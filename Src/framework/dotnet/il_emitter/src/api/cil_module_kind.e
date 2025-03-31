note
	description: "Summary description for {CIL_MODULE_KIND}."
	date: "$Date$"
	revision: "$Revision$"

once class
	CIL_MODULE_KIND

create
	Library,
	GuiApp,
	ConsoleApp

feature {NONE} -- Initialization

	Library
			-- no subsystem
		once
			value := 1
		end

	GuiApp
			-- subsystem
		once
			value := 2
		end

	ConsoleApp
			-- subsystem.
		once
			value := 3
		end

feature -- Access

	value: INTEGER
			-- Current associated value for the module kind.

	instances: ITERABLE [CIL_MODULE_KIND]
			-- All known instances of Module Kind.
		do
			Result := <<{CIL_MODULE_KIND}.library,
					{CIL_MODULE_KIND}.guiapp,
					{CIL_MODULE_KIND}.consoleapp
				>>
		ensure
			instance_free: class
		end

note
	copyright: "Copyright (c) 1984-2025, Eiffel Software"
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
