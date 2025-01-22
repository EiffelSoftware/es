note
	description: "[
	Objec representing the 	bson_iter_t is a structure.
	It is used to iterate through the elements of a bson_t. It is meant to be used on the stack and can be discarded at any time as it contains no external allocation. 
	The contents of the structure should be considered private and may change between releases, however the structure size will not change.

	The bson_t MUST be valid for the lifetime of the iter and it is an error to modify the bson_t while using the iter.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_iter_t", "src=http://mongoc.org/libbson/current/bson_iter_t.html", "protocol=uri"

class
	BSON_ITERATOR

inherit

	BSON_WRAPPER_BASE

create make, make_by_pointer


feature -- Removal

	dispose
			-- <Precursor>
		do
		end

feature -- Operations

	bson_iter_init (a_bson: BSON)
		local
			l_res: BOOLEAN
		do
			l_res := c_bson_iter_init (item, a_bson.item)
		end

	bson_iter_next: BOOLEAN
		do
			Result := c_bson_iter_next (item)
		end

	bson_iter_key: STRING_32
		local
			l_string: C_STRING
		do
			create l_string.make_by_pointer (c_bson_iter_key (item))
			create Result.make_from_string (l_string.string)
		end

feature -- Type Checks

    is_double: BOOLEAN
            -- Does current iterator hold a double value?
        do
            Result := c_bson_iter_holds_double (item)
        end

    is_utf8: BOOLEAN
            -- Does current iterator hold a UTF8 string?
        do
            Result := c_bson_iter_holds_utf8 (item)
        end

    is_document: BOOLEAN
            -- Does current iterator hold a document?
        do
            Result := c_bson_iter_holds_document (item)
        end

    is_array: BOOLEAN
            -- Does current iterator hold an array?
        do
            Result := c_bson_iter_holds_array (item)
        end

    is_int32: BOOLEAN
            -- Does current iterator hold a 32-bit integer?
        do
            Result := c_bson_iter_holds_int32 (item)
        end

    is_int64: BOOLEAN
            -- Does current iterator hold a 64-bit integer?
        do
            Result := c_bson_iter_holds_int64 (item)
        end

    is_number: BOOLEAN
            -- Does current iterator hold any numeric type?
        do
            Result := is_int32 or is_int64 or is_double
        end

    is_bool: BOOLEAN
            -- Does current iterator hold a boolean value?
        do
            Result := c_bson_iter_holds_bool (item)
        end

    is_binary: BOOLEAN
        do
            Result := c_bson_iter_holds_binary (item)
        end

    is_oid: BOOLEAN
        do
            Result := c_bson_iter_holds_oid (item)
        end

    is_date_time: BOOLEAN
        do
            Result := c_bson_iter_holds_date_time (item)
        end

    is_null: BOOLEAN
        do
            Result := c_bson_iter_holds_null (item)
        end

    is_regex: BOOLEAN
        do
            Result := c_bson_iter_holds_regex (item)
        end

    is_code: BOOLEAN
        do
            Result := c_bson_iter_holds_code (item)
        end

    is_codewscope: BOOLEAN
        do
            Result := c_bson_iter_holds_codewscope (item)
        end

    is_timestamp: BOOLEAN
        do
            Result := c_bson_iter_holds_timestamp (item)
        end

    is_decimal128: BOOLEAN
        do
            Result := c_bson_iter_holds_decimal128 (item)
        end

    is_maxkey: BOOLEAN
        do
            Result := c_bson_iter_holds_maxkey (item)
        end

    is_minkey: BOOLEAN
        do
            Result := c_bson_iter_holds_minkey (item)
        end

