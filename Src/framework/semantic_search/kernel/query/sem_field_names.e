note
	description: "Field names used in queryable documents"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_FIELD_NAMES

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

	SEM_CONSTANTS

feature -- Access

	document_type_field: STRING = "document_type"

	class_field: STRING = "class"

	feature_field: STRING = "feature"

	to_field_prefix: STRING = "to::"
	by_field_prefix: STRING = "by::"
	precondition_field_prefix: STRING = "pre::"
	postcondition_field_prefix: STRING = "post::"
	property_field_prefix: STRING = "prop::"

	prefix_separator: STRING = "::"

	changed_field_prefix: STRING = "changed::"

	written_precondition_field_prefix: STRING = "written_pre::"

	written_postcondition_field_prefix: STRING = "written_post::"

	variables_field: STRING = "variables"

	dynamic_variables_field: STRING = "dynamic_variables"

	inputs_field: STRING = "inputs"

	outputs_field: STRING = "outputs"

	locals_field: STRING = "locals"

	variable_types_field: STRING = "variable_types"

	input_types_field: STRING = "input_types"

	output_types_field: STRING = "output_types"

	local_types_field: STRING = "local_types"

	content_field: STRING = "content"

	id_field: STRING = "id"

	uuid_field: STRING = "uuid"

	score_field: STRING = "score"

	export_status_field: STRING = "export_status"

	feature_clause_field: STRING = "feature_clause"

	comment_field: STRING = "comment"

	library_field: STRING = "library"

	serialization_field: STRING = "serialization"

	begin_field: STRING = "begin"

	end_field: STRING = "end"

	variable_position_field: STRING = "variable_position_table"

	prestate_serialization_field: STRING = "prestate_serialization"

	poststate_serialization_field: STRING = "poststate_serialization"

	operand_variable_indexes_field: STRING = "operand_variable_indexes"

	is_feature_under_test_creation_field: STRING = "is_feature_under_test_creation"

	is_feature_under_test_query_field: STRING = "is_feature_under_test_query_field"

	test_feature_field: STRING = "test_feature"

	test_case_class_field: STRING = "test_case_class"

	prestate_bounded_functions_field: STRING = "prestate_bounded_functions"

	poststate_bounded_functions_field: STRING = "poststate_bounded_functions"

	any_value: STRING = "[any_value]"

	feature_type_field: STRING = "feature_type"

	feature_type_command: STRING = "command"

	feature_type_query: STRING = "query"

	is_creation_field: STRING = "is_creation"

	operand_count_field: STRING = "operand_count"

	argument_count_field: STRING = "argument_count"

	test_case_status_field: STRING = "transition_status"

	test_case_status_passing: STRING = "passing"

	test_case_status_failing: STRING = "failing"

	pre_serialization_field: STRING = "pre_serialization"

	pre_object_info_field: STRING = "pre_object_info"

	recipient_field: STRING = "recipient"

	recipient_class_field: STRING = "recipient_class"

	exception_break_point_slot_field: STRING = "exception_break_point_slot"

	exception_code_field: STRING = "exception_code"

	exception_meaning_field: STRING = "exception_meaning"

	exception_trace_field: STRING = "exception_trace"

	exception_tag_field: STRING = "exception_assertion_tag"

	fault_id_field: STRING = "fault_id"

	s_s_arg_field: STRING = "s_s_arg_"
	s_d_arg_field: STRING = "s_d_arg_"
	t_s_arg_field: STRING = "t_s_arg_"
	t_d_arg_field: STRING = "t_d_arg_"
			-- A particular argument variable

	s_s_args_field: STRING = "s_s_args"
	s_d_args_field: STRING = "s_d_args"
	t_s_args_field: STRING = "t_s_args"
	t_d_args_field: STRING = "t_d_args"
			-- Agument variables

	s_s_tgt_field: STRING = "s_s_tgt"
	s_d_tgt_field: STRING = "s_d_tgt"
	t_s_tgt_field: STRING = "t_s_tgt"
	t_d_tgt_field: STRING = "t_d_tgt"
			-- Target variables

	s_s_rlt_field: STRING = "s_s_rlt"
	s_d_rlt_field: STRING = "s_d_rlt"
	t_s_rlt_field: STRING = "t_s_rlt"
	t_d_rlt_field: STRING = "t_d_rlt"
			-- Result variables

	s_s_opd_field: STRING = "s_s_opd"
	s_d_opd_field: STRING = "s_d_opd"
	t_s_opd_field: STRING = "t_s_opd"
	t_d_opd_field: STRING = "t_d_opd"
			-- Operand variables (target + argument)

	s_s_ifc_field: STRING = "s_s_ifc"
	s_d_ifc_field: STRING = "s_d_ifc"
	t_s_ifc_field: STRING = "t_s_ifc"
	t_d_ifc_field: STRING = "t_d_ifc"
			-- Interface variables (target + argument + result)	

	target_varaible_short: STRING = "tgt"
	result_varaible_short: STRING = "rlt"
	argument_variable_short: STRING = "args"
	one_argument_variable_short: STRING = "arg"
	operand_variable_short: STRING = "opd"
	interface_variable_short: STRING = "ifc"

	hit_break_points_field: STRING = "hit_breakpoints"
	timestamp_field: STRING = "timestamp"

	precondition_property_prefix: STRING = "pre"

	postcondition_property_prefix: STRING = "post"

	change_property_prefix: STRING = "ch"

	relative_change_property_prefix: STRING = "by"
	absolute_change_property_prefix: STRING = "to"

	property_field_name: STRING = "property"

	object_property_prefix: STRING = "prop"

	object_info_field: STRING = "object_info"

	variable_field_name: STRING = "variable"

	void_value_id: INTEGER = 32768

	test_case_field: STRING = "test_case_name"

	breakpoint_number_field: STRING = "breakpoint_number"
	first_body_breakpoint_field: STRING = "first_body_breakpoint"

