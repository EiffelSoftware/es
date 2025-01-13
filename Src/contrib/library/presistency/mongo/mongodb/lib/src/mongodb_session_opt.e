note
	description: "Object representing MongoDB Session Options."
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_session_opt_t", "src=http://mongoc.org/libmongoc/current/mongoc_session_opt_t.html", "protocol=uri	"

class
	MONGODB_SESSION_OPT

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
			session_opts_new
		end

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

	is_session_causal_consistency: BOOLEAN
			-- Is session configured for causal consistency (the default), else false.
		note
			EIS: "name=mongoc_session_opts_get_causal_consistency", "src=http://mongoc.org/libmongoc/current/mongoc_session_opts_get_causal_consistency.html", "protocol=uri"
		do
			Result := {MONGODB_EXTERNALS}.c_mongoc_session_opts_get_causal_consistency (item)
		end

feature -- Change Element

	set_session_causal_consistency (a_val: BOOLEAN)
			-- Configure causal consistency in a session.
			-- If true (the default), each operation in the session will be causally ordered after the previous read or write operation.
			-- Set to false to disable causal consistency.
		note
			EIS: "name=mongoc_session_opts_set_causal_consistency", "src=http://mongoc.org/libmongoc/current/mongoc_session_opts_set_causal_consistency.html","protocol=uri"
		do
			{MONGODB_EXTERNALS}.c_mongoc_session_opts_set_causal_consistency (item, a_val)
		end

	session_opts_clone: MONGODB_SESSION_OPT
			-- Create a copy of a session options.
		note
			EIS: "name=mongoc_session_opts_clone", "src=http://mongoc.org/libmongoc/current/mongoc_session_opts_clone.html", "protocol=uri"
		do
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_session_opts_clone (item))
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
