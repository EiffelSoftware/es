note
	description: "Writer to write a semantic document"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_FEATURE_CALL_TRANSITION_WRITER
inherit
	SEM_DOCUMENT_WRITER
		redefine
			write
		end
create {SEM_DOCUMENT_WRITER}
	default_create

feature -- Basic operation

	write (a_transition: SEM_FEATURE_CALL_TRANSITION; a_folder: STRING)
			-- Output `a_transition' into a file in `a_folder'
		local
			l_id: STRING
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
		do
			transition := a_transition
			principal_variable := transition.reversed_variable_position.item (0)
			abstract_principal_types := abstract_types (principal_variable.resolved_type, transition.feature_)

			create buffer.make (4096)
			append_content
			append_class
			append_feature
			append_variables (transition.variables, variables_field, false)
			append_variables (transition.variables, variable_types_field, true)
			append_variables (transition.inputs, inputs_field, false)
			append_variables (transition.inputs, input_types_field, true)
			append_variables (transition.outputs, outputs_field, false)
			append_variables (transition.outputs, output_types_field, true)
			append_variables (transition.intermediate_variables, locals_field, false)
			append_variables (transition.intermediate_variables, local_types_field, true)
			append_export_status
			append_precondition
			append_postcondition
			append_changes

			create l_id.make (64)
			l_id.append (transition.name)
			l_id.append_character ('.')
			l_id.append (buffer.hash_code.out)
			append_field (id_field, default_boost, type_string, l_id)

			create l_file_name.make_from_string (a_folder)
			l_file_name.set_file_name (l_id + ".tran")
			create l_file.make_create_read_write (l_file_name)
			l_file.put_string (buffer)
			l_file.close
		end

feature {NONE} -- Constants

	document_type: STRING = "transition"

