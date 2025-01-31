note
	description: "[
			Object representing a mongoc_find_and_modify_opts_t structure.
			It provides a builder interface to construct the findAndModify command.
			It was created to be able to accommodate new arguments to the findAndModify command.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_find_and_modify_opts_t", "src=http://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_t.html", "protocol=uri"

class
	MONGODB_FIND_AND_MODIFY_OPTIONS

inherit
	MONGODB_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make, make_by_pointer

feature {NONE} -- Initialization

	make
			-- Creates a new find and modify options instance.
		do
			memory_make
			make_by_pointer (c_mongoc_find_and_modify_opts_new)
		end

feature -- Access

	bypass_document_validation: BOOLEAN
			-- Get if document validation is bypassed
		note
			eis: "name=mongoc_find_and_modify_opts_get_bypass_document_validation", "src=https://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_get_bypass_document_validation.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			Result := c_mongoc_find_and_modify_opts_get_bypass_document_validation (item)
		end

	fields: BSON
			-- Get the fields to return.
			-- Note: Returns a copy of the fields document that was set with set_fields,
			-- or an empty BSON document if no fields were set.
		note
			EIS: "name=mongoc_find_and_modify_opts_get_fields", "src=http://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_get_fields.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			create Result.make
			c_mongoc_find_and_modify_opts_get_fields (item, Result.item)
		end

	flags: MONGODB_FIND_AND_MODIFY_FLAGS
			-- Get the flags for the operation.
			-- Returns the flags set with set_flags.
		note
			EIS: "name=mongoc_find_and_modify_opts_get_flags", "src=http://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_get_flags.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			create Result.make
			Result.set_value (c_mongoc_find_and_modify_opts_get_flags (item))
		end

	max_time_ms: NATURAL_32
			-- Get the maximum time in milliseconds
		note
			eis: "name=mongoc_find_and_modify_opts_get_max_time_ms ", "src=https://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_get_max_time_ms.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			Result := c_mongoc_find_and_modify_opts_get_max_time_ms (item)
		end

	sort: BSON
			-- Get the sort specification.
			-- Note: Returns a copy of the sort document that was set with set_sort,
			-- or an empty BSON document if no sort was set.
		note
			EIS: "name=mongoc_find_and_modify_opts_get_sort", "src=http://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_get_sort.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			create Result.make
			c_mongoc_find_and_modify_opts_get_sort (item, Result.item)
		end

	update: BSON
			-- Get the update specification.
			-- Note: Returns a copy of the update document that was set with set_update,
			-- or an empty BSON document if no update was set.
		note
			EIS: "name=mongoc_find_and_modify_opts_get_update", "src=http://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_get_update.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			create Result.make -- Create an uninitialized BSON document
			c_mongoc_find_and_modify_opts_get_update (item, Result.item)
		ensure
			result_not_void: Result /= Void
		end

