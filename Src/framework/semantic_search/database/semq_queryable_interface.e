note
	description: "[
		This class includes columns in the Queryables table in the database schema for semantic search system.
		Include this class in your system so that expressions mentioning columns in the Queryables table can be parsed and
		type-checked using the standard Eiffel compiler API.
		
		Do not use for other purposes
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_QUERYABLE_INTERFACE

feature -- Access

	qry_id: INTEGER
			-- For `qry_id' column

	qry_kind: INTEGER
			-- For `qry_kind' column

	class_: STRING
			-- For `class' column
			-- We added a suffix "_" because "class" is a keyword in Eiffel.

	feature_: STRING
			-- For `feature" column
			-- We added a suffix "_" because "feature" is a keyword in Eiffel.

	library: STRING
			-- For `library' column

	transition_status: INTEGER
			-- For `transition_status' column

	hit_breakpoints: STRING
			-- For `hit_breakpoints' column

	timestamp: STRING
			-- For timestamp' column

	uuid: STRING
			-- For `uuid' column

	is_creation: BOOLEAN
			-- For `is_creation' column

	is_query: BOOLEAN
			-- For `is_query' column

	argument_count: INTEGER
			-- For `argument_count' column

	pre_serialization: STRING
			-- For `pre_serialization' column

	pre_serialization_info: STRING
			-- For `pre_serialization_info' column

	post_serialization: STRING
			-- For `post_serialization' column

	post_serialization_info: STRING
			-- For `post_serialization_info' column

	exception_recipient: STRING
			-- For `exception_recipient' column

	exception_class: STRING
			-- For `exception_class' column

	exception_breakpoint: INTEGER
			-- For `exception_breakpoint' column

	exception_code: INTEGER
			-- For `exception_code' column

	exception_meaning: STRING
			-- For `exception_meaning' column

	exception_tag: STRING
			-- For `exception_tag' column

	exception_trace: STRING
			-- For `exception_trace' column

	fault_signature: STRING
			-- For `fault_signature' column

	feature_kind: INTEGER
			-- For `feature_kind' column

	operand_count: INTEGER
			-- For `operand_count' column

	content: STRING
			-- For `content' column

	test_case_name: STRING
			-- For `test_case_name' column

	breakpoint_number: INTEGER
			-- For `breakpoint_number' column

	first_body_breakpoint: INTEGER
			-- For `first_body_breakpoint' column

	pre_bounded_functions: STRING
			-- For `pre_bounded_functions' column

	post_bounded_functions: STRING
			-- For `post_bounded_functions' column

end
