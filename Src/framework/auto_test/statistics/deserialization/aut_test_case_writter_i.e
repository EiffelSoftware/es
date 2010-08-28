note
	description: "Summary description for {AUT_TEST_CASE_WRITTER_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_TEST_CASE_WRITTER_I

inherit

	AUT_FILE_SYSTEM_ROUTINES

feature -- Access

	error_handler: UT_ERROR_HANDLER
			-- Current AutoTest Session.
		deferred
		end

feature -- Status report

	is_successful: BOOLEAN
			-- Is last writting successful?

feature -- Operation

	write_to (a_dir_name: STRING)
			-- Write a test case class into the given directory.
			-- Create the file system structure as: $a_dir_name$\class_name\feature_name\tc_class.e
		require
			directory_exists: True -- the directory exists.
		local
			l_retried: BOOLEAN
			l_name: STRING
			l_dir: DIRECTORY
			l_file_name: FILE_NAME
			l_file: KL_TEXT_OUTPUT_FILE
			l_class_content: STRING
			l_length: INTEGER
		do
			if not l_retried then
				is_successful := True

				l_class_content := tc_class_content

				if not l_class_content.is_empty then
					-- Prepare test case directory.
					prepare_directory (a_dir_name)
					-- Create test case file.
					l_name := tc_class_full_path (a_dir_name)

--io.put_string ("Writing to file: ")
--io.put_string (l_name)
--io.put_string ("...")

					create l_file.make (l_name)
					-- Write test case.
					l_file.recursive_open_write
					if not l_file.is_open_write then
						is_successful := False
--io.put_string ("Failed.%N")
					else
						l_file.put_string (l_class_content)
						l_file.close
--io.put_string ("Done.%N")
					end
				end
			end
		rescue
			l_retried := True

			-- Delete incomplete class files.
			if l_file /= Void and then l_file.is_open_write then
				l_file.close
				l_file.delete
			end

			retry
		end

feature{NONE} -- Construction

	tc_class_content: STRING
			-- Construct a test case class, with its name in 'name' and content in 'content'.
		local
			l_class_str: STRING
			l_oper_dec: STRING
			l_var_dec: STRING
			l_all_var_dec: STRING
		do
			-- Class body.
			l_class_str := tc_class_template.twin
			l_class_str.replace_substring_all (ph_class_name, tc_class_name)
			l_class_str.replace_substring_all (ph_uuid, tc_uuid)
			l_class_str.replace_substring_all (ph_feature_name, tc_feature_name)
			l_class_str.replace_substring_all (ph_generation_type, tc_generation_type)
			l_class_str.replace_substring_all (ph_summary, tc_summary)
			l_all_var_dec := tc_all_variable_declaration
			l_class_str.replace_substring_all (ph_var_declaration, l_all_var_dec)
			l_class_str.replace_substring_all (ph_body, tc_body)
			l_class_str.replace_substring_all (ph_is_creation, tc_is_creation.out)
			l_class_str.replace_substring_all (ph_is_query, tc_is_query.out)
			l_class_str.replace_substring_all (ph_is_passing, tc_is_passing.out)
			l_class_str.replace_substring_all (ph_exception_code, tc_exception_code.out)
			l_class_str.replace_substring_all (ph_breakpoint_index, tc_breakpoint_index.out)
			l_class_str.replace_substring_all (ph_exception_recipient, tc_exception_recipient)
			l_class_str.replace_substring_all (ph_exception_recipient_class, tc_exception_recipient_class)
			l_class_str.replace_substring_all (ph_assertion_tag, tc_assertion_tag)
			l_class_str.replace_substring_all (ph_argument_count, tc_argument_count.out)
			l_class_str.replace_substring_all (ph_operand_table_initializer, tc_operand_table_initializer)
			l_class_str.replace_substring_all (ph_trace, tc_trace)
			l_class_str.replace_substring_all (ph_pre_serialization, tc_pre_serialization)
