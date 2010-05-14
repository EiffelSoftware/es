note
	description: "Field names used in queryable documents"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_FIELD_NAMES

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

feature -- Access

	document_type_field: STRING = "document_type"

	class_field: STRING = "class"

	feature_field: STRING = "feature"

	to_field_prefix: STRING = "to::"

	by_field_prefix: STRING = "by::"

	changed_field_prefix: STRING = "changed::"

	precondition_field_prefix: STRING = "pre::"

	postcondition_field_prefix: STRING = "post::"

	variables_field: STRING = "variables"

	inputs_field: STRING = "inputs"

	outputs_field: STRING = "outputs"

	locals_field: STRING = "locals"

	variable_types_field: STRING = "variable_types"

	input_types_field: STRING = "input_types"

	output_types_field: STRING = "output_types"

	local_types_field: STRING = "local_types"

	content_field: STRING = "content"

	id_field: STRING = "id"

	export_status_field: STRING = "export_status"

	feature_clause_field: STRING = "feature_clause"

	comment_field: STRING = "comment"

	library_field: STRING = "library"

	serialization_field: STRING = "serialization"

	property_field_prefix: STRING = "property::"

feature -- Access

	field_name_value_separator: STRING = " : "
			-- Separator to separate field name and field value

	field_value_separator: STRING = ";;;"
			-- Field value separator

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
		end

feature -- Status report

	is_valid_field_name (a_name: STRING): BOOLEAN
			-- Is `a_name' a valid field name/prefix?
		do
			Result := field_name_set.has (a_name)
		end

	is_valid_transition_field_name (a_name: STRING): BOOLEAN
			-- Is `a_name' a valid field name/prefix for transition documents?
		do
			Result := transition_field_name_set.has (a_name)
		end

	is_valid_object_field_name (a_name: STRING): BOOLEAN
			-- Is `a_name' a valid field name/prefix object documents?
		do
			Result := object_field_name_set.has (a_name)
		end

	is_valid_field_prefix (a_name: STRING): BOOLEAN
			-- Is `a_name' a valid field prefix?
		do
			Result := field_prefix_set.has (a_name)
		end

end
