note
	description: "Summary description for {SEMQ_TABLE_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_TABLE_CONSTANTS

feature -- Queryables table

	queryables_qry_id: STRING = "qry_id"
	queryables_qry_kind: STRING = "qry_kind"
	queryables_class: STRING = "class"
	queryables_feature: STRING = "feature"
	queryables_library: STRING = "library"
	queryables_transition_status: STRING = "transition_status"
	queryables_hit_breakpoints: STRING = "hit_breakpoints"
	queryables_timestamp: STRING = "timestamp"
	queryables_uuid: STRING = "uuid"
	queryables_is_creation: STRING = "is_creation"
	queryables_is_query: STRING = "is_query"
	queryables_argument_count: STRING = "argument_count"
	queryables_pre_serialization: STRING = "pre_serialization"
	queryables_pre_serialization_info: STRING = "pre_serialization_info"
	queryables_post_serialization: STRING = "post_serialization"
	queryables_post_serialization_info: STRING = "post_serialization_info"
	queryables_exception_recipient: STRING = "exception_recipient"
	queryables_exception_class: STRING = "exception_class"
	queryables_exception_breakpoint: STRING = "exception_breakpoint"
	queryables_exception_code: STRING = "exception_code"
	queryables_exception_meaning: STRING = "exception_meaning"
	queryables_exception_tag: STRING = "exception_tag"
	queryables_exception_trace: STRING = "exception_trace"
	queryables_fault_signature: STRING = "exception_fault_signature"
	queryables_feature_kind: STRING = "feature_kind"
	queryables_operand_count: STRING = "operand_count"
	queryables_content: STRING = "content"
	queryables_test_case_name: STRING = "test_case_name"
	queryables_breakpoint_number: STRING = "breakpoint_number"
	queryables_first_body_breakpoint: STRING = "first_body_breakpoint"
	queryables_pre_bounded_functions: STRING = "pre_bounded_functions"
	queryables_post_bounded_functions: STRING = "post_bounded_functions"

	properties_text: STRING = "text"
	properties_value_type_kind: STRING = "value_type_kind"
	properties_value: STRING = "value"
	properties_equal_value: STRING = "equal_value"
	properties_var_prefix: STRING = "var"

end
