note
	description: "Summary description for {EBB_CODE_ANALYSIS_TOOL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_CA_TOOL

inherit

	EBB_TOOL

feature -- Access

	name: attached STRING = "EiffelInspector"
			-- <Precursor>

	description: attached STRING = "Code analysis."
			-- <Precursor>

	configurations: attached LINKED_LIST [attached EBB_TOOL_CONFIGURATION]
			-- <Precursor>
		once
			create Result.make
			Result.extend (create {EBB_TOOL_CONFIGURATION}.make (Current, "Default"))
		end

	category: INTEGER
			-- <Precursor>
		do
			Result := {EBB_TOOL_CATEGORY}.analysis
		end

feature -- Basic operations

	create_new_instance (a_execution: attached EBB_TOOL_EXECUTION)
			-- <Precursor>
		do
			create last_instance.make (a_execution)
		end

	last_instance: detachable EBB_CA_INSTANCE
			-- <Precursor>

;note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
