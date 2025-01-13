note
    description: "[
        Object Representing a Write Concern abstraction
        The MONGODB_WRITE_CONCERN tells the driver what level of acknowledgement to await from the server.
        The default, MONGOC_WRITE_CONCERN_W_DEFAULT (1), is right for the great majority of applications.

        Write Concern Levels:
        * MONGOC_WRITE_CONCERN_W_DEFAULT (1) - Block for acknowledgement from MongoDB (default)
        * MONGOC_WRITE_CONCERN_W_UNACKNOWLEDGED (0) - Don't block for acknowledgement
        * MONGOC_WRITE_CONCERN_W_MAJORITY ("majority") - Block for majority of nodes
        * n - Block for at least n nodes
    ]"
    date: "$Date$"
    revision: "$Revision$"
    EIS: "name=mongoc_write_concern_t", "src=http://mongoc.org/libmongoc/current/mongoc_write_concern_t.html", "protocol=uri"

class
    MONGODB_WRITE_CONCERN

inherit
    MONGODB_WRAPPER_BASE
        rename
            make as memory_make
        end

create
    make, make_by_pointer

feature {NONE} -- Initialization

    make
        do
            memory_make
            write_concern_new
        end

    write_concern_new
        local
            l_ptr: POINTER
        do
            l_ptr := {MONGODB_EXTERNALS}.c_mongoc_write_concern_new
            make_by_pointer (l_ptr)
        end

feature -- Removal

    dispose
            -- <Precursor>
        do
            if shared then
                c_mongoc_write_concern_destroy (item)
            end
        end

feature -- Status Report

    is_default: BOOLEAN
            -- Returns true if write_concern has not been modified from the default.
        require
            exists: exists
        do
            Result := {MONGODB_EXTERNALS}.c_mongoc_write_concern_is_default (item)
        end

    is_acknowledged: BOOLEAN
            -- Returns true if write operations with this write concern will be acknowledged.
       require
            exists: exists
        do
            Result := {MONGODB_EXTERNALS}.c_mongoc_write_concern_is_acknowledged (item)
        end

    is_valid: BOOLEAN
            -- Returns true if the write concern is valid.
 	     require
            exists: exists
        do
            Result := {MONGODB_EXTERNALS}.c_mongoc_write_concern_is_valid (item)
        end

feature -- Access

    w: INTEGER
            -- Get the w value for write concern.
        require
            exists: exists
        do
            Result := {MONGODB_EXTERNALS}.c_mongoc_write_concern_get_w (item)
        end

    wtimeout: INTEGER_64
            -- Get the wtimeout value in milliseconds.
       require
            exists: exists
        do
            Result := {MONGODB_EXTERNALS}.c_mongoc_write_concern_get_wtimeout_int64 (item)
        end

    wtag: detachable READABLE_STRING_8
            -- Get the wtag value, if any.
		require
            exists: exists
       local
            c_string: C_STRING
            l_ptr: POINTER
        do
            l_ptr := {MONGODB_EXTERNALS}.c_mongoc_write_concern_get_wtag (item)
            if l_ptr /= default_pointer then
                create c_string.make_by_pointer (l_ptr)
                create {STRING_8} Result.make_from_string (c_string.string)
            end
        end

    journal: BOOLEAN
            -- Get if journaling is required
        require
            exists: exists
        do
            Result := {MONGODB_EXTERNALS}.c_mongoc_write_concern_get_journal (item)
        end

    wmajority: BOOLEAN
            -- Returns true if the write must be propagated to a majority of nodes.
         require
            exists: exists
        do
            Result := {MONGODB_EXTERNALS}.c_mongoc_write_concern_get_wmajority (item)
        end

feature -- Element Change

    set_w (a_w: INTEGER)
            -- Set the w value for write concern.
       require
            exists: exists
        do
            {MONGODB_EXTERNALS}.c_mongoc_write_concern_set_w (item, a_w)
        end

    set_wtimeout (a_wtimeout: INTEGER_64)
            -- Set the wtimeout value in milliseconds.
        require
            exists: exists
        do
            {MONGODB_EXTERNALS}.c_mongoc_write_concern_set_wtimeout_int64 (item, a_wtimeout)
        end

    set_wmajority (a_wtimeout_msec: INTEGER_64)
            -- Set the write concern to require majority write concern.
       require
            exists: exists
        do
            {MONGODB_EXTERNALS}.c_mongoc_write_concern_set_wmajority (item, a_wtimeout_msec)
        end

    set_wtag (a_tag: READABLE_STRING_GENERAL)
            -- Set the wtag value.
       require
            exists: exists
        local
            l_string: C_STRING
        do
            create l_string.make (a_tag)
            {MONGODB_EXTERNALS}.c_mongoc_write_concern_set_wtag (item, l_string.item)
        end

    set_journal (a_journal: BOOLEAN)
            -- Set if journaling is required
        require
            exists: exists
        do
            {MONGODB_EXTERNALS}.c_mongoc_write_concern_set_journal (item, a_journal)
        end


feature -- Operations

    append_to_bson (a_command: BSON)
            -- Append this write concern to command options.
            -- Useful for appending write concern to command options before passing
            -- them to write command functions.
            -- Returns: True on success, False if any arguments are invalid.
        note
            eis: "name=mongoc_write_concern_append", "src=http://mongoc.org/libmongoc/current/mongoc_write_concern_append.html", "protocol=uri"
        require
            exists: exists
        local
        	l_res: BOOLEAN
        	l_error: BSON_ERROR
        do
        	clean_up
            l_res := {MONGODB_EXTERNALS}.c_mongoc_write_concern_append (item, a_command.item)
        	if not l_res then
        		create l_error.make
        		error := l_error
        	end
        end

feature {NONE} -- Measurement

    structure_size: INTEGER
            -- Size to allocate (in bytes)
        do
            Result := struct_size
        end

    struct_size: INTEGER
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "return sizeof(mongoc_write_concern_t *);"
        end

    c_mongoc_write_concern_destroy (a_write_concern: POINTER)
        external
            "C inline use <mongoc/mongoc.h>"
        alias
            "mongoc_write_concern_destroy ((mongoc_write_concern_t *)$a_write_concern);"
        end

end
