note
	description: "Summary description for {AFX_BASIC_STATE_EXPRESSION_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BASIC_STATE_EXPRESSION_GENERATOR

inherit
	AFX_RELEVANT_STATE_EXPRESSION_GENERATOR

feature -- Generation

	generate (a_spot: AFX_EXCEPTION_SPOT; a_expressions: HASH_TABLE [AFX_EXPR_RANK, AFX_EXPRESSION])
			-- <Precursor>
		local
			l_gen: AFX_NESTED_EXPRESSION_GENERATOR
			l_skeleton: AFX_STATE_SKELETON
			l_expr: AFX_EXPRESSION
			l_rank: AFX_EXPR_RANK
		do
			create l_gen.make
			l_gen.generate (a_spot.recipient_class_, a_spot.recipient_feature_)
			create l_skeleton.make_with_accesses (a_spot.recipient_class_, a_spot.recipient_feature_, l_gen.accesses)
			from
				l_skeleton.start
			until
				l_skeleton.after
			loop
				l_expr := l_skeleton.item_for_iteration
				l_rank := new_rank (l_expr)
				if a_expressions.has (l_expr) then
					if a_expressions.item (l_expr) < l_rank then
						a_expressions.replace (l_rank, l_expr)
					end
				else
					a_expressions.put (l_rank, l_expr)
				end
				l_skeleton.forth
			end
		end

feature{NONE} -- Implementation

	new_rank (a_expr: AFX_EXPRESSION): AFX_EXPR_RANK
			-- Ranking for `a_expr'
		do
			create Result.make ({AFX_EXPR_RANK}.rank_basic)
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
