note
	description: "Class to write a feature call transition into Solr format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLR_FEATURE_CALL_WRITER

inherit
	SEM_TRANSITION_WRITER [SEM_FEATURE_CALL_TRANSITION]

	SOLR_QUERYABLE_WRITER [SEM_FEATURE_CALL_TRANSITION]

	SEM_UTILITY

create
	make_with_medium

feature{NONE} -- Initialization

	make_with_medium (a_medium: like medium)
			-- Initialize `medium' with `a_medium'.
		do
			set_medium (a_medium)
		end

feature -- Access

	pre_state_serialization: detachable STRING
			-- Pre-state serialization

	pre_state_object_info: detachable STRING
			-- Object info in pre-state

	recipient: detachable STRING
			-- The recipient feature if the transition to be written represents a failing test case

	recipient_class: detachable STRING
			-- The class of `recipient'  if the transition to be written represents a failing test case

	exception_break_point_slot: detachable STRING
			-- The break point slot of the exception if the transition to be written represents a failing test case

	exception_code: detachable STRING
			-- The error code of the exception if the transition to be written represents a failing test case

	exception_meaning: detachable STRING
			-- The error meaning of the exception if the transition to be written represents a failing test case

	exception_trace: detachable STRING
			-- Trace of the exception if the transition to be written represents a failing test case

	exception_tag: detachable STRING
			-- Tag of the failing assertion  if the transition to be written represents a failing test case

	fault_id: detachable STRING
			-- Fault identifier if the transition to be written represents a failing test case

feature -- Setting

	set_pre_state_serialization (a_data: like pre_state_serialization)
			-- Set `pre_state_serialization' with `a_data'.
		do
			pre_state_serialization := a_data
		end

	set_pre_state_object_info (a_data: like pre_state_object_info)
			-- Set `pre_state_object_info' with `a_data'.
		do
			pre_state_object_info := a_data
		end

	set_recipient (a_data: like recipient)
			-- Set `recipient' with `a_data'.
		do
			recipient := a_data
		ensure
			recipient_set: recipient = a_data
		end

	set_recipient_class (a_data: like recipient_class)
			-- Set `recipient_class' with `a_data'.
		do
			recipient_class := a_data
		ensure
			recipient_class_set: recipient_class = a_data
		end

	set_exception_break_point_slot (a_data: like exception_break_point_slot)
			-- Set `exception_break_point_slot' with `a_data'.
		do
			exception_break_point_slot := a_data
		ensure
			exception_break_point_slot_set: exception_break_point_slot = a_data
		end

	set_exception_code (a_data: like exception_code)
			-- Set `exception_code' with `a_data'.
		do
			exception_code := a_data
		ensure
			exception_code_set: exception_code = a_data
		end

	set_exception_meaning (a_data: like exception_meaning)
			-- Set `exception_meaning' with `a_data'.
		do
			exception_meaning := a_data
		ensure
			exception_meaning_set: exception_meaning = a_data
		end

	set_exception_trace (a_data: like exception_trace)
			-- Set `exception_trace' with `a_data'.
		do
			exception_trace := a_data
		ensure
			exception_trace_set: exception_trace = a_data
		end

	set_fault_id (a_data: like fault_id)
			-- Set `fault_id' with `a_data'.
		do
			fault_id := a_data
		ensure
			fault_id_set: fault_id = a_data
		end

	set_exception_tag (a_data: like exception_tag)
			-- Set `exception_tag' with `a_data'.
		do
			exception_tag := a_data
		ensure
			exception_tag_set: exception_tag = a_data
		end

