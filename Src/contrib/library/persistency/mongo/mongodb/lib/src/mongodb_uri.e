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
	make, make_for_host_port, make_by_pointer

feature {NONE}-- Initialization

	make (a_uri: READABLE_STRING_8)
			-- Creates a new MongoClient using the URI string `a_uri' provided.
		do
			new_uri (a_uri)
		end

	make_for_host_port  (a_hostname: READABLE_STRING_8; a_port: NATURAL_16)
			-- Creates a new URI based on the hostname `a_hostname' and port `a_port' provided.
		require
			hostname_not_empty: not a_hostname.is_empty
			valid_port: a_port > 0
		do
			new_for_host_port (a_hostname, a_port)
		end

feature {NONE} -- Implementation

	new_uri (a_uri: READABLE_STRING_8)
		note
			eis: "name=mongoc_uri_new_with_error", "src=https://mongoc.org/libmongoc/current/mongoc_uri_new_with_error.html", "protocol=uri"
		local
			c_string: C_STRING
			l_ptr: POINTER
			l_error: BSON_ERROR
		do
			create l_error.make
			create c_string.make (a_uri)
			l_ptr := c_mongoc_uri_new_with_error (c_string.item, l_error.item)
			if l_ptr /= default_pointer then
				make_by_pointer (l_ptr)
			else
				set_last_error_with_bson (l_error)
			end
		end


	new_for_host_port (a_hostname: READABLE_STRING_8; a_port: NATURAL_16)
			-- Creates a new URI based on the hostname and port provided.
		note
			EIS: "name=mongoc_uri_new_for_host_port", "src=http://mongoc.org/libmongoc/current/mongoc_uri_new_for_host_port.html", "protocol=uri"
		local
			c_string: C_STRING
			l_ptr: POINTER
		do
			create c_string.make (a_hostname)
			l_ptr := c_mongoc_uri_new_for_host_port (c_string.item, a_port)
			if l_ptr /= default_pointer then
				make_by_pointer (l_ptr)
			else
				set_last_error ("Failed to create URI for host: " + a_hostname + " and port: " + a_port.out)
			end
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if not shared then
				if exists then
					c_mongoc_uri_destroy (item)
				else
					check exists: False end
				end
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
			create c_string.make_by_pointer (c_mongoc_uri_get_string (item))
			Result := c_string.string
		end

	auth_mechanism: detachable READABLE_STRING_GENERAL
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
			l_ptr := c_mongoc_uri_get_auth_mechanism (item)
			if not l_ptr.is_default_pointer then
				create c_string.make_by_pointer (l_ptr)
				Result := c_string.string
			end
		end

	auth_source: detachable READABLE_STRING_GENERAL
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
			l_ptr := c_mongoc_uri_get_auth_source (item)
			if not l_ptr.is_default_pointer then
				create c_string.make_by_pointer (l_ptr)
				Result := c_string.string
			end
		end

	compressors: BSON
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
			l_ptr := c_mongoc_uri_get_compressors (item)
			if l_ptr.is_default_pointer then
				create Result.make
			else
				create Result.make_by_pointer (l_ptr)
			end
		end

	database: detachable READABLE_STRING_GENERAL
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
			l_ptr := c_mongoc_uri_get_database (item)
			if not l_ptr.is_default_pointer then
				create c_string.make_by_pointer (l_ptr)
				Result := c_string.string
			end
		end

	hosts: detachable MONGODB_HOST_LIST
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
			l_ptr := c_mongoc_uri_get_hosts (item)
			if not l_ptr.is_default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	auth_mechanism_properties: detachable BSON
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
            l_success := c_mongoc_uri_get_mechanism_properties (item, l_bson.item)
            if l_success then
                Result := l_bson
            end
        end

	option_as_bool (a_option: READABLE_STRING_8; a_fallback: BOOLEAN): BOOLEAN
            -- Returns the value of the URI option if it is set and of the correct type (bool).
            -- If not set, or set to an invalid type, returns `fallback`.
            -- Note: option name is case insensitive.
        note
            EIS: "name=mongoc_uri_get_option_as_bool", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_option_as_bool.html", "protocol=uri"
        require
            is_useful: exists
            is_valid_option: not a_option.is_empty
        local
            c_string: C_STRING
        do
            clean_up
            create c_string.make (a_option)
            Result := c_mongoc_uri_get_option_as_bool (item, c_string.item, a_fallback)
        end

	option_as_int32 (a_option: READABLE_STRING_8; a_fallback: INTEGER): INTEGER
            -- Returns the value of the URI option if it is set and of the correct type (int32).
            -- If not set, or set to an invalid type, returns `fallback`.
            -- Note: option name is case insensitive.
        note
            EIS: "name=mongoc_uri_get_option_as_int32", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_option_as_int32.html", "protocol=uri"
        require
            is_useful: exists
            is_valid_option: not a_option.is_empty
        local
            c_string: C_STRING
        do
            clean_up
            create c_string.make (a_option)
            Result := c_mongoc_uri_get_option_as_int32 (item, c_string.item, a_fallback)
        end

    option_as_int64 (a_option: READABLE_STRING_8; a_fallback: INTEGER_64): INTEGER_64
            -- Returns the value of the URI option if it is set and of the correct type (integer).
            -- Returns `fallback` if the option is not set, set to an invalid type, or zero.
            -- Note: Zero is considered "unset", so URIs can be constructed with zero values
            -- and still accept default values.
            -- Note: option name is case insensitive.
        note
            EIS: "name=mongoc_uri_get_option_as_int64", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_option_as_int64.html", "protocol=uri"
        require
            is_useful: exists
            option_not_empty: not a_option.is_empty
        local
            c_string: C_STRING
        do
            clean_up
            create c_string.make (a_option)
            Result := c_mongoc_uri_get_option_as_int64 (item, c_string.item, a_fallback)
        end

    option_as_utf8 (a_option: READABLE_STRING_8; a_fallback: detachable READABLE_STRING_8): detachable READABLE_STRING_8
            -- Returns the value of the URI option if it is set and of the correct type (string).
            -- If not set, or set to an invalid type, returns `fallback`.
            -- Note: option name is case insensitive.
        note
            EIS: "name=mongoc_uri_get_option_as_utf8", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_option_as_utf8.html", "protocol=uri"
        require
            is_useful: exists
            option_not_empty: not a_option.is_empty
        local
            c_string_option: NATIVE_STRING
            c_string_fallback: C_STRING
            l_ptr: POINTER
            c_result: NATIVE_STRING
        do
            clean_up
            create c_string_option.make (a_option)
            if attached a_fallback then
                create c_string_fallback.make (a_fallback)
                l_ptr := c_mongoc_uri_get_option_as_utf8 (item, c_string_option.item, c_string_fallback.item)
            else
                l_ptr := c_mongoc_uri_get_option_as_utf8 (item, c_string_option.item, default_pointer)
            end

            if not l_ptr.is_default_pointer then
                create c_result.make_from_pointer (l_ptr)
                Result := {UTF_CONVERTER}.utf_32_string_to_utf_8_string_8 (c_result.string)
            end
        end

	 options: detachable BSON
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
            l_ptr := c_mongoc_uri_get_options (item)
            if not l_ptr.is_default_pointer then
                create Result.make_by_pointer (l_ptr)
            end
        end

	password: detachable READABLE_STRING_GENERAL
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
			l_ptr := c_mongoc_uri_get_password (item)
			if not l_ptr.is_default_pointer then
				create c_string.make_by_pointer (l_ptr)
				Result := c_string.string
			end
		end

	read_concern: detachable MONGODB_READ_CONCERN
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
			l_ptr := c_mongoc_uri_get_read_concern (item)
			if not l_ptr.is_default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	read_prefs: detachable MONGODB_READ_PREFERENCES
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
			l_ptr := c_mongoc_uri_get_read_prefs_t (item)
			if not l_ptr.is_default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	replica_set: detachable READABLE_STRING_GENERAL
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
			l_ptr := c_mongoc_uri_get_replica_set (item)
			if not l_ptr.is_default_pointer then
				create c_string.make_by_pointer (l_ptr)
				Result := c_string.string
			end
		end

	server_monitoring_mode: READABLE_STRING_GENERAL
			-- Fetches the serverMonitoringMode parameter of the URI if provided.
			-- Returns "auto" if the serverMonitoringMode parameter was not provided.
		note
			EIS: "name=mongoc_uri_get_server_monitoring_mode", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_server_monitoring_mode.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
			c_string: C_STRING
		do
			clean_up
			l_ptr := c_mongoc_uri_get_server_monitoring_mode (item)
			create c_string.make_by_pointer (l_ptr)
			Result := c_string.string
		end

	srv_hostname: detachable READABLE_STRING_GENERAL
			-- Returns the SRV host and domain name of a MongoDB URI.
			-- Returns Void if the scheme is "mongodb://".
		note
			EIS: "name=mongoc_uri_get_srv_hostname", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_srv_hostname.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
			c_string: C_STRING
		do
			clean_up
			l_ptr := c_mongoc_uri_get_srv_hostname (item)
			if not l_ptr.is_default_pointer then
				create c_string.make_by_pointer (l_ptr)
				Result := c_string.string
			end
		end

	srv_service_name: READABLE_STRING_GENERAL
			-- Returns the SRV service name of a MongoDB URI.
			-- Returns the value of the srvServiceName URI option if present.
			-- Otherwise, returns the default value "mongodb".
		note
			EIS: "name=mongoc_uri_get_srv_service_name", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_srv_service_name.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
			c_string: C_STRING
		do
			clean_up
			l_ptr := c_mongoc_uri_get_srv_service_name (item)
			create c_string.make_by_pointer (l_ptr)
			Result := c_string.string
		end

	username: detachable READABLE_STRING_GENERAL
			-- Fetches the username portion of the URI if provided.
			-- Returns Void if no username was specified.
		note
			EIS: "name=mongoc_uri_get_username", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_username.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
			c_string: C_STRING
		do
			clean_up
			l_ptr := c_mongoc_uri_get_username (item)
			if not l_ptr.is_default_pointer then
				create c_string.make_by_pointer (l_ptr)
				Result := c_string.string
			end
		end

	write_concern: detachable MONGODB_WRITE_CONCERN
			-- Fetches a write concern that is owned by the URI instance.
			-- This write concern is configured based on URI parameters.
			-- Returns Void if no write concern is provided.
		note
			EIS: "name=mongoc_uri_get_write_concern", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_write_concern.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
		do
			clean_up
			l_ptr := c_mongoc_uri_get_write_concern (item)
			if not l_ptr.is_default_pointer then
				create Result.make_by_pointer (l_ptr)
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
			l_ptr := c_mongoc_uri_copy (item)
			if not l_ptr.is_default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	unescape (a_escaped_string: READABLE_STRING_8): detachable STRING_8
			-- Unescapes an URI encoded string. For example, "%40" would become "@".
			-- Returns Void if escaped_string contains an invalid UTF-8 character
			-- or an invalid escape sequence.
		note
			EIS: "name=mongoc_uri_unescape", "src=http://mongoc.org/libmongoc/current/mongoc_uri_unescape.html", "protocol=uri"
		require
			is_useful: exists
			escaped_string_not_empty: not a_escaped_string.is_empty
		local

			c_string: C_STRING
			l_ptr: POINTER
			l_result: C_STRING
		do
			clean_up
			create c_string.make (a_escaped_string)
			l_ptr := c_mongoc_uri_unescape (c_string.item)
			if not l_ptr.is_default_pointer then
				create l_result.make_by_pointer (l_ptr)
				Result := l_result.string
			end
		end

