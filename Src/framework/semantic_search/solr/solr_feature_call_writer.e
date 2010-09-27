note
	description: "Class to write a feature call transition into Solr format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLR_FEATURE_CALL_WRITER

inherit
	SEM_TRANSITION_WRITER [SEM_FEATURE_CALL_TRANSITION]

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

			medium.put_string (once "<add><doc>%N")
			append_basic_info
			append_contracts
			append_changes
			medium.put_string (once "</doc></add>%N")
		end

feature -- Access

	uuid: detachable UUID
			-- UUID used for the queryable to write
			-- If Void, a new UUID will be generated

feature -- Setting

	set_uuid (a_uuid: like uuid)
			-- Set `uuid' with `a_uuid'.
		do
			uuid := a_uuid
		ensure
			uuid_set: uuid = a_uuid
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
			append_variables (queryable.inputs.union (queryable.outputs), variables_field, True, False)
			append_variables (queryable.inputs.union (queryable.outputs), variable_types_field, False, True)
			append_content
		end

	append_library
			-- Append library information of `queryable' into `medium'.
		do
			append_string_field (library_field, queryable.class_.group.name)
		end

	append_queryable_type
			-- Append type of `queryable' into `medium'.
		do
			append_field (queryable_type_field (queryable))
		end

	append_uuid
			-- Append an UUID into `medium'.
		do
			if uuid = Void then
				append_string_field (uuid_field, uuid_generator.generate_uuid.out)
			else
				append_string_field (uuid_field, uuid.out)
			end
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
			l_type: STRING
			l_anonymous: STRING
			a_prefix: STRING
			l_equation: SEM_EQUATION
			l_boost: DOUBLE
			l_value_text: STRING
			l_value: EPA_EXPRESSION_VALUE
		do
			l_tran := queryable
			l_var_dtype_tbl := queryable_dynamic_type_name_table
			l_var_stype_tbl := queryable_static_type_name_table

				-- Iterate through all interface contracts from `queryable'.
			from
				l_equations := queryable.interface_equations.new_cursor
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

					-- Only handle integer value and True boolean values.
				if l_value.is_integer or l_value.is_true_boolean then
						-- Output anonymous format.
					l_anonymous := queryable.anonymous_expression_text (l_expr)
					append_field_with_data (field_name_for_equation (l_anonymous, l_equation, True), l_value_text, l_type, l_boost)

						-- Output dynamic type format.
					append_field_with_data (
						field_name_for_equation (expression_with_replacements (l_expr, l_var_dtype_tbl, True), l_equation, False),
						l_value_text, l_type, l_boost)

						-- Output static type format.
					append_field_with_data (
						field_name_for_equation (expression_with_replacements (l_expr, l_var_stype_tbl, True), l_equation, False),
						l_value_text, l_type, l_boost)
				end
				l_equations.forth
			end
		end

	append_variables (a_variables: detachable EPA_HASH_SET[EPA_EXPRESSION]; a_field: STRING; a_print_position: BOOLEAN; a_print_ancestor: BOOLEAN)
			-- Append operands in `queryable' to `medium'.
			-- `a_print_position' indicates if position of variables are to be printed.
			-- `a_print_ancestor' indicates if ancestors of the types of `a_variables' are to be printed.
		local
			l_values: STRING
		do
			l_values := variable_info (a_variables, queryable, a_print_position, a_print_ancestor)
			if not l_values.is_empty then
				append_field_with_data (a_field, l_values, string_field_type, default_boost_value)
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
		do
			create l_change_calculator

			l_static_change := l_change_calculator.change_set (queryable.written_preconditions, queryable.written_postconditions)
			append_change_set (l_static_change, default_boost_value * 2.0)

			l_dynamic_change := l_change_calculator.change_set (queryable.preconditions, queryable.postconditions)
			append_change_set (l_dynamic_change, default_boost_value)
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
			l_type: STRING
			l_anonymous: STRING
			a_prefix: STRING
			l_equation: SEM_EQUATION
			l_boost: DOUBLE
			l_value_text: STRING
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

					append_field_with_data (field_name_for_change (l_anonymous, a_change, True), l_value_text, l_type, a_boost_value)

						-- Output dynamic type format.
					append_field_with_data (
						field_name_for_change (expression_with_replacements (l_expr, l_var_dtype_tbl, True), a_change, False),
						l_value_text, l_type, l_boost)

						-- Output static type format.
					append_field_with_data (
						field_name_for_change (expression_with_replacements (l_expr, l_var_stype_tbl, True), a_change, False),
						l_value_text, l_type, l_boost)
				end
			end
		end

feature{NONE} -- Implementation

	field_name_for_change (a_name: STRING; a_change: EPA_EXPRESSION_CHANGE; a_anonymous: BOOLEAN): STRING
			-- Field_name for `a_change'
			-- `a_anonymous' indicates if the field is a field for anonymous property.
		do
			create Result.make (a_name.count + 32)

				-- Append type prefix.
			if a_anonymous then
				Result.append (once "s_")
			elseif a_change.expression.type.is_integer then
				Result.append (once "i_")
			elseif a_change.expression.type.is_boolean then
				Result.append (once "b_")
			end
			if a_change.is_relative then
				Result.append (once "by")
			else
				Result.append (once "to")
			end
			if a_anonymous then
				Result.append_character ('0')
			end
			Result.append_character ('_')
			Result.append (escaped_field_name (a_name))
		end

	field_name_for_equation (a_name: STRING; a_equation: SEM_EQUATION; a_anonymous: BOOLEAN): STRING
			-- Field_name for `a_name' and `a_equation'
			-- `a_anonymous' indicates if the field is a field for anonymous property.
		do
			create Result.make (a_name.count + 32)

				-- Append type prefix.
			if a_anonymous then
				Result.append (once "s_")
			elseif a_equation.type.is_integer then
				Result.append (once "i_")
			elseif a_equation.type.is_boolean then
				Result.append (once "b_")
			end
			if a_equation.is_precondition then
				Result.append (once "pre")
			else
				Result.append (once "post")
			end
			if a_anonymous then
				Result.append_character ('0')
			end
			Result.append_character ('_')
			Result.append (escaped_field_name (a_name))
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

	append_field_with_data (a_name: STRING; a_value: STRING; a_type: STRING; a_boost: DOUBLE)
			-- Write field specified through `a_name', `a_value', `a_type' and `a_boost' into `output'.
		do
			append_field (create {SEM_DOCUMENT_FIELD}.make (a_name, a_value, a_type, a_boost))
		end

	append_field (a_field: SEM_DOCUMENT_FIELD)
			-- append `a_field' into `medium'.
		do
			if not written_fields.has (a_field) then
				medium.put_character (' ')
				medium.put_character (' ')
				medium.put_string (xml_element_for_field (a_field))
				medium.put_character ('%N')
				written_fields.force_last (a_field)
			end

		end

	append_string_field (a_name: STRING; a_value: STRING)
			-- Append a string field with `a_name' and `a_value' and default boost value.
		do
			append_field (create {SEM_DOCUMENT_FIELD}.make_with_string_type (a_name, a_value))
		end

end
