note
	description: "[
		Object representing a mongoc_collection_t structure.
		It provides access to a MongoDB collection. This handle is useful for actions for most CRUD operations, I.e. insert, update, delete, find, etc.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_collection_t", "src=http://mongoc.org/libmongoc/current/mongoc_collection_t.html", "protocol=uri"

class
	MONGODB_COLLECTION

inherit

	MONGODB_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make, make_by_pointer

feature {NONE} -- Initialization

	make
		do
			memory_make
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if not shared then
				if exists then
					c_mongoc_collection_destroy (item)
				else
					check exists: False end
				end
			end
		end

feature -- Access: Query

	find_with_opts (a_filter: BSON; a_opts: detachable BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCES): MONGODB_CURSOR
			-- 'a_filter': A bson_t containing the query to execute.
			-- 'a_opts:' An optional bson_t query options, including sort order and which fields to return
			-- 'a_read_prefs': An optional reading preferences.
			-- Return a mongo cursor.
		note
			EIS: "name=mongoc_collection_find_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_collection_find_with_opts.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_pointer: POINTER
			l_opts: POINTER
			l_read_prefs: POINTER
		do
			clean_up

			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end
			l_pointer := {MONGODB_EXTERNALS}.c_mongoc_collection_find_with_opts (item, a_filter.item, l_opts, l_read_prefs)
			create Result.make (l_pointer)
		end


	find_and_modify (query: BSON; sort: detachable BSON; update: BSON; fields: detachable BSON;
					 remove: BOOLEAN; upsert: BOOLEAN; new_doc: BOOLEAN; reply: BSON)
			-- Update and return an object.
			-- `query`: A bson_t containing the query to locate target document(s)
			-- `sort`: A bson_t containing the sort order for `query`
			-- `update`: A bson_t containing an update spec
			-- `fields`: An optional bson_t containing the fields to return or Void
			-- `remove`: If the matching documents should be removed
			-- `upsert`: If an upsert should be performed
			-- `new_doc`: If the new version of the document should be returned
			-- `reply`: A bson_t to contain the results
		note
			EIS: "name=mongoc_collection_find_and_modify", "src=http://mongoc.org/libmongoc/current/mongoc_collection_find_and_modify.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_sort: POINTER
			l_fields: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			if attached sort then
				l_sort := sort.item
			end
			if attached fields then
				l_fields := fields.item
			end

			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_find_and_modify (
				item,            -- collection
				query.item,      -- query
				l_sort,          -- sort
				update.item,     -- update
				l_fields,        -- fields
				remove,          -- remove
				upsert,          -- upsert
				new_doc,         -- new
				reply.item,      -- reply
				l_error.item     -- error
			)

			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end


    find_and_modify_with_opts (a_query: BSON;
                              a_opts: MONGODB_FIND_AND_MODIFY_OPTIONS;
                              a_reply: BSON)
            -- Update and return an object.
            -- Parameters:
            --   `a_query`: A BSON containing the query to locate target document(s)
            --   `a_opts`: Find and modify options
            --   `a_reply`: Location for the resulting document
            -- Note: If an unacknowledged write concern is set, the output reply
            -- is always an empty document. The reply contains the full server
            -- response to the findAndModify command on success.
        note
            EIS: "name=mongoc_collection_find_and_modify_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_collection_find_and_modify_with_opts.html", "protocol=uri"
        require
            is_useful: exists
        local
            l_error: BSON_ERROR
            l_res: BOOLEAN
        do
            clean_up
            create l_error.make

            l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_find_and_modify_with_opts (
                item,           -- collection
                a_query.item,   -- query
                a_opts.item,    -- opts
                a_reply.item,   -- reply
                l_error.item    -- error
            )

            if not l_res then
                set_last_error_with_bson (l_error)
            end
        end

	count_documents (a_filter: BSON; a_opts: detachable BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCES; a_reply: BSON): INTEGER_64
			-- Count documents matching `a_filter` with optional parameters `a_opts`.
			-- This is the recommended way to count documents (over the deprecated count).
		note
			EIS: "name=mongoc_collection_count_documents", "src=http://mongoc.org/libmongoc/current/mongoc_collection_count_documents.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_opts: POINTER
			l_prefs: POINTER

			l_error: BSON_ERROR
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_read_prefs then
			    l_prefs := a_read_prefs.item
			end
			create l_error.make
			Result := {MONGODB_EXTERNALS}.c_mongoc_collection_count_documents (item, a_filter.item, l_opts, l_prefs, a_reply.item, l_error.item)
			if Result < 0 then
				set_last_error_with_bson (l_error)
			end
		end

	estimated_document_count (a_opts: detachable BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCES; a_reply: BSON): INTEGER_64
			-- Get an estimate of the count of documents in the collection.
			-- This operation is faster than count_documents but less accurate.
		note
			EIS: "name=mongoc_collection_estimated_document_count", "src=http://mongoc.org/libmongoc/current/mongoc_collection_estimated_document_count.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_opts: POINTER
			l_prefs: POINTER
			l_error: BSON_ERROR
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_read_prefs then
				l_prefs := a_read_prefs.item
			end
			create l_error.make
			Result := {MONGODB_EXTERNALS}.c_mongoc_collection_estimated_document_count (item, l_opts, l_prefs, a_reply.item, l_error.item)
			if Result < 0 then
				set_last_error_with_bson (l_error)
			end
		end