feature -- Status Report

	is_tls: BOOLEAN
			-- Indicates if TLS was specified for use in the URI.
			-- Returns True if any TLS option is specified.
		note
			EIS: "name=mongoc_uri_get_tls", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_tls.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			Result := c_mongoc_uri_get_tls (item)
		end

	has_option (a_option: READABLE_STRING_8): BOOLEAN
			-- Returns True if the option `a_option' was present in the initial MongoDB URI.
			-- Note: option name is case insensitive.
		note
			EIS: "name=mongoc_uri_has_option", "src=http://mongoc.org/libmongoc/current/mongoc_uri_has_option.html", "protocol=uri"
		require
			is_useful: exists
			option_not_empty: not a_option.is_empty
		local
			c_string: C_STRING
		do
			clean_up
			create c_string.make (a_option)
			Result := c_mongoc_uri_has_option (item, c_string.item)
		end

	is_boolean_option (a_option: READABLE_STRING_8): BOOLEAN
			-- Returns True if the option `a_option` is a known MongoDB URI option of boolean type.
			-- For example, "tls=false" is a valid MongoDB URI option, so `is_valid_option ("tls")` is True.
			-- Note: option name is case insensitive.
		note
			EIS: "name=mongoc_uri_option_is_bool", "src=http://mongoc.org/libmongoc/current/mongoc_uri_option_is_bool.html", "protocol=uri"
		require
			is_useful: exists
			option_not_empty: not a_option.is_empty
		local
			c_string: C_STRING
		do
			clean_up
			create c_string.make (a_option)
			Result := c_mongoc_uri_option_is_bool (c_string.item)
		end

	is_int32_option (a_option: READABLE_STRING_8): BOOLEAN
			-- Returns True if the option `a_option' is a known MongoDB URI option of integer type.
			-- For example, "zlibCompressionLevel=5" is a valid integer MongoDB URI option,
			-- so `is_int32_option ("zlibCompressionLevel")` is True.
			-- This will also return True for all 64-bit integer options.
			-- Note: option name is case insensitive.
		note
			EIS: "name=mongoc_uri_option_is_int32", "src=http://mongoc.org/libmongoc/current/mongoc_uri_option_is_int32.html", "protocol=uri"
		require
			option_not_empty: not a_option.is_empty
		local
			c_string: C_STRING
		do
			create c_string.make (a_option)
			Result := c_mongoc_uri_option_is_int32 (c_string.item)
		end

	is_int64_option (a_option: READABLE_STRING_8): BOOLEAN
			-- Returns True if the option `a_option' is a known MongoDB URI option of 64-bit integer type.
			-- For example, "wTimeoutMS=100" is a valid 64-bit integer MongoDB URI option,
			-- so `is_int64_option ("wTimeoutMS")` is True.
			-- Note: option name is case insensitive.
		note
			EIS: "name=mongoc_uri_option_is_int64", "src=http://mongoc.org/libmongoc/current/mongoc_uri_option_is_int64.html", "protocol=uri"
		require
			option_not_empty: not a_option.is_empty
		local
			c_string: C_STRING
		do
			create c_string.make (a_option)
			Result := c_mongoc_uri_option_is_int64 (c_string.item)
		end

	is_utf8_option (a_option: READABLE_STRING_8): BOOLEAN
			-- Returns True if the option `a_option' is a known MongoDB URI option of string type.
			-- For example, "replicaSet=my_rs" is a valid MongoDB URI option,
			-- so `is_utf8_option ("replicaSet")` is True.
			-- Note: option name is case insensitive.
		note
			EIS: "name=mongoc_uri_option_is_utf8", "src=http://mongoc.org/libmongoc/current/mongoc_uri_option_is_utf8.html", "protocol=uri"
		require
			option_not_empty: not a_option.is_empty
		local
			c_string: C_STRING
		do
			create c_string.make (a_option)
			Result := c_mongoc_uri_option_is_utf8 (c_string.item)
		end

