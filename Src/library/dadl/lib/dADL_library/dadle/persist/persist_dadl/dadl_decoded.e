indexing
	description: "Object which was decoded."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DADL_DECODED

inherit
	GENERAL_DECODED

create
	make,
	make_by_name

feature -- creation

	make (an_old_dtype,new_dtype: INTEGER;a_class_name: STRING) is
			-- init with old dtype and a new dtype and a class name
		do
			generic_type := an_old_dtype
			dtype := new_dtype
			name := a_class_name
			init
		end

	make_by_name (a_unique_id: INTEGER;a_class_name: STRING) is
			--
		do
			dtype := a_unique_id
			name := a_class_name
			init
		end

feature -- basic operations

	set_attribute_values (all_values: ARRAYED_LIST[TUPLE[object: ANY;name: STRING]]) is
			-- Set all attribute values.
		do
			create attribute_values.make_from_array (all_values.to_array)
		end

	insert_actual_attribute (a_name: STRING;a_object: ANY) is
			-- insert an attribute
		require
			not_void: a_name /= void
		local
			tuple:TUPLE[object:ANY;name:STRING]
			dummy:DADL_DECODED
		do
			create tuple
			tuple.put (a_object, 1)
			tuple.put (a_name,2)
			attribute_values.extend(tuple)
			attribute_names.extend (a_name)
			dummy ?= a_object
			if  dummy /= void then
				has_non_base_type_attr := true
			end

		end


	update_attribute_value_by_name (a_attribute_name: STRING;a_new_value: ANY) is
			--
		local
			l_index:INTEGER
			l_tuple:TUPLE[object:ANY;name:STRING]
		do
			attribute_names.search (a_attribute_name)
			if not attribute_names.exhausted then
				l_index := attribute_names.index
				create l_tuple
				l_tuple.put (a_new_value, 1)
				l_tuple.put (a_attribute_name,2)
				attribute_values.go_i_th (l_index)
				attribute_values.replace (l_tuple)
			else
				check
					attribute_does_not_exist:false
				end
			end
		end


feature {NONE} -- Implementation

	init is
			--
		do
			create attribute_values.make(10)
			create attribute_names.make
			attribute_names.compare_objects
			has_non_base_type_attr := false
			is_tuple := false
			is_special := false
			special_count := 0
			if name.has ('[') then
				is_generic := true
			end
		end


end
