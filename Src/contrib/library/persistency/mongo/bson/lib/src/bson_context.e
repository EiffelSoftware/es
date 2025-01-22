note
	description: "[
			Object Representing the bson_context_t structure.
			This context is for generation of BSON Object IDs. 
			This context allows for specialized overriding of how ObjectIDs are generated based on the applications requirements. 
			For example, disabling of PID caching can be configured if the application cannot detect when a call to fork() has occurred.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Bson Context", "src=http://mongoc.org/libbson/current/bson_context_t.html", "protocol=uri"

class
	BSON_CONTEXT
inherit

	BSON_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make, make_by_pointer, make_with_flags

feature {NONE} -- Initialization

	make
			-- Create the default, thread-safe, bson_context_t for the process.
		local
			l_pointer: POINTER
		do
			l_pointer := c_bson_context_get_default
			make_by_pointer (l_pointer)
		end


    make_with_flags (a_flags: INTEGER)
            -- Create a new bson_context_t with the specified flags.
        local
            l_pointer: POINTER
        do
            l_pointer := c_bson_context_new (a_flags)
            make_by_pointer (l_pointer)
        ensure
            item_set: item /= default_pointer
        end

feature -- Constants

    BSON_CONTEXT_NONE: INTEGER = 0
            -- Default context behavior

    BSON_CONTEXT_DISABLE_PID_CACHE: INTEGER = 4
            -- Disable PID caching (1 << 2)

feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_bson_context_destroy (item)
			else
				-- Memory managed by Eiffel.
			end
		end

feature {NONE} -- Implementation

	c_bson_context_get_default: POINTER
		external
			"C inline use <bson/bson.h>"
		alias
			"return bson_context_get_default();"
		end

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

	struct_size: INTEGER
		external
			"C inline use <bson/bson.h>"
		alias
			"sizeof(bson_context_t *)"
		end

	c_bson_context_destroy (a_context: POINTER)
		external
			"C inline use <bson/bson.h>"
		alias
			"bson_context_destroy ((bson_context_t *)$a_context);	"
		end


    c_bson_context_new (a_flags: INTEGER): POINTER
        external
            "C inline use <bson/bson.h>"
        alias
            "return bson_context_new ((bson_context_flags_t)$a_flags);"
        end

end

