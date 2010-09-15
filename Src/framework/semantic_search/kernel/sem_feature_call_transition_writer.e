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

create
	make,
	make_with_medium

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			set_is_anonymous_expression_enabled (True)
			set_is_dynamic_typed_expression_enabled (True)
			set_is_static_typed_expression_enabled (True)
		end

	make_with_medium (a_medium: like output)
			-- Initialize `output' with `a_medium'.
		do
			make
			set_output_medium (a_medium)
		end

feature -- Status report

	is_anonymous_expression_enabled: BOOLEAN
			-- Should anonymous expression be output?
			-- For example, for an expression v_1.has (v_2), then
			-- the output will be {0}.has ({1}), if the position of v_1 is 0 and that of v_2 is 1.
			-- Default: True

	is_dynamic_typed_expression_enabled: BOOLEAN
			-- Should assertions with dynamic types be output?
			-- For example, for an expression v_1.has (v_2), if the dynamic type of v_1 is LINKED_LIST [ANY] and of v_2 is STRING_8,
			-- then the output will be {LINKED_LIST [ANY]}.has ({STRING_8}).
			-- Default: True

	is_static_typed_expression_enabled: BOOLEAN
			-- Should assertions with static types be output?
			-- For example, for an expression v_1.has (v_2), if the static type of v_1 is LINKED_LIST [ANY] and of v_2 is ANY,
			-- then the output will be {LINKED_LIST [ANY]}.has ({ANY}).
			-- Default: True		

feature -- Setting

	set_is_anonymous_expression_enabled (b: BOOLEAN)
			-- Set `is_anonymous_expression_enabled' with `b'.
		do
			is_anonymous_expression_enabled := b
		ensure
			is_anonymous_expression_enabled_set: is_anonymous_expression_enabled = b
		end

	set_is_dynamic_typed_expression_enabled (b: BOOLEAN)
			-- Set `is_dynamic_typed_expression_enabled' with `b'.
		do
			is_dynamic_typed_expression_enabled := b
		ensure
			is_dynamic_typed_expression_enabled_set: is_dynamic_typed_expression_enabled = b
		end

	set_is_static_typed_expression_enabled (b: BOOLEAN)
			-- Set `is_static_typed_expression_enabled' with `b'.
		do
			is_static_typed_expression_enabled := b
		ensure
			is_static_typed_expression_enabled_set: is_static_typed_expression_enabled = b
		end

feature -- Basic operations

	write (a_document: like queryable)
			-- Write `a_document' into output stream.
		do
			queryable := a_document
			write_begin
			write_header
			write_variables
			write_variable_positions
			write_content
			write_preconditions
			write_postconditions
			write_auxiliary_fields
			write_end
		end

feature{NONE} -- Implementation

	write_variable_positions
			-- Write variable position tables
			-- The written data is a commo separated string.
			-- For each pair of strings, the first is variable name, the second is the position of that variable
		local
			l_data: STRING
			l_cursor: like queryable.variable_positions.new_cursor
		do
			create l_data.make (128)
			from
				l_cursor := queryable.variable_positions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if not l_data.is_empty then
					l_data.append_character (',')
				end
				l_data.append (l_cursor.key.text.as_lower)
				l_data.append_character (',')
				l_data.append (l_cursor.item.out)
				l_cursor.forth
			end
			write_field_with_data (variable_position_field, l_data, string_field_type, default_boost_value)
		end

	write_content
			-- Append content of `queryable' to `buffer'.
		do
			write_field_with_data (content_field, queryable.content, string_field_type, default_boost_value)
		end

	write_begin
			-- Write begin section of the whole document
		do
			write_field_with_data (begin_field, begin_field_value, string_field_type, default_boost_value)
		end

	write_end
			-- Write end section of the whole document
		do
			write_field_with_data (end_field, end_field_value, string_field_type, default_boost_value)
		end

	write_header
			-- Write document header, including
			-- document type, class name, feature name.
		do
			write_field_with_data (document_type_field, transition_field_value, string_field_type, default_boost_value)
			write_field_with_data (class_field, queryable.class_.name_in_upper, string_field_type, default_boost_value)
			write_field_with_data (feature_field, queryable.feature_.feature_name_32.as_lower , string_field_type, default_boost_value)
			write_field_with_data (uuid_field, queryable.uuid, string_field_type, default_boost_value)
			write_library
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
			write_assertions (queryable.written_preconditions, precondition_veto_agents, written_precondition_field_prefix)
		end

	write_postconditions
			-- Write postcondition from `queryable' into `output'.
		do
			write_assertions (queryable.postconditions, postcondition_veto_agents, postcondition_field_prefix)
			write_assertions (queryable.written_postconditions, precondition_veto_agents, written_postcondition_field_prefix)
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
					if is_anonymous_expression_enabled then
						write_field_with_data (a_prefix + l_anonymous, l_value.text, type_of_expression (l_assertion), default_boost_value)
					end

						-- Output dynamic type format.
					if is_dynamic_typed_expression_enabled then
						write_field_with_data (a_prefix + expression_with_replacements (l_expression, variable_dynamic_type_table (queryable.variables), True), l_value.text, type_of_expression (l_assertion), default_boost_value)
					end

						-- Output static type format.
					if is_static_typed_expression_enabled then
						write_field_with_data (a_prefix + expression_with_replacements (l_expression, variable_static_type_table (queryable.variables), True), l_value.text, type_of_expression (l_assertion), default_boost_value)
					end

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

end
