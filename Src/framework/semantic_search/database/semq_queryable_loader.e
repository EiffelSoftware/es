note
	description: "Class to load feature call transition from a ssql file"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEMQ_QUERYABLE_LOADER

inherit
	SEM_FIELD_NAMES

	EPA_TYPE_UTILITY

	EPA_UTILITY

	ITP_SHARED_CONSTANTS

	SHARED_TYPES

feature -- Access

	last_queryable: SEM_QUERYABLE
			-- Last transition loaded by `load'

	last_meta: HASH_TABLE [STRING, STRING]
			-- Meta associated with `last_queryable'
			-- Key is meta data name, value is the value of that meta data

feature -- Basic operations

	load (a_path: STRING)
			-- Load queryable from file whose absolute path is specified in `a_path'.
			-- Make result available in `last_queryable'.
		local
			l_retried: BOOLEAN
		do
			if not l_retried then
				create fields.make
				create fields_by_name.make (25)
				fields_by_name.compare_objects

					-- Read file in `a_path', put all fields into `fields' and `fields_by_name'.
				load_file (a_path)

					-- Analyze loaded data.
				build_queryable
			end
		rescue
			last_queryable := Void
			last_meta := Void
			l_retried := True
			retry
		end

feature{NONE} -- Implementation

	is_precondition_property (a_field: IR_FIELD): BOOLEAN
			-- Is `a_field' a precondition field?
		do
			Result :=
				(a_field.name ~ property_field_name or else a_field.name  ~ variable_field_name) and then
				a_field.value_text.split ('%T').i_th (3) ~ precondition_property_prefix
		end

	is_postcondition_property (a_field: IR_FIELD): BOOLEAN
			-- Is `a_field' a precondition field?
		do
			Result :=
				(a_field.name ~ property_field_name or else a_field.name  ~ variable_field_name) and then
				a_field.value_text.split ('%T').i_th (3) ~ postcondition_property_prefix
		end

	is_change_property (a_field: IR_FIELD): BOOLEAN
			-- Is `a_field' a change field?
		do
			Result :=
				a_field.name ~ property_field_name and then
				(a_field.value_text.split ('%T').i_th (3) ~ relative_change_property_prefix or
				a_field.value_text.split ('%T').i_th (3) ~ absolute_change_property_prefix)
		end

feature{NONE} -- Implementation

	fields: LINKED_LIST [IR_FIELD]
			-- Fields read by last `load'

	fields_by_name: HASH_TABLE [LINKED_LIST [IR_FIELD], STRING]
			-- Fields accessed by name
			-- Key of this hash-table is field name, value is the list
			-- of fields under that name

feature{NONE} -- Implementation

	state_with_filter (a_class: CLASS_C; a_feature: FEATURE_I; a_filter: FUNCTION [ANY, TUPLE [IR_FIELD], BOOLEAN]; a_context: EPA_CONTEXT): EPA_STATE
			-- State from loaded data.
		local
			l_field: IR_FIELD
			l_expr: EPA_AST_EXPRESSION
			l_boolean_value: EPA_BOOLEAN_VALUE
			l_equation: EPA_EQUATION
			l_parts: LIST [STRING]
			l_value_type_kind: INTEGER
			l_value: STRING
			l_equal_value: STRING
			l_integer_value: EPA_INTEGER_VALUE
			l_reference_value: EPA_REFERENCE_VALUE
			l_any_type: TYPE_A
			l_integer_type: TYPE_A
			l_boolean_type: TYPE_A
			l_context_class: CLASS_C
			l_context_feature: FEATURE_I
		do
			create Result.make (100, a_class, a_feature)
			l_any_type := workbench.system.any_type
			l_integer_type := integer_type
			l_boolean_type := boolean_type
			l_context_class := a_context.class_
			l_context_feature := a_context.feature_
			across fields as l_fields loop
				l_field := l_fields.item
				if a_filter.item ([l_field]) then
					l_parts := l_field.value_text.split ('%T')
					l_value_type_kind := l_parts.i_th (7).to_integer
					l_value := l_parts.i_th (8)
					l_equal_value := l_parts.i_th (9)
					if l_value_type_kind = 1 then
							-- Boolean type.
						create l_boolean_value.make (l_value.to_integer = 1)
