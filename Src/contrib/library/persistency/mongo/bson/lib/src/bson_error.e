note
	description: "[
		Object representing the bson_error_t structure.
		It is used as an out-parameter to pass error information to the caller. It should be stack-allocated and does not requiring freeing.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_error_t", "src=http://mongoc.org/libbson/current/bson_error_t.html", "protocol=uri"
class
	BSON_ERROR

inherit
	BSON_WRAPPER_BASE

create make, make_by_pointer

feature -- Access

	domain: INTEGER_32
		do
			Result := c_domain (item)
		end

	code: INTEGER_32
		do
			Result := c_code (item)
		end

	message: STRING_32
		local
			l_string: C_STRING

		do
			create l_string.make_by_pointer (c_message (item))
			Result := l_string.string
		end


feature -- Removal

	dispose
			--<Precursor>
		do
		end

feature -- Operations

    set_error (a_domain: INTEGER_32; a_code: INTEGER_32; a_format: STRING_32)
            -- Set the error information
        local
            c_format: C_STRING
        do
            create c_format.make (a_format)
            c_bson_set_error (item, a_domain, a_code, c_format.item)
        ensure
            domain_set: domain = a_domain
            code_set: code = a_code
        end

    error_string: STRING_32
            -- Get a string representation of the error
        local
            c_buf: C_STRING
            l_size: INTEGER
        do
            l_size := 504  -- Maximum size of error message as per bson_error_t structure
            create c_buf.make_empty (l_size)
            c_bson_strerror_r (item, c_buf.item, l_size)
            Result := c_buf.string
        end

feature {NONE} -- Implementation


	c_domain ( a_pointer: POINTER): INTEGER_32
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson/bson.h>"
		alias
			"return ((bson_error_t *) $a_pointer)->domain;"
		end

	c_code ( a_pointer: POINTER): INTEGER_32
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson/bson.h>"
		alias
			"return ((bson_error_t *) $a_pointer)->code;"
		end

	c_message ( a_pointer: POINTER): POINTER
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson/bson.h>"
		alias
			"return ((bson_error_t *) $a_pointer)->message;"
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
			"sizeof(bson_error_t)"
		end

    c_bson_set_error (a_error: POINTER; a_domain: INTEGER_32; a_code: INTEGER_32; a_format: POINTER)
        external
            "C inline use <bson/bson.h>"
        alias
            "bson_set_error ((bson_error_t *)$a_error, $a_domain, $a_code, (const char *)$a_format);"
        end

    c_bson_strerror_r (a_error: POINTER; a_buf: POINTER; a_buflen: INTEGER)
        external
            "C inline use <bson/bson.h>"
        alias
            "bson_strerror_r ((const bson_error_t *)$a_error, (char *)$a_buf, $a_buflen);"
        end

end

