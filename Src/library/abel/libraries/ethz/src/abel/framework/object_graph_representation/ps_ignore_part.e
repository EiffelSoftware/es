note
	description: "An object graph part that can be completely ignored, including the references pointing to it."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_IGNORE_PART

inherit
	PS_OBJECT_GRAPH_PART

create make

feature

	represented_object:ANY
		do
			check not_implemented:False end
			Result:= Current
		end


	is_representing_object:BOOLEAN = False
		-- Is `Current' representing an existing object?


	dependencies:LINKED_LIST[PS_OBJECT_GRAPH_PART]


	make
		do
			create dependencies.make
			create write_mode
			write_mode:=write_mode.No_operation
		end


	is_basic_attribute:BOOLEAN = False

	to_string:STRING
		do
			Result:= "IGNORE reference"+ "%N"
		end

	initialize (a_level:INTEGER; a_mode:PS_WRITE_OPERATION; disassembler:PS_OBJECT_DISASSEMBLER)
		do
			check implementation_error:False end
		end
feature {NONE} -- Implementation

	internal_metadata: detachable like metadata
		-- A little helper to circumvent void safety

end
