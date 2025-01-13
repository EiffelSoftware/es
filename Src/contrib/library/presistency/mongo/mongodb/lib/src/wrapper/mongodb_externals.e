note
	description: "Summary description for {MONGODB_EXTERNALS}."
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Mongodb API", "src=http://mongoc.org/libmongoc/current/api.html", "protocol=uri"


class
	MONGODB_EXTERNALS

feature -- Init

	c_mongoc_init
			-- Required to initialize libmongoc's internals
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_init();"
		end

feature -- Read Concern Levels		

	MONGOC_READ_CONCERN_LEVEL_LOCAL: STRING = "local"
			-- #define MONGOC_READ_CONCERN_LEVEL_LOCAL "local".

	MONGOC_READ_CONCERN_LEVEL_MAJORITY: STRING = "majority"
			-- #define MONGOC_READ_CONCERN_LEVEL_MAJORITY "majority".

	MONGOC_READ_CONCERN_LEVEL_LINEARIZABLE: STRING = "linearizable"
			-- #define MONGOC_READ_CONCERN_LEVEL_LINEARIZABLE "linearizable"

feature -- Error

	MONGOC_ERROR_API_VERSION_LEGACY: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_ERROR_API_VERSION_LEGACY"
		end

	MONGOC_ERROR_API_VERSION_2: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_ERROR_API_VERSION_2"
		end

	MONGOC_HANDSHAKE_APPNAME_MAX: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_HANDSHAKE_APPNAME_MAX"
		end

feature -- Read Preference Modes

	MONGOC_READ_PRIMARY: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_READ_PRIMARY"
		end

	MONGOC_READ_SECONDARY: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_READ_SECONDARY"
		end

	MONGOC_READ_PRIMARY_PREFERRED: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_READ_PRIMARY_PREFERRED"
		end

	MONGOC_READ_SECONDARY_PREFERRED: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_READ_SECONDARY_PREFERRED"
		end

	MONGOC_READ_NEAREST: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_READ_NEAREST"
		end

	MONGOC_NO_MAX_STALENESS: INTEGER_64
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_NO_MAX_STALENESS"
		end


Feature -- Mongo Query Flags

	MONGOC_QUERY_NONE: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_NONE"
		end

	MONGOC_QUERY_TAILABLE_CURSOR: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_TAILABLE_CURSOR"
		end

	MONGOC_QUERY_SLAVE_OK: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_SLAVE_OK"
		end

	MONGOC_QUERY_OPLOG_REPLAY: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_OPLOG_REPLAY"
		end

	MONGOC_QUERY_NO_CURSOR_TIMEOUT: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_NO_CURSOR_TIMEOUT"
		end

	MONGOC_QUERY_AWAIT_DATA: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_AWAIT_DATA"
		end

	MONGOC_QUERY_EXHAUST: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_EXHAUST"
		end

	MONGOC_QUERY_PARTIAL: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return MONGOC_QUERY_PARTIAL"
		end

