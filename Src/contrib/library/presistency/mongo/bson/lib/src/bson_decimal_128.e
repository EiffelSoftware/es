note
	description: "[
			Object representing the bson_decimal128_t structure.
			It represents the IEEE-754 Decimal128 data type.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_decimal128_t", "src=http://mongoc.org/libbson/current/bson_decimal128_t.html", "protocol=uri"

class
	BSON_DECIMAL_128

inherit

	BSON_WRAPPER_BASE

create
	make, make_with_string,make_with_string_and_length,  make_by_pointer

feature {NONE} -- Creation

	make_with_string (a_string: STRING)
		require
			a_string /= Void
		local
			res: BOOLEAN
			c_str: C_STRING
		do
			create c_str.make (a_string)
			make
			res := c_bson_decimal128_from_string (c_str.item, item)
		end

	make_with_string_and_length (a_string: STRING; a_length: INTEGER)
			-- Create from string with specified length
		require
			a_string_not_void: a_string /= Void
			valid_length: a_length >= 0 and a_length <= a_string.count
		local
			res: BOOLEAN
			c_str: C_STRING
		do
			create c_str.make (a_string)
			make
			res := c_bson_decimal128_from_string_w_len (c_str.item, a_length, item)
		end

feature -- Access

	high: INTEGER_64
		do
			Result := c_high (item)
		end

	low: INTEGER_64
		do
			Result := c_low (item)
		end

	to_string: STRING_32
			-- String representation of BSON Decimal128 Abstraction.
		local
			l_string: C_STRING
		do
			create l_string.make_empty (128)
			c_bson_decimal128_to_string (item, l_string.item)
			Result := l_string.string
		end

feature -- Change Element

	set_high (a_val: INTEGER_64)
		do
			c_set_high (item, a_val)
		end

	set_low (a_val: INTEGER_64)
		do
			c_set_low (item, a_val)
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
		end

feature {NONE} -- Implementation

	c_high (a_pointer: POINTER): INTEGER_64
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson/bson.h>"
		alias
			"return ((bson_decimal128_t *) $a_pointer)->high;"
		end

	c_low (a_pointer: POINTER): INTEGER_64
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson/bson.h>"
		alias
			"return ((bson_decimal128_t *) $a_pointer)->low;"
		end

	c_set_high (a_pointer: POINTER; a_val: INTEGER_64)
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson/bson.h>"
		alias
			"((bson_decimal128_t *) $a_pointer)->high = $a_val;"
		end

	c_set_low (a_pointer: POINTER; a_val: INTEGER_64)
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson/bson.h>"
		alias
			"((bson_decimal128_t *) $a_pointer)->low = $a_val;"
		end

	c_bson_decimal128_to_string (a_dec: POINTER; a_str: POINTER)
		external
			"C inline use <bson/bson.h>"
		alias
			"[
				bson_decimal128_to_string ((const bson_decimal128_t *)$a_dec, (char *)$a_str);
				//printf("%s\n", $a_str);
			]"
		end

	c_bson_decimal128_from_string (a_string: POINTER; a_dec: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_decimal128_from_string ((const char *)$a_string, (bson_decimal128_t *)$a_dec);"
		end

	c_bson_decimal128_from_string_w_len (a_string: POINTER; a_length: INTEGER; a_dec: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_decimal128_from_string_w_len ((const char *)$a_string, $a_length, (bson_decimal128_t *)$a_dec);"
		end

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

	struct_size: INTEGER
		external
			"C inline use <bson/bson.h>"
		alias
			"sizeof(bson_decimal128_t)"
		end

feature -- Constants

	decimal128_string_length: INTEGER = 43
			-- Maximum string length for decimal128 representation

	decimal128_inf: STRING = "Infinity"
			-- String representation of infinity

	decimal128_nan: STRING = "NaN"
			-- String representation of Not a Number

end