--			l_class_str.replace_substring_all (ph_post_serialization, tc_post_serialization)
			l_class_str.replace_substring_all (ph_pre_object_info, tc_pre_object_info)
			l_class_str.replace_substring_all (ph_post_object_info, tc_post_object_info)

			-- Extra information.
			l_class_str.replace_substring_all (ph_start_block_string, start_block_string)
			l_class_str.replace_substring_all (ph_finish_block_string, finish_block_string)
			l_class_str.replace_substring_all (ph_class_under_test, tc_class_under_test)
			l_class_str.replace_substring_all (ph_feature_under_test, tc_feature_under_test)
			l_class_str.replace_substring_all (ph_code, tc_code)
			l_oper_dec := tc_operands_declaration
			l_oper_dec.prune_all ('%R')
			l_oper_dec.prune_all ('%T')
			l_oper_dec.replace_substring_all ("%N", "$")
			l_class_str.replace_substring_all (ph_operands_declaration_in_one_line, l_oper_dec)
			l_var_dec := tc_variables_declaration
			l_var_dec.prune_all ('%R')
			l_var_dec.prune_all ('%T')
			l_var_dec.replace_substring_all ("%N", "$")
			l_class_str.replace_substring_all (ph_var_declaration_in_one_line, l_var_dec)
			l_class_str.replace_substring_all (ph_hash_code, tc_hash_code)
			l_class_str.replace_substring_all (ph_pre_state, tc_pre_state)
			l_class_str.replace_substring_all (ph_post_state, tc_post_state)

			Result := l_class_str
		end

	prepare_directory (a_dir_name: STRING)
			-- Prepare the directory where the class will be saved.
		deferred
		end

	tc_class_full_path (a_dir_name: STRING): STRING
			-- Full path of the test case file.
		deferred
		end

	tc_is_query: BOOLEAN
			-- Is the feature under test a query?
		deferred
		end

    tc_is_creation: BOOLEAN
            -- Is the feature under test a creation feature?
        deferred
        end

    tc_is_passing: BOOLEAN
            -- Is the test case passing?
        deferred
        end

    tc_exception_code: INTEGER
            -- Exception code. 0 for passing test cases.
        deferred
        end

	tc_breakpoint_index: INTEGER
			-- Breakpoint index where the test case fails.
		deferred
		end

    tc_assertion_tag: STRING
			-- Tag of the violated assertion, if any.
			-- Empty string for passing test cases.
        deferred
        end

	tc_exception_recipient: STRING
			-- Feature of the exception recipient, same as `tc_feature_under_test' in passing test cases.
        deferred
        end

	tc_exception_recipient_class: STRING
			-- Class of the recipient feature of the exception, same as `tc_class_under_test' in passing test cases.
        deferred
        end

	tc_argument_count: INTEGER
			-- Number of arguments of the feature under test.
        deferred
        end

    tc_operand_table_initializer: STRING
            -- Code to initialize the operand table.
        deferred
        end

    tc_directory_postfix: STRING
			-- Due to the practical limitation on number of files in one directory,
			-- We might need to store the test cases for a feature into several directories.
			-- This postfix string is introduced for this purpose. It is calculated for each test case,
			-- and appended to the directory name.
		deferred
		end

	tc_class_under_test: STRING
			-- Name of the class under test.
		deferred
		end

	tc_feature_under_test: STRING
			-- Name of the feature under test.
		deferred
		end

	tc_code: STRING
			-- Code under test.
			-- Variables are referred to by their original names.
		deferred
		end

	tc_success_status: STRING
			-- Status of the feature execution, whether it is successful or failing.
			-- Possible value: "S" or "F"
		deferred
		end

	tc_class_name: STRING
			-- Get test case class name.
		deferred
		end

	tc_summary: STRING
			-- Test case summary.
		deferred
		end

	tc_all_variable_declaration: STRING
			-- Variable declarations for the test case feature.
		deferred
		end

	tc_operands_declaration: STRING
			-- Variable declaration for operands used in the test case.
		deferred
		end

	tc_variables_declaration: STRING
			-- Declaration for variables reachable from the operands.
		deferred
		end

	tc_body: STRING
			-- Test case routine body.
		deferred
		end

	tc_pre_state: STRING
			-- State report before test.
		deferred
		end

	tc_post_state: STRING
			-- State report after test.
		deferred
		end

	tc_trace: STRING
			-- Trace from the failing test case.
		deferred
		end

	tc_hash_code: STRING
			-- Hashcode from serialization data.
		deferred
		end

	tc_pre_serialization: STRING
			-- Serialization data of operands before test.
		deferred
		end

--	tc_post_serialization: STRING
--			-- Serialization data of operands after test.
--		deferred
--		end

	tc_uuid: STRING
			-- UUID string.
		deferred
		end

	tc_pre_object_info: STRING
			-- String representing for objects in current test case in pre-state
		deferred
		end

	tc_post_object_info: STRING
			-- String representing for objects in current test case in post-state
		deferred
		end

feature{NONE} -- Construction cache

	uuid_generator: UUID_GENERATOR
			-- UUID generator
		once
			create Result
		end

