indexing
	description:
		"[
			Interface to use the verification system.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EVE_PROOFS

inherit {NONE}

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	EB_SHARED_MANAGERS
		export {NONE} all end

	EV_SHARED_APPLICATION
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make is
			-- Initialize object.
		local
			l_error: EP_GENERAL_ERROR
		do
			if {PLATFORM}.is_windows then
				create verifier.make
			else
				create l_error.make (names.error_unsupported_platform)
				l_error.set_description (names.description_unsupported_platform)
				errors.extend (l_error)
			end
			create boogie_generator.make
			create {LINKED_LIST [!CLASS_C]} classes_to_verify.make
		ensure
			supporting_windows: {PLATFORM}.is_windows implies is_ready
		end

feature -- Access

	classes_to_verify: !LIST [!CLASS_C]
			-- Classes which will be verified

feature -- Status report

	is_ready: BOOLEAN
			-- Is ready for verification?
		do
			Result := verifier /= Void
		end

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

feature -- Basic operations

	reset
			-- Reset the classes and feature.
		do
			classes_to_verify.wipe_out
			errors.wipe_out
			warnings.wipe_out
		ensure
			no_classes_to_verify: classes_to_verify.is_empty
		end

	execute_verification
			-- Execute verification on added classes.
		require
			class_added: not classes_to_verify.is_empty
			ready: is_ready
		local
			l_current_class: !CLASS_C
		do
			output_manager.clear
			show_messages (names.message_eve_proofs_started, names.window_message_eve_proofs_started)

				-- Prepare environment for new verification
			set_up_environment

				-- Add background theory
			verifier.add_file_content (background_theory_file_name)

				-- Generate Boogie code for classes
			show_messages (names.message_generating_boogie_code, names.window_message_eve_proofs_started)
			from
				classes_to_verify.start
			until
				classes_to_verify.after
			loop
				l_current_class := classes_to_verify.item

					-- Generate Boogie code of class
					-- First check if class is ignored due to an indexing clause
				if verify_value_in_indexing (l_current_class.ast.internal_top_indexes) then
					show_messages (
						names.message_generating_boogie_code_for_class (l_current_class.name_in_upper),
						names.window_message_generating_boogie_code_for_class (l_current_class.name_in_upper))
					generate_boogie_code (l_current_class)
				else
					show_messages (
						names.message_generating_boogie_class_ignored (l_current_class.name_in_upper),
						names.window_message_generating_boogie_code_for_class (l_current_class.name_in_upper))
				end

				classes_to_verify.forth
			end

				-- Generate Boogie code for referenced features
			show_messages (names.message_generating_referenced_features, names.window_message_generating_referenced_features)
			generate_code_for_referenced_features

			if errors.is_empty then
					-- Start Boogie
				show_messages(names.message_starting_verifier, names.message_verifier_running)
				verifier.verify
				show_messages (names.message_verification_finished, names.message_verification_finished)
			else
				show_messages (names.message_code_generation_failed, names.message_code_generation_failed)
			end
		end

feature {NONE} -- Implementation

	boogie_generator: EP_GENERATOR
			-- Generator used to generate Boogie code

	verifier: EP_VERIFIER
			-- Verifier used to run Boogie

	show_messages (l_output_line, l_status_bar: STRING)
			-- Show `l_output_line' in output window and `l_status_bar' in status bar.
		do
			output_manager.add_string (l_output_line)
			output_manager.add_new_line
			output_manager.end_processing
			window_manager.display_message (l_status_bar)
			ev_application.process_events
		end

	set_up_environment
			-- Set up environment for a new verification session.
		do
			feature_list.reset
			boogie_generator.reset
			verifier.reset
		end

	generate_boogie_code (a_class: !CLASS_C)
			-- Generate Boogie code for `a_class'.
		local
			l_name: !STRING
		do
			boogie_generator.reset
			boogie_generator.generate_implementation

			boogie_generator.process_class (a_class)

			l_name := "Class: "
			l_name.append (a_class.name_in_upper)
			verifier.add_buffer_content (boogie_generator.output_buffer, l_name)
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
				boogie_generator.process_creation_routine (l_list.first)
			end

				-- Generate code for normal features
			from
				l_list := feature_list.features_needed
			until
				l_list.is_empty
			loop
				boogie_generator.process_feature (l_list.first)
			end

			verifier.add_buffer_content (boogie_generator.output_buffer, "Referenced features")
		end


-- TODO: move file someplace else
	background_theory_file_name: !STRING is
			-- File to include for the background theory
		local
			ee: EXECUTION_ENVIRONMENT
		once
			create ee
			Result ?= ee.get("EIFFEL_SRC") + "/eve_proofs/eve_proofs_theory.bpl"
		end

end
