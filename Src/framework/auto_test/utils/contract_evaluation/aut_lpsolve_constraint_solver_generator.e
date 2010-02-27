note
	description: "Summary description for {AUT_LPSOLVE_CONSTRAINT_SOLVER_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_LPSOLVE_CONSTRAINT_SOLVER_GENERATOR

inherit
	AUT_PREDICATE_UTILITY

	AST_ITERATOR
		redefine
			process_binary_as,
			process_unary_as,
			process_integer_as,
			process_access_feat_as
		end

	SHARED_SERVER

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER

	AUT_SHARED_RANDOM

	REFACTORING_HELPER

feature -- Access

	constraining_queries: DS_HASH_SET [STRING]
			-- List of constraining query names.

	constrained_operands: DS_HASH_SET [STRING]
			-- Set of name of constrained operands
			-- The names are arguments of the feature (not predicate argument names).

	assertions: DS_LINKED_LIST [TUPLE [assertion: AUT_EXPRESSION; pattern: AUT_PREDICATE_ACCESS_PATTERN]]
			-- Assertions of all the linearly solvable preconditions

	last_lpsolve: STRING
			-- lpsolve format from the last `generate_lpsolve' call
			-- Only has effect if `has_linear_constraints' is True.

feature -- Status report

	has_linear_constraints: BOOLEAN
			-- Does the last feature processed by `generate' have linear constraints?

	has_unsupported_expression: BOOLEAN
			-- Do the analysis assertions cantains unsupported expressions for lpsolve?
			-- For example "*", "/".

feature -- Basic operations

	generate_lpsolve (a_feature: AUT_FEATURE_OF_TYPE; a_patterns: like access_patterns; a_solver_config: TEST_GENERATOR_CONF_I) is
			-- Generate lpsolve format to solve linear constrains in preconditions in `a_feature'.
			-- `a_patterns' are access patterns of preconditions for that feature.
			-- `a_solver_config' is the configuration of the solver
			-- If there is any linear constraints for `a_feature', set `has_linear_constraints' to True and then
			-- generate the lpsolve format into `last_lpsolve'.
		local
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, INTEGER]
		do
			has_unsupported_expression := False
			current_feature := a_feature
			access_patterns := a_patterns
			solver_configuration := a_solver_config

				-- Collect constrained operands, constraining queries and assertion predicates.
			constrained_operands := constrained_operands_from_access_patterns (a_patterns)
			constraining_queries :=  constraining_queries_from_access_patterns (a_patterns)
			assertions := assertions_from_access_patterns (a_patterns)
			has_linear_constraints := not constrained_operands.is_empty

			if has_linear_constraints then
				create last_lpsolve.make (1024)
				generate_feature_comment (a_feature)
				generate_constraints
				generate_bound_var_placeholders
				generate_var_declarations
			end
		end

feature{NONE} -- Implementation

	solver_configuration: TEST_GENERATOR_CONF_I
			-- Configuration of the solver

	current_feature: AUT_FEATURE_OF_TYPE
			-- Current feature whose linearly solvable precondition
			-- is to be generated as a SMT-LIB file

	current_match_list: LEAF_AS_LIST
			-- Match list of current processed assertion

	current_written_class: CLASS_C
			-- Written class of currently processed assertion

	current_context_class: CLASS_C
			-- Context class of currently processed assertion

	access_patterns: DS_LINEAR [AUT_PREDICATE_ACCESS_PATTERN]
			-- Access patterns of `current_feature'

	current_name: STRING is "current"

	current_access_pattern: AUT_PREDICATE_ACCESS_PATTERN
			-- Access pattern for current processed predicate assertion

