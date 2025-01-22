note
	description: "[
		Object representing the bson_json_reader_t structure.
		It is used for reading a sequence of JSON documents and transforming them to bson_t documents.
		This can often be useful if you want to perform bulk operations that are defined in a file containing JSON documents.
		Tip: bson_json_reader_t works upon JSON documents formatted in MongoDB extended JSON format.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_json_reader_t", "src=http://mongoc.org/libbson/current/bson_json_reader_t.html", "protocol=uri"

class
	BSON_JSON_READER

inherit

	BSON_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make, make_from_data

feature {NONE} -- Initialization

	make (a_filename: PATH)
		do
			create error.make
			make_by_pointer (bson_json_reader_new_from_file (a_filename, error))
		end


	make_from_fd (a_fd: INTEGER; a_close_on_destroy: BOOLEAN)
			-- Create a new JSON reader from a file descriptor
		do
			create error.make
			make_by_pointer (c_bson_json_reader_new_from_fd (a_fd, a_close_on_destroy, error.item))
		end

	make_from_data (a_data: READABLE_STRING_GENERAL)
			-- Create a new JSON reader from a string data
		local
			l_data: C_STRING
		do
			create l_data.make (a_data)
			create error.make
			make_by_pointer (c_bson_json_data_reader_new (l_data.item, l_data.count, error.item))
		end

	bson_json_reader_new_from_file (a_file_name: PATH; a_error: BSON_ERROR): POINTER
		local
			l_filename: C_STRING
		do
			create l_filename.make (a_file_name.absolute_path.name)
			Result := c_bson_json_reader_new_from_file (l_filename.item, a_error.item)
		end


feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_bson_json_reader_destroy (item)
			end
		end

feature -- Operations

	bson_json_reader_read (a_bson: BSON)
		local
			l_res: INTEGER
		do
			from
				l_res := c_bson_json_reader_read (item, a_bson.item, error.item)
			until
				l_res = 0 or l_res= -1
			loop
				l_res := c_bson_json_reader_read (item, a_bson.item, error.item)
			end
		end

feature -- Error

	error: BSON_ERROR

feature -- Measurement

	structure_size: INTEGER
		external
			"C inline use <bson/bson.h>"
		alias
			"return sizeof(bson_t);"
		end

feature -- Error Codes

	BSON_JSON_ERROR_READ_CORRUPT_JS: INTEGER = 1
			-- JSON is corrupt or contains invalid characters

	BSON_JSON_ERROR_READ_INVALID_PARAM: INTEGER = 2
			-- Invalid parameter provided

	BSON_JSON_ERROR_READ_CB_FAILURE: INTEGER = 3
			-- Callback failure during reading

feature {NONE} -- c EXTERNALS


	c_bson_json_reader_new_from_file (a_filename: POINTER; a_error: POINTER): POINTER
			-- Create a new JSON reader from a file.
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_json_reader_new_from_file ((const char *)$a_filename, (bson_error_t *)$a_error);"
		end

	c_bson_json_reader_read (a_reader: POINTER; a_bson: POINTER; a_error: POINTER): INTEGER
			-- Read the next JSON document into a_bson.
			-- Returns:
			--   1 if successful and there are more documents
			--   0 if successful and there are no more documents
			--   -1 if there was an error
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_json_reader_read ((bson_json_reader_t *)$a_reader, (bson_t *)$a_bson, (bson_error_t *)$a_error); "
		end

	c_bson_json_reader_destroy (a_reader: POINTER)
			-- Destroy a JSON reader.
		external
			"C inline use <bson/bson.h>"
		alias
			"bson_json_reader_destroy ((bson_json_reader_t *)$a_reader);"
		end

	c_bson_json_reader_new_from_fd (a_fd: INTEGER; a_close_on_destroy: BOOLEAN; a_error: POINTER): POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_json_reader_new_from_fd ((int)$a_fd, (bool)$a_close_on_destroy, (bson_error_t *)$a_error);"
		end

	c_bson_json_data_reader_new (a_data: POINTER; a_len: INTEGER; a_error: POINTER): POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_json_data_reader_new ((const uint8_t *)$a_data, (size_t)$a_len, (bson_error_t *)$a_error);"
		end


end