feature -- Bulk Operations


    create_bulk_operation_with_opts (a_opts: detachable BSON): MONGODB_BULK_OPERATION
            -- Begin a new bulk operation.
            -- Parameters:
            --   `a_opts`: Optional BSON document that may contain:
            --     * writeConcern: Write concern for the operation
            --     * ordered: Set to false to attempt all inserts, continuing after errors
            --     * sessionId: Client session ID for transactions
            --     * let: Document with parameter definitions in MQL Aggregate Expression language
            --     * comment: Comment to attach to this command (MongoDB 4.4+)
            -- Returns: A new bulk operation that should be destroyed when no longer in use.
            -- Note: After creating this you may call various functions such as
            -- update, insert and others. The commands will be executed in batches
            -- when execute is called.
        note
            EIS: "name=mongoc_collection_create_bulk_operation_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_collection_create_bulk_operation_with_opts.html", "protocol=uri"
        require
            is_useful: exists
        local
            l_opts: POINTER
            l_ptr: POINTER
        do
            clean_up
            if attached a_opts then
                l_opts := a_opts.item
            end

            l_ptr := {MONGODB_EXTERNALS}.c_mongoc_collection_create_bulk_operation_with_opts (item, l_opts)
            check l_ptr_attached: not l_ptr.is_default_pointer end

            create Result.make_by_pointer (l_ptr)
        end