feature -- Element Change

	set_auth_mechanism (a_value: READABLE_STRING_8)
			-- Sets the "authMechanism" URI option, such as "SCRAM-SHA-1" or "GSSAPI",
			-- after the URI has been parsed from a string.
			-- Updates the option in-place if already set, otherwise appends it to the URI's options.
			-- Set an error if the option cannot be set, for example if value is not valid UTF-8.
		note
			EIS: "name=mongoc_uri_set_auth_mechanism", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_auth_mechanism.html", "protocol=uri"
		require
			is_useful: exists
			value_not_empty: not a_value.is_empty
		local
			c_string: C_STRING
			l_res: BOOLEAN
		do
			clean_up
			create c_string.make (a_value)
			l_res := c_mongoc_uri_set_auth_mechanism (item, c_string.item)
			if not l_res then
				set_last_error ("Error setting auth mechanism with value: [" + a_value + "]")
			end
		end

	set_auth_source (a_value: READABLE_STRING_8)
			-- Sets the "authSource" URI option after the URI has been parsed from a string.
			-- Updates the option in-place if already set, otherwise appends it to the URI's options.
			-- Set an error if the option cannot be set, for example if value is not valid UTF-8.
		note
			EIS: "name=mongoc_uri_set_auth_source", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_auth_source.html", "protocol=uri"
		require
			is_useful: exists
			value_not_empty: not a_value.is_empty
		local
			c_string: C_STRING
			l_res: BOOLEAN
		do
			clean_up
			create c_string.make (a_value)
			l_res := c_mongoc_uri_set_auth_source (item, c_string.item)
			if not l_res then
				set_last_error ("Error setting auth source with value: [" + a_value + "]")
			end
		end

	set_compressors (a_compressors: detachable READABLE_STRING_8)
			-- Sets the URI's compressors, after the URI has been parsed from a string.
			-- Will overwrite any previously set value.
			-- `compressors`: A string consisting of one or more comma (,) separated compressors
			-- (e.g. "snappy,zlib") or Void. Passing Void clears any existing compressors set on URI.
		note
			EIS: "name=mongoc_uri_set_compressors", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_compressors.html", "protocol=uri"
		require
			is_useful: exists
		local
			c_string: C_STRING
			l_res: BOOLEAN
		do
			clean_up
			if attached a_compressors then
				create c_string.make (a_compressors)
				l_res := c_mongoc_uri_set_compressors (item, c_string.item)
			else
				l_res := c_mongoc_uri_set_compressors (item, default_pointer)
			end
			if not l_res then
				set_last_error ("Error setting compressors with value: [" + if attached a_compressors then a_compressors else "Void" end + "]")
			end
		end

	set_database (a_database: READABLE_STRING_8)
			-- Sets the URI's database, after the URI has been parsed from a string.
			-- The driver authenticates to this database if the connection string includes
			-- authentication credentials. This database is also the return value of
			-- mongoc_client_get_default_database().
			-- Set an error if the option cannot be set, for example if database is not valid UTF-8.
		note
			EIS: "name=mongoc_uri_set_database", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_database.html", "protocol=uri"
		require
			is_useful: exists
			database_not_empty: not a_database.is_empty
		local
			c_string: C_STRING
			l_res: BOOLEAN
		do
			clean_up
			create c_string.make (a_database)
			l_res := c_mongoc_uri_set_database (item, c_string.item)
			if not l_res then
				set_last_error ("Error setting database with value: [" + a_database + "]")
			end
		end

	set_mechanism_properties (a_properties: BSON)
			-- Replaces all the options in URI's "authMechanismProperties" after
			-- the URI has been parsed from a string.
			-- Set an error if the option cannot be set, for example if properties
			-- is not valid BSON data.
		note
			EIS: "name=mongoc_uri_set_mechanism_properties", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_mechanism_properties.html", "protocol=uri"
		require
			is_useful: exists
			properties_exists: a_properties.exists
		local
			l_res: BOOLEAN
		do
			clean_up
			l_res := c_mongoc_uri_set_mechanism_properties (item, a_properties.item)
			if not l_res then
				set_last_error ("Error setting mechanism properties with value: [" + a_properties.bson_as_canonical_extended_json + "]")
			end
		end

	set_boolean_option (a_option: READABLE_STRING_8; a_value: BOOLEAN)
			-- Sets an individual URI option of boolean type, after the URI has been parsed from a string.
			-- Only known options of type bool can be set.
			-- Updates the option in-place if already set, otherwise appends it to the URI's options.
			-- Write an error If not successfully set (the named option is a known option of type bool).
			-- Note: option name is case insensitive.
		note
			EIS: "name=mongoc_uri_set_option_as_bool", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_option_as_bool.html", "protocol=uri"
		require
			is_useful: exists
			option_not_empty: not a_option.is_empty
			is_boolean_type: is_boolean_option (a_option)
		local
			c_string: C_STRING
			l_res: BOOLEAN
		do
			clean_up
			create c_string.make (a_option)
			l_res := c_mongoc_uri_set_option_as_bool (item, c_string.item, a_value)
			if not l_res then
				set_last_error ("Error setting boolean option [" + a_option + "] with value: [" + a_value.out + "]")
			end
		end

	set_option_int32 (a_option: READABLE_STRING_8; a_value: INTEGER): BOOLEAN
			-- Sets an individual URI option of integer type, after the URI has been parsed from a string.
			-- Only known options of type integer can be set. Some integer options, such as
			-- minHeartbeatFrequencyMS, have additional constraints.
			-- Updates the option in-place if already set, otherwise appends it to the URI's options.
			-- Write an error if not successfully set (the named option is a known option of type int32 or int64).
			-- Note: option name is case insensitive.
		note
			EIS: "name=mongoc_uri_set_option_as_int32", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_option_as_int32.html", "protocol=uri"
		require
			is_useful: exists
			option_not_empty: not a_option.is_empty
			is_integer_type: is_int32_option (a_option)
		local
			c_string: C_STRING
			l_res: BOOLEAN
		do
			clean_up
			create c_string.make (a_option)
			l_res := c_mongoc_uri_set_option_as_int32 (item, c_string.item, a_value)
			if not l_res then
				set_last_error ("Error setting int32 option [" + a_option + "] with value: [" + a_value.out + "]")
			end
		end

	set_option_int64 (a_option: READABLE_STRING_8; a_value: INTEGER_64)
			-- Sets an individual URI option of 64-bit integer type, after the URI has been parsed from a string.
			-- Only known options of type int32 or int64 can be set. For 32-bit integer options,
			-- the function returns false when trying to set a 64-bit value that exceeds
			-- the range of an int32_t. Values that fit into an int32_t will be set correctly.
			-- In both cases, a warning will be emitted.
			-- Updates the option in-place if already set, otherwise appends it to the URI's options.
			-- Write an error if not successfully set (the named option is a known option of type int64).
			-- Note: option name is case insensitive.
		note
			EIS: "name=mongoc_uri_set_option_as_int64", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_option_as_int64.html", "protocol=uri"
		require
			is_useful: exists
			option_not_empty: not a_option.is_empty
			is_integer_type: is_int64_option (a_option)
		local
			c_string: C_STRING
			l_res: BOOLEAN
		do
			clean_up
			create c_string.make (a_option)
			l_res := c_mongoc_uri_set_option_as_int64 (item, c_string.item, a_value)
			if not l_res then
				set_last_error ("Error setting int64 option [" + a_option + "] with value: [" + a_value.out + "]")
			end
		end

	set_option_utf8 (a_option: READABLE_STRING_8; a_value: READABLE_STRING_8)
			-- Sets an individual URI option of string type, after the URI has been parsed from a string.
			-- Only known string-type options can be set.
			-- Updates the option in-place if already set, otherwise appends it to the URI's options.
			-- Write an error if not successfully set (the named option is a known option of string type).
			-- Note: option name is case insensitive.
		note
			EIS: "name=mongoc_uri_set_option_as_utf8", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_option_as_utf8.html", "protocol=uri"
		require
			is_useful: exists
			option_not_empty: not a_option.is_empty
			is_string_type: is_utf8_option (a_option)
		local
			c_string_option: C_STRING
			c_string_value: C_STRING
			l_res: BOOLEAN
		do
			clean_up
			create c_string_option.make (a_option)
			create c_string_value.make (a_value)
			l_res := c_mongoc_uri_set_option_as_utf8 (item, c_string_option.item, c_string_value.item)
			if not l_res then
				set_last_error ("Error setting utf8 option [" + a_option + "] with value: [" + a_value + "]")
			end
		end

	set_password (a_password: READABLE_STRING_8)
			-- Sets the URI's password, after the URI has been parsed from a string.
			-- The driver authenticates with this password if the username is also set.
			-- Write an error if the option cannot be set, for example if password is not valid UTF-8.
		note
			EIS: "name=mongoc_uri_set_password", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_password.html", "protocol=uri"
		require
			is_useful: exists
			password_not_empty: not a_password.is_empty
		local
			c_string: C_STRING
			l_res: BOOLEAN
		do
			clean_up
			create c_string.make (a_password)
			l_res := c_mongoc_uri_set_password (item, c_string.item)
			if not l_res then
				set_last_error ("Error setting password with value: [" + a_password + "]")
			end
		end

	set_read_concern (a_read_concern: MONGODB_READ_CONCERN)
			-- Sets a MongoDB URI's read concern option, after the URI has been parsed from a string.
		note
			EIS: "name=mongoc_uri_set_read_concern", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_read_concern.html", "protocol=uri"
		require
			is_useful: exists
			read_concern_exists: a_read_concern.exists
		do
			clean_up
			c_mongoc_uri_set_read_concern (item, a_read_concern.item)
		end

	set_read_preferences (a_prefs: MONGODB_READ_PREFERENCES)
			-- Sets a MongoDB URI's read preferences, after the URI has been parsed from a string.
		note
			EIS: "name=mongoc_uri_set_read_prefs_t", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_read_prefs_t.html", "protocol=uri"
		require
			is_useful: exists
			prefs_exists: a_prefs.exists
		do
			clean_up
			c_mongoc_uri_set_read_prefs_t (item, a_prefs.item)
		end

	set_server_monitoring_mode (a_value: READABLE_STRING_8): BOOLEAN
			-- Sets the serverMonitoringMode URI option to value after the URI has been parsed from a string.
			-- Updates the option in-place if already set, otherwise appends it to the URI's options.
			-- Requeries the `a_value` is in "auto", "poll", or "stream".
		note
			EIS: "name=mongoc_uri_set_server_monitoring_mode", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_server_monitoring_mode.html", "protocol=uri"
		require
			is_useful: exists
			value_not_empty: not a_value.is_empty
			valid_value: a_value.same_string ("auto") or a_value.same_string ("poll") or a_value.same_string ("stream")
		local
			c_string: C_STRING
			l_res: BOOLEAN
		do
			clean_up
			create c_string.make (a_value)
			l_res := c_mongoc_uri_set_server_monitoring_mode (item, c_string.item)
			if not l_res then
				set_last_error ("Error setting server monitoring mode with value: [" + a_value + "]")
			end
		end

	set_username (a_username: READABLE_STRING_8)
			-- Sets the URI's username, after the URI has been parsed from a string.
			-- The driver authenticates with this username if the password is also set.
			-- Write an error if the option cannot be set, for example if username is not valid UTF-8.
		note
			EIS: "name=mongoc_uri_set_username", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_username.html", "protocol=uri"
		require
			is_useful: exists
			username_not_empty: not a_username.is_empty
		local
			c_string: C_STRING
			l_res: BOOLEAN
		do
			clean_up
			create c_string.make (a_username)
			l_res := c_mongoc_uri_set_username (item, c_string.item)
			if not l_res then
				set_last_error ("Error setting username with value: [" + a_username + "]")
			end
		end

	set_write_concern (a_write_concern: MONGODB_WRITE_CONCERN)
			-- Sets a MongoDB URI's write concern option, after the URI has been parsed from a string.
		note
			EIS: "name=mongoc_uri_set_write_concern", "src=http://mongoc.org/libmongoc/current/mongoc_uri_set_write_concern.html", "protocol=uri"
		require
			is_useful: exists
			write_concern_exists: a_write_concern.exists
		do
			clean_up
			c_mongoc_uri_set_write_concern (item, a_write_concern.item)
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


