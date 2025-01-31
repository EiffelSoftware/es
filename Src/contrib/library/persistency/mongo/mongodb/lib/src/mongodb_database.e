note
	description: "[
		Object Representing a MongoDB Database Abstraction
		mongoc_database_t provides access to a MongoDB database. 
		This handle is useful for actions a particular database object. It is not a container for mongoc_collection_t structures.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Mongo Database ", "src=http://mongoc.org/libmongoc/current/mongoc_database_t.html", "protocol=uri"

class
	MONGODB_DATABASE

inherit
	MONGODB_WRAPPER_BASE

create
	make_by_pointer

feature -- Access

	collection_names (a_opts: detachable BSON): LIST [STRING]
			-- This function queries current database and  return a list of strings containing the names of all of the collections in database.
			-- a_opts: A bson document containing additional options.
		note
			EIS: "name=mongoc_database_get_collection_names_with_opts  ", "src=http://mongoc.org/libmongoc/current/mongoc_database_get_collection_names_with_opts.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_error: BSON_ERROR
			l_ptr: POINTER
			i: INTEGER
			l_mgr: MANAGED_POINTER
			l_opts: POINTER
			l_res: INTEGER
			l_cstring: C_STRING
		do
			clean_up

			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			create l_res.default_create
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_database_get_collection_names_with_opts (item, l_opts, l_error.item)
			l_res := {MONGODB_EXTERNALS}.c_mongoc_database_get_collection_names_count (item, l_opts, l_error.item)
			create l_mgr.make_from_pointer (l_ptr, l_res* c_sizeof (l_ptr))
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

	collection (a_name: READABLE_STRING_GENERAL): MONGODB_COLLECTION
			-- If the collection `a_name' does not exist create a new one.
		note
			EIS: "name=", "src=http://mongoc.org/libmongoc/current/mongoc_database_get_collection.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_name: C_STRING
		do
			clean_up
			create l_name.make (a_name)
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_database_get_collection (item, l_name.item))
		end

	name: READABLE_STRING_8
			-- name of the database.
		note
			EIS: "name=mongoc_database_get_name", "src=http://mongoc.org/libmongoc/current/mongoc_database_get_name.html", "protocol=uri"
		require
			is_usable: exists
		local
			c_string: C_STRING
		do
			clean_up
			create c_string.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_database_get_name (item))
			Result := c_string.string
		end

	find_collections_with_opts (a_opts: detachable BSON): MONGODB_CURSOR
			-- Fetches a cursor containing documents, each corresponding to a collection in this database.
			-- Parameters:
			--   a_opts: Optional settings for the command. May include:
			--     * sessionId: for use within a session (requires prior mongoc_client_start_session)
			--     * serverId: to target a specific server
			-- Note: This is a retryable read operation.
			-- Note: The cursor functions set_limit, set_batch_size, and set_max_await_time_ms
			--       have no effect on the returned cursor.
		note
			eis: "name=mongoc_database_find_collections_with_opts", "src=https://mongoc.org/libmongoc/current/mongoc_database_find_collections_with_opts.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_opts: POINTER
			l_cursor: POINTER
		do
			clean_up

			if attached a_opts then
				l_opts := a_opts.item
			end

			l_cursor := {MONGODB_EXTERNALS}.c_mongoc_database_find_collections_with_opts (item, l_opts)
			create Result.make (l_cursor)
		end

	read_concern: MONGODB_READ_CONCERN
			-- Get the default read concern for this database
			-- Note: The returned read concern should not be modified or freed
		note
			eis: "name=mongoc_database_get_read_concern", "src=https://mongoc.org/libmongoc/current/mongoc_database_get_read_concern.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_database_get_read_concern (item))
		end

	read_prefs: MONGODB_READ_PREFERENCES
			-- Get the default read preferences for this database
			-- Note: The returned read preferences should not be modified or freed
		note
			eis: "name=mongoc_database_get_read_prefs", "src=https://mongoc.org/libmongoc/current/mongoc_database_get_read_prefs.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_database_get_read_prefs (item))
		end

	write_concern: MONGODB_WRITE_CONCERN
			-- Get the default write concern for this database
			-- Note: The returned write concern should not be modified or freed
		note
			eis: "name=mongoc_database_get_write_concern", "src=https://mongoc.org/libmongoc/current/mongoc_database_get_write_concern.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_database_get_write_concern (item))
		end

feature -- Change Element

    add_user (a_username: READABLE_STRING_GENERAL; a_password: READABLE_STRING_GENERAL; a_roles: detachable BSON; a_custom_data: detachable BSON)
            -- Create a new user with access to current database.
            -- Warning: Do not call this function without TLS.
            -- Parameters:
            --   a_username: The name of the user
            --   a_password: The cleartext password for the user
            --   a_roles: Optional roles as BSON document
            --   a_custom_data: Optional custom data as BSON document
            -- Note: On failure, has_error is true implies error /= Void.
        note
        	eis: "name=mongoc_database_add_user", "src=https://mongoc.org/libmongoc/current/mongoc_database_add_user.html", "protocol=uri"
        require
       		is_usable: exists
        local
            c_string_username: C_STRING
            c_string_password: C_STRING
            l_roles_ptr: POINTER
            l_custom_data_ptr: POINTER
            l_error: BSON_ERROR
            l_res: BOOLEAN
        do
        	clean_up
            create c_string_username.make (a_username)
            create c_string_password.make (a_password)

            if attached a_roles then
                l_roles_ptr := a_roles.item
            end

            if attached a_custom_data then
                l_custom_data_ptr := a_custom_data.item
            end

           	create l_error.make
            l_res := {MONGODB_EXTERNALS}.c_mongoc_database_add_user (item,
                                                c_string_username.item,
                                                c_string_password.item,
                                                l_roles_ptr,
                                                l_custom_data_ptr,
                                                l_error.item)
           if not l_res then
           		set_last_error_with_bson (l_error)
           end
       end

    remove_all_users
            -- Remove all users configured to access this database
            -- Note: This may fail if there are socket errors or the current user
            --       is not authorized to perform the given command
        note
            eis: "name=mongoc_database_remove_all_users", "src=https://mongoc.org/libmongoc/current/mongoc_database_remove_all_users.html", "protocol=uri"
        require
            is_usable: exists
        local
            l_error: BSON_ERROR
            l_success: BOOLEAN
        do
            clean_up
            create l_error.make
            l_success := {MONGODB_EXTERNALS}.c_mongoc_database_remove_all_users (item, l_error.item)

            if not l_success then
                set_last_error_with_bson (l_error)
            end
        end

    remove_user (a_username: READABLE_STRING_GENERAL)
            -- Remove the specified user from this database
            -- Note: This may fail if there are socket errors or the current user
            --       is not authorized to perform the command
        note
            eis: "name=mongoc_database_remove_user", "src=https://mongoc.org/libmongoc/current/mongoc_database_remove_user.html", "protocol=uri"
        require
            is_usable: exists
            username_not_empty: not a_username.is_empty
        local
            l_error: BSON_ERROR
            l_success: BOOLEAN
            l_c_username: C_STRING
        do
            clean_up
            create l_error.make
            create l_c_username.make (a_username)

            l_success := {MONGODB_EXTERNALS}.c_mongoc_database_remove_user (
                item, l_c_username.item, l_error.item)

            if not l_success then
                set_last_error_with_bson (l_error)
            end
        end


feature -- Drop

	drop_with_opts (a_opts: detachable BSON)
			-- Drop a current a database on the MongoDB server.
		note
			EIS: "name=mongoc_database_drop_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_database_drop_with_opts.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_error: BSON_ERROR
			l_opts: POINTER
			l_res: BOOLEAN
		do
			clean_up
			create l_error.make
			if attached a_opts then
				l_opts := a_opts.item
			end
			l_res := {MONGODB_EXTERNALS}.c_mongoc_database_drop_with_opts (item, l_opts, l_error.item)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

feature -- Status Report

	has_collection (a_name: READABLE_STRING_GENERAL): BOOLEAN
			-- Does collection `a_name' exist in the current database?
		note
			EIS: "name=mongoc_database_has_collection", "src=http://mongoc.org/libmongoc/current/mongoc_database_has_collection.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_error: BSON_ERROR
			l_name: C_STRING
		do
			clean_up

			create l_error.make
			create l_name.make (a_name)
			Result := {MONGODB_EXTERNALS}.c_mongoc_database_has_collection (item, l_name.item, l_error.item)
			if not Result then
				set_last_error_with_bson (l_error)
			end
		end


