note
	description: "Constants for test case serialization"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ITP_TEST_CASE_SERIALIZATION_CONSTANTS

feature -- Constants

	test_case_tag_start: STRING = "<test_case>"
	test_case_tag_end: STRING = "</test_case>"

	time_tag_start: STRING = "<time>"
	time_tag_end: STRING = "</time>"

	class_tag_start: STRING = "<class>"
	class_tag_end: STRING = "</class>"

	code_tag_start: STRING = "<code>"
	code_tag_end: STRING = "</code>"

	operands_tag_start: STRING = "<operands>"
	operands_tag_end: STRING = "</operands>"

	all_variables_tag_start: STRING = "<all_variables>"
	all_variables_tag_end: STRING = "</all_variables>"

	trace_tag_start: STRING = "<trace>"
	trace_tag_end: STRING = "</trace>"

	hash_code_tag_start: STRING = "<hash_code>"
	hash_code_tag_end: STRING = "</hash_code>"

	pre_serialization_length_tag_start: STRING = "<pre_serialization_length>"
	pre_serialization_length_tag_end: STRING = "</pre_serialization_length>"

	pre_serialization_tag_start: STRING = "<pre_serialization>"
	pre_serialization_tag_end: STRING = "</pre_serialization>"

	pre_state_tag_start: STRING = "<pre_state>"
	pre_state_tag_end: STRING = "</pre_state>"

	post_state_tag_start: STRING = "<post_state>"
	post_state_tag_end: STRING = "</post_state>"

	CDATA_tag_start: STRING = "<![CDATA["
	CDATA_tag_end: STRING = "]]>"

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