feature -- Access

	serialization_field_array_separator: CHARACTER = ','

	field_name_value_separator: STRING = " : "
			-- Separator to separate field name and field value

	field_value_separator: CHARACTER = ';'
			-- Field value separator

	triple_field_value_separator: STRING = ";;;"
			-- Triple file value separator

	field_section_separator: CHARACTER = '%T'
			-- Field value separator

	default_variable_prefix: STRING = "v_"
			-- Default prefix for variables

feature -- Access

	property_types: HASH_TABLE [INTEGER, STRING]
			-- Property types: Property, Precondition, Postcondition
			--                 Absolute and relative change
			-- The value is the identifier stored in a database
		once
			create Result.make (5)
			Result.put (1, "prop")
			Result.put (2, "pre")
			Result.put (3, "post")
			Result.put (4, "to")
			Result.put (5, "by")
		end

	queryable_types: HASH_TABLE [INTEGER, STRING]
			-- Queryable types: Object, Transition
			-- The value is the identifier stored in a database
		once
			create Result.make (2)
			Result.put (1, "object")
			Result.put (2, "transition")
		end

	queryable_feature_types: HASH_TABLE [INTEGER, STRING]
			-- Queryable types: Object, Transition
			-- The value is the identifier stored in a database
		once
			create Result.make (2)
			Result.put (1, "command")
			Result.put (2, "query")
		end

	queryable_true_false: HASH_TABLE [INTEGER, STRING]
			-- Mapping True to 1 and False to 0
		once
			create Result.make (2)
			Result.put (0, "False")
			Result.put (1, "True")
		end

	queryable_transition_status: HASH_TABLE [INTEGER, STRING]
			-- Transition status for transition field in Queryable
		once
			create Result.make (2)
			Result.put (1, "failing")
			Result.put (2, "passing")
		end

feature -- Access

	begin_field_value: STRING = "begin"
	end_field_value: STRING = "end"

