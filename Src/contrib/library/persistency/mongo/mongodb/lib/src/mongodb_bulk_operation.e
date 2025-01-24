note
	description: "[
			Object representing a mongoc_bulk_operation_t structure.
			It provides an abstraction for submitting multiple write operations as a single batch.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_bulk_operation_t", "src=http://mongoc.org/libmongoc/current/mongoc_bulk_operation_t.html", "protocol=uri"

class
	MONGODB_BULK_OPERATION

inherit

	MONGODB_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make, make_by_pointer

feature {NONE} -- Initialization

	make
			-- Create a new bulk operation instance
		do
			memory_make
		end

feature -- Execute

	execute (a_reply: BSON): BOOLEAN
			-- Execute the bulk operation
			-- Returns True on success, False on error
			-- `a_reply`: Optional. An uninitialized bson_t populated with the operation result
		note
			EIS: "name=mongoc_bulk_operation_execute", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_execute.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_error: BSON_ERROR
		do
			clean_up
			create l_error.make
			Result := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_execute (item, a_reply.item, l_error.item)
			if not Result then
				set_last_error_with_bson (l_error)
			end
		end

feature -- Access

	server_id: NATURAL_32
			-- Get the server id associated with this bulk operation.
			-- Returns 0 if no server id has been assigned.
		note
			EIS: "name=mongoc_bulk_operation_get_server_id", "src=http://mongoc.org/libmongoc/current/mongoc_bulk_operation_get_server_id.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			Result := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_get_server_id (item)
		end

	write_concern: MONGODB_WRITE_CONCERN
			-- Get the write concern associated with this bulk operation.
		note
			EIS: "name=mongoc_bulk_operation_get_write_concern ", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_get_write_concern.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_item: POINTER
		do
			clean_up
			l_item := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_get_write_concern (item)
			create Result.make_by_pointer (l_item)
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_mongoc_bulk_operation_destroy (item)
			end
		end