feature -- Settings

	set_bypass_document_validation (a_bypass: BOOLEAN)
			-- Set if document validation should be bypassed.
			-- Note: This option is only available with MongoDB 3.2 and later.
			-- When authentication is enabled, the authenticated user must have
			-- either the "dbadmin" or "restore" roles to bypass document validation.
		note
			EIS: "name=mongoc_find_and_modify_opts_set_bypass_document_validation", "src=http://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_set_bypass_document_validation.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_res: BOOLEAN
		do
			clean_up
			l_res := c_mongoc_find_and_modify_opts_set_bypass_document_validation (item, a_bypass)
			if not l_res then
				set_last_error ("Error setting bypass document validation with value: [" + a_bypass.out + "]")
			end
		end

	set_fields (a_fields: BSON)
			-- Set the fields to return.
			-- Parameters:
			--   `a_fields`: A subset of fields to return. Choose which fields to include
			--     by appending {fieldname: 1} for each fieldname, or excluding it
			--     with {fieldname: 0}.
			-- Note: The fields document does not have to remain valid after calling
			-- this function.
		note
			EIS: "name=mongoc_find_and_modify_opts_set_fields", "src=http://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_set_fields.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_res: BOOLEAN
		do
			clean_up
			l_res := c_mongoc_find_and_modify_opts_set_fields (item, a_fields.item)
			if not l_res then
				set_last_error ("Error setting fields with value: [" + a_fields.bson_as_canonical_extended_json + "]")
			end
		end

	set_flags (a_flags: MONGODB_FIND_AND_MODIFY_FLAGS)
			-- Set the flags for the operation.
			-- Flags can be:
			--   * NONE - Default. Doesn't add anything to the builder.
			--   * REMOVE - Will remove the matching document.
			--   * UPSERT - Update matching document or insert if none matches.
			--   * RETURN_NEW - Return the resulting document.
			-- Note: Multiple flags can be combined.
		note
			EIS: "name=mongoc_find_and_modify_opts_set_flags", "src=http://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_set_flags.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_res: BOOLEAN
		do
			clean_up
			l_res := c_mongoc_find_and_modify_opts_set_flags (item, a_flags.value)
			if not l_res then
				set_last_error ("Error setting flags with value: [" + a_flags.value.out + "]")
			end
		end

	set_max_time_ms (a_max_time_ms: NATURAL_32)
			-- Set the maximum server-side execution time permitted, in milliseconds.
			-- Parameters:
			--   `a_max_time_ms`: Maximum time in milliseconds, or 0 for no maximum (default).
			-- Note: Although the server expects a 32-bit value, this interface accepts
			-- a 64-bit value for consistency with other MongoDB interfaces.
		note
			EIS: "name=mongoc_find_and_modify_opts_set_max_time_ms", "src=http://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_set_max_time_ms.html", "protocol=uri"
		require
			exists: exists
			valid_time: a_max_time_ms >= 0
		local
			l_res: BOOLEAN
		do
			clean_up
			l_res := c_mongoc_find_and_modify_opts_set_max_time_ms (item, a_max_time_ms)
			if not l_res then
				set_last_error ("Error setting max time ms with value: [" + a_max_time_ms.out + "]")
			end
		end

	set_sort (a_sort: BSON)
			-- Set the sort specification for the operation.
			-- Parameters:
			--   `a_sort`: Determines which document the operation modifies if the query
			--     selects multiple documents. findAndModify modifies the first document
			--     in the sort order specified by this argument.
			-- Note: The sort document does not have to remain valid after calling
			-- this function.
		note
			EIS: "name=mongoc_find_and_modify_opts_set_sort", "src=http://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_set_sort.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_res: BOOLEAN
		do
			clean_up
			l_res := c_mongoc_find_and_modify_opts_set_sort (item, a_sort.item)
			if not l_res then
				set_last_error ("Error setting sort with value: [" + a_sort.bson_as_canonical_extended_json + "]")
			end
		end

	set_update (a_update: BSON)
			-- Set the update specification.
			-- Parameters:
			--   `a_update`: The update document in the same format as used
			--     for collection update operations.
			-- Note: The update document does not have to remain valid after
			-- calling this function.
		note
			EIS: "name=mongoc_find_and_modify_opts_set_update", "src=http://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_set_update.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_res: BOOLEAN
		do
			clean_up
			l_res := c_mongoc_find_and_modify_opts_set_update (item, a_update.item)
			if not l_res then
				set_last_error ("Error setting update with value: [" + a_update.bson_as_canonical_extended_json + "]")
			end
		end

	append (a_extra: detachable BSON)
			-- Adds arbitrary options to the findAndModify command.
			-- Parameters:
			--   `a_extra`: Optional BSON document with additional command options:
			--     * writeConcern: Write concern for the operation
			--     * sessionId: Client session ID for transactions
			--     * hint: Document or string specifying the index to use
			--     * let: Document with parameter definitions in MQL Aggregate Expression language
			--     * comment: Comment to attach to this command (MongoDB 4.4+)
			-- Note: The extra document does not have to remain valid after calling this function.
		note
			EIS: "name=mongoc_find_and_modify_opts_append", "src=http://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_append.html", "protocol=uri"
		require
			exists: exists
		local
			l_res: BOOLEAN
			l_extra: POINTER
		do
			clean_up
			if attached a_extra then
				l_extra := a_extra.item
			end
			l_res := c_mongoc_find_and_modify_opts_append (item, l_extra)
			if not l_res then
				set_last_error ("Error appending extra options to find and modify command")
			end
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if not shared then
				if exists then
					c_mongoc_find_and_modify_opts_destroy (item)
				else
					check exists: False end
				end
			end
		end

feature -- Measurement

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

feature {NONE} -- Implementation

	struct_size: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return sizeof(mongoc_find_and_modify_opts_t *);"
		end

