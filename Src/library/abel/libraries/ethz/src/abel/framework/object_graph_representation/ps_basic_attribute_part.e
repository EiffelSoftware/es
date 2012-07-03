note
	description: "Represents a single attribute of a basic type in the object graph."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_BASIC_ATTRIBUTE_PART

inherit
	PS_OBJECT_GRAPH_PART
	redefine
		basic_attribute_value
	end

inherit{NONE} REFACTORING_HELPER

create
	make

feature {PS_EIFFELSTORE_EXPORT}-- Initialization

	represented_object:ANY

	root: PS_OBJECT_GRAPH_ROOT
		-- The root of the object graph

	value:STRING
		-- The value of the basic attribute as a string
		do
			if attached{CHARACTER_8} represented_object as char then
				Result:= char.natural_32_code.out
			elseif attached{CHARACTER_32} represented_object as char then
				Result:= char.natural_32_code.out
			else
				Result:= represented_object.out
			end
		end

	is_representing_object:BOOLEAN = True
		-- Is `Current' representing an existing object?

	dependencies:LINKED_LIST[PS_OBJECT_GRAPH_PART]

	make (a_value:ANY; meta:PS_TYPE_METADATA; a_root:PS_OBJECT_GRAPH_ROOT)
			-- Initialization for `Current'.
		do
			represented_object:= a_value
			internal_metadata:=meta

			create dependencies.make
			create write_mode
			write_mode:=write_mode.No_operation
			root:= a_root

		end

	is_basic_attribute:BOOLEAN = True


--	storable_tuple (optional_primary: INTEGER):PS_PAIR[STRING, STRING]
		-- The storable tuple of the current object.
--		do
--			fixme ("TODO: add type information to basic attributes as well")
--			create Result.make (value, "BASIC")
--		end

	to_string:STRING
		do
			Result:= "Basic attribute: " + value.out + "%N"
		end


	basic_attribute_value: STRING
		-- The value of `Current' as a string.
		do
			Result:= value
		end

	internal_metadata: detachable like metadata

	initialize (a_level:INTEGER; a_mode:PS_WRITE_OPERATION; disassembler:PS_OBJECT_DISASSEMBLER)
		do
			if not is_initialized then
				is_initialized:= True
				level:= a_level
			end
		end

end