--						create l_expr.make_with_standard_text_and_type (a_class, a_feature, l_parts.first, a_class, l_boolean_type)
						create l_expr.make_with_text (l_context_class, l_context_feature, l_parts.first, l_context_class)
						create l_equation.make (l_expr, l_boolean_value)
					elseif l_value_type_kind = 2 then
							-- Integer type.
						create l_integer_value.make (l_value.to_integer)
--						create l_expr.make_with_standard_text_and_type (a_class, a_feature, l_parts.first, a_class, l_integer_type)
						create l_expr.make_with_text (l_context_class, l_context_feature, l_parts.first, l_context_class)
						create l_equation.make (l_expr, l_integer_value)
					else
							-- Reference type.						
						create l_reference_value.make (once "0x" + l_value, l_any_type)
--						create l_expr.make_with_standard_text_and_type (a_class, a_feature, l_parts.first, a_class, l_any_type)
						create l_expr.make_with_text (l_context_class, l_context_feature, l_parts.first, l_context_class)
						l_reference_value.set_object_equivalent_class_id (l_equal_value.to_integer)
						create l_equation.make (l_expr, l_reference_value)
					end
					l_expr.set_boost (l_parts.i_th (10).to_double)
					Result.force_last (l_equation)
				end
			end
		end

	uuid: STRING
			-- UUID from loaded data
		do
			Result := fields_by_name.item (uuid_field).first.value_text
		end

	hit_breakpoints: DS_HASH_SET [INTEGER]
			-- Hit breakpoints from loaded data
		local
			l_breakpoints: LIST [STRING]
		do
			create Result.make (10)
			if fields_by_name.has (hit_break_points_field) then
				across fields_by_name.item (hit_break_points_field).first.value_text.split (',') as l_bps loop
					Result.force_last (l_bps.item.to_integer)
				end
			end
		end

	variable_with_positions (a_feature: FEATURE_I): HASH_TABLE [STRING, INTEGER]
			-- Variable with their positions
			-- Key is variable position, value is the name of that variable at that position.
		local
			l_vars: LINKED_LIST [IR_FIELD]
			l_parts: LIST [STRING]
			l_position: INTEGER
			l_operand_count: INTEGER
		do
			l_operand_count := operand_count_of_feature (a_feature)
			create Result.make (20)
			across fields_by_name.item (variable_field_name) as l_fields loop
				l_parts := l_fields.item.value_text.split ('%T')
				if l_parts.i_th (3) ~ precondition_property_prefix then
					l_position := l_parts.last.to_integer
					if l_position < l_operand_count then
						Result.force (l_parts.first, l_position)
					end
				end
			end
		end

	context_from_field (a_field: IR_FIELD): EPA_CONTEXT
			-- Context from `a_field'
		local
			l_parts: LIST [STRING]
			l_var_name: STRING
			l_var_type: TYPE_A
			l_variables: HASH_TABLE [TYPE_A, STRING]
		do
			create l_variables.make (20)
			l_parts := a_field.value_text.split (field_value_separator)
			from
				l_parts.start
			until
				l_parts.after
			loop
				l_var_type := type_a_from_string_in_application_context (l_parts.item_for_iteration)
				l_parts.forth
				l_var_name := variable_name_prefix + l_parts.item_for_iteration
				l_variables.force (l_var_type, l_var_name)
				l_parts.forth
			end
			create Result.make (l_variables)
		end

feature{NONE} -- Implementation

	load_file (a_path: STRING)
			-- Load queryable data from `a_path', put loaded fields into `fields' and `fields_by_name'.
		local
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_field: IR_FIELD
			l_field_name: STRING
			l_field_value: STRING
			l_fields: LINKED_LIST [IR_FIELD]
			l_colon_index: INTEGER
		do
			create l_file.make_open_read (a_path)
			from
				l_file.read_line
			until
				l_file.end_of_file
			loop
				l_line := l_file.last_string.twin
				l_line.left_adjust
				l_line.right_adjust
				l_colon_index := l_line.index_of (':', 1)
				l_field_name := l_line.substring (1, l_colon_index - 1)
				l_field_value := l_line.substring (l_colon_index + 2, l_line.count)
				if (l_field_name ~ property_field_name or l_field_name ~ variable_field_name) and l_field_value.ends_with (once "-1") then
					-- We ignore augxiliary variable and properties.
				else
					create l_field.make_as_string (l_field_name, l_field_value, 0)
					fields.extend (l_field)
					fields_by_name.search (l_field_name)
					if fields_by_name.found then
						l_fields := fields_by_name.found_item
					else
						create l_fields.make
						fields_by_name.force (l_fields, l_field_name)
					end
					l_fields.extend (l_field)
				end
				l_file.read_line
			end
			l_file.close
		end

	build_queryable
			-- Build queryable from loaded data.
		do
			create last_meta.make (10)
			last_meta.compare_objects
			if fields_by_name.item (document_type_field).first.value_text ~ transition_field_value then
				build_transition
			else
				build_objects
			end
		end

	build_transition
			-- Build transition from loaded data.
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_tran: SEM_FEATURE_CALL_TRANSITION
			l_context: EPA_CONTEXT
			l_variables: HASH_TABLE [STRING, INTEGER]
		do
			create last_meta.make (10)
			last_meta.compare_objects

				-- Set transition.
			l_class := first_class_starts_with_name (fields_by_name.item (class_field).first.value_text)
			l_feature := l_class.feature_named (fields_by_name.item (feature_field).first.value_text)
			if fields_by_name.item (pre_object_info_field) /= Void then
				l_context := context_from_field (fields_by_name.item (pre_object_info_field).first)
				l_variables := variable_with_positions (l_feature)
				create l_tran.make (l_class, l_feature, l_variables, l_context, fields_by_name.item (is_creation_field).first.value_text.to_boolean)
				l_tran.set_uuid (uuid)
				l_tran.set_is_passing (fields_by_name.item (test_case_status_field).first.value_text.to_boolean)
				l_tran.hit_breakpoints.append (hit_breakpoints)
				l_tran.set_preconditions_unsafe (state_with_filter (l_tran.class_, l_tran.feature_, agent is_precondition_property, l_context))
				l_tran.set_postconditions_unsafe (state_with_filter (l_tran.class_, l_tran.feature_, agent is_postcondition_property, l_context))
				load_changes (l_tran)

					-- Setup meta data.
				if fields_by_name.has (pre_serialization_field) then
					last_meta.put (fields_by_name.item (pre_serialization_field).first.value_text, pre_serialization_field)
				end
				if fields_by_name.has (timestamp_field) then
					last_meta.put (fields_by_name.item (timestamp_field).first.value_text, timestamp_field)
				end
				if fields_by_name.has (pre_serialization_field) then
					last_meta.put (fields_by_name.item (pre_serialization_field).first.value_text, pre_serialization_field)
				end

				if fields_by_name.has (recipient_field) then
					last_meta.put (fields_by_name.item (recipient_field).first.value_text, recipient_field)
				end
				if fields_by_name.has (recipient_class_field) then
					last_meta.put (fields_by_name.item (recipient_class_field).first.value_text, recipient_class_field)
				end
				if fields_by_name.has (exception_break_point_slot_field) then
					last_meta.put (fields_by_name.item (exception_break_point_slot_field).first.value_text, exception_break_point_slot_field)
				end
				if fields_by_name.has (exception_code_field) then
					last_meta.put (fields_by_name.item (exception_code_field).first.value_text, exception_code_field)
				end
				if fields_by_name.has (exception_meaning_field) then
					last_meta.put (fields_by_name.item (exception_meaning_field).first.value_text, exception_meaning_field)
				end
				if fields_by_name.has (exception_trace_field) then
					last_meta.put (fields_by_name.item (exception_trace_field).first.value_text, exception_trace_field)
				end
				if fields_by_name.has (exception_tag_field) then
					last_meta.put (fields_by_name.item (exception_tag_field).first.value_text, exception_tag_field)
				end
				if fields_by_name.has (fault_id_field) then
					last_meta.put (fields_by_name.item (fault_id_field).first.value_text, fault_id_field)
				end
				if fields_by_name.has (prestate_bounded_functions_field) then
					last_meta.put (fields_by_name.item (prestate_bounded_functions_field).first.value_text, prestate_bounded_functions_field)
				end
				if fields_by_name.has (poststate_bounded_functions_field) then
					last_meta.put (fields_by_name.item (poststate_bounded_functions_field).first.value_text, poststate_bounded_functions_field)
				end
				last_queryable := l_tran
			else
				last_queryable := Void
				last_meta := Void
			end
		end

	build_objects
			-- Build objects from loaded data.
		do
		end

	load_changes (a_transition: SEM_FEATURE_CALL_TRANSITION)
			-- Load changes for `a_transition' from loaded data.
		local
			l_field: IR_FIELD
			l_parts: LIST [STRING]
			l_is_relative: BOOLEAN
			l_expr: EPA_AST_EXPRESSION
			l_change: EPA_EXPRESSION_CHANGE
			l_values: EPA_EXPRESSION_ENUMERATION_CHANGE_SET
			l_value_type_kind: INTEGER
			l_value_expr: EPA_AST_EXPRESSION
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_value: STRING
			l_changes: DS_HASH_TABLE [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
			l_change_list: LIST [EPA_EXPRESSION_CHANGE]
			l_boolean_type: TYPE_A
			l_integer_type: TYPE_A
		do
			l_boolean_type := boolean_type
			l_integer_type := integer_type
			l_class := a_transition.class_
			l_feature := a_transition.feature_
			l_changes := a_transition.changes
			across fields as l_fields loop
				l_field := l_fields.item
				if is_change_property (l_field) then
					l_parts := l_field.value.text.split ('%T')
					l_is_relative := l_parts.i_th (3) ~ relative_change_property_prefix
					create l_values.make (1)
					l_value_type_kind := l_parts.i_th (7).to_integer
					l_value := l_parts.i_th (8)
					if l_value_type_kind = 1 then
							-- Boolean type.
						create l_value_expr.make_with_standard_text_and_type (l_class, l_feature, (l_value.to_integer = 1).out, l_class, l_boolean_type)
						create l_expr.make_with_standard_text_and_type (l_class, l_feature, l_parts.first, l_class, l_boolean_type)
					elseif l_value_type_kind = 2 then
							-- Integer type.						
						create l_value_expr.make_with_standard_text_and_type (l_class, l_feature, l_value, l_class, l_integer_type)
						create l_expr.make_with_standard_text_and_type (l_class, l_feature, l_parts.first, l_class, l_integer_type)
					else
						check should_not_be_here: False end
					end
					l_values.force_last (l_value_expr)
					create l_change.make (l_expr, l_values, l_is_relative)
					l_change.set_boost (l_parts.i_th (10).to_double)

						-- Insert `l_change' into `a_transition'.
					l_changes.search (l_expr)
					if l_changes.found then
						l_change_list := l_changes.found_item
					else
						create {LINKED_LIST [EPA_EXPRESSION_CHANGE]} l_change_list.make
						l_changes.force_last (l_change_list, l_expr)
					end
					l_change_list.extend (l_change)
				end
			end
		end

end
