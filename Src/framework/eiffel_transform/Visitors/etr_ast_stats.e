note
	description: "Computes some stats of asts."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_STATS
inherit
	AST_ITERATOR
		export
			{AST_EIFFEL} all
		redefine
			process_loop_as,
			process_if_as,
			process_elseif_as,
			process_inspect_as
		end

feature -- Access

	has_loops: BOOLEAN

	has_inspects: BOOLEAN

	has_elseifs: BOOLEAN

	has_conditional_branches: BOOLEAN

feature -- Operation

	process_transformable(a_transformable: ETR_TRANSFORMABLE)
			-- Process `a_transformable'
		require
			non_void: a_transformable /= void
			valid: a_transformable.is_valid
		do
			process_ast(a_transformable.target_node)
		end

	process_ast(a_ast: AST_EIFFEL)
			-- Process `a_ast'
		require
			non_void: a_ast /= void
		do
			has_loops := false
			has_inspects := false
			has_elseifs := false
			has_conditional_branches := false

			a_ast.process (Current)
		end

feature {AST_EIFFEL} -- Roundtrip

	process_loop_as (l_as: LOOP_AS)
		do
			has_conditional_branches := true
			has_loops := true
			Precursor(l_as)
		end

	process_if_as (l_as: IF_AS)
		do
			has_conditional_branches := true
			Precursor(l_as)
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			has_conditional_branches := true
			has_elseifs := true
			Precursor(l_as)
		end

	process_inspect_as (l_as: INSPECT_AS)
		do
			has_inspects := true
			has_conditional_branches := true
			Precursor(l_as)
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
