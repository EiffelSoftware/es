note
	description: "[
			Object representing a mongoc_stream_t structure.
			Provides a generic streaming IO abstraction that can be used for various types of streams
			including buffered, file, socket, and TLS streams.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_stream_t", "src=https://mongoc.org/libmongoc/current/mongoc_stream_t.html", "protocol=uri"

deferred class
	MONGODB_STREAM

inherit
	MONGODB_WRAPPER_BASE

feature -- Access

	base_stream: detachable MONGODB_STREAM
			-- Get the underlying stream that is being wrapped.
		note
			EIS: "name=mongoc_stream_get_base_stream", "src=https://mongoc.org/libmongoc/current/mongoc_stream_get_base_stream.html", "protocol=uri"
		deferred
		end

feature -- Operations

	read (buffer: POINTER; length: INTEGER): INTEGER
			-- Read from the stream into the buffer
			-- Returns number of bytes read or -1 on failure
		note
			eis: "name=mongoc_stream_read", "src=https://mongoc.org/libmongoc/current/mongoc_stream_read.html", "protocol=uri"

		require
			is_useful: exists
		local
			l_error: BSON_ERROR
		do
			clean_up
			Result := {MONGODB_EXTERNALS}.c_mongoc_stream_read (item, buffer, length, 0, 0)
			if Result = -1 then
				create l_error.make
				l_error.set_error (
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM,
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM_SOCKET,
						"Failed to read from stream. The stream may be closed, in an invalid state, or the read operation timed out."
					)
				set_last_error_with_bson (l_error)
			end
		end

	write (buffer: POINTER; length: INTEGER): INTEGER
			-- Write to the stream from the buffer
			-- Returns number of bytes written or -1 on failure
		note
			eis: "name=mongoc_stream_write", "src=https://mongoc.org/libmongoc/current/mongoc_stream_write.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_error: BSON_ERROR
		do
			clean_up
			Result := {MONGODB_EXTERNALS}.c_mongoc_stream_write (item, buffer, length, 0)
			if Result = -1 then
				create l_error.make
				l_error.set_error (
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM,
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM_SOCKET,
						"Failed to write to stream. The stream may be closed, in an invalid state, or the write operation failed."
					)
				set_last_error_with_bson (l_error)
			end
		end

	flush
			-- Flush the stream's buffers
		note
			EIS: "name=mongoc_stream_flush", "src=https://mongoc.org/libmongoc/current/mongoc_stream_flush.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_res: INTEGER
			l_error: BSON_ERROR
		do
			clean_up
			l_res := {MONGODB_EXTERNALS}.c_mongoc_stream_flush (item)
			if l_res = -1 then
				create l_error.make
				l_error.set_error (
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM,
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM_SOCKET,
						"Failed to flush stream. The stream may be in an invalid state or closed."
					)
				set_last_error_with_bson (l_error)
			end
		end

	close
			-- Close the stream
		note
			EIS: "name=mongoc_stream_close", "src=https://mongoc.org/libmongoc/current/mongoc_stream_close.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_res: INTEGER
			l_error: BSON_ERROR
		do
			clean_up
			l_res := {MONGODB_EXTERNALS}.c_mongoc_stream_close (item)
			if l_res = -1 then
				create l_error.make
				l_error.set_error (
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM,
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM_SOCKET,
						"Failed to close stream. The stream may be already closed or in an invalid state."
					)
				set_last_error_with_bson (l_error)
			end
		end

--    cork
--            -- Cork the stream, preventing writes
--        note
--        	EIS: "name=mongoc_stream_cork", "src=https://mongoc.org/libmongoc/current/mongoc_stream_cork.html", "protocol=uri"
--        local
--            l_res: INTEGER
--            l_error: BSON_ERROR
--        do
--            l_res := {MONGODB_EXTERNALS}.c_mongoc_stream_cork (item)
--            if l_res = -1 then
--                create l_error.make
--                l_error.set_error (
--                    {MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM,
--                    {MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM_SOCKET,
--                    "Failed to cork stream. The stream may be in an invalid state or already corked."
--                )
--                error := l_error
--            end
--        end

--    uncork
--            -- Uncork the stream, allowing writes
--        note
--            eis:"name=mongoc_stream_uncork", "src=https://mongoc.org/libmongoc/current/mongoc_stream_uncork.html", "protocol=uri"
--        local
--            l_res: INTEGER
--            l_error: BSON_ERROR
--        do
--            l_res := {MONGODB_EXTERNALS}.c_mongoc_stream_uncork (item)
--            if l_res = -1 then
--                create l_error.make
--                l_error.set_error (
--                    {MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM,
--                    {MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM_SOCKET,
--                    "Failed to uncork stream. The stream may be in an invalid state or not corked."
--                )
--                error := l_error
--            end
--        end

feature -- Status Report

	should_retry: BOOLEAN
			-- Checks if a stream operation should be retried
		note
			eis: "name=mongoc_stream_should_retry", "src=https://mongoc.org/libmongoc/current/mongoc_stream_should_retry.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			Result := {MONGODB_EXTERNALS}.c_mongoc_stream_should_retry (item)
		end

	timed_out: BOOLEAN
			-- Checks if the stream operation timed out
		note
			eis: "name=mongoc_stream_timed_out", "src=https://mongoc.org/libmongoc/current/mongoc_stream_timed_out.html", "protocol=uri"
		require
			is_useful: exists
		do
			clean_up
			Result := {MONGODB_EXTERNALS}.c_mongoc_stream_timed_out (item)
		end

feature -- Factory

	buffered_new (a_buffer_size: INTEGER): detachable MONGODB_STREAM_BUFFERED
			-- Create a new buffered stream that wraps the current stream with initial buffer size `a_buffer_size'.
			-- The buffered stream will add buffering capabilities to all read/write operations.
			-- Returns Void if creation fails.
		note
			EIS: "name=mongoc_stream_buffered_new", "src=https://mongoc.org/libmongoc/current/mongoc_stream_buffered_new.html", "protocol=uri"
		require
			is_useful: exists
			valid_buffer_size: a_buffer_size > 0
		local
			l_ptr: POINTER
			l_error: BSON_ERROR
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_stream_buffered_new (item, a_buffer_size)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
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

feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_mongoc_stream_destroy (item)
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
			"return sizeof(mongoc_stream_t *);"
		end

	c_mongoc_stream_destroy (a_item: POINTER)
		note
			eis: "name=mongoc_stream_destroy ", "src=https://mongoc.org/libmongoc/current/mongoc_stream_destroy.html", "protocol=uri"
		external
			"C inline use <mongoc/mongoc.h>"
		alias
			"mongoc_stream_destroy  ((mongoc_stream_t   *)$a_item);"
		end

end
