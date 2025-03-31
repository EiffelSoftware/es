note
	description: "Summary description for {ENUM_METHOD_ATTRIBUTES}."
	date: "$Date$"
	revision: "$Revision$"


class
	CIL_QUALIFIERS_ENUM

feature -- Access

		-- The full list is in section
		-- II.15.4.2 Predefined attributes on methods CIL_ECMA-335

	Public: INTEGER = 0x1
	Private: INTEGER = 0x2
	Static: INTEGER = 0x4
	Instance: INTEGER = 0x8
	Explicit: INTEGER = 0x10
	Ansi: INTEGER = 0x20
	Sealed: INTEGER = 0x40
	Enum: INTEGER = 0x80
	Value: INTEGER = 0x100
	Sequential: INTEGER = 0x200
	Auto: INTEGER = 0x400
	Literal: INTEGER = 0x800
	HideBySig: INTEGER = 0x1000
	PreserveSig: INTEGER = 0x2000
	SpecialName: INTEGER = 0x4000
	RTSpecialName: INTEGER = 0x8000
	CIL: INTEGER = 0x10000
	Managed: INTEGER = 0x20000
	Runtime: INTEGER = 0x40000
	Virtual: INTEGER = 0x100000 -- sealed
	NewSlot: INTEGER = 0x200000 -- value

	MainClass: INTEGER
		do
			Result := Ansi | Sealed
		ensure
			is_class: class
		end

	ClassClass: INTEGER
		do
			Result := Value | Sequential | Ansi | Sealed
		ensure
			is_class: class
		end

	ClassUnion: INTEGER
		do
			Result := Value | Explicit | Ansi | Sealed
		ensure
			is_class: class
		end

	ClassField: INTEGER = 0

	FieldInitialized: INTEGER
		do
			Result := Static
		ensure
			is_class: class
		end

	EnumClass: INTEGER
		do
			Result := Enum | Auto | Ansi | Sealed
		ensure
			is_class: class
		end

	EnumField: INTEGER
		do
			Result := Static | Literal | Public
		ensure
			is_class: class
		end

	PInvokeFunc: INTEGER
		do
			Result := HideBySig | Static | PreserveSig
		ensure
			is_class: class
		end

	ManagedFunc: INTEGER
		do
			Result := HideBySig | Static | CIL | Managed
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
