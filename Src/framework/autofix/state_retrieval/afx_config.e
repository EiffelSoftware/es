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

	state_test_case_class_c: detachable CLASS_C
			-- CLASS_C for `state_test_case_class'
			-- Void if no such class exists.
		local
			l_classes: LIST [CLASS_I]
		do
			if state_test_case_class /= Void then
				l_classes := universe.classes_with_name (state_test_case_class)
				if not l_classes.is_empty then
					Result := l_classes.first.compiled_representation
				end
			end
		end

	state_feature_under_test: STRING
			-- Name of the feature under test, used for state retrieval
		do
			if state_feature_under_test_cache = Void then
				Result := once "generated_test_1"
			else
				Result := state_feature_under_test_cache
			end
		end

	state_feature_i_under_test: detachable FEATURE_I
			-- FEATURE_I for `state_feature_under_test',
			-- Void if no such feature exists.
		local
			l_class: detachable CLASS_C
		do
			l_class := state_test_case_class_c
			if l_class /= Void then
				Result := l_class.feature_named (state_feature_under_test)
			end
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

	state_feature_under_test_cache: detachable STRING
			-- Cache `state_feature_under_test'

	should_retrieve_state_cache: BOOLEAN
			-- Cache for `should_retrieve_state'

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

end