feature -- Settings

    set_read_concern (a_read_concern: MONGODB_READ_CONCERN)
            -- Set the read concern for this database.
            -- Note: Collections created after this call will inherit this read concern.
            -- Note: The default read concern is empty: no readConcern is sent to
            --       the server unless explicitly configured.
        note
            eis: "name=mongoc_database_set_read_concern", "src=https://mongoc.org/libmongoc/current/mongoc_database_set_read_concern.html", "protocol=uri"
        require
            is_usable: exists
        do
            clean_up
            {MONGODB_EXTERNALS}.c_mongoc_database_set_read_concern (item, a_read_concern.item)
        end

    set_write_concern (a_write_concern: MONGODB_WRITE_CONCERN)
            -- Set the write concern for this database.
            -- Note: Collections created after this call will inherit this write concern.
            -- Note: The default write concern is MONGOC_WRITE_CONCERN_W_DEFAULT: the driver
            --       blocks awaiting basic acknowledgement of write operations from MongoDB.
            --       This is the correct write concern for the great majority of applications.
        note
            eis: "name=mongoc_database_set_write_concern", "src=https://mongoc.org/libmongoc/current/mongoc_database_set_write_concern.html", "protocol=uri"
        require
            is_usable: exists
        do
            clean_up
            {MONGODB_EXTERNALS}.c_mongoc_database_set_write_concern (item, a_write_concern.item)
        end