feature {NONE} -- Impelementation

	buffer: STRING
			-- Buffer to store output content

	transition: SEM_FEATURE_CALL_TRANSITION
			-- Transition to be output

	principal_variable: EPA_EXPRESSION
			-- The principal variable of this transition

	abstract_principal_types: LIST[CL_TYPE_A]
			-- Abstract types of `principal_variable'			

	is_principal_variable (a_variable: EPA_EXPRESSION): BOOLEAN
			-- Is `a_variable' the principle one
		do
			Result := transition.variable_position (a_variable) = 0
		end

	expression_rewriter: EPA_TRANSITION_EXPRESSION_REWRITER
			-- Expression rewriter to rewrite `variables' in anonymous format.
		once
			create Result.make
		end

	abstracting_rewriter: SEM_ABSTRACTING_EXPRESSION_REWRITER
		once
			create Result.make
		end

	abstracted_expression_strings (a_expression: EPA_EXPRESSION; a_principal_variable: EPA_EXPRESSION): LIST[STRING]
		local
			l_replacements: HASH_TABLE [STRING, STRING]
		do
			create l_replacements.make (transition.variables.count*2)
			l_replacements.compare_objects
			transition.variables.do_all (
				agent (a_expr: EPA_EXPRESSION; a_tbl: HASH_TABLE [STRING, STRING])
					local
						l_type: STRING
					do
						l_type := a_expr.resolved_type.name
						l_type.replace_substring_all (once "?", once "")
						l_type.prepend_character ('{')
						l_type.append_character ('}')
						a_tbl.put (l_type, a_expr.text.as_lower)
					end (?, l_replacements))

			Result := abstracting_rewriter.abstracted_expression_texts (a_expression, a_principal_variable, abstract_principal_types, l_replacements)
		end

feature {NONE} -- Append

	append_document_type_field
			-- Append document type
		do
			append_field (document_type_field, default_boost, type_string, document_type)
		end

	append_export_status
			-- Append export-status
		local
			l_value: STRING
		do
			if attached {SEM_FEATURE_CALL_TRANSITION}transition as l_ft_call_trans then
				if l_ft_call_trans.feature_.export_status.is_none then
					l_value := once "NONE"
				else
					l_value := once "ANY"
				end
				append_field (export_status_field, default_boost, type_string, l_value)
			end
		end

	append_class
			-- Append class of `transition' to `buffer'.
		do
			if attached {SEM_FEATURE_CALL_TRANSITION}transition as l_ft_call_trans then
				append_field (class_field, default_boost, type_string, l_ft_call_trans.class_.name_in_upper)
			end
		end

	append_feature
			-- Append feature of `transition' to `buffer'.
		do
			if attached {SEM_FEATURE_CALL_TRANSITION}transition as l_ft_call_trans then
				append_field (feature_field, default_boost, type_string, l_ft_call_trans.feature_.feature_name)
			end
		end

	append_content
			-- Append content of `transition' to `buffer'.
		do
			append_field (content_field, default_boost, type_string, transition.content)
		end

	append_variables (a_variables: detachable EPA_HASH_SET[EPA_EXPRESSION]; a_field: STRING; a_print_pos: BOOLEAN)
			-- Append operands in `transition' to `buffer'.
		local
			l_values: STRING
			l_pos: INTEGER
			l_abs_types: LIST[TYPE_A]
		do
			if attached a_variables and then not a_variables.is_empty then
				create l_values.make (128)
				from
					a_variables.start
				until
					a_variables.after
				loop
					l_pos := transition.variable_position (a_variables.item_for_iteration)

					if is_principal_variable (a_variables.item_for_iteration) then
						-- "principal" object
						-- add better way to get this ofc
						if attached {SEM_FEATURE_CALL_TRANSITION}transition as l_ft_call_trans then
							from
								l_abs_types := abstract_types (a_variables.item_for_iteration.resolved_type, l_ft_call_trans.feature_)
								l_abs_types.start
							until
								l_abs_types.after
							loop
								l_values.append (once "{")
								l_values.append (cleaned_type_name (l_abs_types.item.name))
								if a_print_pos then
									l_values.append (once "}@")
									l_values.append (l_pos.out)
								else
									l_values.append (once "}")
								end
								l_values.append (field_value_separator)
								l_abs_types.forth
							end
						end
					end

					l_values.append (once "{")
					l_values.append (cleaned_type_name (a_variables.item_for_iteration.resolved_type.name))
					if a_print_pos then
						l_values.append (once "}@")
						l_values.append (l_pos.out)
					else
						l_values.append (once "}")
					end

					a_variables.forth
					if not a_variables.after then
						l_values.append (field_value_separator)
					end
				end

				append_field (a_field, default_boost, type_string, l_values)
			end
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
			l_operands := transition.variable_positions
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
			append_contracts (transition.precondition, precondition_field_prefix)
		end

	append_postcondition
			-- Append postcondition in `transition' into `buffer'.
		do
			append_contracts (transition.postcondition, postcondition_field_prefix)
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

			l_abstract_exprs: LIST[STRING]
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

				-- print the typed expressions for all abstract types
				l_abstract_exprs := abstracted_expression_strings (l_expr, principal_variable)
				from
					l_abstract_exprs.start
				until
					l_abstract_exprs.after
				loop
					if not l_abstract_exprs.item.is_equal (l_typed_expr) then
						append_field (a_field_prefix + l_abstract_exprs.item, default_boost, l_type_name, l_value.out)
					end

					l_abstract_exprs.forth
				end

				l_anony_expr := l_transition.anonymous_expression_text (l_expr)
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
			l_abstract_exprs: LIST[STRING]
		do
			l_transition := transition
			l_typed_expr := l_transition.typed_expression_text (a_expression)
			-- print the typed expressions for all abstract types
			l_abstract_exprs := abstracted_expression_strings (a_expression, principal_variable)
			from
				l_abstract_exprs.start
			until
				l_abstract_exprs.after
			loop
				if not l_abstract_exprs.item.is_equal (l_typed_expr) then
					append_field (changed_field_prefix + l_abstract_exprs.item, default_boost, type_boolean, once "False")
				end

				l_abstract_exprs.forth
			end
			l_anony_expr := l_transition.anonymous_expression_text (a_expression)
			append_field (changed_field_prefix + l_typed_expr, default_boost, type_boolean, once "False")
			append_field (changed_field_prefix + l_anony_expr, default_boost, type_boolean, once "False")
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
			l_abstract_exprs: LIST[STRING]
		do
			l_transition := transition
			l_typed_expr := l_transition.typed_expression_text (a_expression)
			l_anony_expr := l_transition.anonymous_expression_text (a_expression)
			l_abstract_exprs := abstracted_expression_strings (a_expression, principal_variable)

			if a_expression.type.is_boolean then
				l_type := type_boolean
			else
				l_type := type_integer
			end
			if a_change.is_relative then
				l_prefix := by_field_prefix
			else
				l_prefix := to_field_prefix
			end
			l_value := values_from_change (a_change)
			if not l_value.is_empty then
				append_field (l_prefix + l_typed_expr, a_change.relevance, l_type, l_value)
				from
					l_abstract_exprs.start
				until
					l_abstract_exprs.after
				loop
					if not l_abstract_exprs.item.is_equal (l_typed_expr) then
						append_field (l_prefix  + l_abstract_exprs.item, default_boost, type_boolean, once "True")
					end

					l_abstract_exprs.forth
				end
				append_field (l_prefix + l_anony_expr, a_change.relevance, l_type, l_value)

				if a_append_changed then
					append_field (changed_field_prefix + l_typed_expr, a_change.relevance, type_boolean, once "True")
					from
						l_abstract_exprs.start
					until
						l_abstract_exprs.after
					loop
						if not l_abstract_exprs.item.is_equal (l_typed_expr) then
							append_field (changed_field_prefix  + l_abstract_exprs.item, default_boost, type_boolean, once "True")
						end

						l_abstract_exprs.forth
					end
					append_field (changed_field_prefix + l_anony_expr, a_change.relevance, type_boolean, once "True")
				end
			end
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
end
