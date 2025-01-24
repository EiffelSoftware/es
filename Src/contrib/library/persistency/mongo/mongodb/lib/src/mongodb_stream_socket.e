note
	description: "[
			Object representing a mongoc_stream_socket_t structure.
			Provides socket stream capabilities.
			This is a specialized version of MONGODB_STREAM for working with network sockets.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_stream_socket_t", "src=https://mongoc.org/libmongoc/current/mongoc_stream_socket_t.html", "protocol=uri"

class
	MONGODB_STREAM_SOCKET

inherit
	MONGODB_STREAM

create
	make_by_pointer, make_from_socket

feature {NONE} -- Initialization

	make_from_socket (a_socket: MONGODB_SOCKET)
			-- Create a new stream from an existing socket `a_socket'.
		local
			l_ptr: POINTER
			l_error: BSON_ERROR
		do
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_stream_socket_new (a_socket.item)
			if l_ptr /= default_pointer then
				make_by_pointer (l_ptr)
			else
				create l_error.make
				l_error.set_error (
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM,
						{MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM_SOCKET,
						"Failed to create socket stream. Unable to initialize the stream."
					)
				set_last_error_with_bson (l_error)
			end
		end

feature -- Access

	socket: detachable MONGODB_SOCKET
			-- Get the underlying socket
		note
			eis: "name=", "src=https://mongoc.org/libmongoc/current/mongoc_stream_socket_get_socket.html", "protocol=uri"
		require
			is_useful: exists
		local
			l_ptr: POINTER
		do
			clean_up
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_stream_socket_get_socket (item)
			if l_ptr /= default_pointer then
				create Result.make_by_pointer (l_ptr)
			end
		end

	base_stream: detachable MONGODB_STREAM_SOCKET
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