feature -- Collection

    create_collection (a_name: READABLE_STRING_GENERAL; a_opts: detachable BSON): detachable MONGODB_COLLECTION
            -- Create a new collection in the database.
            -- Parameters:
            --   a_name: The name of the new collection
            --   a_opts: Optional settings for the create command
            -- Note: If no write concern is provided in opts, the database's write concern is used.
            -- Note: The encryptedFields document in opts may be used for Queryable Encryption.
        note
            eis: "name=mongoc_database_create_collection", "src=https://mongoc.org/libmongoc/current/mongoc_database_create_collection.html", "protocol=uri"
        require
            is_usable: exists
            name_not_empty: not a_name.is_empty
        local
            l_opts: POINTER
            l_error: BSON_ERROR
            l_collection: POINTER
            l_c_name: C_STRING
        do
            clean_up

            if attached a_opts then
                l_opts := a_opts.item
            end

            create l_c_name.make (a_name)
            create l_error.make

            l_collection := {MONGODB_EXTERNALS}.c_mongoc_database_create_collection (
                item,
                l_c_name.item,
                l_opts,
                l_error.item
            )

            if l_collection.is_default_pointer then
                set_last_error_with_bson (l_error)
            else
                create Result.make_by_pointer (l_collection)
            end
        end

feature -- Operations

    aggregate (a_pipeline: BSON; a_opts: detachable BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCES): MONGODB_CURSOR
            -- Execute an aggregation pipeline on the database.
            -- Parameters:
            --   a_pipeline: A BSON array or document containing an array field named "pipeline"
            --   a_opts: Optional BSON document with additional command options
            --   a_read_prefs: Optional read preferences
            -- Returns:
            --   A cursor to iterate over the aggregation results
            -- Note: The pipeline must start with a compatible stage that does not require
            -- an underlying collection (e.g. "$currentOp", "$listLocalSessions")
        note
            eis: "name=mongoc_database_aggregate", "src=https://mongoc.org/libmongoc/current/mongoc_database_aggregate.html", "protocol=uri"
        require
            is_usable: exists
        local
            l_opts: POINTER
            l_read_prefs: POINTER
            l_cursor: POINTER
        do
            clean_up

            if attached a_opts then
                l_opts := a_opts.item
            end

            if attached a_read_prefs then
                l_read_prefs := a_read_prefs.item
            end

            l_cursor := {MONGODB_EXTERNALS}.c_mongoc_database_aggregate (item,
                                                    a_pipeline.item,
                                                    l_opts,
                                                    l_read_prefs)

            create Result.make (l_cursor)
        end

    command_simple (a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCES; a_reply: BSON)
            -- Execute a command on the database with a simplified interface.
            -- Parameters:
            --   a_command: The command to execute
            --   a_read_prefs: Optional read preferences (uses MONGOC_READ_PRIMARY if Void)
            --   a_reply: Storage for the command's result document
            -- Note: This is not considered a retryable read operation.
            -- The database's read preference, read concern, and write concern are not applied.
        note
            eis: "name=mongoc_database_command_simple", "src=https://mongoc.org/libmongoc/current/mongoc_database_command_simple.html", "protocol=uri"
        require
            is_usable: exists
        local
            l_read_prefs: POINTER
            l_error: BSON_ERROR
            l_res: BOOLEAN
        do
            clean_up

            if attached a_read_prefs then
                l_read_prefs := a_read_prefs.item
            end

            create l_error.make
            l_res := {MONGODB_EXTERNALS}.c_mongoc_database_command_simple (item,
                                                    a_command.item,
                                                    l_read_prefs,
                                                    a_reply.item,
                                                    l_error.item)
            if not l_res then
                set_last_error_with_bson (l_error)
            end
        end

    command_with_opts (a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCES; a_opts: detachable BSON; a_reply: BSON)
            -- Execute a command on the server, interpreting opts according to MongoDB server version.
            -- Parameters:
            --   a_command: The command to execute
            --   a_read_prefs: Optional read preferences
            --   a_opts: Optional additional options
            --   a_reply: Storage for the command's result document
            -- Note: This is not considered a retryable read operation.
            -- Note: In a transaction, read concern and write concern are prohibited in opts
            --       and the read preference must be primary or NULL.
        note
            eis: "name=mongoc_database_command_with_opts", "src=https://mongoc.org/libmongoc/current/mongoc_database_command_with_opts.html", "protocol=uri"
        require
            is_usable: exists
        local
            l_read_prefs: POINTER
            l_opts: POINTER
            l_error: BSON_ERROR
            l_res: BOOLEAN
        do
            clean_up

            if attached a_read_prefs then
                l_read_prefs := a_read_prefs.item
            end

            if attached a_opts then
                l_opts := a_opts.item
            end

            create l_error.make
            l_res := {MONGODB_EXTERNALS}.c_mongoc_database_command_with_opts (item,
                                                    a_command.item,
                                                    l_read_prefs,
                                                    l_opts,
                                                    a_reply.item,
                                                    l_error.item)
            if not l_res then
                set_last_error_with_bson (l_error)
            end
        end

    read_command_with_opts (a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCES;
                          a_opts: detachable BSON; a_reply: BSON)
            -- Execute a command on the server, applying logic specific to read commands.
            -- Parameters:
            --   a_command: The command to execute
            --   a_read_prefs: Optional read preferences
            --   a_opts: Optional additional options. May include:
            --     * readConcern: Configure read concern
            --     * sessionId: For use within a session
            --     * collation: Configure textual comparisons
            --     * serverId: To target a specific server
            -- Note: This is a retryable read operation.
            -- Note: In a transaction, read concern is prohibited in opts
            --       and read preference must be primary or Void.
        note
            eis: "name=mongoc_database_read_command_with_opts", "src=https://mongoc.org/libmongoc/current/mongoc_database_read_command_with_opts.html", "protocol=uri"
        require
            is_usable: exists
        local
            l_error: BSON_ERROR
            l_read_prefs_ptr: POINTER
            l_opts_ptr: POINTER
            l_success: BOOLEAN
        do
            clean_up

            if attached a_read_prefs then
                l_read_prefs_ptr := a_read_prefs.item
            end
            if attached a_opts then
                l_opts_ptr := a_opts.item
            end


            create l_error.make
            l_success := {MONGODB_EXTERNALS}.c_mongoc_database_read_command_with_opts (
                item, a_command.item, l_read_prefs_ptr, l_opts_ptr, a_reply.item, l_error.item)

            if not l_success then
                set_last_error_with_bson (l_error)
            end
        end


   read_write_command_with_opts (a_command: BSON; a_opts: detachable BSON; a_reply: detachable BSON)
            -- Execute a command on the server, applying logic for commands that both read and write.
            -- Parameters:
            --   a_command: The command to execute
            --   a_opts: Optional additional options. May include:
            --     * readConcern: Configure read concern
            --     * writeConcern: Configure write concern
            --     * sessionId: For use within a session
            --     * collation: Configure textual comparisons
            --     * serverId: To target a specific server
            -- Note: In a transaction, read concern and write concern are prohibited in opts
            -- Note: The read preferences parameter is ignored in the underlying implementation
        note
            eis: "name=mongoc_database_read_write_command_with_opts", "src=https://mongoc.org/libmongoc/current/mongoc_database_read_write_command_with_opts.html", "protocol=uri"
        require
            is_usable: exists
        local
            l_reply: POINTER
            l_error: BSON_ERROR
            l_opts_ptr: POINTER
            l_success: BOOLEAN
        do
            clean_up

            if attached a_opts then
                l_opts_ptr := a_opts.item
            end

            if attached a_reply then
            	l_reply := a_reply.item
            end

            create l_error.make
            l_success := {MONGODB_EXTERNALS}.c_mongoc_database_read_write_command_with_opts (
                		               	item,				-- database
                		               	a_command.item,     -- command
                		               	default_pointer, 	-- read_prefs
                		               	l_opts_ptr, 		-- opts
                		               	l_reply.item,  		-- reply
                		               	l_error.item)		-- error

            if not l_success then
                set_last_error_with_bson (l_error)
            end
        end

    watch (a_pipeline: BSON; a_opts: detachable BSON): MONGODB_CHANGE_STREAM
            -- Create a change stream to watch for changes in this database.
            -- Parameters:
            --   a_pipeline: representing an aggregation pipeline appended to the change stream. This may be an empty document.
            --   a_opts: Optional settings, which may include:
            --     * batchSize: Number of documents per batch
            --     * resumeAfter: Resume token for continuing from a previous change stream
            --     * startAfter: Resume token that can follow an "invalidate" event
            --     * startAtOperationTime: Timestamp to start watching from
            --     * maxAwaitTimeMS: Max time to wait for new data
            --     * fullDocument: How to return modified documents
            --     * fullDocumentBeforeChange: How to return documents before changes
            --     * showExpandedEvents: Return expanded list of events (MongoDB 6.0+)
            -- Warning: Change streams require majority read concern
        note
            eis: "name=mongoc_database_watch", "src=https://mongoc.org/libmongoc/current/mongoc_database_watch.html", "protocol=uri"
        require
            is_usable: exists
        local
            l_opts: POINTER
        do
            clean_up
            if attached a_opts then
                l_opts := a_opts.item
            end
            create Result.make_by_pointer (
                {MONGODB_EXTERNALS}.c_mongoc_database_watch (item, a_pipeline.item, l_opts)
            )
        end


	write_command_with_opts (a_command: BSON; a_opts: detachable BSON; a_reply: detachable BSON)
            -- Execute a command on the server, applying logic specific to write commands.
            -- Parameters:
            --   a_command: The command to execute
            --   a_opts: Optional additional options. May include:
            --     * writeConcern: Configure write concern
            --     * sessionId: For use within a session
            --     * collation: Configure textual comparisons
            --     * serverId: To target a specific server
            -- Note: Do not use for basic write operations (insert, update, delete)
            -- Note: In a transaction, write concern is prohibited in opts
        note
            eis: "name=mongoc_database_write_command_with_opts", "src=https://mongoc.org/libmongoc/current/mongoc_database_write_command_with_opts.html", "protocol=uri"
        require
            is_usable: exists
        local
            l_reply: POINTER
            l_error: BSON_ERROR
            l_opts_ptr: POINTER
            l_success: BOOLEAN
        do
            clean_up

            if attached a_opts then
                l_opts_ptr := a_opts.item
            end

            if attached a_reply then
                l_reply := a_reply.item
            end

            create l_error.make
            l_success := {MONGODB_EXTERNALS}.c_mongoc_database_write_command_with_opts (
                                    item,               -- database
                                    a_command.item,     -- command
                                    l_opts_ptr,         -- opts
                                    l_reply,            -- reply
                                    l_error.item)       -- error

            if not l_success then
                set_last_error_with_bson (l_error)
            end
        end

feature -- Duplication

    db_copy: MONGODB_DATABASE
            -- Create a deep copy of current database instance.
            -- Note: Useful when you want to modify write concern, read preferences,
            --       or read concern while preserving an unaltered copy.
        note
            eis: "name=mongoc_database_copy", "src=https://mongoc.org/libmongoc/current/mongoc_database_copy.html", "protocol=uri"
        require
            is_usable: exists
        do
        	clean_up
            create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_database_copy (item))
        end

feature -- Removal

	dispose
		do
			if not shared then
				if exists then
					c_mongoc_database_destroy (item)
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
			"return sizeof(mongoc_database_t *);"
		end

	c_sizeof (ptr: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return sizeof ($ptr)"
		end

	c_mongoc_database_destroy (a_database: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_database_destroy ((mongoc_database_t *)$a_database);	"
		end


end
