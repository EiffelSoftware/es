indexing
	description: "Wrapper class for ISTORED_FIELD"
	author: "Ruihua Jin"
	date: "$Date: 2008/03/25 13:48:59$"
	revision: "$Revision: 1.0$"

class
	STORED_FIELD

inherit
	ATTRIBUTE_NAME_HELPER

create
	make

feature {NONE}  -- Initialization

	make (sc: STORED_CLASS; name: SYSTEM_STRING; type: SYSTEM_OBJECT) is
			-- Initialize `stored_class', `fieldname', `fieldtype' and `istored_field'.
		local
			t: TYPE[SYSTEM_OBJECT]
			systype: SYSTEM_TYPE
			net_field_name: SYSTEM_STRING
		do
			stored_class := sc
			fieldname := name
			t ?= type
			if (t /= Void) then
				systype := t.to_cil
			else
				systype ?= type
				if (systype = Void) then
					systype := type.get_type
				end
			end
			fieldtype := implementation_type (systype)
			net_field_name := get_net_field_name (fieldname, stored_class.sys_type)
			istored_field := stored_class.istored_class.stored_field (net_field_name, fieldtype)
		end

feature  -- Wrapper routines for ISTORED_FIELD

	create_index is
			-- Create an index on this field at runtime.
		do
			istored_field.create_index
		end

	get (on_object: SYSTEM_OBJECT): SYSTEM_OBJECT is
			-- Field value on `on_object'
		require
			on_object_not_void: on_object /= Void
		do
			Result := istored_field.get (on_object)
		end

	get_name: SYSTEM_STRING is
			-- Field name
		do
			Result := istored_field.get_name
		end

	get_stored_type: IREFLECT_CLASS is
			-- Type of the field
		do
			Result := istored_field.get_stored_type
		end

	has_index: BOOLEAN is
			-- Does this field has an index?
		do
			Result := istored_field.has_index
		end

	is_array: BOOLEAN is
			-- Is this field an array?
		do
			Result := istored_field.is_array
		end

	rename_ (old_eiffel_type: SYSTEM_TYPE; new_name: SYSTEM_STRING) is
			-- Rename this field as `new_name'.
		require
			nonempty_new_name: not {SYSTEM_STRING}.is_null_or_empty (new_name)
		local
			net_field_name, new_net_field_name: SYSTEM_STRING
		do
			if (is_eiffel_type (stored_class.sys_type)) then
				check
					old_eiffel_type_not_void: old_eiffel_type /= Void
				end
				net_field_name := get_net_field_name (fieldname, old_eiffel_type)
				new_net_field_name := get_net_field_name (new_name, stored_class.sys_type)
				stored_class.istored_class.stored_field (net_field_name, fieldtype).rename_ (new_net_field_name)
			else
				istored_field.rename_ (new_name)
			end
		end

	traverse_values (visitor: IVISITOR_4) is
			-- Specialized highspeed API to collect all values of a field
			-- for all instances of a class, if the field is indexed.
		require
			visitor_not_void: visitor /= Void
		do
			istored_field.traverse_values (visitor)
		end

feature {STORED_CLASS, STORED_FIELD}

	stored_class: STORED_CLASS

	istored_field: ISTORED_FIELD

	fieldname: SYSTEM_STRING

	fieldtype: SYSTEM_TYPE


end
