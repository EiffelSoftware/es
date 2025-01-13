note
	description: "Object representing a connection pool for multi-threaded programs"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_client_pool", "src=https://mongoc.org/libmongoc/current/mongoc_client_pool_t.html", "protocol=uri"
class
	MONGODB_CLIENT_POOL

inherit

	MONGODB_WRAPPER_BASE

create
	 make_by_pointer, make_from_uri

feature {NONE} -- Initialization


	make_from_uri (a_uri: MONGODB_URI)
			-- Create a new pool using the uri `a_uri'.
		local
			l_ptr: POINTER
			l_error: BSON_ERROR
		do
			create l_error.make
				-- https://mongoc.org/libmongoc/current/mongoc_client_pool_new_with_error.html
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_pool_new_with_error (a_uri.item, l_error.item)
			if l_ptr /= default_pointer then
				make_by_pointer (l_ptr)
			else
				error := l_error
			end
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_mongoc_client_pool_destroy (item)
			end
		end

feature -- Access

	has_pop: BOOLEAN
			-- was pop or try_pop called?	


	pop: MONGODB_CLIENT
			-- Retrieve a MONGODB_CLIENT from the client pool or create one, possibly blocking until one is available.
		note
			EIS: "name=mongoc_client_pool_pop", "src=http://mongoc.org/libmongoc/current/mongoc_client_pool_pop.html", "protocol=uri"
		do
			has_pop := True
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_pool_pop (item))
		end

	try_pop: detachable MONGODB_CLIENT
			-- Retrieve a MONGODB_CLIENT from the client pool similar to pop, ecxcept it will return VOID instead of blocking for a client to become available.
		note
			EIS: "name=mongoc_client_pool_try_pop", "src=http://mongoc.org/libmongoc/current/mongoc_client_pool_try_pop.html", "protocol=uri"
		local
			l_ptr: POINTER
		do
			has_pop := True
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_pool_try_pop (item)
			if l_ptr /= default_pointer  then
				has_pop := True
				create Result.make_by_pointer (l_ptr)
			end
		end

	push (a_client: MONGODB_CLIENT)
			-- Return a MONGODB_CLIENT `a_client' to the client pool.
		note
			EIS: "name=mongoc_client_pool_push", "src=https://mongoc.org/libmongoc/current/mongoc_client_pool_push.html", "protocol=uri"
		do
			has_pop := False
			{MONGODB_EXTERNALS}.c_mongoc_client_pool_push (item, a_client.item)
		end

feature -- Settings

	set_appname (a_name: READABLE_STRING_GENERAL)
			-- Set the application name `a_name' for this client.
			-- WARNING: MONGODB_CLIENT.set_appname can't be called on a client retrieved from a client pool.
			-- This function can only be called once on a pool, and must be called before the first call to `pop' or `try_pop'.
		note
			EIS: "name=mongoc_client_pool_set_appname","src=http://mongoc.org/libmongoc/current/mongoc_client_pool_set_appname.html", "protocol=uri"
		require
			is_valid_length: a_name.count <= {MONGODB_EXTERNALS}.MONGOC_HANDSHAKE_APPNAME_MAX
			not_pop: not has_pop
		local
			c_name: C_STRING
			l_res: BOOLEAN
			l_error: BSON_ERROR
		do
			create c_name.make (a_name)
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_pool_set_appname (item, c_name.item)
			if not l_res then
				create l_error.make
				l_error.set_error (
					{MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT,
					{MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT_HANDSHAKE_FAILED,
					"Failed to set application name. This operation must be called before any client operations begin and can only be called once."
				)
				error := l_error
			end
		end


	set_error_api (a_version: INTEGER)
			-- Configure how the C Driver reports errors
			-- a_version: version of the error API, either MONGOC_ERROR_API_VERSION_LEGACY or MONGOC_ERROR_API_VERSION_2.
			-- This function can only be called once on a pool, and must be called before the first call to `pop' or `try_pop'.
		note
			EIS: "name=mongoc_client_pool_set_error_api", "src=http://mongoc.org/libmongoc/current/mongoc_client_pool_set_error_api.html", "protocol=uri"
		require
			valid_version: a_version = {MONGODB_EXTERNALS}.mongoc_error_api_version_2 or else a_version = {MONGODB_EXTERNALS}.mongoc_error_api_version_legacy
			not_pop: not has_pop
		local
			l_res: BOOLEAN
			l_error: BSON_ERROR
		do
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_pool_set_error_api (item, a_version)
			if not l_res then
				create l_error.make
				l_error.set_error (
					{MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT,        -- Domain: Client-side errors
					{MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT_SESSION_FAILURE,  -- Code: Session/configuration failure
					"Failed to set error API version. This operation must be called before any client operations begin and can only be called once."
				)
				error := l_error
			end
		end


	set_max_size (a_max_pool_size: NATURAL_32)
			-- Sets the maximum number of pooled connections available from the pool.
			-- This function is safe to call from multiple threads.
		note
			eis: "name=mongoc_client_pool_max_size", "src=https://mongoc.org/libmongoc/current/mongoc_client_pool_max_size.html", "protocol=uri"
		do
			{MONGODB_EXTERNALS}.c_mongoc_client_pool_max_size (item, a_max_pool_size)
		end

	set_server_api (a_api: MONGODB_SERVER_API)
			-- Set the API version to use for clients created through this pool.
			-- Once the API version is set on a pool, it may not be changed to a new value.
			-- This function can only be called once on a pool, and must be called before the first call to `pop` or `try_pop'.
		require
			valid_api: a_api /= Void
			not_pop: not has_pop
		local
			l_res: BOOLEAN
			l_error: BSON_ERROR
		do
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_pool_set_server_api (item, a_api.item, l_error.item)
			if not l_res then
				l_error.set_error (
					{MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT,
					{MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT_SESSION_FAILURE,
					"Failed to set server API version. This operation must be called before any client operations begin and can only be called once."
				)
				error := l_error
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
			"C inline use <mongoc/mongoc.h>"
		alias
			"return sizeof(mongoc_client_pool_t *);"
		end

	c_mongoc_client_pool_destroy (a_pool: POINTER)
		note
			eis: "name=mongoc_client_pool_destroy ", "src=https://mongoc.org/libmongoc/current/mongoc_client_pool_destroy.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_client_pool_destroy ((mongoc_client_pool_t *)$a_pool);"
		end

end
