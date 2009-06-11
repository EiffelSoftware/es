note
	description: "Summary description for {TEST_GENERATOR_ROUTINES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_GENERATOR_ROUTINES

feature -- Access

	contracts_of_feature_action: FUNCTION [ANY, TUPLE [a_feature: FEATURE_I; a_ast: FEATURE_AS], LINKED_LIST [TUPLE [precondition: REQUIRE_AS; postcondition: ENSURE_AS; written_in_feature: FEATURE_I]]]
			-- Action to get contracts of `a_feature' with AST `a_ast'
		do
			Result := contracts_of_feature_action_cell.item
		ensure
			good_result: Result = contracts_of_feature_action_cell.item
		end

feature -- Setting

	set_contracts_of_feature_action (a_action: like contracts_of_feature_action) is
			-- Set `contracts_of_feature_action' with `a_action'.
		do
			contracts_of_feature_action_cell.replace (a_action)
		ensure
			contracts_of_feature_action_cell_set: contracts_of_feature_action = a_action
		end

feature{NONE} -- Implementation

	contracts_of_feature_action_cell: CELL [FUNCTION [ANY, TUPLE [a_feature: FEATURE_I; a_ast: FEATURE_AS], LINKED_LIST [TUPLE [precondition: REQUIRE_AS; postcondition: ENSURE_AS; written_in_feature: FEATURE_I]]]] is
			-- Cell for `contracts_of_feature_action'
		once
			create Result.put (Void)
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
