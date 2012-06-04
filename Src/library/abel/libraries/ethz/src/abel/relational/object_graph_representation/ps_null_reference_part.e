note
	description: "Represents a part of the object graph that should be set to NULL in the database."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_NULL_REFERENCE_PART

inherit
	PS_OBJECT_GRAPH_PART

create make

feature

	dependencies: LINKED_LIST[PS_OBJECT_GRAPH_PART]

	is_basic_attribute:BOOLEAN = False

	to_string:STRING
		do
			Result:= "Null reference%N"
		end

feature {NONE}


	make
		-- initialize `Current'
		do
			create dependencies.make
			create write_mode
			write_mode:=write_mode.No_operation
		end


end
