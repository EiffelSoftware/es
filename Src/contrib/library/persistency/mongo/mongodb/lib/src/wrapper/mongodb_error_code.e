note
    description: "[
        MongoDB error codes and domains.
        See: https://mongoc.org/libmongoc/current/errors.html
    ]"
    date: "$Date$"
    revision: "$Revision$"
	EIS: "name=Error Codes", "src=https://mongoc.org/libmongoc/current/errors.html", "protocol=uri"
	
class
    MONGODB_ERROR_CODE

feature -- Error Domains

    MONGOC_ERROR_CLIENT: INTEGER = 1
            -- Client-side errors

    MONGOC_ERROR_STREAM: INTEGER = 2
            -- Stream/network errors

    MONGOC_ERROR_PROTOCOL: INTEGER = 3
            -- MongoDB wire protocol errors

    MONGOC_ERROR_CURSOR: INTEGER = 4
            -- Cursor errors

    MONGOC_ERROR_QUERY: INTEGER = 5
            -- Query errors (legacy)

    MONGOC_ERROR_SERVER: INTEGER = 6
            -- Server-side errors

    MONGOC_ERROR_SASL: INTEGER = 7
            -- SASL authentication errors

    MONGOC_ERROR_BSON: INTEGER = 8
            -- BSON document errors

    MONGOC_ERROR_NAMESPACE: INTEGER = 9
            -- Namespace-related errors

    MONGOC_ERROR_COMMAND: INTEGER = 10
            -- Command errors

    MONGOC_ERROR_COLLECTION: INTEGER = 11
            -- Collection operation errors

    MONGOC_ERROR_GRIDFS: INTEGER = 12
            -- GridFS errors

    MONGOC_ERROR_SCRAM: INTEGER = 13
            -- SCRAM authentication errors

    MONGOC_ERROR_SERVER_SELECTION: INTEGER = 14
            -- Server selection errors

    MONGOC_ERROR_WRITE_CONCERN: INTEGER = 15
            -- Write concern errors

    MONGOC_ERROR_TRANSACTION: INTEGER = 16
            -- Transaction errors

    MONGOC_ERROR_CLIENT_SIDE_ENCRYPTION: INTEGER = 17
            -- Client-side encryption errors

    MONGOC_ERROR_AZURE: INTEGER = 18
            -- Azure KMS errors

    MONGOC_ERROR_GCP: INTEGER = 19
            -- Google Cloud Platform KMS errors

feature -- Client Error Codes

    MONGOC_ERROR_CLIENT_TOO_BIG: INTEGER = 101
            -- Message larger than server's max message size

    MONGOC_ERROR_CLIENT_AUTHENTICATE: INTEGER = 102
            -- Authentication failure or invalid credentials

    MONGOC_ERROR_CLIENT_NO_ACCEPTABLE_PEER: INTEGER = 103
            -- TLS connection attempted but driver not built with TLS support

    MONGOC_ERROR_CLIENT_IN_EXHAUST: INTEGER = 104
            -- Operation attempted during exhaust cursor iteration

    MONGOC_ERROR_CLIENT_SESSION_FAILURE: INTEGER = 105
            -- Failure related to creating or using a logical session

    MONGOC_ERROR_CLIENT_INVALID_ENCRYPTION_ARG: INTEGER = 106
            -- Invalid arguments for In-Use Encryption initialization

    MONGOC_ERROR_CLIENT_INVALID_ENCRYPTION_STATE: INTEGER = 107
            -- Failure related to In-Use Encryption

    MONGOC_ERROR_CLIENT_INVALID_LOAD_BALANCER: INTEGER = 108
            -- Server does not advertise load balanced support

    MONGOC_ERROR_CLIENT_HANDSHAKE_FAILED: INTEGER = 109
            -- Client handshake operation failed

feature -- Stream Error Codes

    MONGOC_ERROR_STREAM_NAME_RESOLUTION: INTEGER = 201
            -- DNS resolution failure

    MONGOC_ERROR_STREAM_SOCKET: INTEGER = 202
            -- Socket communication error or timeout

    MONGOC_ERROR_STREAM_CONNECT: INTEGER = 203
            -- Failed to connect to server

feature -- Protocol Error Codes

    MONGOC_ERROR_PROTOCOL_INVALID_REPLY: INTEGER = 301
            -- Invalid server reply

    MONGOC_ERROR_PROTOCOL_BAD_WIRE_VERSION: INTEGER = 302
            -- Incompatible wire protocol version

feature -- Cursor Error Codes

    MONGOC_ERROR_CURSOR_INVALID_CURSOR: INTEGER = 401
            -- Invalid cursor

    MONGOC_ERROR_CHANGE_STREAM_NO_RESUME_TOKEN: INTEGER = 402
            -- No resume token in change stream

feature -- Collection Error Codes

    MONGOC_ERROR_COLLECTION_INSERT_FAILED: INTEGER = 1101
            -- Insert operation failed

    MONGOC_ERROR_COLLECTION_UPDATE_FAILED: INTEGER = 1102
            -- Update operation failed

    MONGOC_ERROR_COLLECTION_DELETE_FAILED: INTEGER = 1103
            -- Delete operation failed

feature -- GridFS Error Codes

    MONGOC_ERROR_GRIDFS_CHUNK_MISSING: INTEGER = 1201
            -- Missing chunk in GridFS file

    MONGOC_ERROR_GRIDFS_CORRUPT: INTEGER = 1202
            -- GridFS data corruption detected

    MONGOC_ERROR_GRIDFS_INVALID_FILENAME: INTEGER = 1203
            -- Invalid GridFS filename

    MONGOC_ERROR_GRIDFS_PROTOCOL_ERROR: INTEGER = 1204
            -- GridFS protocol error

    MONGOC_ERROR_GRIDFS_BUCKET_FILE_NOT_FOUND: INTEGER = 1205
            -- GridFS file not found

    MONGOC_ERROR_GRIDFS_BUCKET_STREAM: INTEGER = 1206
            -- GridFS stream error

feature -- Transaction Error Codes

    MONGOC_ERROR_TRANSACTION_INVALID: INTEGER = 1601
            -- Invalid transaction state

feature -- KMS Error Codes

    MONGOC_ERROR_KMS_SERVER_HTTP: INTEGER = 1801
            -- KMS HTTP service error

    MONGOC_ERROR_KMS_SERVER_BAD_JSON: INTEGER = 1802
            -- Invalid JSON response from KMS service

end
