note
	description: "[
		MongoDB client session for managing sequences of operations with optional causal consistency.
		
		Sessions are causally consistent by default and must be used by only one thread 
		at a time. Use within one minute of acquisition to avoid timeout.

		Note: Unacknowledged writes are not allowed with sessions.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=MongoDB Client Session Documentation", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_t.html", "protocol=uri"

class
	MONGODB_CLIENT_SESSION


inherit

	MONGODB_WRAPPER_BASE

create
	make_by_pointer

feature {NONE} -- Initialization


feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_mongoc_client_session_destroy (item)
			end
		end

feature -- Transaction Operations

	start_transaction (a_opts: detachable MONGODB_TRANSACTION_OPTIONS)
			-- Start a multi-document transaction for all following operations in this session.
			-- Any options provided in `opts` override options passed to session options default transaction opts,
			-- and options inherited from the MongoDB client.
			-- The transaction must be completed with `commit_transaction` or `abort_transaction`.
		note
			eis: "name=mongoc_client_session_start_transaction", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_start_transaction.html", "protocol=uri"
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
			l_res := c_mongoc_client_session_start_transaction (item, l_opts, l_error.item)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	commit_transaction (reply: detachable BSON)
			-- Commit a multi-document transaction.
			-- `reply`: Optional storage for the server's reply.

		note
			eis: "name=mongoc_client_session_commit_transaction", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_commit_transaction.html", "protocol=uri"
		require
			is_usable: exists
			transaction_in_progress: in_transaction -- Double check.
		local
			l_error: BSON_ERROR
			l_reply: POINTER
			l_res: BOOLEAN
		do
			clean_up
			create l_error.make
			if attached reply then
				l_reply := reply.item
			end
			l_res := c_mongoc_client_session_commit_transaction (item, l_reply, l_error.item)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

	abort_transaction
			-- Abort a multi-document transaction.
			-- Returns true if the transaction was aborted, false otherwise.
			-- Network or server errors are ignored.
		note
			eis: "name=mongoc_client_session_abort_transaction", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_abort_transaction.html", "protocol=uri"
		require
			is_usable: exists
			transaction_in_progress: in_transaction
		local
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			create l_error.make
			l_res := c_mongoc_client_session_abort_transaction (item, l_error.item)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

feature -- Status Report		

	in_transaction: BOOLEAN
			-- Check whether a multi-document transaction is in progress for this session.
			-- Returns True if a transaction was started and has not been committed or aborted.
		note
			eis: "name=mongoc_client_session_in_transaction", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_in_transaction.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			Result := c_mongoc_client_session_in_transaction (item)
		end

	get_transaction_state: MONGODB_TRANSACTION_STATE
			-- Get the current transaction state for this session.
		note
			eis: "name=mongoc_client_session_get_transaction_state", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_get_transaction_state.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			create Result.make
			Result.set_value (c_mongoc_client_session_get_transaction_state (item))
		end

	dirty: BOOLEAN
			-- Indicates whether session has been marked "dirty" as defined in the driver sessions specification.
			-- Note: This feature is intended for use by drivers that wrap libmongoc.
			-- It is not useful in client applications.
		note
			eis: "name=mongoc_client_session_get_dirty", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_get_dirty.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			Result := c_mongoc_client_session_get_dirty (item)
		end

feature -- Operations

	advance_cluster_time (a_cluster_time: BSON)
			-- Advance the cluster time for a session.
			-- Has an effect only if the new cluster time is greater than the session's current cluster time.
			-- Use this feature along with `advance_operation_time` to copy the operationTime and clusterTime
			-- from another session, ensuring subsequent operations in this session are causally consistent
			-- with the last operation in the other session.
		note
			eis: "name=mongoc_client_session_advance_cluster_time", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_advance_cluster_time.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			c_mongoc_client_session_advance_cluster_time (item, a_cluster_time.item)
		end

	advance_operation_time (a_timestamp: NATURAL_32; a_increment: NATURAL_32)
			-- Advance the session's operation time, expressed as a BSON Timestamp with timestamp and increment components.
			-- Has an effect only if the new operation time is greater than the session's current operation time.
			-- Use this feature along with `advance_cluster_time` to copy the operationTime and clusterTime
			-- from another session, ensuring subsequent operations in this session are causally consistent
			-- with the last operation in the other session.
		note
			eis: "name=mongoc_client_session_advance_operation_time", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_advance_operation_time.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			c_mongoc_client_session_advance_operation_time (item, a_timestamp, a_increment)
		end

	append (a_opts: BSON)
			-- Append a logical session id to command options.
			-- Use it to configure a session for any function that takes an options document.
			-- Note: It is an error to use a session for unacknowledged writes.
		note
			eis: "name=mongoc_client_session_append", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_append.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_error: BSON_ERROR
			l_res: BOOLEAN
		do
			clean_up
			create l_error.make
			l_res := c_mongoc_client_session_append (item, a_opts.item, l_error.item)
			if not l_res then
				set_last_error_with_bson (l_error)
			end
		end

feature -- Measurement

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

