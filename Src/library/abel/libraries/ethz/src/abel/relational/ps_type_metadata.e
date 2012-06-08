note
	description: "Collects all information about a specific runtime type"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_TYPE_METADATA

inherit PS_EIFFELSTORE_EXPORT

inherit{NONE}
	REFACTORING_HELPER
--	INTERNAL



create {PS_METADATA_MANAGER} make

feature

	type: TYPE[detachable ANY]
		-- The dynamic type id

	class_of_type: PS_CLASS_METADATA
		-- The class of which `Current' type is an instance of.
		once ("OBJECT")
			create Result.make_from_type (Current, manager)
		end

	is_basic_type: BOOLEAN
		do
			Result:= type.is_expanded or reflection.type_conforms_to (type.type_id, reflection.dynamic_type_from_string ("READABLE_STRING_GENERAL"))
		end

	is_generic: BOOLEAN
		do
			Result:= number_of_generics > 0
		end

	number_of_generics: INTEGER
		do
			Result:= reflection.generic_count_of_type (type.type_id)
		end

	is_subtype_of (other :PS_TYPE_METADATA):BOOLEAN
		do
			Result:= conforms (type, other.type)
		end

	is_supertype_of (other :PS_TYPE_METADATA):BOOLEAN
		do
			Result:= conforms (other.type, type)
		end


	supertypes: LIST[PS_TYPE_METADATA]
		do
			create {LINKED_LIST[PS_TYPE_METADATA]} Result.make

			across supertypes_internal_wrapper (type) as type_cursor  loop
				Result.extend (manager.create_metadata_from_type (type_cursor.item))
			end

		end

	subtypes: LIST[PS_TYPE_METADATA]
		do
			create {LINKED_LIST[PS_TYPE_METADATA]} Result.make

			across subtypes_internal_wrapper (type) as type_cursor loop
				Result.extend (manager.create_metadata_from_type (type_cursor.item))
			end
		end



	attributes: LIST [STRING]
			-- List of name of the attributes

	basic_attributes: LIST[STRING]
			-- Name of all attributes of a basic type
		do
			create {LINKED_LIST[STRING]} Result.make

			across attributes as attr_cursor loop
				if attribute_type (attr_cursor.item).is_basic_type then
					Result.extend (attr_cursor.item)
				end
			end
		end


	reference_attributes: LIST[STRING]
			-- Name of all attributes of a reference type
		do
			create {LINKED_LIST[STRING]} Result.make

			across attributes as attr_cursor loop
				if not attribute_type (attr_cursor.item).is_basic_type then
					Result.extend (attr_cursor.item)
				end
			end
		end

	index_of (attribute_name:STRING): INTEGER
		require
			attribute_present: across attributes as cursor some cursor.item.is_equal (attribute_name) end
			attr_persent_second_try: attributes.has (attribute_name)
		do
			Result:= attr_name_to_index_hash[attribute_name]
		ensure
			correct: reflection.field_name_of_type (Result, type.type_id).is_equal (attribute_name)
		end

--	is_generic_attribute (attribute_name:STRING): BOOLEAN
--		do
--		end

	attribute_type (attribute_name: STRING): PS_TYPE_METADATA
			-- Get the metadata of the type of the attribute `attribute_name'
		require
			has_attribute: attributes.has (attribute_name)
		do
			Result:= attach (attr_name_to_type_hash[attribute_name])
		end

	reflection:INTERNAL
		-- instance of INTERNAL.


feature {PS_METADATA_MANAGER} -- Initialization

	make (a_type: TYPE[detachable ANY]; a_manager:PS_METADATA_MANAGER)
		do
			type:= a_type
			manager:= a_manager
			create attr_name_to_type_hash.make (100)
			create attr_name_to_index_hash.make (100)
			create {LINKED_LIST[STRING]} attributes.make
			attributes.compare_objects
			create reflection
		end



	initialize
		local
			i:INTEGER
			new_type: TYPE[detachable ANY]
		do
			from i:=1
			until i> reflection.field_count_of_type (type.type_id)
			loop
				fixme ("check if the detachable type really is needed all the time")

				new_type:= reflection.type_of_type (reflection.detachable_type (reflection.field_static_type_of_type (i, type.type_id)))
				attr_name_to_index_hash.extend (i, reflection.field_name_of_type (i, type.type_id))
				attr_name_to_type_hash.extend (manager.create_metadata_from_type (new_type), reflection.field_name_of_type (i, type.type_id))

				attributes.extend (reflection.field_name_of_type (i, type.type_id))
				i:= i+1
			end
		end



feature{NONE} -- Implementation

	manager: PS_METADATA_MANAGER

	attr_name_to_type_hash: HASH_TABLE[PS_TYPE_METADATA, STRING]

	attr_name_to_index_hash: HASH_TABLE[INTEGER, STRING]

	subtypes_internal_wrapper (a_type: TYPE[detachable ANY]): LIST[TYPE[detachable ANY]]
		do
			create {LINKED_LIST[TYPE[detachable ANY]]} Result.make
		ensure
			Result.for_all (agent conforms (?, a_type))
		end


	supertypes_internal_wrapper (a_type: TYPE[detachable ANY]): LIST[TYPE[detachable ANY]]
		do
			create {LINKED_LIST[TYPE[detachable ANY]]} Result.make
		ensure
			Result.for_all (agent conforms (a_type, ?))
		end


	conforms (subtype, supertype: TYPE[detachable ANY]): BOOLEAN
		do
			Result:= reflection.type_conforms_to (subtype.type_id, supertype.type_id)
		end

end