feature -- Operations

	insert (a_document: BSON)
			-- Queue an insert operation
			-- `a_document`: A bson_t containing the document to insert
		note
			eis: "name=mongoc_bulk_operation_insert ", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_insert.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_bulk_operation_insert (item, a_document.item)
		end

	insert_with_opts (a_document: BSON; a_opts: detachable BSON)
			-- Queue an insert operation with options
			-- `a_document`: The document to insert
			-- `a_opts`: Optional additional options (may be Void)
			--        - validate: Construct a bitwise-or of all desired bson_validate_flags_t.
			--                    Set to false to skip client-side validation of the provided BSON documents.
			-- Returns True on success, False on error
			-- Note: The insert is not performed until execute() is called
		note
			eis: "name=mongoc_bulk_operation_insert ", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_insert_with_opts.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_error: BSON_ERROR
			l_opts: POINTER
			l_res: BOOLEAN
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_insert_with_opts (
						item, -- bulk operation
						a_document.item, -- document to insert
						l_opts, -- options
						l_error.item -- error info
					)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	remove (a_selector: BSON)
			-- Queue a remove operation to remove all documents matching the selector.
			-- Note: This only queues the operation. To execute it, call `execute`.
			-- `a_selector`: A BSON document containing the query to match documents for removal
		note
			eis: "name=mongoc_bulk_operation_remove", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_remove.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_bulk_operation_remove (
					item, -- bulk operation
					a_selector.item -- selector
				)
		end

	remove_many_with_opts (a_selector: BSON; a_opts: detachable BSON)
			-- Queue a remove operation to remove all documents matching the selector with additional options.
			-- `a_selector`: A BSON document containing the query to match documents for removal
			-- `a_opts`: Optional BSON document containing additional options:
			--          - collation: Configure textual comparisons
			--          - hint: Specify index to use for the query
			-- Returns: True on success, False on error
			-- Note: This only queues the operation. To execute it, call `execute`.
		note
			eis: "name=mongoc_bulk_operation_remove_many_with_opts ", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_remove_many_with_opts.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_error: BSON_ERROR
			l_opts: POINTER
			l_res: BOOLEAN
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_remove_many_with_opts (
						item, -- bulk operation
						a_selector.item, -- selector
						l_opts, -- options (may be null)
						l_error.item -- error info
					)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	remove_one (a_selector: BSON)
			-- Queue a remove operation to remove a single document matching the selector.
			-- Note: This only queues the operation. To execute it, call `execute`.
			-- `a_selector`: A BSON document containing the query to match document for removal
		note
			eis: "name=mongoc_bulk_operation_remove_one", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_remove_one.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_bulk_operation_remove_one (
					item, -- bulk operation
					a_selector.item -- selector
				)
		end

	remove_one_with_opts (a_selector: BSON; a_opts: detachable BSON)
			-- Queue a remove operation to remove a single document matching the selector with additional options.
			-- `a_selector`: A BSON document containing the query to match document for removal
			-- `a_opts`: Optional BSON document containing additional options:
			--          - collation: Configure textual comparisons
			--          - hint: Specify index to use for the query
			-- Returns: True on success, False on error
			-- Note: This only queues the operation. To execute it, call `execute`.
		note
			eis: "name=mongoc_bulk_operation_remove_one_with_opts", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_remove_one_with_opts.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_error: BSON_ERROR
			l_opts: POINTER
			l_res: BOOLEAN
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_remove_one_with_opts (
						item, -- bulk operation
						a_selector.item, -- selector
						l_opts, -- options
						l_error.item -- error info
					)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	replace_one (a_selector: BSON; a_document: BSON; a_upsert: BOOLEAN)
			-- Queue a replace operation to replace a single document matching the selector.
			-- Note: This only queues the operation. To execute it, call `execute`.
			-- `a_selector`: A BSON document containing the query to match document for replacement
			-- `a_document`: A BSON document containing the replacement document
			-- `a_upsert`: True if this should be an upsert (insert if not found)
		note
			eis: "name=mongoc_bulk_operation_replace_one", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_replace_one.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_bulk_operation_replace_one (
					item, -- bulk operation
					a_selector.item, -- selector
					a_document.item, -- replacement document
					a_upsert -- upsert flag
				)
		end

	replace_one_with_opts (a_selector: BSON; a_document: BSON; a_opts: detachable BSON)
			-- Queue a replace operation to replace a single document matching the selector with additional options.
			-- `a_selector`: A BSON document containing the query to match document for replacement
			-- `a_document`: A BSON document containing the replacement document
			-- `a_opts`: Optional BSON document containing additional options:
			--          - collation: Configure textual comparisons
			--          - hint: Specify index to use for the query
			--          - upsert: Whether to insert if document not found
			-- Returns: True on success, False on error
			-- Note: This only queues the operation. To execute it, call `execute`.
		note
			eis: "name=mongoc_bulk_operation_replace_one_with_opts", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_replace_one_with_opts.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_error: BSON_ERROR
			l_opts: POINTER
			l_res: BOOLEAN
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_replace_one_with_opts (
						item, -- bulk operation
						a_selector.item, -- selector
						a_document.item, -- replacement document
						l_opts, -- options
						l_error.item -- error info
					)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	update (a_selector: BSON; a_document: BSON; a_upsert: BOOLEAN)
			-- Queue an update operation to update all documents matching the selector.
			-- Note: This only queues the operation. To execute it, call `execute`.
			-- Note: This is superseded by `update_one_with_opts` and `update_many_with_opts`.
			-- `a_selector`: A BSON document containing the query to match documents for update
			-- `a_document`: A BSON document containing the update operations (must start with $)
			-- `a_upsert`: True if this should be an upsert (insert if not found)
		note
			eis: "name=mongoc_bulk_operation_update", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_update.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_bulk_operation_update (
					item, -- bulk operation
					a_selector.item, -- selector
					a_document.item, -- update document
					a_upsert -- upsert flag
				)
		end

	update_many_with_opts (a_selector: BSON; a_document: BSON; a_opts: detachable BSON)
			-- Queue an update operation to update all documents matching the selector with additional options.
			-- `a_selector`: A BSON document containing the query to match documents for update
			-- `a_document`: A BSON document containing the update operations (must start with $)
			-- `a_opts`: Optional BSON document containing additional options:
			--          - collation: Configure textual comparisons
			--          - hint: Specify index to use for the query
			--          - upsert: Whether to insert if document not found
			--          - arrayFilters: Filters for array updates
			-- Returns: True on success, False on error
			-- Note: This only queues the operation. To execute it, call `execute`.
		note
			eis: "name=mongoc_bulk_operation_update_many_with_opts", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_update_many_with_opts.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_error: BSON_ERROR
			l_opts: POINTER
			l_res: BOOLEAN
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_update_many_with_opts (
						item, -- bulk operation
						a_selector.item, -- selector
						a_document.item, -- update document
						l_opts, -- options
						l_error.item -- error info
					)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	update_one (a_selector: BSON; a_document: BSON; a_upsert: BOOLEAN)
			-- Queue an update operation to update a single document matching the selector.
			-- Note: This only queues the operation. To execute it, call `execute`.
			-- Note: This is superseded by `update_one_with_opts`.
			-- `a_selector`: A BSON document containing the query to match document for update
			-- `a_document`: A BSON document containing the update operations (must start with $)
			-- `a_upsert`: True if this should be an upsert (insert if not found)
		note
			eis: "name=mongoc_bulk_operation_update_one", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_update_one.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_bulk_operation_update_one (
					item, -- bulk operation
					a_selector.item, -- selector
					a_document.item, -- update document
					a_upsert -- upsert flag
				)
		end

	update_one_with_opts (a_selector: BSON; a_document: BSON; a_opts: detachable BSON)
			-- Queue an update operation to update a single document matching the selector with additional options.
			-- `a_selector`: A BSON document containing the query to match document for update
			-- `a_document`: A BSON document containing the update operations (must start with $)
			-- `a_opts`: Optional BSON document containing additional options:
			--          - collation: Configure textual comparisons
			--          - hint: Specify index to use for the query
			--          - upsert: Whether to insert if document not found
			--          - arrayFilters: Filters for array updates
			-- Returns: True on success, False on error
			-- Note: This only queues the operation. To execute it, call `execute`.
		note
			eis: "name=mongoc_bulk_operation_update_one_with_opts", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_update_one_with_opts.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_error: BSON_ERROR
			l_opts: POINTER
			l_res: BOOLEAN
		do
			clean_up
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			l_res := {MONGODB_EXTERNALS}.c_mongoc_bulk_operation_update_one_with_opts (
						item, -- bulk operation
						a_selector.item, -- selector
						a_document.item, -- update document
						l_opts, -- options
						l_error.item -- error info
					)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

