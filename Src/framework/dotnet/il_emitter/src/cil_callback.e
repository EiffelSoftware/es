note
	description: "The callback structure is passed to 'traverse'... it holds callbacks"
	date: "$Date$"
	revision: "$Revision$"

class
	CIL_CALLBACK

feature -- Callbacks

	enter_assembly (a_val: CIL_ASSEMBLY_DEF): BOOLEAN
		do
			Result := True
		end

	exit_assembly (a_val: CIL_ASSEMBLY_DEF): BOOLEAN
		do
			Result := True
		end

	enter_Namespace (a_val: CIL_NAMESPACE): BOOLEAN
		do
			Result := True
		end

	exit_Namespace (a_val: CIL_NAMESPACE): BOOLEAN
		do
			Result := True
		end

	enter_class (a_val: CIL_CLASS): BOOLEAN
		do
			Result := True
		end

	exit_class (a_val: CIL_CLASS): BOOLEAN
		do
			Result := True
		end

	enter_enum (a_val: CIL_ENUM): BOOLEAN
		do
			Result := True
		end

	exit_enum (a_val: CIL_ENUM): BOOLEAN
		do
			Result := True
		end

	enter_method (a_val: CIL_METHOD): BOOLEAN
		do
			Result := True
		end

	enter_field (a_val: CIL_FIELD): BOOLEAN
		do
			Result := True
		end

	enter_property (a_val: CIL_PROPERTY): BOOLEAN
		do
			Result := True
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