feature{NONE} -- Constants

	ph_class_name: STRING = "$(CLASS_NAME)"
	ph_feature_name: STRING = "$(FEATURE_NAME)"
	ph_success_status: STRING = "$(STATUS)"
	ph_exception_code: STRING = "$(EXCEPTION_CODE)"
	ph_breakpoint_index: STRING = "$(BREAKPOINT_INDEX)"
	ph_assertion_tag: STRING = "$(ASSERTION_TAG)"
	ph_hash_code: STRING = "$(HASH_CODE)"
	ph_uuid: STRING = "$(UUID)"
	ph_generation_type: STRING = "$(GENERATION_TYPE)"
	ph_summary: STRING = "$(SUMMARY)"
	ph_var_declaration: STRING = "$(VAR_DECLARATION)"
	ph_body: STRING = "$(BODY)"
	ph_trace: STRING = "$(TRACE)"
	ph_pre_serialization: STRING = "$(PRE_SERIALIZATION)"
	ph_post_serialization: STRING = "$(POST_SERIALIZATION)"
	ph_is_creation: STRING = "$(IS_CREATION)"
	ph_is_query: STRING = "$(IS_QUERY)"
	ph_is_passing: STRING = "$(IS_PASSING)"
	ph_exception_recipient: STRING = "$(EXCEPTION_RECIPIENT)"
	ph_exception_recipient_class: STRING = "$(EXCEPTION_RECIPIENT_CLASS)"
	ph_argument_count: STRING = "$(ARGUMENT_COUNT)"
	ph_operand_table_initializer: STRING = "$(OPERAND_TABLE_INITIALIZER)"
	ph_operand_index: STRING = "$(OPERAND_INDEX)"
	ph_var_index: STRING = "$(VAR_INDEX)"
	ph_start_block_string: STRING = "$(START_BLOCK_STRING)"
	ph_finish_block_string: STRING = "$(FINISH_BLOCK_STRING)"
	ph_pre_object_info: STRING = "$(PRE_OBJECT_INFO)"
	ph_post_object_info: STRING = "$(POST_OBJECT_INFO)"


	ph_class_under_test: STRING = "$(CLASS_UNDER_TEST)"
	ph_feature_under_test: STRING = "$(FEATURE_UNDER_TEST)"
	ph_code: STRING = "$(CODE)"
	ph_operands_declaration_in_one_line: STRING = "$(OPERANDS_DECLARATION_IN_ONE_LINE)"
	ph_var_declaration_in_one_line: STRING = "$(VAR_DECLARATION_IN_ONE_LINE)"
	ph_pre_state: STRING = "$(PRE_STATE)"
	ph_post_state: STRING = "$(POST_STATE)"

	tc_name_extension: STRING = "e"
	tc_feature_name: STRING = "generated_test_1"
	tc_generation_type: STRING = "AutoTest test case extracted from serialization"

	tc_class_name_template: STRING = "TC__$(CLASS_UNDER_TEST)__$(FEATURE_UNDER_TEST)__$(STATUS)__c$(EXCEPTION_CODE)__b$(BREAKPOINT_INDEX)__REC_$(EXCEPTION_RECIPIENT_CLASS)__$(EXCEPTION_RECIPIENT)__TAG_$(ASSERTION_TAG)__$(HASH_CODE)__$(UUID)"
	tc_var_initialization_template: STRING = "$(VAR) ?= pre_variable_table[$(INDEX)]%N"
	tc_operand_table_initializer_template: STRING = "%T%T%TResult.put ($(VAR_INDEX),$(OPERAND_INDEX))"

	tc_class_template: STRING = "[
class 
	$(CLASS_NAME)

inherit
    EQA_SERIALIZED_TEST_SET
	
feature -- Test routine

    $(FEATURE_NAME)
        note
            testing: "$(GENERATION_TYPE)"
            testing: "$(SUMMARY)"
        local
$(VAR_DECLARATION)
        do
$(BODY)
        end
        
