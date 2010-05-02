note
	description: "Class to find queries with an integer argument which is within a known range defined by the minimal and maximal values"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_LINEAR_BOUNDED_ARGUMENT_FINDER

inherit
	EPA_TYPE_UTILITY

	EPA_UTILITY

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create contract_extractor
		end

feature -- Access

	minimal_value: detachable EPA_EXPRESSION
			-- Minimal value of the range for the bounded argument
			-- Void means no such value exists

	maximal_value: detachable EPA_EXPRESSION
			-- Maximal value of the range for the bounded argument
			-- Void means no such value exists

feature -- Status report

	is_matched: BOOLEAN
			-- Is the last feature checked `check_feature' satisfy the criterion
			-- that it has a single integer argument and that argument are linearly
			-- constrained within a range according to the precondition of that feature?

feature -- Basic operations

	check_feature (a_context_class: CLASS_C; a_feature: FEATURE_I)
			-- Check if `a_feature' viewed from `a_context_class' satisfy the bounded
			-- single integer argument criterion. If so, set `is_matched' to True, and
			-- set `minimal_value' and `maximal_value' accordingly.
		local
			l_done: BOOLEAN
			l_expr: EPA_AST_EXPRESSION
			l_preconditions: LIST [EPA_EXPRESSION]
		do
			is_matched := False
			minimal_value := Void
			maximal_value := Void

			l_done := (not a_feature.has_return_value) or (a_feature.argument_count /= 1)
			if not l_done then
					-- Check if the argument is of type INTEGER.
				create l_expr.make_with_text (a_context_class, a_feature, a_feature.arguments.item_name (1), a_feature.written_class)
				l_done := not l_expr.resolved_type.is_integer
			end

			if not l_done then
					-- Check if `a_feature' has precondition. If it does not have precondition,
					-- the integer argument is considered unbounded.
				l_preconditions := contract_extractor.precondition_of_feature (a_feature, a_context_class)
				l_done := l_preconditions.is_empty
			end

				-- Check if there is a precondition which bounds the integer argument.
			if not l_done then
				check_bouding_assertions (l_expr, l_preconditions)
				if not is_matched then
						-- Check if there is a precondition which is query over the integer argument,
						-- if so, check if we can learn from the postcondition of that precondition query,
						-- to see if the integer argument is bounded.

				end
			end
		end

feature{NONE} -- Implementation

	contract_extractor: EPA_CONTRACT_EXTRACTOR
			-- Contract extractor

feature{NONE} -- Implementation

	check_bouding_assertions (a_argument: EPA_EXPRESSION; a_assertions: LIST [EPA_EXPRESSION])
			-- Check if there is an assertion in `a_assertions' which bounds the single integer argument.
			-- `a_argument' is the integer argument which should be bounded in both ends.
		local
			l_constraints: LINKED_LIST [EPA_NUMERIC_CONSTRAINTS]
		do
			l_constraints := linear_constraints_from_assertions (a_assertions)
			from
				l_constraints.start
			until
				l_constraints.after or else is_matched
			loop
				if attached {like argument_bounds} argument_bounds (a_argument, l_constraints.item_for_iteration) as l_bounds  then
					is_matched := True
					minimal_value := l_bounds.lower_bound
					maximal_value := l_bounds.upper_bound
				end
				l_constraints.forth
			end
		end

	argument_bounds (a_argument: EPA_EXPRESSION; a_constraint: EPA_NUMERIC_CONSTRAINTS): detachable TUPLE [lower_bound: EPA_EXPRESSION; upper_bound: EPA_EXPRESSION]
			-- Lower and upper bounds of `a_argument' by `a_constraint'
			-- If either lower or upper bound does not exist, return Void.
		do

		end

	linear_constraints_from_assertions (a_assertions: LIST [EPA_EXPRESSION]): LINKED_LIST [EPA_NUMERIC_CONSTRAINTS]
			-- Linear constraints from `a_assertions'
			-- Return an empty list if there is no such constraints.
		local
			l_analyzer: EPA_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER
			l_cursor: CURSOR
		do
				-- Find out all linearly constrained assertions from `a_assertions'.
			create Result.make
			create l_analyzer
			l_cursor := a_assertions.cursor
			from
				a_assertions.start
			until
				a_assertions.after
			loop
				l_analyzer.analyze (a_assertions.item_for_iteration)
				if l_analyzer.is_matched then
					Result.extend (l_analyzer.constraints)
				end
				a_assertions.forth
			end
			a_assertions.go_to (l_cursor)
		end

end
