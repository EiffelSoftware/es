note
	description: "[
			Options for starting a multi-document transaction.
			
			When a session is first created, it inherits from the client the read concern, 
			write concern, and read preference with which to start transactions. Each of 
			these fields can be overridden independently using the setter functions.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=MongoDB Transaction Options Documentation", "src=https://mongoc.org/libmongoc/current/mongoc_transaction_opt_t.html", "protocol=uri"

class
	MONGODB_TRANSACTION_OPTIONS

inherit
	MONGODB_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make, make_by_pointer

feature {NONE} -- Initialization

	make
			-- Creates a new transaction options object.
		do
			transaction_opts_new
		end

feature {NONE} -- Implementation

	transaction_opts_new
			-- Create new transaction options.
		note
			eis: "name=_mongoc_transaction_opts_new", "src=https://mongoc.org/libmongoc/current/mongoc_transaction_opts_new.html", "protocol=uri"
		do
			make_by_pointer ({MONGOC_TRANSACTION_OPT}.c_mongoc_transaction_opts_new)
		end

feature -- Access

	read_concern: MONGODB_READ_CONCERN
			-- Gets the read concern set on this transaction options.
		note
			eis: "name=mongoc_transaction_opts_get_read_concern", "src=https://mongoc.org/libmongoc/current/mongoc_transaction_opts_get_read_concern.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			create Result.make_by_pointer ({MONGOC_TRANSACTION_OPT}.c_mongoc_transaction_opts_get_read_concern (item))
		end

	write_concern: MONGODB_WRITE_CONCERN
			-- Gets the write concern set on this transaction options.
		note
			eis: "name=mongoc_transaction_opts_get_write_concern", "src=https://mongoc.org/libmongoc/current/mongoc_transaction_opts_get_write_concern.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			create Result.make_by_pointer ({MONGOC_TRANSACTION_OPT}.c_mongoc_transaction_opts_get_write_concern (item))
		end

	read_prefs: MONGODB_READ_PREFERENCES
			-- Gets the read preferences set on this transaction options.
		note
			eis: "name=mongoc_transaction_opts_get_read_prefs", "src=https://mongoc.org/libmongoc/current/mongoc_transaction_opts_get_read_prefs.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			create Result.make_by_pointer ({MONGOC_TRANSACTION_OPT}.c_mongoc_transaction_opts_get_read_prefs (item))
		end

	max_commit_time_ms: INTEGER_64
			-- Gets the transaction options' max commit time, in milliseconds.
		note
			eis: "name=mongoc_transaction_opts_get_max_commit_time_ms", "src=https://mongoc.org/libmongoc/current/mongoc_transaction_opts_get_max_commit_time_ms.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			Result := {MONGOC_TRANSACTION_OPT}.c_mongoc_transaction_opts_get_max_commit_time_ms (item)
		end

feature -- Settings

	set_read_concern (a_read_concern: MONGODB_READ_CONCERN)
			-- Set the read concern for this transaction options.
		note
			eis: "name=mongoc_transaction_opts_set_read_concer", "src=https://mongoc.org/libmongoc/current/mongoc_transaction_opts_set_read_concern.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			{MONGOC_TRANSACTION_OPT}.c_mongoc_transaction_opts_set_read_concern (item, a_read_concern.item)
		end

	set_write_concern (a_write_concern: MONGODB_WRITE_CONCERN)
			-- Set the write concern for this transaction options.
		note
			eis: "name=mongoc_transaction_opts_set_write_concern", "src=https://mongoc.org/libmongoc/current/mongoc_transaction_opts_set_write_concern.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			{MONGOC_TRANSACTION_OPT}.c_mongoc_transaction_opts_set_write_concern (item, a_write_concern.item)
		end

	set_read_prefs (a_read_prefs: MONGODB_READ_PREFERENCES)
			-- Set the read preferences for this transaction options.
		note
			eis: "name=mongoc_transaction_opts_set_read_prefs", "src=https://mongoc.org/libmongoc/current/mongoc_transaction_opts_set_read_prefs.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			{MONGOC_TRANSACTION_OPT}.c_mongoc_transaction_opts_set_read_prefs (item, a_read_prefs.item)
		end

	set_max_commit_time_ms (a_max_commit_time_ms: INTEGER_64)
			-- Sets the transaction options' max commit time in milliseconds.
			-- A non-zero value causes a transaction to be aborted if the commit
			-- operation takes longer than the specified value.
		note
			eis: "name=mongoc_transaction_opts_set_max_commit_time_ms", "src=https://mongoc.org/libmongoc/current/mongoc_transaction_opts_set_max_commit_time_ms.html", "protocol=uri"
		require
			is_usable: exists
			valid_time: a_max_commit_time_ms >= 0
		do
			clean_up
			{MONGOC_TRANSACTION_OPT}.c_mongoc_transaction_opts_set_max_commit_time_ms (item, a_max_commit_time_ms)
		end

feature -- Operations

	db_clone: MONGODB_TRANSACTION_OPTIONS
			-- Creates a copy of the current transaction options.
		note
			eis: "name=mongoc_transaction_opts_clone", "src=https://mongoc.org/libmongoc/current/mongoc_transaction_opts_clone.html", "protocol=uri"
		require
			is_usable: exists
		do
			clean_up
			create Result.make_by_pointer ({MONGOC_TRANSACTION_OPT}.c_mongoc_transaction_opts_clone (item))
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_mongoc_transaction_opts_destroy (item)
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
			"return sizeof(mongoc_transaction_opt_t *);"
		end

	c_mongoc_transaction_opts_destroy (a_opts: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_transaction_opts_destroy ((mongoc_transaction_opt_t *)$a_opts);"
		end

end
