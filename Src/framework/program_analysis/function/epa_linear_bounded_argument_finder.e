note
	description: "Class to find queries with an integer argument which is within a known range defined by the minimal and maximal values"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_LINEAR_BOUNDED_ARGUMENT_FINDER

inherit
	EPA_TYPE_UTILITY

	EPA_UTILITY

	SHARED_NAMES_HEAP

create
	make

feature{NONE} -- Initialization

	make (a_output_dir: STRING; a_context_type: detachable TYPE_A)
			-- Initialize Current.
			-- `a_output_dir' specifies the directory to store generated files.
		do
			output_directory := a_output_dir.twin
			context_type := a_context_type
		end

feature -- Access

	minimal_values: LINKED_LIST [EPA_EXPRESSION]
			-- Minimal values of the range for the bounded argument
			-- Empty if no such value exists.

	maximal_values: LINKED_LIST [EPA_EXPRESSION]
			-- Maximal value of the range for the bounded argument
			-- Empty if no such value exists.

	output_directory: STRING
			-- Directory to store generated files.

	context_type: detachable TYPE_A
			-- Context type in which types are resolved

feature -- Status report

	is_bound_found: BOOLEAN
			-- Is the last feature checked `analyze_bounds' satisfy the criterion
			-- that it has a single integer argument and that argument are linearly
			-- constrained within a range according to the precondition of that feature?

feature -- Basic operations

	analyze_bounds (a_context_class: CLASS_C; a_feature: FEATURE_I)
			-- Check if `a_feature' viewed from `a_context_class' satisfy the bounded
			-- single integer argument criterion. If so, set `is_bound_found' to True, and
			-- set `minimal_value' and `maximal_value' accordingly.
		local
			l_done: BOOLEAN
			l_expr: EPA_AST_EXPRESSION
			l_preconditions: LIST [EPA_EXPRESSION]
			l_pre_feat: LIST [TUPLE [expr: EPA_EXPRESSION; feat: FEATURE_I]]
		do
			is_bound_found := False
			create minimal_values.make
			create maximal_values.make

			l_done := (not a_feature.has_return_value) or (a_feature.argument_count /= 1)
			if not l_done then
					-- Check if the argument is of type INTEGER.
				create l_expr.make_with_text (a_context_class, a_feature, a_feature.arguments.item_name (1), a_feature.written_class)
				l_done := not l_expr.resolved_type (context_type).is_integer
			end

			if not l_done then
					-- Check if `a_feature' has precondition. If it does not have precondition,
					-- the integer argument is considered unbounded.
				l_preconditions := contract_extractor.precondition_of_feature (a_feature, a_context_class)
				l_done := l_preconditions.is_empty
			end

				-- Check if there is a precondition which bounds the integer argument.
			if not l_done then
				check_bouding_assertions (l_expr, l_preconditions, a_context_class, a_feature)
				if not is_bound_found then
						-- Check if there is a precondition which is query over the integer argument,
						-- if so, check if we can learn from the postcondition of that precondition query,
						-- to see if the integer argument is bounded.
					l_pre_feat := single_query_over_argument (l_expr, a_context_class, a_feature, l_preconditions)
					if l_pre_feat /= Void then
						l_preconditions := postconditions_as_preconditions (l_expr, l_pre_feat, a_context_class, a_feature)
						if l_preconditions /= Void then
							check_bouding_assertions (l_expr, l_preconditions, a_context_class, a_feature)
						end
					end
				end
			end
		end

feature{NONE} -- Implementation

	check_bouding_assertions (a_argument: EPA_EXPRESSION; a_assertions: LIST [EPA_EXPRESSION]; a_context_class: CLASS_C; a_feature: FEATURE_I)
			-- Check if there is an assertion in `a_assertions' which bounds the single integer argument.
			-- `a_argument' is the integer argument which should be bounded in both ends.
		local
			l_constraints: LINKED_LIST [EPA_NUMERIC_CONSTRAINTS]
		do
			l_constraints := linear_constraints_from_assertions (a_assertions)
			from
				l_constraints.start
			until
				l_constraints.after or else is_bound_found
			loop
				if attached {like argument_bounds} argument_bounds (a_argument, l_constraints.item_for_iteration, a_context_class, a_feature) as l_bounds  then
					is_bound_found := True
					minimal_values := l_bounds.lower_bounds
					maximal_values := l_bounds.upper_bounds
				end
				l_constraints.forth
			end
		end

	argument_bounds (a_argument: EPA_EXPRESSION; a_constraint: EPA_NUMERIC_CONSTRAINTS; a_context_class: CLASS_C; a_feature: FEATURE_I): detachable TUPLE [lower_bounds: LINKED_LIST [EPA_EXPRESSION]; upper_bounds: LINKED_LIST [EPA_EXPRESSION]]
			-- Lower and upper bounds of `a_argument' by `a_constraint'
			-- If either lower or upper bound does not exist, return Void.
			-- `a_argument' is a formal argument in `a_feature' viewed from `a_context_class'.
		local
			l_finder: EPA_RELAVANT_LINEAR_CONSTRAINT_FINDER
			l_relevant_assertions: DS_HASH_SET [EPA_EXPRESSION]

			l_relevant_constraints: EPA_NUMERIC_CONSTRAINTS
			l_constraint_table: DS_HASH_TABLE [EPA_NUMERIC_CONSTRAINTS, EPA_EXPRESSION]
			l_constraining_expressions: LINKED_LIST [EPA_EXPRESSION]

			l_solver: EPA_MATHEMATICA_SYMBOLIC_CONSTRAINT_SOLVER
			l_args: LINKED_LIST [EPA_EXPRESSION]
			l_constraining_exprs: LINKED_LIST [EPA_EXPRESSION]
			l_min: LINKED_LIST [EPA_EXPRESSION]
			l_max: LINKED_LIST [EPA_EXPRESSION]
			l_set1, l_set2: DS_HASH_SET [EPA_EXPRESSION]
		do
				-- Get candidate assertions.
			l_set1 := contract_extractor.precondition_expression_set (a_context_class, a_feature)
			l_set2 := contract_extractor.invariant_expression_set (a_context_class, True)
			l_relevant_assertions := l_set1.union (l_set2)
