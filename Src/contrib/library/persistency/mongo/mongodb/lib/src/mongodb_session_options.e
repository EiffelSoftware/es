note
	description: "Object representing MongoDB Session Options."
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_session_opt_t", "src=http://mongoc.org/libmongoc/current/mongoc_session_opt_t.html", "protocol=uri	"

class
	MONGODB_SESSION_OPTIONS

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
			session_opts_new
		end

feature {NONE} -- Implementation

	session_opts_new
		note
			EIS: "name=mongoc_session_opts_new", "src=http://mongoc.org/libmongoc/current/mongoc_session_opts_new.html", "protocol=uri"
		do
			make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_session_opts_new)
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_mongoc_session_opts_destroy (item)
			end
		end
feature -- Access

	default_transaction_opts: MONGODB_TRANSACTION_OPTIONS
			-- Get the default options for transactions started with this session.
			-- Note: The returned transaction options are valid only for the lifetime of the session options.
		note
			eis: "name=mongoc_session_opts_get_default_transaction_opts", "src=http://mongoc.org/libmongoc/current/mongoc_session_opts_get_default_transaction_opts.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_session_opts_get_default_transaction_opts (item))
		end

	transaction_opts: detachable MONGODB_TRANSACTION_OPTIONS
			-- Get the options for the current transaction started with this session.
			-- Returns Void if this session is not in a transaction.
			-- Note: The returned options must be destroyed when no longer needed.
		note
			eis: "name=mongoc_session_opts_get_transaction_opts", "src=http://mongoc.org/libmongoc/current/mongoc_session_opts_get_transaction_opts.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_ptr: POINTER
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_session_opts_get_transaction_opts (item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

feature -- Settings

	set_causal_consistency (a_val: BOOLEAN)
			-- Configure causal consistency in a session.
			-- If true (the default), each operation in the session will be causally ordered after the previous read or write operation.
			-- Set to false to disable causal consistency.
		note
			EIS: "name=mongoc_session_opts_set_causal_consistency", "src=http://mongoc.org/libmongoc/current/mongoc_session_opts_set_causal_consistency.html","protocol=uri"
		require
			is_useful: exists
			not_snapshotp_read: a_val implies not is_configure_for_snapshot_reads
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_session_opts_set_causal_consistency (item, a_val)
		end

	options_clone: MONGODB_SESSION_OPTIONS
			-- Create a copy of a session options.
		note
			EIS: "name=mongoc_session_opts_clone", "src=http://mongoc.org/libmongoc/current/mongoc_session_opts_clone.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_session_opts_clone (item))
		end

	set_default_transaction_opts (txn_opts: MONGODB_TRANSACTION_OPTIONS)
			-- Set the default options for transactions started with this session.
			-- The transaction options are copied and can be freed after calling this function.
			-- Each field set in the transaction options overrides the inherited client configuration.
			-- These defaults can still be overridden by passing options to `start_transaction`.
		note
			eis: "name=mongoc_session_opts_set_default_transaction_opts", "src=http://mongoc.org/libmongoc/current/mongoc_session_opts_set_default_transaction_opts.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_session_opts_set_default_transaction_opts (item, txn_opts.item)
		end

	set_snapshots (a_snapshot: BOOLEAN)
			-- Configure snapshot reads for a session.
			-- If True (False by default), each read operation in the session will be sent
			-- with a "snapshot" level read concern. After the first read operation ("find",
			-- "aggregate" or "distinct"), subsequent read operations will read from the same
			-- point in time as the first read operation.
			-- Note:
			-- * Snapshot reads and causal consistency are mutually exclusive
			-- * Can only be used on MongoDB server version 5.0 and later
			-- * Cannot be used during a transaction
			-- * Write operations in a snapshot-enabled session will result in an error
		note
			eis: "name=mongoc_session_opts_set_snapshot", "src=http://mongoc.org/libmongoc/current/mongoc_session_opts_set_snapshot.html", "protocol=uri"
		require
			exists: exists
			not_causal_consistency: a_snapshot implies not is_causal_consistency
		do
			clean_up
			{MONGODB_EXTERNALS}.c_mongoc_session_opts_set_snapshot (item, a_snapshot)
		end

feature -- Status Report

	is_causal_consistency: BOOLEAN
			-- Is session configured for causal consistency (the default), else false.
		note
			EIS: "name=mongoc_session_opts_get_causal_consistency", "src=http://mongoc.org/libmongoc/current/mongoc_session_opts_get_causal_consistency.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			Result := {MONGODB_EXTERNALS}.c_mongoc_session_opts_get_causal_consistency (item)
		end

	is_configure_for_snapshot_reads: BOOLEAN
			-- Is this session configured for snapshot reads?
			-- Returns False by default.
		note
			eis: "name=mongoc_session_opts_get_snapshot", "src=http://mongoc.org/libmongoc/current/mongoc_session_opts_get_snapshot.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			Result := {MONGODB_EXTERNALS}.c_mongoc_session_opts_get_snapshot (item)
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
			"return sizeof(mongoc_session_opt_t *);"
		end

	c_mongoc_session_opts_destroy (a_opts: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_session_opts_destroy ((mongoc_session_opt_t *)$a_opts);"
		end


end
