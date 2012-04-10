note
	description: "Stores a repository-wide unique identifier for an object alongside a reference to it."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_IDENTIFIER_WRAPPER

create make

feature {NONE}

	make (id:INTEGER; obj:ANY)
		-- create `current' with object_identifier `id' and object `obj'
		do
			object_identifier:=id
			item:=obj
		end

feature	{PS_EIFFELSTORE_EXPORT} -- Access

	object_identifier:INTEGER
		-- the unique identifier for this object

	item: ANY
		-- A reference to the actual object

	class_name: STRING
		-- The object's class name
		local
			reflection:INTERNAL
		do
			create reflection
			Result:= reflection.class_name (item)
		end
end
