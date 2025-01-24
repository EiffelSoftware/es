note
	description: "[
		Object representing a Client-side cursor abstraction.
		
		mongoc_cursor_t provides access to a MongoDB query cursor. It wraps up the wire protocol negotiation required to initiate a query and retrieve an unknown number of documents.

		Cursors are lazy, meaning that no network traffic occurs until the first call to mongoc_cursor_next().

		At that point we can:

		Determine which host we’ve connected to with mongoc_cursor_get_host().
		Retrieve more records with repeated calls to mongoc_cursor_next().
		Clone a query to repeat execution at a later point with mongoc_cursor_clone().
		Test for errors with mongoc_cursor_error().
		Thread Safety
		mongoc_cursor_t is NOT thread safe. It may only be used from the thread it was created from.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_cursor_t", "src=http://mongoc.org/libmongoc/current/mongoc_cursor_t.html", "protocol=uri"

class
	MONGODB_CURSOR

inherit

	MONGODB_WRAPPER_BASE
		rename
			make as make_default
		end

create
	make, make_default

feature -- Creation

	make (a_pointer: POINTER)

		do
			make_by_pointer (a_pointer)
		end

feature -- Iterator

	next: detachable BSON
			-- 'a_bson': A location for a bson_t.
			--| This function returns true if a valid bson document was read from the cursor. Otherwise, false if there was an error or the cursor was exhausted.
			--| Errors can be determined with the mongoc_cursor_error() function.		
		note
			EIS: "name=mongoc_cursor_next", "src=http://mongoc.org/libmongoc/current/mongoc_cursor_next.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_pointer: POINTER
		do
			clean_up
			if {MONGODB_EXTERNALS}.c_mongo_cursor_next (item, $l_pointer) then
				create Result.make_by_pointer (l_pointer)
			end
		end

feature -- Disponse

	dispose
			-- <Precursor>
		do
			if shared then
				c_mongoc_cursor_destroy (item)
			end
		end

feature -- Status Report

	cursor_error: detachable BSON_ERROR
			-- Check if an error has occurred while iterating the cursor.
			-- Returns: Void if no error has occurred, otherwise returns the error details.
		note
			EIS: "name=mongoc_cursor_error", "src=http://mongoc.org/libmongoc/current/mongoc_cursor_error.html", "protocol=uri"
		require
			is_usable: exists
		local
			l_error: BSON_ERROR
		do
			create l_error.make
			if {MONGODB_EXTERNALS}.c_mongoc_cursor_error (item, l_error.item) then
				Result := l_error
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
			"return sizeof(mongoc_cursor_t *);"
		end

	c_mongoc_cursor_destroy (a_cursor: POINTER)
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_cursor_destroy ((mongoc_cursor_t *)$a_cursor);;"
		end

end