feature -- Settings

	set_bypass_document_validation (bypass: BOOLEAN)
			-- Set whether to bypass document validation for this bulk operation.
			-- `bypass`: True to bypass document validation, False to enforce it
		note
			eis: "name=mongoc_bulk_operation_set_bypass_document_validation", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_set_bypass_document_validation.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_bulk_operation_set_bypass_document_validation (
					item, -- bulk operation
					bypass -- bypass flag
				)
		end

	set_client_session (a_session: MONGODB_CLIENT_SESSION)
			-- Sets an explicit client session to use for the bulk operation.
			-- Note: It is an error to use a session for unacknowledged writes.
			-- `a_session`: The client session to use for this bulk operation
		note
			eis: "name=mongoc_bulk_operation_set_client_session", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_set_client_session.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_bulk_operation_set_client_session (
					item, -- bulk operation
					a_session.item -- client session
				)
		end

	set_comment (a_comment: BSON_VALUE)
			-- Sets a comment to associate with this bulk write operation.
			-- The comment will appear in log files, profiler output, and command monitoring events.
			-- `a_comment`: The comment value to associate with this bulk operation
		note
			eis: "name=mongoc_bulk_operation_set_comment", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_set_comment.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_bulk_operation_set_comment (
					item, -- bulk operation
					a_comment.item -- comment value
				)
		end

	set_server_id (a_server_id: NATURAL_32)
			-- Specifies which server to use for the operation.
			-- Note: This function has an effect only if called before execute().
			-- Warning: Use this only for building a language driver that wraps the C Driver.
			-- When writing applications in C, leave the server id unset and allow the
			-- driver to choose a suitable server for the bulk operation.
			-- `a_server_id`: An opaque id identifying the server to use
		note
			eis: "name=mongoc_bulk_operation_set_server_id", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_set_server_id.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_bulk_operation_set_server_id (
					item, -- bulk operation
					a_server_id -- server id
				)
		end

	set_let (a_let: BSON)
			-- Defines constants that can be accessed by all update, replace, and delete
			-- operations executed as part of this bulk.
			-- `a_let`: A BSON document consisting of parameter names and their definitions
			-- in the MQL Aggregate Expression language.
		note
			eis: "name=mongoc_bulk_operation_set_let", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_set_let.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_bulk_operation_set_let (
					item, -- bulk operation
					a_let.item -- let definitions
				)
		end

feature {NONE} -- Implementation

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

	struct_size: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return sizeof(mongoc_bulk_operation_t *);"
		end

	c_mongoc_bulk_operation_destroy (a_bulk: POINTER)
		note
			eis: "name=mongoc_bulk_operation_destroy", "src=https://mongoc.org/libmongoc/current/mongoc_bulk_operation_destroy.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_bulk_operation_destroy((mongoc_bulk_operation_t *)$a_bulk);"
		end

end
