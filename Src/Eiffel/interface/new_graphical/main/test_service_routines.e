note
	description: "[
			Routines that are used by AutoTest library
			This classes is designed because AutoTest library needs to use some classes 
			in the estudio project, those classes are not extracted into libraries so
			AutoTest library cannot use them directly.
			
			This is a walkround, if in the future the needed classes are extracted into libraries,
			remove this class.
			]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_SERVICE_ROUTINES

feature -- Access

	contracts_of_feature (a_feature: FEATURE_I; a_ast: FEATURE_AS): LINKED_LIST [TUPLE [precondition: REQUIRE_AS; postcondition: ENSURE_AS; written_in_feature: FEATURE_I]] is
			-- Contracts for feature `a_feature' with AST `a_ast'.
			-- The result is a list of all pre-/post-conditions associated with `a_feature'.
			-- The order of the assertions appear in the result list corresponds to the inheriance relation.
		local
			l_assert_server: ASSERTION_SERVER
			l_asserts: CHAINED_ASSERTIONS
			l_rout_asserts: ROUTINE_ASSERTIONS
		do
			create l_assert_server.make_for_feature (a_feature, a_ast)
			l_asserts := l_assert_server.current_assertion
			create Result.make
			from
				l_asserts.start
			until
				l_asserts.after
			loop
				l_rout_asserts := l_asserts.item_for_iteration
				Result.extend ([l_rout_asserts.precondition, l_rout_asserts.postcondition, l_rout_asserts.origin])
				l_asserts.forth
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
