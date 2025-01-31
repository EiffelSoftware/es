note
	description: "[
			Object representing the bson_t structure 
			It represents a BSON document. 
			This structure manages the underlying BSON encoded buffer. For mutable documents, it can append new data to the document.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_t", "src=http://mongoc.org/libbson/current/bson_t.html", "protocol=uri"

class
	BSON

inherit

	BSON_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make, make_by_pointer, make_from_json, make_from_json_value

feature {NONE}-- Initialization


	make
		do
			make_by_pointer (c_bson_new)
		end

	make_from_json (a_data: READABLE_STRING_GENERAL)  -- JSON
		local
			l_data: C_STRING
			l_error: BSON_ERROR
			l_pointer: POINTER
		do
			create l_error.make
			create l_data.make (a_data)
				--see https://mongoc.org/libbson/current/bson_new_from_json.html
			l_pointer := c_bson_new_from_json (l_data.item, l_data.count, l_error.item)
			make_by_pointer (l_pointer)
		end

	make_from_json_value (a_data: JSON_VALUE)
		local
			l_data: C_STRING
			l_error: BSON_ERROR
			l_pointer: POINTER
		do
			create l_error.make
			create l_data.make (a_data.representation)
				--see https://mongoc.org/libbson/current/bson_new_from_json.html
			l_pointer := c_bson_new_from_json (l_data.item, l_data.count, l_error.item)
			make_by_pointer (l_pointer)
		end


	bson_init
			-- Initializes the given bson_t structure.
		do
			c_bson_init (item)
		end


feature -- Access

 	len: INTEGER_32
 		do
 			Result := c_bson_len (item)
 		end

 	valid_option_characters: STRING_32 = "imxlsu"
		-- Valid characters for regex options	

