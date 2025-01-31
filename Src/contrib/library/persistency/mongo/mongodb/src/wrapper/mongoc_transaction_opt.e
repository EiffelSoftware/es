note
	description: "Summary description for {MONGOC_TRANSACTION_OPT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MONGOC_TRANSACTION_OPT

feature -- Transaction Options

    c_mongoc_transaction_opts_new: POINTER
            -- Create new transaction options.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_transaction_opts_new();"
        end

    c_mongoc_transaction_opts_get_read_concern (opts: POINTER): POINTER
            -- Get read concern from transaction options.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_transaction_opts_get_read_concern((mongoc_transaction_opt_t *)$opts);"
        end

    c_mongoc_transaction_opts_get_write_concern (opts: POINTER): POINTER
            -- Get write concern from transaction options.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_transaction_opts_get_write_concern((mongoc_transaction_opt_t *)$opts);"
        end

    c_mongoc_transaction_opts_get_read_prefs (opts: POINTER): POINTER
            -- Get read preferences from transaction options.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_transaction_opts_get_read_prefs((mongoc_transaction_opt_t *)$opts);"
        end

    c_mongoc_transaction_opts_set_read_concern (opts: POINTER; read_concern: POINTER)
            -- Set read concern for transaction options.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_transaction_opts_set_read_concern((mongoc_transaction_opt_t *)$opts, (const mongoc_read_concern_t *)$read_concern);"
        end

    c_mongoc_transaction_opts_set_write_concern (opts: POINTER; write_concern: POINTER)
            -- Set write concern for transaction options.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_transaction_opts_set_write_concern((mongoc_transaction_opt_t *)$opts, (const mongoc_write_concern_t *)$write_concern);"
        end

    c_mongoc_transaction_opts_set_read_prefs (opts: POINTER; read_prefs: POINTER)
            -- Set read preferences for transaction options.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_transaction_opts_set_read_prefs((mongoc_transaction_opt_t *)$opts, (const mongoc_read_prefs_t *)$read_prefs);"
        end

    c_mongoc_transaction_opts_clone (opts: POINTER): POINTER
            -- Clone transaction options.
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_transaction_opts_clone((mongoc_transaction_opt_t *)$opts);"
        end

    c_mongoc_transaction_opts_get_max_commit_time_ms (opts: POINTER): INTEGER_64
            -- Get max commit time from transaction options (in milliseconds).
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return mongoc_transaction_opts_get_max_commit_time_ms((const mongoc_transaction_opt_t *)$opts);"
        end

    c_mongoc_transaction_opts_set_max_commit_time_ms (opts: POINTER; max_commit_time_ms: INTEGER_64)
            -- Set max commit time for transaction options (in milliseconds).
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_transaction_opts_set_max_commit_time_ms((mongoc_transaction_opt_t *)$opts, $max_commit_time_ms);"
        end

end
