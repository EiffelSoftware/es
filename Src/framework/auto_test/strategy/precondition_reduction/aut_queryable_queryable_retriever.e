note
	description: "Class to retrieve queryables from semantic database"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_QUERYABLE_QUERYABLE_RETRIEVER

inherit
	REFACTORING_HELPER

feature -- Access

	last_objects: LINKED_LIST [SEMQ_RESULT]
			-- Objects that are retrieved through last `retrieve_invariant_violating_objects'

feature -- Basic operations

	retrieve_objects (a_predicate: EPA_EXPRESSION; a_context_class: CLASS_C; a_feature: FEATURE_I; a_satisfying: BOOLEAN)
			-- Retrieve objects that satisfying `a_predicate' if `a_satisfying' is True;
			-- otherwise, retrieve objects that violating `a_predicate'.
			-- Make result available in `last_objects'.
			-- `a_context_class' and `a_feature' compose the context where `a_predicate' appears.
		do
			to_implement ("To implement. 21.2.2011 Jasonw")
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
