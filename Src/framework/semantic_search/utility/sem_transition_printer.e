note
	description: "Printer to output transitions into other formats"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_TRANSITION_PRINTER

inherit
	EPA_SHARED_EQUALITY_TESTERS

	KL_SHARED_STRING_EQUALITY_TESTER

feature{NONE} -- Initialization

	make
			-- Initialize current
		do
			set_is_union_mode (False)
			create transitions.make
		end

	make_with_selection_function (a_function: like equation_selection_function)
			-- Initialize Current.
		do
			make
			set_equation_selection_function (a_function)
		end

feature -- Access

	transitions: LINKED_LIST [SEM_TRANSITION]
			-- Transitions to be translated as instances into Weka

	equation_selection_function: detachable PREDICATE [ANY, TUPLE [EPA_EQUATION]]
			-- Action to only select some expressions from a transition
			-- If this function returns True, the equation is selected, otherwise, not selected.
			-- If Void, all expressions from any transition is selected.

feature -- Status report

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

	is_absolute_change_included: BOOLEAN
			-- Should absolute changes be included as Weka attributes?
			-- Default: False

	is_relative_change_included: BOOLEAN
			-- Should relative changed be included as Weka attributes?
			-- Default: False

	is_transition_valid (a_transition: SEM_TRANSITION): BOOLEAN
			-- Is `a_transition' valid to be added into Current?
		deferred
		end

feature -- Setting

	set_equation_selection_function (a_function: like equation_selection_function)
			-- Set `equation_selection_function' with `a_function'.
		do
			equation_selection_function := a_function
		ensure
			equation_selection_function_set: equation_selection_function = a_function
		end

	set_is_union_mode (b: BOOLEAN)
			-- Set `is_union_mode' with `b'.
		do
			is_union_mode := b
		ensure
			is_union_mode_set: is_union_mode = b
		end

	set_is_absolute_change_included (b: BOOLEAN)
			-- Set `is_absolute_change_included' with `b'.
		do
			is_absolute_change_included := b
		ensure
			is_absolute_change_included_set: is_absolute_change_included = b
		end

	set_is_relative_change_included (b: BOOLEAN)
			-- Set `is_relative_change_included' with `b'.
		do
			is_relative_change_included := b
		ensure
			is_relative_change_included_set: is_relative_change_included = b
		end

	set_transitions (a_transitions: LINEAR [SEM_TRANSITION])
			-- Set `transitions' with `a_transitions'.
		do
			transitions.wipe_out
			extend_transitions (a_transitions)
		end

	extend_transition (a_transition: SEM_TRANSITION)
			-- Extend `a_transition' in Current as an instance in the target Weka relation.
		do
			transitions.extend (a_transition)
		ensure
			a_transition_extended: transitions.has (a_transition)
		end

	extend_transitions (a_transitions: LINEAR [SEM_TRANSITION])
			-- Extend `a_transitions' in Current as instances in the target Weka relation.
		do
			a_transitions.do_all (agent extend_transition)
		ensure
			a_transitions_extended: a_transitions.for_all (agent transitions.has)
		end

feature{NONE} -- Implementation

	pre_state_expressions: DS_HASH_TABLE [TYPE_A, STRING]
			-- Expressions that are used as preconditions
			-- Key is anonymous text representation, such as {0}.has ({1}), for those expressions.
			-- Value is type of the expression.
		do
			Result := selected_assertions (agent (a_transition: SEM_TRANSITION): EPA_STATE do Result := a_transition.interface_preconditions end)
		end

	post_state_expressions: DS_HASH_TABLE [TYPE_A, STRING]
			-- Expressions that are used as postconditions
			-- Key is anonymous text representation, such as {0}.has ({1}), for those expressions.
			-- Value is type of the expression.
		do
			Result := selected_assertions (agent (a_transition: SEM_TRANSITION): EPA_STATE do Result := a_transition.interface_postconditions end)
		end

	selected_assertions (a_attributes_retriever: FUNCTION [ANY, TUPLE [SEM_TRANSITION], EPA_STATE]): DS_HASH_TABLE [TYPE_A, STRING]
			-- Set of expressions that are to be translated into Weka attributes
			-- Elements in Result is anonymous expression names for those attributes.
		local
			l_frequence_tbl: DS_HASH_TABLE [INTEGER, STRING]
			l_type_tbl: DS_HASH_TABLE [TYPE_A, STRING]
			l_cursor: CURSOR
			l_state_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_selection_function: like equation_selection_function
			l_expression: EPA_EXPRESSION
			l_union_mode: BOOLEAN
			l_count: INTEGER
			l_anonymous_expr: STRING
			l_transition: SEM_TRANSITION
			l_state: EPA_STATE
		do
			l_selection_function := equation_selection_function
			create l_frequence_tbl.make (100)
			l_frequence_tbl.set_key_equality_tester (string_equality_tester)
			create l_type_tbl.make (100)
			l_type_tbl.set_key_equality_tester (string_equality_tester)

				-- Collect the number of times that each expression appears in all transitions.
			l_cursor := transitions.cursor
			from
				transitions.start
			until
				transitions.after
			loop
				from
					l_transition := transitions.item_for_iteration
					l_state := a_attributes_retriever.item ([l_transition])
					l_state_cursor := l_state.new_cursor
					l_state_cursor.start
				until
					l_state_cursor.after
				loop
					if l_selection_function = Void or else l_selection_function.item ([l_state_cursor.item]) then
						l_expression := l_state_cursor.item.expression
						l_anonymous_expr := l_transition.anonymous_expression_text (l_expression)
						l_frequence_tbl.force_last (l_frequence_tbl.item (l_anonymous_expr) + 1, l_anonymous_expr)
						l_type_tbl.force_last (l_expression.resolved_type (l_transition.context_type), l_anonymous_expr)
					end
					l_state_cursor.forth
				end
				transitions.forth
			end
			transitions.go_to (l_cursor)

				-- Collect all the expressions to be translated as attributes.
			create Result.make (l_frequence_tbl.count)
			Result.set_key_equality_tester (string_equality_tester)
			l_union_mode := is_union_mode

			from
				l_count := transitions.count
				l_frequence_tbl.start
			until
				l_frequence_tbl.after
			loop
				if l_union_mode or else (l_frequence_tbl.item_for_iteration = l_count) then
					Result.force_last (l_type_tbl.item (l_frequence_tbl.key_for_iteration), l_frequence_tbl.key_for_iteration)
				end
				l_frequence_tbl.forth
			end
		end

end
