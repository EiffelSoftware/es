note
    description: "[
        Socket-related constants for MongoDB driver.
        These constants are used when creating new sockets.
    ]"
    date: "$Date$"
    revision: "$Revision$"

class
    MONGODB_SOCKET_CONSTANTS

feature -- Domain Constants

    AF_INET: INTEGER = 2
            -- IPv4 Internet protocols

    AF_INET6: INTEGER = 10
            -- IPv6 Internet protocols

feature -- Type Constants

    SOCK_STREAM: INTEGER = 1
            -- Provides sequenced, reliable, two-way, connection-based byte streams

    SOCK_DGRAM: INTEGER = 2
            -- Supports datagrams (connectionless, unreliable messages)

feature -- Protocol Constants

    IPPROTO_TCP: INTEGER = 6
            -- Transmission Control Protocol

    IPPROTO_UDP: INTEGER = 17
            -- User Datagram Protocol

    IPPROTO_DEFAULT: INTEGER = 0
            -- Default protocol (usually suitable for most cases)

end -- class MONGODB_SOCKET_CONSTANTS
