note
	description: "Summary description for {AFX_TRANSITION_SUMMARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TRANSITION_SUMMARY

inherit
	AUT_PREDICATE_UTILITY

	EPA_UTILITY


create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			fixme ("This class should be removed in the future. It is just a quick sketch to investigate the quality of the contract inferred from AutoTest generated test cases. 22.2.2010 Jasonw")

			create expression_table.make (100)
			expression_table.set_key_equality_tester (feature_of_type_equality_tester)

			create transitions.make (100)
			transitions.set_key_equality_tester (feature_of_type_equality_tester)

			create transitions_cache.make (10000)
			transitions_cache.set_equality_tester (string_equality_tester)
		end

feature -- Access

	expression_table: DS_HASH_TABLE [DS_HASH_TABLE [STRING, STRING], AUT_FEATURE_OF_TYPE]
			-- Table of expressions that are used in state model for a feature
			-- For the outer table, key of the is the feature,
			-- value is the set of expressions with types used in state model.
			-- For the inner table, key is expression name, value is the type of that expression.


	transitions: DS_HASH_TABLE [LINKED_LIST [TUPLE [source: HASH_TABLE [STRING, STRING]; target: HASH_TABLE [STRING, STRING]]], AUT_FEATURE_OF_TYPE]
			-- Table of transitions.
			-- Key is the feature, value is a list of transitions for that feature.
			-- `source' is the starting state of a transition, `target' is the end state of a transition.
			-- For both `source' and `target', key is expression name, value is the evaluation value of that expression.

