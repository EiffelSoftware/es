note
	description: "AutoTest tool for the blackboard."
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_AUTOTEST_TOOL

inherit

	EBB_TOOL

feature -- Access

	name: attached STRING = "AutoTest"
			-- <Precursor>

	description: attached STRING = ""
			-- <Precursor>

	configurations: LINKED_LIST [attached EBB_TOOL_CONFIGURATION]
			-- <Precursor>
		once
			create Result.make
			Result.extend (create {EBB_TOOL_CONFIGURATION}.make (Current, "15 seconds"))
			Result.last.put_integer_setting (15, "timeout")
			Result.extend (create {EBB_TOOL_CONFIGURATION}.make (Current, "1 minute"))
			Result.last.put_integer_setting (60, "timeout")
			Result.extend (create {EBB_TOOL_CONFIGURATION}.make (Current, "5 minutes"))
			Result.last.put_integer_setting (300, "timeout")
		end

	category: INTEGER
			-- <Precursor>
		do
			Result := {EBB_TOOL_CATEGORY}.dynamic_verification
		end

feature -- Basic operations

	create_new_instance (a_execution: EBB_TOOL_EXECUTION)
			-- <Precursor>
		do
			create last_instance.make (a_execution)
		end

	last_instance: EBB_AUTOTEST_INSTANCE
			-- <Precursor>

feature -- Options

	timeout: STRING = "timeout"
			-- Timeout in seconds (default: 10)
	use_boundary_integers: STRING = "use_boundary_integers"
			-- Use {INTEGER}.max_value and {INTEGER}.min_value for input (default: False)
	generate_test_case: STRING = "generate_test_case"
			-- Generate test case for faults (default: False)

;note
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
