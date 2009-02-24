indexing
	description:
		"[
			Interface to use the verification system.
			TODO: store the outcome of the verification, so others can access it (e.g. for testing integration)
		]"
	date: "$Date$"
	revision: "$Revision$"

class EVE_PROOFS

inherit

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	EIFFEL_LAYOUT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make is
			-- Initialize object.
		do
			create verifier.make
			create boogie_generator.make
			create pure_marker.make
			create {LINKED_LIST [!CLASS_C]} classes_to_verify.make
		end

feature -- Access

	classes_to_verify: !LIST [!CLASS_C]
			-- Classes which will be verified

feature -- Element change

	add_class_to_verify (a_class: !CLASS_C)
			-- Add `a_class' to `classes_to_verify'.
		require
			a_class_not_yet_added: not classes_to_verify.has (a_class)
			a_class_is_eiffel_class: a_class.is_eiffel_class_c
		do
			classes_to_verify.extend (a_class)
		ensure
			a_class_added: classes_to_verify.has (a_class)
		end

	register_message_callbacks (a_output, a_window: PROCEDURE [ANY, TUPLE [STRING]])
			-- Register callback functions to receive messages.
		do
			output_callback := a_output
			window_callback := a_window
		end

feature -- Basic operations

	reset
			-- Reset classes to verify.
		do
			classes_to_verify.wipe_out
		ensure
			no_classes_to_verify: classes_to_verify.is_empty
		end

	execute_verification
			-- Execute verification on added classes.
		require
			class_added: not classes_to_verify.is_empty
		local
			l_current_class: !CLASS_C
		do
			put_output_message (names.message_eve_proofs_started)
			put_window_message (names.message_eve_proofs_started)

				-- Prepare environment for new verification
			set_up_environment

				-- Add background theory
			verifier.add_file_content (background_theory_file_name)

				-- Generate Boogie code for classes
			put_output_message (names.message_generating_boogie_code)
			from
				classes_to_verify.start
			until
				classes_to_verify.after
			loop
				l_current_class := classes_to_verify.item

					-- Generate Boogie code of class
					-- First check if class is ignored due to an indexing clause
				put_window_message (names.message_generating_boogie_code_for_class (l_current_class.name_in_upper))
				if is_class_proof_done (l_current_class) then
					generate_boogie_code (l_current_class)
				else
					event_handler.add_proof_skipped_event (l_current_class, Void, "indexing value")
				end

				classes_to_verify.forth
			end

				-- Generate Boogie code for referenced features
			put_window_message (names.message_generating_referenced_features)
			generate_code_for_referenced_features

			if errors.is_empty then
					-- Start Boogie
				put_output_message (names.message_boogie_running)
				put_window_message (names.message_boogie_running)
				verifier.verify
			else
				put_output_message (names.message_code_generation_failed)
				put_window_message (names.message_code_generation_failed)
			end
			put_output_message (names.message_eve_proofs_finished)
			put_window_message (names.message_eve_proofs_finished)
		end

	put_output_message (a_string: STRING)
			-- Put `a_string' to output.
		do
			if output_callback /= Void then
				output_callback.call ([a_string])
			end
		end

	put_window_message (a_string: STRING)
			-- Put `a_string' to status bar.
		do
			if window_callback /= Void then
				window_callback.call ([a_string])
			end
		end

feature {NONE} -- Implementation

	boogie_generator: !EP_BOOGIE_CODE_GENERATOR
			-- Generator used to generate Boogie code

	verifier: !EP_BOOGIE_VERIFIER
			-- Verifier used to run Boogie

	pure_marker: !EP_PURE_MARKER
			-- Marker to preprocess classes and find pure features

	output_callback: PROCEDURE [ANY, TUPLE [STRING]]
			-- Callback function for output panel

	window_callback: PROCEDURE [ANY, TUPLE [STRING]]
			-- Callback function for status bar

	set_up_environment
			-- Set up environment for a new verification session.
		do
			errors.wipe_out
			warnings.wipe_out
			event_handler.clear_events
			feature_list.reset
			boogie_generator.reset
			verifier.reset
		end

	generate_boogie_code (a_class: !CLASS_C)
			-- Generate Boogie code for `a_class'.
		local
			l_name: !STRING
		do
			pure_marker.traverse_class (a_class)

			boogie_generator.reset
			boogie_generator.generate_implementation

			boogie_generator.process_class (a_class)

			l_name := "Class: "
			l_name.append (a_class.name_in_upper)
			verifier.add_buffer_content (boogie_generator.output, l_name)
		end

	generate_code_for_referenced_features
			-- Generate Boogie code for all referenced features.
		local
			l_list: !LIST [!FEATURE_I]
		do
			boogie_generator.reset
			boogie_generator.omit_implementation

				-- Generate code for creation routines
			from
				l_list := feature_list.creation_routines_needed
			until
				l_list.is_empty
			loop
				-- TODO: do this different
				pure_marker.traverse_feature (l_list.first)

				boogie_generator.process_creation_routine (l_list.first)
			end

				-- Generate code for normal features
			from
				l_list := feature_list.features_needed
			until
				l_list.is_empty
			loop
				-- TODO: do this different
				pure_marker.traverse_feature (l_list.first)

				boogie_generator.process_feature (l_list.first)
			end

			verifier.add_buffer_content (boogie_generator.output, "Referenced features")
		end


-- TODO: move file someplace else
-- TODO: this should go into the Delivery somewhere...
	background_theory_file_name: !STRING is
			-- File to include for the background theory
		local
			l_path: DIRECTORY_NAME
			l_file_name: FILE_NAME
			l_file: RAW_FILE
			ee: EXECUTION_ENVIRONMENT
		once
			l_path := eiffel_layout.shared_application_path
			l_path.extend ("tools")
			l_path.extend ("eve_proofs")
			create l_file_name.make
			l_file_name.set_directory (l_path.string)
			l_file_name.set_file_name ("eve_proofs_theory.bpl")
			create l_file.make (l_file_name.string)
			if l_file.exists then
				if {l_result: STRING} l_file_name.string then
					Result := l_result
				end
			else
				create ee
				if {l_result2: STRING} (ee.get("EIFFEL_SRC") + "/framework/eve_proofs/eve_proofs_theory.bpl") then
					Result := l_result2
				end
			end
		end

end
