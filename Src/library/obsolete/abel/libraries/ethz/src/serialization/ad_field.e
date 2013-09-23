note
	description: "Summary description for {AD_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AD_FIELD

inherit

	ANY
	redefine
			out
	end

create
	make

feature {AD_OBJECT_TRAVERSABLE} -- Initialization

	make (a_name: STRING; a_field_index: INTEGER; a_parent: NATURAL; an_object: ANY)
		require
			a_name_not_void: a_name /= Void
			a_field_index_not_void: a_field_index /= Void
			a_parent_positive: a_parent >= 0
			an_object_not_void: an_object /= Void
		do
			name := a_name
			field_index := a_field_index.as_natural_32
			parent := a_parent
			object := an_object
			type := an_object.generator
		end

feature {AD_OBJECT_TRAVERSABLE} -- Access - Must be encoded

	id: NATURAL

	name: STRING

	field_index: NATURAL

	parent: NATURAL

	type: STRING

	value: detachable ANY --should be only of basic types (integers, strings, booleans, etc..)

feature {AD_OBJECT_TRAVERSABLE} -- Access - Must NOT be encoded

	object: ANY

feature {AD_OBJECT_TRAVERSABLE} -- setters

	set_value
		do
			value := object
		end

	set_id (an_id: INTEGER)
		do
			id := an_id.as_natural_32
		end

feature {ANY} -- Operations

	out: STRING
		do
			Result := "ID: " + id.out + " Parent: " + parent.out + " Field Index: " + field_index.out + " Name: " + name.out + " Class: " + type.out + " Value: "
			if attached {ANY} value as v then
				Result.append (v.out)
			else
				Result.append ("Reference")
			end
		end

end
