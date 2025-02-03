note
	description: "[
		Object representing a mongoc_host_list_t structure.
		A host list structure containing information about a MongoDB host.
	]"
	date: "$Date$"
	revision: "$Revision$"
	eis: "name=mongoc_host_list_t", "src=https://mongoc.org/libmongoc/current/mongoc_host_list_t.html", "protocol=uri"
class
	MONGODB_HOST_LIST

inherit
	MONGODB_WRAPPER_BASE
		redefine
			make
		end

create
	make,
	make_by_pointer

feature {NONE} -- Initialization

	make
			-- Initialize the structure.
		do
			Precursor
			set_family (0)
			set_port (0)
		end

feature -- Access

	next: detachable MONGODB_HOST_LIST
			-- Next host in the list
		local
			l_ptr: POINTER
		do
			l_ptr := c_next (item)
			if not l_ptr.is_default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	host: STRING_8
			-- Host name
		local
			c_str: C_STRING
		do
			create c_str.make_by_pointer (c_host (item))
			Result := c_str.string
		end

	host_and_port: STRING_8
			-- Host and port string
		local
			c_str: C_STRING
		do
			create c_str.make_by_pointer (c_host_and_port (item))
			Result := c_str.string
		end

	port: INTEGER_16
			-- Port number
		do
			Result := c_port (item)
		end

	family: INTEGER
			-- Address family
		do
			Result := c_family (item)
		end

feature -- Element Change

	set_host (a_host: STRING_8)
			-- Set host name
		require
			a_host_not_empty: not a_host.is_empty
			valid_host_length: a_host.count <= {MONGODB_EXTERNALS}.bson_host_name_max
		local
			c_str: C_STRING
		do
			create c_str.make (a_host)
			c_set_host (item, c_str.item)
		end

	set_host_and_port (a_host_and_port: STRING_8)
			-- Set host and port string
		require
			a_host_and_port_not_empty: not a_host_and_port.is_empty
			valid_host_and_port_length: a_host_and_port.count <= {MONGODB_EXTERNALS}.bson_host_name_max + 7
		local
			c_str: C_STRING
		do
			create c_str.make (a_host_and_port)
			c_set_host_and_port (item, c_str.item)
		end

	set_port (a_port: INTEGER_16)
			-- Set port number
		do
			c_set_port (item, a_port)
		end

	set_family (a_family: INTEGER)
			-- Set address family
		do
			c_set_family (item, a_family)
		end

feature -- Removal

	dispose
		do
			-- to be defined.
		end

feature  -- Measurement

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
			"return sizeof(mongoc_host_list_t);"
		end

	c_next (p: POINTER): POINTER
		external
			"C [struct <mongoc/mongoc.h>] (mongoc_host_list_t): mongoc_host_list_t *"
		alias
			"next"
		end

	c_host (p: POINTER): POINTER
		external
			"C [struct <mongoc/mongoc.h>] (mongoc_host_list_t): char *"
		alias
			"host"
		end

	c_host_and_port (p: POINTER): POINTER
		external
			"C [struct <mongoc/mongoc.h>] (mongoc_host_list_t): char *"
		alias
			"host_and_port"
		end

	c_port (p: POINTER): INTEGER_16
		external
			"C [struct <mongoc/mongoc.h>] (mongoc_host_list_t): uint16_t"
		alias
			"port"
		end

	c_family (p: POINTER): INTEGER
		external
			"C [struct <mongoc/mongoc.h>] (mongoc_host_list_t): int"
		alias
			"family"
		end

	c_set_host (p: POINTER; value: POINTER)
		external
			"C inline use <string.h>"
		alias
			"strncpy(((mongoc_host_list_t *)$p)->host, (char *)$value, BSON_HOST_NAME_MAX);"
		end

	c_set_host_and_port (p: POINTER; value: POINTER)
		external
			"C inline use <string.h>"
		alias
			"strncpy(((mongoc_host_list_t *)$p)->host_and_port, (char *)$value, BSON_HOST_NAME_MAX + 6);"
		end

	c_set_port (p: POINTER; value: INTEGER_16)
		external
			"C [struct <mongoc/mongoc.h>] (mongoc_host_list_t, uint16_t)"
		alias
			"port"
		end

	c_set_family (p: POINTER; value: INTEGER)
		external
			"C [struct <mongoc/mongoc.h>] (mongoc_host_list_t, int)"
		alias
			"family"
		end

end