feature -- Basic operations

	transitions_cache: DS_HASH_SET [STRING]
			-- Cache for transitions seen so far

	transition_signature (a_type: TYPE_A; a_class: CLASS_C; a_feature: FEATURE_I; a_source: DS_ARRAYED_LIST [EPA_STATE]; a_target: DS_ARRAYED_LIST [EPA_STATE]): STRING
			-- Signature of the transition defined by `a_class', `a_feature', `a_source' and `a_target'.
			-- See `add_transition' for meanings of these arguments.
			-- The signature is used to check if a transition has been seen before.
			-- `a_type' is the dynamic type of the target of the feature call.
		do
			create Result.make (2048)
			Result.append_character ('{')
			Result.append (a_type.name)
			Result.append_character ('}')
			Result.append_character ('.')
			Result.append (a_feature.feature_name.as_lower)
			a_source.do_all (agent (a_str: STRING; a_state: EPA_STATE) do a_str.append (a_state.debug_output) end (Result, ?))
			Result.append_character ('%N')
			a_target.do_all (agent (a_str: STRING; a_state: EPA_STATE) do a_str.append (a_state.debug_output) end (Result, ?))
		end

	add_semantic_document (a_type: TYPE_A; a_class: CLASS_C; a_feature: FEATURE_I; a_source: DS_ARRAYED_LIST [EPA_STATE]; a_target: DS_ARRAYED_LIST [EPA_STATE])
			-- Add state transition as a semantic document for `a_feature' in `a_class' into `transitions', and update `expression_table' when needed.
			-- `a_source' is the starting state, `a_target' is the ending state.
			-- The elements in `a_source' or `a_target' are states for a particular operand, or result object.
			-- The first element is target, followed by optional arguments, and then the result object.
		local
			l_signature: STRING
			l_precondition: EPA_STATE
			l_postcondition: EPA_STATE
			l_change_calculator: EPA_EXPRESSION_CHANGE_CALCULATOR
			l_changes: DS_HASH_TABLE [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]
			l_document_writer: SEM_DOCUMENT_WRITER
			l_transition: SEM_FEATURE_CALL_TRANSITION
		do
			if not a_feature.is_function and not a_feature.is_attribute and not a_feature.is_constant then
				l_signature := transition_signature (a_type, a_class, a_feature, a_source, a_target)

					-- Only continure to process if current transision is not seen so far.
				if not transitions_cache.has (l_signature) then
					transitions_cache.force_last (l_signature)
					l_precondition := state_with_operands (a_class, a_feature, a_source)
					l_postcondition := state_with_operands (a_class, a_feature, a_target)
					create l_transition.make_with_operands (a_class, a_feature, l_precondition, l_postcondition)
					create l_change_calculator
					l_changes := l_change_calculator.change_set (l_transition.precondition, l_transition.postcondition)
					if not l_changes.is_empty then
						create l_transition.make_with_operands (a_class, a_feature, l_precondition, l_postcondition)
						create l_document_writer
						l_document_writer.write (l_transition, "d:\temp\transitions")
					end
				end
			end
		end

	string_representation_of_changes (a_changes: DS_HASH_TABLE [LIST [EPA_EXPRESSION_CHANGE], EPA_EXPRESSION]): STRING
			-- String representation for `a_changes'
		do
			create Result.make (2048)
			a_changes.do_all_with_key (
				agent (a_change: LIST [EPA_EXPRESSION_CHANGE]; a_expr: EPA_EXPRESSION; a_str: STRING)
					local
						l_cursor: CURSOR
					do
						l_cursor := a_change.cursor
						from
							a_change.start
						until
							a_change.after
						loop
							a_str.append (a_change.item_for_iteration.debug_output)
							a_str.append_character ('%N')
							a_change.forth
						end
						a_change.go_to (l_cursor)
					end (?, ?, Result))
		end

	state_with_operands (a_class: CLASS_C; a_feature: FEATURE_I; a_states: DS_ARRAYED_LIST [EPA_STATE]): EPA_STATE
			-- State containing equations in all states in `a_states' in `a_class', `a_feature'.
			-- every expression is prepended with its operand name.
			-- For example, an expression "is_empty" for target object in `a_states'
			-- will be "Current.is_empty" in the resulting state.
		local
			l_operands: like operands_with_feature
			l_cursor: DS_ARRAYED_LIST_CURSOR [EPA_STATE]
			l_state_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_old_equation: EPA_EQUATION
			l_new_equation: EPA_EQUATION
			l_operand_pos: INTEGER
			l_new_expr: EPA_AST_EXPRESSION
		do
			create Result.make (50, a_class, a_feature)
			l_operands := operands_with_feature (a_feature)

			from
				l_operand_pos := 0
				l_cursor := a_states.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				from
					l_state_cursor := l_cursor.item.new_cursor
					l_state_cursor.start
				until
					l_state_cursor.after
				loop
					l_old_equation := l_state_cursor.item
					create l_new_expr.make_with_text (a_class, a_feature, l_operands.item (l_operand_pos) + once "." + l_old_equation.expression.text, a_class)
					if l_new_expr.type /= Void then
						create l_new_equation.make (l_new_expr, l_old_equation.value)
						Result.force_last (l_new_equation)
					end
					l_state_cursor.forth
				end
				l_operand_pos := l_operand_pos + 1
				l_cursor.forth
			end
		end

	add_transition (a_class: CLASS_C; a_feature: FEATURE_I; a_source: DS_ARRAYED_LIST [EPA_STATE]; a_target: DS_ARRAYED_LIST [EPA_STATE])
			-- Add state transition for `a_feature' in `a_class' into `transitions', and update `expression_table' when needed.
			-- `a_source' is the starting state, `a_target' is the ending state.
			-- The elements in `a_source' or `a_target' are states for a particular operand, or result object.
			-- The first element is target, followed by optional arguments, and then the result object.
		require
			state_valid: a_source.count = a_target.count
		local
			l_operand_names: LINKED_LIST [STRING]
			i: INTEGER
			c: INTEGER
			l_expr_tbl: like expression_table
			l_state: EPA_STATE
			l_states: DS_ARRAYED_LIST [EPA_STATE]
			l_feature: AUT_FEATURE_OF_TYPE
			l_expr: STRING
			l_value: STRING
			l_set: DS_HASH_TABLE [STRING, STRING]
			l_transitions: like transitions
			l_state_summary: HASH_TABLE [STRING, STRING]
			l_source_summary: HASH_TABLE [STRING, STRING]
			l_target_summary: HASH_TABLE [STRING, STRING]
		do
			create l_feature.make (a_feature, a_class.actual_type)
			create l_operand_names.make
			l_operand_names.extend ("o0.")
			from
				i := 1
				c := a_feature.argument_count
			until
				i > c
			loop
				l_operand_names.extend ("o" + i.out + ".")
				i := i + 1
			end
			if not a_feature.type.actual_type.is_void then
				l_operand_names.extend ("r" + (a_feature.argument_count + 1).out + ".")
			end

			l_transitions := transitions
			l_expr_tbl := expression_table
			if not l_expr_tbl.has (l_feature) then
				create l_set.make (30)
				l_set.set_key_equality_tester (string_equality_tester)
				l_expr_tbl.force_last (l_set, l_feature)
			end

			if not l_transitions.has (l_feature) then
				l_transitions.force_last (create {LINKED_LIST [TUPLE [source: HASH_TABLE [STRING, STRING]; target: HASH_TABLE [STRING, STRING]]]}.make, l_feature)
			end

			from
				c := 1
			until
				c > 2
			loop
				if c = 1 then
					l_states := a_source
				else
					l_states := a_target
				end
				create l_state_summary.make (30)
				l_state_summary.compare_objects

				from
					i := 1
					l_states.start
					l_operand_names.start
				until
					l_states.after
				loop
					l_state := l_states.item_for_iteration
					from
						l_state.start
					until
						l_state.after
					loop
						l_expr := l_operand_names.item_for_iteration + l_state.item_for_iteration.expression.text
						l_expr_tbl.search (l_feature)
						if not l_expr_tbl.found_item.has (l_expr) then
							l_expr_tbl.found_item.force_last (l_state.item_for_iteration.type.name, l_expr)
						end
						l_value := l_state.item_for_iteration.value.out
						l_state_summary.put (l_value, l_expr)
						l_state.forth
					end
					l_operand_names.forth
					l_states.forth
					i := i + 1
				end
				if c = 1 then
					l_source_summary := l_state_summary
				else
					l_target_summary := l_state_summary
				end
				if c = 2 then
					l_transitions.search (l_feature)
					l_transitions.found_item.extend ([l_source_summary, l_target_summary])
				end
				c := c + 1
			end
		end

	hash_table_debug_output (a_table: HASH_TABLE [STRING, STRING]): STRING
			-- Debug output for `a_table'
		do
			create Result.make (1024)
			from
				a_table.start
			until
				a_table.after
			loop
				Result.append (a_table.key_for_iteration)
				Result.append (once " = ")
				Result.append (a_table.item_for_iteration)
				Result.append (once "%N")
				a_table.forth
			end
		end

	store_transitions (a_directory: STRING)
			-- Store `transitions' into `a_directory'.
			-- Create a file for each feature in `expression_table'.
		local
			l_feature: AUT_FEATURE_OF_TYPE
			l_exprs: LINKED_LIST [STRING]
			l_types: DS_HASH_TABLE [STRING, STRING]
			l_file_name: FILE_NAME
		do
			from
				expression_table.start
			until
				expression_table.after
			loop
				l_feature := expression_table.key_for_iteration
				create l_file_name.make_from_string (a_directory)
				l_file_name.set_file_name (l_feature.type.associated_class.name + "." + l_feature.feature_.feature_name + ".arff")
				create l_exprs.make

				from
					expression_table.item_for_iteration.start
				until
					expression_table.item_for_iteration.after
				loop
					l_exprs.extend (expression_table.item_for_iteration.key_for_iteration)
					expression_table.item_for_iteration.forth
				end
				l_types := expression_table.item_for_iteration
				store_transitions_for_feature (l_feature, l_exprs, l_types, l_file_name)
				expression_table.forth
			end
		end

	store_transitions_for_feature (a_feature: AUT_FEATURE_OF_TYPE; a_expressions: LINKED_LIST [STRING]; a_types: DS_HASH_TABLE [STRING, STRING] a_file_name: STRING)
			-- Store transitions for `a_feature' into `a_file_name'.
			-- `a_expressions' are the set of expressions that are needed to be stored,
			-- `a_types' are types of `a_expressions' in the corresponding order.
		local
			l_file: PLAIN_TEXT_FILE
			l_attr: WEKA_ARFF_ATTRIBUTE
			l_attrs: ARRAYED_LIST [WEKA_ARFF_ATTRIBUTE]
			l_sorted_attrs: SORTED_TWO_WAY_LIST [STRING]
			l_relation: WEKA_ARFF_RELATION
			l_transitions: LINKED_LIST [TUPLE [source: HASH_TABLE [STRING, STRING]; target: HASH_TABLE [STRING, STRING]]]
			l_data: TUPLE [source: HASH_TABLE [STRING, STRING]; target: HASH_TABLE [STRING, STRING]]
			l_evaluation: HASH_TABLE [STRING, STRING]
			l_source_attrs: ARRAYED_LIST [WEKA_ARFF_ATTRIBUTE]
			l_target_attrs: ARRAYED_LIST [WEKA_ARFF_ATTRIBUTE]
			l_values: ARRAYED_LIST [STRING]
		do
			create l_sorted_attrs.make
			l_sorted_attrs.append (a_expressions)
			l_sorted_attrs.sort
			create l_source_attrs.make (a_expressions.count)
			create l_target_attrs.make (a_expressions.count)
			from
				l_sorted_attrs.start
			until
				l_sorted_attrs.after
			loop
				if a_types.item (l_sorted_attrs.item_for_iteration) ~ "BOOLEAN" then
					create {WEKA_ARFF_BOOLEAN_ATTRIBUTE} l_attr.make ("s." + l_sorted_attrs.item_for_iteration)
				elseif a_types.item (l_sorted_attrs.item_for_iteration).starts_with ("INTEGER_") then
					create {WEKA_ARFF_NUMERIC_ATTRIBUTE} l_attr.make ("s." + l_sorted_attrs.item_for_iteration)
				end
				l_source_attrs.extend (l_attr)

				if a_types.item (l_sorted_attrs.item_for_iteration) ~ "BOOLEAN" then
					create {WEKA_ARFF_BOOLEAN_ATTRIBUTE} l_attr.make ("t." + l_sorted_attrs.item_for_iteration)
				elseif a_types.item (l_sorted_attrs.item_for_iteration).starts_with ("INTEGER_") then
					create {WEKA_ARFF_NUMERIC_ATTRIBUTE} l_attr.make ("t." + l_sorted_attrs.item_for_iteration)
				end

				l_target_attrs.extend (l_attr)

				l_sorted_attrs.forth
			end
			l_attrs := l_source_attrs.twin
			l_attrs.append (l_target_attrs)

				-- Build up instance data.
			create l_relation.make (l_attrs)
			l_relation.set_name (a_feature.associated_class.name + "." + a_feature.feature_.feature_name)
			l_transitions := transitions.item (a_feature)
			from
				l_transitions.start
			until
				l_transitions.after
			loop
				create l_values.make (l_attrs.count)
				l_data := l_transitions.item_for_iteration
				l_evaluation := l_data.source

				from
					l_sorted_attrs.start
				until
					l_sorted_attrs.after
				loop
					l_evaluation.search (l_sorted_attrs.item_for_iteration)
					if l_evaluation.found then
						l_values.extend (l_evaluation.found_item)
					else
						l_values.extend (once "?")
					end
					l_sorted_attrs.forth
				end

				l_evaluation := l_data.target
				from
					l_sorted_attrs.start
				until
					l_sorted_attrs.after
				loop
					l_evaluation.search (l_sorted_attrs.item_for_iteration)
					if l_evaluation.found then
						l_values.extend (l_evaluation.found_item)
					else
						l_values.extend (once "?")
					end
					l_sorted_attrs.forth
				end
				l_relation.extend (l_values)
				l_transitions.forth
			end
			if not l_attrs.is_empty then
				create l_file.make_create_read_write (a_file_name)
				l_relation.to_file (l_file)
				l_file.close
			end
		end

end
