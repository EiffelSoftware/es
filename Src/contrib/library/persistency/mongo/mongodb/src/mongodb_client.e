note
	description: "[
		Object Representing MongoDB mongoc_client_t 
		It is an opaque type that provides access to a MongoDB server, replica set, or sharded cluster. 
		It maintains management of underlying sockets and routing to individual nodes based on mongoc_read_prefs_t or mongoc_write_concern_t.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name= Mongoc Client", "src=http://mongoc.org/libmongoc/current/mongoc_client_t.html", "protocol=uri"

class
	MONGODB_CLIENT

inherit
	MONGODB_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make, make_by_pointer, make_from_uri

feature {NONE}-- Initialization

	make (a_uri: READABLE_STRING_8)
			-- Creates a new MongoClient using the URI string `a_uri' provided.
			--| a_uri must be an UTF-8 encoded string.
		do
			new_mongoc_client (a_uri)
		end

	make_from_uri (a_uri: MONGODB_URI)
			-- Create a new client using `a_uri` provided
		note
			eis: "name=mongoc_client_new_from_uri ", "src=https://mongoc.org/libmongoc/current/mongoc_client_new_from_uri.html", "protocol=uri"
		do
			new_from_uri_with_error (a_uri)
		end

feature -- Status report

	is_destroyed: BOOLEAN
			-- Is Current destroyed?

	is_usable: BOOLEAN
		do
			Result := exists and then not is_destroyed
		end

feature {NONE} -- Implementation

	new_mongoc_client (a_uri: READABLE_STRING_8)
			-- new mongodb client instance using the uri `a_uri'.
		note
			eis: "name=mongoc_client_new", "src=https://mongoc.org/libmongoc/current/mongoc_client_new.html", "protocol=uri"
		local
			l_uri: MONGODB_URI
		do
			create l_uri.make (a_uri)
			new_from_uri_with_error (l_uri)
		end

	new_from_uri_with_error (a_uri: MONGODB_URI)
			-- Creates a new client instance using the provided URI.
			-- Sets the error attribute if creation fails.
		local
			l_error: BSON_ERROR
			l_ptr: POINTER
		do
			create l_error.make
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_new_from_uri_with_error (a_uri.item, l_error.item)

			if l_ptr.is_default_pointer then
				set_last_error_with_bson (l_error)
			else
				make_by_pointer (l_ptr)
			end
		end

feature {NONE} -- Init

	mongoc_init
			-- Required to initialize libmongoc's internals.
		do
			{MONGODB_EXTERNALS}.c_mongoc_init
		end

feature -- Basic operation

	destroy
			-- Manually destroy current object (and underlying C memory)
		do
			dispose
		ensure
			is_destroyed
		rescue
			io.error.put_string (generator + ".destroy: rescued!%N")
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if not is_destroyed then
				if not shared then
					if exists then
						c_mongoc_client_destroy (item)
					else
						check exists: False end
					end
				end
				is_destroyed := True
			end
		end

