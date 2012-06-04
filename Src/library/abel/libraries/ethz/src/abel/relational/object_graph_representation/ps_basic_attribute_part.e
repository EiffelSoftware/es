note
	description: "Represents a single attribute of a basic type in the object graph."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_BASIC_ATTRIBUTE_PART

inherit
	PS_OBJECT_GRAPH_PART

create
	make

feature -- Initialization

	value:STRING
		-- The value of the basic attribute as a string


	dependencies:LINKED_LIST[PS_OBJECT_GRAPH_PART]

	make (a_value:ANY)
			-- Initialization for `Current'.
		do
			if attached{CHARACTER_8} a_value as char then
				value:= char.natural_32_code.out
			elseif attached{CHARACTER_32} a_value as char then
				value:= char.natural_32_code.out
			else
				value:= a_value.out
			end
			create dependencies.make
			create write_mode
			write_mode:=write_mode.No_operation
		end

	is_basic_attribute:BOOLEAN = True


	to_string:STRING
		do
			Result:= "Basic attribute: " + value.out + "%N"
		end


end
