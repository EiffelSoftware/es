note
	description: "Utilities"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_UTILITY

inherit
	EPA_TYPE_UTILITY

	EPA_UTILITY

	SEM_CONSTANTS

	ETR_CONTRACT_TOOLS

	SEM_FIELD_NAMES

feature -- Access

	principal_variable_from_anon_content (a_string: STRING): INTEGER
			-- Returns the index of the principal variable by taking the most frequent one
			-- occuring in `a_string'
		local
			l_counts: HASH_TABLE[INTEGER,INTEGER]
			l_pos: INTEGER
			l_in_index: BOOLEAN
			l_cur_index_str: STRING
			l_cur_index: INTEGER
			l_max_count: INTEGER
			l_max: INTEGER
		do
			from
				create l_counts.make (10)
				l_max_count := -1
				l_max := -1
				l_pos := 1
			until
				l_pos > a_string.count
			loop
				if a_string.item (l_pos) = '{' then
					l_in_index := true
					create l_cur_index_str.make (3)
				elseif l_in_index and a_string.item (l_pos) = '}' then
					l_in_index := false
					l_cur_index := l_cur_index.to_integer
					-- Keep track how often a variable occured
					if l_counts.has (l_cur_index) then
						l_counts[l_cur_index] := l_counts[l_cur_index]+1
					else
						l_counts[l_cur_index] := 1
					end

					if l_counts[l_cur_index]>l_max_count then
						l_max_count := l_counts[l_cur_index]
						l_max := l_cur_index
					end
				else
					if l_in_index then
						l_cur_index_str.extend (a_string.item (l_pos))
					end
				end
				l_pos := l_pos + 1
			end

			Result := l_max
		end

	selected_expressions (
		a_transitions: LINKED_LIST [SEM_TRANSITION];
		a_pre_state: BOOLEAN; a_union_mode: BOOLEAN;
		a_selection_function: detachable FUNCTION [ANY, TUPLE [equation: EPA_EQUATION; transition: SEM_TRANSITION; pre_state: BOOLEAN], BOOLEAN]): HASH_TABLE [TYPE_A, STRING]
			-- expression table from `a_transitions'
			-- `a_pre_state' indicates if the expressions come from pre-state or post-state.
			-- If `a_union_mode' is True, an expressions is in the result table if and only if it appears in all transitions from `a_transitions',
			-- otherwise, that expressions will be in the result table if it appears in at least one transition from `a_transitions'.
			-- `a_selection_function' also decides if an expression will be selected or not: If it returns True, an expression will be selected.
			-- If `a_selection_function' is Void, all candidate expression is selected.
			-- Key of the result table is anonymous text of an expression, value of the result table is the type of that expression.
		local
			l_frequence_tbl: DS_HASH_TABLE [INTEGER, STRING]
			l_type_tbl: DS_HASH_TABLE [TYPE_A, STRING]
			l_state_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_expression: EPA_EXPRESSION
			l_count: INTEGER
			l_anonymous_expr: STRING
			l_transition: SEM_TRANSITION
			l_state: EPA_STATE
		do
			create l_frequence_tbl.make (100)
			l_frequence_tbl.set_key_equality_tester (string_equality_tester)
			create l_type_tbl.make (100)
			l_type_tbl.set_key_equality_tester (string_equality_tester)

				-- Collect the number of times that each expression appears in all transitions.
			across a_transitions as l_trans loop
				l_transition := l_trans.item
				from
					if a_pre_state then
						l_state := l_transition.preconditions
					else
						l_state := l_transition.postconditions
					end
					l_state_cursor := l_state.new_cursor
					l_state_cursor.start
				until
					l_state_cursor.after
				loop
					if a_selection_function = Void or else a_selection_function.item ([l_state_cursor.item, l_transition, a_pre_state]) then
						l_expression := l_state_cursor.item.expression
						l_anonymous_expr := l_transition.anonymous_expression_text (l_expression)
						l_frequence_tbl.force_last (l_frequence_tbl.item (l_anonymous_expr) + 1, l_anonymous_expr)
						l_type_tbl.force_last (l_expression.resolved_type (l_transition.context_type), l_anonymous_expr)
					end
					l_state_cursor.forth
				end
			end

				-- Collect all the expressions to be translated as attributes.
			create Result.make (l_frequence_tbl.count)
			Result.compare_objects

			from
				l_count := a_transitions.count
				l_frequence_tbl.start
			until
				l_frequence_tbl.after
			loop
				if a_union_mode or else (l_frequence_tbl.item_for_iteration = l_count) then
					Result.force (l_type_tbl.item (l_frequence_tbl.key_for_iteration), l_frequence_tbl.key_for_iteration)
				end
				l_frequence_tbl.forth
			end
		end

feature -- Names

	variable_name_with_prefix (a_prefix: STRING; a_id: INTEGER): STRING
			-- Variable name with `a_prefix' and `a_id',
			-- for example, "v_12" if `a_prefix' is "v_" and `a_id' is 12.
		do
			create Result.make (5)
			Result.append (a_prefix)
			Result.append (a_id.out)
		end

	variable_name_with_default_prefix (a_id: INTEGER): STRING
			-- Variable name with prefix "v_" and `a_id',
			-- for example, "v_12" if `a_prefix' is "v_" and `a_id' is 12.
		do
			create Result.make (5)
			Result.append (once "v_")
			Result.append (a_id.out)
		end