feature -- Access

	uri: MONGODB_URI
			-- Fetches the mongoc_uri_t used to create the client.
		note
			EIS: "name=mongoc_client_get_uri", "src=https://mongoc.org/libmongoc/current/mongoc_client_get_uri.html", "protocol=uri"
		require
			is_usable: is_usable
		do
			clean_up
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_get_uri (item))
		end

	collection (a_db: READABLE_STRING_GENERAL; a_collection: READABLE_STRING_GENERAL): MONGODB_COLLECTION
			-- a_db: The name of the database containing the collection.
			-- a_collection: The name of the collection.
			-- Note:
			--		Collections are automatically created on the MongoDB server upon insertion of the first document.
			--		There is no need to create a collection manually.
		note
			EIS: "name=mongoc_client_get_collection", "src=https://mongoc.org/libmongoc/current/mongoc_client_get_collection.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			c_db: C_STRING
			c_collection: C_STRING
			l_ptr:  POINTER
		do
			clean_up
			create c_db.make (a_db)
			create c_collection.make (a_collection)
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_collection (item, c_db.item, c_collection.item)
			check success: not l_ptr.is_default_pointer end
			create Result.make_by_pointer (l_ptr)
		end

	database (a_dbname: READABLE_STRING_GENERAL): MONGODB_DATABASE
				-- Get a new database MONGODB_DATABASE for the database named `a_dbname'.
				-- Note
				-- 		Databases are automatically created on the MongoDB server upon insertion of the first document into a collection.
				--		There is no need to create a database manually.
		note
			EIS: "name=mongoc_client_get_database", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_database.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			c_name: C_STRING
			l_ptr: POINTER
		do
			clean_up
			create c_name.make (a_dbname)
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_database (item, c_name.item)
			check success: not l_ptr.is_default_pointer end
			create Result.make_by_pointer (l_ptr)
		end

	database_names (a_opts: detachable BSON): LIST [STRING]
			-- Queries the MongoDB server for a list of known databases.
			-- This is a retryable read operation that will be retried once upon transient errors.
			-- `a_opts': Optional BSON document that may contain:
			--   * sessionId: Client session ID for transactions
			--   * serverId: To target a specific server
			--   * Other options as specified in the listDatabases command
		note
			EIS: "name=mongoc_client_get_database_names_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_database_names_with_opts.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			l_error: BSON_ERROR
			l_ptr: POINTER
			i: INTEGER
			l_mgr: MANAGED_POINTER
			l_opts: POINTER
			l_res: INTEGER
			l_cstring: C_STRING
		do
				-- Clean last error.
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			create l_res.default_create
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_database_names_with_opts (item, l_opts, l_error.item)

			if l_ptr.is_default_pointer then
				set_last_error_with_bson (l_error)
				create {ARRAYED_LIST [STRING]} Result.make (0)
			else
				l_res := {MONGODB_EXTERNALS}.c_mongoc_client_get_database_names_count (item, l_opts, l_error.item)
				create l_mgr.make_from_pointer (l_ptr, l_res * c_sizeof (l_ptr))
				create {ARRAYED_LIST [STRING]} Result.make (l_res)
				from
					i := 0
				until
					i = l_mgr.count
				loop
					create l_cstring.make_by_pointer (l_mgr.read_pointer (i))
					Result.force (l_cstring.string)
					i := i + c_sizeof (l_ptr)
				end
			end
		end

	default_database: detachable MONGODB_DATABASE
			-- Get the database named in the MongoDB connection URI, or VOID if the URI specifies none.
			-- Useful when you want to choose which database to use based only on the URI in a configuration file.
		note
			EIS: "name=mongoc_client_get_default_database", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_default_database.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			l_ptr: POINTER
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_default_database (item)
			if not l_ptr.is_default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	find_databases_with_opts (a_opts: detachable BSON): MONGODB_CURSOR
			-- Fetches a cursor containing documents, each corresponding to a database on this MongoDB server.
			-- This is a retryable read operation that will be retried once upon transient errors.
			-- `a_opts': Optional BSON document that may contain:
			--   * sessionId: Client session ID for transactions
			--   * serverId: To target a specific server
			--   * Other options as specified in the listDatabases command
		note
			EIS: "name=mongoc_client_find_databases_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_find_databases_with_opts.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			l_opts: POINTER
			l_ptr: POINTER
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_find_databases_with_opts (item, l_opts)
			check success: not l_ptr.is_default_pointer end
			create Result.make (l_ptr)
		end

	read_concern: MONGODB_READ_CONCERN
				-- Retrieve the default read concern configured for the client instance.
				-- This Result should not be modified.
		note
			EIS: "name=mongoc_client_get_read_concern", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_read_concern.html", "protocol=uri"
		require
			is_usable: is_usable
		do
			clean_up
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_get_read_concern (item))
		end

	read_preferences: MONGODB_READ_PREFERENCES
				-- Retrieves the default read preferences configured for the client instance.
				-- This result should not be modified
		note
			EIS: "name=mongoc_client_get_read_prefs", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_read_prefs.html", "protocol=uri"
		require
			is_usable: is_usable
		do
			clean_up
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_get_read_prefs (item))
		end

	write_concern: MONGODB_WRITE_CONCERN
			-- Get the write concern for this client
		note
			eis: "name=mongoc_client_get_write_concern", "src=https://mongoc.org/libmongoc/current/mongoc_client_get_write_concern.html", "protocol=uri"
		require
			is_usable: is_usable
		do
			clean_up
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_get_write_concern (item))
		end

	server_description (a_server_id: NATURAL_32): detachable MONGODB_SERVER_DESCRIPTION
			-- Get information about the server specified by `a_server_id`.
			-- Returns: Server description that must be freed, or Void if the server is no longer in the topology.
		note
			EIS: "name=mongoc_client_get_server_description", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_server_description.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			l_ptr: POINTER
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_server_description (item, a_server_id)
			if not l_ptr.is_default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	server_descriptions: LIST [MONGODB_SERVER_DESCRIPTION]
			-- Return an array of server descriptions or empty until the clients connects.
		note
			EIS: "name=mongoc_client_get_server_descriptions", "src=https://mongoc.org/libmongoc/current/mongoc_client_get_server_descriptions.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			l_size: INTEGER_64
			l_mgr: MANAGED_POINTER
			l_ptr: POINTER
			i: INTEGER
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_server_descriptions (item, $l_size)
			create l_mgr.make_from_pointer (l_ptr, (l_size.as_integer_32)* c_sizeof (l_ptr))
			create {ARRAYED_LIST [MONGODB_SERVER_DESCRIPTION]} Result.make (l_size.as_integer_32)
			from
				i := 0
			until
				i = l_mgr.count
			loop
				Result.force (create {MONGODB_SERVER_DESCRIPTION}.make_by_pointer (l_mgr.read_pointer (i)))
				i := i + c_sizeof (l_ptr)
			end
		end

	crypt_shared_version: detachable STRING
			-- Obtain the version string of the crypt_shared that is loaded for auto-encryption.
			-- Returns Void if no crypt_shared library is loaded or auto-encryption is not loaded.
		note
			EIS: "name=mongoc_client_get_crypt_shared_version", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_crypt_shared_version.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			l_ptr: POINTER
			l_c_string: C_STRING
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_crypt_shared_version (item)
			if not l_ptr.is_default_pointer then
				create l_c_string.make_by_pointer (l_ptr)
				Result := l_c_string.string
			end
		end


	handshake_description (a_server_id: NATURAL_32; a_opts: detachable BSON): detachable MONGODB_SERVER_DESCRIPTION
			-- Returns a description constructed from the initial handshake response to a server.
			-- Note: This is distinct from `get_server_description`. This returns a server description
			-- constructed from the connection handshake, which may differ from the server description
			-- constructed from monitoring.
			-- `a_server_id': The ID of the server to get the handshake description for
			-- `a_opts': Optional parameters for the operation
		note
			EIS: "name=mongoc_client_get_handshake_description", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_handshake_description.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			l_error: BSON_ERROR
			l_ptr: POINTER
			l_opts: POINTER
		do
			clean_up
			create l_error.make
			if attached a_opts then
				l_opts := a_opts.item
			end

			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_handshake_description (
				item,			-- client
				a_server_id,	-- server_id
				l_opts,			-- opts
				l_error.item	-- error
			)

			if l_ptr.is_default_pointer then
				set_last_error_with_bson (l_error)
			else
				create Result.make_by_pointer (l_ptr)
			end
		end

	select_server (for_writes: BOOLEAN; prefs: detachable MONGODB_READ_PREFERENCES): detachable MONGODB_SERVER_DESCRIPTION
			-- Choose a server for an operation, according to the Server Selection Spec.
			-- `for_writes': Whether to choose a server suitable for writes or reads.
			-- `prefs': Optional read preferences. If for_writes is True, prefs must be Void.
			--         Otherwise, use prefs to customize server selection, or pass Void to use read preference PRIMARY.
			-- Returns: A server description that must be freed, or Void if no suitable server is found.
		note
			EIS: "name=mongoc_client_select_server", "src=https://mongoc.org/libmongoc/current/mongoc_client_select_server.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			l_prefs: POINTER
			l_error: BSON_ERROR
			l_ptr: POINTER
		do
			clean_up
			if attached prefs then
				l_prefs := prefs.item
			end

			create l_error.make
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_select_server (
				item,       -- client
				for_writes, -- for_writes
				l_prefs,    -- prefs
				l_error.item -- error
			)

			if l_ptr.is_default_pointer then
				set_last_error_with_bson (l_error)
			else
				create Result.make_by_pointer (l_ptr)
			end
		end


feature -- Status

	is_ssl_enabled: BOOLEAN
			-- Is SSL support enabled in this build?
		do
			Result := {MONGODB_EXTERNALS}.is_ssl_enabled
		end

	read_command_with_opts (a_db_name: READABLE_STRING_GENERAL; a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCES;
							a_opts: detachable BSON; a_reply: BSON; )
			-- Execute a command on the server, applying logic specific to read commands.
			-- This is a retryable read operation that will be retried once upon transient errors.
			-- `a_db_name': The name of the database to run the command on.
			-- `a_command': A BSON containing the command specification.
			-- `a_read_prefs': An optional read preferences.
			-- `a_opts': Optional BSON document that may contain:
			--   * readConcern: Read concern for the command
			--   * sessionId: Client session ID for transactions
			--   * collation: Text comparison options
			--   * serverId: To target a specific server
			-- `a_reply': Location for the resulting document.
		note
			EIS: "name=mongoc_client_read_command_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_read_command_with_opts.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			c_db: C_STRING
			l_read_prefs: POINTER
			l_opts: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			create c_db.make (a_db_name)
			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make

			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_read_command_with_opts (
				item,           -- client
				c_db.item,     	-- db_name
				a_command.item, -- command
				l_read_prefs,   -- read_prefs
				l_opts,         -- opts
				a_reply.item,   -- reply
				l_error.item    -- error
			)

			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	read_write_command_with_opts (a_db_name: READABLE_STRING_GENERAL; a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCES; a_opts: detachable BSON;
			a_reply: BSON)
			-- Execute a command on the server that both reads and writes.
			-- Note: The read_prefs parameter is ignored (included by mistake in libmongoc 1.5)
			-- `a_db_name': The name of the database to run the command on.
			-- `a_command': A BSON containing the command specification.
			-- `a_read_prefs': Ignored parameter (included for API compatibility).
			-- `a_opts': Optional BSON document that may contain:
			--   * readConcern: Read concern for the command
			--   * writeConcern: Write concern for the command
			--   * sessionId: Client session ID for transactions
			--   * collation: Text comparison options
			--   * serverId: To target a specific server
			-- `a_reply': Location for the resulting document.
		note
			EIS: "name=mongoc_client_read_write_command_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_read_write_command_with_opts.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			c_db: C_STRING
			l_read_prefs: POINTER
			l_opts: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			create c_db.make (a_db_name)
			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end
			if attached a_opts then
				l_opts := a_opts.item
			end

			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_read_write_command_with_opts (
				item,           -- client
				c_db.item,     	-- db_name
				a_command.item, -- command
				l_read_prefs,   -- read_prefs (ignored)
				l_opts,         -- opts
				a_reply.item,   -- reply
				l_error.item         -- error
			)

			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

feature -- Error

	set_error_api (a_version: INTEGER)
			-- Configure how the C Driver reports errors
			-- a_version: version of the error API, either MONGOC_ERROR_API_VERSION_LEGACY or MONGOC_ERROR_API_VERSION_2.
		note
			EIS: "name=mongoc_client_set_error_api", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_error_api.html", "protocol=uri"
		require
			is_usable: is_usable
			valid_version: a_version = {MONGODB_EXTERNALS}.mongoc_error_api_version_2 or else a_version = {MONGODB_EXTERNALS}.mongoc_error_api_version_legacy
		local
			l_res: BOOLEAN
			l_error: BSON_ERROR
		do
			clean_up
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_set_error_api (item, a_version)
			if not l_res then
				create l_error.make
				l_error.set_error (
					{MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT,
					{MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT_AUTHENTICATE,
					"Failed to set error API version to: " + a_version.out
				)
				set_last_error_with_bson (l_error)
			end
		end

feature -- Settings

	set_read_concern (a_read_concern: MONGODB_READ_CONCERN)
			-- The default read concern is MONGOC_READ_CONCERN_LEVEL_LOCAL. This is the correct read concern for the great majority of applications.
			-- It is a programming error to call this function on a client from a mongoc_client_pool_t. For pooled clients, set the read concern with the MongoDB URI instead.
		note
			EIS: "name=mongoc_client_set_read_concern", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_read_concern.html", "protocol=uri"
		require
			is_usable: is_usable
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_client_set_read_concern (item, a_read_concern.item)
		end


	set_read_preference (a_read_pref: MONGODB_READ_PREFERENCES)
			-- Sets the default read preferences to use with future operations
			-- The global default is to read from the replica set primary.
		note
			EIS: "name=mongoc_client_set_read_prefs ", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_read_prefs.html", "protocol=uri"
		require
			is_usable: is_usable
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_client_set_read_prefs (item, a_read_pref.item)
		end

	set_appname (a_name: READABLE_STRING_GENERAL)
			-- Sets the application name 'a_name' for this client.
			-- This string, along with other internal driver details, is sent to the server as part of the initial connection handshake ('isMaster').
			--'a_name': The application name, of length at most {MONGODB_EXTERNALS}.MONGOC_HANDSHAKE_APPNAME_MAX
		note
			EIS: "name=mongoc_client_set_appname", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_appname.html", "protocol=uri"
		require
			is_usable: is_usable
			is_valid_length: a_name.count <= {MONGODB_EXTERNALS}.MONGOC_HANDSHAKE_APPNAME_MAX
		local
			c_name: C_STRING
			l_res: BOOLEAN
			l_error: BSON_ERROR
		do
			clean_up
			create c_name.make (a_name)
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_set_appname (item, c_name.item)
			if not l_res then
				create l_error.make
				l_error.set_error (
					{MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT,
					{MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT_AUTHENTICATE,
					"Failed to set appname to: " + a_name.out
				)
				set_last_error_with_bson (l_error)
			end
		end

	set_write_concern (a_write_concern: MONGODB_WRITE_CONCERN)
			-- Set the write concern for this client
		note
			eis: "name=", "src=https://mongoc.org/libmongoc/current/mongoc_client_set_write_concern.html", "protocl=uri"
		require
			is_usable: is_usable
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_client_set_write_concern (item, a_write_concern.item)
		end

	reset
			-- Reset the client after forking to prevent resource cleanup interference.
			-- Note: This method:
			-- * Clears the session pool without sending endSessions
			-- * Increments internal generation counter
			-- * Prevents cursors from previous generations from issuing killCursors commands
			-- * Invalidates client sessions from previous generations
		note
			EIS: "name=mongoc_client_reset", "src=http://mongoc.org/libmongoc/current/mongoc_client_reset.html", "protocol=uri"
		require
			is_usable: is_usable
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_client_reset (item)
		end

	set_server_api (a_api: MONGODB_SERVER_API)
			-- Set the API version to use for this client.
			-- Note: Once the API version is set, it cannot be changed to a new value.
			-- Returns: True if the API version was successfully set, False otherwise.
		note
			eis: "name=", "src=https://mongoc.org/libmongoc/current/mongoc_client_set_server_api.html", "protocl=uri"
		require
			is_usable: is_usable
		local
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_set_server_api (
				item,        -- client
				a_api.item,  -- api
				l_error.item -- error
			)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	set_socket_timeout_ms (a_timeout_ms: INTEGER)
			-- Set the socket timeout for this client.
			-- If client was obtained from a client pool, the socket timeout is restored
			-- to the previous value when returning the client to the pool.
			-- `a_timeout_ms': The requested timeout value in milliseconds.
		note
			eis: "name=mongoc_client_set_sockettimeoutms", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_sockettimeoutms.html", "protocol=uri"
		require
			is_usable: is_usable
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_client_set_sockettimeoutms (item, a_timeout_ms)
		end

	set_ssl_opts (a_opts: MONGODB_SSL_OPTIONS)
			-- Sets the TLS (SSL) options to use when connecting to TLS enabled MongoDB servers.
			-- Note: This overrides all TLS options set through the connection string.
			-- Warning: It is a programming error to call this on a client from a client pool.
		note
			EIS: "name=mongoc_client_set_ssl_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_ssl_opts.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			l_error: BSON_ERROR
		do
			clean_up
			if is_ssl_enabled then
				{MONGODB_EXTERNALS}.c_mongoc_client_set_ssl_opts (item, a_opts.item)
			else
				create l_error.make
				l_error.set_error (
					{MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT,
					{MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT_AUTHENTICATE,
					"SSL support is not enabled in this build of the MongoDB C driver"
				)
				set_last_error_with_bson (l_error)
			end
		end

feature -- Encryption

	enable_auto_encryption (a_opts: MONGODB_AUTO_ENCRYPTION)
			-- Enable automatic client side encryption.
			-- Note:
			--   * Requires libmongoc to be built with support for In-Use Encryption
			--   * Only applies to operations on a collection
			--   * Not supported for operations on a database or view
			--   * Requires the authenticated user to have the listCollections privilege
			--   * May reduce maximum message size and impact performance
			-- `a_opts': Required encryption options
		note
			EIS: "name=mongoc_client_enable_auto_encryption", "src=http://mongoc.org/libmongoc/current/mongoc_client_enable_auto_encryption.html", "protocol=uri"
		require
			is_usable: is_usable
			opts_usable: a_opts.exists
		local
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_enable_auto_encryption (
				item,           -- client
				a_opts.item,   -- opts
				l_error.item   -- error
			)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

feature -- Command

	ping (a_db: READABLE_STRING_GENERAL): BOOLEAN
			-- Test if server is responsive
		require
			is_usable: is_usable
		local
			l_command: BSON
			l_reply: BSON
		do
			clean_up
			create l_command.make_from_json ("{ping: 1}")
			create l_reply.make
			command_simple (a_db, l_command, Void, l_reply)
			Result := last_call_succeed
		end

	command_simple (a_db:READABLE_STRING_GENERAL; a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCES; a_reply: BSON)
			-- This is a simplified interface to mongoc_client_command(). It returns the first document from the result cursor into reply.
			-- The client’s read preference, read concern, and write concern are not applied to the command.
			-- 'a_db': The name of the database to run the command on.
			-- 'a_command': A bson_t containing the command specification.
			-- 'a_read_prefs': An optional mongoc_read_prefs_t. Otherwise, the command uses mode MONGOC_READ_PRIMARY.
			-- 'reply': A location for the resulting document.
		note
			EIS: "name=mongoc_client_command_simple", "src=http://mongoc.org/libmongoc/current/mongoc_client_command_simple.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			c_db: C_STRING
			l_res: BOOLEAN
			l_read_prefs:  POINTER
			l_error: BSON_ERROR
		do
			clean_up
			create c_db.make (a_db)

			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end

			create l_error.make

			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_command_simple (item, c_db.item, a_command.item, l_read_prefs, a_reply.item, l_error.item)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	command_with_opts (a_db_name: READABLE_STRING_GENERAL; a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCES; a_opts:detachable BSON;  a_reply: BSON)
			-- Execute a command on the server, interpreting opts according to the MongoDB server version.
			-- 'a_db_name': The name of the database to run the command on.
			-- 'a_command': A bson_t containing the command specification.
			-- 'a_read_prefs': An optional mongoc_read_prefs_t.
			-- 'a_opts': A bson_t containing additional options.
			-- 'a_reply': A location for the resulting document.
			-- 'a_error': An optional location for a bson_error_t or NULL.	
		note
			EIS: "name=mongoc_client_command_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_command_with_opts.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			c_db: C_STRING
			l_read_prefs: POINTER
			l_opts: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			create c_db.make (a_db_name)
			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_command_with_opts (item, c_db.item, a_command.item, l_read_prefs, l_opts, a_reply.item, l_error.item)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	write_command_with_opts (a_db_name: READABLE_STRING_GENERAL; a_command: BSON;
						a_opts: detachable BSON; a_reply: BSON)
			-- Execute a command on the server, applying logic specific to write commands.
			-- Note: Do not use this for basic write operations (insert, update, delete).
			-- Use the CRUD operations or Bulk API instead.
			-- `a_db_name': The name of the database to run the command on.
			-- `a_command': A BSON containing the command specification.
			-- `a_opts': Optional BSON document that may contain:
			--   * writeConcern: Write concern for the command
			--   * sessionId: Client session ID for transactions
			--   * collation: Text comparison options
			--   * serverId: To target a specific server
			-- `a_reply': Location for the resulting document.
		note
			EIS: "name=mongoc_client_write_command_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_write_command_with_opts.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			c_db: C_STRING
			l_opts: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			create c_db.make (a_db_name)
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make

			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_write_command_with_opts (
				item,           -- client
				c_db.item,     -- db_name
				a_command.item, -- command
				l_opts,        -- opts
				a_reply.item,  -- reply
				l_error.item   -- error
			)

			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

feature -- Session

	start_session (a_opts: detachable MONGODB_SESSION_OPTIONS): detachable MONGODB_CLIENT_SESSION
			-- Create a session for a sequence of operations.
			-- By default, sessions are causally consistent.
			-- Unacknowledged writes are prohibited with sessions.
			-- A session must be used by only one thread at a time.
			-- Note: Due to session pooling, this may return a session that has been idle
			-- for some time and is about to be closed after its idle timeout.
			-- Use the session within one minute of acquiring it to refresh the session and avoid a timeout.
			-- `a_opts': Optional session options.
			-- `Result': If successful, returns a newly allocated client session that should be freed when no longer in use.
		note
			EIS: "name=mongoc_client_start_session", "src=https://mongoc.org/libmongoc/current/mongoc_client_start_session.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			l_opts: POINTER
			l_error: BSON_ERROR
			l_ptr: POINTER
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_start_session (item, l_opts, l_error.item)
			if l_ptr.is_default_pointer then
				set_last_error_with_bson (l_error)
			else
				create Result.make_by_pointer (l_ptr)
			end
		end


feature -- Handshake

	handshake_data_append (a_driver_name: detachable READABLE_STRING_GENERAL;
						a_driver_version: detachable READABLE_STRING_GENERAL;
						a_platform: detachable READABLE_STRING_GENERAL)
			-- Appends the given strings to the handshake data for the underlying C Driver.
			-- Must be called before any server operations begin and can only be called once.
			-- `a_driver_name': Optional name of the wrapping driver
			-- `a_driver_version': Optional version of the wrapping driver
			-- `a_platform': Optional information about the current platform
			-- Returns: True if the handshake data was successfully appended
		note
			eis: "name=mongoc_handshake_data_append", "src=http://mongoc.org/libmongoc/current/mongoc_handshake_data_append.html", "protocol=uri"
		require
			is_usable: is_usable
		local
			l_driver_name, l_driver_version, l_platform: C_STRING
			l_driver_name_ptr, l_driver_version_ptr, l_platform_ptr: POINTER
			l_res: BOOLEAN
			l_error: BSON_ERROR
		do
			clean_up
			if attached a_driver_name then
				create l_driver_name.make (a_driver_name)
				l_driver_name_ptr := l_driver_name.item
			end
			if attached a_driver_version then
				create l_driver_version.make (a_driver_version)
				l_driver_version_ptr := l_driver_version.item
			end
			if attached a_platform then
				create l_platform.make (a_platform)
				l_platform_ptr := l_platform.item
			end

			l_res := {MONGODB_EXTERNALS}.c_mongoc_handshake_data_append (
				l_driver_name_ptr,     -- driver_name
				l_driver_version_ptr,  -- driver_version
				l_platform_ptr         -- platform
			)
			if not l_res then
				create l_error.make
				l_error.set_error ({MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT,
								{MONGODB_ERROR_CODE}.MONGOC_ERROR_CLIENT_HANDSHAKE_FAILED,
								"Failed to append handshake data. This operation must be called before any server operations begin and can only be called once.")
				set_last_error_with_bson (l_error)
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
			"return sizeof(mongoc_client_t *);"
		end

	c_sizeof (ptr: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return sizeof ($ptr)"
		end

	c_mongoc_client_destroy (a_client: POINTER)
		note
			eis: "name=mongoc_client_destroy", "src=https://mongoc.org/libmongoc/current/mongoc_client_destroy.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_client_destroy ((mongoc_client_t *)$a_client);"
		end


end

