note
	description: "[
			A versioned API to use for MongoDB connections.
			Used to specify which version of the MongoDB server's API to use for driver connections.
			
			The server API type takes a mongoc_server_api_version_t. It can optionally be strict about 
			the list of allowed commands in that API version, and can also optionally provide errors 
			for deprecated commands in that API version.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Server API", "src=http://mongoc.org/libmongoc/current/mongoc_server_api_t.html", "protocol=uri"

class
	MONGODB_SERVER_API

inherit
	MONGODB_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make,
	make_by_pointer

feature {NONE} -- Initialization

	make (a_version: INTEGER)
			-- Create a new server API instance with the specified version.
		local
			l_ptr: POINTER
		do
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_server_api_new (a_version)
			make_by_pointer (l_ptr)
		ensure
			item_set: item /= default_pointer
		end

feature -- Access

	version: INTEGER
			-- Get the version set on this server API.
		note
			eis: "name=mongoc_server_api_get_version ", "src=https://mongoc.org/libmongoc/current/mongoc_server_api_get_version.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			Result := {MONGODB_EXTERNALS}.c_mongoc_server_api_get_version (item)
		end

	strict: BOOLEAN
			-- Get whether strict mode is enabled.
		note
			eis: "name=mongoc_server_api_get_strict", "src=https://mongoc.org/libmongoc/current/mongoc_server_api_get_strict.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			Result := {MONGODB_EXTERNALS}.c_mongoc_server_api_get_strict (item)
		end

	deprecation_errors: BOOLEAN
			-- Get whether deprecation errors are enabled.
		note
			eis: "name=mongoc_server_api_get_deprecation_errors", "src=https://mongoc.org/libmongoc/current/mongoc_server_api_get_deprecation_errors.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			Result := {MONGODB_EXTERNALS}.c_mongoc_server_api_get_deprecation_errors (item)
		end

feature -- Status Setting

	set_strict (a_strict: BOOLEAN)
			-- Set whether strict mode is enabled.
			-- When enabled, the server will reject all commands that are not part of the specified API version.
		note
			eis: "name=mongoc_server_api_strict", "src=https://mongoc.org/libmongoc/current/mongoc_server_api_strict.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_server_api_strict (item, a_strict)
		end

	set_deprecation_errors (a_deprecation_errors: BOOLEAN)
			-- Set whether deprecation errors are enabled.
			-- When enabled, the server will reject commands that are deprecated in the specified API version.
		note
			eis: "name=mongoc_server_api_deprecation_errors", "src=https://mongoc.org/libmongoc/current/mongoc_server_api_deprecation_errors.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_server_api_deprecation_errors (item, a_deprecation_errors)
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if not shared then
				if exists then
					c_destroy_pointer (item)
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

	c_destroy_pointer (a_ptr: POINTER)
			-- Destroy the underlying C pointer when the object is collected.
		do
			if a_ptr /= default_pointer then
				{MONGODB_EXTERNALS}.c_mongoc_server_api_destroy (a_ptr)
			end
		end

	struct_size: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return sizeof(mongoc_server_api_version_t *);"
		end

end