feature -- Client

	c_mongoc_client_new (a_uri: POINTER): POINTER
			-- Create a new client instance with uri `a_uri'.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_new ((const char *)$a_uri);"
		end

	c_mongoc_client_new_from_uri (a_uri: POINTER): POINTER
			-- Create a new client instance with uri `a_uri'.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_new_from_uri ((const mongoc_uri_t *)$a_uri);"
		end

	c_mongoc_client_set_appname (a_client: POINTER; a_appname: POINTER): BOOLEAN
			-- Sets the application name for this client.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_client_set_appname ((mongoc_client_t *)$a_client, (const char *)$a_appname);"
		end

	c_mongoc_client_get_database (a_client: POINTER; a_name: POINTER): POINTER
			-- Get a newly allocated mongoc_database_t for the database named name.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_get_database ((mongoc_client_t *)$a_client, (const char *)$a_name);"
		end

	c_mongoc_client_get_default_database (a_client: POINTER): POINTER
			-- Get the database named in the MongoDB connection URI, or NULL if the URI specifies none.
			-- Useful when you want to choose which database to use based only on the URI in a configuration file.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_get_default_database ((mongoc_client_t*)$a_client);"
		end

	c_mongoc_client_get_collection (a_client: POINTER; a_db: POINTER; a_collection: POINTER): POINTER
			-- Get a newly allocated mongoc_collection_t for the collection named collection in the database named db.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return mongoc_client_get_collection ((mongoc_client_t *)$a_client,
				                              (const char *)$a_db,
				                              (const char *)$a_collection);
			]"
		end

	c_mongoc_client_command_simple (a_client: POINTER; a_dbname: POINTER; a_command: POINTER; a_read_prefs: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return (EIF_BOOLEAN) mongoc_client_command_simple ((mongoc_client_t *)$a_client,
				                              (const char *)$a_dbname,
				                              (const bson_t *)$a_command,
				                              (const mongoc_read_prefs_t *)$a_read_prefs,
				                              (bson_t *)$a_reply,
				                              (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_client_set_error_api (a_client: POINTER; a_version: INTEGER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_set_error_api ((mongoc_client_t *)$a_client, (int32_t)$a_version);"
		end

	c_mongoc_client_command_with_opts (a_client: POINTER; a_db_name: POINTER; a_command: POINTER; a_read_prefs: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
							return (EIF_BOOLEAN)	mongoc_client_command_with_opts (
											   (mongoc_client_t *)$a_client,
											   (const char *)$a_db_name,
											   (const bson_t *)$a_command,
											   (const mongoc_read_prefs_t *)$a_read_prefs,
											   (const bson_t *)$a_opts,
											   (bson_t *)$a_reply,
											   (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_client_get_database_names_with_opts (a_client: POINTER; a_opts: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
					   char **strv;
					   strv = mongoc_client_get_database_names_with_opts ($a_client, $a_opts, $a_error);
				 	   return strv;
			]"
		end

	c_mongoc_client_get_database_names_count (a_client: POINTER; a_opts: POINTER; a_error: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				char **strv;
				strv = mongoc_client_get_database_names_with_opts ($a_client, $a_opts, $a_error);
				int i;
				for (i = 0; strv[i]; i++);
				return i;
			]"
		end

	c_mongoc_client_get_uri (a_client: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_client_get_uri ((const mongoc_client_t *)$a_client);
			]"
		end

	c_mongoc_client_get_server_status (a_client: POINTER; a_read_prefs: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return (EIF_BOOLEAN) mongoc_client_get_server_status ((mongoc_client_t *)$a_client,
				                                 (mongoc_read_prefs_t *)$a_read_prefs,
				                                 (bson_t *)$a_reply,
				                                 (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_client_find_databases_with_opts (a_client: POINTER; a_opts: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return mongoc_client_find_databases_with_opts ((mongoc_client_t *)$a_client, (const bson_t *)$a_opts);

			]"
		end

	c_mongoc_client_get_read_concern (a_client: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return mongoc_client_get_read_concern ((const mongoc_client_t *)$a_client);

			]"
		end


	c_mongoc_client_get_read_prefs (a_client: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return mongoc_client_get_read_prefs ((const mongoc_client_t *)$a_client);

			]"
		end


	c_mongoc_client_set_read_concern (a_client: POINTER; a_read_concern: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								mongoc_client_set_read_concern ((mongoc_client_t *)$a_client, (const mongoc_read_concern_t *)$a_read_concern);

			]"
		end


	c_mongoc_client_set_read_prefs (a_client: POINTER; a_read_prefs:POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								mongoc_client_set_read_prefs ((mongoc_client_t *)$a_client, (const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_client_get_server_descriptions (a_client: POINTER; a_size: TYPED_POINTER [INTEGER_64]): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
						size_t i, n;
						mongoc_server_description_t ** res;
						res = mongoc_client_get_server_descriptions ((const mongoc_client_t *)$a_client, &n);
						$a_size = n;
						return res;
			]"
		end

	c_mongoc_client_start_session (a_client: POINTER; a_opts: POINTER; a_error:POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
						return mongoc_client_start_session ((mongoc_client_t *)$a_client, (mongoc_session_opt_t *)$a_opts, (bson_error_t *)$a_error);

			]"
		end

	c_mongoc_client_get_write_concern (a_client: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_get_write_concern ((const mongoc_client_t *)$a_client);"
		end

	c_mongoc_client_set_write_concern (a_client: POINTER; a_write_concern: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_client_set_write_concern ((mongoc_client_t *)$a_client, (const mongoc_write_concern_t *)$a_write_concern);"
		end

	c_mongoc_client_get_max_message_size (a_client: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_get_max_message_size ((const mongoc_client_t *)$a_client);"
		end

	c_mongoc_client_select_server (a_client: POINTER; a_for_writes: BOOLEAN; a_prefs: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_select_server ((mongoc_client_t *)$a_client, (bool)$a_for_writes, (const mongoc_read_prefs_t *)$a_prefs, (bson_error_t *)$a_error);"
		end


    c_mongoc_client_get_crypt_shared_version (a_client: POINTER): POINTER
            -- Obtain the version string of the crypt_shared that is loaded for auto-encryption.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return (EIF_POINTER) mongoc_client_get_crypt_shared_version ((const mongoc_client_t *)$a_client);"
        end

	c_mongoc_client_get_handshake_description (a_client: POINTER; a_server_id: NATURAL_32; a_opts: POINTER; a_error: POINTER): POINTER
			-- Returns a description constructed from the initial handshake response to a server.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_client_get_handshake_description(
					(mongoc_client_t *)$a_client,
					(uint32_t)$a_server_id,
					(bson_t *)$a_opts,
					(bson_error_t *)$a_error
				);
			]"
		end


    c_mongoc_client_read_command_with_opts (a_client: POINTER; a_db_name: POINTER; a_command: POINTER;
            a_read_prefs: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
            -- Execute a command on the server, applying logic specific to read commands
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_client_read_command_with_opts(
                    (mongoc_client_t *)$a_client,
                    (const char *)$a_db_name,
                    (const bson_t *)$a_command,
                    (const mongoc_read_prefs_t *)$a_read_prefs,
                    (const bson_t *)$a_opts,
                    (bson_t *)$a_reply,
                    (bson_error_t *)$a_error
                );
            ]"
        end

	c_mongoc_client_new_from_uri_with_error (a_uri: POINTER; a_error: POINTER): POINTER
			-- Creates a new mongoc_client_t using the mongoc_uri_t provided.
			-- Parameters:
			--   a_uri: const mongoc_uri_t* - The URI to use
			--   a_error: bson_error_t* - Optional error location
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_client_new_from_uri_with_error(
					(const mongoc_uri_t *)$a_uri,
					(bson_error_t *)$a_error
				);
			]"
		end

	c_mongoc_client_reset (a_client: POINTER)
			-- Call this method in the child after forking to invalidate the client.
			-- Prevents resource cleanup in the child process from interfering with the parent process.
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_client_reset ((mongoc_client_t *)$a_client);"
		end

	c_mongoc_client_set_server_api (a_client: POINTER; a_api: POINTER; a_error: POINTER): BOOLEAN
			-- Set the API version to use for client.
			-- Parameters:
			--   a_client: mongoc_client_t* - The client instance
			--   a_api: const mongoc_server_api_t* - The server API version
			--   a_error: bson_error_t* - Error information
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_client_set_server_api(
					(mongoc_client_t *)$a_client,
					(const mongoc_server_api_t *)$a_api,
					(bson_error_t *)$a_error
				);
			]"
		end

	c_mongoc_client_set_sockettimeoutms (a_client: POINTER; a_timeoutms: INTEGER)
			-- Set the socket timeout for this client
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_client_set_sockettimeoutms((mongoc_client_t *)$a_client, (int32_t)$a_timeoutms);"
		end

	c_mongoc_handshake_data_append (a_driver_name: POINTER; a_driver_version: POINTER; a_platform: POINTER): BOOLEAN
			-- Appends the given strings to the handshake data for the underlying C Driver.
			-- Parameters:
			--   a_driver_name: const char* - The name of the wrapping driver
			--   a_driver_version: const char* - The version of the wrapping driver
			--   a_platform: const char* - Information about the current platform
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_handshake_data_append(
					(const char *)$a_driver_name,
					(const char *)$a_driver_version,
					(const char *)$a_platform
				);
			]"
		end

	c_mongoc_client_write_command_with_opts (a_client: POINTER; a_db_name: POINTER;
            a_command: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
            -- Execute a command on the server, applying logic specific to write commands
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_client_write_command_with_opts(
                    (mongoc_client_t *)$a_client,
                    (const char *)$a_db_name,
                    (const bson_t *)$a_command,
                    (const bson_t *)$a_opts,
                    (bson_t *)$a_reply,
                    (bson_error_t *)$a_error
                );
            ]"
        end

feature -- Mongo Collection

	c_mongoc_collection_insert_one (a_collection: POINTER; a_document: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return (EIF_BOOLEAN) mongoc_collection_insert_one ((mongoc_collection_t *)$a_collection,
				                              (const bson_t *)$a_document,
				                              (const bson_t *)$a_opts,
				                              (bson_t *)$a_reply,
				                              (bson_error_t *)$a_error);
			]"
		end


	c_mongoc_collection_insert_many (a_collection: POINTER; a_documents: POINTER; a_val: INTEGER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
			   	return	mongoc_collection_insert_many ((mongoc_collection_t *)$a_collection,
                               (const bson_t **)$a_documents,
                               (size_t) $a_val,
                               (const bson_t *)$a_opts,
                               (bson_t *)$a_reply,
                               (bson_error_t *)$a_error);
			]"
		end


	c_mongoc_collection_find_with_opts (a_collection: POINTER; a_filter: POINTER; a_opts: POINTER; a_read_prefs: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return mongoc_collection_find_with_opts ((mongoc_collection_t *)$a_collection,
				                                  (const bson_t *)$a_filter,
				                                  (const bson_t *)$a_opts,
				                                  (const mongoc_read_prefs_t *)$a_read_prefs)
			]"
		end

	c_mongoc_collection_update_one (a_collection: POINTER; a_selector: POINTER; a_update: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_collection_update_one ((mongoc_collection_t *)$a_collection,
				                             (const bson_t *)$a_selector,
				                             (const bson_t *)$a_update,
				                             (const bson_t *)$a_opts,
				                             (bson_t *)$a_reply,
				                             (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_collection_delete_one (a_collection: POINTER; a_selector: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return (EIF_BOOLEAN)  mongoc_collection_delete_one ((mongoc_collection_t *)$a_collection,
				                              (const bson_t *)$a_selector,
				                              (const bson_t *)$a_opts,
				                              (bson_t *)$a_reply,
				                              (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_collection_count (a_collection: POINTER; a_flags: INTEGER; a_query: POINTER; a_skip: INTEGER_64; a_limit: INTEGER_64; a_read_prefs: POINTER; a_error: POINTER): INTEGER_64
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
					return (EIF_INTEGER_64)
					mongoc_collection_count ((mongoc_collection_t *)$a_collection,
				                         (mongoc_query_flags_t)$a_flags,
				                         (const bson_t *)$a_query,
				                         (int64_t)$a_skip,
				                         (int64_t)$a_limit,
				                         (const mongoc_read_prefs_t *)$a_read_prefs,
				                         (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_collection_drop_with_opts (a_collection: POINTER; a_opts: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return (EIF_BOOLEAN)  mongoc_collection_drop_with_opts ((mongoc_collection_t *)$a_collection,
				                                  (bson_t *)$a_opts,
				                                  (bson_error_t *)$a_error);
			]"
		end



	c_mongoc_collection_aggregate (a_collection: POINTER; a_flags: INTEGER; a_pipeline: POINTER; a_opts: POINTER; a_read_prefs: POINTER): POINTER
			-- Execute an aggregation pipeline
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_collection_aggregate ((mongoc_collection_t *)$a_collection,
												  (mongoc_query_flags_t)$a_flags,
												  (const bson_t *)$a_pipeline,
												  (const bson_t *)$a_opts,
												  (const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_collection_find_and_modify (coll: POINTER; query: POINTER; sort: POINTER;
			update: POINTER; fields: POINTER; remove: BOOLEAN; upsert: BOOLEAN;
			new_doc: BOOLEAN; reply: POINTER; error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_collection_find_and_modify(
					(mongoc_collection_t*)$coll,
					(const bson_t*)$query,
					(const bson_t*)$sort,
					(const bson_t*)$update,
					(const bson_t*)$fields,
					$remove,
					$upsert,
					$new_doc,
					(bson_t*)$reply,
					(bson_error_t*)$error
				);
			]"
		end


 	c_mongoc_collection_update_many (collection: POINTER; selector: POINTER; update: POINTER; opts: POINTER; reply: POINTER; error: POINTER): BOOLEAN
            -- Update all documents in collection matching selector
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to update
            --   selector: const bson_t* - document describing the query to match documents
            --   update: const bson_t* - document containing update operations or pipeline
            --   opts: const bson_t* - optional additional options
            --   reply: bson_t* - optional reply document
            --   error: bson_error_t* - optional error details
            -- Returns: true on success, false on failure with error set
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_update_many(
                    (mongoc_collection_t *)$collection,
                    (const bson_t *)$selector,
                    (const bson_t *)$update,
                    (const bson_t *)$opts,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

feature -- Collection Operations

    c_mongoc_collection_count_documents (collection: POINTER; filter: POINTER; opts: POINTER; read_prefs: POINTER; reply: POINTER; error: POINTER): INTEGER_64
            -- Count documents in collection matching filter
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to count from
            --   filter: const bson_t* - the filter to match documents
            --   opts: const bson_t* - optional query options
            --   read_prefs: const mongoc_read_prefs_t* - optional read preferences
            --   reply: bson_t* - optional reply document
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_count_documents(
                    (mongoc_collection_t *)$collection,
                    (const bson_t *)$filter,
                    (const bson_t *)$opts,
                    (const mongoc_read_prefs_t *)$read_prefs,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_collection_estimated_document_count (collection: POINTER; opts: POINTER; read_prefs: POINTER; reply: POINTER; error: POINTER): INTEGER_64
            -- Get an estimated count of documents in collection
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to count from
            --   opts: const bson_t* - optional query options
            --   read_prefs: const mongoc_read_prefs_t* - optional read preferences
            --   reply: bson_t* - optional reply document
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_estimated_document_count(
                    (mongoc_collection_t *)$collection,
                    (const bson_t *)$opts,
                    (const mongoc_read_prefs_t *)$read_prefs,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_collection_command_simple (collection: POINTER; command: POINTER; read_prefs: POINTER; reply: POINTER; error: POINTER): BOOLEAN
            -- Execute a command on the collection.
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to execute the command on
            --   command: const bson_t* - the command to execute
            --   read_prefs: const mongoc_read_prefs_t* - optional read preferences
            --   reply: bson_t* - storage for the command's result document
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_command_simple(
                    (mongoc_collection_t *)$collection,
                    (const bson_t *)$command,
                    (const mongoc_read_prefs_t *)$read_prefs,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_collection_delete_many (collection: POINTER; selector: POINTER; opts: POINTER; reply: POINTER; error: POINTER): BOOLEAN
            -- Delete all documents matching selector
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to delete from
            --   selector: const bson_t* - the query to match documents
            --   opts: const bson_t* - optional delete options
            --   reply: bson_t* - optional reply document
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_delete_many(
                    (mongoc_collection_t *)$collection,
                    (const bson_t *)$selector,
                    (const bson_t *)$opts,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_collection_create_indexes_with_opts (collection: POINTER; models: POINTER; n_models: INTEGER; opts: POINTER; reply: POINTER; error: POINTER): BOOLEAN
            -- Create multiple indexes on the collection
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to create indexes on
            --   models: mongoc_index_model_t** - array of index model pointers
            --   n_models: size_t - number of index models
            --   opts: const bson_t* - optional additional options
            --   reply: bson_t* - optional reply document
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_create_indexes_with_opts(
                    (mongoc_collection_t *)$collection,
                    (mongoc_index_model_t **)$models,
                    (size_t)$n_models,
                    (const bson_t *)$opts,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_collection_drop_index (collection: POINTER; index_name: POINTER; error: POINTER): BOOLEAN
            -- Drop an index from the collection
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to drop the index from
            --   index_name: const char* - name of the index to drop
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_drop_index(
                    (mongoc_collection_t *)$collection,
                    (const char *)$index_name,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_collection_find_indexes_with_opts (collection: POINTER; opts: POINTER): POINTER
            -- Fetch a cursor containing documents for each index in the collection
            -- Parameters:
            --   collection: mongoc_collection_t* - the collection to get indexes from
            --   opts: const bson_t* - optional additional options
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_collection_find_indexes_with_opts(
                    (mongoc_collection_t *)$collection,
                    (const bson_t *)$opts
                );
            ]"
        end

feature -- Mongo Database

	c_mongoc_database_create_collection (a_database: POINTER; a_name: POINTER; a_opts: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
								return mongoc_database_create_collection ((mongoc_database_t *)$a_database,
				                                   (const char *)$a_name,
				                                   (const bson_t *)$a_opts,
				                                   (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_database_get_collection_names_with_opts (a_database: POINTER; a_opts: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
					   char **strv;
					   strv = mongoc_database_get_collection_names_with_opts  ($a_database, $a_opts, $a_error);
				 	   return strv;
			]"
		end

	c_mongoc_database_get_collection_names_count (a_database: POINTER; a_opts: POINTER; a_error: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				char **strv;
				strv = mongoc_database_get_collection_names_with_opts ($a_database, $a_opts, $a_error);
				int i;
				for (i = 0; strv[i]; i++);
				return i;
			]"
		end

	c_mongoc_database_has_collection (a_database: POINTER; a_name: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
							return (EIF_BOOLEAN) mongoc_database_has_collection ((mongoc_database_t *)$a_database,
				                                (const char *)$a_name,
				                                (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_database_drop_with_opts (a_database: POINTER; a_opts: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
							return (EIF_BOOLEAN) mongoc_database_drop_with_opts ((mongoc_database_t *)$a_database,
				                                (const bson_t *)$a_opts,
				                                (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_database_get_collection (a_database: POINTER; a_name: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_database_get_collection ((mongoc_database_t *)$a_database, (const char *)$a_name);
			]"
		end

	c_mongoc_database_get_name (a_database: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_database_get_name ((mongoc_database_t *)$a_database);	;
			]"
		end

	c_mongoc_database_add_user (a_database: POINTER; a_username: POINTER; a_password: POINTER;
                               a_roles: POINTER; a_custom_data: POINTER; a_error: POINTER): BOOLEAN
            -- Create a new user with access to database
            -- Parameters:
            --   a_database: mongoc_database_t* - The database instance
            --   a_username: const char* - The name of the user
            --   a_password: const char* - The cleartext password for the user
            --   a_roles: const bson_t* - Optional roles as BSON document
            --   a_custom_data: const bson_t* - Optional custom data as BSON document
            --   a_error: bson_error_t* - Optional error location
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_database_add_user(
                    (mongoc_database_t *)$a_database,
                    (const char *)$a_username,
                    (const char *)$a_password,
                    (const bson_t *)$a_roles,
                    (const bson_t *)$a_custom_data,
                    (bson_error_t *)$a_error
                );
            ]"
        end

    c_mongoc_database_aggregate (a_database: POINTER; a_pipeline: POINTER;
                               a_opts: POINTER; a_read_prefs: POINTER): POINTER
            -- Execute an aggregation pipeline on a database
            -- Parameters:
            --   a_database: mongoc_database_t* - the database to aggregate from
            --   a_pipeline: const bson_t* - the pipeline of aggregation operations
            --   a_opts: const bson_t* - optional options for the command
            --   a_read_prefs: const mongoc_read_prefs_t* - optional read preferences
            -- Returns:
            --   A newly allocated mongoc_cursor_t that should be freed with mongoc_cursor_destroy()
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_database_aggregate(
                    (mongoc_database_t *)$a_database,
                    (const bson_t *)$a_pipeline,
                    (const bson_t *)$a_opts,
                    (const mongoc_read_prefs_t *)$a_read_prefs
                );
            ]"
        end

    c_mongoc_database_command_simple (a_database: POINTER; a_command: POINTER;
                                    a_read_prefs: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
            -- Execute a command on the database with a simplified interface.
            -- Parameters:
            --   a_database: mongoc_database_t* - the database to execute the command on
            --   a_command: const bson_t* - the command to execute
            --   a_read_prefs: const mongoc_read_prefs_t* - optional read preferences
            --   a_reply: bson_t* - storage for the command's result document
            --   a_error: bson_error_t* - optional error details
            -- Returns: true on success, false on failure with error set
            -- Note: This is not considered a retryable read operation
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_database_command_simple(
                    (mongoc_database_t *)$a_database,
                    (const bson_t *)$a_command,
                    (const mongoc_read_prefs_t *)$a_read_prefs,
                    (bson_t *)$a_reply,
                    (bson_error_t *)$a_error
                );
            ]"
        end

    c_mongoc_database_command_with_opts (a_database: POINTER; a_command: POINTER;
                                       a_read_prefs: POINTER; a_opts: POINTER;
                                       a_reply: POINTER; a_error: POINTER): BOOLEAN
            -- Execute a command on the server, interpreting opts according to MongoDB server version.
            -- Parameters:
            --   a_database: mongoc_database_t* - the database to execute the command on
            --   a_command: const bson_t* - the command to execute
            --   a_read_prefs: const mongoc_read_prefs_t* - optional read preferences
            --   a_opts: const bson_t* - optional additional options
            --   a_reply: bson_t* - storage for the command's result document
            --   a_error: bson_error_t* - optional error details
            -- Note: This is not considered a retryable read operation.
            -- Note: In a transaction, read concern and write concern are prohibited in opts
            --       and the read preference must be primary or NULL.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_database_command_with_opts(
                    (mongoc_database_t *)$a_database,
                    (const bson_t *)$a_command,
                    (const mongoc_read_prefs_t *)$a_read_prefs,
                    (const bson_t *)$a_opts,
                    (bson_t *)$a_reply,
                    (bson_error_t *)$a_error
                );
            ]"
        end

    c_mongoc_database_copy (a_database: POINTER): POINTER
            -- Performs a deep copy of the database struct and its configuration.
            -- Parameters:
            --   a_database: mongoc_database_t* - The database to copy
            -- Returns: A newly allocated mongoc_database_t that should be freed with mongoc_database_destroy()
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_database_copy((mongoc_database_t *)$a_database);"
        end

    c_mongoc_database_find_collections_with_opts (a_database: POINTER; a_opts: POINTER): POINTER
            -- Fetches a cursor containing documents, each corresponding to a collection on this database.
            -- Parameters:
            --   a_database: mongoc_database_t* - The database to query
            --   a_opts: const bson_t* - Optional additional options
            -- Returns: A newly allocated mongoc_cursor_t that must be freed with mongoc_cursor_destroy()
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_database_find_collections_with_opts(
                    (mongoc_database_t *)$a_database,
                    (const bson_t *)$a_opts
                );
            ]"
        end

    c_mongoc_database_get_read_concern (a_database: POINTER): POINTER
            -- Retrieves the default read concern for the database
            -- Parameters:
            --   a_database: mongoc_database_t* - The database instance
            -- Returns: A mongoc_read_concern_t that should not be modified or freed
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_database_get_read_concern((const mongoc_database_t *)$a_database);"
        end

    c_mongoc_database_get_read_prefs (a_database: POINTER): POINTER
            -- Fetches the default read preferences to use with database
            -- Parameters:
            --   a_database: mongoc_database_t* - The database instance
            -- Returns: A mongoc_read_prefs_t that should not be modified or freed
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_database_get_read_prefs((const mongoc_database_t *)$a_database);"
        end

    c_mongoc_database_get_write_concern (a_database: POINTER): POINTER
            -- Retrieves the default write concern for the database
            -- Parameters:
            --   a_database: mongoc_database_t* - The database instance
            -- Returns: A mongoc_write_concern_t that should not be modified or freed
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_database_get_write_concern((const mongoc_database_t *)$a_database);"
        end

    c_mongoc_database_read_command_with_opts (a_database: POINTER; a_command: POINTER;
                                            a_read_prefs: POINTER; a_opts: POINTER;
                                            a_reply: POINTER; a_error: POINTER): BOOLEAN
            -- Execute a command on the server, applying logic specific to read commands
            -- Parameters:
            --   a_database: mongoc_database_t* - The database instance
            --   a_command: const bson_t* - The command to execute
            --   a_read_prefs: const mongoc_read_prefs_t* - Optional read preferences
            --   a_opts: const bson_t* - Optional additional options
            --   a_reply: bson_t* - Storage for the command's result
            --   a_error: bson_error_t* - Optional error information
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_database_read_command_with_opts(
                    (mongoc_database_t *)$a_database,
                    (const bson_t *)$a_command,
                    (const mongoc_read_prefs_t *)$a_read_prefs,
                    (const bson_t *)$a_opts,
                    (bson_t *)$a_reply,
                    (bson_error_t *)$a_error
                );
            ]"
        end

    c_mongoc_database_read_write_command_with_opts (a_database: POINTER; a_command: POINTER;
                                                  a_read_prefs: POINTER; a_opts: POINTER;
                                                  a_reply: POINTER; a_error: POINTER): BOOLEAN
            -- Execute a command on the server, applying logic for commands that both read and write
            -- Parameters:
            --   a_database: mongoc_database_t* - The database instance
            --   a_command: const bson_t* - The command to execute
            --   a_read_prefs: const mongoc_read_prefs_t* - Ignored (included by mistake in libmongoc 1.5)
            --   a_opts: const bson_t* - Optional additional options
            --   a_reply: bson_t* - Storage for the command's result
            --   a_error: bson_error_t* - Optional error information
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_database_read_write_command_with_opts(
                    (mongoc_database_t *)$a_database,
                    (const bson_t *)$a_command,
                    (const mongoc_read_prefs_t *)$a_read_prefs,
                    (const bson_t *)$a_opts,
                    (bson_t *)$a_reply,
                    (bson_error_t *)$a_error
                );
            ]"
        end


 	c_mongoc_database_remove_all_users (a_database: POINTER; a_error: POINTER): BOOLEAN
            -- Remove all users configured to access the database
            -- Parameters:
            --   a_database: mongoc_database_t* - The database instance
            --   a_error: bson_error_t* - Optional error information
            -- Returns: true if successful, false and sets error if there are invalid arguments or a server error
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_database_remove_all_users((mongoc_database_t *)$a_database, (bson_error_t *)$a_error);"
        end

    c_mongoc_database_set_read_concern (a_database: POINTER; a_read_concern: POINTER)
            -- Set the read concern for the database
            -- Parameters:
            --   a_database: mongoc_database_t* - The database instance
            --   a_read_concern: const mongoc_read_concern_t* - The read concern to set
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_database_set_read_concern((mongoc_database_t *)$a_database, (const mongoc_read_concern_t *)$a_read_concern);"
        end

    c_mongoc_database_remove_user (a_database: POINTER; a_username: POINTER; a_error: POINTER): BOOLEAN
            -- Remove a specific user from the database
            -- Parameters:
            --   a_database: mongoc_database_t* - The database instance
            --   a_username: const char* - The username to remove
            --   a_error: bson_error_t* - Optional error information
            -- Returns: true if successful, false and sets error if there are invalid arguments or a server error
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_database_remove_user((mongoc_database_t *)$a_database, (const char *)$a_username, (bson_error_t *)$a_error);"
        end

    c_mongoc_database_set_write_concern (a_database: POINTER; a_write_concern: POINTER)
            -- Set the write concern for the database
            -- Parameters:
            --   a_database: mongoc_database_t* - The database instance
            --   a_write_concern: const mongoc_write_concern_t* - The write concern to set
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_database_set_write_concern((mongoc_database_t *)$a_database, (const mongoc_write_concern_t *)$a_write_concern);"
        end


    c_mongoc_database_watch (a_database: POINTER; a_pipeline: POINTER; a_opts: POINTER): POINTER
            -- Create a change stream for watching changes in a database
            -- Parameters:
            --   a_database: mongoc_database_t* - The database to watch
            --   a_pipeline: const bson_t* - Optional aggregation pipeline
            --   a_opts: const bson_t* - Optional change stream options
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_database_watch((mongoc_database_t *)$a_database, (const bson_t *)$a_pipeline, (const bson_t *)$a_opts);"
        end

    c_mongoc_database_write_command_with_opts (a_database: POINTER; a_command: POINTER;
                                           a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
            -- Execute a command on the server, applying logic specific to write commands
            -- Parameters:
            --   a_database: mongoc_database_t* - The database instance
            --   a_command: const bson_t* - The command to execute
            --   a_opts: const bson_t* - Optional additional options
            --   a_reply: bson_t* - Storage for the command's result
            --   a_error: bson_error_t* - Optional error information
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_database_write_command_with_opts(
                    (mongoc_database_t *)$a_database,
                    (const bson_t *)$a_command,
                    (const bson_t *)$a_opts,
                    (bson_t *)$a_reply,
                    (bson_error_t *)$a_error
                );
            ]"
        end

feature -- Mongo Client Pool

	c_mongoc_client_pool_new (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
			alias
				"[
					return mongoc_client_pool_new ((const mongoc_uri_t *)$a_uri);
				]"
			end

	c_mongoc_client_pool_pop (a_pool: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_client_pool_pop ((mongoc_client_pool_t *)$a_pool);
			]"
		end

	c_mongoc_client_pool_push (a_pool: POINTER; a_client: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				mongoc_client_pool_push ((mongoc_client_pool_t *)$a_pool, (mongoc_client_t *)$a_client);
			]"
		end

	c_mongoc_client_pool_try_pop (a_pool: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_client_pool_try_pop ((mongoc_client_pool_t *)$a_pool);
			]"
		end

	c_mongoc_client_pool_set_appname (a_pool: POINTER; a_name: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_client_pool_set_appname ((mongoc_client_pool_t *)$a_pool, (const char *)$a_name);
			]"
		end

	c_mongoc_client_pool_set_error_api (a_pool: POINTER; a_version: INTEGER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_client_pool_set_error_api ((mongoc_client_pool_t *)$a_pool, (int32_t)$a_version);
			]"
		end

	c_mongoc_client_pool_max_size (a_pool: POINTER; a_max_pool_size: NATURAL_32)
			-- Sets the maximum number of pooled connections available
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				mongoc_client_pool_max_size((mongoc_client_pool_t *)$a_pool, (uint32_t)$a_max_pool_size);
			]"
		end

	c_mongoc_client_pool_new_with_error (a_uri: POINTER; a_error: POINTER): POINTER
			-- Creates a new client pool using the URI provided, with error handling
			-- Parameters:
			--   a_uri: const mongoc_uri_t* - The URI to use
			--   a_error: bson_error_t* - Optional error location
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_client_pool_new_with_error(
					(const mongoc_uri_t *)$a_uri,
					(bson_error_t *)$a_error
				);
			]"
		end

	c_mongoc_client_pool_set_server_api (a_pool: POINTER; a_api: POINTER; a_error: POINTER): BOOLEAN
			-- Set the API version to use for clients created through pool
			-- Parameters:
			--   a_pool: mongoc_client_pool_t* - The client pool instance
			--   a_api: const mongoc_server_api_t* - The server API version
			--   a_error: bson_error_t* - Error information
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_client_pool_set_server_api(
					(mongoc_client_pool_t *)$a_pool,
					(const mongoc_server_api_t *)$a_api,
					(bson_error_t *)$a_error
				);
			]"
		end

feature -- Cursor

	c_mongo_cursor_next (a_cursor: POINTER; a_bson: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_cursor_next ((mongoc_cursor_t *)$a_cursor, (const bson_t **)$a_bson);
			]"
		end

	c_mongoc_cursor_error (a_cursor: POINTER; a_error: POINTER): BOOLEAN
			-- Check if an error has occurred while iterating the cursor
			-- Parameters:
			--   a_cursor: mongoc_cursor_t* - The cursor instance
			--   a_error: bson_error_t* - Optional error location
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_cursor_error((mongoc_cursor_t *)$a_cursor, (bson_error_t *)$a_error);"
		end

feature -- URI

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

feature -- Mongo Read Preference

	c_mongoc_read_prefs_new (a_read_mode: INTEGER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_new ((mongoc_read_mode_t)$a_read_mode);
			]"
		end

	c_mongoc_read_prefs_is_valid (a_read_prefs: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_read_prefs_is_valid ((const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_read_prefs_get_mode (a_read_prefs: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_get_mode ((const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_read_prefs_get_tags (a_read_prefs: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_get_tags ((const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_read_prefs_set_mode (a_read_prefs: POINTER; a_mode: INTEGER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_set_mode ((mongoc_read_prefs_t *)$a_read_prefs,
                            (mongoc_read_mode_t)$a_mode);
			]"
		end

	c_mongoc_read_prefs_set_tags (a_read_prefs: POINTER; a_tags: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_set_tags ((mongoc_read_prefs_t *)$a_read_prefs,
                            (const bson_t *)$a_tags);
			]"
		end

	c_mongoc_read_prefs_set_max_staleness_seconds (a_read_prefs: POINTER; a_seconds: INTEGER_64)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_set_max_staleness_seconds ((mongoc_read_prefs_t *)$a_read_prefs,
                                             (int64_t)$a_seconds);
			]"
		end

feature -- Mongo Read Concern

	c_mongoc_read_concern_new: POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_read_concern_new();
			]"
		end

	c_mongoc_read_concern_get_level (a_read_concern: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (const char *) mongoc_read_concern_get_level ((const mongoc_read_concern_t *)$a_read_concern);
			]"
		end

	c_mongoc_read_concern_is_default (a_read_concern: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_read_concern_is_default ((mongoc_read_concern_t *)$a_read_concern);
			]"
		end

	c_mongoc_read_concern_set_level (a_read_concern: POINTER; a_level: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_read_concern_set_level ((mongoc_read_concern_t *)$a_read_concern,
	                              (const char *)$a_level);
			]"
		end

    c_mongoc_read_concern_append (a_read_concern: POINTER; a_command: POINTER): BOOLEAN
            -- Append read concern to command options
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_read_concern_append((mongoc_read_concern_t *)$a_read_concern, (bson_t *)$a_command);"
        end

feature -- Mongo Server Description

	c_mongoc_server_description_id (a_description: POINTER): INTEGER_32
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_INTEGER_32) mongoc_server_description_id ((const mongoc_server_description_t *)$a_description);
			]"
		end

	c_mongoc_server_description_ismaster (a_description: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_server_description_ismaster ((const mongoc_server_description_t *)$a_description);
			]"
		end

	c_mongoc_server_description_new_copy (a_description: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_server_description_new_copy ((const mongoc_server_description_t *)$a_description);
			]"
		end

	c_mongoc_server_description_round_trip_time (a_description: POINTER): INTEGER_64
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return (EIF_INTEGER_64) mongoc_server_description_round_trip_time ((const mongoc_server_description_t *)$a_description);
			]"
		end

	c_mongoc_server_description_type (a_description: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_server_description_type ((const mongoc_server_description_t *)$a_description);

			]"
		end

	c_mongoc_server_description_host (a_description: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_server_description_host ((const mongoc_server_description_t *)$a_description);

			]"
		end

feature -- MongoDB Session Options

	c_mongoc_session_opts_new: POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_session_opts_new();
			]"
		end


	c_mongoc_session_opts_get_causal_consistency (a_opts: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return mongoc_session_opts_get_causal_consistency($a_opts);
			]"
		end

	c_mongoc_session_opts_set_causal_consistency (a_opts: POINTER; a_causal_consistency: BOOLEAN)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return 	mongoc_session_opts_set_causal_consistency ((mongoc_session_opt_t *)$a_opts, (bool)$a_causal_consistency);
			]"
		end

	c_mongoc_session_opts_clone (a_opts: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"[
				return 	mongoc_session_opts_clone ((const mongoc_session_opt_t *)$a_opts);
			]"
		end

feature -- Write Concern

	c_mongoc_write_concern_new: POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_new();"
		end

	c_mongoc_write_concern_is_default (a_concern: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_is_default((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_is_acknowledged (a_concern: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_is_acknowledged((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_is_valid (a_concern: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_is_valid((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_get_w (a_concern: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_get_w((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_get_wtimeout_int64 (a_concern: POINTER): INTEGER_64
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_get_wtimeout_int64((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_get_wtag (a_concern: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (EIF_POINTER)mongoc_write_concern_get_wtag((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_get_journal (a_concern: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_get_journal((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_get_wmajority (a_concern: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_write_concern_get_wmajority((const mongoc_write_concern_t *)$a_concern);"
		end

	c_mongoc_write_concern_set_w (a_concern: POINTER; a_w: INTEGER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_write_concern_set_w((mongoc_write_concern_t *)$a_concern, $a_w);"
		end

	c_mongoc_write_concern_set_wtimeout_int64 (a_concern: POINTER; a_wtimeout: INTEGER_64)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_write_concern_set_wtimeout_int64((mongoc_write_concern_t *)$a_concern, $a_wtimeout);"
		end

	c_mongoc_write_concern_set_wmajority (a_concern: POINTER; a_wtimeout_msec: INTEGER_64)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_write_concern_set_wmajority((mongoc_write_concern_t *)$a_concern, $a_wtimeout_msec);"
		end

	c_mongoc_write_concern_set_wtag (a_concern: POINTER; a_tag: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_write_concern_set_wtag((mongoc_write_concern_t *)$a_concern, (const char *)$a_tag);"
		end

	c_mongoc_write_concern_set_journal (a_concern: POINTER; a_journal: BOOLEAN)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_write_concern_set_journal((mongoc_write_concern_t *)$a_concern, $a_journal);"
		end

    c_mongoc_write_concern_append (a_write_concern: POINTER; a_command: POINTER): BOOLEAN
            -- Append write concern to command options
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_write_concern_append((mongoc_write_concern_t *)$a_write_concern, (bson_t *)$a_command);"
        end

feature -- MongoDB Indexes

    c_mongoc_index_model_new (keys: POINTER; opts: POINTER): POINTER
            -- Create a new index model
            -- Parameters:
            --   keys: const bson_t* - document containing fields and order for the index
            --   opts: const bson_t* - optional index options
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_index_model_new(
                    (const bson_t *)$keys,
                    (const bson_t *)$opts
                );
            ]"
        end

    c_mongoc_index_model_destroy (model: POINTER)
            -- Destroy an index model
            -- Parameters:
            --   model: mongoc_index_model_t* - the index model to destroy
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_index_model_destroy((mongoc_index_model_t *)$model);"
        end

feature -- Bulk Operations

    c_mongoc_bulk_operation_destroy (bulk: POINTER)
            -- Destroy a bulk operation
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_destroy((mongoc_bulk_operation_t *)$bulk);
            ]"
        end

    c_mongoc_bulk_operation_execute (bulk: POINTER; reply: POINTER; error: POINTER): BOOLEAN
            -- Execute a bulk operation
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_execute(
                    (mongoc_bulk_operation_t *)$bulk,
                    (bson_t *)$reply,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_insert (bulk: POINTER; document: POINTER)
            -- Queue an insert operation
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_insert(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$document
                );
            ]"
        end

    c_mongoc_bulk_operation_remove (bulk: POINTER; selector: POINTER)
            -- Queue a remove operation in a bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match documents
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_remove(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector
                );
            ]"
        end

    c_mongoc_bulk_operation_get_server_id (bulk: POINTER): NATURAL_32
            -- Get the server id for a bulk operation
            -- Parameters:
            --   bulk: const mongoc_bulk_operation_t* - the bulk operation handle
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_get_server_id((const mongoc_bulk_operation_t *)$bulk);
            ]"
        end

    c_mongoc_bulk_operation_insert_with_opts (bulk: POINTER; document: POINTER; opts: POINTER; error: POINTER): BOOLEAN
            -- Queue an insert operation with options
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   document: const bson_t* - document to insert
            --   opts: const bson_t* - optional additional options
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_insert_with_opts(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$document,
                    (const bson_t *)$opts,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_remove_many_with_opts (bulk: POINTER; selector: POINTER; opts: POINTER; error: POINTER): BOOLEAN
            -- Queue a remove operation with options in a bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match documents
            --   opts: const bson_t* - optional additional options
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_remove_many_with_opts(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$opts,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_remove_one (bulk: POINTER; selector: POINTER)
            -- Queue a remove operation for a single document in a bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match document
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_remove_one(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector
                );
            ]"
        end

    c_mongoc_bulk_operation_remove_one_with_opts (bulk: POINTER; selector: POINTER; opts: POINTER; error: POINTER): BOOLEAN
            -- Queue a remove operation for a single document with options
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match document
            --   opts: const bson_t* - optional additional options
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_remove_one_with_opts(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$opts,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_replace_one (bulk: POINTER; selector: POINTER; document: POINTER; upsert: BOOLEAN)
            -- Queue a replace operation for a single document in a bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match document
            --   document: const bson_t* - the replacement document
            --   upsert: bool - whether to insert if document not found
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_replace_one(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$document,
                    (bool)$upsert
                );
            ]"
        end

    c_mongoc_bulk_operation_replace_one_with_opts (bulk: POINTER; selector: POINTER; document: POINTER; opts: POINTER; error: POINTER): BOOLEAN
            -- Queue a replace operation for a single document with options
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match document
            --   document: const bson_t* - the replacement document
            --   opts: const bson_t* - optional additional options
            --   error: bson_error_t* - optional error details
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_replace_one_with_opts(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$document,
                    (const bson_t *)$opts,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_set_bypass_document_validation (bulk: POINTER; bypass: BOOLEAN)
            -- Set whether to bypass document validation for this bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   bypass: bool - whether to bypass document validation
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_set_bypass_document_validation(
                    (mongoc_bulk_operation_t *)$bulk,
                    (bool)$bypass
                );
            ]"
        end

    c_mongoc_bulk_operation_set_client_session (bulk: POINTER; client_session: POINTER)
            -- Set an explicit client session to use for the bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   client_session: mongoc_client_session_t* - the client session to use
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_set_client_session(
                    (mongoc_bulk_operation_t *)$bulk,
                    (mongoc_client_session_t *)$client_session
                );
            ]"
        end

    c_mongoc_bulk_operation_set_comment (bulk: POINTER; comment: POINTER)
            -- Set a comment to associate with this bulk write operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   comment: const bson_value_t* - the comment value to set
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_set_comment(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_value_t *)$comment
                );
            ]"
        end

    c_mongoc_bulk_operation_set_server_id (bulk: POINTER; server_id: NATURAL_32)
            -- Set the server id for this bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   server_id: uint32_t - the server id to use
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_set_server_id(
                    (mongoc_bulk_operation_t *)$bulk,
                    (uint32_t)$server_id
                );
            ]"
        end

    c_mongoc_bulk_operation_set_let (bulk: POINTER; let: POINTER)
            -- Define constants that can be accessed by all operations in this bulk
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   let: const bson_t* - BSON document containing constant definitions
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_set_let(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$let
                );
            ]"
        end

    c_mongoc_bulk_operation_update (bulk: POINTER; selector: POINTER; document: POINTER; upsert: BOOLEAN)
            -- Queue an update operation in a bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match documents
            --   document: const bson_t* - document containing the update operations
            --   upsert: bool - whether to insert if document not found
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_update(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$document,
                    (bool)$upsert
                );
            ]"
        end

    c_mongoc_bulk_operation_update_many_with_opts (bulk: POINTER; selector: POINTER; document: POINTER; opts: POINTER; error: POINTER): BOOLEAN
            -- Queue an update operation to update multiple documents with options
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match documents
            --   document: const bson_t* - document containing the update operations
            --   opts: const bson_t* - optional additional options
            --   error: bson_error_t* - error information
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_update_many_with_opts(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$document,
                    (const bson_t *)$opts,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_update_one (bulk: POINTER; selector: POINTER; document: POINTER; upsert: BOOLEAN)
            -- Queue an update operation for a single document in a bulk operation
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match document
            --   document: const bson_t* - document containing the update operations
            --   upsert: bool - whether to insert if document not found
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                mongoc_bulk_operation_update_one(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$document,
                    (bool)$upsert
                );
            ]"
        end

    c_mongoc_bulk_operation_update_one_with_opts (bulk: POINTER; selector: POINTER; document: POINTER; opts: POINTER; error: POINTER): BOOLEAN
            -- Queue an update operation for a single document with options
            -- Parameters:
            --   bulk: mongoc_bulk_operation_t* - the bulk operation handle
            --   selector: const bson_t* - document describing the query to match document
            --   document: const bson_t* - document containing the update operations
            --   opts: const bson_t* - optional additional options
            --   error: bson_error_t* - error information
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_update_one_with_opts(
                    (mongoc_bulk_operation_t *)$bulk,
                    (const bson_t *)$selector,
                    (const bson_t *)$document,
                    (const bson_t *)$opts,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_bulk_operation_get_write_concern (bulk: POINTER): POINTER
            -- Get the write concern for a bulk operation
            -- Parameters:
            --   bulk: const mongoc_bulk_operation_t* - the bulk operation handle
            -- Returns: const mongoc_write_concern_t* - the write concern
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_bulk_operation_get_write_concern(
                    (const mongoc_bulk_operation_t *)$bulk
                );
            ]"
        end

    c_mongoc_client_read_write_command_with_opts (a_client: POINTER; a_db_name: POINTER; a_command: POINTER;
            a_read_prefs: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
            -- Execute a command on the server, applying logic for commands that both read and write
            -- Note: The read_prefs parameter is ignored (included by mistake in libmongoc 1.5)
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_client_read_write_command_with_opts(
                    (mongoc_client_t *)$a_client,
                    (const char *)$a_db_name,
                    (const bson_t *)$a_command,
                    (const mongoc_read_prefs_t *)$a_read_prefs,
                    (const bson_t *)$a_opts,
                    (bson_t *)$a_reply,
                    (bson_error_t *)$a_error
                );
            ]"
        end

feature -- Server API

    c_mongoc_server_api_new (a_version: INTEGER): POINTER
            -- Create a new server API instance.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_server_api_new((mongoc_server_api_version_t)$a_version);"
        end

    c_mongoc_server_api_destroy (a_api: POINTER)
            -- Destroy a server API instance.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_server_api_destroy((mongoc_server_api_t *)$a_api);"
        end

    c_mongoc_server_api_get_version (a_api: POINTER): INTEGER
            -- Get the version set on this server API.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return (EIF_INTEGER)mongoc_server_api_get_version((const mongoc_server_api_t *)$a_api);"
        end

    c_mongoc_server_api_get_strict (a_api: POINTER): BOOLEAN
            -- Get whether strict mode is enabled.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return (EIF_BOOLEAN)mongoc_server_api_get_strict((const mongoc_server_api_t *)$a_api);"
        end

    c_mongoc_server_api_get_deprecation_errors (a_api: POINTER): BOOLEAN
            -- Get whether deprecation errors are enabled.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return (EIF_BOOLEAN)mongoc_server_api_get_deprecation_errors((const mongoc_server_api_t *)$a_api);"
        end

    c_mongoc_server_api_strict (a_api: POINTER; a_strict: BOOLEAN)
            -- Set whether strict mode is enabled.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_server_api_strict((mongoc_server_api_t *)$a_api, (bool)$a_strict);"
        end

    c_mongoc_server_api_deprecation_errors (a_api: POINTER; a_deprecation_errors: BOOLEAN)
            -- Set whether deprecation errors are enabled.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_server_api_deprecation_errors((mongoc_server_api_t *)$a_api, (bool)$a_deprecation_errors);"
        end

feature -- GridFS Bucket

    c_mongoc_gridfs_bucket_new (database: POINTER; opts: POINTER; read_prefs: POINTER; error: POINTER): POINTER
            -- Create a new GridFS bucket instance
            -- Parameters:
            --   database: mongoc_database_t* - the database to create bucket in
            --   opts: const bson_t* - optional settings document or NULL
            --   read_prefs: const mongoc_read_prefs_t* - read preferences or NULL
            --   error: bson_error_t* - error information
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_gridfs_bucket_new(
                    (mongoc_database_t *)$database,
                    (const bson_t *)$opts,
                    (const mongoc_read_prefs_t *)$read_prefs,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_gridfs_bucket_upload_from_stream (bucket: POINTER; filename: POINTER; source: POINTER;
                                             opts: POINTER; file_id: POINTER; error: POINTER): BOOLEAN
            -- Upload contents from stream to GridFS
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_gridfs_bucket_upload_from_stream(
                    (mongoc_gridfs_bucket_t *)$bucket,
                    (const char *)$filename,
                    (mongoc_stream_t *)$source,
                    (const bson_t *)$opts,
                    (bson_value_t *)$file_id,
                    (bson_error_t *)$error
                );
            ]"
        end

    c_mongoc_gridfs_bucket_download_to_stream (bucket: POINTER; file_id: POINTER; destination: POINTER; error: POINTER): BOOLEAN
            -- Download a file from GridFS to the destination stream
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_gridfs_bucket_download_to_stream(
                    (mongoc_gridfs_bucket_t *)$bucket,
                    (const bson_value_t *)$file_id,
                    (mongoc_stream_t *)$destination,
                    (bson_error_t *)$error
                );
            ]"
        end

feature -- Stream

    c_mongoc_stream_get_base_stream (stream: POINTER): POINTER
            -- Get the underlying stream
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_stream_get_base_stream((mongoc_stream_t *)$stream);"
        end

    c_mongoc_stream_read (stream: POINTER; buffer: POINTER; length: INTEGER; min_bytes: INTEGER; timeout_msec: INTEGER): INTEGER
            -- Read from stream
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_stream_read((mongoc_stream_t *)$stream, $buffer, (size_t)$length, (size_t)$min_bytes, (int32_t)$timeout_msec);"
        end

    c_mongoc_stream_write (stream: POINTER; buffer: POINTER; length: INTEGER; timeout_msec: INTEGER): INTEGER
            -- Write to stream
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_stream_write((mongoc_stream_t *)$stream, $buffer, (size_t)$length, (int32_t)$timeout_msec);"
        end

    c_mongoc_stream_flush (stream: POINTER): INTEGER
            -- Flush stream buffers
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_stream_flush((mongoc_stream_t *)$stream);"
        end

    c_mongoc_stream_close (stream: POINTER): INTEGER
            -- Close stream
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_stream_close((mongoc_stream_t *)$stream);"
        end

--    c_mongoc_stream_cork (stream: POINTER): INTEGER
--            -- Cork stream
--        external
--            "C inline use <mongoc/mongoc.h>"
--        alias
--            "return mongoc_stream_cork((mongoc_stream_t *)$stream);"
--        end

--    c_mongoc_stream_uncork (stream: POINTER): INTEGER
--            -- Uncork stream
--        external
--            "C inline use <mongoc/mongoc.h>"
--        alias
--            "return mongoc_stream_uncork((mongoc_stream_t *)$stream);"
--        end

    c_mongoc_stream_should_retry (stream: POINTER): BOOLEAN
            -- Check if operation should be retried
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_stream_should_retry((mongoc_stream_t *)$stream);"
        end

    c_mongoc_stream_timed_out (stream: POINTER): BOOLEAN
            -- Check if operation timed out
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_stream_timed_out((mongoc_stream_t *)$stream);"
        end

feature -- Stream Buffered

    c_mongoc_stream_buffered_new (base_stream: POINTER; buffer_size: INTEGER): POINTER
            -- Create a new buffered stream that wraps the base stream with specified buffer size
            -- Parameters:
            --   base_stream: mongoc_stream_t* - the base stream to buffer
            --   buffer_size: size_t - initial buffer size in bytes
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_stream_buffered_new((mongoc_stream_t *)$base_stream, (size_t)$buffer_size);"
        end

feature -- Stream File

    c_mongoc_stream_file_new (fd: INTEGER): POINTER
            -- Create a new file stream from a file descriptor
            -- Parameters:
            --   fd: int - file descriptor
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_stream_file_new((int)$fd);"
        end

    c_mongoc_stream_file_new_for_path (path: POINTER; flags: INTEGER; mode: INTEGER): POINTER
            -- Create a new file stream from a file path
            -- Parameters:
            --   path: const char* - file path
            --   flags: Flags to be passed to open().
            --   mode:  An optional mode to be passed to open() when creating a file.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_stream_file_new_for_path((const char *)$path, (int)$flags,(int)$mode);"
        end

    c_mongoc_stream_file_get_fd (stream: POINTER): INTEGER
            -- Get the file descriptor from a file stream
            -- Parameters:
            --   stream: mongoc_stream_file_t* - the file stream
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_stream_file_get_fd((mongoc_stream_file_t *)$stream);"
        end

feature -- Stream Socket

    c_mongoc_stream_socket_new (socket: POINTER): POINTER
            -- Create a new socket stream from a socket
            -- Parameters:
            --   socket: mongoc_socket_t* - the socket to wrap
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_stream_socket_new((mongoc_socket_t *)$socket);"
        end

    c_mongoc_stream_socket_get_socket (stream: POINTER): POINTER
            -- Get the underlying socket from a socket stream
            -- Parameters:
            --   stream: mongoc_stream_socket_t* - the socket stream
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_stream_socket_get_socket((mongoc_stream_socket_t *)$stream);"
        end

feature -- Socket

    c_mongoc_socket_new (domain, type, protocol: INTEGER): POINTER
            -- Create a new socket instance
            -- Parameters:
            --   domain: The socket domain (e.g., AF_INET, AF_INET6)
            --   type: The socket type (e.g., SOCK_STREAM)
            --   protocol: The socket protocol (usually 0)
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_socket_new((int)$domain, (int)$type, (int)$protocol);"
        end

    c_mongoc_socket_accept (socket: POINTER; expire_at: INTEGER_64): POINTER
            -- Accept a new client connection
            -- Parameters:
            --   socket: mongoc_socket_t* - the socket to accept connections on
            --   expire_at: int64_t - when to timeout the operation (monotonic clock, msec)
            -- Returns: A newly allocated mongoc_socket_t if successful; otherwise NULL.
            -- Note: expire_at is a timeout in milliseconds, use -1 for no timeout
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_socket_accept((mongoc_socket_t *)$socket, (int64_t)$expire_at);"
        end

    c_mongoc_socket_bind (socket: POINTER; addr: POINTER; addrlen: INTEGER): BOOLEAN
            -- Bind the socket to an address
            -- Parameters:
            --   socket: mongoc_socket_t* - the socket to bind
            --   addr: const struct sockaddr* - the address to bind to
            --   addrlen: mongoc_socklen_t - the length of the address structure
            -- Returns: TRUE if successful; otherwise FALSE and errno is set
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_socket_bind((mongoc_socket_t *)$socket, (const struct sockaddr *)$addr, (mongoc_socklen_t)$addrlen);"
        end

    c_mongoc_socket_connect (socket: POINTER; addr: POINTER; addrlen: INTEGER; expire_at: INTEGER_64): BOOLEAN
            -- Connect to a remote host
            -- Parameters:
            --   socket: mongoc_socket_t* - the socket to connect
            --   addr: const struct sockaddr* - the address to connect to
            --   addrlen: mongoc_socklen_t - the length of the address structure
            --   expire_at: int64_t - absolute timeout in milliseconds (monotonic clock)
            -- Returns: TRUE if successful; otherwise FALSE and errno is set
            -- Note: expire_at is an absolute timeout, add your desired timeout to current monotonic clock time
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_socket_connect(
                    (mongoc_socket_t *)$socket,
                    (const struct sockaddr *)$addr,
                    (mongoc_socklen_t)$addrlen,
                    (int64_t)$expire_at
                );
            ]"
        end

    c_mongoc_socket_destroy (socket: POINTER)
            -- Destroy a socket
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_socket_destroy((mongoc_socket_t *)$socket);"
        end

    c_mongoc_socket_close (socket: POINTER)
            -- Close a socket
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_socket_close((mongoc_socket_t *)$socket);"
        end

    c_mongoc_socket_errno (socket: POINTER): INTEGER
            -- Get the last error code for a socket
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_socket_errno((mongoc_socket_t *)$socket);"
        end

    c_mongoc_socket_getsockname (socket: POINTER; addr: POINTER; addrlen: POINTER): INTEGER
            -- Get the address to which the socket is bound
            -- Parameters:
            --   socket: mongoc_socket_t* - the socket to query
            --   addr: struct sockaddr* - buffer to store the socket address
            --   addrlen: mongoc_socklen_t* - on input, the size of addr buffer; on output, the actual size used
            -- Returns: 0 on success, -1 on failure and errno is set
            -- Note: addrlen should contain the size of addr when calling this function
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_socket_getsockname((mongoc_socket_t *)$socket, (struct sockaddr *)$addr, (mongoc_socklen_t *)$addrlen);"
        end

    c_mongoc_socket_listen (socket: POINTER; backlog: INTEGER): BOOLEAN
            -- Listen for incoming connections
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_socket_listen((mongoc_socket_t *)$socket, (unsigned int)$backlog);"
        end

    c_mongoc_socket_recv (socket: POINTER; buf: POINTER; buflen: INTEGER; flags: INTEGER; expire_at: INTEGER_64): INTEGER
            -- Receive data from a socket
            -- Parameters:
            --   socket: mongoc_socket_t* - the socket to receive from
            --   buf: void* - buffer to read into
            --   buflen: size_t - number of bytes to receive
            --   flags: int - flags for recv()
            --   expire_at: int64_t - absolute timeout in microseconds (monotonic clock)
            -- Returns: number of bytes received on success, -1 on failure and errno is set
            -- Note: expire_at is an absolute timeout, add your desired timeout to current monotonic clock time
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "[
                return mongoc_socket_recv(
                    (mongoc_socket_t *)$socket,
                    (void *)$buf,
                    (size_t)$buflen,
                    (int)$flags,
                    (int64_t)$expire_at
                );
            ]"
        end

    c_mongoc_socket_send (socket: POINTER; buf: POINTER; size: INTEGER; timeout_msec: INTEGER): INTEGER
            -- Send data through a socket
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_socket_send((mongoc_socket_t *)$socket, (const void *)$buf, (size_t)$size, (int32_t)$timeout_msec);"
        end

    c_mongoc_socket_setsockopt (socket: POINTER; level: INTEGER; optname: INTEGER; optval: POINTER; optlen: INTEGER): BOOLEAN
            -- Set socket options
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_socket_setsockopt((mongoc_socket_t *)$socket, (int)$level, (int)$optname, (const void *)$optval, (mongoc_socklen_t)$optlen);"
        end


 feature -- Change Stream

    c_mongoc_change_stream_next (a_stream: POINTER; a_bson: POINTER): BOOLEAN
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_change_stream_next ((mongoc_change_stream_t *)$a_stream, (const bson_t **)$a_bson);"
        end

    c_mongoc_change_stream_get_resume_token (a_stream: POINTER): POINTER
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return (EIF_POINTER) mongoc_change_stream_get_resume_token ((mongoc_change_stream_t *)$a_stream);"
        end

    c_mongoc_change_stream_error_document (a_stream: POINTER; a_error: POINTER; a_error_doc: POINTER): BOOLEAN
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_change_stream_error_document ((mongoc_change_stream_t *)$a_stream, (bson_error_t *)$a_error, (const bson_t **)$a_error_doc);"
        end

end
