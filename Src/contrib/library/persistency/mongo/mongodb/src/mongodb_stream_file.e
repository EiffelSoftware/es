note
	description: "[
			Object representing a mongoc_stream_file_t structure.
			Provides file stream capabilities based on UNIX style file-descriptors.
			This is a specialized version of MONGODB_STREAM for working with files.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_stream_file_t", "src=https://mongoc.org/libmongoc/current/mongoc_stream_file_t.html", "protocol=uri"

class
	MONGODB_STREAM_FILE

inherit
	MONGODB_STREAM

create
	make_by_pointer, make_from_fd, make_from_path

feature {NONE} -- Initialization

	make_from_fd (a_fd: INTEGER)
			-- Create a new stream from an existing file descriptor `a_fd'.
		require
			valid_fd: a_fd >= 0
		local
			l_ptr: POINTER
			l_error: BSON_ERROR
		do
				-- https://mongoc.org/libmongoc/current/mongoc_stream_file_new.html
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_stream_file_new (a_fd)
			if l_ptr /= default_pointer then
				make_by_pointer (l_ptr)
			else
				create l_error.make
				l_error.set_error (
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM,
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM_SOCKET,
						"Failed to create file stream from file descriptor."
					)
				set_last_error_with_bson (l_error)
			end
		end

	make_from_path (a_path: READABLE_STRING_GENERAL; a_flags: INTEGER; a_mode: INTEGER)
			-- Create a new stream from file path `a_path' with open flags `a_flags' and mode `a_mode'.
		require
			valid_path: not a_path.is_empty
		local
			l_ptr: POINTER
			l_error: BSON_ERROR
			c_path: C_STRING
		do
				-- https://mongoc.org/libmongoc/current/mongoc_stream_file_new_for_path.html
			create c_path.make (a_path)
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_stream_file_new_for_path (c_path.item, a_flags, a_mode)
			if l_ptr /= default_pointer then
				make_by_pointer (l_ptr)
			else
				create l_error.make
				l_error.set_error (
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM,
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM_SOCKET,
						"Failed to create file stream from path: " + a_path.to_string_8
					)
				set_last_error_with_bson (l_error)
			end
		end

feature -- Access

	file_descriptor: INTEGER
			-- Get the underlying file descriptor
		note
			EIS: "name=mongoc_stream_file_get_fd", "src=https://mongoc.org/libmongoc/current/mongoc_stream_file_get_fd.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			Result := {MONGODB_EXTERNALS}.c_mongoc_stream_file_get_fd (item)
		ensure
			valid_result: Result >= 0
		end

	base_stream: detachable MONGODB_STREAM_FILE
			-- Get the underlying stream that is being wrapped.
		note
			EIS: "name=mongoc_stream_get_base_stream", "src=https://mongoc.org/libmongoc/current/mongoc_stream_get_base_stream.html", "protocol=uri"
		local
			l_ptr: POINTER
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_stream_get_base_stream (item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

end
