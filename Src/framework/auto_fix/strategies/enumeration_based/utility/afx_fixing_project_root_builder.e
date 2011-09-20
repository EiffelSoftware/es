note
	description: "Summary description for {AFX_FIXING_PROJECT_ROOT_BUILDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIXING_PROJECT_ROOT_BUILDER

inherit
	AFX_UTILITY
		undefine
			system
		end

	AFX_SHARED_SESSION

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER
		undefine
			system
		end

	EQA_TEST_EXECUTION_MODE

	REFACTORING_HELPER

create
	make, make_with_test_cases

feature{NONE} -- Initialization

	make (a_system: like system; a_config: like config;
				a_failing_test_cases: HASH_TABLE [ARRAYED_LIST [STRING], EPA_TEST_CASE_SIGNATURE];
				a_passing_test_cases: ARRAYED_LIST [STRING])
			-- Initialization.
		do
--			system := a_system
--			config := a_config
--			failing_test_cases := a_failing_test_cases
--			passing_test_cases := a_passing_test_cases
		end

	make_with_test_cases (a_system: like system; a_failing_test_cases, a_passing_test_cases: DS_ARRAYED_LIST [STRING];
					a_fault_signature: EPA_TEST_CASE_SIGNATURE)
			-- Initialization.
		do
			system := a_system
			current_failing_test_cases := a_failing_test_cases
			current_passing_test_cases := a_passing_test_cases
			current_fault_signature := a_fault_signature
		end

feature -- Access

	system: SYSTEM_I
			-- System under which test cases are analyzed

--	config: AFX_CONFIG
--			-- Config for AutoFix

	current_fault_signature: EPA_TEST_CASE_SIGNATURE
			-- Signature of the fault under fix.

	current_failing_test_cases: DS_ARRAYED_LIST [STRING]
			-- List of failing test case files for fixing.

	current_passing_test_cases: DS_ARRAYED_LIST [STRING]
			-- List of passing test case files for fixing.

--	failing_test_cases: HASH_TABLE [ARRAYED_LIST [STRING], EPA_TEST_CASE_SIGNATURE]
--			-- Table of failing test cases.
--			-- Key: {EPA_TEST_CASE_INFO}.`id' describing a failure senario;
--			-- Value: List of test cases revealing the same fault.

--	passing_test_cases: ARRAYED_LIST [STRING]
--			-- List of passing test cases from `test_case_folder'.

	last_class_text: detachable STRING
			-- Class text from last building.

	test_cases: LINKED_LIST [TUPLE [agent_name: STRING; uuid: STRING]]
			-- List of test cases. `agent_name' is the name of an agent to invoke a test case,
			-- `uuid' is the universal identifier for that test case.

feature -- Basic operation

	build
			-- Build the class text for the root class in `system'.
			-- The class text is available in `last_class_text'.
		local
			l_root_class_name: STRING
			l_executor: STRING
		do
			l_root_class_name := system.root_type.associated_class.name.twin
			create test_cases.make

			create l_executor.make (4096 * 4)
				-- Note that one failing test case is added TWICE to the executor.
				-- The first execution is to reproduce the failure, and the second for dynamic analysis.
			append_test_to_executor (l_executor, current_failing_test_cases.first, current_fault_signature, False, Mode_execute)
			current_failing_test_cases.do_all (agent append_test_to_executor (l_executor, ?, current_fault_signature, False, Mode_monitor))

			current_passing_test_cases.do_all (agent append_test_to_executor (l_executor, ?, current_fault_signature, True, Mode_monitor))

			last_class_text := Root_class_body_template.twin
			last_class_text.replace_substring_all ("${CLASS_NAME}", l_root_class_name)
			last_class_text.replace_substring_all ("${INITIALIZE_TEST_CASES}", feature_for_initialize_test_cases (test_cases))
			last_class_text.replace_substring_all ("${FIRST_FAILING_TEST_CASE_UUID}", feature_for_first_test_case_uuid)
			last_class_text.replace_substring_all ("${EXECUTE_TEST_CASES}", feature_for_execute_test_cases)
--			last_class_text.replace_substring_all ("${RETRIEVE_OPERAND_STATES}", feature_for_operand_states (current_fault_signature.recipient_, current_fault_signature.recipient_class_))
			last_class_text.replace_substring_all ("${TEST_CASES}", l_executor)
		end

