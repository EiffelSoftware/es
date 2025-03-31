note
	description: "Summary description for {PE_TYPE_DEF_FLAGS}."
	date: "$Date$"
	revision: "$Revision$"

class
	PE_TYPE_DEF_FLAGS

feature -- Enum: Flags

		-- Visibility

	VisibilityMask: INTEGER = 0x00000007

	NotPublic: INTEGER = 0x00000000
	Public: INTEGER = 0x00000001

	NestedPublic: INTEGER = 0x00000002
	NestedPrivate: INTEGER = 0x00000003
	NestedFamily: INTEGER = 0x00000004
	NestedAssembly: INTEGER = 0x00000005
	NestedFamANDAssem: INTEGER = 0x00000006
	NestedFamORAssem: INTEGER = 0x00000007

		-- layout

	LayoutMask: INTEGER = 0x00000018

	AutoLayout: INTEGER = 0x00000000
	SequentialLayout: INTEGER = 0x00000008
	ExplicitLayout: INTEGER = 0x00000010

		-- semantics

	ClassSemanticsMask: INTEGER = 0x00000060

	Class_: INTEGER = 0x00000000
	Interface: INTEGER = 0x00000020

		-- other attributes

	Abstract: INTEGER = 0x00000080
	Sealed: INTEGER = 0x00000100
	SpecialName: INTEGER = 0x00000400
	Import: INTEGER = 0x00001000
	Serializable: INTEGER = 0x00002000

		-- string format

	StringFormatMask: INTEGER = 0x00030000

	AnsiClass: INTEGER = 0x00000000
	UnicodeClass: INTEGER = 0x00010000
	AutoClass: INTEGER = 0x00020000
	CustomFormatClass: INTEGER = 0x00030000

		-- valid for custom format class but undefined

	CustomFormatMask: INTEGER = 0x00C00000

	BeforeFieldInit: INTEGER = 0x00100000
	Forwarder: INTEGER = 0x00200000

		-- runtime
	ReservedMask: INTEGER = 0x00040800
	RTSpecialName: INTEGER = 0x00000800

	HasSecurity: INTEGER = 0x00040000

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