feature -- Test case information

	tci_class_name: STRING do Result := "$(CLASS_NAME)" end
			-- Name of current class.
			
	tci_class_uuid: STRING do Result := "$(UUID)" end
			-- UUID of current test case.

	tci_class_under_test: STRING do Result := "$(CLASS_UNDER_TEST)" end
			-- Name of the class under test.

	tci_feature_under_test: STRING do Result := "$(FEATURE_UNDER_TEST)" end
			-- Name of the feature under test.
			
	tci_pre_object_info: STRING do Result := "$(PRE_OBJECT_INFO)" end
			-- Information about objects in current test case in pre-state
			-- Format: TYPE_1;position1;TYPE_2;position2;...;TYPE_n;position_n.

	tci_post_object_info: STRING do Result := "$(POST_OBJECT_INFO)" end
			-- Information about objects in current test case in post-state
			-- Format: TYPE_1;position1;TYPE_2;position2;...;TYPE_n;position_n.
			
	tci_is_creation: BOOLEAN = $(IS_CREATION)
			-- Is the feature under test a creation feature?

	tci_is_query: BOOLEAN = $(IS_QUERY)
			-- Is the feature under test a query?
	
	tci_is_passing: BOOLEAN = $(IS_PASSING)
			-- Is the test case passing?
	
	tci_exception_code: INTEGER = $(EXCEPTION_CODE)
			-- Exception code. 0 for passing test cases.
	
	tci_breakpoint_index: INTEGER = $(BREAKPOINT_INDEX)
			-- Index of the breakpoint where the test case fails inside `tci_class_under_test'.`tci_feature_under_test'.
			
	tci_assertion_tag: STRING do Result := "$(ASSERTION_TAG)" end
			-- Tag of the violated assertion, if any.
			-- Empty string for passing test cases.
	
	tci_exception_recipient_class: STRING do Result := "$(EXCEPTION_RECIPIENT_CLASS)" end
			-- Class of the recipient feature of the exception, same as `tci_class_under_test' in passing test cases.
	
	tci_exception_recipient: STRING do Result := "$(EXCEPTION_RECIPIENT)" end
			-- Feature of the exception recipient, same as `tci_feature_under_test' in passing test cases.
	
    tci_exception_trace: STRING =
			-- Exception trace.
--<exception_trace>
$(TRACE)
--</exception_trace>

	tci_argument_count: INTEGER = $(ARGUMENT_COUNT)
			-- Number of arguments of the feature under test.
	
	tci_operand_table: HASH_TABLE[INTEGER, INTEGER]
			-- key is operand position index (0 means target, 1 means the first argument, 
			-- and argument_count + 1 means the result, if any), value is the variable 
			-- index of that operand.
		do
			create Result.make ($(ARGUMENT_COUNT) + 2)
$(OPERAND_TABLE_INITIALIZER)
		end

feature -- Serialization data

    pre_serialization: ARRAY [NATURAL_8]
            -- Serialized test case data before the transition.
        do
            Result := <<
--<pre_serialization>
$(PRE_SERIALIZATION) 
--</pre_serialization>
>>
        end
        
    post_serialization: ARRAY [NATURAL_8]
    		-- Serialized test case data after the transition.
    	do
    		if is_post_state_information_enabled then
    			Result := post_serialization_cache
    		else
    			create Result.make (1, 0)
    		end
		end

feature{NONE} -- Implementation

	post_serialization_cache: detachable like post_serialization
			-- Cache for `post_serialization'

;note
  extra_information: 
$(START_BLOCK_STRING)
--<extra_information>
--<class_under_test>$(CLASS_UNDER_TEST)</class_under_test>
--<feature_under_test>$(FEATURE_UNDER_TEST)</feature_under_test>
--<code>$(CODE)</code>
--<operands_declaration>$(OPERANDS_DECLARATION_IN_ONE_LINE)</operands_declaration>
--<variable_declaration>$(VAR_DECLARATION_IN_ONE_LINE)</variable_declaration>
--<hash_code>$(HASH_CODE)</hash_code>
--<pre_state>
$(PRE_STATE)
--</pre_state>
--<post_state>
$(POST_STATE)
--</post_state>
--</extra_information>
$(FINISH_BLOCK_STRING)
end
		]"

	start_block_string: STRING = "%"["
	finish_block_string: STRING = "]%""

	start_extra_information_tag: STRING = "<extra_information>"
	finish_extra_information_tag: STRING = "</extra_information>"

	start_exception_trace_tag: STRING = "<exception_trace>"
	finish_exception_trace_tag: STRING = "</exception_trace>"

	start_pre_object_tag: STRING = "<pre_serialization>"
	finish_pre_object_tag: STRING = "</pre_serialization>"

--	start_post_object_tag: STRING = "<post_serialization>"
--	finish_post_object_tag: STRING = "</post_serialization>"

	start_class_under_test_tag: STRING = "<class_under_test>"
	finish_class_under_test_tag: STRING = "</class_under_test>"

	start_feature_under_test_tag: STRING = "<feature_under_test>"
	finish_feature_under_test_tag: STRING = "</feature_under_test>"

	start_operands_declaration_tag: STRING = "<operands_declaration>"
	finish_operands_declaration_tag: STRING = "</operands_declaration>"

	start_variable_declaration_tag: STRING = "<variable_declaration>"
	finish_variable_declaration_tag: STRING = "</variable_declaration>"

	start_hashcode_tag: STRING = "<hash_code>"
	finish_hashcode_tag: STRING = "</hash_code>"

	start_pre_state_report_tag: STRING = "<pre_state>"
	finish_pre_state_report_tag: STRING = "</pre_state>"

	start_post_state_report_tag: STRING = "<post_state>"
	finish_post_state_report_tag: STRING = "</post_state>"


note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