feature -- Operations

	bson_append_utf8 (a_key: STRING_32; a_value: STRING_32)
		note
			EIS:"name=bson_append_utf8", "src=http://mongoc.org/libbson/current/bson_append_utf8.html", "protocol=uri"
		local
			c_key: C_STRING
			c_value: C_STRING
			l_res: BOOLEAN
			l_utf: UTF_CONVERTER
		do
			create c_key.make (a_key)
			create c_value.make (l_utf.string_32_to_utf_8_string_8 (a_value))
			l_res := c_bson_append_utf8 (item, c_key.item, c_key.count, c_value.item, c_value.count)
		end

	bson_append_boolean (a_key: STRING_32; a_value: BOOLEAN)
		note
			EIS: "name=bson_append_boolean", "src=https://mongoc.org/libbson/current/bson_append_boolean.html", "protocol=url"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_bool (item, c_key.item, c_key.count, a_value)
		end

	bson_append_integer_32 (a_key: STRING_32; a_value: INTEGER_32)
		note
			EIS: "name=bson_append_integer_32", "src=https://mongoc.org/libbson/current/bson_append_int32.html", "protocol=url"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_int32 (item, c_key.item, c_key.count, a_value)
		end

	bson_append_integer_64 (a_key: STRING_32; a_value: INTEGER_64)
		note
			EIS: "name=bson_append_integer_64", "src=https://mongoc.org/libbson/current/bson_append_int64.html", "protocol=url"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_int64 (item, c_key.item, c_key.count, a_value)
		end

	bson_append_code (a_key: STRING_32; a_value: STRING_32)
		note
			EIS: "name=bson_append_code", "src=https://mongoc.org/libbson/current/bson_append_code.html", "protocol=url"
		local
			c_key: C_STRING
			c_value: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			create c_value.make (a_value)
			l_res := c_bson_append_code (item, c_key.item, c_key.count, c_value.item)
		end

	bson_append_code_scope (a_key: STRING_32; a_value: STRING_32; a_scope: detachable BSON)
		note
			EIS: "name=bson_append_code_scope", "src=https://mongoc.org/libbson/current/bson_append_code_scope.html", "protocol=url"
		local
			c_key: C_STRING
			c_value: C_STRING
			l_res: BOOLEAN
			l_scope: POINTER
		do
			l_scope := default_pointer
			if attached a_scope then
				l_scope := a_scope.item
			end
			create c_key.make (a_key)
			create c_value.make (a_value)
			l_res := c_bson_append_code_scope (item, c_key.item, c_key.count, c_value.item, l_scope)
		end

	bson_append_double (a_key: STRING_32; a_value: REAL_64)
		note
			EIS: "name=bson_append_double", "src=https://mongoc.org/libbson/current/bson_append_double.html", "protocol=uri"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_double (item, c_key.item, c_key.count, a_value)
		end

	bson_append_binary (a_key: STRING_32; a_type: INTEGER; a_buffer: ARRAY [NATURAL_8])
			-- Append binary data with subtype `a_type` using the specified key `a_key` to current bson document.
		note
			EIS: "name=bson_append_binary", "src=http://mongoc.org/libbson/current/bson_append_binary.html", "protocol=uri"
		require
			valid_subtype: (create {BSON_SUBTYPE}).is_valid_subtype (a_type)
		local
			l_mgr: MANAGED_POINTER
			l_key: C_STRING
			l_res: BOOLEAN
		do
			create l_key.make (a_key)
			create l_mgr.make_from_array (a_buffer)
			l_res := c_bson_append_binary (item, l_key.item, l_key.count, a_type, l_mgr.item, l_mgr.count)
		end

	bson_append_null (a_key: STRING_32)
		note
			EIS: "name=bson_append_null", "src=http://mongoc.org/libbson/current/bson_append_null.html", "protocol=uri"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_null (item, c_key.item, c_key.count)
		end

	bson_append_oid (a_key: STRING_32; a_oid: BSON_OID)
		note
			EIS: "name=bson_append_oid", "src=http://mongoc.org/libbson/current/bson_append_oid.html", "protocol=uri"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_oid (item, c_key.item, c_key.count, a_oid.item)
		end

	bson_append_time (a_key: STRING; a_val:INTEGER_64)
		note
			EIS: "name=bson_append_time", "src=https://mongoc.org/libbson/current/bson_append_time_t.html", "protocol=url"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_time_t (item, c_key.item, c_key.count, a_val)
		end

	bson_append_timestamp (a_key: STRING; a_timestamp:INTEGER_64; a_increment: INTEGER_64)
		note
			EIS: "name=bson_append_timestamp", "src=https://mongoc.org/libbson/current/bson_append_timestamp.html", "protocol=url"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_timestamp (item, c_key.item, c_key.count, a_timestamp, a_increment)
		end

	bson_append_regex (a_key: STRING_32; a_regex: STRING_8; a_options: STRING_32)
		note
			EIS: "name=bson_append_regex", "src=http://mongoc.org/libbson/current/bson_append_regex.html", "protocol=uri"
		require
			valid_options: not a_options.is_empty implies across a_options as opt all
				valid_option_characters.has (opt.item)
			end
			no_duplicate_options:  not a_options.is_empty implies across a_options as opt all
				a_options.occurrences (opt.item) = 1
			end
		local
			c_key: C_STRING
			l_res: BOOLEAN
			c_regex: C_STRING
			c_options: C_STRING
		do
			create c_regex.make (a_regex)
			create c_options.make (a_options)
			create c_key.make (a_key)
			l_res := c_bson_append_regex (item, c_key.item, c_key.count, c_regex.item, c_options.item)
		ensure
			length_increased: old len <= len
		end

	bson_append_decimal128 (a_key: STRING_32; a_dec: BSON_DECIMAL_128)
		note
			EIS: "name=bson_append_decimal128", "src=https://mongoc.org/libbson/current/bson_append_decimal128.html", "protocol=uri"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_decimal128 (item, c_key.item, c_key.count, a_dec.item)
		end

	bson_get_data: MANAGED_POINTER
			-- Retrieve the raw buffer of the BSON document.
			-- This can be used in conjunction with the `len` property.
			-- Note: The returned buffer should not be modified.
		note
			EIS: "name=bson_get_data", "src=https://mongoc.org/libbson/current/bson_get_data.html", "protocol=uri"
		do
			create Result.share_from_pointer (c_bson_get_data (item), len)
		ensure
			valid_size: Result.count = len
		end

	bson_append_date_time (a_key: STRING_32; a_value: INTEGER_64)
		note
			EIS: "name=bson_append_date_time", "src=http://mongoc.org/libbson/current/bson_append_date_time.html", "protocol=uri"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_date_time (item, c_key.item, c_key.count, a_value)
		end

	bson_append_iter (a_key: detachable STRING_32; a_iter: BSON_ITERATOR)
		note
			EIS: "name=bson_append_iter", "src=http://mongoc.org/libbson/current/bson_append_iter.html", "protocol=uri"
		local
			c_key: C_STRING
			l_res: BOOLEAN
			l_key: POINTER
			l_count: INTEGER
		do
			if attached a_key then
				create c_key.make (a_key)
				l_key := c_key.item
				l_count := c_key.count
			else
				l_count := -1
			end
			l_res := c_bson_append_iter (item, l_key, l_count, a_iter.item)
		end

	bson_append_now_utc	(a_key: STRING_32)
		note
			EIS: "name=bson_append_now_utc", "src=http://mongoc.org/libbson/current/bson_append_now_utc.html", "protocol=uri"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_now_utc (item, c_key.item, c_key.count)

		end

    bson_append_timeval (a_key: STRING_32; a_seconds: INTEGER_64; a_microseconds: INTEGER)
            -- Append a time value with microsecond precision using the specified key `a_key`.
            -- `a_seconds`: Number of seconds since Unix epoch
            -- `a_microseconds`: Additional microseconds (0-999999)
        note
            EIS: "name=bson_append_timeval", "src=https://mongoc.org/libbson/current/bson_append_timeval.html", "protocol=url"
        require
            valid_microseconds: a_microseconds >= 0 and a_microseconds < 1_000_000
        local
            c_key: C_STRING
            l_res: BOOLEAN
            l_milliseconds: INTEGER_64
        do
            create c_key.make (a_key)
                -- Convert to milliseconds for BSON date format
            l_milliseconds := (a_seconds * 1000) + (a_microseconds // 1000)
            l_res := c_bson_append_date_time (item, c_key.item, c_key.count, l_milliseconds)
        ensure
            length_increased: old len <= len
        end


	bson_append_value (a_key: STRING_32; a_value: BSON_VALUE)
			-- Append a BSON value to the current BSON document with the specified key.
		require
			a_key_not_void: a_key /= Void
			a_value_not_void: a_value /= Void
		local
			l_key: C_STRING
			l_res: BOOLEAN
		do
			create l_key.make (a_key)
			l_res:= c_bson_append_value (item, l_key.item, l_key.count, a_value.item)
		end


feature -- Append Document

	bson_append_document (a_key: STRING_32; a_document: BSON)
		note
			EIS: "name=bson_append_document", "src=http://mongoc.org/libbson/current/bson_append_document.html", "protocol=uri"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_document (item, c_key.item, c_key.count, a_document.item)
		end

	bson_append_document_begin (a_key: STRING): BSON
		note
			EIS: "name=bson_append_document_begin", "src=http://mongoc.org/libbson/current/bson_append_document_begin.html", "protocol=uri"
		local
			c_key: C_STRING
			l_res: BOOLEAN
			l_result: BSON
		do
			create c_key.make (a_key)
			create l_result.make
			l_res := c_bson_append_document_begin (item, c_key.item, c_key.count, l_result.item)
			Result := l_result
		end

	bson_append_document_end (a_bson: BSON)
		note
			EIS: "name=bson_append_document_end", "src=http://mongoc.org/libbson/current/bson_append_document_end.html", "protocol=uri"
		local
			l_res: BOOLEAN
		do
			l_res := c_bson_append_document_end (item, a_bson.item)
		end


feature -- Operations

	bson_compare (a_other: BSON): BOOLEAN
		note
			EIS: "name=bson_compare", "src=https://mongoc.org/libbson/current/bson_compare.html", "protocol=uri"
		do
			if c_bson_compare (item, a_other.item) = 0 then
				Result := True
			else
				Result := False
			end
		end

	bson_concat (a_other: BSON)
		note
			EIS: "name=bson_concat", "src=https://mongoc.org/libbson/current/bson_concat.html", "protocol=uri"
		local
			l_res: BOOLEAN
		do
			l_res := c_bson_concat (item, a_other.item)
		end

	bson_copy: BSON
		note
			EIS: "name=bson_copy", "src=https://mongoc.org/libbson/current/bson_copy.html", "protocol=uri"
		do
			create Result.make_by_pointer (c_bson_copy (item))
		end

	bson_copy_to (a_dst: BSON)
		note
			EIS: "name=bson_copy_to", "src=https://mongoc.org/libbson/current/bson_copy_to.html", "protocol=uri"
		do
			c_bson_copy_to (item, a_dst.item)
		end

	bson_equal (a_other: BSON): BOOLEAN
		note
			EIS: "name=bson_equal", "src=https://mongoc.org/libbson/current/bson_equal.html", "protocol=uri"
		do
			Result := c_bson_equal (item, a_other.item)
		end

feature -- Append Array

	bson_append_array (a_key: STRING_32; a_array: BSON)
			-- Append and array `a_array` using the specified key `a_key` to current bson document.
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_array (item, c_key.item, c_key.count, a_array.item)
		end

	bson_append_arrary_begin (a_key: STRING_32): BSON
			-- Start appending an array field to the current bson document.
		local
			c_key: C_STRING
			l_res: BOOLEAN
			l_result: BSON
		do
			create c_key.make (a_key)
			create l_result.make
			l_res := c_bson_append_array_begin (item, c_key.item, c_key.count, l_result.item)
			Result := l_result
		end

	bson_append_array_end (a_bson: BSON)
			-- Complete the appending of an array started with `bson_append_arrary_begin`
		local
			l_res: BOOLEAN
		do
			l_res := c_bson_append_array_end (item, a_bson.item)
		end

feature -- Min Key , Max Key

	bson_append_minkey (a_key: STRING_32)
		note
			EIS: "name=bson_append_maxkey", "src=http://mongoc.org/libbson/current/bson_append_maxkey.html", "protocol=uri"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_minkey (item, c_key.item, c_key.count)
		end

	bson_append_maxkey (a_key: STRING_32)
		note
			EIS: "name=bson_append_maxkey", "src=http://mongoc.org/libbson/current/bson_append_maxkey.html", "protocol=uri"
		local
			c_key: C_STRING
			l_res: BOOLEAN
		do
			create c_key.make (a_key)
			l_res := c_bson_append_maxkey (item, c_key.item, c_key.count)
		end


feature -- Status Report

	bson_count_keys: INTEGER
		note
			EIS:"name=bson_count_keys", "src=https://mongoc.org/libbson/current/bson_count_keys.html", "protocol=url"
		do
			Result := c_bson_count_keys (item)
		end

	bson_has_field (a_key: STRING): BOOLEAN
		note
			EIS:"name=bson_has_field ", "src=https://mongoc.org/libbson/current/bson_has_field.html", "protocol=url"
		local
			l_str: C_STRING
		do
			create l_str.make (a_key)
			Result := c_bson_has_field (item, l_str.item)
		end

    bson_validate (flags: INTEGER): BOOLEAN
            -- Validates a BSON document by walking through the document and inspecting
            -- the keys and values for valid content.
            -- `flags`: A bitwise-or of all desired bson_validate_flags_t.
            -- Returns: True if document passes the requested validations, False otherwise.
        note
            EIS: "name=bson_validate", "src=https://mongoc.org/libbson/current/bson_validate.html", "protocol=uri"
        local
            l_offset: POINTER
        do
            Result := c_bson_validate (item, flags, l_offset)
        end

    bson_validate_with_error (flags: INTEGER): BOOLEAN
            -- Validates a BSON document with detailed error reporting.
            -- `flags`: A bitwise-or of all desired bson_validate_flags_t.
            -- Returns: True if document passes the requested validations, False otherwise.
        note
            EIS: "name=bson_validate_with_error", "src=https://mongoc.org/libbson/current/bson_validate_with_error.html", "protocol=uri"
        local
            l_error: BSON_ERROR
        do
            create l_error.make
            Result := c_bson_validate_with_error (item, flags, l_error.item)
        end

feature -- BSON to JSON string

	bson_as_json: STRING
		obsolete "[
			Deprecated since version 1.29.0: Use bson_as_canonical_extended_json() and bson_as_relaxed_extended_json() instead,
			which use the same MongoDB Extended JSON format as all other MongoDB drivers. [2024-11-25]
			]"
		local
			l_res: C_STRING
		do
			create l_res.make_by_pointer (c_bson_as_json (item, default_pointer))
			Result := l_res.string
		end

	bson_as_canonical_extended_json: STRING
		note
			EIS: "name=bson_as_canonical_extended_json", "src=https://mongoc.org/libbson/current/bson_as_canonical_extended_json.html", "protocol=url"
		local
			l_res: C_STRING
		do
			create l_res.make_by_pointer (c_bson_as_canonical_extended_json (item, default_pointer))
			Result := l_res.string
		end

	bson_as_relaxed_extended_json: STRING
		note
			EIS: "name=bson_as_relaxed_extended_json", "src=https://mongoc.org/libbson/current/bson_as_relaxed_extended_json.html", "protocol=url"
		local
			l_res: C_STRING
		do
			create l_res.make_by_pointer (c_bson_as_relaxed_extended_json (item, default_pointer))
			Result := l_res.string
		end

	bson_array_as_json: STRING
		local
			l_res: C_STRING
		do
			create l_res.make_by_pointer (c_bson_array_as_json (item))
			Result := l_res.string
		end

