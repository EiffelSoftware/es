note
	description: "Summary description for {AUT_SERIALIZED_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_DESERIALIZED_TEST_CASE

inherit

	AUT_TEST_CASE_SUMMARIZATION
		rename
			make as make_summarization
		redefine
			hash_code, is_equal
		end

create
	make

feature -- Initialization

	make (a_class_name, a_code, a_operands, a_variables, a_trace, a_hash_code, a_pre_state, a_post_state, a_time: STRING;
				a_pre_serialization: ARRAY [NATURAL_8])
			-- Initialization.
		local
			l_string: STRING
			l_start: INTEGER
		do
			make_summarization (a_class_name, a_code, a_operands, a_variables, a_trace, a_pre_state, a_post_state, a_time)
			pre_serialization := a_pre_serialization
				-- Parse the `hash_code' part from "CLASS_NAME.feature_name.hash_code" and save it into `hash_code_str'.
			hash_code_str := a_hash_code.substring (a_hash_code.last_index_of ('.', a_hash_code.count) + 1, a_hash_code.count)

			update_uuid
			gather_exception_related_information
			build_test_case_class_name
		end

feature -- Access

	tc_class_under_test: STRING
			-- Class name of the feature under test.
		do
			Result := class_name_str
		end

	tc_feature_under_test: STRING
			-- Name of the feature under test.
		do
			Result := feature_.feature_name_32
		end

	class_and_feature_under_test: STRING
			-- Feature under test, with context class.
			-- In the format of 'class_name.feature_name'.
		do
			Result := tc_class_under_test.twin
			Result.append (once ".")
			Result.append (tc_feature_under_test)
		end

	exception_signature: STRING
			-- Signature of the exception of the last test case.

	test_case_class_name: STRING
			-- Name of the test case class from the last build.

	test_case_text: STRING
			-- The class text for the test case.
		local
			l_builder: AUT_TEST_CASE_TEXT_BUILDER
		do
			if test_case_text_cache = Void then
				l_builder := test_case_text_builder
				l_builder.generate_test_case_text (Current)
				if l_builder.is_last_generation_successful then
					test_case_text_cache := l_builder.last_test_case_text
				else
					test_case_text_cache := ""
				end
			end
			Result := test_case_text_cache
		end

	tc_uuid: STRING
			-- UUID for a test case class.

	hash_code_str: STRING
			-- Hash code of the test case.

	pre_serialization: ARRAY [NATURAL_8]
			-- Serialized objects before testing.

feature{AUT_TEST_CASE_TEXT_BUILDER} -- Direct information

	tc_argument_count: INTEGER
			-- Count of arguments of the routine under test.
		do
			Result := test_case.argument_count
        end

	tc_code: STRING
			-- Code executed by the interpreter.
		do
			Result := code_str.twin
		end

	tc_is_query: BOOLEAN
			-- Is the feature under test a query?
		do
			Result := is_feature_query
		end

	tc_is_function: BOOLEAN
			-- Is the feature under test a function?
		do
			Result := feature_.is_function
		end

	tc_is_attribute: BOOLEAN
			-- Is the feature under test an attribute?
		do
			Result := feature_.is_attribute
		end

    tc_is_creation: BOOLEAN
            -- Is the feature under test a creation routine?
        do
        	Result := is_feature_creation
        end

    tc_is_passing: BOOLEAN
            -- Is the test case passing?
        do
        	Result := is_execution_successful
        end

	tc_success_status: STRING
			-- Success status.
		do
			if tc_is_passing then
				Result := "S"
			else
				Result := "F"
			end
		end

	tc_pre_state: STRING
			-- Pre-state of operands.
		do
			Result := pre_state_str.twin
		end

	tc_post_state: STRING
			-- Post-state of operands.
		do
			Result := post_state_str.twin
		end

	tc_trace: STRING
			-- Exception trace.
		do
			Result := "%"[%N" + trace_str + "%N]%""
		end

	tc_hash_code: STRING
			-- <Precursor>
		do
			Result := hash_code_str
		end

feature{AUT_TEST_CASE_TEXT_BUILDER} -- Exception related

	tc_exception_code: INTEGER
			-- Code of the exception.
			-- 0 for passing test cases.

	tc_breakpoint_index: INTEGER
			-- Breakpoint index of the exception.
			-- 0 for passing test cases.

	tc_assertion_tag: STRING
			-- Tag of the violated assertion.
			-- "noname" for passing test cases.

	tc_exception_recipient: STRING
			-- Feature name of the exception recipient.
			-- Name of the feature under test for passing test cases.

	tc_exception_recipient_class: STRING
			-- Class name of the exception recipient.
			-- Name of the class under test for passing test cases.

feature{NONE} -- UUID

	update_uuid
			-- Get a new uuid string from `uuid_generator',
			-- the new uuid is available in `tc_uuid'.
		do
			tc_uuid := uuid_generator.generate_uuid.out
			tc_uuid.prune_all ('-')
		end

