indexing
	description: "[
			Objects that run test cases and print testing result
			to console. Descendants of this class should be used
			as the root class of some target.
		]"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_ABSTRACT_INTERPRETER

inherit

	CDD_REQUEST_PARSER

	EXCEPTIONS
		export
			{NONE} all
		end

	EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

feature {NONE} -- Execution

	execute is
			-- If command line arguments are provided, only execute
			-- test cases matching these arguments. Otherwise
			-- execute all test cases in `test_cases'.
		do
			make
			main_loop
		end

	main_loop is
			-- Wait for requests on standard input. If request
			-- is received, parse it.
		local
			l_input: STRING
		do
			from
			until
				should_quit or io.input.end_of_file
			loop
				io.input.read_line
				l_input := io.input.last_string
				if l_input = Void then
					print_and_flush ("error: empty input%N")
				else
					set_input (l_input)
					parse
				end
			end
		end

feature -- Access

	test_setting: HASH_TABLE [TUPLE [instance: CDD_ABSTRACT_TEST_CASE; test_features: HASH_TABLE [PROCEDURE [CDD_ABSTRACT_TEST_CASE, TUPLE [CDD_ABSTRACT_TEST_CASE]], STRING]], STRING] is
			-- Main data structure containing an instance of all
			-- classes representing a test case. Each instance comes
			-- with a number of procedures pointing to actual test
			-- features within the class. The operand of the
			-- procedure is the instance of the test class
			-- containing the test feature.
		deferred
		ensure
			not_void: Result /= Void
			valid_items: not Result.has (Void)
		end

	test_class_names: ARRAY [STRING] is
			-- Names of all test classes
		local
			i: INTEGER
		do
			create Result.make (1, test_setting.count)
			from
				test_setting.start
				i := 1
			until
				test_setting.off
			loop
				Result.put (test_setting.key_for_iteration, i)
				test_setting.forth
				i := i + 1
			end
		ensure
			names_not_void: Result /= Void
			names_doesnt_have_void: not Result.has (Void)
		end

	test_feature_names (a_class_name: STRING): ARRAY [STRING] is
			-- Feature names of all test features in class `a_class_name'
		require
			a_class_name_valid: a_class_name /= Void and then has_test_class (a_class_name)
		local
			i: INTEGER
			l_test_features: HASH_TABLE [PROCEDURE [CDD_ABSTRACT_TEST_CASE, TUPLE [CDD_ABSTRACT_TEST_CASE]], STRING]
		do
			l_test_features := test_setting.item (a_class_name).test_features
			create Result.make (1, l_test_features.count)
			from
				l_test_features.start
				i := 1
			until
				l_test_features.off
			loop
				Result.put (l_test_features.key_for_iteration, i)
				l_test_features.forth
				i := i + 1
			end
		ensure
			features_not_void: Result /= Void
			features_doesnt_have_void: not Result.has (Void)
		end

	has_test_class (a_class_name: STRING): BOOLEAN is
			-- Does `test_setting' contain a test class named `a_class_name'?
		require
			a_class_name_not_void: a_class_name /= Void
		do
			Result := test_setting.has (a_class_name)
		ensure
			correct_result: Result = test_setting.has (a_class_name)
		end

	has_test_feature (a_class_name, a_feature_name: STRING): BOOLEAN is
			-- Does `test_setting' contain a test feature named
			-- `a_feature_name' in class `a_class_name'?
		require
			a_class_name_valid: a_class_name /= Void and then has_test_class (a_class_name)
			a_feature_name_not_void: a_feature_name /= Void
		do
			Result := test_setting.item (a_class_name).test_features.has (a_feature_name)
		ensure
			correct_result: Result = test_setting.item (a_class_name).test_features.has (a_feature_name)
		end

	test_case (a_class_name: STRING): CDD_ABSTRACT_TEST_CASE is
			-- Instance of `a_class_name'
		require
			a_class_name_valid: a_class_name /= Void and then has_test_class (a_class_name)
		do
			Result := test_setting.item (a_class_name).instance
		ensure
			valid_result: Result /= Void and then Result = test_setting.item (a_class_name).instance
		end

	test_feature (a_class_name, a_feature_name: STRING): PROCEDURE [CDD_ABSTRACT_TEST_CASE, TUPLE [CDD_ABSTRACT_TEST_CASE]] is
			-- Procedure calling `a_feature_name' in class `a_class_name'
		require
			a_class_name_valid: a_class_name /= Void and then has_test_class (a_class_name)
			a_feature_name_valid: a_feature_name /= Void and then has_test_feature (a_class_name, a_feature_name)
		do
			Result := test_setting.item (a_class_name).test_features.item (a_feature_name)
		ensure
			valid_result: Result /= Void and then
				Result = test_setting.item (a_class_name).test_features.item (a_feature_name)
		end