feature -- Access

	client: MONGODB_CLIENT
			-- Returns the MongoDB client from which this session was created.
			-- Note: The returned client should not be freed as it's managed by the session.
		note
			eis: "name=mongoc_client_session_get_client", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_get_client.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			create Result.make_by_pointer (c_mongoc_client_session_get_client (item))
		end

	cluster_time: detachable BSON
			-- Get the session's clusterTime as a BSON document.
			-- Returns Void if:
			-- * The session has not been used for any operation
			-- * advance_cluster_time has not been called
		note
			eis: "name=mongoc_client_session_get_cluster_time", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_get_cluster_time.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_ptr: POINTER
		do
			clean_up
			l_ptr := c_mongoc_client_session_get_cluster_time (item)
			if not l_ptr.is_default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	operation_time: TUPLE [timestamp: NATURAL_32; increment: NATURAL_32]
			-- Get the session's operationTime, expressed as a BSON Timestamp with timestamp and increment components.
			-- If the session has not been used for any operations, both components will be 0.
		note
			eis: "name=mongoc_client_session_get_operation_time", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_get_operation_time.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_timestamp, l_increment: NATURAL_32
		do
			clean_up
			l_timestamp := 0
			l_increment := 0
			c_mongoc_client_session_get_operation_time (item, $l_timestamp, $l_increment)

			create Result
			Result.put (l_timestamp, 1)
			Result.put (l_increment, 2)
		end

	options: MONGODB_SESSION_OPTIONS
			-- Get a reference to the session options with which this session was configured.
			-- Note: The returned options are valid only for the lifetime of the session.
		note
			eis: "name=mongoc_client_session_get_opts", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_get_opts.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			create Result.make_by_pointer (c_mongoc_client_session_get_opts (item))
		end

	logical_session_id: BSON
			-- Get the server-side "logical session ID" associated with this session as a BSON document.
			-- Note: The returned BSON document is valid only for the lifetime of the session.
		note
			eis: "name=mongoc_client_session_get_lsid", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_get_lsid.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			create Result.make_by_pointer (c_mongoc_client_session_get_lsid (item))
		end

	server_id: NATURAL_32
			-- Get the "server ID" of the mongos this session is pinned to.
			-- Returns 0 if this session is not pinned.
		note
			eis: "name=mongoc_client_session_get_server_id", "src=https://mongoc.org/libmongoc/current/mongoc_client_session_get_server_id.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			Result := c_mongoc_client_session_get_server_id (item)
		end


feature {NONE} -- Implementation

	struct_size: INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return sizeof(mongoc_client_session_t *);"
		end

	c_mongoc_client_session_destroy (a_session: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_client_session_destroy ((mongoc_client_session_t *)$a_session);	"
		end


feature {NONE} -- C externals

	c_mongoc_client_session_start_transaction (a_session: POINTER; a_opts: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_session_start_transaction ((mongoc_client_session_t *)$a_session, (const mongoc_transaction_opt_t *)$a_opts, (bson_error_t *)$a_error);"
		end

	c_mongoc_client_session_in_transaction (a_session: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_session_in_transaction ((const mongoc_client_session_t *)$a_session);"
		end

	c_mongoc_client_session_get_transaction_state (a_session: POINTER): INTEGER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_session_get_transaction_state ((const mongoc_client_session_t *)$a_session);"
		end

	c_mongoc_client_session_commit_transaction (a_session: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_session_commit_transaction ((mongoc_client_session_t *)$a_session, (bson_t *)$a_reply, (bson_error_t *)$a_error);"
		end

	c_mongoc_client_session_abort_transaction (a_session: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_session_abort_transaction ((mongoc_client_session_t *)$a_session, (bson_error_t *)$a_error);"
		end

	c_mongoc_client_session_advance_cluster_time (a_session: POINTER; a_cluster_time: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_client_session_advance_cluster_time ((mongoc_client_session_t *)$a_session, (const bson_t *)$a_cluster_time);"
		end

	c_mongoc_client_session_advance_operation_time (a_session: POINTER; a_timestamp: NATURAL_32; a_increment: NATURAL_32)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_client_session_advance_operation_time ((mongoc_client_session_t *)$a_session, (uint32_t)$a_timestamp, (uint32_t)$a_increment);"
		end

	c_mongoc_client_session_append (a_session: POINTER; a_opts: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_session_append ((const mongoc_client_session_t *)$a_session, (bson_t *)$a_opts, (bson_error_t *)$a_error);"
		end

	c_mongoc_client_session_get_client (a_session: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_session_get_client ((const mongoc_client_session_t *)$a_session);"
		end

	c_mongoc_client_session_get_cluster_time (a_session: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return (bson_t *)mongoc_client_session_get_cluster_time ((const mongoc_client_session_t *)$a_session);"
		end

	c_mongoc_client_session_get_dirty (a_session: POINTER): BOOLEAN
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_session_get_dirty ((const mongoc_client_session_t *)$a_session);"
		end

	c_mongoc_client_session_get_operation_time (a_session: POINTER; a_timestamp: POINTER; a_increment: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_client_session_get_operation_time ((const mongoc_client_session_t *)$a_session, (uint32_t *)$a_timestamp, (uint32_t *)$a_increment);"
		end

	c_mongoc_client_session_get_opts (a_session: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_session_get_opts ((const mongoc_client_session_t *)$a_session);"
		end

	c_mongoc_client_session_get_lsid (a_session: POINTER): POINTER
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_session_get_lsid ((mongoc_client_session_t *)$a_session);"
		end

	c_mongoc_client_session_get_server_id (a_session: POINTER): NATURAL_32
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"return mongoc_client_session_get_server_id ((const mongoc_client_session_t *)$a_session);"
		end

end
