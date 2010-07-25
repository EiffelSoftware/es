note
	description: "Class containing test case data used for contract inference"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_TEST_CASE_DATA

inherit
	CI_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

create
	make

feature{NONE} -- Initialization

	make (a_transition_data: like transition_data)
			-- Initialize current.
		do
			transition_data := a_transition_data
			set_interface_transitions (interface_transitions_from_test_cases (transition_data))

			create transitions.make
			across transition_data as l_trans loop transitions.extend (l_trans.item.transition) end

			initialize_interface_expressions
		end

feature -- Access

	transition_data: LINKED_LIST [CI_TEST_CASE_TRANSITION_INFO]
			-- Transition data

	transitions: LINKED_LIST [SEM_TRANSITION]
			-- List of transitions in `transition_data'			

	interface_transitions: DS_HASH_TABLE [SEM_FEATURE_CALL_TRANSITION, CI_TEST_CASE_TRANSITION_INFO]
			-- Transitions that consist of only interface assertions
			-- Result is a table of interface transtions
			-- Key is test case, value is the interface transition adapted from the transition in that test case.
			-- The pre- and post-conditions of the interface transition only mentions operands in the feature.

	arff_relation: detachable WEKA_ARFF_RELATION
			-- ARFF relation

	interface_pre_expressions: HASH_TABLE [TYPE_A, STRING]
			-- Table from interface pre-state expressions to their types
			-- Key is an interface expression in anonymous format,
			-- value is type of that expression

	interface_post_expressions: HASH_TABLE [TYPE_A, STRING]
			-- Table from interface pre-state expressions to their types
			-- Key is an interface expression in anonymous format,
			-- value is type of that expression

	interface_expressions: HASH_TABLE [like interface_pre_expressions, BOOLEAN]
			-- Table of interface expressions
			-- Key is a boolean indicating pre-state or post-state.
			-- Value is the set of expressions associated with that state.
			-- See `interface_pre_expressions' for detailed information about the format of the value.

	interface_expression_changes: HASH_TABLE [BOOLEAN, STRING]
			-- Table to indicate if an interface expression ever changes in transitions
			-- Key is the anonymous format of an interface expression,
			-- value is a boolean indicator, True means that expression is changes in at least one test case,
			-- False means that the expression never changes.

	interface_pre_expression_values: HASH_TABLE [CI_HASH_SET [EPA_EXPRESSION_VALUE], STRING]
			-- Table from interface expression to its values in all `transitions' in pre-state
			-- Key is anonymous format of an expression in pre-state,
			-- value is a set of values that expression have in all transitions in pre-state.

	interface_post_expression_values: HASH_TABLE [CI_HASH_SET [EPA_EXPRESSION_VALUE], STRING]
			-- Table from interface expression to its values in all `transitions' in post-state
			-- Key is anonymous format of an expression in post-state,
			-- value is a set of values that expression have in all transitions in post-state.

	interface_expression_values: HASH_TABLE [like interface_pre_expression_values, BOOLEAN]
			-- Table of inteface expression values
			-- Key is a boolean indicating pre-state or post-state
			-- value is an expression to value table.							

