note
    description: "[
        Object representing a mongoc_socket_t structure.
        Provides a portable socket abstraction that handles inconsistencies
        between Linux, various BSDs, Solaris, and Windows.
    ]"
    date: "$Date$"
    revision: "$Revision$"
    EIS: "name=mongoc_socket_t", "src=https://mongoc.org/libmongoc/current/mongoc_socket_t.html", "protocol=uri"

class
    MONGODB_SOCKET

inherit
    MONGODB_WRAPPER_BASE
        rename
            make as memory_make
        end

create
    make, make_by_pointer

feature {NONE} -- Initialization

    make (a_domain: INTEGER; a_type: INTEGER; a_protocol: INTEGER)
            -- Create a new socket instance
        local
            l_ptr: POINTER
            l_error: BSON_ERROR
        do
            l_ptr := {MONGODB_EXTERNALS}.c_mongoc_socket_new (a_domain, a_type, a_protocol)
            if l_ptr /= default_pointer then
                make_by_pointer (l_ptr)
            else
                create l_error.make
                l_error.set_error (
                    {MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM,
                    {MONGODB_ERROR_CODE}.MONGOC_ERROR_STREAM_SOCKET,
                    "Failed to create socket. Unable to initialize."
                )
                set_last_error_with_bson (l_error)
            end
        end

feature -- Operations

    accept (a_expire_at: INTEGER_64): detachable MONGODB_SOCKET
            -- Accept a new client connection
        require
            is_useful: exists
        local
            l_ptr: POINTER
        do
        	clean_up
        		-- TODO double check
            l_ptr := {MONGODB_EXTERNALS}.c_mongoc_socket_accept (item, a_expire_at)
            if not l_ptr.is_default_pointer then
                create Result.make_by_pointer (l_ptr)
            end
        end

    bind (a_addr: POINTER; a_addrlen: INTEGER): BOOLEAN
            -- Bind the socket to an address
            -- `a_addr`: The address to bind to
        require
            valid_socket: exists
            valid_addlen: a_addrlen > 0
        do
        	clean_up
        		-- TODO double check
        		-- See how to use SOCKET from EiffelNet.
            Result := {MONGODB_EXTERNALS}.c_mongoc_socket_bind (item, a_addr, a_addrlen)
        end

    connect (a_addr: POINTER; a_addrlen: INTEGER; a_timeout_msec: INTEGER): BOOLEAN
            -- Connect to a remote host
            -- `a_addr`: The address to connect to
            -- `a_timeout_msec`: Timeout in milliseconds
        require
            valid_socket: exists
            valid_addr: a_addr /= default_pointer
            valid_addrlen: a_addrlen > 0
            valid_timeout: a_timeout_msec >= -1
        do
        		-- TODO double check.
        		-- See if we can use SOCKET from EiffelNet.
            clean_up
            Result := {MONGODB_EXTERNALS}.c_mongoc_socket_connect (item, a_addr, a_addrlen, a_timeout_msec)
        end

    close
            -- Close the socket
        require
            valid_socket: exists
        do
        	clean_up
            {MONGODB_EXTERNALS}.c_mongoc_socket_close (item)
        end

    listen (a_backlog: INTEGER): BOOLEAN
            -- Listen for incoming connections
            -- `a_backlog`: Maximum length of the queue of pending connections
        require
            valid_socket: exists
            valid_backlog: a_backlog >= 0
        do
        	clean_up
            Result := {MONGODB_EXTERNALS}.c_mongoc_socket_listen (item, a_backlog)
        end

    recv (a_buffer: POINTER; a_size: INTEGER; a_flag: INTEGER; a_timeout_msec: INTEGER_64): INTEGER
            -- Receive data from the socket
            -- `a_buffer`: Buffer to store received data
            -- `a_size`: Size of the buffer
            -- `a_flag`: flags for recv
            -- `a_timeout_msec`: Timeout in milliseconds
        require
            valid_socket: exists
            valid_buffer: a_buffer /= default_pointer
            valid_size: a_size > 0
            valid_timeout: a_timeout_msec >= -1
        do
        	clean_up
            Result := {MONGODB_EXTERNALS}.c_mongoc_socket_recv (item, a_buffer, a_size, a_flag, a_timeout_msec)
        end

    send (a_buffer: POINTER; a_size: INTEGER; a_timeout_msec: INTEGER): INTEGER
            -- Send data through the socket
            -- `a_buffer`: Buffer containing data to send
            -- `a_size`: Size of the data to send
            -- `a_timeout_msec`: Timeout in milliseconds
        require
            valid_socket: exists
            valid_buffer: a_buffer /= default_pointer
            valid_size: a_size > 0
            valid_timeout: a_timeout_msec >= -1
        do
        	clean_up
            Result := {MONGODB_EXTERNALS}.c_mongoc_socket_send (item, a_buffer, a_size, a_timeout_msec)
        end

    setsockopt (a_level: INTEGER; a_optname: INTEGER; a_optval: POINTER; a_optlen: INTEGER): BOOLEAN
            -- Set socket options
        require
            valid_socket: exists
            valid_optval: a_optval /= default_pointer
            valid_optlen: a_optlen > 0
        do
        	clean_up
            Result := {MONGODB_EXTERNALS}.c_mongoc_socket_setsockopt (item, a_level, a_optname, a_optval, a_optlen)
        end

feature -- Access

    errno: INTEGER
            -- Get the last error code for this socket
        require
            valid_socket: exists
        do
            Result := {MONGODB_EXTERNALS}.c_mongoc_socket_errno (item)
        end

    getsockname: POINTER
            -- Get the address to which the socket is bound
        require
            valid_socket: item /= default_pointer
        do
           -- TODO
        end

feature -- Removal

    dispose
            -- <Precursor>
        do
			if not shared then
				if exists then
					c_mongoc_socket_destroy (item)
				end
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
			"return sizeof(mongoc_socket_t *);"
		end


end
