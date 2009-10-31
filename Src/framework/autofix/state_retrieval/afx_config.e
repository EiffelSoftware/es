note
	description: "Summary description for {AFX_CONFIG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CONFIG

inherit
	SHARED_WORKBENCH

	SHARED_EXEC_ENVIRONMENT

create
	make

feature{NONE} -- Initialization

	make (a_system: like eiffel_system)
			-- Initialize `eiffel_system' with `a_system'.
		do
			eiffel_system := a_system
		ensure
			eiffel_system_set: eiffel_system = a_system
		end

feature -- Access

	eiffel_system: SYSTEM_I
			-- Current system

	working_directory: STRING is
			-- Working directory of the project
		do
			if working_directory_cache = Void then
				Result := Execution_environment.current_working_directory
			else
				Result := working_directory_cache
			end
		end

	state_output_file: STRING is
			-- Full path of the output file
		do
			if state_output_file_cache = Void then
				Result := once "state_log.txt"
			else
				Result := state_output_file_cache
			end
		end

	state_test_case_class: STRING
			-- Name of the test case class used for state retrieval
		do
			if state_test_case_class_cache = Void then
				Result := test_case_class_name
			else
				Result := state_test_case_class_cache
			end
		end

	state_class_under_test: detachable CLASS_C
			-- CLASS_C for `state_test_case_class'
			-- Void if no such class exists.
		do
			if state_test_case_class_cache = Void then
				calculate_recipient
			end
			Result := state_class_under_test_cache
		end

	state_feature_under_test: detachable FEATURE_I
			-- FEATURE_I for `state_feature_under_test',
			-- Void if no such feature exists.
		do
			if state_test_case_class_cache = Void then
				calculate_recipient
			end
			Result := state_feature_under_test_cache
		end

	output_directory: STRING is
			-- Directory for output
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (eiffel_system.eiffel_project.project_directory.testing_results_path)
			l_path.extend ("auto_fix")
		end

feature -- Status report

	should_retrieve_state: BOOLEAN
			-- Should state of the system be retrieved?
		do
			Result := should_retrieve_state_cache
		ensure
			result_set: Result = should_retrieve_state_cache
		end

feature -- Setting

	set_should_retrieve_state (b: BOOLEAN)
			-- Set `should_retrieve_state' with `b'.
		do
			should_retrieve_state_cache := b
		ensure
			should_retrieve_state_set: should_retrieve_state = b
		end

feature{NONE} -- Implementation

	working_directory_cache: detachable STRING
			-- Cache for working_directory

	state_output_file_cache: detachable STRING
			-- Cache for `state_output_file'

	state_test_case_class_cache: detachable STRING
			-- Cache for `state_test_case_class'

	should_retrieve_state_cache: BOOLEAN
			-- Cache for `should_retrieve_state'

	state_class_under_test_cache: like state_class_under_test
			-- Cache for `state_class_c_under_test'

	state_feature_under_test_cache: like state_feature_under_test
			-- Cache for `state_feature_under_test'

	test_case_class_name: STRING is
			-- Name of the test case class
		local
			l_classes: CLASS_C_SERVER
			i: INTEGER
			n: INTEGER
			l_done: BOOLEAN
			l_class: CLASS_C
		do
			l_classes := eiffel_system.classes
			i := l_classes.lower
			n := l_classes.count

			from
				Result := ""
			until
				i = n or else not Result.is_empty
			loop
				l_class := l_classes.item (i)
				if l_class.name.starts_with (once "TC__") then
					Result := l_class.name.twin
				end
				i := i + 1
			end
		end

	calculate_recipient is
			-- Calculate recipient feature and its associated class.
		local
			l_classes: LIST [CLASS_I]
			l_tc_class: CLASS_C
			l_class_name: STRING
			l_index: INTEGER
			l_index2: INTEGER
			l_index3: INTEGER
			l_recipient_class: STRING
			l_recipient_feature: STRING
		do
			if state_test_case_class_cache = Void then
				l_classes := universe.classes_with_name (state_test_case_class)
				if not l_classes.is_empty then
					l_tc_class := l_classes.first.compiled_representation
					l_class_name := l_tc_class.name
					l_index := l_class_name.substring_index (once "__REC_", 1)
					if l_index > 0 then
						l_index2 := l_class_name.substring_index (once "__", l_index + 6)
						l_index3 := l_class_name.substring_index (once "__", l_index2 + 2)
						l_recipient_class := l_class_name.substring (l_index + 6, l_index2 - 1)
						l_recipient_feature := l_class_name.substring (l_index2 + 2, l_index3 - 1)
						state_class_under_test_cache := universe.classes_with_name (l_recipient_class).first.compiled_representation
						state_feature_under_test_cache := state_class_under_test_cache.feature_named (l_recipient_feature.as_lower)
					end
				end
			end
		end

end
