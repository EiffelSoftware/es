note
	description: "Writer to write a semantic document"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_DOCUMENT_WRITER

inherit
	EPA_EXPRESSION_CHANGE_VALUE_SET_VISITOR

	EPA_SHARED_EQUALITY_TESTERS

feature -- Basic operation

	write (a_transition: SEM_TRANSITION; a_folder: STRING)
			-- Output `a_transition' into a file in `a_folder'
		local
			l_id: STRING
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
		do
			transition := a_transition
			create buffer.make (4096)
			append_content
			append_operands
			append_operand_types
			append_inputs
			append_outputs
			append_precondition
			append_postcondition
			append_changes

			create l_id.make (64)
			l_id.append (transition.description)
			l_id.append_character ('.')
			l_id.append (buffer.hash_code.out)
			append_field (field_id, default_boost, type_string, l_id)

			create l_file_name.make_from_string (a_folder)
			l_file_name.set_file_name (l_id + ".tran")
			create l_file.make_create_read_write (l_file_name)
			l_file.put_string (buffer)
			l_file.close
		end

feature{NONE} -- Impelementation

	buffer: STRING
			-- Buffer to store output content

	transition: SEM_TRANSITION
			-- Transition to be output

	is_type_valid (a_type: STRING): BOOLEAN
			-- Is `a_type' valid?
		do
			Result :=
				a_type ~ type_boolean or
				a_type ~ type_integer or
				a_type ~ type_string
		end

	field_content: STRING = "content"
	field_id: STRING = "id"
	field_inputs: STRING = "inputs"
	field_outputs: STRING = "outputs"
	field_precondition: STRING = "pre::"
	field_postcondition: STRING = "post::"
	field_to: STRING = "to::"
	field_by: STRING = "by::"
	field_changed: STRING = "changed::"
	field_operands: STRING = "operands"
	field_type: STRING = "type::"

	default_boost: DOUBLE = 1.0
			-- Default boost value for a field

	type_boolean: STRING = "BOOLEAN"
			-- Type boolean

	type_integer: STRING = "INTEGER"
			-- Type integer

	type_string: STRING = "STRING"

	field_value_separator: STRING = ";;;"
			-- Field value separator

feature{NONE} -- Implementation

	normalized_type_name (a_type: STRING): STRING
			-- Normalized type name
		do
			create Result.make_from_string (a_type)
			Result.replace_substring_all (once "?", once "")
		end

	append_content
			-- Append content of `transition' to `buffer'.
		do
			append_field (field_content, default_boost, type_string, transition.content)
		end

	append_operands
			-- Append operands in `transition' to `buffer'.
		local
			l_values: STRING
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, EPA_EXPRESSION]
			i, c: INTEGER
		do
			create l_values.make (128)
			from
				i := 1
				c := transition.operand_positions.count
				l_cursor := transition.operand_positions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_values.append (l_cursor.key.text)
				l_values.append (once ": {")
				l_values.append (normalized_type_name (l_cursor.key.resolved_type.name))
				l_values.append (once "}@")
				l_values.append (l_cursor.item.out)
				if i < c then
					l_values.append (field_value_separator)
				end
				i := i + 1
				l_cursor.forth
			end

			append_field (field_operands, default_boost, type_string, l_values)
		end

	append_inputs
			-- Append inputs in `transition' to `buffer'.
		do
			append_operand_positions (transition.inputs, field_inputs)
		end

	append_outputs
			-- Append outputs in `transition' to `buffer'.
		do
			append_operand_positions (transition.inputs, field_outputs)
		end

	append_operand_positions (a_operands: EPA_HASH_SET [EPA_EXPRESSION]; a_field_name: STRING)
			-- Append inputs from `a_operands' to `buffer'.		
		local
			l_values: STRING
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_operands: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
			i, c: INTEGER
		do
			create l_values.make (64)
			l_operands := transition.operand_positions
			from
				i := 1
				c := a_operands.count
				l_cursor := a_operands.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_values.append (l_operands.item (l_cursor.item).out)
				if i < c then
					l_values.append (field_value_separator)
				end
				i := i + 1
				l_cursor.forth
			end
			append_field (a_field_name, default_boost, type_string, l_values)
		end

	append_precondition
			-- Append precondition in `transition' into `buffer'.
		do
			append_contracts (transition.precondition, field_precondition)
		end

	append_postcondition
			-- Append postcondition in `transition' into `buffer'.
		do
			append_contracts (transition.postcondition, field_postcondition)
		end

	append_contracts (a_state: EPA_STATE; a_field_prefix: STRING)
			-- Append `a_state' as contract into `buffer'.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_transition: like transition
			l_equation: EPA_EQUATION
			l_expr: EPA_EXPRESSION
			l_typed_expr: STRING
			l_anony_expr: STRING
			l_type_name: STRING
			l_value: EPA_EXPRESSION_VALUE
		do
			l_transition := transition
			from
				l_cursor := a_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_equation := l_cursor.item
				l_expr := l_equation.expression
				l_value := l_equation.value
				if l_value.is_boolean then
					l_type_name := type_boolean
				else
					l_type_name := type_integer
				end

				l_typed_expr := l_transition.typed_expression_text (l_expr)
				append_field (a_field_prefix + l_typed_expr, default_boost, l_type_name, l_value.out)

				l_anony_expr := l_transition.anonymous_expressoin_text (l_expr)
				append_field (a_field_prefix + l_anony_expr, default_boost, l_type_name, l_value.out)

				l_cursor.forth
			end
		end

	append_changes
			-- Append state changes into `buffer'.
		local
			l_calculator: EPA_EXPRESSION_CHANGE_CALCULATOR
			l_changes: DS_HASH_TABLE [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
			l_transition: like transition
			l_expr: EPA_EXPRESSION
			l_change_list: LIST [EPA_EXPRESSION_CHANGE]
			l_all_exprs: EPA_HASH_SET [EPA_EXPRESSION]
			l_not_changed_exprs: EPA_HASH_SET [EPA_EXPRESSION]
			l_changed_exprs: EPA_HASH_SET [EPA_EXPRESSION]
		do
			l_transition := transition
			create l_calculator
			l_changes := l_calculator.change_set (l_transition.precondition, l_transition.postcondition)

			from
				l_changes.start
			until
				l_changes.after
			loop
				l_expr := l_changes.key_for_iteration
				l_change_list := l_changes.item_for_iteration
				from
					l_change_list.start
				until
					l_change_list.after
				loop
					append_expression_change (l_expr, l_change_list.item_for_iteration, l_change_list.index = 1)
					l_change_list.forth
				end
				l_changes.forth
			end

				-- Calculate expressions that are not changed in current transition, and
				-- add corresponding information into the semantic document.
			l_all_exprs := l_transition.precondition.expressions.union (l_transition.postcondition.expressions)
			create l_changed_exprs.make (l_all_exprs.count)
			l_changed_exprs.set_equality_tester (expression_equality_tester)
			l_changes.keys.do_all (agent l_changed_exprs.force_last)

				-- Only consider an expression to be unchanged if it appears both in pre- and postconditions of
				-- the transition, and its value is the same in pre- and postconditions.
			l_all_exprs.subtraction (l_changed_exprs).do_if (
				agent append_unchanged_expression,
				agent (a_expr: EPA_EXPRESSION): BOOLEAN
					do
						Result :=
							transition.precondition.has_expression (a_expr) and
							transition.postcondition.has_expression (a_expr)
					end
				)
		end

	append_unchanged_expression (a_expression: EPA_EXPRESSION)
			-- Append unchanged `a_expression' in `buffer'.
		local
			l_typed_expr: STRING
			l_anony_expr: STRING
			l_transition: like transition
		do
			l_transition := transition
			l_typed_expr := l_transition.typed_expression_text (a_expression)
			l_anony_expr := l_transition.anonymous_expressoin_text (a_expression)
			append_field (field_changed + l_typed_expr, default_boost, type_boolean, once "False")
			append_field (field_changed + l_anony_expr, default_boost, type_boolean, once "False")
		end

	append_expression_change (a_expression: EPA_EXPRESSION; a_change: EPA_EXPRESSION_CHANGE; a_append_changed: BOOLEAN)
			-- Append `a_change' of `a_expression' in `buffer'.
			-- `a_append_changed' indicates whether a special field "changed::" is to be added also.
		local
			l_typed_expr: STRING
			l_anony_expr: STRING
			l_transition: like transition
			l_typed_content: STRING
			l_anony_content: STRING
			l_prefix: STRING
			l_value: STRING
			l_type: STRING
		do
			l_transition := transition
			l_typed_expr := l_transition.typed_expression_text (a_expression)
			l_anony_expr := l_transition.anonymous_expressoin_text (a_expression)

			if a_expression.type.is_boolean then
				l_type := type_boolean
			else
				l_type := type_integer
			end
			if a_change.is_relative then
				l_prefix := field_by
			else
				l_prefix := field_to
			end
			l_value := values_from_change (a_change)
			if not l_value.is_empty then
				append_field (l_prefix + l_typed_expr, a_change.relevance, l_type, l_value)
				append_field (l_prefix + l_anony_expr, a_change.relevance, l_type, l_value)

				if a_append_changed then
					append_field (field_changed + l_typed_expr, a_change.relevance, type_boolean, once "True")
					append_field (field_changed + l_anony_expr, a_change.relevance, type_boolean, once "True")
				end
			end
		end

	append_operand_types
			-- Append type information (operand type and their number of occurrences) of `transition into `buffer'.
		local
			l_types: DS_HASH_TABLE [INTEGER, TYPE_A]
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, TYPE_A]
			l_count: INTEGER
			i: INTEGER
			l_values: STRING
		do
			l_types := transition.operand_type_table
			from
				l_cursor := l_types.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				create l_values.make (32)
				l_count := l_cursor.item
				from
					i := 1
				until
					i > l_count
				loop
					l_values.append (i.out)
					if i < l_count then
						l_values.append (field_value_separator)
					end
					i := i + 1
				end
				append_field (field_type + once "{" + normalized_type_name (l_cursor.key.name) + "}", default_boost, type_integer, l_values)
				l_cursor.forth
			end
		end

	values_from_change (a_change: EPA_EXPRESSION_CHANGE): STRING
			-- Values from `a_change'.
		do
			create change_value_buffer.make (64)
			a_change.values.process (Current)
			Result := change_value_buffer.twin
		end

	append_field (a_name: STRING; a_boost: DOUBLE; a_type: STRING; a_value: STRING)
			-- Append field specified by `a_name' `a_boost', `a_type' and `a_value'
			-- into `buffer'.
		require
			is_type_valid: is_type_valid (a_type)
		do
			buffer.append (a_name)
			buffer.append_character ('%N')

			buffer.append (a_boost.out)
			buffer.append_character ('%N')

			buffer.append (a_type)
			buffer.append_character ('%N')

			buffer.append (a_value)
			buffer.append_character ('%N')

			buffer.append_character ('%N')
		end

