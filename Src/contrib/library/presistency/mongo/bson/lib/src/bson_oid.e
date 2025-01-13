note
	description: "[
		Object representing the bson_oid_t structure.
		It contains the 12-byte ObjectId notation defined by the BSON ObjectID specification.
		ObjectId is a 12-byte BSON type, constructed using:
		a 4-byte value representing the seconds since the Unix epoch (in Big Endian)
		a 3-byte machine identifier
		a 2-byte process id (Big Endian), and
		a 3-byte counter (Big Endian), starting with a random value.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_oid_t", "src=http://mongoc.org/libbson/current/bson_oid_t.html", "protocol=uri"
class
	BSON_OID

inherit

	BSON_WRAPPER_BASE
		rename
			make as make_empty
		end

create
	make, make_empty, make_by_pointer, make_with_string

feature {NONE} -- Creation

	make (a_context: detachable BSON_CONTEXT)
		do
			make_empty
			bson_oid_init (a_context)
		end

	make_with_string (a_string: STRING)
		require
			a_string /= Void
		local
			c_str: C_STRING
		do
			create c_str.make (a_string)
			make_empty
				-- Keep a reference to `a_string'
			any_data := a_string
			c_bson_oid_init_from_string (item, c_str.item);
		end

feature -- Removal

	dispose
			-- <Precursor>
		do

		end

feature -- Access

	oid_to_string: STRING_32
		local
			l_string: C_STRING
		do
			create l_string.make_empty (25)
			c_bson_oid_to_string (item, l_string.item)
			Result := l_string.string
		end

	bson_oid_init (a_context: detachable BSON_CONTEXT)
			-- An optional bson_context_t `a_context'.
		local
			l_context: POINTER
		do
			if attached a_context then
				l_context := a_context.item
			end
			c_bson_oid_init (item, l_context)
		end

feature -- Delete

	delete
		do
			any_data := Void
		end

feature {NONE} -- Implementation

	c_bson_oid_init (a_oid: POINTER; a_context: POINTER)
		external
			"C inline use <bson/bson.h>"
		alias
			"bson_oid_init ((bson_oid_t *)$a_oid, (bson_context_t *)$a_context);"
		end

	c_bson_oid_init_from_string (a_oid: POINTER; a_str: POINTER)
		external
			"C inline use <bson/bson.h>"
		alias
			"bson_oid_init_from_string ((bson_oid_t *)$a_oid, (const char *)$a_str);"
		end

	c_bson_oid_to_string (a_oid: POINTER; a_str: POINTER)
		external
			"C inline use <bson/bson.h>"
		alias
			"[
				bson_oid_to_string ($a_oid, $a_str);
			]"
		end

	any_data: detachable ANY
			-- Reference to the data feed at creation time using `make_with_string'.

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

	struct_size: INTEGER
		external
			"C inline use <bson/bson.h>"
		alias
			"sizeof(bson_oid_t)"
		end




end