feature -- Access

    bson_iter_type: INTEGER
            -- Get the type of the current element
        do
            Result := c_bson_iter_type (item)
        end

    bson_iter_value: BSON_VALUE
            -- Get the value of the current element
        do
            create Result.make_by_pointer (c_bson_iter_value (item))
        end

    bson_iter_find (a_key: STRING): BOOLEAN
            -- Find an element with the given key
        local
            c_key: C_STRING
        do
            create c_key.make (a_key)
            Result := c_bson_iter_find (item, c_key.item)
        end

    bson_iter_recurse: BSON_ITERATOR
            -- Create a new iterator for the current document/array element
        local
        	l_res: BOOLEAN
        do
            create Result.make
            l_res := c_bson_iter_recurse (item, Result.item)
        end

    bson_iter_as_double: REAL_64
            -- Fetches the current field as if it were a double.
            -- Will cast the following types to double:
            -- * BSON_TYPE_BOOL
            -- * BSON_TYPE_DOUBLE
            -- * BSON_TYPE_INT32
            -- * BSON_TYPE_INT64
            -- Any other value will return 0.
        do
            Result := c_bson_iter_as_double (item)
        ensure
            valid_conversion: is_number implies Result = c_bson_iter_as_double (item)
            default_for_invalid: (not is_number) implies Result = 0.0
        end

    bson_iter_double: REAL_64
            -- Get the double value at the current iterator position
        require
            is_double: is_double
        do
            Result := c_bson_iter_double (item)
        end

    bson_iter_as_int64: INTEGER_64
            -- Fetches the current field as if it were an INT64.
            -- Will cast the following types to INT64:
            -- * BSON_TYPE_BOOL
            -- * BSON_TYPE_DOUBLE
            -- * BSON_TYPE_INT32
            -- * BSON_TYPE_INT64
        require
            valid_iterator: item /= default_pointer
        do
            Result := c_bson_iter_as_int64 (item)
        ensure
            valid_conversion: is_number implies Result = c_bson_iter_as_int64 (item)
        end

    bson_iter_int64: INTEGER_64
            -- Get the int64 value at the current iterator position
        require
            is_int64_value: is_int64
        do
            Result := c_bson_iter_int64 (item)
        end

    bson_iter_int32: INTEGER_32
            -- Fetches the value from a BSON_TYPE_INT32 element.
            -- You should verify that the field is a BSON_TYPE_INT32 field before calling this function.
        require
            is_int32_value: is_int32
        do
            Result := c_bson_iter_int32 (item)
        ensure
            valid_value: Result = c_bson_iter_int32 (item)
        end

    bson_iter_utf8: STRING
            -- Retrieve the contents of a BSON_TYPE_UTF8 element currently observed by iterator.
            -- Note: The caller should validate the content is valid UTF-8 before using this.
        require
            is_utf8_value: is_utf8
        local
            l_length: NATURAL_32
            l_string: C_STRING
            l_utf8_ptr: POINTER
        do
            l_utf8_ptr := c_bson_iter_utf8 (item, $l_length)
            create l_string.make_by_pointer_and_count (l_utf8_ptr, l_length.to_integer_32)
            Result := l_string.string
        ensure
            result_not_void: Result /= Void
        end

    bson_iter_as_bool: BOOLEAN
            -- Fetches the current field as if it were a boolean.
            -- Will cast the following types to boolean:
            -- * BSON_TYPE_BOOL
            -- * BSON_TYPE_DOUBLE
            -- * BSON_TYPE_INT32
            -- * BSON_TYPE_INT64
            -- * BSON_TYPE_NULL
            -- * BSON_TYPE_UNDEFINED
            -- * BSON_TYPE_UTF8 (always returns True)
        do
            Result := c_bson_iter_as_bool (item)
        end

    bson_iter_bool: BOOLEAN
            -- Get the boolean value at the current iterator position
        require
            is_bool_value: is_bool
        do
            Result := c_bson_iter_bool (item)
        ensure
            valid_value: Result = c_bson_iter_bool (item)
        end

    bson_iter_init_find (a_bson: BSON; a_key: STRING): BOOLEAN
            -- Initialize iterator and find key in one step
        local
            c_key: C_STRING
        do
            create c_key.make (a_key)
            Result := c_bson_iter_init_find (item, a_bson.item, c_key.item)
        end

    bson_iter_find_case (a_key: STRING): BOOLEAN
            -- Case-insensitive key lookup
        local
            c_key: C_STRING
        do
            create c_key.make (a_key)
            Result := c_bson_iter_find_case (item, c_key.item)
        end

    bson_iter_find_descendant (a_dotkey: STRING; a_descendant: BSON_ITERATOR): BOOLEAN
            -- Find a descendant using dotted notation
        local
            c_dotkey: C_STRING
        do
            create c_dotkey.make (a_dotkey)
            Result := c_bson_iter_find_descendant (item, c_dotkey.item, a_descendant.item)
        end

    bson_iter_key_len: INTEGER
            -- Get the length of current key
        do
            Result := c_bson_iter_key_len (item)
        end

    bson_iter_offset: INTEGER
            -- Get current offset in underlying BSON buffer
        do
            Result := c_bson_iter_offset (item)
        end

    bson_iter_oid: BSON_OID
            -- Get ObjectId value
        require
            is_oid: is_oid
        do
            create Result.make_by_pointer (c_bson_iter_oid (item))
        end

    bson_iter_timestamp (timestamp: INTEGER_64; increment: INTEGER_64)
            -- Get timestamp value
        require
            is_timestamp: is_timestamp
        do
            c_bson_iter_timestamp (item, $timestamp, $increment)
        end

    bson_iter_date_time: INTEGER_64
            -- Get datetime value
        require
            is_date_time: is_date_time
        do
            Result := c_bson_iter_date_time (item)
        end

