note
	description: "[
		Object representing the bson_value_t structure. It is a boxed type for encapsulating a runtime determined type.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_value_t", "src=http://mongoc.org/libbson/current/bson_value_t.html", "protocol=uri"

class
	BSON_VALUE

inherit

	BSON_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make, make_by_pointer

feature {NONE} -- Initialization

	make
		do
			memory_make
		end

feature -- Access

	value_type: INTEGER
		do
			Result := c_value_type (item)
		end

	as_integer_32: INTEGER_32
			-- Value as 32-bit integer
		require
			is_integer_32: value_type = {BSON_TYPE}.bson_type_int32
		do
			Result := c_value_int32 (item)
		end

	as_integer_64: INTEGER_64
			-- Value as 64-bit integer
		require
			is_integer_64: value_type = {BSON_TYPE}.bson_type_int64
		do
			Result := c_value_int64 (item)
		end

	as_double: REAL_64
			-- Value as double
		require
			is_double: value_type = {BSON_TYPE}.bson_type_double
		do
			Result := c_value_double (item)
		end

	as_boolean: BOOLEAN
			-- Value as boolean
		require
			is_boolean: value_type = {BSON_TYPE}.bson_type_bool
		do
			Result := c_value_bool (item)
		end

	as_string: STRING_8
			-- Value as UTF-8 string
		require
			is_string: value_type = {BSON_TYPE}.bson_type_utf8
		local
			l_ptr: POINTER
			l_len: INTEGER
		do
			l_ptr := c_value_utf8_str (item)
			l_len := c_value_utf8_len (item)
			create Result.make_from_c_substring (l_ptr, 1, l_len)
		end

feature -- Operations

	copy_value (a_other: BSON_VALUE)
			-- Copy value from `a_other`
		require
			a_other_not_void: a_other /= Void
		do
			c_bson_value_copy (a_other.item, item)
		end

feature {NONE} -- Externals

	c_value_type (a_pointer: POINTER): INTEGER
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson/bson.h>"
		alias
			"return ((bson_value_t  *) $a_pointer)->value_type;"
		end

	c_value_int32 (a_pointer: POINTER): INTEGER_32
		external "C inline use <bson/bson.h>"
		alias
			"return ((bson_value_t *)$a_pointer)->value.v_int32;"
		end

	c_value_int64 (a_pointer: POINTER): INTEGER_64
		external "C inline use <bson/bson.h>"
		alias
			"return ((bson_value_t *)$a_pointer)->value.v_int64;"
		end

	c_value_double (a_pointer: POINTER): REAL_64
		external "C inline use <bson/bson.h>"
		alias
			"return ((bson_value_t *)$a_pointer)->value.v_double;"
		end

	c_value_bool (a_pointer: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return ((bson_value_t *)$a_pointer)->value.v_bool;"
		end

	c_value_utf8_str (a_pointer: POINTER): POINTER
		external "C inline use <bson/bson.h>"
		alias
			"return ((bson_value_t *)$a_pointer)->value.v_utf8.str;"
		end

	c_value_utf8_len (a_pointer: POINTER): INTEGER
		external "C inline use <bson/bson.h>"
		alias
			"return ((bson_value_t *)$a_pointer)->value.v_utf8.len;"
		end

	c_bson_value_copy (a_src: POINTER; a_dst: POINTER)
		external "C inline use <bson/bson.h>"
		alias
			"bson_value_copy ((const bson_value_t *)$a_src, (bson_value_t *)$a_dst);"
		end

feature -- Removal

	dispose
		do
			if shared then
				c_bson_value_destroy (item)
			end
		end

feature {NONE} -- Implementation

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

	c_bson_value_destroy (a_value: POINTER)
		external
			"C inline use <bson/bson.h>"
		alias
			"bson_value_destroy ((bson_value_t *)$a_value);"
		end
end