feature -- Externals

	c_mongoc_find_and_modify_opts_new: POINTER
			-- Create new find and modify options
		note
			eis: "name=mongoc_find_and_modify_opts_new", "src=https://mongoc.org/libmongoc/current/mongoc_find_and_modify_opts_new.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_find_and_modify_opts_new();"
		end

	c_mongoc_find_and_modify_opts_destroy (a_opts: POINTER)
			-- Destroy find and modify options
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_find_and_modify_opts_destroy((mongoc_find_and_modify_opts_t *)$a_opts);"
		end

	c_mongoc_find_and_modify_opts_append (a_opts: POINTER; a_extra: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_find_and_modify_opts_append((mongoc_find_and_modify_opts_t *)$a_opts, (const bson_t *)$a_extra);"
		end

	c_mongoc_find_and_modify_opts_get_bypass_document_validation (a_opts: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_find_and_modify_opts_get_bypass_document_validation((const mongoc_find_and_modify_opts_t *)$a_opts);"
		end

	c_mongoc_find_and_modify_opts_get_fields (a_opts: POINTER; a_fields: POINTER)
			-- Copy fields document to the provided BSON structure
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_find_and_modify_opts_get_fields((const mongoc_find_and_modify_opts_t *)$a_opts, (bson_t *)$a_fields);"
		end

	c_mongoc_find_and_modify_opts_get_flags (a_opts: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_find_and_modify_opts_get_flags((const mongoc_find_and_modify_opts_t *)$a_opts);"
		end

	c_mongoc_find_and_modify_opts_get_max_time_ms (a_opts: POINTER): NATURAL_32
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_find_and_modify_opts_get_max_time_ms((const mongoc_find_and_modify_opts_t *)$a_opts);"
		end

	c_mongoc_find_and_modify_opts_get_sort (a_opts: POINTER; a_sort: POINTER)
			-- Copy sort document to the provided BSON structure
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_find_and_modify_opts_get_sort((const mongoc_find_and_modify_opts_t *)$a_opts, (bson_t *)$a_sort);"
		end

	c_mongoc_find_and_modify_opts_get_update (a_opts: POINTER; a_update: POINTER)
			-- Copy update document to the provided BSON structure
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_find_and_modify_opts_get_update((const mongoc_find_and_modify_opts_t *)$a_opts, (bson_t *)$a_update);"
		end

	c_mongoc_find_and_modify_opts_set_bypass_document_validation (a_opts: POINTER; a_bypass: BOOLEAN): BOOLEAN
			-- Set bypass document validation option.
			-- Returns true if successfully added the option, false otherwise.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_find_and_modify_opts_set_bypass_document_validation((mongoc_find_and_modify_opts_t *)$a_opts, (bool)$a_bypass);"
		end

	c_mongoc_find_and_modify_opts_set_fields (a_opts: POINTER; a_fields: POINTER): BOOLEAN
			-- Set the fields to return in the result.
			-- Returns true if successfully added the option, false otherwise.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_find_and_modify_opts_set_fields((mongoc_find_and_modify_opts_t *)$a_opts, (const bson_t *)$a_fields);"
		end

	c_mongoc_find_and_modify_opts_set_flags (a_opts: POINTER; a_flags: INTEGER): BOOLEAN
			-- Set the flags for the find and modify operation.
			-- Returns true if successfully added the flags, false otherwise.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_find_and_modify_opts_set_flags((mongoc_find_and_modify_opts_t *)$a_opts, (mongoc_find_and_modify_flags_t)$a_flags);"
		end

	c_mongoc_find_and_modify_opts_set_max_time_ms (a_opts: POINTER; a_max_time_ms: NATURAL_32): BOOLEAN
			-- Set maximum execution time in milliseconds.
			-- Returns true if successfully added the option, false otherwise.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_find_and_modify_opts_set_max_time_ms((mongoc_find_and_modify_opts_t *)$a_opts, (uint32_t)$a_max_time_ms);"
		end

	c_mongoc_find_and_modify_opts_set_sort (a_opts: POINTER; a_sort: POINTER): BOOLEAN
			-- Set the sort specification for find and modify operation.
			-- Returns true if successfully added the option, false otherwise.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_find_and_modify_opts_set_sort((mongoc_find_and_modify_opts_t *)$a_opts, (const bson_t *)$a_sort);"
		end

	c_mongoc_find_and_modify_opts_set_update (a_opts: POINTER; a_update: POINTER): BOOLEAN
			-- Set the update specification for find and modify operation.
			-- Returns true if successfully added the option, false otherwise.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_find_and_modify_opts_set_update((mongoc_find_and_modify_opts_t *)$a_opts, (const bson_t *)$a_update);"
		end

end
