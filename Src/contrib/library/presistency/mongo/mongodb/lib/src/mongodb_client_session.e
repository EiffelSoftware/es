note
	description: "Summary description for {MONGODB_CLIENT_SESSION}."
	date: "$Date$"
	revision: "$Revision$"

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
			"return sizeof(mongoc_client_session_t *);"
		end

	c_mongoc_client_session_destroy (a_session: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_client_session_destroy ((mongoc_client_session_t *)$a_session);	"
		end

end