feature -- Redefinition

	hash_code: INTEGER
			-- <Precursor>
		do
			Result := hash_code_str.to_integer
		end

	is_equal (a_other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := class_and_feature_under_test ~ a_other.class_and_feature_under_test
					and then a_other.exception_signature ~ exception_signature
					and then a_other.hash_code_str ~ hash_code_str
		end

feature{NONE} -- Implementation

	gather_exception_related_information
			-- Gather exception related information from the exception trace, if any.
		require
			trace_attached: trace_str /= Void
		local
			l_trace: STRING
			l_explainer: EPA_EXCEPTION_TRACE_EXPLAINER
			l_summary: EPA_EXCEPTION_TRACE_SUMMARY
		do
				-- Default values for exception related information.
			tc_exception_code := 0
			tc_breakpoint_index := 0
			tc_assertion_tag := "noname"
			tc_exception_recipient := tc_feature_under_test
			tc_exception_recipient_class := tc_class_under_test

			l_trace := trace_str
			if not l_trace.is_empty then
				create l_explainer
				l_explainer.explain (l_trace)

				if l_explainer.was_successful and then l_explainer.last_explanation.is_exception_supported then
						-- Only test cases with supported exception types will be extracted.
					l_summary := l_explainer.last_explanation
					tc_exception_code := l_summary.exception_code
					tc_breakpoint_index := l_summary.failing_position_breakpoint_index
					tc_assertion_tag := l_summary.failing_assertion_tag.twin
					tc_exception_recipient := l_summary.recipient_feature_name.twin
					tc_exception_recipient_class := l_summary.recipient_context_class_name.twin
				else
					update_summarization_availability (False)
				end
			end

			if is_summarization_available then
				exception_signature := tc_exception_recipient_class.twin + "__" + tc_exception_recipient
							+ "__c" + tc_exception_code.out + "__b" + tc_breakpoint_index.out
			end
		end

	build_test_case_class_name
			-- Build the test case class name into `last_test_case_class_name'.
		local
			l_name: STRING
		do
			create l_name.make (128)
			l_name.copy (tc_class_name_template)
			l_name.replace_substring_all (ph_class_under_test, tc_class_under_test)
			l_name.replace_substring_all (ph_feature_under_test, tc_feature_under_test)
			if tc_is_query then
				if tc_is_function then
					l_name.replace_substring_all (ph_feature_type, ph_function)
				else
					l_name.replace_substring_all (ph_feature_type, ph_attribute)
				end
			else
				l_name.replace_substring_all (ph_feature_type, ph_command)
			end
			l_name.replace_substring_all (ph_success_status, tc_success_status)
			l_name.replace_substring_all (ph_exception_code, tc_exception_code.out)
			l_name.replace_substring_all (ph_breakpoint_index, tc_breakpoint_index.out)
			l_name.replace_substring_all (ph_exception_recipient, tc_exception_recipient)
			l_name.replace_substring_all (ph_exception_recipient_class, tc_exception_recipient_class)
			l_name.replace_substring_all (ph_assertion_tag, tc_assertion_tag)
			l_name.replace_substring_all (ph_hash_code, tc_hash_code.hash_code.out)
			l_name.replace_substring_all (ph_uuid, tc_uuid)
			test_case_class_name := l_name
		end

	test_case_text_builder: AUT_TEST_CASE_TEXT_BUILDER
			-- Test case text builder.
		once
			create Result
		end

	uuid_generator: UUID_GENERATOR
			-- UUID generator
		once
			create Result
		end

	test_case_text_cache: STRING
			-- Cache for `test_case_text'.

feature{NONE} -- Constants

	tc_class_name_template: STRING = "TC__$(CLASS_UNDER_TEST)__$(FEATURE_UNDER_TEST)__$(FEATURE_TYPE)__$(STATUS)__c$(EXCEPTION_CODE)__b$(BREAKPOINT_INDEX)__REC_$(EXCEPTION_RECIPIENT_CLASS)__$(EXCEPTION_RECIPIENT)__TAG_$(ASSERTION_TAG)__$(HASH_CODE)__$(UUID)"

	ph_success_status: STRING = "$(STATUS)"
	ph_exception_code: STRING = "$(EXCEPTION_CODE)"
	ph_breakpoint_index: STRING = "$(BREAKPOINT_INDEX)"
	ph_assertion_tag: STRING = "$(ASSERTION_TAG)"
	ph_hash_code: STRING = "$(HASH_CODE)"
	ph_uuid: STRING = "$(UUID)"
	ph_exception_recipient: STRING = "$(EXCEPTION_RECIPIENT)"
	ph_exception_recipient_class: STRING = "$(EXCEPTION_RECIPIENT_CLASS)"
	ph_class_under_test: STRING = "$(CLASS_UNDER_TEST)"
	ph_feature_under_test: STRING = "$(FEATURE_UNDER_TEST)"
	ph_feature_type: STRING = "$(FEATURE_TYPE)"
	ph_command: STRING = "CMD"
	ph_function: STRING = "FUN"
	ph_attribute: STRING = "ATT"



note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
