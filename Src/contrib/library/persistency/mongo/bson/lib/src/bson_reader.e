note
	description: "[
		Object representing the bson_reader_t structure.
		It is used for reading a sequence of BSON documents from a file or buffer.
		This is particularly useful when reading BSON documents that have been stored in a file sequentially.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_reader_t", "src=http://mongoc.org/libbson/current/bson_reader_t.html", "protocol=uri"

class
	BSON_READER

inherit
	BSON_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make_from_file,
	make_from_data

feature {NONE} -- Initialization

	make_from_file (a_filename: PATH)
			-- Initialize reader from file at `a_filename`.
		do
			create error.make
			make_by_pointer (bson_reader_new_from_file (a_filename, error))
		end

	make_from_data (a_data: MANAGED_POINTER)
			-- Initialize reader from `a_data` buffer.
		do
			create error.make
			make_by_pointer (bson_reader_new_from_data (a_data.item, a_data.count))
		end

	bson_reader_new_from_file (a_file_name: PATH; a_error: BSON_ERROR): POINTER
			-- Create new BSON reader from file.
		local
			l_filename: C_STRING
		do
			create l_filename.make (a_file_name.absolute_path.name)
			Result := c_bson_reader_new_from_file (l_filename.item, a_error.item)
		end

	bson_reader_new_from_data (a_data: POINTER; a_length: INTEGER): POINTER
			-- Create new BSON reader from data buffer.
		do
			Result := c_bson_reader_new_from_data (a_data, a_length)
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_bson_reader_destroy (item)
			end
		end

feature -- Operations

	read (a_bson: BSON): BOOLEAN
			-- Read next BSON document into `a_bson`.
			-- Returns True if successful, False if no more documents or error.
		local
			l_reached_eof: BOOLEAN
		do
			Result := c_bson_reader_read (item, $l_reached_eof) /= default_pointer
		end

	tell: INTEGER
			-- Get current position in underlying buffer.
		do
			Result := c_bson_reader_tell (item)
		end

feature -- Error

	error: BSON_ERROR
			-- Last error that occurred.

feature -- Measurement

	structure_size: INTEGER
		external
			"C inline use <bson/bson.h>"
		alias
			"return sizeof(bson_reader_t);"
		end

feature {NONE} -- C externals

	c_bson_reader_new_from_file (a_filename: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_reader_new_from_file ((const char *)$a_filename, (bson_error_t *)$a_error);"
		end

	c_bson_reader_new_from_data (a_data: POINTER; a_length: INTEGER): POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_reader_new_from_data ((const uint8_t *)$a_data, (size_t)$a_length);"
		end

	c_bson_reader_read (a_reader: POINTER; a_reached_eof: POINTER): POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_reader_read ((bson_reader_t *)$a_reader, (bool *)$a_reached_eof);"
		end

	c_bson_reader_tell (a_reader: POINTER): INTEGER
		external
			"C inline use <bson/bson.h>"
		alias
			"return (EIF_INTEGER) bson_reader_tell ((bson_reader_t *)$a_reader);"
		end

	c_bson_reader_destroy (a_reader: POINTER)
		external
			"C inline use <bson/bson.h>"
		alias
			"bson_reader_destroy ((bson_reader_t *)$a_reader);"
		end

end
