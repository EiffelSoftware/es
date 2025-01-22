note
	description: "[
			Object representing a mongoc_uri_t structure.
			It provides an abstraction on top of the MongoDB connection URI format. 
			It provides standardized parsing as well as convenience methods for extracting useful information such as replica hosts or authorization information.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_uri_t", "src=http://mongoc.org/libmongoc/current/mongoc_uri_t.html", "protocol=uri"

class
	MONGODB_URI

inherit

	MONGODB_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make, make_by_pointer

feature {NONE}-- Initialization

	make (a_uri: READABLE_STRING_8)
			-- Creates a new MongoClient using the URI string `a_uri' provided.
		do
			memory_make
			uri_new (a_uri)
		end

feature {NONE} -- Implementation

	uri_new (a_uri: READABLE_STRING_8)
		local
			c_string: C_STRING
			l_ptr: POINTER
			l_error: BSON_ERROR
		do
			create l_error.make
			create c_string.make (a_uri)
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_new_with_error (c_string.item, l_error.item)
			if l_ptr /= default_pointer then
				make_by_pointer (l_ptr)
			else
				create error.make_by_pointer (l_error.item)
			end
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_mongoc_uri_destroy (item)
			end
		end

feature -- Access

	uri_string: READABLE_STRING_GENERAL
			-- String representation of current URI.
		note
			EIS: "name=mongoc_uri_get_string", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_string.html", "protocol=uri"
		require
			is_useful: exists
		local
			c_string: C_STRING
		do
			clean_up
			create c_string.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_uri_get_string (item))
			Result := c_string.string
		end

	get_auth_mechanism: detachable READABLE_STRING_GENERAL
			-- Fetches the authMechanism parameter if provided.
			-- Returns Void if the authMechanism parameter was not provided.
		note
			EIS: "name=mongoc_uri_get_auth_mechanism", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_auth_mechanism.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
			c_string: C_STRING
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_get_auth_mechanism (item)
			if not l_ptr.is_default_pointer then
				create c_string.make_by_pointer (l_ptr)
				Result := c_string.string
			end
		end

	get_auth_source: detachable READABLE_STRING_GENERAL
			-- Fetches the authSource parameter if provided.
			-- Returns Void if the authSource parameter was not provided.
		note
			EIS: "name=mongoc_uri_get_auth_source", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_auth_source.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
			c_string: C_STRING
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_get_auth_source (item)
			if not l_ptr.is_default_pointer then
				create c_string.make_by_pointer (l_ptr)
				Result := c_string.string
			end
		end

	get_compressors: BSON
			-- Returns a BSON document with the enabled compressors as the keys
			-- or an empty document if no compressors were provided.
		note
			EIS: "name=mongoc_uri_get_compressors", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_compressors.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_get_compressors (item)
			if l_ptr.is_default_pointer then
				create Result.make
			else
				create Result.make_by_pointer (l_ptr)
			end
		end

	get_database: detachable READABLE_STRING_GENERAL
			-- Fetches the database portion of the URI if provided.
			-- This is the portion after the '/' but before the '?'.
			-- Returns Void if no database was specified.
		note
			EIS: "name=mongoc_uri_get_database", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_database.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
			c_string: C_STRING
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_get_database (item)
			if not l_ptr.is_default_pointer then
				create c_string.make_by_pointer (l_ptr)
				Result := c_string.string
			end
		end

	get_hosts: detachable MONGODB_HOST_LIST
			-- Fetches a linked list of hosts that were defined in the URI.
			-- Returns Void if this URI's scheme is "mongodb+srv://".
		note
			EIS: "name=mongoc_uri_get_hosts", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_hosts.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_get_hosts (item)
			if not l_ptr.is_default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	get_mechanism_properties: detachable BSON
            -- Fetches the "authMechanismProperties" options.
            -- Returns Void if no "authMechanismProperties" have been set.
        note
            EIS: "name=mongoc_uri_get_mechanism_properties", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_mechanism_properties.html", "protocol=uri"
        require
            is_useful: exists
        local
            l_bson: BSON
            l_success: BOOLEAN
        do
            clean_up
            create l_bson.make
            l_success := {MONGODB_EXTERNALS}.c_mongoc_uri_get_mechanism_properties (item, l_bson.item)
            if l_success then
                Result := l_bson
            end
        end

	get_option_as_bool (option: READABLE_STRING_8; fallback: BOOLEAN): BOOLEAN
            -- Returns the value of the URI option if it is set and of the correct type (bool).
            -- If not set, or set to an invalid type, returns `fallback`.
            -- Note: option name is case insensitive.
        note
            EIS: "name=mongoc_uri_get_option_as_bool", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_option_as_bool.html", "protocol=uri"
        require
            is_useful: exists
            option_not_empty: not option.is_empty
        local
            c_string: C_STRING
        do
            clean_up
            create c_string.make (option)
            Result := {MONGODB_EXTERNALS}.c_mongoc_uri_get_option_as_bool (item, c_string.item, fallback)
        end

	get_option_as_int32 (option: READABLE_STRING_8; fallback: INTEGER): INTEGER
            -- Returns the value of the URI option if it is set and of the correct type (int32).
            -- If not set, or set to an invalid type, returns `fallback`.
            -- Note: option name is case insensitive.
        note
            EIS: "name=mongoc_uri_get_option_as_int32", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_option_as_int32.html", "protocol=uri"
        require
            is_useful: exists
            option_not_empty: not option.is_empty
        local
            c_string: C_STRING
        do
            clean_up
            create c_string.make (option)
            Result := {MONGODB_EXTERNALS}.c_mongoc_uri_get_option_as_int32 (item, c_string.item, fallback)
        end

    get_option_as_int64 (option: READABLE_STRING_8; fallback: INTEGER_64): INTEGER_64
            -- Returns the value of the URI option if it is set and of the correct type (integer).
            -- Returns `fallback` if the option is not set, set to an invalid type, or zero.
            -- Note: Zero is considered "unset", so URIs can be constructed with zero values
            -- and still accept default values.
            -- Note: option name is case insensitive.
        note
            EIS: "name=mongoc_uri_get_option_as_int64", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_option_as_int64.html", "protocol=uri"
        require
            is_useful: exists
            option_not_empty: not option.is_empty
        local
            c_string: C_STRING
        do
            clean_up
            create c_string.make (option)
            Result := {MONGODB_EXTERNALS}.c_mongoc_uri_get_option_as_int64 (item, c_string.item, fallback)
        end

    get_option_as_utf8 (option: READABLE_STRING_8; fallback: detachable READABLE_STRING_8): detachable READABLE_STRING_8
            -- Returns the value of the URI option if it is set and of the correct type (string).
            -- If not set, or set to an invalid type, returns `fallback`.
            -- Note: option name is case insensitive.
        note
            EIS: "name=mongoc_uri_get_option_as_utf8", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_option_as_utf8.html", "protocol=uri"
        require
            is_useful: exists
            option_not_empty: not option.is_empty
        local
            c_string_option: C_STRING
            c_string_fallback: detachable C_STRING
            l_ptr: POINTER
            c_result: C_STRING
        do
            clean_up
            create c_string_option.make (option)
            if attached fallback as l_fallback then
                create c_string_fallback.make (l_fallback)
                l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_get_option_as_utf8 (item, c_string_option.item, c_string_fallback.item)
            else
                l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_get_option_as_utf8 (item, c_string_option.item, default_pointer)
            end

            if not l_ptr.is_default_pointer then
                create c_result.make_by_pointer (l_ptr)
                Result := c_result.string
            end
        end

	 get_options: detachable BSON
            -- Fetches a BSON document containing all of the options provided after the ? of a URI.
            -- Returns Void if no options were provided.
        note
            EIS: "name=mongoc_uri_get_options", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_options.html", "protocol=uri"
        require
            is_useful: exists
        local
            l_ptr: POINTER
        do
            clean_up
            l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_get_options (item)
            if not l_ptr.is_default_pointer then
                create Result.make_by_pointer (l_ptr)
            end
        end

	get_password: detachable READABLE_STRING_GENERAL
			-- Fetches the password portion of the URI if provided.
			-- Returns Void if no password was specified.
		note
			EIS: "name=mongoc_uri_get_password", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_password.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
			c_string: C_STRING
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_get_password (item)
			if not l_ptr.is_default_pointer then
				create c_string.make_by_pointer (l_ptr)
				Result := c_string.string
			end
		end

	get_read_concern: detachable MONGODB_READ_CONCERN
			-- Fetches a read concern that is owned by the URI instance.
			-- This read concern is configured based on URI parameters.
			-- Returns Void if no read concern is provided.
		note
			EIS: "name=mongoc_uri_get_read_concern", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_read_concern.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_get_read_concern (item)
			if not l_ptr.is_default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	get_read_prefs: detachable MONGODB_READ_PREFERENCE
			-- Fetches a read preference that is owned by the URI instance.
			-- This read preference is configured based on URI parameters.
			-- Returns Void if no read preferences are provided.
		note
			EIS: "name=mongoc_uri_get_read_prefs_t", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_read_prefs_t.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_get_read_prefs_t (item)
			if not l_ptr.is_default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	get_replica_set: detachable READABLE_STRING_GENERAL
			-- Fetches the replicaSet parameter of the URI if provided.
			-- Returns Void if the replicaSet parameter was not provided.
		note
			EIS: "name=mongoc_uri_get_replica_set", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_replica_set.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
			c_string: C_STRING
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_get_replica_set (item)
			if not l_ptr.is_default_pointer then
				create c_string.make_by_pointer (l_ptr)
				Result := c_string.string
			end
		end

feature -- Operations

	uri_copy: detachable MONGODB_URI
			-- Copies the entire contents of the current URI.
		note
			EIS: "name=mongo_uri_copy", "src=http://mongoc.org/libmongoc/current/mongoc_uri_copy.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_copy (item)
			if not l_ptr.is_default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

feature {NONE} -- Measurement

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

	struct_size: INTEGER
		external
			"C inline use<mongoc/mongoc.h>"
		alias
			"return sizeof(mongoc_uri_t *);"
		end

	c_mongoc_uri_destroy (a_uri: POINTER)
		external
			"C inline use<mongoc/mongoc.h>"
		alias
			"mongoc_uri_destroy ((mongoc_uri_t *)$a_uri);"
		end



end
