note
	description: "Deferred class for semantic searchable object input/output"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_QUERYABLE_IO [G -> SEM_QUERYABLE]

inherit
	SOLR_UTILITY

	SEM_UTILITY

	SEM_FIELD_NAMES

	SEM_SHARED_EQUALITY_TESTER

	ETR_CONTRACT_TOOLS

feature -- Access

	medium: IO_MEDIUM
			-- Medium used for input/output

	queryable: G
			-- Queryable

feature -- Setting

	set_medium (a_medium: like medium)
			-- Set `medium' with `a_medium'.
		do
			medium := a_medium
		ensure
			medium_set: medium = a_medium
		end

feature{NONE} -- Implementation

	queryable_type_field (a_queryable: like queryable): SEM_DOCUMENT_FIELD
			-- Field representing the type name of `a_queryable'
		require
			a_queryable_attached: a_queryable /= Void
		do
			if a_queryable.is_feature_call then
				create Result.make_with_string_type (document_type_field, transition_field_value)
			elseif a_queryable.is_snippet then
				create Result.make_with_string_type (document_type_field, snippet_field_value)
			elseif a_queryable.is_objects then
				create Result.make_with_string_type (document_type_field, object_field_value)
			end
		end

	type_of_equation (a_equation: EPA_EQUATION): STRING
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

	type_of_expression (a_equation: EPA_EXPRESSION): STRING
			-- Type of the value from `a_equation'
		local
			l_type: TYPE_A
		do
			l_type := a_equation.type
			if l_type.is_integer then
				Result := integer_field_type
			elseif l_type.is_boolean then
				Result := boolean_field_type
			else
				Result := string_field_type
			end
		end


	expression_with_replacements (a_expression: EPA_EXPRESSION; a_replacements: HASH_TABLE [STRING, STRING]; a_simplify_basic_equation: BOOLEAN): STRING
			-- Expressions from `a_expression' where all replacements are done
			-- If `a_simplify_basic_equation' is True, basic equations such as "=", "~", "/=" and "/~" will be simplified, meaning that
			-- they will only be output as "{ANY} = {ANY}" for example.
		local
			l_expr_rewriter: like expression_rewriter
		do
			if attached {STRING} equality_based_abstraction (a_expression.ast, a_replacements) as l_expr then
				Result := l_expr
			else
				l_expr_rewriter := expression_rewriter
				Result := l_expr_rewriter.expression_text (a_expression, a_replacements)
			end
		end

	equality_based_abstraction (a_expr: EXPR_AS; a_replacements: HASH_TABLE [STRING, STRING]): detachable STRING
			-- Abstracted expressions for `a_expr' if and only if
			-- `a_expr' is "a = b", "a /= b", "a ~ b" or "a /~ b".
			-- Otherwise, return an empty list.
		do
			if
				attached {BIN_EQ_AS} a_expr or else
				attached {BIN_NE_AS} a_expr or else
				attached {BIN_TILDE_AS} a_expr or else
				attached {BIN_NOT_TILDE_AS} a_expr
			then
				if attached {BINARY_AS} a_expr as l_bin_as then
					if
						a_replacements.has (text_from_ast (l_bin_as.left).as_lower) and then
						a_replacements.has (text_from_ast (l_bin_as.right).as_lower)
				 	then
						create Result.make (24)
						Result.append (once "{ANY} ")
						Result.append (l_bin_as.op_name.name)
						Result.append (once " {ANY}")
					end
				end
			end
		end

	curly_brace_surrounded_type (a_type_name: STRING): STRING
			-- Type name surrounded by curly braces
		do
			create Result.make (a_type_name.count + 2)
			Result.append_character ('{')
			Result.append (output_type_name (a_type_name))
			Result.append_character ('}')
		end

	type_name_table (a_tbl: HASH_TABLE [TYPE_A, STRING]): HASH_TABLE [STRING, STRING]
			-- Table whose values are type names, instead of types
		do
			create Result.make (a_tbl.count)
			Result.compare_objects
			across a_tbl as l_pairs loop Result.extend (curly_brace_surrounded_type (l_pairs.item.name), l_pairs.key)  end
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

	variable_info (a_variables: detachable EPA_HASH_SET[EPA_EXPRESSION]; a_queryable: SEM_TRANSITION a_print_position: BOOLEAN; a_print_ancestor: BOOLEAN): STRING
			-- Information about operands in `a_variables' in the context of `a_queryable'
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
					l_pos := a_queryable.variable_position (l_cursor.item)
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
				Result := l_values
			else
				create Result.make_empty
			end
		end

end
