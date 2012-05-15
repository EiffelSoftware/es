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
			value:= a_value.out
			create dependencies.make
			create write_mode
			write_mode:=write_mode.No_operation
		end

	is_basic_attribute:BOOLEAN = True



end