feature{NONE} -- Auxiliary operation

	append_test_to_executor (a_executor: STRING; a_test_class_name: STRING; a_test: EPA_TEST_CASE_SIGNATURE; a_passing: BOOLEAN; a_execution_mode: INTEGER)
			-- Append the execution command of the test with its name 'a_test_class_name' to the execution string 'a_executor'.
			-- The way this test is executed depends on the execution mode given by 'a_execution_mode'.
		local
			l_test_executor: STRING
			l_slices: LIST [STRING]
		do
			l_test_executor := Execute_test_case_feature_template.twin
			l_test_executor.replace_substring_all ("${TEST_CASE_INDEX}", test_case_index.out)
			l_test_executor.replace_substring_all ("${TEST_CASE_CLASS_NAME}", a_test_class_name)
			l_test_executor.replace_substring_all ("${EXECUTION_MODE}", a_execution_mode.out)

			a_executor.append (l_test_executor)
			a_executor.append ("%N%N")

			if a_execution_mode = Mode_monitor then
				l_slices := string_slices (a_test_class_name, "__")
				test_cases.extend (["execute_test_case_" + test_case_index.out, l_slices.last])
			end

			test_case_index := test_case_index + 1
		end

	feature_for_initialize_test_cases (a_test_cases: like test_cases): STRING
			-- Feature text for `initialize_test_cases', which setup test cases from `a_test_cases'.
		do
			create Result.make (2048)
			Result.append ("%Tinitialize_test_cases%N")
			Result.append ("%T%T%T-- Initialize `test_cases'.%N")
			Result.append ("%T%Tdo%N")
			Result.append ("%T%T%Tcreate test_cases.make (" + a_test_cases.count.out + ")%N")
			Result.append ("%T%T%Ttest_cases.compare_objects%N")
			from
				a_test_cases.start
			until
				a_test_cases.after
			loop
				Result.append ("%T%T%Ttest_cases.extend (agent ")
				Result.append (a_test_cases.item_for_iteration.agent_name)
				Result.append (", %"")
				Result.append (a_test_cases.item_for_iteration.uuid)
				Result.append ("%")%N")
				a_test_cases.forth
			end

			Result.append ("%T%Tend%N")
		end

	feature_for_execute_test_cases: STRING
			-- Feature text for `execute_test_cases'.
		do
			create Result.make (1024)
			Result.append ("%Texecute_test_cases%N")
			Result.append ("%T%T%T--Execute test cases.%N")
			Result.append ("%T%Tdo%N")
			Result.append ("%T%T%Texecute_test_case_0%N")
			from
				test_cases.start
			until
				test_cases.after
			loop
				Result.append ("%T%T%T")
				Result.append (test_cases.item_for_iteration.agent_name)
				Result.append ("%N")
				test_cases.forth
			end
			Result.append ("%T%Tend%N")
		end

	feature_for_first_test_case_uuid: STRING
			-- Feature text to return the UUID of the first failing test case from `a_failing_test_cases'
		local
			l_cursor: CURSOR
			l_uuid: STRING
			l_signature: EPA_TEST_CASE_SIGNATURE
		do
--			l_cursor := a_failing_test_cases.cursor
--			a_failing_test_cases.start
--			l_uuid := a_failing_test_cases.key_for_iteration.uuid
--			a_failing_test_cases.go_to (l_cursor)

			create l_signature.make_with_string (current_failing_test_cases.first)
			check same_uuid: l_signature.uuid ~ current_fault_signature.uuid end
			l_uuid := current_fault_signature.uuid

			Result := First_failing_test_case_uuid_feature_template.twin
			Result.replace_substring_all ("${UUID}", l_uuid)
		end

feature{NONE} -- State retrieval

--	feature_for_operand_states (a_feature: FEATURE_I; a_context_class: CLASS_C): STRING
--			-- Implementation of feature {AFX_INTERPRETER}.`operand_states'.
--			-- NOT IMPLEMENTED YET.
--		do
--			fixme ("Do we still need to look at the operands in random fixing?")
--			create Result.make (512)
--			Result.append ("%Toperand_states (a_operands: SPECIAL [detachable ANY]):  like state_type%N")
--			Result.append ("%T%Tlocal%N")
--			Result.append ("%T%Tdo%N")
--			Result.append ("%T%Tend%N")
--		end

feature{NONE} -- Implementation

	test_case_index: INTEGER
			-- Index of the NEXT test case executor.

feature{NONE} -- Root class template

	Root_class_body_template: STRING =
	"[
class
	${CLASS_NAME}
	
inherit
	AFX_INTERPRETER
	
create
	make
		
		
feature{NONE} -- Implementation

${INITIALIZE_TEST_CASES}

${FIRST_FAILING_TEST_CASE_UUID}

${EXECUTE_TEST_CASES}

feature{NONE} -- Implementation

${TEST_CASES}

end

	]"

	First_failing_test_case_uuid_feature_template: STRING = "%Tfirst_failing_test_case_uuid: STRING = %"${UUID}%"%N%N"

	Execute_test_case_feature_template: STRING =
	"[
		execute_test_case_${TEST_CASE_INDEX}
			local
				l_tc: ${TEST_CASE_CLASS_NAME}
				l_retried: BOOLEAN
			do
				if not l_retried then
					create l_tc
					l_tc.set_execution_mode (${EXECUTION_MODE})
					l_tc.generated_test_1
				end
			rescue
				exception_count := exception_count + 1
				l_retried := True
				retry
			end
	]"

end
