note
	description: "[
			Object representing a mongoc_uri_t structure.
			It provides an abstraction on top of the MongoDB connection URI format. 
			It provides standardized parsing as well as convenience methods for extracting useful information such as replica hosts or authorization information.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_uri_t", "src=http://mongoc.org/libmongoc/current/mongoc_uri_t.html", "protocol=uri"

class
	MONGODB_URI

inherit

	MONGODB_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make, make_by_pointer

feature {NONE}-- Initialization

	make (a_uri: READABLE_STRING_GENERAL)
			-- Creates a new MongoClient using the URI string `a_uri' provided.
		do
			memory_make
			uri_new (a_uri)
		end

	uri_new (a_uri: READABLE_STRING_GENERAL)
		local
			c_string: C_STRING
			l_bson_error: BSON_ERROR
			l_ptr: POINTER
			l_error: BSON_ERROR
		do
			create l_error.make
			create c_string.make (a_uri)
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_uri_new_with_error (c_string.item, l_error.item)
			if l_ptr /= default_pointer then
				make_by_pointer (l_ptr)
			else
				create l_bson_error.make_by_pointer (l_error.item)
			end
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_mongoc_uri_destroy (item)
			end
		end

feature -- Access

	uri_string: READABLE_STRING_GENERAL
			-- String representation of current URI.
		note
			EIS: "name=mongoc_uri_get_string", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_string.html", "protocol=uri"
		local
			c_string: C_STRING
		do
			create c_string.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_uri_get_string (item))
			Result := c_string.string
		end

feature -- Operations

	uri_copy: MONGODB_URI
			-- Copies the entire contents of the current URI.
		note
			EIS: "name=mongo_uri_copy", "src=http://mongoc.org/libmongoc/current/mongoc_uri_copy.html", "protocol=uri"
		do
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_uri_copy (item))
		end

feature {NONE} -- Measurement

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

	struct_size: INTEGER
		external
			"C inline use<mongoc/mongoc.h>"
		alias
			"return sizeof(mongoc_uri_t *);"
		end

	c_mongoc_uri_destroy (a_uri: POINTER)
		external
			"C inline use<mongoc/mongoc.h>"
		alias
			"mongoc_uri_destroy ((mongoc_uri_t *)$a_uri);"
		end



end
