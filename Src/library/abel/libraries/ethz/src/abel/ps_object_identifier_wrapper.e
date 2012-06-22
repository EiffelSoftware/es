note
	description: "Stores a repository-wide unique identifier for an object alongside a reference to it."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_IDENTIFIER_WRAPPER
inherit
	PS_EIFFELSTORE_EXPORT


create make

feature {NONE}

	make (id:INTEGER; obj:ANY; meta: PS_TYPE_METADATA)
		-- create `current' with object_identifier `id' and object `obj'
		do
			object_identifier:=id
			item:=obj
			metadata:= meta
		end

feature	{PS_EIFFELSTORE_EXPORT} -- Access

	object_identifier:INTEGER
		-- the unique identifier for this object

	item: ANY
		-- A reference to the actual object

	metadata: PS_TYPE_METADATA
		-- Metadata information about the type of `item'

	class_name: STRING
		-- The object's class name
		obsolete "use metadata.class_of_type.name instead"
		do
			Result:= metadata.base_class.name
		end
end
