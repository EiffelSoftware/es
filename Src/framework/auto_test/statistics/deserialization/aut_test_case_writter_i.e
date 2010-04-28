note
	description: "Summary description for {AUT_TEST_CASE_WRITTER_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_TEST_CASE_WRITTER_I

inherit

	AUT_FILE_SYSTEM_ROUTINES

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
			l_dir: DIRECTORY
			l_file_name: FILE_NAME
			l_file: KL_TEXT_OUTPUT_FILE
			l_class_content: STRING
		do
			is_successful := True

			-- Prepare test case directory.
--			update_uuid
			create l_file_name.make_from_string (a_dir_name)
			l_file_name.set_subdirectory (tc_class_under_test)
			l_file_name.set_subdirectory (tc_feature_under_test + "__" + tc_directory_postfix)
			recursive_create_directory (l_file_name.string)

			-- Create test case file.
			l_file_name.set_file_name (tc_class_name)
			l_file_name.add_extension (tc_name_extension)
			create l_file.make (l_file_name)

			-- Write test case.
			l_file.recursive_open_write
			if not l_file.is_open_write then
				is_successful := False
			else
				l_class_content := tc_class_content
				l_file.put_string (l_class_content)
				l_file.close
			end
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
			l_class_str.replace_substring_all (ph_feature_name, tc_feature_name)
			l_class_str.replace_substring_all (ph_generation_type, tc_generation_type)
			l_class_str.replace_substring_all (ph_summary, tc_summary)
			l_all_var_dec := tc_all_variable_declaration
			l_class_str.replace_substring_all (ph_var_declaration, l_all_var_dec)
			l_class_str.replace_substring_all (ph_body, tc_body)
			l_class_str.replace_substring_all (ph_trace, tc_trace)
			l_class_str.replace_substring_all (ph_pre_serialization, tc_pre_serialization)
			l_class_str.replace_substring_all (ph_post_serialization, tc_post_serialization)

			-- Extra information.
			l_class_str.replace_substring_all (ph_class_under_test, tc_class_under_test)
			l_class_str.replace_substring_all (ph_feature_under_test, tc_feature_under_test)
			l_class_str.replace_substring_all (ph_code, tc_code)
			l_oper_dec := tc_operands_declaration
			l_oper_dec.prune_all ('%R')
			l_oper_dec.replace_substring_all ("%N", "$")
			l_class_str.replace_substring_all (ph_operands_declaration_in_one_line, l_oper_dec)
			l_var_dec := tc_variables_declaration
			l_var_dec.prune_all ('%R')
			l_var_dec.replace_substring_all ("%N", "$")
			l_class_str.replace_substring_all (ph_var_declaration_in_one_line, l_var_dec)
			l_class_str.replace_substring_all (ph_hash_code, tc_hash_code)
			l_class_str.replace_substring_all (ph_pre_state, tc_pre_state)
			l_class_str.replace_substring_all (ph_post_state, tc_post_state)

			Result := l_class_str
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

	tc_post_serialization: STRING
			-- Serialization data of operands after test.
		deferred
		end

	tc_uuid: STRING
			-- UUID string.
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
	ph_recipient: STRING = "$(RECIPIENT)"
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

	tc_class_name_template: STRING = "TC__$(CLASS_UNDER_TEST)__$(FEATURE_UNDER_TEST)__$(STATUS)__$(EXCEPTION_CODE)__$(BREAKPOINT_INDEX)__$(RECIPIENT)__$(ASSERTION_TAG)__$(HASH_CODE)__$(UUID)"
	tc_var_initialization_template: STRING = "$(VAR) ?= pre_operands_table[$(INDEX)]%N"
	tc_class_template: STRING = "[
class $(CLASS_NAME)

inherit
    EQA_SERIALIZED_TEST_SET

create
	generated_test_1

feature -- Test routines

    $(FEATURE_NAME)
        note
            testing: "$(GENERATION_TYPE)"
            testing: "$(SUMMARY)"
        local
$(VAR_DECLARATION)
        do
$(BODY)
        end
        
feature{NONE} -- Serialization data

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
    		Result := <<
--<post_serialization>
$(POST_SERIALIZATION)
--</post_serialization>
			>>
		end
		
feature{NONE} -- Test case information

	tci_class_under_test: STRING = "$(CLASS_UNDER_TEST)"
			-- Name of the class under test.

	tci_feature_under_test: STRING = "$(FEATURE_UNDER_TEST)"
			-- Name of the feature under test.

    tci_exception_trace: STRING =
			-- Exception trace.
--<exception_trace>
$(TRACE)
--</exception_trace>

feature{NONE} -- Implementation

note
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

end
		]"

	start_extra_information_tag: STRING = "<extra_information>"
	finish_extra_information_tag: STRING = "</extra_information>"

	start_exception_trace_tag: STRING = "<exception_trace>"
	finish_exception_trace_tag: STRING = "</exception_trace>"

	start_pre_object_tag: STRING = "<pre_serialization>"
	finish_pre_object_tag: STRING = "</pre_serialization>"

	start_post_object_tag: STRING = "<post_serialization>"
	finish_post_object_tag: STRING = "</post_serialization>"

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
