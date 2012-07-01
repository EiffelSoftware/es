note
	description: "Summary description for {PS_OBJECT_GRAPH_ROOT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_GRAPH_ROOT

inherit
	PS_OBJECT_GRAPH_PART

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create dependencies.make
			create write_mode
			write_mode:= write_mode.no_operation
		end

feature


	represented_object:ANY
		do
			check not_implemented:False end
			Result:= Current
		end

	is_representing_object:BOOLEAN = False
		-- Is `Current' representing an existing object?

	dependencies: LINKED_LIST[PS_OBJECT_GRAPH_PART]
		-- All (immediate) parts on which `Current' is dependent on.

	add_dependency (obj: PS_OBJECT_GRAPH_PART)
		-- Add `obj' to the dependency list
		do
			dependencies.extend (obj)
		end


	storable_tuple (optional_primary: INTEGER):PS_PAIR[STRING, STRING]
		-- The storable tuple of the current object.
		do
			-- Should never be called on this object
			check implementation_error: False end
			create Result.make ("", "")
		end


	is_basic_attribute:BOOLEAN = False
		-- Is `Current' an instance of PS_BASIC_ATTRIBUTE_PART?


	to_string:STRING = ""
feature {NONE} -- Implementation

	internal_metadata: detachable like metadata
		-- A little helper to circumvent void safety

end
