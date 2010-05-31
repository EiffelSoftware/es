note
	description: "Summary description for {AUT_CONTRACT_FILTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_CONTRACT_FILTER

inherit
	SHARED_WORKBENCH

feature -- Status report

	is_assertion_satisfied (a_assertion: AUT_ASSERTION; a_context_class: CLASS_C): BOOLEAN is
			-- Is `a_assertion' valid from `a_context_class'?
			-- An assertion is valid if is suitable to generate proof obligation from it.
		require
			a_assertion_attached: a_assertion /= Void
			a_context_class_attached: a_context_class /= Void
		deferred
		end

feature -- Basic operations

	drop (a_assertions: LIST [AUT_ASSERTION]; a_context_class: CLASS_C) is
			-- Delete elements in `a_assertions' which satisfy criterion defined in Current.
			-- `a_context_class' is where assertions in `a_assertions' viewed, it has impacts
			-- in case of feature renaming.
			-- The cursor in `a_contracts' may change after the filtering.
		require
			a_assertions_attached: a_assertions /= Void
			a_context_class_attached: a_context_class /= Void
		do
			from
				a_assertions.start
			until
				a_assertions.after
			loop
				if is_assertion_satisfied (a_assertions.item, a_context_class) then
					a_assertions.remove
				else
					a_assertions.forth
				end
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