feature -- Modification

    bson_iter_overwrite_bool (a_value: BOOLEAN)
        require
            is_bool: is_bool
        do
            c_bson_iter_overwrite_bool (item, a_value)
        end

    bson_iter_overwrite_int32 (a_value: INTEGER_32)
        require
            is_int32: is_int32
        do
            c_bson_iter_overwrite_int32 (item, a_value)
        end

    bson_iter_overwrite_int64 (a_value: INTEGER_64)
        require
            is_int64: is_int64
        do
            c_bson_iter_overwrite_int64 (item, a_value)
        end

    bson_iter_overwrite_double (a_value: REAL_64)
        require
            is_double: is_double
        do
            c_bson_iter_overwrite_double (item, a_value)
        end

feature {NONE} -- C externals

	c_bson_iter_init (a_iter: POINTER; a_bson: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_init ((bson_iter_t *)$a_iter, (const bson_t *)$a_bson);"
		end

	c_bson_iter_next (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_next ((bson_iter_t *)$a_iter);	"
		end

	c_bson_iter_key (a_iter: POINTER): POINTER
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_key ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_double (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_DOUBLE ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_utf8 (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_UTF8 ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_document (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_DOCUMENT ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_array (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_ARRAY($a_iter);"
		end

	c_bson_iter_holds_int32 (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_INT32 ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_int64 (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_INT64 ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_type (a_iter: POINTER): INTEGER
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_type((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_value (a_iter: POINTER): POINTER
		external "C inline use <bson/bson.h>"
		alias
			"return (EIF_POINTER)bson_iter_value((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_find (a_iter: POINTER; a_key: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_find((bson_iter_t *)$a_iter, (const char *)$a_key);"
		end

	c_bson_iter_recurse (a_iter: POINTER; a_child: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_recurse((const bson_iter_t *)$a_iter, (bson_iter_t *)$a_child);"
		end

	c_bson_iter_array (a_iter: POINTER; a_array_len: TYPED_POINTER [NATURAL_32]; a_array: TYPED_POINTER [POINTER])
		external
			"C inline use <bson/bson.h>"
		alias
			"[
				const uint8_t *array;
				uint32_t array_len;
				bson_iter_array((const bson_iter_t *)$a_iter, &array_len, &array);
				*$a_array_len = array_len;
				*$a_array = array;
			]"
		end

	c_bson_iter_as_double (a_iter: POINTER): REAL_64
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_iter_as_double ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_double (a_iter: POINTER): REAL_64
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_iter_double ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_as_int64 (a_iter: POINTER): INTEGER_64
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_iter_as_int64 ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_int64 (a_iter: POINTER): INTEGER_64
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_iter_int64 ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_int32 (a_iter: POINTER): INTEGER_32
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_iter_int32 ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_utf8 (a_iter: POINTER; a_length: TYPED_POINTER [NATURAL_32]): POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"[
				uint32_t length;
				const char* result = bson_iter_utf8((const bson_iter_t *)$a_iter, &length);
				*$a_length = length;
				return result;
			]"
		end

	c_bson_iter_holds_bool (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_BOOL ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_as_bool (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_as_bool ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_bool (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_bool ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_binary (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_BINARY ((const bson_iter_t *)$a_iter);"
		end


	c_bson_iter_holds_oid (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_OID ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_date_time (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_DATE_TIME ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_null (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_NULL ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_regex (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_REGEX ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_code (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_CODE ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_codewscope (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_CODEWSCOPE ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_timestamp (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_TIMESTAMP ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_decimal128 (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_DECIMAL128 ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_maxkey (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_MAXKEY ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_holds_minkey (a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return BSON_ITER_HOLDS_MINKEY ((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_init_find (a_iter: POINTER; a_bson: POINTER; a_key: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_init_find((bson_iter_t *)$a_iter, (const bson_t *)$a_bson, (const char *)$a_key);"
		end

	c_bson_iter_find_case (a_iter: POINTER; a_key: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_find_case((bson_iter_t *)$a_iter, (const char *)$a_key);"
		end

	c_bson_iter_find_descendant (a_iter: POINTER; a_dotkey: POINTER; a_descendant: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_find_descendant((bson_iter_t *)$a_iter, (const char *)$a_dotkey, (const bson_iter_t *)$a_descendant);"
		end

	c_bson_iter_key_len (a_iter: POINTER): INTEGER
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_key_len((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_offset (a_iter: POINTER): INTEGER
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_offset((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_oid (a_iter: POINTER): POINTER
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_oid((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_timestamp (a_iter: POINTER; a_timestamp: TYPED_POINTER [INTEGER_64]; a_increment: TYPED_POINTER [INTEGER_64])
		external "C inline use <bson/bson.h>"
		alias
			"bson_iter_timestamp((bson_iter_t *)$a_iter, $a_timestamp, $a_increment);"
		end

	c_bson_iter_date_time (a_iter: POINTER): INTEGER_64
		external "C inline use <bson/bson.h>"
		alias
			"return bson_iter_date_time((const bson_iter_t *)$a_iter);"
		end

	c_bson_iter_overwrite_bool (a_iter: POINTER; a_value: BOOLEAN)
		external "C inline use <bson/bson.h>"
		alias
			"bson_iter_overwrite_bool ((bson_iter_t *)$a_iter, (bool)$a_value);"
		end

	c_bson_iter_overwrite_int32 (a_iter: POINTER; a_value: INTEGER_32)
		external "C inline use <bson/bson.h>"
		alias
			"bson_iter_overwrite_int32 ((bson_iter_t *)$a_iter, (int32_t)$a_value);"
		end

	c_bson_iter_overwrite_int64 (a_iter: POINTER; a_value: INTEGER_64)
		external "C inline use <bson/bson.h>"
		alias
			"bson_iter_overwrite_int64 ((bson_iter_t *)$a_iter, (int64_t)$a_value);"
		end

	c_bson_iter_overwrite_double (a_iter: POINTER; a_value: REAL_64)
		external "C inline use <bson/bson.h>"
		alias
			"bson_iter_overwrite_double ((bson_iter_t *)$a_iter, (double)$a_value);"
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
			"sizeof(bson_iter_t)"
		end

end
