indexing
	description: "Wrapper class for ISTORED_CLASS"
	author: "Ruihua Jin"
	date: "$Date: 2008/03/25 13:48:59$"
	revision: "$Revision: 1.0$"

class
	STORED_CLASS

inherit
	ATTRIBUTE_NAME_HELPER

create
	make

feature {NONE}  -- Initialization

	make (extoc: IEXT_OBJECT_CONTAINER; object: SYSTEM_OBJECT) is
			-- Initialize with `extoc' and `object'.
			-- `object' can be `TYPE[SYSTEM_OBJECT]', `SYSTEM_TYPE' or
			-- any other object used as a template.
		require
			extoc_not_void: extoc /= Void
			object_not_void: object /= Void
		local
			type: TYPE[SYSTEM_OBJECT]
		do
			type ?= object
			if (type /= Void) then
				sys_type := type.to_cil
			else
				sys_type ?= object
				if (sys_type = Void) then
					sys_type := object.get_type
				end
			end
			impl_type := implementation_type (sys_type)
			istored_class := extoc.stored_class (impl_type)
		end

feature  -- Wrapper routines for ISTORED_CLASS

	get_ids: NATIVE_ARRAY[INTEGER_64] is
			-- An array of IDs of all stored object instances of this stored class.
		do
			Result := istored_class.get_ids
		end

	get_name: SYSTEM_STRING is
			-- Name of this stored class.
		do
			Result := istored_class.get_name
		end

	get_parent_stored_class: ISTORED_CLASS is
			-- STORED_CLASS for the parent of the class this STORED_CLASS represents
		do
			Result := istored_class.get_parent_stored_class
		end

	get_stored_fields: NATIVE_ARRAY[ISTORED_FIELD] is
			-- All stored fields of this stored class.
		do
			Result := istored_class.get_stored_fields
		end

	has_class_index: BOOLEAN is
			-- Does this STORED_CLASS have a class index?
		do
			Result := istored_class.has_class_index
		end

	rename_ (name: SYSTEM_STRING) is
			-- Rename this stored class.
		require
			nonempty_name: not {SYSTEM_STRING}.is_null_or_empty (name)
		do
			istored_class.rename_ (name)
		end

	stored_field (fieldname: SYSTEM_STRING; fieldtype: SYSTEM_OBJECT): STORED_FIELD is
			-- Existing stored field of this stored class.
		require
			nonempty_fieldname: not {SYSTEM_STRING}.is_null_or_empty (fieldname)
			fieldtype_not_void: fieldtype /= Void
		do
			Result := create {STORED_FIELD}.make (Current, fieldname, fieldtype)
		end

feature {STORED_CLASS, STORED_FIELD}

	istored_class: ISTORED_CLASS
			-- The actual `ISTORED_CLASS' for db4o database

	sys_type: SYSTEM_TYPE
			-- An interface type

	impl_type: SYSTEM_TYPE
			-- The implementation class for `sys_type'


end
