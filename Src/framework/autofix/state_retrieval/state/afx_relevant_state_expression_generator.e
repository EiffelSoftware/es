note
	description: "Summary description for {AFX_RELEVANT_STATE_PREDICATE_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_RELEVANT_STATE_EXPRESSION_GENERATOR

feature -- Generation

	generate (a_spot: AFX_TEST_CASE_INFO; a_expressions: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION])
			-- Generate expressions that are relevant to `a_spot' and
			-- store result in `a_expressions'.
			-- Ranking of expressions alreadys in `a_expressions' before `generate' may also get updated
			-- according the policy encoded in current generator.
			-- `a_expressions' stores expressions as well as their rankings.
			-- Key is the expression, value is the ranking of that expression
			-- indicating its degree of relevance.
		require
			a_expressions_compare_objects: a_expressions.object_comparison
		deferred
		end

feature{NONE} -- Implementation

	update_expressions_with_ranking (a_expressions: HASH_TABLE [AFX_EXPR_RANK, EPA_EXPRESSION]; a_new_exprs: DS_HASH_SET [EPA_EXPRESSION]; a_ranking: INTEGER)
			-- Add `a_new_exprs' into `a_expressions' with `a_ranking' into `a_expression'.
			-- If some expression already in `a_expressions' but `a_ranking' is higher than the original ranking,
			-- update it with `a_ranking'.
		local
			l_expr: EPA_EXPRESSION
			l_rank: AFX_EXPR_RANK
		do
			from
				a_new_exprs.start
			until
				a_new_exprs.after
			loop
				create l_rank.make ({AFX_EXPR_RANK}.rank_implication)
				l_expr := a_new_exprs.item_for_iteration
				if a_expressions.has (l_expr) then
					if a_expressions.item (l_expr) < l_rank then
						a_expressions.replace (l_rank, l_expr)
					end
				else
					a_expressions.put (l_rank, l_expr)
				end
				a_new_exprs.forth
			end
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
