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
		do
			if {PLATFORM}.is_windows then
				create verifier.make
--				create {BOOGIE_WINDOWS_EXEC}verifier.make
			else
--				add_error (create {BPL_ERROR}.make("unsupported system for Ballet"))
			end
			create boogie_generator.make
			create {LINKED_LIST [!CLASS_C]} classes_to_verify.make
			is_file_per_class_generated := False
		ensure
			supporting_windows: {PLATFORM}.is_windows implies is_ready
		end

feature -- Access

	classes_to_verify: !LIST [!CLASS_C]
			-- Classes which will be verified

feature -- Status report

	is_ready: BOOLEAN
			-- Is Ballet ready for verification?
		do
			Result := verifier /= Void
		end

	is_file_per_class_generated: BOOLEAN
			-- Is a single file generated per verified class?

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
			show_messages ("Ballet started", "Ballet started")

				-- Prepare environment for new verification
			set_up_environment

				-- Add background theory
			verifier.add_file_content (background_theory_file_name)

				-- Generate Boogie code for classes
			show_messages ("Generating Boogie code for:", "Generating Boogie code")
			from
				classes_to_verify.start
			until
				classes_to_verify.after
			loop
				l_current_class := classes_to_verify.item

					-- Print byte nodes of class for debugging
				print_byte_nodes (l_current_class)

					-- Generate Boogie code of class
					-- First check if class is ignored due to an indexing clause
				if verify_value_in_indexing (l_current_class.ast.internal_top_indexes) then
					show_messages (" - Class " + l_current_class.name_in_upper, "Generating Boogie code: " + l_current_class.name_in_upper)
					generate_boogie_code (l_current_class)
				else
					show_messages (" - Class " + l_current_class.name_in_upper + " (ignored due to indexing clause)", "Generating Boogie code")
				end

				classes_to_verify.forth
			end

				-- Generate Boogie code for referenced features
			show_messages(" - Referenced features", "Generating Boogie code: Referenced features")
			generate_code_for_referenced_features

				-- Start Boogie
			show_messages("Starting verifier", "Running verifier")
			verifier.verify

				-- React on errors
			-- TODO
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

	print_byte_nodes (a_class: !CLASS_C)
			-- Print byte node tree for debugging.
		do
			-- TODO
		end

	generate_boogie_code (a_class: !CLASS_C)
			-- Generate Boogie code for `a_class'.
		local
			l_content, l_name: !STRING
		do
			boogie_generator.reset
			boogie_generator.process_class (a_class)

			l_content ?= boogie_generator.output_buffer.string
			l_name ?= "Class: " + a_class.name_in_upper
			verifier.add_string_content (l_content, l_name)
		end

	generate_code_for_referenced_features
			-- Generate Boogie code for all referenced features.
		local
			l_list: !LIST [!FEATURE_I]
			l_content: !STRING
		do
			boogie_generator.reset

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

			l_content ?= boogie_generator.output_buffer.string
			verifier.add_string_content (l_content, "Referenced features")
		end


-- TODO: move file someplace else
	background_theory_file_name: !STRING is
			-- File to include for the background theory
		local
			ee: EXECUTION_ENVIRONMENT
		once
			create ee
			Result ?= ee.get("EIFFEL_SRC") + "/ballet/background_theory.bpl"
		end

end