feature -- BSON to JSON value		

	bson_as_json_value: JSON_VALUE
		obsolete "[
			Deprecated since version 1.29.0: Use bson_as_canonical_extended_json() and bson_as_relaxed_extended_json() instead,
			which use the same MongoDB Extended JSON format as all other MongoDB drivers. [2024-11-25]
			]"
		do
			Result := to_json_value (bson_as_json)
		end

	bson_as_canonical_extended_json_value: JSON_VALUE
		note
			EIS: "name=bson_as_canonical_extended_json", "src=https://mongoc.org/libbson/current/bson_as_canonical_extended_json.html", "protocol=url"
		do
			Result := to_json_value (bson_as_canonical_extended_json)
		end

	bson_as_relaxed_extended_json_value: JSON_VALUE
		note
			EIS: "name=bson_as_relaxed_extended_json", "src=https://mongoc.org/libbson/current/bson_as_relaxed_extended_json.html", "protocol=url"
		do
			Result := to_json_value (bson_as_relaxed_extended_json)
		end

	bson_array_as_json_value: JSON_VALUE
		do
			Result := to_json_value (bson_array_as_json)
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
					-- Memory is handled by the C lib
			else
				if exists then
					c_bson_destroy (item)
				else
					check exists: False end
				end
			end        	
		end

