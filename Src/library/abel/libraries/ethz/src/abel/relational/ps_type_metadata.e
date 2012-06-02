note
	description: "Collects all information about a specific runtime type"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_TYPE_METADATA

inherit PS_EIFFELSTORE_EXPORT
inherit{NONE} INTERNAL

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
			Result:= type.is_expanded or type_conforms_to (type.type_id, dynamic_type_from_string ("READABLE_STRING_GENERAL"))
		end

	is_generic: BOOLEAN
		do
			Result:= number_of_generics > 0
		end

	number_of_generics: INTEGER
		do
			Result:= generic_count_of_type (type.type_id)
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


feature {PS_METADATA_MANAGER} -- Initialization

	make (a_type: TYPE[detachable ANY]; a_manager:PS_METADATA_MANAGER)
		do
			type:= a_type
			manager:= a_manager
			create attr_name_to_type_hash.make (100)
			create {LINKED_LIST[STRING]} attributes.make
		end



	initialize
		local
			i:INTEGER
			new_type: TYPE[detachable ANY]
		do
			from i:=1
			until i< field_count_of_type (type.type_id)
			loop
				new_type:= type_of_type (field_static_type_of_type (i, type.type_id))
				attr_name_to_type_hash.extend (manager.create_metadata_from_type (new_type), field_name_of_type (i, type.type_id))

				attributes.extend (field_name_of_type (i, type.type_id))
			end
		end


feature{NONE} -- Implementation

	manager: PS_METADATA_MANAGER

	attr_name_to_type_hash: HASH_TABLE[PS_TYPE_METADATA, STRING]


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
			Result:= type_conforms_to (subtype.type_id, supertype.type_id)
		end

end