feature -- Basic operations

	initialize_interface_expressions
			-- Initialize `interface_expressions'.
		local
			l_utility: SEM_UTILITY
			l_state: BOOLEAN
			l_assertions: EPA_STATE
			l_transition: SEM_TRANSITION
			l_anony_expr: STRING
			l_value_set: DS_HASH_SET [EPA_EXPRESSION_VALUE]
			l_expr_values: like interface_pre_expression_values
			l_cursor: like interface_transitions.new_cursor
			l_itrans: LINKED_LIST [SEM_FEATURE_CALL_TRANSITION]
		do
			create l_itrans.make
			from
				l_cursor := interface_transitions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_itrans.extend (l_cursor.item)
				l_cursor.forth
			end
			create l_utility
			interface_pre_expressions := l_utility.selected_expressions (l_itrans, True, False, Void)
			interface_post_expressions := l_utility.selected_expressions (l_itrans, False, False, Void)
			create interface_expressions.make (2)
			interface_expressions.put (interface_pre_expressions, True)
			interface_expressions.put (interface_post_expressions, False)
		end

	initialize_interface_expression_value_mapping
			-- Initialize `interface_expression_values'.
		local
			l_state: BOOLEAN
			l_transition: SEM_TRANSITION
			l_anony_expr: STRING
			l_value_set: CI_HASH_SET [EPA_EXPRESSION_VALUE]
			l_expr_values: like interface_pre_expression_values
			l_pre_state_values: HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			l_post_state_value: HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			l_state_values: HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			l_value: EPA_EXPRESSION_VALUE
			l_changes: like interface_expression_changes
		do
				-- Setup expression value related data structures.
			create interface_pre_expression_values.make (interface_pre_expressions.count)
			interface_pre_expression_values.compare_objects
			create interface_post_expression_values.make (interface_post_expressions.count)
			interface_post_expression_values.compare_objects
			create interface_expression_values.make (2)
			interface_expression_values.put (interface_pre_expression_values, True)
			interface_expression_values.put (interface_post_expression_values, False)

			across interface_pre_expressions as l_exprs loop
				create l_value_set.make (10)
				l_value_set.set_equality_tester (expression_value_equality_tester)
				interface_pre_expression_values.force (l_value_set, l_exprs.key)
			end

			create interface_expression_changes.make (interface_post_expressions.count)
			l_changes := interface_expression_changes
			l_changes.compare_objects
			across interface_post_expressions as l_exprs loop
				create l_value_set.make (10)
				l_value_set.set_equality_tester (expression_value_equality_tester)
				interface_post_expression_values.force (l_value_set, l_exprs.key)
				l_changes.put (False, l_exprs.key)
			end

				-- Loop over all transitions, for each transition, collec the set of values for each
				-- interface expression.
			across transitions as l_transitions loop
				l_transition := l_transitions.item
				create l_pre_state_values.make (interface_post_expressions.count)
				create l_post_state_value.make (interface_post_expressions.count)
				across <<True, False>> as l_states loop
					l_state := l_states.item
					l_expr_values := interface_expression_values.item (l_state)
					if l_state then
						l_state_values := l_pre_state_values
					else
						l_state_values := l_post_state_value
					end
						-- Loop over all interface expression in `l_state'.
					across interface_expressions.item (l_state) as l_exprs loop
						l_anony_expr := l_exprs.key
						if attached {EPA_EQUATION} l_transition.assertion_by_anonymouse_expression_text (l_anony_expr, l_state) as l_equation then
							l_value := l_equation.value
							l_expr_values.item (l_anony_expr).force_last (l_value)
							l_state_values.force (l_value, l_anony_expr)
						end
					end
				end

					-- Calculate which expressions are changed.
				across l_post_state_value as l_post_values loop
					l_anony_expr := l_post_values.key
					if not l_changes.item (l_anony_expr) then
						l_pre_state_values.search (l_anony_expr)
						l_changes.force (l_pre_state_values.not_found or else l_pre_state_values.found_item /~ l_post_values.item, l_anony_expr)
					end
				end
			end
		end

feature -- Setting

	set_transition_data (a_transition_data: like transition_data)
			-- Set `transition_data' with `a_transition_data'.
		do
			transition_data := a_transition_data
		ensure
			transition_data_set: transition_data = a_transition_data
		end

	set_interface_transitions (a_transitions: like interface_transitions)
			-- Set `interface_transitions' with `a_transitions'.
		do
			interface_transitions := a_transitions
		ensure
			interface_transitions_set: interface_transitions = a_transitions
		end

	set_arff_relation (a_relation: like arff_relation)
			-- Set `arff_relation' with `a_relation'.
		do
			arff_relation := a_relation
		ensure
			arff_relation_set: arff_relation = a_relation
		end

end
