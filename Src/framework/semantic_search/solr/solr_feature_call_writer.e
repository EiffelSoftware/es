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

	EPA_SHARED_EQUALITY_TESTERS

create
	make_with_medium

feature{NONE} -- Initialization

	make_with_medium (a_medium: like medium)
			-- Initialize `medium' with `a_medium'.
		do
			set_medium (a_medium)
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

feature{NONE} -- Implementation

	queryable_static_type_name_table: like type_name_table
			-- Static type name table for variables in `queryable'

	queryable_dynamic_type_name_table: like type_name_table
			-- Dynamic type name table for variables in `queryable'

	append_basic_info
			-- Append basic information of `queryable' into `medium'.
		do
			append_queryable_type (queryable)
			append_class_and_feature (queryable)
			append_uuid
			append_library (queryable)
			append_feature_type (queryable)
			append_transition_status (queryable)
--			append_variables (queryable.inputs.union (queryable.outputs), dynamic_variables_field, True, False, False)
--			append_variables (queryable.inputs.union (queryable.outputs), variables_field, True, False, True)
--			append_variables (queryable.inputs.union (queryable.outputs), variable_types_field, False, True, False)
			append_variables (queryable.variables, dynamic_variables_field, True, False, False)
			append_variables (queryable.variables, variables_field, True, False, True)
			append_variables (queryable.variables, variable_types_field, False, True, False)
			append_interface_variable_positions
			append_content
			append_hit_breakpoints (queryable)
		end

	append_interface_variable_positions
			-- Append position information for interface variables into `medium'.
		local
			l_arg_count: INTEGER
			l_vars: DS_HASH_SET [EPA_EXPRESSION]
		do
				-- For target variable.
			create l_vars.make (1)
			l_vars.set_equality_tester (expression_equality_tester)
			l_vars.force_last (queryable.reversed_variable_position.item (0))
			append_interface_variable_positions_internal (l_vars, target_varaible_short)

				-- For result variable.
			if queryable.is_query then
				create l_vars.make (1)
				l_vars.set_equality_tester (expression_equality_tester)
				l_vars.force_last (queryable.reversed_variable_position.item (queryable.argument_count + 1))
				append_interface_variable_positions_internal (l_vars, result_varaible_short)
			end

				-- For argument variables.
			if queryable.argument_count > 0 then
				create l_vars.make (queryable.argument_count)
				l_vars.set_equality_tester (expression_equality_tester)
				across 1 |..| queryable.argument_count as l_arg_indexes loop
					l_vars.force_last (queryable.reversed_variable_position.item (l_arg_indexes.item))
				end
				append_interface_variable_positions_internal (l_vars, argument_variable_short)
			end

				-- For particular variables.
			if queryable.argument_count > 0 then
				across 1 |..| queryable.argument_count as l_arg_indexes loop
					create l_vars.make (queryable.argument_count)
					l_vars.set_equality_tester (expression_equality_tester)
					l_vars.force_last (queryable.reversed_variable_position.item (l_arg_indexes.item))
					append_interface_variable_positions_internal (l_vars, one_argument_variable_short + "_" + l_arg_indexes.item.out)
				end
			end

				-- For operand variables (target + argument).
			if queryable.argument_count > 0 then
				create l_vars.make (queryable.argument_count + 1)
				l_vars.set_equality_tester (expression_equality_tester)
				across 0 |..| queryable.argument_count as l_arg_indexes loop
					l_vars.force_last (queryable.reversed_variable_position.item (l_arg_indexes.item))
				end
				append_interface_variable_positions_internal (l_vars, operand_variable_short)
			end

				-- For interface variables (target + argument + result).
			if queryable.argument_count > 0 then
				create l_vars.make (queryable.argument_count + 2)
				l_vars.set_equality_tester (expression_equality_tester)
				across 0 |..| (queryable.interface_variable_count - 1) as l_arg_indexes loop
					l_vars.force_last (queryable.reversed_variable_position.item (l_arg_indexes.item))
				end
				append_interface_variable_positions_internal (l_vars, interface_variable_short)
			end
		end

	append_interface_variable_positions_internal (a_vars: DS_HASH_SET [EPA_EXPRESSION]; a_category: STRING)
			-- Append position information for interface variables into `medium'.
		local
			l_dfield_value, l_sfield_value: STRING
			l_meta_field_value: STRING
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_var_name: STRING
			l_var_position: INTEGER
		do
			create l_sfield_value.make (128)
			create l_dfield_value.make (128)
			create l_meta_field_value.make (256)
			from
				l_cursor := a_vars.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_var_name := l_cursor.item.text
				l_var_position := queryable.variable_position (l_cursor.item)
				l_sfield_value.append (queryable.static_type_name_table.item (l_var_name))
				l_sfield_value.append_character (field_value_separator)
				l_dfield_value.append (queryable.dynamic_type_name_table.item (l_var_name))
				l_dfield_value.append_character (field_value_separator)

				l_meta_field_value.append (l_var_position.out)
				l_meta_field_value.append_character (',')
				l_meta_field_value.append_boolean (True)
				l_meta_field_value.append_character (field_value_separator)
				l_cursor.forth
			end

			append_string_field (once "t_s_" + a_category, l_sfield_value)
			append_string_field (once "t_d_" + a_category, l_dfield_value)
			append_string_field (once "s_s_" + a_category, l_meta_field_value)
			append_string_field (once "s_d_" + a_category, l_meta_field_value)
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
					l_equations := queryable.all_equations.new_cursor
				else
					l_equations := queryable.all_precondition_equations.new_cursor
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
