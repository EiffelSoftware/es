note
	description: "Printer to output a set of transitions into Weka ARFF format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TRANSITION_TO_WEKA_PRINTER

inherit
	EPA_SHARED_EQUALITY_TESTERS

create
	make,
	make_with_selection_function

feature{NONE} -- Initialization

	make (a_context: like context)
			-- Initialize current with `a_context'.
		do
			context := a_context
		ensure
			context_set: context = a_context
		end

	make_with_selection_function (a_context: like context; a_function: like equation_selection_function)
			-- Initialize Current.
		do
			make (a_context)
			set_equation_selection_function (a_function)
		end

feature -- Access

	context: SEM_TRANSITION_CONTEXT
			-- Context in which transitions are type checked

	transitions: LINKED_LIST [SEM_TRANSITION]
			-- Transitions to be translated as instances into Weka

	is_union_mode: BOOLEAN
			-- If `transitions' have different pre-/postcondition expressions,
			-- should the Weka relation contain the union of all the different expressions?
			-- Attributes that do not appear in certain transitions are treated as missing values.

	is_intersection_mode: BOOLEAN
			-- If `transitions' have different pre-/postcondition expression,
			-- should the Weka relation only contain the intersection of all the expression?
		do
			Result := not is_union_mode
		ensure
			good_result: Result = not is_union_mode
		end

	equation_selection_function: detachable PREDICATE [ANY, TUPLE [EPA_EQUATION]]
			-- Action to only select some expressions from a transition
			-- If this function returns True, the equation is selected, otherwise, not selected.
			-- If Void, all expressions from any transition is selected.

feature -- Status report

	is_transition_valid (a_transition: SEM_TRANSITION): BOOLEAN
			-- Is `a_transition' valid to be added into Current?
		local
			l_agent: FUNCTION [ANY, TUPLE [EPA_EQUATION], BOOLEAN]
		do
			l_agent :=
				agent (a_equation: EPA_EQUATION): BOOLEAN
					do
						Result :=
							attached equation_selection_function as l_function implies l_function.item ([a_equation]) and
							((a_equation.value.is_boolean or
							a_equation.value.is_integer)) and
							a_equation.value.is_deterministic
					end

			Result :=
				a_transition.precondition.for_all (l_agent) and then
				a_transition.postcondition.for_all (l_agent)
		end

feature -- Basic operations

	set_is_union_mode (b: BOOLEAN)
			-- Set `is_union_mode' with `b'.
		do
			is_union_mode := b
		ensure
			is_union_mode_set: is_union_mode = b
		end

	set_equation_selection_function (a_function: like equation_selection_function)
			-- Set `equation_selection_function' with `a_function'.
		do
			equation_selection_function := a_function
		ensure
			equation_selection_function_set: equation_selection_function = a_function
		end

	extend_transition (a_transition: SEM_TRANSITION)
			-- Extend `a_transition' in Current as an instance in the target Weka relation.
		require
			a_transitio_valid: is_transition_valid (a_transition)
		do
			transitions.extend (a_transition)
		ensure
			a_transition_extended: transitions.has (a_transition)
		end

	extend_transitions (a_transitions: LINEAR [SEM_TRANSITION])
			-- Extend `a_transitions' in Current as instances in the target Weka relation.
		require
			a_transitions_valid: a_transitions.for_all (agent is_transition_valid)
		do
			a_transitions.do_all (agent extend_transition)
		ensure
			a_transitions_extended: a_transitions.for_all (agent transitions.has)
		end

feature{NONE} -- Implementation

	precondition_attributes: EPA_HASH_SET [EPA_EXPRESSION]
			-- Attributes that are used as preconditions
		do
			Result := attributes (agent (a_transition: SEM_TRANSITION): EPA_STATE do Result := a_transition.precondition end)
		end

	postcondition_attributes: EPA_HASH_SET [EPA_EXPRESSION]
			-- Attributes that are used as postconditions
		do
			Result := attributes (agent (a_transition: SEM_TRANSITION): EPA_STATE do Result := a_transition.postcondition end)
		end

	attributes (a_attributes_retriever: FUNCTION [ANY, TUPLE [SEM_TRANSITION], EPA_STATE]): EPA_HASH_SET [EPA_EXPRESSION]
			-- Set of expressions that are to be translated into Weka attributes
		local
			l_frequence_tbl: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
			l_cursor: CURSOR
			l_state_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_selection_function: like equation_selection_function
			l_expression: EPA_EXPRESSION
			l_union_mode: BOOLEAN
			l_count: INTEGER
		do
			l_selection_function := equation_selection_function
			create l_frequence_tbl.make (100)
			l_frequence_tbl.set_key_equality_tester (expression_equality_tester)

				-- Collect the number of times that each expression appears in all transitions.
			l_cursor := transitions.cursor
			from
				transitions.start
			until
				transitions.after
			loop
				from
					l_state_cursor := a_attributes_retriever.item ([transitions.item_for_iteration]).new_cursor
					l_state_cursor.start
				until
					l_state_cursor.after
				loop
					if l_selection_function = Void or else l_selection_function.item ([l_state_cursor.item]) then
						l_expression :=	l_state_cursor.item.expression
						l_frequence_tbl.force_last (l_frequence_tbl.item (l_expression) + 1, l_expression)
					end
					l_state_cursor.forth
				end
				transitions.forth
			end
			transitions.go_to (l_cursor)

				-- Collect all the expressions to be translated as attributes.
			create Result.make (l_frequence_tbl.count)
			Result.set_equality_tester (expression_equality_tester)

			from
				l_count := transitions.count
				l_frequence_tbl.start
			until
				l_frequence_tbl.after
			loop
				if l_union_mode or else (l_frequence_tbl.item_for_iteration = l_count) then
					Result.force_last (l_frequence_tbl.key_for_iteration)
				end
				l_frequence_tbl.forth
			end
		end

end
