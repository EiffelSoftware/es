note
	description: "[
		Factory features to create different types of OPERAND
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CIL_OPERAND_FACTORY

feature -- Operand factory features.

	default_operand: CIL_OPERAND
			-- default operand.
		do
			create Result.make
		ensure
			instance_free: class
		end

feature -- Operand is a complex value

	complex_operand (v: CIL_VALUE): CIL_OPERAND
			-- Operand is a complex value.
		do
			Result := {CIL_OPERAND_FACTORY}.default_operand
			Result.type := {CIL_OPERAND_TYPE}.t_value
			Result.ref_value := v
		ensure
			instance_free: class
			operand_type_complex: Result.type = {CIL_OPERAND_TYPE}.t_value
			ref_value_attached: attached Result.ref_value as l_ref_value and then l_ref_value = v
			int_value_zero: Result.int_value = 0
			size_set: Result.size = {CIL_OPERAND_SIZE}.i8
			float_value_zero: Result.float_value = {REAL_64}0.0
			property_set: Result.property = False
			string_value_empty: Result.string_value.is_empty
		end

feature -- Operand is an integer constant

	integer64_operand (a_value: INTEGER_64; a_size: CIL_OPERAND_SIZE): CIL_OPERAND
			-- Operand is an integer constant.
		do
			Result := {CIL_OPERAND_FACTORY}.default_operand
			Result.type := {CIL_OPERAND_TYPE}.t_int
			Result.int_value := a_value
			Result.size := a_size
		ensure
			instance_free: class
			operand_type_int: Result.type = {CIL_OPERAND_TYPE}.t_int
		 	int_value_set: Result.int_value = a_value
		 	size_set: Result.size = a_size
		 	ref_value_void: Result.ref_value = Void
		 	float_value_zero: Result.float_value = {REAL_64}0.0
		 	property_set: Result.property = False
		 	string_value_empty: Result.string_value.is_empty
		end

	integer_operand (a_value: INTEGER; a_size: CIL_OPERAND_SIZE): CIL_OPERAND
			-- Operand is an integer constant.
		do
			Result := {CIL_OPERAND_FACTORY}.integer64_operand (a_value, a_size)
		ensure
			instance_free: class
		end

	natural_operand (a_value: NATURAL; a_size: CIL_OPERAND_SIZE): CIL_OPERAND
			-- Operand is a Natural constant.
		do
			Result := {CIL_OPERAND_FACTORY}.integer64_operand (a_value.to_integer_64, a_size)
		ensure
			instance_free: class
		end

	natural64_operand (a_value: NATURAL_32; a_size: CIL_OPERAND_SIZE): CIL_OPERAND
			-- Operand is a Natural constant.
		do
			Result := {CIL_OPERAND_FACTORY}.integer64_operand (a_value.to_integer_64, a_size)
		ensure
			instance_free: class
		end


	character_operand (a_value: CHARACTER; a_size: CIL_OPERAND_SIZE): CIL_OPERAND
			-- Operand is a Natural constant.
		do
			Result := {CIL_OPERAND_FACTORY}.integer64_operand (a_value.code, a_size)
		ensure
			instance_free: class
		end


feature -- Operand is a floating point constant		

	real_operand (a_value: REAL_64; a_size: CIL_OPERAND_SIZE): CIL_OPERAND
			-- Operand is a floating point operand.
		do
			Result := {CIL_OPERAND_FACTORY}.default_operand
			Result.type := {CIL_OPERAND_TYPE}.t_real
			Result.float_value := a_value
			Result.size := a_size
		ensure
			instance_free: class
			operand_type_rel: Result.type = {CIL_OPERAND_TYPE}.t_real
		 	int_value_zero: Result.int_value = 0
		 	size_set: Result.size = a_size
		 	ref_value_void: Result.ref_value = Void
		 	float_value_set: Result.float_value = a_value
		 	property_set: Result.property = False
		 	string_value_empty: Result.string_value.is_empty
		end


feature -- Operand is an string constant		

	string_operand (a_value: READABLE_STRING_GENERAL): CIL_OPERAND
			-- Operand is a String.
		do
			Result := {CIL_OPERAND_FACTORY}.default_operand
			Result.type := {CIL_OPERAND_TYPE}.t_string
			Result.string_value := a_value
		ensure
			instance_free: class
			operand_type_string: Result.type = {CIL_OPERAND_TYPE}.t_string
		 	int_value_zero: Result.int_value = 0
		 	size_set: Result.size = {CIL_OPERAND_SIZE}.i8
		 	ref_value_void: Result.ref_value = Void
		 	float_value_zero: Result.float_value = {REAL_64}0.0
		 	property_set: Result.property = False
		 	string_value_set: Result.string_value.same_string_general (a_value)
		end


feature -- Operand is a label constant

	label_operand (a_value: READABLE_STRING_GENERAL): CIL_OPERAND
			-- Operand is a label
		do
			Result := {CIL_OPERAND_FACTORY}.default_operand
			Result.type := {CIL_OPERAND_TYPE}.t_label
			Result.string_value := a_value
		ensure
			instance_free: class
			operand_type_label: Result.type = {CIL_OPERAND_TYPE}.t_label
		 	int_value_zero: Result.int_value = 0
		 	size_set: Result.size = {CIL_OPERAND_SIZE}.i8
		 	ref_value_void: Result.ref_value = Void
		 	float_value_zero: Result.float_value = {REAL_64}0.0
		 	property_set: Result.property = False
		 	string_value_set: Result.string_value.same_string_general (a_value)
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
