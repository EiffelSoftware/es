note
	description: "Summary description for {AFX_IMPLICATION_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_IMPLICATION_GENERATOR

inherit
	AFX_RELEVANT_STATE_EXPRESSION_GENERATOR

	AFX_ACCESS_AGENT_UTILITY

feature -- Generation

	generate (a_spot: AFX_EXCEPTION_SPOT; a_expressions: HASH_TABLE [AFX_EXPR_RANK, AFX_EXPRESSION])
			-- <Precursor>
		local
			l_exprs: like atomic_predicates
		do
			l_exprs := atomic_predicates (a_spot.recipient_class_, a_spot.recipient_feature_)
		end

feature{NONE} -- Implementation

	atomic_predicates (a_class: CLASS_C; a_feature: FEATURE_I): LINEAR [AFX_EXPRESSION]
			-- List of predicates that are used as atomic terms
			-- in implication generation
		local
			l_gen: AFX_NESTED_EXPRESSION_GENERATOR
			l_skeleton: AFX_STATE_SKELETON
		do
			create l_gen.make
			l_gen.set_level (2)
			l_gen.expression_veto_agents.force (
				current_expression_veto_agent, 1)

			l_gen.expression_veto_agents.force (
				anded_agents (<<
					feature_expression_veto_agent,
					nested_not_on_basic_veto_agent,
					feature_not_obsolete_veto_agent,
					feature_with_few_arguments_veto_agent (0),
					boolean_expression_veto_agent>>)
				, 1)
			l_gen.generate (a_class, a_feature)

			create l_skeleton.make_with_accesses (a_class, a_feature, l_gen.accesses)
			Result := l_skeleton.linear_representation
			io.put_string (l_skeleton.debug_output)
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