feature -- Access

	field_name_set: DS_HASH_SET [STRING]
			-- Set of field names/prefixes
		once
			create Result.make (25)
			Result.set_equality_tester (string_equality_tester)

			Result.force_last (document_type_field)
			Result.force_last (class_field)
			Result.force_last (feature_field)
			Result.force_last (to_field_prefix)
			Result.force_last (by_field_prefix)
			Result.force_last (changed_field_prefix)
			Result.force_last (precondition_field_prefix)
			Result.force_last (postcondition_field_prefix)
			Result.force_last (written_precondition_field_prefix)
			Result.force_last (written_postcondition_field_prefix)
			Result.force_last (variables_field)
			Result.force_last (inputs_field)
			Result.force_last (outputs_field)
			Result.force_last (locals_field)
			Result.force_last (variable_types_field)
			Result.force_last (input_types_field)
			Result.force_last (output_types_field)
			Result.force_last (local_types_field)
			Result.force_last (content_field)
			Result.force_last (id_field)
			Result.force_last (export_status_field)
			Result.force_last (feature_clause_field)
			Result.force_last (comment_field)
			Result.force_last (library_field)
			Result.force_last (serialization_field)
			Result.force_last (property_field_prefix)
		end

	transition_field_name_set: DS_HASH_SET [STRING]
			-- Set of field names/prefixes that can be used in transition documents.
		once
			create Result.make (25)
			Result.set_equality_tester (string_equality_tester)

			Result.force_last (document_type_field)
			Result.force_last (class_field)
			Result.force_last (feature_field)
			Result.force_last (to_field_prefix)
			Result.force_last (by_field_prefix)
			Result.force_last (changed_field_prefix)
			Result.force_last (precondition_field_prefix)
			Result.force_last (postcondition_field_prefix)
			Result.force_last (written_precondition_field_prefix)
			Result.force_last (written_postcondition_field_prefix)
			Result.force_last (variables_field)
			Result.force_last (inputs_field)
			Result.force_last (outputs_field)
			Result.force_last (locals_field)
			Result.force_last (variable_types_field)
			Result.force_last (input_types_field)
			Result.force_last (output_types_field)
			Result.force_last (local_types_field)
			Result.force_last (content_field)
			Result.force_last (id_field)
			Result.force_last (export_status_field)
			Result.force_last (feature_clause_field)
			Result.force_last (comment_field)
			Result.force_last (library_field)
		end

	object_field_name_set: DS_HASH_SET [STRING]
			-- Set of field names/prefixes that can be used in object documents.
		once
			create Result.make (25)
			Result.set_equality_tester (string_equality_tester)

			Result.force_last (document_type_field)
			Result.force_last (variables_field)
			Result.force_last (variable_types_field)
			Result.force_last (id_field)
			Result.force_last (comment_field)
			Result.force_last (serialization_field)
			Result.force_last (property_field_prefix)
		end

	field_prefix_set: DS_HASH_SET [STRING]
			-- Set of field prefixes that can be used in documents.
		once
			create Result.make (25)
			Result.set_equality_tester (string_equality_tester)

			Result.force_last (to_field_prefix)
			Result.force_last (by_field_prefix)
			Result.force_last (changed_field_prefix)
			Result.force_last (precondition_field_prefix)
			Result.force_last (postcondition_field_prefix)
			Result.force_last (written_precondition_field_prefix)
			Result.force_last (written_postcondition_field_prefix)
		end

feature -- Status report

	is_valid_field_name (a_name: STRING): BOOLEAN
			-- Is `a_name' a valid field name/prefix?
		do
			Result := True
		end

	is_valid_transition_field_name (a_name: STRING): BOOLEAN
			-- Is `a_name' a valid field name/prefix for transition documents?
		do
			Result := True
		end

	is_valid_object_field_name (a_name: STRING): BOOLEAN
			-- Is `a_name' a valid field name/prefix object documents?
		do
			Result := True
		end

	is_valid_field_prefix (a_name: STRING): BOOLEAN
			-- Is `a_name' a valid field prefix?
		do
			Result := True
		end

feature -- Property types

	property_kind_object_property: INTEGER = 1
			-- Property kind ID for a property in objects

	property_kind_precondition: INTEGER = 2
			-- Property kind ID for a precondition

	property_kind_postcondition: INTEGER = 3
			-- Property kind ID for a postcondition

	property_kind_absolute_change: INTEGER = 4
			-- Property kind ID for an absolute change

	property_kind_relative_change: INTEGER = 5
			-- Property kind ID for a relative change

	is_property_kind_valid (a_kind: INTEGER): BOOLEAN
			-- Is `a_kine' a valid property kind ID?
		do
			Result :=
				a_kind = property_kind_precondition or else
				a_kind = property_kind_postcondition or else
				a_kind = property_kind_absolute_change or else
				a_kind = property_kind_relative_change or else
				a_kind = property_kind_object_property
		end

	property_kind_prefix (a_property_kind: INTEGER): STRING
			-- Property prefix for `a_property_kind'
		require
			a_property_kind_valid: is_property_kind_valid (a_property_kind)
		do
			if a_property_kind = property_kind_precondition then
				Result := precondition_field_prefix
			elseif a_property_kind = property_kind_postcondition then
				Result := postcondition_field_prefix
			elseif a_property_kind = property_kind_absolute_change then
				Result := to_field_prefix
			elseif a_property_kind = property_kind_relative_change then
				Result := by_field_prefix
			elseif a_property_kind = property_kind_object_property then
				Result := property_field_prefix
			end
		end

	boolean_type_prefix: STRING = "b::"
			-- Prefix for a boolean type

	integer_type_prefix: STRING = "i::"
			-- Prefix for an integer type

	reference_type_prefix: STRING = "r::"
			-- Prefix for a reference type

end
