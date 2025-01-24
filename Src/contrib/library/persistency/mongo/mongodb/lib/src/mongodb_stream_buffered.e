note
	description: "[
			Object representing a mongoc_stream_buffered_t structure.
			Provides buffering capabilities on top of an underlying stream.
			This is a specialized version of MONGODB_STREAM that adds buffering functionality.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_stream_buffered_t", "src=https://mongoc.org/libmongoc/current/mongoc_stream_buffered_t.html", "protocol=uri"

class
	MONGODB_STREAM_BUFFERED

inherit
	MONGODB_STREAM

create
	make_by_pointer, make_from_base_stream

feature {NONE} -- Initialization

	make_from_base_stream (a_base: MONGODB_STREAM; a_buffer_size: INTEGER)
			-- Create a new buffered stream that wraps the base stream `a_base' with initial buffer size `a_buffer_size'.
			-- The buffered stream will add buffering capabilities to all read/write operations.
		require
			valid_base_stream: a_base.exists
			valid_buffer_size: a_buffer_size > 0
		local
			l_ptr: POINTER
			l_error: BSON_ERROR
		do
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_stream_buffered_new (a_base.item, a_buffer_size)
			if l_ptr /= default_pointer then
				make_by_pointer (l_ptr)
			else
				create l_error.make
				l_error.set_error (
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM,
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM_SOCKET,
						"Failed to create buffered stream. Unable to allocate or initialize the stream buffer."
					)
				set_last_error_with_bson (l_error)
			end
		end

feature -- Access

	base_stream: detachable MONGODB_STREAM_BUFFERED
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