feature -- Basic operations

	write (a_transition: like queryable)
			-- Write `a_transition' into `medium'.
		do
			queryable := a_transition

			queryable_dynamic_type_name_table := type_name_table (queryable.variable_dynamic_type_table)
			queryable_static_type_name_table := type_name_table (queryable.variable_static_type_table)

			create dynamic_change_meta.make (400)
			dynamic_change_meta.compare_objects

			create static_change_meta.make (400)
			static_change_meta.compare_objects

			medium.put_string (once "<add><doc>%N")
			append_basic_info
			append_contracts
			append_changes
			append_serialization
			append_exception
			medium.put_string (once "</doc></add>%N")
		end

	clear_for_write
			-- Clear intermediate data for next `write'.
		do
			set_pre_state_serialization (Void)
			set_pre_state_object_info (Void)
			set_recipient (Void)
			set_recipient_class (Void)
			set_exception_break_point_slot (Void)
			set_exception_code (Void)
			set_exception_meaning (Void)
			set_exception_trace (Void)
			set_fault_id (Void)
		end

feature{NONE} -- Implementation

	queryable_static_type_name_table: like type_name_table
			-- Static type name table for variables in `queryable'

	queryable_dynamic_type_name_table: like type_name_table
			-- Dynamic type name table for variables in `queryable'

	append_basic_info
			-- Append basic information of `queryable' into `medium'.
		do
			append_queryable_type
			append_class_and_feature
			append_uuid
			append_library
			append_feature_type
			append_transition_status
			append_variables (queryable.inputs.union (queryable.outputs), dynamic_variables_field, True, False, False)
			append_variables (queryable.inputs.union (queryable.outputs), variables_field, True, False, True)
			append_variables (queryable.inputs.union (queryable.outputs), variable_types_field, False, True, False)
			append_content
		end

	append_transition_status
			-- Append transition status into `medium'.
		do
			if queryable.is_passing then
				append_string_field (test_case_status_field, test_case_status_passing)
			else
				append_string_field (test_case_status_field, test_case_status_failing)
			end
		end

	append_feature_type
			-- Append feature type fields into `medium'.
		do
			if queryable.feature_.has_return_value then
				append_string_field (feature_type_field, feature_type_query)
			else
				append_string_field (feature_type_field, feature_type_command)
			end
			append_boolean_field (is_creation_field, queryable.is_creation)
			append_integer_field (operand_count_field, queryable.feature_.argument_count + 1)
			append_integer_field (argument_count_field, queryable.feature_.argument_count)
		end

	append_library
			-- Append library information of `queryable' into `medium'.
		do
			append_string_field (library_field, queryable.class_.group.name)
		end

	append_class_and_feature
			-- Append class and feature of `queryable' into `medium'.
		do
			append_string_field (class_field, queryable.class_.name_in_upper)
			append_string_field (feature_field, queryable.feature_.feature_name.as_lower)
		end

	append_contracts
			-- Append contracts from `queryable' into `medium'.
		local
			l_equations: like queryable.interface_equations.new_cursor
			l_expr: EPA_EXPRESSION
			l_tran: like queryable
			l_var_dtype_tbl: like type_name_table
			l_var_stype_tbl: like type_name_table
			l_type: INTEGER
			l_anonymous: STRING
			a_prefix: STRING
			l_equation: SEM_EQUATION
			l_boost: DOUBLE
			l_value_text: STRING
			l_value: EPA_EXPRESSION_VALUE
			l_prefix: STRING
			l_smeta: HASH_TABLE [DS_HASH_SET [STRING], STRING]
			l_dmeta: HASH_TABLE [DS_HASH_SET [STRING], STRING]
			l_body: STRING
			l_field_name: STRING
			l_list: LINKED_LIST [STRING]
			l_meta_value: STRING
			l_separator: STRING
			l_char: CHARACTER
			l_set: DS_HASH_SET_CURSOR [STRING]
		do
			l_tran := queryable
			l_var_dtype_tbl := queryable_dynamic_type_name_table
			l_var_stype_tbl := queryable_static_type_name_table
			l_separator := field_value_separator.out

			create l_smeta.make (400)
			l_smeta.compare_objects
			create l_dmeta.make (400)
			l_dmeta.compare_objects

				-- Iterate through all interface contracts from `queryable'.
			from
				if queryable.is_passing then
					l_equations := queryable.interface_equations.new_cursor
				else
					l_equations := queryable.precondition_interface_equations.new_cursor
				end
				l_equations.start
			until
				l_equations.after
			loop
				l_equation := l_equations.item
				l_expr := l_equation.expression
				l_value := l_equation.value
				l_value_text := l_value.text
				l_type := type_of_equation (l_equation.equation)
				l_boost := boost_value_for_equation (l_equation)
				if l_equation.is_precondition then
					l_prefix := precondition_prefix
				else
					l_prefix := postcondition_prefix
				end

					-- Only handle integer value and boolean values.
				if l_value.is_integer or l_value.is_boolean then
						-- Output anonymous format.
					l_anonymous := queryable.anonymous_expression_text (l_expr)
					append_field_with_data (field_name_for_equation (l_anonymous, l_equation.equation, anonymous_type_form, False, l_prefix), l_value_text, l_type, l_boost)

						-- Output dynamic type format.
					l_body := expression_with_replacements (l_expr, l_var_dtype_tbl, True)
					append_field_with_data (
						field_name_for_equation (
							l_body,
							l_equation.equation,
							dynamic_type_form,
							False,
							l_prefix),
						l_value_text, l_type, l_boost)

					l_field_name := field_name_for_equation (l_body, l_equation.equation, dynamic_type_form, True, l_prefix)
					l_meta_value := text_for_variable_indexes_and_value (l_anonymous, l_value_text)
					extend_string_into_list (l_smeta, l_meta_value, l_field_name)

						-- Output static type format.
					l_body := expression_with_replacements (l_expr, l_var_stype_tbl, True)
					append_field_with_data (
						field_name_for_equation (
							l_body,
							l_equation.equation,
							static_type_form,
							False,
							l_prefix),
						l_value_text, l_type, l_boost)
					l_field_name := field_name_for_equation (l_body, l_equation.equation, static_type_form, True, l_prefix)
					extend_string_into_list (l_dmeta, l_meta_value, l_field_name)
				end
				l_equations.forth
			end

			across <<l_smeta, l_dmeta>> as l_metas loop
				across l_metas.item as l_items loop
					create l_value_text.make (256)
					from
						l_set := l_items.item.new_cursor
						l_set.start
					until
						l_set.after
					loop
						l_value_text.append (l_set.item)
						l_set.forth
					end
					append_field_with_data (l_items.key, l_value_text, ir_string_value_type, l_boost)
				end
			end
		end

	append_content
			-- Append content of `queryable' to `medium'.
		do
			append_string_field (content_field, queryable.content)
		end

	append_changes
			-- Append state-changes of `queryable' to `medium'.
		local
			l_change_calculator: EPA_EXPRESSION_CHANGE_CALCULATOR
			l_dynamic_change: DS_HASH_TABLE [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
			l_static_change: DS_HASH_TABLE [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
			l_type: INTEGER
			l_set: DS_HASH_SET_CURSOR [STRING]
			l_value_text: STRING
		do
			if queryable.is_passing then
				create l_change_calculator.make

				l_static_change := l_change_calculator.change_set (queryable.written_preconditions, queryable.written_postconditions)
				append_change_set (l_static_change, default_boost_value * 2.0)

				l_dynamic_change := l_change_calculator.change_set (queryable.preconditions, queryable.postconditions)
				append_change_set (l_dynamic_change, default_boost_value)

				l_type := ir_string_value_type
				across <<dynamic_change_meta, static_change_meta>> as l_metas loop
					across l_metas.item as l_items loop
						create l_value_text.make (256)
						from
							l_set := l_items.item.new_cursor
							l_set.start
						until
							l_set.after
						loop
							l_value_text.append (l_set.item)
							l_set.forth
						end
						append_field_with_data (l_items.key, l_value_text, l_type, default_boost_value)
					end
				end
			end
		end

	append_change_set (a_set: DS_HASH_TABLE [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]; a_boost_value: DOUBLE)
			-- Append change set `a_set' with `a_boost_value' into `medium'.
		local
			l_expr: EPA_EXPRESSION
			l_cursor: DS_HASH_TABLE_CURSOR [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
		do
			from
				l_cursor := a_set.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_cursor.item.do_all (agent append_change (?, a_boost_value))
				l_cursor.forth
			end
		end

	append_change (a_change: EPA_EXPRESSION_CHANGE; a_boost_value: DOUBLE)
			-- Append `a_change' into `medium'.
		local
			l_values: EPA_EXPRESSION_CHANGE_VALUE_SET
			l_value: EPA_EXPRESSION

			l_equations: like queryable.interface_equations.new_cursor
			l_expr: EPA_EXPRESSION
			l_tran: like queryable
			l_var_dtype_tbl: like type_name_table
			l_var_stype_tbl: like type_name_table
			l_type: INTEGER
			l_anonymous: STRING
			a_prefix: STRING
			l_equation: SEM_EQUATION
			l_boost: DOUBLE
			l_value_text: STRING
			l_body: STRING
			l_field_name: STRING
			l_meta_value: STRING
			l_meta_value2: STRING
			l_bool_text: STRING
			l_bool_type: TYPE_A
		do
			if not a_change.values.is_empty then
				l_var_dtype_tbl := queryable_dynamic_type_name_table
				l_var_stype_tbl := queryable_static_type_name_table

				l_expr := a_change.expression
				if l_expr.is_integer or l_expr.is_boolean then
					l_value_text := a_change.values.first.text

					l_type := type_of_expression (l_expr)

						-- Output anonymous format.
					l_anonymous := queryable.anonymous_expression_text (a_change.expression)

					append_field_with_data (field_name_for_change (l_anonymous, a_change, anonymous_type_form, False, False), l_value_text, l_type, a_boost_value)
					append_field_with_data (field_name_for_change (l_anonymous, a_change, anonymous_type_form, False, True), once "True", ir_boolean_value_type, a_boost_value)

						-- Output dynamic type format.
					l_body := expression_with_replacements (l_expr, l_var_dtype_tbl, True)
					append_field_with_data (
						field_name_for_change (l_body, a_change, dynamic_type_form, False, False),
						l_value_text, l_type, l_boost)
					append_field_with_data (
						field_name_for_change (l_body, a_change, dynamic_type_form, False, True),
						once "True", ir_boolean_value_type, l_boost)

					l_field_name := field_name_for_change (l_body, a_change, dynamic_type_form, True, False)
					l_meta_value := text_for_variable_indexes_and_value (l_anonymous, l_value_text)
					extend_string_into_list (dynamic_change_meta, l_meta_value, l_field_name)

					l_field_name := field_name_for_change (l_body, a_change, dynamic_type_form, True, True)
					l_meta_value2 := text_for_variable_indexes_and_value (l_anonymous, once "True")
					extend_string_into_list (dynamic_change_meta, l_meta_value2, l_field_name)

						-- Output static type format.
					l_body := expression_with_replacements (l_expr, l_var_stype_tbl, True)
					append_field_with_data (
						field_name_for_change (l_body, a_change, static_type_form, False, False),
						l_value_text, l_type, l_boost)
					append_field_with_data (
						field_name_for_change (l_body, a_change, static_type_form, False, True),
						once "True", ir_boolean_value_type, l_boost)

					l_field_name := field_name_for_change (l_body, a_change, static_type_form, True, False)
					extend_string_into_list (static_change_meta, l_meta_value, l_field_name)

					l_field_name := field_name_for_change (l_body, a_change, static_type_form, True, True)
					extend_string_into_list (static_change_meta, l_meta_value2, l_field_name)
				end
			end
		end

	append_serialization
			-- Append object serialization data into `medium'.
		do
			if pre_state_serialization /= Void and then pre_state_object_info /= Void then
				append_string_field (pre_serialization_field, pre_state_serialization)
				append_string_field (pre_object_info_field, pre_state_object_info)
			end
		end

	append_exception
			-- Append exception related fields into `medium'.
		do
			if recipient_class /= Void then
				append_string_field (recipient_class_field, recipient_class)
			end
			if recipient /= Void then
				append_string_field (recipient_field, recipient)
			end
			if exception_break_point_slot /= Void then
				append_integer_field (exception_break_point_slot_field, exception_break_point_slot.to_integer)
			end
			if exception_code /= Void then
				append_integer_field (exception_code_field, exception_code.to_integer)
			end
			if exception_meaning /= Void then
				append_string_field (exception_meaning_field, exception_meaning)
			end
			if exception_tag /= Void then
				append_string_field (exception_tag_field, exception_tag)
			end
			if fault_id /= Void then
				append_string_field (fault_id_field, fault_id)
			end
			if exception_trace /= Void then
				append_string_field (exception_trace_field, once "<![CDATA[%N" +  exception_trace + once "]]>%N")
			end
		end

feature{NONE} -- Implementation

	dynamic_change_meta: HASH_TABLE [DS_HASH_SET [STRING], STRING]
			-- Meta data for dynamic change
			-- Key is Typed expression, value is all anonymous expressions conforming to that typed expression

	static_change_meta: HASH_TABLE [DS_HASH_SET [STRING], STRING]
			-- Meta data for dynamic change
			-- Key is Typed expression, value is all anonymous expressions conforming to that typed expression

	field_name_for_change (a_name: STRING; a_change: EPA_EXPRESSION_CHANGE; a_format_type: INTEGER; a_meta: BOOLEAN; a_only_change: BOOLEAN): STRING
			-- Field_name for `a_change'
			-- `a_anonymous' indicates if the field is a field for anonymous property.
		do
			create Result.make (a_name.count + 32)

				-- Append type prefix.
			if a_meta then
				Result.append (string_prefix)
			elseif a_only_change then
				Result.append (boolean_prefix)
			else
				if a_change.expression.type.is_integer then
					Result.append (integer_prefix)
				else
					Result.append (boolean_prefix)
				end
			end
			Result.append (format_type_prefix (a_format_Type))

			if a_only_change then
				Result.append (change_prefix)
			else
				if a_change.is_relative then
					Result.append (by_change_prefix)
				else
					Result.append (to_change_prefix)
				end
			end
			Result.append (encoded_field_string (a_name))
		end

	boost_value_for_equation (a_equation: SEM_EQUATION): DOUBLE
			-- Boost value for `a_equation'
		do
			if a_equation.is_human_written then
				Result := default_boost_value * 2.0
			else
				Result := default_boost_value
			end
		end

end
