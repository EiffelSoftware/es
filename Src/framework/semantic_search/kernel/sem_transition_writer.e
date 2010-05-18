note
	description: "Writer to write a semantic document"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TRANSITION_WRITER
inherit
	SEM_DOCUMENT_WRITER
		redefine
			write,
			queryable
		end
create {SEM_DOCUMENT_WRITER}
	default_create

feature -- Basic operation

	write (a_transition: SEM_TRANSITION; a_folder: STRING)
			-- Output `a_transition' into a file in `a_folder'
		local
			l_id: STRING
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
			l_calls: LIST[STRING]
		do
			queryable := a_transition
			if attached {SEM_FEATURE_CALL_TRANSITION}a_transition as l_fc_trans then
				principal_variable_index := 0
			else
				principal_variable_index := principal_variable_from_anon_content (queryable.content)
			end
			principal_variable := queryable.reversed_variable_position.item (principal_variable_index)
			l_calls := calls_on_principal_variable(queryable.content, principal_variable_index)

			abstract_principal_types := abstract_types (principal_variable.resolved_type (queryable.context_type),l_calls)

			create buffer.make (4096)
			append_document_type (document_type)
			append_content

			if attached {SEM_FEATURE_CALL_TRANSITION}a_transition as l_fc_trans then
				append_class
				append_feature
				append_export_status
			end

			append_variables (queryable.variables, variables_field, true)
			append_variables (queryable.variables, variable_types_field, false)
			append_variables (queryable.inputs, inputs_field, true)
			append_variables (queryable.inputs, input_types_field, false)
			append_variables (queryable.outputs, outputs_field, true)
			append_variables (queryable.outputs, output_types_field, false)
			append_variables (queryable.intermediate_variables, locals_field, true)
			append_variables (queryable.intermediate_variables, local_types_field, false)
			append_precondition
			append_postcondition
			append_changes

			create l_id.make (64)
			l_id.append (cleaned_type_name (principal_variable.resolved_type (queryable.context_type).name))
			l_id.append_character ('.')
			l_id.append (buffer.hash_code.out)
			append_field (id_field, default_boost, type_string, l_id)

			create l_file_name.make_from_string (a_folder)
			l_file_name.set_file_name (l_id + ".tran")
			create l_file.make_create_read_write (l_file_name)
			l_file.put_string (buffer)
			l_file.close
		end

feature -- Constants

	document_type: STRING = "transition"

feature {NONE} -- Impelementation

	queryable: SEM_TRANSITION
			-- Transition to be output	

feature {NONE} -- Append

	append_export_status
			-- Append export-status
		local
			l_value: STRING
		do
			if attached {SEM_FEATURE_CALL_TRANSITION}queryable as l_ft_call_trans then
				if l_ft_call_trans.feature_.export_status.is_none then
					l_value := once "NONE"
				else
					l_value := once "ANY"
				end
				append_field (export_status_field, default_boost, type_string, l_value)
			end
		end

	append_class
			-- Append class of `queryable' to `buffer'.
		do
			if attached {SEM_FEATURE_CALL_TRANSITION}queryable as l_ft_call_trans then
				append_field (class_field, default_boost, type_string, l_ft_call_trans.class_.name_in_upper)
			end
		end

	append_feature
			-- Append feature of `queryable' to `buffer'.
		do
			if attached {SEM_FEATURE_CALL_TRANSITION}queryable as l_ft_call_trans then
				append_field (feature_field, default_boost, type_string, l_ft_call_trans.feature_.feature_name)
			end
		end

	append_content
			-- Append content of `queryable' to `buffer'.
		do
			append_field (content_field, default_boost, type_string, queryable.content)
		end

	append_precondition
			-- Append precondition in `queryable' into `buffer'.
		do
			append_state (queryable.precondition, precondition_field_prefix)
		end

	append_postcondition
			-- Append postcondition in `queryable' into `buffer'.
		do
			append_state (queryable.postcondition, postcondition_field_prefix)
		end

	append_changes
			-- Append state changes into `buffer'.
		local
			l_calculator: EPA_EXPRESSION_CHANGE_CALCULATOR
			l_changes: DS_HASH_TABLE [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
			l_transition: like queryable
			l_expr: EPA_EXPRESSION
			l_change_list: LIST [EPA_EXPRESSION_CHANGE]
			l_all_exprs: EPA_HASH_SET [EPA_EXPRESSION]
			l_not_changed_exprs: EPA_HASH_SET [EPA_EXPRESSION]
			l_changed_exprs: EPA_HASH_SET [EPA_EXPRESSION]
		do
			l_transition := queryable
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
							queryable.precondition.has_expression (a_expr) and
							queryable.postcondition.has_expression (a_expr)
					end
				)
		end

	append_unchanged_expression (a_expression: EPA_EXPRESSION)
			-- Append unchanged `a_expression' in `buffer'.
		local
			l_typed_expr: STRING
			l_anony_expr: STRING
			l_transition: like queryable
			l_abstract_exprs: LIST[STRING]
		do
			l_transition := queryable
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
			l_transition: like queryable
			l_typed_content: STRING
			l_anony_content: STRING
			l_prefix: STRING
			l_value: STRING
			l_type: STRING
			l_abstract_exprs: LIST[STRING]
		do
			l_transition := queryable
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
end