feature{NONE} -- Process

	process_binary_as (l_as: BINARY_AS)
		local
			l_operator: STRING
		do
				-- Get operator for current binary expression.
			l_operator := normalized_string (l_as.operator (current_match_list).text (current_match_list))
			if
				l_operator.is_equal ("and then") or else
				l_operator.is_equal ("and")
			then
					-- lines are always ANDed
				l_operator := ";%N"
			elseif
				l_operator.is_equal ("<") or else
				l_operator.is_equal ("<=") or else
				l_operator.is_equal ("=") or else
				l_operator.is_equal (">") or else
				l_operator.is_equal (">=") or else
				l_operator.is_equal ("-") or else
				l_operator.is_equal ("+")
			then
					-- do nothing
			else
				has_unsupported_expression := True
				fixme ("unsupported operator: " + l_operator)
			end

			l_as.left.process (Current)
			last_lpsolve.append (l_operator)
			l_as.right.process (Current)
		end

	process_unary_as (l_as: UNARY_AS)
		local
			l_operator: STRING
		do
			l_operator := normalized_string (l_as.operator (current_match_list).text (current_match_list))
			has_unsupported_expression := True
			fixme ("unsupported operator: " + l_operator)
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			last_lpsolve.append (l_as.integer_32_value.out)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_feature: detachable FEATURE_I
			l_arg_name: detachable STRING
			i: INTEGER
		do
			l_feature := final_feature (l_as.feature_name.name, current_written_class, current_context_class)
			if l_feature /= Void then
				last_lpsolve.append (normalized_string (l_feature.feature_name))
			else
					-- Can be an argument.
				i := final_argument_index (l_as.access_name, current_feature.feature_, current_written_class)
				if i > 0 then
					last_lpsolve.append (normalized_argument_name (i))
				else
					last_lpsolve.append (l_as.access_name)
				end
			end
		end

feature{NONE} -- Generation

	generate_feature_comment (a_feature: AUT_FEATURE_OF_TYPE) is
			-- Generate a simple comment indicating which feature on which type the predicates belong to
		do
			last_lpsolve.append ("%N/* " + a_feature.debug_output + " */%N")
		end


	generate_constraints is
			-- Generate the constraints part of the lpsolve format.
		local
			l_data: TUPLE [assertion: AUT_EXPRESSION; pattern: AUT_PREDICATE_ACCESS_PATTERN]
			l_integer_lower_bound: INTEGER_32
			l_integer_upper_bound: INTEGER_32
		do
			from
				assertions.start
			until
				assertions.after
			loop
				l_data := assertions.item_for_iteration
				current_access_pattern := l_data.pattern
				current_written_class := current_access_pattern.assertion.written_class
				current_context_class := current_access_pattern.assertion.context_class
				current_match_list := match_list_server.item (current_written_class.class_id)
				current_access_pattern.assertion.ast.process (Current)
				last_lpsolve.append (";%N")
				assertions.forth
			end
			last_lpsolve.append ("%N")

			from
				constrained_operands.start
			until
				constrained_operands.after
			loop
				random.forth
				if random.item \\ 100 = 0 then
						-- with 0.01 probability choose {INTEGER_16} boundaries
					l_integer_lower_bound := {INTEGER_16}.min_value
					l_integer_upper_bound := {INTEGER_16}.max_value
				else
						-- with 0.99 probability choose command line boundaries
					l_integer_lower_bound := solver_configuration.integer_lower_bound
					l_integer_upper_bound := solver_configuration.integer_upper_bound
				end

				last_lpsolve.append (l_integer_lower_bound.out + "<=" + constrained_operands.item_for_iteration + "<=" + l_integer_upper_bound.out + ";%N")
				constrained_operands.forth
			end
			last_lpsolve.append ("%N")
		end

	generate_bound_var_placeholders is
			-- Generate placeholders that will get replaced when variables are bound
		do
			from
				constrained_operands.start
			until
				constrained_operands.after
			loop
				last_lpsolve.append ("/*placeholder_")
				last_lpsolve.append (constrained_operands.item_for_iteration)
				last_lpsolve.append ("*/%N")
				constrained_operands.forth
			end

			last_lpsolve.append ("%N")
		end

	generate_var_declarations is
			-- Generate the variables declarations part of the lpsolve format.
		do
			from
				constrained_operands.start
			until
				constrained_operands.after
			loop
				last_lpsolve.append ("int ")
				last_lpsolve.append (constrained_operands.item_for_iteration)
				last_lpsolve.append (";")
				last_lpsolve.append ("%N")
				constrained_operands.forth
			end

			last_lpsolve.append ("%N")
		end

	final_argument_name (a_name: STRING; a_feature: FEATURE_I; a_written_class: CLASS_C): detachable STRING is
			-- Final name of the argument `a_name' in `a_feature'
		local
			i: INTEGER
		do
			i := final_argument_index (a_name, a_feature, a_written_class)
			if i > 0 then
				Result := a_feature.arguments.item_name (i)
			end
		end
		
	normalized_string (a_string: STRING): STRING is
			-- Normalized version of `a_string'.
			-- Normalization means remoing all leading and trailing
			-- spaces, and turning all letters in non-capital ones.
		require
			a_string_attached: a_string /= Void
		do
			Result := a_string.as_lower
			Result.left_adjust
			Result.right_adjust
		ensure
			result_attached: Result /= Void
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