feature{NONE} -- Process

	change_value_buffer: STRING
			-- Buffer to store change values

	max_integer: INTEGER = 10
			-- Max integer used in relaxed integer changes

	min_integer: INTEGER = -10
			-- Min integer used in relaxed integer changes

	process_expression_change_value_set (a_values: EPA_EXPRESSION_CHANGE_VALUE_SET)
			-- Process `a_values'
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			i, c: INTEGER
			l_buffer: like change_value_buffer
		do
			from
				l_buffer := change_value_buffer
				i := 1
				c := a_values.count
				l_cursor := a_values.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_buffer.append (l_cursor.item.text)
				if i < c then
					l_buffer.append (field_value_separator)
				end
				i := i + 1
				l_cursor.forth
			end
		end

	process_integer_range (a_values: EPA_INTEGER_RANGE)
			-- Process `a_values'.
		local
			l_lower: INTEGER
			l_upper: INTEGER
			i: INTEGER
			l_buffer: like change_value_buffer
		do
			l_buffer := change_value_buffer
			if a_values.lower = a_values.negative_infinity then
				l_lower := min_integer
			else
				if a_values.is_lower_included then
					l_lower := a_values.lower
				else
					l_lower := a_values.lower + 1
				end
			end

			if a_values.upper = a_values.positive_infinity then
				l_upper := max_integer
			else
				if a_values.is_upper_included then
					l_upper := a_values.upper
				else
					l_upper := a_values.upper - 1
				end
			end
			from
				i := l_lower
			until
				i > l_upper
			loop
				l_buffer.append (i.out)
				if i < l_upper then
					l_buffer.append (field_value_separator)
				end
				i := i + 1
			end
		end

end
