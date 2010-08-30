note
	description: "Writer to output a feature call transition"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_FEATURE_CALL_TRANSITION_WRITER

inherit
	SEM_TRANSITION_WRITER2 [SEM_FEATURE_CALL_TRANSITION]

	EPA_CONTRACT_EXTRACTOR

	EPA_UTILITY

feature -- Basic operations

	write (a_document: like queryable)
			-- Write `a_document' into output stream.
		do
			queryable := a_document
			write_header
			write_variables
		end

feature{NONE} -- Implementation

	write_header
			-- Write document header, including
			-- document type, class name, feature name.
		do
			write_field_with_data (document_type_field, transition_field_value, string_field_type, default_boost_value)
			write_field_with_data (class_field, queryable.class_.name_in_upper, string_field_type, default_boost_value)
			write_field_with_data (feature_field, queryable.feature_.feature_name_32.as_lower , string_field_type, default_boost_value)
			write_auxiliary_fields
			write_library
			write_preconditions
			write_postconditions
		end

	write_variables
			-- Write variables from `a_document' into `output'.
		do
			append_variables (queryable.variables, variables_field, True, False)
			append_variables (queryable.variables, variable_types_field, False, True)
			append_variables (queryable.inputs, inputs_field, True, False)
			append_variables (queryable.inputs, input_types_field, False, True)
			append_variables (queryable.outputs, outputs_field, True, False)
			append_variables (queryable.outputs, output_types_field, False, True)
			append_variables (queryable.intermediate_variables, locals_field, True, False)
			append_variables (queryable.intermediate_variables, local_types_field, False, True)
		end

	append_variables (a_variables: detachable EPA_HASH_SET[EPA_EXPRESSION]; a_field: STRING; a_print_position: BOOLEAN; a_print_ancestor: BOOLEAN)
			-- Append operands in `queryable' to `buffer'.
			-- `a_print_position' indicates if position of variables are to be printed.
			-- `a_print_ancestor' indicates if ancestors of the types of `a_variables' are to be printed.
		local
			l_values: STRING
			l_pos: INTEGER
			l_abs_types: LIST[TYPE_A]
			l_context_type: detachable TYPE_A
			l_cursor: DS_HASH_SET_CURSOR[EPA_EXPRESSION]
			l_set: DS_HASH_SET [STRING]
			l_value: STRING
			l_types: DS_HASH_SET [STRING]
			l_type: TYPE_A
		do
			if attached a_variables and then not a_variables.is_empty then
				create l_set.make (100)
				l_set.set_equality_tester (string_equality_tester)

				l_context_type := queryable.context_type
				create l_values.make (1024)
				from
					l_cursor := a_variables.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_pos := queryable.variable_position (l_cursor.item)
					l_type := l_cursor.item.resolved_type (l_context_type)
					l_value := positioned_type_name (l_type, l_pos, a_print_position)

					create l_types.make (20)
					l_types.set_equality_tester (string_equality_tester)
					l_types.force_last (l_value)

					if a_print_ancestor then
						if l_type.has_associated_class then
							across ancestors (l_type.associated_class) as l_ancestors loop
								l_types.force_last (positioned_type_name (l_ancestors.item.constraint_actual_type, l_pos, a_print_position))
							end
						end
					end

					from
						l_types.start
					until
						l_types.after
					loop
						l_value := l_types.item_for_iteration
						if not l_set.has (l_value) then
							if not l_values.is_empty then
								l_values.append (field_value_separator)
							end
							l_set.force_last (l_value)
							l_values.append (l_value)
						end
						l_types.forth
					end

					l_cursor.forth
				end
				write_field_with_data (a_field, l_values, string_field_type, default_boost_value)
			end
		end

	write_library
			-- Write the library of `queryable' into `output'
		do
			write_field_with_data (library_field, queryable.class_.group.name, string_field_type, default_boost_value)
		end

	positioned_type_name (a_type: TYPE_A; a_position: INTEGER; a_print_position: BOOLEAN): STRING
			-- Type name with possible position
			-- If `a_print_position' is False, the position infomration is ignored.
		do
			create Result.make (32)
			Result.append (once "{")
			Result.append (output_type_name (a_type.name))
			if a_print_position then
				Result.append (once "}@")
				Result.append (a_position.out)
			else
				Result.append (once "}")
			end
		end

	write_preconditions
			-- Write preconditions from `queryable' into `output'.
		do
			write_assertions (queryable.preconditions, precondition_veto_agents, precondition_field_prefix)
		end

	write_postconditions
			-- Write postcondition from `queryable' into `output'.
		do
			write_assertions (queryable.postconditions, postcondition_veto_agents, postcondition_field_prefix)
		end

	write_assertions (a_assertions: EPA_STATE; a_veto_agents: like precondition_veto_agents; a_prefix: STRING)
			-- Write `a_assertions' (filtered by `a_veto_agents') into `output'.
			-- `a_prefix' is the prefix that is put in front of every output field name.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_assertion: EPA_EQUATION
			l_expression: EPA_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
			l_anonymous: STRING
		do
			from
				l_cursor := a_assertions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_assertion := l_cursor.item
					-- Only process assertions that are selected by `a_veto_agents'.
				if across a_veto_agents as l_agents all l_agents.item.item ([l_assertion]) end then
					l_expression := l_assertion.expression
					l_value := l_assertion.value
					l_anonymous := queryable.anonymous_expression_text (l_expression)

						-- Output anonymous format.
					write_field_with_data (a_prefix + l_anonymous, l_value.text, type_of_expression (l_assertion), default_boost_value)

						-- Output dynamic type format.
					write_field_with_data (a_prefix + expression_with_replacements (l_expression, variable_dynamic_type_table (queryable.variables)), l_value.text, type_of_expression (l_assertion), default_boost_value)

						-- Output static type format.
					write_field_with_data (a_prefix + expression_with_replacements (l_expression, variable_static_type_table (queryable.variables)), l_value.text, type_of_expression (l_assertion), default_boost_value)
				end
				l_cursor.forth
			end
		end

	variable_dynamic_type_table (a_variables: DS_HASH_SET [EPA_EXPRESSION]): HASH_TABLE [STRING, STRING]
			-- Table from variable name to their dynamic type
			-- `a_variables' is a set of variable expressions.
			-- Key of Result is variable, value is the resolved dynamic type of that variable.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_context_type: detachable TYPE_A
		do
			l_context_type := queryable.context_type

			create Result.make (a_variables.count)
			Result.compare_objects
			from
				l_cursor := a_variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.force (curly_brace_surrounded_type (l_cursor.item.resolved_type (l_context_type).name), l_cursor.item.text)
				l_cursor.forth
			end
		end

	variable_static_type_table (a_variables: DS_HASH_SET [EPA_EXPRESSION]): HASH_TABLE [STRING, STRING]
			-- Table from variable name to their dynamic type
			-- `a_variables' is a set of variable expressions.
			-- Key of Result is variable, value is the resolved static type of that variable.
			-- Static type only makes sense for variables which are also operands, for other variables,
			-- dyanmic types are used.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_context_type: detachable TYPE_A
			l_operand_types: like operand_types_with_feature
			l_positions: like queryable.variable_positions
			l_variable: EPA_EXPRESSION
			l_operand_map: like queryable.operand_map
			l_operand_pos_map: like queryable.operand_variable_positions
			l_position: INTEGER
			l_type: TYPE_A
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			l_class := queryable.class_
			l_feature := queryable.feature_
			l_context_type := queryable.context_type
			l_operand_types := resolved_operand_types_with_feature (l_feature, l_class, l_context_type)
			l_context_type := queryable.context_type
			l_positions := queryable.variable_positions
			l_operand_pos_map := queryable.operand_variable_positions

			create Result.make (a_variables.count)
			Result.compare_objects
			from
				l_cursor := a_variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_variable := l_cursor.item
				l_operand_pos_map.search (l_variable)
				if l_operand_pos_map.found then
					l_position := l_operand_pos_map.found_item
						-- This is an operand variable, static type is used.
					l_type := l_operand_types.item (l_position)
				else
						-- This is not an operand variable, dynamic type is used.
					l_type := l_variable.resolved_type (l_context_type)
				end
				Result.force (curly_brace_surrounded_type (l_type.name), l_variable.text)
				l_cursor.forth
			end
		end

	type_of_expression (a_equation: EPA_EQUATION): STRING
			-- Type of the value from `a_equation'
		local
			l_value: EPA_EXPRESSION_VALUE
		do
			l_value := a_equation.value
			if l_value.is_integer then
				Result := integer_field_type
			elseif l_value.is_boolean then
				Result := boolean_field_type
			else
				Result := string_field_type
			end
		end

	expression_with_replacements (a_expression: EPA_EXPRESSION; a_replacements: HASH_TABLE [STRING, STRING]): STRING
			-- Expressions from `a_expression' where all replacements are done
		local
			l_expr_rewriter: like expression_rewriter
		do
			l_expr_rewriter := expression_rewriter
			Result := l_expr_rewriter.expression_text (a_expression, a_replacements)
		end

	curly_brace_surrounded_type (a_type_name: STRING): STRING
			-- Type name surrounded by curly braces
		do
			create Result.make (a_type_name.count + 2)
			Result.append_character ('{')
			Result.append (output_type_name (a_type_name))
			Result.append_character ('}')
		end

end
