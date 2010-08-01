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

	SEM_UTILITY

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

	equation_selection_function: detachable PREDICATE [ANY, TUPLE [equation: EPA_EQUATION; transition: SEM_TRANSITION; pre_state: BOOLEAN]]
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

	pre_state_expressions: like selected_expressions
			-- Expressions that are used as preconditions
			-- Key is anonymous text representation, such as {0}.has ({1}), for those expressions.
			-- Value is type of the expression.
		do
			Result := selected_expressions (transitions, True, is_union_mode, equation_selection_function)
		end

	post_state_expressions: like selected_expressions
			-- Expressions that are used as postconditions
			-- Key is anonymous text representation, such as {0}.has ({1}), for those expressions.
			-- Value is type of the expression.
		do
			Result := selected_expressions (transitions, False, is_union_mode, equation_selection_function)
		end

end
