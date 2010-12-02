note
	description: "Class to write objects into Solr documents"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLR_OBJECTS_WRITER

inherit
	SEM_OBJECTS_WRITER

	SOLR_QUERYABLE_WRITER [SEM_QUERYABLE]

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

	write (a_objects: like queryable)
			-- Write `a_objects' into `medium'.
		do
			queryable := a_objects
			queryable_dynamic_type_name_table := type_name_table (queryable.variable_dynamic_type_table)

			medium.put_string (once "<add><doc>%N")
			append_queryable_type (queryable)
			append_uuid
			append_variables (queryable.variables, variables_field, True, False, False)
			append_variables (queryable.variables, variable_types_field, False, True, False)
			append_properties
			append_serialization
			append_content
			medium.put_string (once "</doc></add>%N")
		end

feature{NONE} -- Implementation

	queryable_dynamic_type_name_table: like type_name_table
			-- Dynamic type name table for variables in `queryable'

feature{NONE} -- Implementation

	append_properties
			-- Append properties from `queryable' into `medium'.
		local
			l_equations: like queryable.properties.new_cursor
			l_expr: EPA_EXPRESSION
			l_queryable: like queryable
			l_var_dtype_tbl: like type_name_table
			l_var_stype_tbl: like type_name_table
			l_type: INTEGER
			l_anonymous: STRING
			a_prefix: STRING
			l_equation: EPA_EQUATION
			l_boost: DOUBLE
			l_value_text: STRING
			l_value: EPA_EXPRESSION_VALUE
			l_prefix: STRING
			l_dmeta: HASH_TABLE [DS_HASH_SET [STRING], STRING]
			l_smeta: HASH_TABLE [DS_HASH_SET [STRING], STRING]
			l_body: STRING
			l_field_name: STRING
			l_meta_value: STRING
			l_set: DS_HASH_SET_CURSOR [STRING]
			l_state: EPA_STATE
		do
			l_queryable := queryable
			l_var_dtype_tbl := queryable_dynamic_type_name_table
			l_boost := default_boost_value
			l_prefix := property_prefix
			create l_dmeta.make (400)
			l_dmeta.compare_objects
			create l_smeta.make (400)
			l_smeta.compare_objects
				-- Iterate through all interface contracts from `queryable'.
			l_state := integer_argumented_expression_equations (l_queryable.properties)
			l_state.append (l_queryable.properties)
			from
				l_equations := l_state.new_cursor
				l_equations.start
			until
				l_equations.after
			loop
				l_equation := l_equations.item
				l_expr := l_equation.expression
				l_value := l_equation.value
				l_value_text := l_value.text
				l_type := type_of_equation (l_equation)

					-- Only handle integer value and boolean values.
				if l_value.is_integer or l_value.is_boolean then
						-- Output anonymous format.
					l_anonymous := l_queryable.anonymous_expression_text (l_expr)
					append_field_with_data (field_name_for_equation (l_anonymous, l_equation, anonymous_type_form, False, l_prefix), l_value_text, l_type, l_boost)

						-- Output dynamic type format.
					l_body := expression_with_replacements (l_expr, l_var_dtype_tbl, True)
					append_field_with_data (
						field_name_for_equation (l_body, l_equation, dynamic_type_Form, False, l_prefix),
						l_value_text, l_type, l_boost)

					l_field_name := field_name_for_equation (l_body, l_equation, dynamic_type_form, True, l_prefix)
					l_meta_value := text_for_variable_indexes_and_value (l_anonymous, l_value_text)
					extend_string_into_list (l_dmeta, l_meta_value, l_field_name)

						-- Output static type form.
					static_type_form_generator.generate (l_queryable.context, l_expr, l_var_dtype_tbl)
					l_body := static_type_form_generator.output.string_representation
					append_field_with_data (
						field_name_for_equation (l_body, l_equation, static_type_form, False, l_prefix),
						l_value_text, l_type, l_boost)
					l_field_name := field_name_for_equation (l_body, l_equation, static_type_form, True, l_prefix)
					l_meta_value := text_for_variable_indexes_and_value (l_anonymous, l_value_text)
					extend_string_into_list (l_smeta, l_meta_value, l_field_name)
				end
				l_equations.forth
			end

			across <<l_dmeta, l_smeta>> as l_metas loop
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
					append_field_with_data (l_items.key, l_value_text, ir_string_value_type, default_boost_value)
				end
			end
		end

	append_serialization
			-- Append serialization from `queryable' to `medium'.
		do
			append_string_field (serialization_field, queryable.serialization_as_string)
		end

	append_content
			-- Append content from `queryable'e to `medium'.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_types: HASH_TABLE [INTEGER, STRING]
			l_type_name: STRING
			l_content: STRING
		do
			create l_types.make (10)
			l_types.compare_objects
			from
				l_cursor := queryable.variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_type_name := output_type_name (l_cursor.item.type.name)
				l_types.force (l_types.item (l_type_name) + 1, l_type_name)
				l_cursor.forth
			end

			create l_content.make (256)
			across l_types as l_type_counts loop
				l_content.append (l_type_counts.key)
				l_content.append (once ": ")
				l_content.append (l_type_counts.item.out)
				l_content.append (once "; ")
			end
			append_string_field (content_field, l_content)
		end

	integer_argumented_expression_equations (a_state: EPA_STATE): EPA_STATE
			-- A state containing equations for integer argumented equations in `a_state'
			-- For example, if in `a_state', there is two expressions: "i_th (1) = 0x1234" and "b = 0x1234",
			-- thene the result has two equations: "i_th (1) = b == True" and "b = i_th (1) == True".
		local
			l_matcher: like integer_argumented_expression_matcher
			l_values: DS_HASH_TABLE [LINKED_LIST [EPA_EXPRESSION], EPA_EXPRESSION_VALUE]
			l_int_exprs: DS_HASH_TABLE [EPA_EXPRESSION_VALUE, EPA_EXPRESSION]
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_expr: EPA_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
			l_equation: EPA_EQUATION
			l_expr_list: LINKED_LIST [EPA_EXPRESSION]
			l_new_equation: EPA_EQUATION
			l_true_value: EPA_BOOLEAN_VALUE
			l_expr2: EPA_EXPRESSION
			l_equ_expr: EPA_AST_EXPRESSION
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			l_class := a_state.class_
			l_feature := a_state.feature_
			create l_true_value.make (True)
			l_matcher := integer_argumented_expression_matcher
			create l_values.make (100)
			l_values.set_key_equality_tester (expression_value_equality_tester)

			create l_int_exprs.make (50)
			l_int_exprs.set_key_equality_tester (expression_equality_tester)

			from
				l_cursor := a_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_equation := l_cursor.item
				l_expr := l_equation.expression
				l_value := l_equation.value
				l_values.search (l_value)
				if l_values.found then
					l_expr_list := l_values.found_item
				else
					create l_expr_list.make
					l_values.put (l_expr_list, l_value)
				end
				l_expr_list.extend (l_expr)

				l_matcher.match (l_expr.text)
				if l_matcher.has_matched then
						-- `l_expr' is an integer argumented expression.
					l_int_exprs.force_last (l_value, l_expr)
				end
				l_cursor.forth
			end

			create Result.make (100, a_state.class_, a_state.feature_)
			from
				l_int_exprs.start
			until
				l_int_exprs.after
			loop
				l_expr := l_int_exprs.key_for_iteration
				l_value := l_int_exprs.item_for_iteration
				l_values.search (l_value)
				if l_values.found then
					l_expr_list := l_values.found_item
					across l_expr_list as l_exprs loop
						l_expr2 := l_exprs.item
						if l_expr.text /~ l_expr2.text then
							create l_equ_expr.make_with_text (l_class, l_feature, l_expr.text + once " = " + l_expr2.text, l_class)
							Result.force_last (create {EPA_EQUATION}.make (l_equ_expr, l_true_value))
							create l_equ_expr.make_with_text (l_class, l_feature, l_expr2.text + once " = " + l_expr.text, l_class)
							Result.force_last (create {EPA_EQUATION}.make (l_equ_expr, l_true_value))
						end
					end
				end
				l_int_exprs.forth
			end
		end

	integer_argumented_expression_matcher: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expression match engine
		once
			create Result.make
			Result.compile (".*\([0-9\-]+\).*")
		end

end

