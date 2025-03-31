note
	description: "Optional Header NetCore constants for Net version greater than or equal 6"
	date: "$Date$"
	revision: "$Revision$"

class
	CLI_CONFIG_NETCORE

feature -- Constants

	major_linked_version: INTEGER_8 = 48
		-- 0x30 in hex

feature -- Image DLL Characteristics

	HIGH_ENTROPY_VA: INTEGER_16 = 0x0020
			-- Image can handle a high entropy 64-bit virtual address space.

	DYNAMIC_BASE: INTEGER_16 = 0x0040
			-- DLL can be relocated at load time.

	FORCE_INTEGRITY: INTEGER_16 = 0x0080
			-- Code Integrity checks are enforced.

	NX_COMPAT: INTEGER_16 = 0x0100
			-- Image is NX compatible.

	NO_ISOLATION: INTEGER_16 = 0x0200
			-- Isolation aware, but do not isolate the image.

	NO_SEH: INTEGER_16 = 0x0400
			-- Does not use structured exception (SE) handling.
			-- No SE handler may be called in this image.

	NO_BIND: INTEGER_16 = 0x0800
			-- Do not bind the image.

	APPCONTAINER: INTEGER_16 = 0x1000
			-- Image must execute in an AppContainer.

	WDM_DRIVER: INTEGER_16 = 0x2000
			-- A WDM driver.

	GUARD_CF: INTEGER_16 = 0x4000
			-- Image supports Control Flow Guard.

	TERMINAL_SERVER_AWARE: INTEGER_16 = 0x8000
			-- Terminal Server aware.


	default_dll_characteristics: INTEGER_16
		do
			Result := high_entropy_va | dynamic_base | nx_compat | no_seh | terminal_server_aware
		ensure
			is_class: class
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
