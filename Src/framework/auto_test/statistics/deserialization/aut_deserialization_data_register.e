note
	description: "Summary description for {AUT_DESERIALIZATION_DATA_REGISTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_DESERIALIZATION_DATA_REGISTER

create
	default_create

feature -- Access

	register: AUT_NESTED_HASH_TABLE[AUT_DESERIALIZED_DATA, FEATURE_I, CLASS_C]
			-- Shared register.
		do
			Result := internal_register.item
		end

feature -- Setting

	set_register (a_register: like register)
			-- Set the register.
		do
			internal_register.put (a_register)
		end
feature{NONE} -- Implementation

	internal_register: CELL [AUT_NESTED_HASH_TABLE[AUT_DESERIALIZED_DATA, FEATURE_I, CLASS_C]]
			-- Internal storage for the register.
		local
			l_reg: AUT_NESTED_HASH_TABLE[AUT_DESERIALIZED_DATA, FEATURE_I, CLASS_C]
		once
			create l_reg.make_with_equality_testers (100, data_equality_tester, feature_equality_tester, class_equality_tester)
			create Result.put (l_reg)
		end

	feature_equality_tester: AUT_FEATURE_I_EQUALITY_TESTER
		once
			create Result
		end

	class_equality_tester: AUT_CLASS_EQUALITY_TESTER
		once
			create Result
		end

	data_equality_tester: AUT_DESERIALIZED_DATA_EQUALITY_TESTER
		once
			create Result
		end

;note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
