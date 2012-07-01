note
	description: "Represents a part of the object graph that should be set to NULL in the database."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_NULL_REFERENCE_PART

inherit
	PS_OBJECT_GRAPH_PART
		redefine
			storable_tuple
		end

create make

feature
	is_representing_object:BOOLEAN = False
		-- Is `Current' representing an existing object?

	represented_object:ANY
		do
			check not_implemented:False end
			Result:= Current
		end

	dependencies: LINKED_LIST[PS_OBJECT_GRAPH_PART]

	is_basic_attribute:BOOLEAN = False

	to_string:STRING
		do
			Result:= "Null reference%N"
		end


	storable_tuple (optional_primary: INTEGER):PS_PAIR[STRING, STRING]
		-- The storable tuple of the current object.
		require else
			True
		do
			create Result.make ("0", "NONE")
		end

	initialize (a_level:INTEGER; a_mode:PS_WRITE_OPERATION; disassembler:PS_OBJECT_DISASSEMBLER)
		do
			if not is_initialized then
				is_initialized:= True
				level:= a_level
			end
		end

feature {NONE}


	make
		-- initialize `Current'
		do
			create dependencies.make
			create write_mode
			write_mode:=write_mode.No_operation
		end

feature {NONE} -- Implementation

	internal_metadata: detachable like metadata
		-- A little helper to circumvent void safety

end