--				contract_extractor.precondition_expression_set (a_context_class, a_feature).union (contract_extractor.invariant_expression_set (a_context_class, True))

				-- Find assertions relevant to `a_constraint'.
			create l_finder
			l_finder.calculate (a_constraint, l_relevant_assertions)
			l_relevant_constraints := l_finder.relevant_constraints
			l_constraint_table := l_finder.constraint_table
			l_constraining_expressions := l_finder.constraining_expressions

			create l_args.make
			l_args.extend (a_argument)
			create l_constraining_exprs.make
			l_constraint_table.keys.do_all (agent l_constraining_exprs.extend)

			create l_solver.make (output_directory)

				-- Find the maximal and minimal value for the argument.
			l_solver.maximize (a_argument, l_constraining_exprs, l_args)
			l_max := values_from_solver (l_solver)
			if not l_max.is_empty then
				l_solver.minimize (a_argument, l_constraining_exprs, l_args)
				l_min := values_from_solver (l_solver)
			end

			if not l_max.is_empty and not l_min.is_empty then
				Result := [l_min, l_max]
			end
		end

	values_from_solver (a_solver: EPA_MATHEMATICA_SYMBOLIC_CONSTRAINT_SOLVER): LINKED_LIST [EPA_EXPRESSION]
			-- values from `a_solve'.`last_solution'
			-- Return Void if there is no such value
		do
			create Result.make
			if attached {HASH_TABLE [TUPLE [conditions: LINKED_LIST [EPA_EXPRESSION]; argument_valuations: HASH_TABLE [EPA_EXPRESSION, EPA_EXPRESSION]], EPA_EXPRESSION]} a_solver.last_solutions  as l_solutions then
				if not l_solutions.is_empty then
					from
						l_solutions.start
					until
						l_solutions.after
					loop
						Result.extend (l_solutions.key_for_iteration)
						l_solutions.forth
					end
				end
			end
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

	single_query_over_argument (a_argument: EPA_EXPRESSION; a_context_class: CLASS_C; a_feature: FEATURE_I; a_preconditions: LIST [EPA_EXPRESSION]): LIST [TUPLE [expr: EPA_EXPRESSION; feature_: FEATURE_I]]
			-- List of expressions from `a_preconditions' which consists a single query over the argument of `a_feature' viewed from `a_context_class'
			-- Return an empty list if no such expression exists in `a_preconditions'.
		local
			l_cursor: CURSOR
			l_expr: EXPR_AS
		do
			create {LINKED_LIST [TUPLE [EPA_EXPRESSION, FEATURE_I]]} Result.make
			l_cursor := a_preconditions.cursor
			from
				a_preconditions.start
			until
				a_preconditions.after
			loop
				l_expr := a_preconditions.item_for_iteration.ast
				if attached {EXPR_CALL_AS} l_expr as l_call_as then
					if attached {ACCESS_ID_AS} l_call_as.call as l_access_id_as then
						if attached {EIFFEL_LIST [EXPR_AS]} l_access_id_as.parameters as l_arguments and then l_arguments.count = 1 then
							if text_from_ast (l_arguments.first) ~ a_argument.text then
								Result.extend ([a_preconditions.item_for_iteration, a_context_class.feature_named (names_heap.item (l_access_id_as.feature_name.name_id))])
							end
						end
					end
				end
				a_preconditions.forth
			end
			a_preconditions.go_to (l_cursor)
		end

	postconditions_as_preconditions (a_argument: EPA_EXPRESSION; a_precondition_features: like single_query_over_argument; a_context_class: CLASS_C; a_feature: FEATURE_I): LIST [EPA_EXPRESSION]
			-- List of assertions that are derived from postconditions of `a_precondition_features'.
		local
			l_cursor: CURSOR
			l_finder: EPA_QUERY_POSTCONDITION_FINDER
			l_rewriter: EPA_CONTRACT_REWRITE_VISITOR
			l_asserts: LINKED_LIST [EPA_EXPRESSION]
			l_feat: FEATURE_I
			l_arg_tbl: HASH_TABLE [STRING_8, INTEGER_32]
		do
			create {LINKED_LIST [EPA_EXPRESSION]} Result.make
			create l_finder
			create l_rewriter
			create l_arg_tbl.make (1)
			l_arg_tbl.put (a_argument.text, 1)
			l_cursor := a_precondition_features.cursor
			from
				a_precondition_features.start
			until
				a_precondition_features.after
			loop
				l_feat := a_precondition_features.item_for_iteration.feature_
				l_finder.find (a_context_class, l_feat)
				l_asserts := l_finder.expressions
				if not l_asserts.is_empty then
					from
						l_asserts.start
					until
						l_asserts.after
					loop
						l_rewriter.rewrite (l_asserts.item_for_iteration.ast, l_feat, l_feat.written_class, a_context_class, "", l_arg_tbl)
						Result.extend (create {EPA_AST_EXPRESSION}.make_with_text (a_context_class, a_feature, l_rewriter.assertion, a_context_class))
						l_asserts.forth
					end
				end
				a_precondition_features.forth
			end
			a_precondition_features.go_to (l_cursor)
		end

end
