note
	description: "Summary description for {PE_ASSEMBLY_FLAGS}."
	date: "$Date$"
	revision: "$Revision$"

class
	PE_ASSEMBLY_FLAGS

feature -- flags

	PublicKey: INTEGER = 0x0001 -- full key
	PA_None: INTEGER = 0x0000
	PA_MSIL: INTEGER = 0x0010
	PA_x86: INTEGER = 0x0020
	PA_IA64: INTEGER = 0x0030
	PA_AMD64: INTEGER = 0x0040
	PA_Specified: INTEGER = 0x0080

	PA_Mask: INTEGER = 0x0070
	PA_FullMask: INTEGER = 0x00F0

	PA_Shift: INTEGER = 0x0004 -- shift count

	EnableJITcompileTracking: INTEGER = 0x8000 -- From "DebuggableAttribute".
	DisableJITcompileOptimizer: INTEGER = 0x4000 -- From "DebuggableAttribute".

	Retargetable: INTEGER = 0x0100

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
