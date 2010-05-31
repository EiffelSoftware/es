note
	description: "Summary description for {AUT_LINEAR_CONSTRAINT_SOLVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_LINEAR_CONSTRAINT_SOLVER

inherit
	SHARED_WORKBENCH

	AUT_PREDICATE_UTILITY

	AUT_SHARED_RANDOM

feature{NONE} -- Initialization

	make (a_feature: like feature_; a_linear_solvable_predicates: like linear_solvable_predicates; a_context_queries: like context_queries; a_config: like configuration) is
			-- Initialize.
		require
			a_feature_attached: a_feature /= Void
			a_linear_solvable_predicates_attached: a_linear_solvable_predicates /= Void
			not_a_linear_solvable_predicates_is_empty: not a_linear_solvable_predicates.is_empty
			a_context_queries_attached: a_context_queries /= Void
			a_config_attached: a_config /= Void
		do
			feature_ := a_feature
			linear_solvable_predicates := a_linear_solvable_predicates
			context_queries := a_context_queries
			linear_solvable_operands := constrained_operands_from_access_patterns (linear_solvable_predicates)
			configuration := a_config
		ensure
			feature__set: feature_ = a_feature
			linear_solvable_predicates_set: linear_solvable_predicates = a_linear_solvable_predicates
			constraining_queries_set: context_queries = a_context_queries
			linear_solvable_operands_set: linear_solvable_operands /= Void
			configuration_set: configuration = a_config
		end

feature -- Access

	feature_: AUT_FEATURE_OF_TYPE
			-- Feature for which the linear constraint is solved

	linear_solvable_predicates: DS_LINKED_LIST [AUT_PREDICATE_ACCESS_PATTERN]
			-- Linear solvable predicates associated with their access patterns

	context_queries: HASH_TABLE [STRING, STRING]
			-- Table of contraining queries and their values
			-- [Query value, query name]
			-- For example, in precondition "0 < i and then i < count",
			-- query "count" is a context query'.

	last_solution: DS_HASH_TABLE [INTEGER, INTEGER]
			-- Table of last linearly sovled operands
			-- [operand value, operand index]
			-- Operand index is 0-based, but in here the operand is already larger than 0,
			-- because linear constraint solving for target operand is not supported.
			-- Only has effect if `has_last_solution' is True

	configuration: TEST_GENERATOR
			-- Configuration of current test session

feature -- Status report

	has_last_solution: BOOLEAN
			-- Does last call to `solve' generated a solution?

	is_input_format_correct: BOOLEAN
			-- Is the last generated linear solver of the correct format?

feature -- Basic operations

	solve is
			-- Try to solve constraints defined in `linear_solvable_predicates' and `context_queries'.
			-- If there is a solution, set `has_last_solution' to True and put that solution into
			-- `last_solution'. Otherwise, set `has_last_solution' to False.
		deferred
		end

feature{NONE} -- Implementation

	linear_solvable_operands: DS_HASH_SET [STRING]
			-- Names of linearly solvable arguments

	set_last_solution (a_valuation: HASH_TABLE [INTEGER, STRING]) is
			-- Set `last_solution' with `a_valuation'.
		require
			a_valuation_attached: a_valuation /= Void
		local
			l_arg_name: STRING
		do
			create last_solution.make (a_valuation.count)
			from
				a_valuation.start
			until
				a_valuation.after
			loop
				l_arg_name := a_valuation.key_for_iteration.twin
				l_arg_name.replace_substring_all (normalized_argument_name_prefix, "")

				last_solution.force_last (a_valuation.item_for_iteration, l_arg_name.to_integer)
				a_valuation.forth
			end
		ensure
			last_solution_attached: last_solution /= Void
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
