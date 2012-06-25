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

	dependencies:LINKED_LIST[PS_OBJECT_GRAPH_PART]


	make
		do
			create dependencies.make
			create write_mode
			write_mode:=write_mode.No_operation
		end

	storable_tuple (optional_primary: INTEGER):PS_PAIR[STRING, STRING]
		-- The storable tuple of the current object.
		do
			check ignore_part_should_not_be_stored: false end
			create Result.make ("", "")
		end


	is_basic_attribute:BOOLEAN = False

	to_string:STRING
		do
			Result:= "IGNORE reference"+ "%N"
		end

end