feature {MONGODB_EXTERNALS_ACCESS} -- C externals

	c_mongoc_uri_new (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_uri_new ((const char *)$a_uri);
			]"
		end

	c_mongoc_uri_copy (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_uri_copy ((const mongoc_uri_t *)$a_uri);
			]"
		end

	c_mongoc_uri_get_string (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_uri_get_string ((const mongoc_uri_t *)$a_uri);
			]"
		end

	c_mongoc_uri_new_with_error	(a_uri: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_uri_new_with_error ((const char *)$a_uri,(bson_error_t *)$a_error);
			]"
		end

    c_mongoc_uri_get_auth_mechanism (a_uri: POINTER): POINTER
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return (EIF_POINTER) mongoc_uri_get_auth_mechanism ((const mongoc_uri_t *)$a_uri);"
        end

    c_mongoc_uri_get_auth_source (a_uri: POINTER): POINTER
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return (EIF_POINTER) mongoc_uri_get_auth_source ((const mongoc_uri_t *)$a_uri);"
        end

     c_mongoc_uri_get_compressors (a_uri: POINTER): POINTER
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return (EIF_POINTER) mongoc_uri_get_compressors ((const mongoc_uri_t *)$a_uri);"
        end

    c_mongoc_uri_get_database (a_uri: POINTER): POINTER
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return (EIF_POINTER) mongoc_uri_get_database ((const mongoc_uri_t *)$a_uri);"
        end

    c_mongoc_uri_get_hosts (a_uri: POINTER): POINTER
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return (EIF_POINTER) mongoc_uri_get_hosts ((const mongoc_uri_t *)$a_uri);"
        end

	c_mongoc_uri_get_mechanism_properties (uri: POINTER; properties: POINTER): BOOLEAN
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_uri_get_mechanism_properties ((const mongoc_uri_t *)$uri, (bson_t *)$properties);"
        end

    c_mongoc_uri_get_option_as_bool (uri: POINTER; option: POINTER; fallback: BOOLEAN): BOOLEAN
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_uri_get_option_as_bool ((const mongoc_uri_t *)$uri, (const char *)$option, (bool)$fallback);"
        end

	c_mongoc_uri_get_option_as_int32 (uri: POINTER; option: POINTER; fallback: INTEGER): INTEGER
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_uri_get_option_as_int32 ((const mongoc_uri_t *)$uri, (const char *)$option, (int32_t)$fallback);"
        end

   c_mongoc_uri_get_option_as_int64 (uri: POINTER; option: POINTER; fallback: INTEGER_64): INTEGER_64
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_uri_get_option_as_int64 ((const mongoc_uri_t *)$uri, (const char *)$option, (int64_t)$fallback);"
        end

    c_mongoc_uri_get_option_as_utf8 (uri: POINTER; option: POINTER; fallback: POINTER): POINTER
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return (EIF_POINTER) mongoc_uri_get_option_as_utf8 ((const mongoc_uri_t *)$uri, (const char *)$option, (const char *)$fallback);"
        end

  c_mongoc_uri_get_options (uri: POINTER): POINTER
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return (EIF_POINTER) mongoc_uri_get_options ((const mongoc_uri_t *)$uri);"
        end

	c_mongoc_uri_get_password (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_uri_get_password ((const mongoc_uri_t *)$a_uri);"
		end

	c_mongoc_uri_get_read_concern (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_POINTER) mongoc_uri_get_read_concern ((const mongoc_uri_t *)$a_uri);"
		end

	c_mongoc_uri_get_read_prefs_t (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_POINTER) mongoc_uri_get_read_prefs_t ((const mongoc_uri_t *)$a_uri);"
		end

	c_mongoc_uri_get_replica_set (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_POINTER) mongoc_uri_get_replica_set ((const mongoc_uri_t *)$a_uri);"
		end

	c_mongoc_uri_get_server_monitoring_mode (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_POINTER) mongoc_uri_get_server_monitoring_mode ((const mongoc_uri_t *)$a_uri);"
		end

	c_mongoc_uri_get_srv_hostname (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_POINTER) mongoc_uri_get_srv_hostname ((const mongoc_uri_t *)$a_uri);"
		end

	c_mongoc_uri_get_srv_service_name (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_POINTER) mongoc_uri_get_srv_service_name ((const mongoc_uri_t *)$a_uri);"
		end

	c_mongoc_uri_get_tls (a_uri: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_get_tls ((const mongoc_uri_t *)$a_uri);"
		end

	c_mongoc_uri_get_username (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_POINTER) mongoc_uri_get_username ((const mongoc_uri_t *)$a_uri);"
		end

	c_mongoc_uri_get_write_concern (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_POINTER) mongoc_uri_get_write_concern ((const mongoc_uri_t *)$a_uri);"
		end

	c_mongoc_uri_has_option (a_uri: POINTER; option: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_has_option ((const mongoc_uri_t *)$a_uri, (const char *)$option);"
		end

	c_mongoc_uri_new_for_host_port (hostname: POINTER; port: NATURAL_16): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_POINTER) mongoc_uri_new_for_host_port ((const char *)$hostname, (uint16_t)$port);"
		end

	c_mongoc_uri_option_is_bool (option: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_option_is_bool ((const char *)$option);"
		end

	c_mongoc_uri_option_is_int32 (option: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_option_is_int32 ((const char *)$option);"
		end

	c_mongoc_uri_option_is_int64 (option: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_option_is_int64 ((const char *)$option);"
		end

	c_mongoc_uri_option_is_utf8 (option: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_option_is_utf8 ((const char *)$option);"
		end

	c_mongoc_uri_set_auth_mechanism (uri: POINTER; value: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_set_auth_mechanism ((mongoc_uri_t *)$uri, (const char *)$value);"
		end

	c_mongoc_uri_set_auth_source (uri: POINTER; value: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_set_auth_source ((mongoc_uri_t *)$uri, (const char *)$value);"
		end

	c_mongoc_uri_set_compressors (uri: POINTER; a_compressors: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_set_compressors ((mongoc_uri_t *)$uri, (const char *)$a_compressors);"
		end

	c_mongoc_uri_set_database (uri: POINTER; a_database: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_set_database ((mongoc_uri_t *)$uri, (const char *)$a_database);"
		end

	c_mongoc_uri_set_mechanism_properties (uri: POINTER; properties: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_set_mechanism_properties ((mongoc_uri_t *)$uri, (const bson_t *)$properties);"
		end

	c_mongoc_uri_set_option_as_bool (uri: POINTER; option: POINTER; value: BOOLEAN): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_set_option_as_bool ((const mongoc_uri_t *)$uri, (const char *)$option, (bool)$value);"
		end

	c_mongoc_uri_set_option_as_int32 (uri: POINTER; option: POINTER; value: INTEGER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_set_option_as_int32 ((const mongoc_uri_t *)$uri, (const char *)$option, (int32_t)$value);"
		end

	c_mongoc_uri_set_option_as_int64 (uri: POINTER; option: POINTER; value: INTEGER_64): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_set_option_as_int64 ((const mongoc_uri_t *)$uri, (const char *)$option, (int64_t)$value);"
		end

	c_mongoc_uri_set_option_as_utf8 (uri: POINTER; option: POINTER; value: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_set_option_as_utf8 ((const mongoc_uri_t *)$uri, (const char *)$option, (const char *)$value);"
		end

	c_mongoc_uri_set_password (uri: POINTER; a_password: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_set_password ((mongoc_uri_t *)$uri, (const char *)$a_password);"
		end

	c_mongoc_uri_set_read_concern (uri: POINTER; rc: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_uri_set_read_concern ((mongoc_uri_t *)$uri, (const mongoc_read_concern_t *)$rc);"
		end

	c_mongoc_uri_set_read_prefs_t (uri: POINTER; prefs: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_uri_set_read_prefs_t ((mongoc_uri_t *)$uri, (const mongoc_read_prefs_t *)$prefs);"
		end

	c_mongoc_uri_set_server_monitoring_mode (uri: POINTER; value: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_set_server_monitoring_mode ((mongoc_uri_t *)$uri, (const char *)$value);"
		end

	c_mongoc_uri_set_username (uri: POINTER; a_username: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_uri_set_username ((mongoc_uri_t *)$uri, (const char *)$a_username);"
		end

	c_mongoc_uri_set_write_concern (uri: POINTER; wc: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_uri_set_write_concern ((mongoc_uri_t *)$uri, (const mongoc_write_concern_t *)$wc);"
		end

	c_mongoc_uri_unescape (escaped_string: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_POINTER) mongoc_uri_unescape ((const char *)$escaped_string);"
		end


end
