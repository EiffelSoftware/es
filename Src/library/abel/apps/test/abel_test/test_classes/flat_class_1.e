note
	description: "[
	Test objects for serialization not using STORABLE mechanism,
	filled in with attributes of the following types:
	INTEGER_8, INTEGER_16, INTEGER_32, INTEGER_64, 
	NATURAL_8, NATURAL_16, NATURAL_32, NATURAL_64,
	CHARACTER_8, CHARACTER_32, REAL_32, REAL_64
	BOOLEAN, STRING_8, STRING_32
	]"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	FLAT_CLASS_1

inherit

ANY
	redefine
		out end

create
	make

feature {FLAT_CLASS_1_FOR_STORABLE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			int_8_max := int_8_max.max_value
			int_8_min := int_8_min.min_value
			int_16_max := int_16_max.max_value
			int_16_min := int_16_min.min_value
			int_32_max := int_32_max.max_value
			int_32_min := int_32_min.min_value
			int_64_max := int_64_max.max_value
			int_64_min := int_64_min.min_value
			nat_8_max := nat_8_max.max_value
			nat_8_min := nat_8_min.min_value
			nat_16_max := nat_16_max.max_value
			nat_16_min := nat_16_min.min_value
			nat_32_max := nat_32_max.max_value
			nat_32_min := nat_32_min.min_value
			nat_64_max := nat_64_max.max_value
			nat_64_min := nat_64_min.min_value
			char_8_max := char_8_max.max_value.to_character_8
			char_8_min := char_8_min.min_value.to_character_8
			char_32_max := char_32_max.max_value.to_character_32
			char_32_min := char_32_min.min_value.to_character_32
			real_32_max := real_32_max.max_value
			real_32_min := real_32_min.min_value
			real_64_max := real_64_max.max_value
			real_64_min := real_64_min.min_value
			a_boolean := True
			a_string_8 := "test string_8"
			a_string_32 := "test string_32"
		end

feature -- Access

	int_8_max: INTEGER_8
	int_8_min: INTEGER_8
	int_16_max: INTEGER_16
	int_16_min: INTEGER_16
	int_32_max: INTEGER_32
	int_32_min: INTEGER_32
	int_64_max: INTEGER_64
	int_64_min: INTEGER_64
	nat_8_max: NATURAL_8
	nat_8_min: NATURAL_8
	nat_16_max: NATURAL_16
	nat_16_min: NATURAL_16
	nat_32_max: NATURAL_32
	nat_32_min: NATURAL_32
	nat_64_max: NATURAL_64
	nat_64_min: NATURAL_64
	char_8_max: CHARACTER_8
	char_8_min: CHARACTER_8
	char_32_max: CHARACTER_32
	char_32_min: CHARACTER_32
	real_32_max: REAL_32
	real_32_min: REAL_32
	real_64_max: REAL_64
	real_64_min: REAL_64
	a_boolean: BOOLEAN
	a_string_8: STRING_8
	a_string_32: STRING_32

feature -- Status Report

	out: STRING
			-- Convenient STRING representation of Current.
		do
			Result := "Object of class " + Current.generating_type + " string representation:%N"
			Result.append ("int_8_max = " + nat_8_max.out + " nat_8_min = " + nat_8_min.out + "%N")
			Result.append ("int_16_max = " + nat_16_max.out + " nat_16_min = " + nat_16_min.out + "%N")
			Result.append ("int_32_max = " + nat_32_max.out + " nat_32_min = " + nat_32_min.out + "%N")
			Result.append ("int_64_max = " + nat_64_max.out + " nat_64_min = " + nat_64_min.out + "%N")
			Result.append ("nat_8_max = " + nat_8_max.out + " nat_8_min = " + nat_8_min.out + "%N")
			Result.append ("nat_16_max = " + nat_16_max.out + " nat_16_min = " + nat_16_min.out + "%N")
			Result.append ("nat_32_max = " + nat_32_max.out + " nat_32_min = " + nat_32_min.out + "%N")
			Result.append ("nat_64_max = " + nat_64_max.out + " nat_64_min = " + nat_64_min.out + "%N")
			Result.append ("char_8_max = " + char_8_max.out + " char_8_min = " + char_8_min.out + "%N")
			Result.append ("char_32_max = " + char_32_max.out + " char_32_min = " + char_32_min.out + "%N")
			Result.append ("real_32_max = " + real_32_max.out + " real_32_min = " + real_32_min.out + "%N")
			Result.append ("real_64_max = " + real_64_max.out + " real_64_min = " + real_64_min.out + "%N")
			Result.append ("a_boolean = " + a_boolean.out + " a_string_8 = " + a_string_8 + " a_string_32 = " + a_string_32 + "%N")
		end


feature -- Update function

	update
		-- update some fields for testing
		do
			int_8_max:= int_8_max-1
			int_16_max:= int_16_max-1
			int_32_max:= int_32_max-1
			int_64_max:= int_64_max-1
			nat_8_max:= nat_8_max-1
			nat_16_max:= nat_16_max-1
			nat_32_max:= nat_32_max-1
			nat_64_max:= nat_64_max-1

			char_8_max:= (char_8_max.max_value -1).to_character_8
			char_32_max:= (char_32_max.max_value -1).to_character_32

			real_32_max:= real_32_max-1
			real_64_max:= real_64_max-1

			a_boolean:= a_boolean.negated
			a_string_8 := a_string_8 + "0"
			a_string_32 := a_string_32 + "0"

		end

end
