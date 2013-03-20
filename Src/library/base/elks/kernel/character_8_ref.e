note
	description: "References to objects containing a character value"
	library: "Free implementation of ELKS library"
	copyright: "Copyright (c) 1986-2004, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class CHARACTER_8_REF inherit

	COMPARABLE
		redefine
			out, is_equal
		end

	HASHABLE
		redefine
			out, is_equal
		end

feature -- Access

	item: CHARACTER_8
			-- Character value
		external
			"built_in"
		end

	code: INTEGER
			-- Associated integer value
		do
			Result := item.code
		ensure
			code_non_negatif: Result >= 0
			code_in_range: Result >= min_value and Result <= max_value
		end

	natural_32_code: NATURAL_32
			-- Associated natural value
		do
			Result := code.to_natural_32
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := code
		end

	min_value: INTEGER = 0
	max_value: INTEGER = 255
			-- Bounds for integer representation of characters (ASCII)

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is `other' greater than current character?
		do
			Result := code < other.code
		ensure then
			definition: Result = (code < other.code)
		end

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object of the same type
			-- as current object and identical to it?
		do
			Result := other.item = item
		end

feature -- Basic routines

	plus alias "+" (incr: INTEGER): CHARACTER_8
			-- Add `incr' to the code of `item'
		require
			valid_increment: (item.code + incr).is_valid_character_8_code
		do
			Result := (item.code + incr).to_character_8
		ensure
			valid_result: Result |-| item = incr
		end

	minus alias "-" (decr: INTEGER): CHARACTER_8
			-- Subtract `decr' to the code of `item'
		require
			valid_decrement: (item.code - decr).is_valid_character_8_code
		do
			Result := (item.code - decr).to_character_8
		ensure
			valid_result: item |-| Result = decr
		end

	difference alias "|-|" (other: CHARACTER_8): INTEGER
			-- Difference between the codes of `item' and `other'
		do
			Result := item.code - other.code
		ensure
			valid_result: other + Result = item
		end

	next: CHARACTER_8
			-- Next character
		require
			valid_character: (item.code + 1).is_valid_character_8_code
		do
			Result := item + 1
		ensure
			valid_result: Result |-| item = 1
		end

	previous: CHARACTER_8
			-- Previous character
		require
			valid_character: (item.code - 1).is_valid_character_8_code
		do
			Result := item - 1
		ensure
			valid_result: Result |-| item = -1
		end

feature -- Element change

	set_item (c: CHARACTER_8)
			-- Make `c' the `item' value.
		external
			"built_in"
		end

feature -- Output

	out: STRING
			-- Printable representation of character
		do
			create Result.make (1)
			Result.append_character (item)
		end

feature {NONE} -- Initialization

	make_from_reference (v: CHARACTER_8_REF)
			-- Initialize `Current' with `v.item'.
		require
			v_not_void: v /= Void
		do
			set_item (v)
		ensure
			item_set: item = v.item
		end

feature -- Conversion

	to_reference: CHARACTER_8_REF
			-- Associated reference of Current
		do
			create Result
			Result.set_item (item)
		ensure
			to_reference_not_void: Result /= Void
		end

	to_character_8: CHARACTER_8
			-- Associated character in 8 bit version
		do
			Result := item
		end

	to_character_32: CHARACTER_32
			-- Associated character in 32 bit version
		do
			Result := item.to_character_32
		end

	as_upper, upper: CHARACTER_8
			-- Uppercase value of `item'
			-- Returns `item' if not `is_lower'
		do
			if is_lower then
				Result := (item.code - ('a').code + ('A').code).to_character_8
			else
				Result := item
			end
		end

	as_lower, lower: CHARACTER_8
			-- Lowercase value of `item'
			-- Returns `item' if not `is_upper'
		do
			if is_upper then
				Result := (item.code - ('A').code + ('a').code).to_character_8
			else
				Result := item
			end
		end

