note
	description: "This class collects all relevant information about inheritance structure and fields in a single class."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_CLASS_METADATA

inherit PS_EIFFELSTORE_EXPORT
inherit {NONE}INTERNAL

create
	make_from_type


feature {PS_EIFFELSTORE_EXPORT} -- Access

	name: STRING
			--name of the class

	type: PS_TYPE_METADATA
		require
			not_generic: not is_generic
		do
			Result:=manager.create_metadata_from_type (type_of_type (dynamic_type_from_string(name)))
		end


feature {PS_EIFFELSTORE_EXPORT} -- Access

	proper_ancestors: LIST [PS_CLASS_METADATA]
			-- The proper ancestors


	proper_descendants: LIST [PS_CLASS_METADATA]
			-- The proper descendants


	--immediate_ancestors: LIST[PS_CLASS_METADATA]
			-- The immediate ancestors
			-- there is no way to get the immediate ancestors when just using the (transitive) conformsTo relation.
	--immediate_descendants: LIST[PS_CLASS_METADATA]
			-- The immediate descendants





feature {PS_EIFFELSTORE_EXPORT} -- Status

	is_basic_type: BOOLEAN
			-- Is `Current' a basic type, i.e. a String, Boolean or Numeric value?

	is_generic: BOOLEAN


feature {PS_EIFFELSTORE_EXPORT} -- obsolete

	attributes: LINKED_LIST[STRING]
		once
			create Result.make
		end

	get_attribute_id (arg: STRING):INTEGER
		do
			Result:=0
		end

	attribute_type (arg: STRING): like Current
		do
			Result:= Current
		end

feature {NONE} -- Initialization

	make (cl_name: STRING; basic: BOOLEAN)
			-- Initialize `Current'
		do
--			create {LINKED_LIST [PS_CLASS_METADATA]} proper_ancestors.make
--			create {LINKED_LIST [PS_CLASS_METADATA]} proper_descendants.make
--			create {LINKED_LIST [STRING]} attributes.make
--			create private_type_hash.make (50)
--			create private_attr_id_hash.make (50)
			name := cl_name
			is_basic_type := basic
		end

	make_from_type (type_metadata: PS_TYPE_METADATA; a_manager:PS_METADATA_MANAGER)
		do
			name:= class_name_of_type (type_metadata.type.type_id)
			is_generic:= type_metadata.is_generic
			is_basic_type:= type_metadata.is_basic_type
			manager:= a_manager

			proper_ancestors:= calculate_proper_ancestors (type_metadata)
			proper_descendants:= calculate_proper_descendants (type_metadata)
		end



	calculate_proper_ancestors(type_metadata: PS_TYPE_METADATA): LIST[PS_CLASS_METADATA]
		local
			type_names: LINKED_LIST[STRING]
			local_class_name: STRING
		do
			create {LINKED_LIST[PS_CLASS_METADATA]} Result.make
			create type_names.make

			across type_metadata.supertypes as type_cursor loop
				local_class_name:= class_name_of_type (type_cursor.item.type.type_id)
				if not type_names.has (local_class_name) and local_class_name /= name then
					type_names.extend (local_class_name)
					Result.extend (type_cursor.item.class_of_type)
				end
			end
		end


	calculate_proper_descendants(type_metadata: PS_TYPE_METADATA): LIST[PS_CLASS_METADATA]
		local
			type_names: LINKED_LIST[STRING]
			local_class_name: STRING
		do
			create {LINKED_LIST[PS_CLASS_METADATA]} Result.make
			create type_names.make

			across type_metadata.subtypes as type_cursor loop
				local_class_name:= class_name_of_type (type_cursor.item.type.type_id)
				if not type_names.has (local_class_name) and local_class_name /= name then
					type_names.extend (local_class_name)
					Result.extend (type_cursor.item.class_of_type)
				end
			end
		end

	manager: PS_METADATA_MANAGER








end