feature -- Command

	insert_one (a_document: BSON; a_opts: detachable BSON; a_reply: detachable BSON)
			-- This feature shall insert document `a_document' into collection.
			-- a_document: A BSON document
			-- a_opts: An optional BSON containing additional options.
			-- a_reply: Optional. An uninitialized bson_t populated with the insert result.
		note
			EIS: "name=mongoc_collection_insert_one", "src=http://mongoc.org/libmongoc/current/mongoc_collection_insert_one.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_insert_one (item, a_document.item, l_opts, l_reply, l_error.item)
			if l_res then
				-- do nothing
			else
				set_last_error_with_bson (l_error)
			end
		end

	insert_many (a_documents: LIST [BSON]; a_opts: detachable BSON; a_reply: detachable BSON)
			--documents: An array of pointers to bson_t.
			--opts may be NULL or a BSON document with additional command options:
			--reply: Optional. An uninitialized bson_t populated with the insert result, or NULL.
		note
			EIS: "name=mongoc_collection_insert_one", "src=http://mongoc.org/libmongoc/current/mongoc_collection_insert_many.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: BSON_ERROR
			l_pos: INTEGER
			l_item: MANAGED_POINTER
			l_res: BOOLEAN
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end

			create l_item.make (a_documents.count * 8)
			from
				a_documents.start
				l_pos := 0
			until
				a_documents.after
			loop
				l_item.put_pointer (a_documents.item.item, l_pos)
				a_documents.forth
				l_pos := l_pos + 8
			end

			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_insert_many (item, l_item.item, a_documents.count , l_opts, l_reply, l_error.item)
			if l_res then
				-- do nothing
			else
				set_last_error_with_bson (l_error)
			end
		end

	update_one (a_selector: BSON; a_update: BSON; a_opts: detachable BSON; a_reply: detachable BSON)
			-- a_selector: A bson_t containing the query to match the document for updating.
			-- a_update: A bson_t containing the update to perform.
			-- a_opts: An optional bson_t containing additional options
			-- a_reply: Optional. An uninitialized bson_t populated with the update result.
			-- This feature updates at most one document in collection that matches selector `a_selector'.
		note
			EIS: "name=mongoc_collection_update_one","src=http://mongoc.org/libmongoc/current/mongoc_collection_update_one.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_update_one (item, a_selector.item, a_update.item, l_opts, l_reply, l_error.item)
			if l_res then
				-- do nothing
			else
				set_last_error_with_bson (l_error)
			end
		end


	update_many (a_selector: BSON; a_update: BSON; a_opts: detachable BSON; a_reply: detachable BSON)
			-- Update all documents matching `a_selector`
		note
			EIS: "name=mongoc_collection_update_many", "src=http://mongoc.org/libmongoc/current/mongoc_collection_update_many.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_update_many (item, a_selector.item, a_update.item, l_opts, l_reply, l_error.item)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	delete_one (a_selector: BSON; a_opts: detachable BSON; a_reply: detachable BSON )
			-- a_selector: A bson_t containing the query to match documents.
			-- a_opts: An optional bson_t containing additional options.
			-- a_reply: Optional. An uninitialized bson_t populated with the delete result, or NULL.
			-- This feature removes at most one document in the given collection that matches selector `a_selector'.		
		note
			EIS: "name=mongoc_collection_delete_one","src=http://mongoc.org/libmongoc/current/mongoc_collection_delete_one.html","protocol=uri"
		require
			is_useful: exists
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_delete_one (item, a_selector.item, l_opts, l_reply, l_error.item)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	delete_many (a_selector: BSON; a_opts: detachable BSON; a_reply: detachable BSON)
			-- Delete all documents matching `a_selector`
			-- Parameters:
			--   a_selector: A bson_t containing the query to match documents
			--   a_opts: An optional bson_t containing additional options
			--   a_reply: Optional. An uninitialized bson_t populated with the delete result
		note
			EIS: "name=mongoc_collection_delete_many", "src=http://mongoc.org/libmongoc/current/mongoc_collection_delete_many.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_delete_many (
				item,            	-- collection
				a_selector.item, 	-- selector
				l_opts,         	-- opts
				l_reply,        	-- reply
				l_error.item    	-- error
			)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	command_simple (command: BSON; read_prefs: detachable MONGODB_READ_PREFERENCES; a_reply: BSON)
			-- Execute a command on the collection.
			-- `command`: A BSON containing the command to execute
			-- `read_prefs`: Optional read preferences
			-- `reply`: A BSON to contain the results (initialized even upon failure)
		note
			EIS: "name=mongoc_collection_command_simple", "src=http://mongoc.org/libmongoc/current/mongoc_collection_command_simple.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_error: BSON_ERROR
			l_read_prefs: POINTER
			l_res: BOOLEAN
		do
			clean_up

			create l_error.make
			if attached read_prefs then
				l_read_prefs := read_prefs.item
			end

			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_command_simple (
				item,           -- collection
				command.item,   -- command
				l_read_prefs,   -- read_prefs
				a_reply.item,     -- reply
				l_error.item    -- error
			)

			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

    command_with_opts (a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCES;
                      a_opts: detachable BSON; a_reply: BSON)
            -- Execute a command on the server, interpreting opts according to the MongoDB server version.
            -- Note: This is not considered a retryable read operation.
            -- Parameters:
            --   `a_command`: A BSON containing the command specification.
            --   `a_read_prefs`: Optional read preferences.
            --   `a_opts`: Optional BSON document that may contain:
            --     * readConcern: Read concern for the command
            --     * writeConcern: Write concern for the command
            --     * sessionId: Client session ID for transactions
            --     * collation: Text comparison options
            --     * serverId: To target a specific server
            --   `a_reply`: Location for the resulting document.
        note
            EIS: "name=mongoc_collection_command_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_collection_command_with_opts.html", "protocol=uri"
        require
            is_useful: exists
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
            l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_command_with_opts (
                item,           -- collection
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

    cl_copy: MONGODB_COLLECTION
            -- Create a deep copy of the collection and its configuration.
            -- Note: This copies the collection struct and its configuration,
            -- not the contents of the collection on the MongoDB server.
            -- Useful when you want to modify write concern, read preferences,
            -- or read concern while preserving an unaltered copy.
        note
            EIS: "name=mongoc_collection_copy", "src=http://mongoc.org/libmongoc/current/mongoc_collection_copy.html", "protocol=uri"
        require
            is_useful: exists
        local
            l_ptr: POINTER
        do
            clean_up
            l_ptr := {MONGODB_EXTERNALS}.c_mongoc_collection_copy (item)
            check l_ptr_attached: not l_ptr.is_default_pointer end
            create Result.make_by_pointer (l_ptr)
        end

feature -- Aggregation

	aggregate (a_pipeline: BSON; a_opts: detachable BSON; a_read_pref: detachable MONGODB_READ_PREFERENCES ): MONGODB_CURSOR
			-- Execute an aggregation framework pipeline using `a_pipeline`.
			-- Returns a cursor to the result set.
		note
			EIS: "name=mongoc_collection_aggregate","src=https://mongoc.org/libmongoc/current/mongoc_collection_aggregate.html","protocol=uri"
		require
			is_useful: exists
		local
			l_opts: POINTER
			l_flags: INTEGER
			l_read_prefs: POINTER
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_read_pref then
				l_read_prefs := a_read_pref.item
			end
			l_flags := (create {MONGODB_QUERY_FLAG}).mongoc_query_none
			create Result.make (
				{MONGODB_EXTERNALS}.c_mongoc_collection_aggregate (
					item,
					l_flags,
					a_pipeline.item,
					l_opts,
					l_read_prefs
				)
			)
		end

feature -- Indexes

	create_indexes_with_opts (a_models: LIST [MONGODB_INDEX_MODEL]; a_opts: detachable BSON; a_reply: detachable BSON)
			-- Create multiple indexes on the collection
			-- Parameters:
			--   a_models: List of index models defining the indexes to create
			--   a_opts: Optional additional options
			--   a_reply: Optional reply document
		note
			EIS: "name=mongoc_collection_create_indexes_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_collection_create_indexes_with_opts.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
			l_pos: INTEGER
			l_item: MANAGED_POINTER
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end

				-- Create a managed pointer to store array of model pointers
			create l_item.make (a_models.count * {PLATFORM}.pointer_bytes)

				-- Fill the array with model pointers
			from
				a_models.start
				l_pos := 0
			until
				a_models.after
			loop
				l_item.put_pointer (a_models.item.item, l_pos)
				a_models.forth
				l_pos := l_pos + {PLATFORM}.pointer_bytes
			end

			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_create_indexes_with_opts (
				item,                -- collection
				l_item.item,         -- models array
				a_models.count,      -- number of models
				l_opts,              -- opts
				l_reply,             -- reply
				l_error.item         -- error
			)

			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	drop_index (a_index_name: READABLE_STRING_GENERAL)
			-- Drop the index named `a_index_name` from the collection.
			-- If the operation fails, sets the error which can be checked with `has_error`.
		require
			is_useful: exists
			valid_index_name: not a_index_name.is_empty
		local
			l_error: BSON_ERROR
			l_c_string: C_STRING
			l_res: BOOLEAN
		do
			clean_up
			create l_c_string.make (a_index_name)
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_drop_index (
				item,               -- collection
				l_c_string.item,    -- index_name
				l_error.item        -- error
			)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	find_indexes_with_opts (a_opts: detachable BSON): MONGODB_CURSOR
			-- Fetch a cursor containing documents for each index in the collection.
			-- Each document describes an index, with fields:
			--   "v": index version
			--   "key": document containing index keys and their order
			--   "name": index name
			--   "ns": full namespace (databaseName.collectionName)
			-- Parameters:
			--   a_opts: Optional additional options for the operation
		note
			EIS: "name=mongoc_collection_find_indexes_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_collection_find_indexes_with_opts.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_opts: POINTER
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			create Result.make (
				{MONGODB_EXTERNALS}.c_mongoc_collection_find_indexes_with_opts (
					item,    -- collection
					l_opts   -- opts
				)
			)
		ensure
			result_not_void: Result /= Void
		end

feature -- Drop

    drop
            -- Drop the collection and all its indexes.
            -- Note: This is a potentially dangerous operation as it will remove all data
            -- from the collection.
        note
            EIS: "name=mongoc_collection_drop", "src=http://mongoc.org/libmongoc/current/mongoc_collection_drop.html", "protocol=uri"
        require
            is_useful: exists
        local
            l_error: BSON_ERROR
            l_res: BOOLEAN
        do
            clean_up
            create l_error.make
            l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_drop (item, l_error.item)
            if not l_res then
				set_last_error_with_bson (l_error)
            end
        end

	drop_with_opts	(a_opts: detachable BSON)
			-- Drop the current collection, including all indexes associated with the collection.
			-- If no write concern is provided in a_opts, the collection's write concern is used.
		note
			EIS: "name=mongoc_collection_drop_with_opts","src=http://mongoc.org/libmongoc/current/mongoc_collection_drop_with_opts.html","protocol=uri"
		require
			is_useful: exists
		local
			l_opts: POINTER
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			if attached a_opts then
				l_opts := l_opts.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_collection_drop_with_opts (item, l_opts, l_error.item)
			if not l_res then
				set_last_error_with_bson (l_error)
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
			"return sizeof(mongoc_collection_t *);"
		end

	c_mongoc_collection_destroy (a_collection: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_collection_destroy ((mongoc_collection_t *)$a_collection);"
		end



end
