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
		local
			l_int: INTERNAL
		do
			create l_int
			name := a_name
			field_index := a_field_index.as_natural_32
			parent := a_parent
			object := an_object
			type := an_object.generator
			num_type := l_int.dynamic_type (an_object)
		end

feature {AD_OBJECT_TRAVERSABLE} -- Access - Must be encoded

	id: NATURAL

	name: STRING

	field_index: NATURAL

	parent: NATURAL

	type: STRING

	num_type: INTEGER

	value: detachable ANY --should be only of basic types (integers, strings, booleans, etc..)

feature {AD_OBJECT_TRAVERSABLE}-- Access - Must NOT be encoded

	object: ANY

feature {ANY}-- getters

	get_value: ANY
		do
			result := value
		end

	get_id: NATURAL
		do
			result := id
		end

	get_name: STRING
		do
			result := name
		end

	get_field_index: NATURAL
		do
			result := field_index
		end

	get_parent: NATURAL
		do
			result := parent
		end

	get_type: STRING
		do
			result := type
		end

	get_value_to_integer_8: INTEGER_8
		do
			result ?= value
		end
	get_value_to_integer_16: INTEGER_16
		do
			result ?= value
		end
	get_value_to_integer_32: INTEGER_32
		do
			result ?= value
		end
	get_value_to_integer_64: INTEGER_64
		do
			result ?= value
		end
	get_value_to_natural_8: NATURAL_8
		do
			result ?= value
		end
	get_value_to_natural_16: NATURAL_16
		do
			result ?= value
		end
	get_value_to_natural_32: NATURAL_32
		do
			result ?= value
		end
	get_value_to_natural_64: NATURAL_64
		do
			result ?= value
		end
	get_value_to_double: DOUBLE
		do
			result ?= value
		end
	get_value_to_real: REAL
		do
			result ?= value
		end
	get_value_to_boolean: BOOLEAN
		do
			result ?= value
		end
	get_value_to_character_8: CHARACTER_8
		do
			result ?= value
		end
	get_value_to_character_32: CHARACTER_32
		do
			result ?= value
		end
	get_value_to_pointer: POINTER
		do
			result ?= value
		end

feature {ANY} -- setters

	set_value(o:ANY)
		do
			value := o
		end

	set_id (an_id: INTEGER)
		do
			id := an_id.as_natural_32
		end

feature {ANY} -- Operations

	out: STRING
		do
			Result := "ID: " + id.out + ", Parent: " + parent.out + ", Field Index: " + field_index.out + ", Name: " + name.out + ", Class: " + type.out + "(" + num_type.out + "), Value: "
			if attached {ANY} value as v then
				Result.append (v.out)
			else
				Result.append ("Reference")
			end
		end

end