feature -- Status report

	is_alpha: BOOLEAN
			-- Is `item' alphabetic?
			-- Alphabetic is `is_upper' or `is_lower'
		do
			Result := (character_types (item.code) & (is_upper_flag | is_lower_flag)) > 0
		end

	is_upper: BOOLEAN
			-- Is `item' uppercase?
		do
			Result := (character_types (item.code) & is_upper_flag) > 0
		end

	is_lower: BOOLEAN
			-- Is `item' lowercase?
		do
			Result := (character_types (item.code) & is_lower_flag) > 0
		end

	is_digit: BOOLEAN
			-- Is `item' a digit?
			-- A digit is one of 0123456789
		do
			Result := (character_types (item.code) & is_digit_flag) > 0
		end

	is_hexa_digit: BOOLEAN
			-- Is `item' an hexadecimal digit?
			-- A digit is one of 0123456789ABCDEFabcedf
		do
			Result := (character_types (item.code) & (is_hexa_digit_flag | is_digit_flag)) > 0
		end

	is_space: BOOLEAN
			-- Is `item' a white space?
		do
			Result := (character_types (item.code) & is_white_space_flag) > 0
		end

	is_punctuation: BOOLEAN
			-- Is `item' a punctuation?
		do
			Result := (character_types (item.code) & is_punctuation_flag) > 0
		end

	is_alpha_numeric: BOOLEAN
			-- Is `item' alphabetic or a digit?
		do
			Result := (character_types (item.code) & (is_upper_flag | is_lower_flag | is_digit_flag)) > 0
		end

	is_printable: BOOLEAN
			-- Is `item' a printable character including space?
		do
			Result := (character_types (item.code) &
				(is_upper_flag | is_lower_flag | is_digit_flag | is_punctuation_flag | is_space_flag)) > 0
		end

	is_graph: BOOLEAN
			-- Is `item' a printable character except space?
		do
			Result := (character_types (item.code) &
				(is_upper_flag | is_lower_flag | is_digit_flag | is_punctuation_flag)) > 0
		end

	is_control: BOOLEAN
			-- Is `item' a control character?
		do
			Result := (character_types (item.code) & is_control_flag) > 0
		end

feature {NONE} -- Implementation

	character_types (a_code: INTEGER): NATURAL_8
			-- Associated type for character of code `a_code'
		do
				-- For character whose code is above 256, it is as if
				-- we had no information about it.
			if a_code < 256 then
				Result := internal_character_types.item (a_code)
			end
		end

	internal_character_types: SPECIAL [NATURAL_8]
			-- Array which stores the various type for the ASCII characters
		once
			create Result.make_empty (256)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag | is_white_space_flag)
			Result.extend (is_control_flag | is_white_space_flag)
			Result.extend (is_control_flag | is_white_space_flag)
			Result.extend (is_control_flag | is_white_space_flag)
			Result.extend (is_control_flag | is_white_space_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_control_flag)
			Result.extend (is_white_space_flag | is_space_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_digit_flag)
			Result.extend (is_digit_flag)
			Result.extend (is_digit_flag)
			Result.extend (is_digit_flag)
			Result.extend (is_digit_flag)
			Result.extend (is_digit_flag)
			Result.extend (is_digit_flag)
			Result.extend (is_digit_flag)
			Result.extend (is_digit_flag)
			Result.extend (is_digit_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_upper_flag | is_hexa_digit_flag)
			Result.extend (is_upper_flag | is_hexa_digit_flag)
			Result.extend (is_upper_flag | is_hexa_digit_flag)
			Result.extend (is_upper_flag | is_hexa_digit_flag)
			Result.extend (is_upper_flag | is_hexa_digit_flag)
			Result.extend (is_upper_flag | is_hexa_digit_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_upper_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_lower_flag | is_hexa_digit_flag)
			Result.extend (is_lower_flag | is_hexa_digit_flag)
			Result.extend (is_lower_flag | is_hexa_digit_flag)
			Result.extend (is_lower_flag | is_hexa_digit_flag)
			Result.extend (is_lower_flag | is_hexa_digit_flag)
			Result.extend (is_lower_flag | is_hexa_digit_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_lower_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_punctuation_flag)
			Result.extend (is_control_flag)
			Result.fill_with (0, 128, 255)
		ensure
			internal_character_types_not_void: Result /= Void
		end

	is_upper_flag: NATURAL_8 = 0x01

	is_lower_flag: NATURAL_8 = 0x02

	is_digit_flag: NATURAL_8 = 0x04

	is_white_space_flag: NATURAL_8 = 0x08

	is_punctuation_flag: NATURAL_8 = 0x10

	is_control_flag: NATURAL_8 = 0x20

	is_hexa_digit_flag: NATURAL_8 = 0x40

	is_space_flag: NATURAL_8 = 0x80

end
