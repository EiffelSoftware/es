note
	description: "Planer which plans the evaluation of expressions."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_EXPRESSION_EVALUATION_PLANER

inherit
	EPA_SHARED_EQUALITY_TESTERS
		export
			{NONE} all
		end

feature -- Access

	last_expression_evaluation_plan: DS_HASH_TABLE [DS_HASH_SET [INTEGER], EPA_EXPRESSION]
			-- Last expression evaluation plan.

feature -- Basic operations

	plan_from_localized_expressions (
		a_localized_expressions: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING];
		a_expressions: DS_HASH_SET [EPA_EXPRESSION]
	)
			-- Plan from localized expressions and make result available in
			-- `last_expression_evaluation_plan'.
		require
			a_localized_expressions_not_void: a_localized_expressions /= void
			a_expressions_not_void: a_expressions /= Void
			same_number_of_expressions: a_localized_expressions.count = a_expressions.count
		local
			l_expression: EPA_EXPRESSION
			l_expression_text: STRING
			l_program_locations: DS_HASH_SET [INTEGER]
		do
			create last_expression_evaluation_plan.make (a_expressions.count)
			last_expression_evaluation_plan.set_key_equality_tester (expression_equality_tester)

			-- Iterate over expressions.
			from
				a_expressions.start
			until
				a_expressions.after
			loop
				l_expression := a_expressions.item_for_iteration

				l_expression_text := l_expression.text

				-- Make sure that the current expression is a localized expression.
				check
					a_localized_expressions.has (l_expression_text)
				then
					-- Extend expression evaluation plan with current expression and its program
					-- locations.
					l_program_locations := a_localized_expressions.item (l_expression_text)
					last_expression_evaluation_plan.force_last (l_program_locations, l_expression)
				end

				a_expressions.forth
			end
		ensure
			last_expression_evaluation_plan_not_void: last_expression_evaluation_plan /= Void
			same_number_of_expressions: last_expression_evaluation_plan.count = a_expressions.count
		end

	plan_from_localized_variables (
		a_localized_variables: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING];
		a_expression_mapping: DS_HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], STRING]
	)
			-- Plan from localized variables and make result available in
			-- `last_expression_evaluation_plan'.
		require
			a_localized_variables_not_void: a_localized_variables /= Void
			a_expression_mapping_not_void: a_expression_mapping /= Void
			same_number_of_variables: a_localized_variables.count = a_expression_mapping.count
		local
			l_expression: EPA_EXPRESSION
			l_expressions: DS_HASH_SET [EPA_EXPRESSION]
			l_program_locations_for_expression: DS_HASH_SET [INTEGER]
			l_program_locations_for_variable: DS_HASH_SET [INTEGER]
		do
			create last_expression_evaluation_plan.make_default
			last_expression_evaluation_plan.set_key_equality_tester (expression_equality_tester)

			-- Iterate over variables.
			from
				a_expression_mapping.start
			until
				a_expression_mapping.after
			loop
				-- Retrieve expressions for current variable.
				l_expressions := a_expression_mapping.item_for_iteration

				-- Retrieve program locations for current variable.
				l_program_locations_for_variable :=
					a_localized_variables.item (a_expression_mapping.key_for_iteration)

				-- Iterate over expressions.
				from
					l_expressions.start
				until
					l_expressions.after
				loop
					l_expression := l_expressions.item_for_iteration

					-- Add program locations of current expression to the expression evaluation
					-- plan.
					if
						last_expression_evaluation_plan.has (l_expression)
					then
						l_program_locations_for_expression :=
							last_expression_evaluation_plan.item (l_expression)
						l_program_locations_for_variable.do_all (
							agent l_program_locations_for_expression.force_last
						)
					else
						create l_program_locations_for_expression.make (
							l_program_locations_for_variable.count
						)
						l_program_locations_for_variable.do_all (
							agent l_program_locations_for_expression.force_last
						)
						last_expression_evaluation_plan.force_last (
							l_program_locations_for_expression,
							l_expression
						)
					end

					l_expressions.forth
				end

				a_expression_mapping.forth
			end
		ensure
			last_expression_evaluation_plan_not_void: last_expression_evaluation_plan /= Void
			at_least_as_many_expressions_as_variables:
				last_expression_evaluation_plan.count >= a_localized_variables.count
		end

	plan_from_expressions_and_program_locations (
		a_expressions: DS_HASH_SET [EPA_EXPRESSION];
		a_program_locations: DS_HASH_SET [INTEGER]
	)
			-- Plan from program locations and make result available in
			-- `last_expression_evaluation_plan'.
		do
			create last_expression_evaluation_plan.make (a_expressions.count)
			last_expression_evaluation_plan.set_key_equality_tester (expression_equality_tester)

			-- Iterate over expressions.
			from
				a_expressions.start
			until
				a_expressions.after
			loop
				last_expression_evaluation_plan.force_last (
					a_program_locations,
					a_expressions.item_for_iteration
				)

				a_expressions.forth
			end
		ensure
			last_expression_evaluation_plan_not_void: last_expression_evaluation_plan /= Void
			same_number_of_expressions: last_expression_evaluation_plan.count = a_expressions.count
		end

end