feature -- Measurement

	 bson_max_size: INTEGER_32
            -- The maximum size in bytes of a BSON document.
            -- This limit exists because BSON uses a 32-bit integer for document lengths.
        do
            Result := {INTEGER_32}.max_value  -- This is (2^31 - 1)
        ensure
        	instance_free: class
        end

	structure_size: INTEGER
		external
			"C inline use <bson/bson.h>"
		alias
			"return sizeof(bson_t);"
		end


feature {NONE} -- JSON helper

	to_json_value (s: READABLE_STRING_8): JSON_VALUE
		local
			p: JSON_PARSER
		do
			create p.make
			p.parse_string (s)
			if p.is_parsed and p.is_valid then
				Result := p.parsed_json_value
			end
			if Result = Void then
				create {JSON_NULL} Result
			end
		end

feature {NONE} -- C externals

	c_bson_init (a_bson_t: POINTER)
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_init ((bson_t *)$a_bson_t);"
		end

	c_bson_new: POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_new()"
		end


	c_bson_append_utf8 (a_bson_t: POINTER; a_key: POINTER; a_key_length: INTEGER; a_value: POINTER; a_length: INTEGER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_utf8 ((bson_t *)$a_bson_t, (const char *)$a_key, (int)$a_key_length, (const char *)$a_value, (int) $a_length);"
		end

	c_bson_as_json (a_bson_t: POINTER; a_length: detachable POINTER): POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_as_json ((const bson_t *)$a_bson_t, (size_t *)$a_length);"
		end

	c_bson_as_canonical_extended_json (a_bson_t: POINTER; a_length: detachable POINTER): POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_as_canonical_extended_json ((const bson_t *)$a_bson_t, (size_t *)$a_length)"
		end

	c_bson_as_relaxed_extended_json (a_bson: POINTER; a_length: detachable POINTER): POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_as_relaxed_extended_json ((const bson_t *)$a_bson, (size_t *)$a_length);"
		end

	c_bson_append_bool (a_bson_t: POINTER; a_key: POINTER; a_length: INTEGER; a_value: BOOLEAN): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_bool ((bson_t *)$a_bson_t, (const char *)$a_key, (int) $a_length, (bool)$a_value);"
		end

	c_bson_append_document (a_bson_t: POINTER; a_key: POINTER; a_length: INTEGER; a_value: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_document ((bson_t *)$a_bson_t, (const char *)$a_key,(int)$a_length, (const bson_t *)$a_value);"
		end

	c_bson_append_document_begin (a_bson: POINTER; a_key: POINTER; a_length: INTEGER; a_child: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_document_begin ((bson_t  *)$a_bson, (const char *)$a_key, ( int) $a_length, (bson_t *)$a_child);"
		end

	c_bson_append_document_end (a_bson: POINTER; a_child: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_document_end ((bson_t  *)$a_bson, (bson_t *)$a_child);"
		end

	c_bson_append_int32 (a_bson_t: POINTER; a_key: POINTER; a_length: INTEGER; a_value: INTEGER_32): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_int32 ((bson_t *)$a_bson_t, (const char *) $a_key,(int)$a_length,(int32_t) $a_value);"
		end

	c_bson_append_int64 (a_bson_t: POINTER; a_key: POINTER; a_length: INTEGER; a_value: INTEGER_64): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_int64 ((bson_t *)$a_bson_t, (const char *) $a_key,(int)$a_length,(int64_t) $a_value);"
		end

	c_bson_append_array_begin (a_bson_t: POINTER; a_key: POINTER; a_length: INTEGER; a_child: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_array_begin ((bson_t *)$a_bson_t, (const char *)$a_key, (int)$a_length, (bson_t  *)$a_child);"
		end

	c_bson_append_array_end (a_bson_t: POINTER; a_child: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_array_end ((bson_t *)$a_bson_t, (bson_t *)$a_child);"
		end

	c_bson_append_array (a_bson_t: POINTER; a_key: POINTER; a_length: INTEGER; a_array: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_array ((bson_t *)$a_bson_t, (const char *)$a_key, (int)$a_length, (bson_t  *)$a_array);"
		end

	c_bson_count_keys (a_bson_t: POINTER): INTEGER_32
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_count_keys ((const bson_t *)$a_bson_t);"
		end

	c_bson_has_field (a_bson_t: POINTER; a_key: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_has_field ((const bson_t *)$a_bson_t, (const char   *)$a_key);"
		end

	c_bson_append_code (a_bson_t: POINTER; a_key: POINTER; a_length: INTEGER; a_javascript: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_code ((bson_t *)$a_bson_t, (const char *)$a_key,(int )$a_length, (const char *)$a_javascript);"
		end

	c_bson_append_code_scope (a_bson_t: POINTER; a_key: POINTER; a_length: INTEGER; a_javascript: POINTER; a_scope: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_code_with_scope ((bson_t *)$a_bson_t, (const char *)$a_key,(int )$a_length, (const char *)$a_javascript, (const bson_t *)$a_scope);"
		end

	c_bson_append_double (a_bson_t: POINTER; a_key: POINTER; a_length: INTEGER; a_value: REAL_64): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_double ((bson_t *)$a_bson_t, (const char *) $a_key,(int)$a_length,(double) $a_value);"
		end

	c_bson_append_minkey (a_bson_t: POINTER; a_key: POINTER; a_length: INTEGER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_minkey ((bson_t *)$a_bson_t, (const char *) $a_key,(int)$a_length);"
		end

	c_bson_append_maxkey (a_bson: POINTER; a_key: POINTER; a_key_length: INTEGER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_maxkey ((bson_t *)$a_bson, (const char *)$a_key, (int)$a_key_length);"
		end

	c_bson_append_binary (a_bson: POINTER; a_key: POINTER; a_key_length: INTEGER; a_subtype: INTEGER; a_binary: POINTER; a_length: INTEGER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_binary ((bson_t *)$a_bson,(const char *)$a_key,(int)$a_key_length, (bson_subtype_t)$a_subtype, (const uint8_t *)$a_binary, (uint32_t)$a_length);"
		end

	c_bson_append_null (a_bson: POINTER; a_key: POINTER; a_key_length: INTEGER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_null ((bson_t *)$a_bson, (const char *)$a_key, (int)$a_key_length);"
		end

	c_bson_append_oid (a_bson: POINTER; a_key: POINTER; a_key_length: INTEGER; a_oid: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_oid ((bson_t *)$a_bson, (const char *)$a_key, (int) $a_key_length, (const bson_oid_t *)$a_oid);"
		end

	c_bson_append_time_t (a_bson: POINTER; a_key: POINTER; a_key_length: INTEGER; a_val: INTEGER_64): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_time_t ((bson_t *)$a_bson, (const char *)$a_key, (int) $a_key_length, (time_t) $a_val);"
		end

	c_bson_append_timestamp (a_bson: POINTER; a_key: POINTER; a_key_length: INTEGER; a_timestamp: INTEGER_64; a_increment: INTEGER_64): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_timestamp ((bson_t *)$a_bson, (const char *)$a_key, (int)$a_key_length, (uint32_t) $a_timestamp, (uint32_t) $a_increment);"
		end

	c_bson_append_regex (a_bson: POINTER; a_key: POINTER; a_key_length: INTEGER; a_regex: POINTER; a_options: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_regex ((bson_t *)$a_bson, (const char *)$a_key, (int)$a_key_length, (const char *)$a_regex, (const char *)$a_options);"
		end


	c_bson_append_symbol (a_bson: POINTER; a_key: POINTER; a_key_length: INTEGER; a_value: POINTER; a_length: INTEGER): BOOLEAN
		obsolete "This BSON type is deprecated and should not be used in new code."
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_symbol ((bson_t *)$a_bson, (const char *)$a_key, (int) $a_key_length, (const char *)$a_value, (int)$a_length);"
		end

	c_bson_append_decimal128 (a_bson: POINTER; a_key: POINTER; a_key_length: INTEGER; a_value: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_decimal128 ((bson_t *)$a_bson, (const char *)$a_key, (int)$a_key_length, (const bson_decimal128_t *)$a_value);"
		end

	c_bson_array_as_json (a_bson: POINTER): POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_array_as_json ((const bson_t *)$a_bson,NULL);"
		end

	c_bson_compare (a_bson: POINTER; a_other: POINTER): INTEGER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_compare ((const bson_t *)$a_bson, (const bson_t *)$a_other);"
		end

	c_bson_concat (a_dst: POINTER; a_src: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_concat ((const bson_t *)$a_dst, (const bson_t *)$a_src);"
		end

	c_bson_copy (a_bson: POINTER): POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_copy ((const bson_t *)$a_bson);"
		end

	c_bson_copy_to (a_src: POINTER; a_dst: POINTER)
		external
			"C inline use <bson/bson.h>"
		alias
			"bson_copy_to ((const bson_t *)$a_src, (bson_t *)$a_dst);"
		end

	c_bson_equal (a_bson: POINTER; a_other: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_equal ((const bson_t *)$a_bson, (const bson_t *)$a_other);"
		end

	c_bson_get_data (a_bson: POINTER): POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_get_data ((const bson_t *)$a_bson);"
		end

	c_bson_len (a_bson: POINTER): INTEGER
		external "C inline use <bson/bson.h>"
		alias
			"return ((bson_t *) $a_bson)->len;"
		end

	c_bson_new_from_json (a_data: POINTER; a_len: INTEGER; a_error: POINTER): POINTER
		external "C inline use <bson/bson.h>"
		alias
			"return bson_new_from_json ((const uint8_t *)$a_data, (ssize_t)$a_len, (bson_error_t *)$a_error);"
		end

	c_bson_append_date_time (a_bson: POINTER; a_key: POINTER; a_length: INTEGER; a_value: INTEGER_64): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"[
				return (EIF_BOOLEAN) bson_append_date_time ((bson_t *)$a_bson, (const char *)$a_key, (int)$a_length, (int64_t)$a_value);
			]"
		end

	c_bson_append_iter (a_bson: POINTER; a_key: POINTER; a_length: INTEGER; a_iter: POINTER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"[
				return (EIF_BOOLEAN) bson_append_iter ((bson_t *)$a_bson, (const char *)$a_key, (int) $a_length, (const bson_iter_t *)$a_iter);
			]"
		end

	c_bson_append_now_utc (a_bson: POINTER; a_key: POINTER; a_length: INTEGER): BOOLEAN
		external "C inline use <bson/bson.h>"
		alias
			"[
				return (EIF_BOOLEAN) bson_append_now_utc ((bson_t *)$a_bson, (const char *)$a_key, (int)$a_length);
			]"
		end

	c_bson_append_timeval (a_bson: POINTER; a_key: POINTER; a_key_length: INTEGER; a_value: POINTER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_timeval ((bson_t *)$a_bson, (const char *)$a_key, (int)$a_key_length, (struct timeval *)$a_value);"
		end

	c_bson_append_undefined (a_bson: POINTER; a_key: POINTER; a_key_length: INTEGER): BOOLEAN
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_append_undefined ((bson_t *)$a_bson, (const char *)$a_key, (int)$a_key_length);"
		end

	c_bson_destroy (a_bson: POINTER)
		external "C inline use <bson/bson.h>"
		alias
			"[
				bson_destroy ((bson_t *)$a_bson);
			]"
		end

    c_bson_validate (a_bson: POINTER; a_flags: INTEGER; a_offset: POINTER): BOOLEAN
        external
            "C inline use <bson/bson.h>"
        alias
            "return bson_validate ((const bson_t *)$a_bson, (bson_validate_flags_t)$a_flags, (size_t *)$a_offset);"
        end

    c_bson_validate_with_error (a_bson: POINTER; a_flags: INTEGER; a_error: POINTER): BOOLEAN
        external
            "C inline use <bson/bson.h>"
        alias
            "return bson_validate_with_error ((const bson_t *)$a_bson, (bson_validate_flags_t)$a_flags, (bson_error_t *)$a_error);"
        end

	c_bson_append_value (a_bson: POINTER; a_key: POINTER; a_key_length: INTEGER; a_value: POINTER): BOOLEAN
		external "C inline use <bson.h>"
		alias
			"return bson_append_value ((bson_t *)$a_bson, (const char *)$a_key, (int)$a_key_length, (bson_value_t *)$a_value);"
		end

invariant
    max_size_positive: True -- current bson size is > 0
    max_size_within_int32: True -- current bson size is <= max_bson_sise = {INTEGER_32}.max_value
end
