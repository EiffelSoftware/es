note
	description: "Summary description for {AFX_FIXING_TARGET_EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIXING_TARGET_EXPRESSION

inherit
	AFX_FIXING_TARGET_I

create
    make

feature -- Initialization

	make (a_rep: like representation; a_type: like type; a_context: like context_feature)
			-- initialize a new object
		require
		    rep_not_empty: not a_rep.is_empty
		do
		    representation := a_rep.twin
		    type := a_type
		    context_feature := a_context
		end

feature -- Access

	context_feature: E_FEATURE
			-- <Precursor>

	representation: STRING
			-- <Precursor>

	type: TYPE_A
			-- <Precursor>

	tunning_operations: DS_LINEAR [AFX_FIX_OPERATION_TUNNING]
			-- <Precursor>
		do
		    if internal_tunning_operations = Void then
				create internal_tunning_operations.make_default
		    end

		    Result := internal_tunning_operations
		end

feature -- Operation

	register_tunning_operations (a_operations: like tunning_operations)
			-- <Precursor>
		do
		    check not_implemented_yet: False end
		end

feature -- Impelementation

	internal_tunning_operations: detachable DS_ARRAYED_LIST [AFX_FIX_OPERATION_TUNNING]
			-- internal storage for tunning operations


;note
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
