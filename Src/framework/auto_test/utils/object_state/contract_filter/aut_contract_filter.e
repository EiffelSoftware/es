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

	is_assertion_satisfied (a_tag: TAGGED_AS; a_written_class: CLASS_C; a_context_class: CLASS_C): BOOLEAN is
			-- Is `a_tag' written in `a_written_class' a valid tag in `a_context_class'?
			-- An assertion is valid if is suitable to generate proof obligation from it.
		require
			a_tag_attached: a_tag /= Void
			a_written_class_attached: a_written_class /= Void
			a_context_class_attached: a_context_class /= Void
		deferred
		end

feature -- Basic operations

	filter (a_contracts: LIST [TUPLE [tag: TAGGED_AS; written_class: CLASS_C]]; a_context_class: CLASS_C) is
			-- Delete elements in `a_contract_list' which do not satisfy criterion defined in Current.
			-- `a_context_class' is where assertions in `a_contract_list' viewed, it has impacts
			-- in case of feature renaming.
			-- The cursor in `a_contracts' may change after the filtering.
		require
			a_contracts_attached: a_contracts /= Void
			a_context_class_attached: a_context_class /= Void
		local
			l_assert: TUPLE [tag: TAGGED_AS; written_class: CLASS_C]
		do
			from
				a_contracts.start
			until
				a_contracts.after
			loop
				l_assert := a_contracts.item
				if not is_assertion_satisfied (l_assert.tag, l_assert.written_class, a_context_class) then
					a_contracts.remove
				else
					a_contracts.forth
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