feature {NONE} -- Request handling

	report_quit_request is
			-- Set `should_quit' to True.
		do
			should_quit := True
		end

	report_list_test_classes_request is
			-- Print a list of all test cases and their test features.
		local
			l_cursor: DS_BILINEAR_CURSOR [STRING]
		do
			test_class_names.do_all (agent report_list_of_class_request)
		end

	report_list_of_class_request (a_class_name: STRING) is
			-- Print a list of all test features in class `a_class_name'.
		do
			print ("Test cases for " + a_class_name + ":%N")
			test_feature_names (a_class_name).do_all (
				agent (a_test_feature_name: STRING)
					do
						print ("%T" + a_test_feature_name + "%N")
					end)
		end

	report_execute_all_test_routines_request is
			-- Execute all tests in all test cases.
		do
			-- TODO: implement
			check
				todo: False
			end
		end

	report_execute_test_class_request (a_class_name: STRING) is
			-- Execute all tests found in class `a_class_name'.
		do
			if not has_test_class (a_class_name) then
				report_and_set_error ("`" + a_class_name + "' is not a valid class name.")
			else
				test_feature_names (a_class_name).do_all (agent execute_test (a_class_name, ?))
			end
		end

	report_execute_test_routine_request (a_class_name, a_feature_name: STRING) is
			-- Execute test feature `a_feature_name' in class `a_class_name'.
			-- If `a_class_name' does not contain such a feature, print error message.
		do
			if not has_test_class (a_class_name) then
				report_and_set_error ("`" + a_class_name + "' is not a valid class name.")
			elseif not has_test_feature (a_class_name, a_feature_name) then
				report_error (a_class_name + " does not contain a test feature `" + a_feature_name + "'")
			else
				execute_test (a_class_name, a_feature_name)
			end
		end

feature {NONE} -- Error handling

	report_error (a_reason: STRING) is
			-- Report error `a_reason'.
		do
			print_and_flush ("error: " + a_reason + "%N")
		end

feature {NONE} -- Control

	should_quit: BOOLEAN
			-- Should main loop quit?

feature {NONE} -- Implementation

	execute_test (a_tc_name, a_feature_name: STRING) is
			-- Set up `a_tc' and call `a_feature' with `a_tc' as operand.
			-- Print results on standard out refering to `a_tc_name' and
			-- `a_feature_name'.
		require
			a_tc_name_valid: a_tc_name /= Void and then has_test_class (a_tc_name)
			a_feature_name_valid: a_feature_name /= Void and then has_test_feature (a_tc_name, a_feature_name)
		local
			l_tc: CDD_ABSTRACT_TEST_CASE
			l_tr: PROCEDURE [CDD_ABSTRACT_TEST_CASE, TUPLE [CDD_ABSTRACT_TEST_CASE]]
		do
			l_tc := test_case (a_tc_name)
			execute_protected (agent l_tc.set_up)
			if last_protected_execution_successfull then
				l_tr := test_feature (a_tc_name, a_feature_name)
				l_tr.set_operands ([l_tc])
				execute_protected (l_tr)
				execute_protected (agent l_tc.tear_down)
			end
			print_line_and_flush ("done:")
		end

	execute_protected (procedure: PROCEDURE [ANY, TUPLE]) is
			-- Execute `procedure' in a protected way.
		local
			failed: BOOLEAN
			l_exception: INTEGER
			l_recipient_name: STRING
			l_class_name: STRING
			l_tag_name: STRING
			l_meaning: STRING
			l_exception_trace: STRING
		do
			last_protected_execution_successfull := False
			if not failed then
				print_multi_line_value_start_tag
				procedure.apply
				print_multi_line_value_end_tag
				print_and_flush ("status: success%N")
				last_protected_execution_successfull := True
			end
		rescue
			failed := True
			print_multi_line_value_end_tag
			l_exception := exception
			l_tag_name := tag_name
			l_recipient_name := recipient_name
			l_class_name := class_name
			l_meaning := meaning (l_exception)
			l_exception_trace := exception_trace

			if l_recipient_name = Void then
				l_recipient_name := ""
			end
			check
				l_class_name_not_void: l_class_name /= Void
			end
			if l_tag_name = Void then
				l_tag_name := ""
			end
			if l_meaning = Void then
				l_meaning := ""
			end
			print_line_and_flush ("status: exception")
			print_line_and_flush (l_exception.out)
			print_line_and_flush (l_recipient_name)
			print_line_and_flush (l_class_name)
			print_multi_line_value_start_tag
			print_line_and_flush (l_tag_name)
			print_multi_line_value_end_tag
			print_multi_line_value_start_tag
			print_line_and_flush (l_exception_trace)
			print_multi_line_value_end_tag
			retry
		end

	last_protected_execution_successfull: BOOLEAN
			-- Was the last protected execution successfull?
			-- (i.e. did it not trigger an exception)

feature {NONE} -- Output

	print_and_flush (a_text: STRING) is
			-- Print `a_text' and flush output stream.
		require
			a_text_not_void: a_text /= Void
		do
			print (a_text)
			io.output.flush
		end

	print_line_and_flush (a_text: STRING) is
			-- Print `a_text' followed by a newline and flush output stream.
		require
			a_text_not_void: a_text /= Void
		do
			print (a_text)
			io.output.put_new_line
			io.output.flush
		end

	print_multi_line_value_start_tag is
			-- Print the start tag for a multi line value.
		do
			print_and_flush (multi_line_value_start_tag)
			print_and_flush ("%N")
		end

	print_multi_line_value_end_tag is
			-- Print the start tag for a multi line value.
		do
			print_and_flush (multi_line_value_end_tag)
			print_and_flush ("%N")
		end

feature {NONE} -- Constants

	multi_line_value_start_tag: STRING is "---multi-line-value-start---"
			-- Multi line start tag

	multi_line_value_end_tag: STRING is "---multi-line-value-end---"
			-- Multi line end tag

end