feature -- Access

	uuid_generator: UUID_GENERATOR
			-- UUID generator
		once
			create Result
		end

	queryable_type_field (a_queryable: SEM_QUERYABLE): IR_FIELD
			-- Field representing the type name of `a_queryable'
		require
			a_queryable_attached: a_queryable /= Void
		do
			if a_queryable.is_feature_call then
				create Result.make_as_string (document_type_field, transition_field_value, default_boost_value)
			elseif a_queryable.is_snippet then
				create Result.make_as_string (document_type_field, snippet_field_value, default_boost_value)
			elseif a_queryable.is_objects then
				create Result.make_as_string (document_type_field, object_field_value, default_boost_value)
			end
		end

	type_of_equation (a_equation: EPA_EQUATION): INTEGER
			-- Type of the value from `a_equation'
		local
			l_value: EPA_EXPRESSION_VALUE
		do
			l_value := a_equation.value
			if l_value.is_integer then
				Result := ir_integer_value_type
			elseif l_value.is_boolean then
				Result := ir_boolean_value_type
			else
				Result := ir_string_value_type
			end
		end

	type_of_expression (a_equation: EPA_EXPRESSION): INTEGER
			-- Type of the value from `a_equation'
		local
			l_type: TYPE_A
		do
			l_type := a_equation.type
			if l_type.is_integer then
				Result := ir_integer_value_type
			elseif l_type.is_boolean then
				Result := ir_boolean_value_type
			else
				Result := ir_string_value_type
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
			-- Key is variable name
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

	variable_info (a_variables: detachable EPA_HASH_SET[EPA_EXPRESSION]; a_queryable: SEM_QUERYABLE; a_print_position: BOOLEAN; a_print_ancestor: BOOLEAN): STRING
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

				l_context_type := a_queryable.context_type
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

	variable_expression_from_context (a_variable_name: STRING; a_context: EPA_CONTEXT): EPA_EXPRESSION
			-- Expression for variable named `a_variable_name'
			-- The variable should appear in `a_context'.
		require
			a_variable_name_name: a_context.variables.has (a_variable_name)
		local
			l_expr_as: EXPR_AS
			l_type: TYPE_A
		do
			l_expr_as := ast_from_expression_text (a_variable_name)
			l_type := a_context.expression_type (l_expr_as)
			if l_type=void then
				create {NONE_A}l_type
			end
			create {EPA_AST_EXPRESSION} Result.make_with_type (a_context.class_, a_context.feature_, l_expr_as, a_context.class_, l_type)
		end

	static_type_form_generator: SEM_STATIC_TYPE_FORM_GENERATOR
			-- Static type form generator
		once
			create Result.make
		end

end
