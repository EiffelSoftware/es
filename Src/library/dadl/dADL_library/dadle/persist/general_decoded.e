indexing
	description: "Summary description for {GENERAL_DECODED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GENERAL_DECODED


feature -- Creation	

	make (an_old_dtype,new_dtype: INTEGER;a_class_name: STRING) is
			-- init with old dtype and a new dtype and a class name
		deferred
		end


feature -- Access

	dtype: INTEGER
			-- unique dtype in current system

	generic_type: INTEGER
			-- dtype of generic object representing this object type

	name: STRING
			-- name of class

	has_non_base_type_attr: BOOLEAN
			-- has attribute which is not a base type

	is_tuple: BOOLEAN
			-- is tuple type

	is_special: BOOLEAN
			-- is special type SPECIAL[ANY]

	is_generic: BOOLEAN
			-- is based on generic object... sequence,special,tuple,...

	special_count: INTEGER
			-- number of special entries

	attribute_values: ARRAYED_LIST[TUPLE[object:ANY;name:STRING]]
			-- actual values/objects of attributes

	attribute_names: LINKED_LIST[STRING]
			-- names of attributes

feature -- Access

	has_attribute (a_name: STRING): BOOLEAN is
			-- checks whether already has an attribute with this name
		require
			not_void: a_name /= void
		do
			result := attribute_names.has (a_name)
		end

	set_is_tuple is
			-- sets tuple flag
		do
			is_tuple := true
		end

	set_is_special is
			-- sets special flag
		do
			is_special := true
		end

	set_special_count (a_count: INTEGER) is
			-- sets number of special entries
		do
			special_count := a_count
		end

	tuple_length: INTEGER is
			-- count of tuple
		require
			has_to_be_tuple: is_tuple
		do
			result := name.occurrences (',') + 1
		end

	change_value (a_new_value: STRING; a_position: INTEGER) is
			-- change the value of the attribute at a specified position
		local
			l_class_name: STRING
		do
			l_class_name := attribute_values.i_th (a_position).object.generating_type


			if l_class_name.is_equal ("INTEGER_8") then
				attribute_values.i_th (a_position).object := a_new_value.to_integer_8
			elseif l_class_name.is_equal ("INTEGER_16") then
				attribute_values.i_th (a_position).object := a_new_value.to_integer_16
			elseif l_class_name.is_equal ("INTEGER_32") then
				attribute_values.i_th (a_position).object := a_new_value.to_integer_32
			elseif l_class_name.is_equal ("INTEGER_64") then
				attribute_values.i_th (a_position).object := a_new_value.to_integer_64

			elseif l_class_name.is_equal ("NATURAL_8") then
				attribute_values.i_th (a_position).object := a_new_value.to_natural_8
			elseif l_class_name.is_equal ("NATURAL_16") then
				attribute_values.i_th (a_position).object := a_new_value.to_natural_16
			elseif l_class_name.is_equal ("NATURAL_32") then
				attribute_values.i_th (a_position).object := a_new_value.to_natural_32
			elseif l_class_name.is_equal ("NATURAL_64") then
				attribute_values.i_th (a_position).object := a_new_value.to_natural_64

			elseif l_class_name.is_equal ("BOOLEAN") then
				if a_new_value.as_lower.is_equal ("true") then
					attribute_values.i_th (a_position).object := true
				else
					attribute_values.i_th (a_position).object := false
				end

			elseif l_class_name.is_equal ("REAL_32") then
				attribute_values.i_th (a_position).object := a_new_value.to_real
			elseif l_class_name.is_equal ("REAL_64") then
				attribute_values.i_th (a_position).object := a_new_value.to_double

			elseif l_class_name.is_equal ("STRING_8") then
				attribute_values.i_th (a_position).object := a_new_value.to_string_8
			elseif l_class_name.is_equal ("STRING_32") then
				attribute_values.i_th (a_position).object := a_new_value.to_string_32
			elseif l_class_name.is_equal ("CHARACTER") or l_class_name.is_equal ("CHARACTER_8") or l_class_name.is_equal ("CHARACTER_32") then
				attribute_values.i_th (a_position).object := a_new_value.item(1)
			else
				check
					expanded_but_not_string_type: false
				end
			end
		end

end
