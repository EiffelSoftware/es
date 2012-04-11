indexing
	description: "Wrapper class for IOBJECT_FIELD"
	author: "Ruihua Jin"
	date: "$Date: 2008/03/18 13:47:59$"
	revision: "$Revision$"

class
	OBJECT_FIELD

inherit
	ATTRIBUTE_NAME_HELPER

create
	make

feature {NONE}  -- Initialization

	make (clazz: OBJECT_CLASS; f: SYSTEM_STRING) is
			-- Initialize `iobject_class' with `clazz',
			-- `fieldname' with `f'.
		require
			clazz_not_void: clazz /= Void
			nonempty_field: not {SYSTEM_STRING}.is_null_or_empty (f)
		do
			object_class := clazz
			fieldname := f
		end

feature  -- IOBJECT_FIELD

	cascade_on_activate (flag: BOOLEAN) is
			-- Set cascaded activation behaviour.
		local
			object_classes: LINKED_LIST[OBJECT_CLASS]
			oc: OBJECT_CLASS
			net_field_name, fn: SYSTEM_STRING
		do
			if (is_eiffel_type (object_class.sys_type)) then
				net_field_name := get_net_field_name (fieldname, object_class.sys_type)
				object_classes := object_class.descendant_object_classes
				from
					object_classes.start
				until
					object_classes.after
				loop
					oc := object_classes.item
					fn := get_descendant_field_name (net_field_name, object_class.sys_type, oc.impl_type)
					object_class.configuration.iconfig.object_class (oc.impl_type).object_field (fn).cascade_on_activate (flag)
					object_classes.forth
				end
			else
				object_class.iobject_class.object_field (fieldname).cascade_on_activate (flag)
			end
		end

	cascade_on_delete (flag: BOOLEAN) is
			-- Set cascaded delete behaviour.
		local
			object_classes: LINKED_LIST[OBJECT_CLASS]
			oc: OBJECT_CLASS
			net_field_name, fn: SYSTEM_STRING
		do
			if (is_eiffel_type (object_class.sys_type)) then
				net_field_name := get_net_field_name (fieldname, object_class.sys_type)
				object_classes := object_class.descendant_object_classes
				from
					object_classes.start
				until
					object_classes.after
				loop
					oc := object_classes.item
					fn := get_descendant_field_name (net_field_name, object_class.sys_type, oc.impl_type)
					object_class.configuration.iconfig.object_class (oc.impl_type).object_field (fn).cascade_on_delete (flag)
					object_classes.forth
				end
			else
				object_class.iobject_class.object_field (fieldname).cascade_on_delete (flag)
			end
		end

	cascade_on_update (flag: BOOLEAN) is
			-- Set cascaded update behaviour.
		local
			object_classes: LINKED_LIST[OBJECT_CLASS]
			oc: OBJECT_CLASS
			net_field_name, fn: SYSTEM_STRING
		do
			if (is_eiffel_type (object_class.sys_type)) then
				net_field_name := get_net_field_name (fieldname, object_class.sys_type)
				object_classes := object_class.descendant_object_classes
				from
					object_classes.start
				until
					object_classes.after
				loop
					oc := object_classes.item
					fn := get_descendant_field_name (net_field_name, object_class.sys_type, oc.impl_type)
					object_class.configuration.iconfig.object_class (oc.impl_type).object_field (fn).cascade_on_update (flag)
					object_classes.forth
				end
			else
				object_class.iobject_class.object_field (fieldname).cascade_on_update (flag)
			end
		end

	indexed (flag: BOOLEAN) is
			-- Turn indexing on or off.
		local
			object_classes: LINKED_LIST[OBJECT_CLASS]
			oc: OBJECT_CLASS
			net_field_name, fn: SYSTEM_STRING
		do
			if (is_eiffel_type (object_class.sys_type)) then
				net_field_name := get_net_field_name (fieldname, object_class.sys_type)
				object_classes := object_class.descendant_object_classes
				from
					object_classes.start
				until
					object_classes.after
				loop
					oc := object_classes.item
					fn := get_descendant_field_name (net_field_name, object_class.sys_type, oc.impl_type)
					object_class.configuration.iconfig.object_class (oc.impl_type).object_field (fn).indexed (flag)
					object_classes.forth
				end
			else
				object_class.iobject_class.object_field (fieldname).indexed (flag)
			end
		end

	query_evaluation (flag: BOOLEAN) is
			-- Toggle query evaluation.
		local
			object_classes: LINKED_LIST[OBJECT_CLASS]
			oc: OBJECT_CLASS
			net_field_name, fn: SYSTEM_STRING
		do
			if (is_eiffel_type (object_class.sys_type)) then
				net_field_name := get_net_field_name (fieldname, object_class.sys_type)
				object_classes := object_class.descendant_object_classes
				from
					object_classes.start
				until
					object_classes.after
				loop
					oc := object_classes.item
					fn := get_descendant_field_name (net_field_name, object_class.sys_type, oc.impl_type)
					object_class.configuration.iconfig.object_class (oc.impl_type).object_field (fn).query_evaluation (flag)
					object_classes.forth
				end
			else
				object_class.iobject_class.object_field (fieldname).query_evaluation (flag)
			end
		end

	rename_ (old_eiffel_type: SYSTEM_TYPE; new_name: SYSTEM_STRING) is
			-- Rename a field of a stored class.
		require
			nonempty_new_name: not {SYSTEM_STRING}.is_null_or_empty (new_name)
		local
			object_classes: LINKED_LIST[OBJECT_CLASS]
			oc: OBJECT_CLASS
			net_field_name, new_net_field_name, fn: SYSTEM_STRING
		do
			if (is_eiffel_type (object_class.sys_type)) then
				check
					old_eiffel_type_not_void: old_eiffel_type /= Void
				end
				net_field_name := get_net_field_name (fieldname, old_eiffel_type)
				new_net_field_name := get_net_field_name (new_name, object_class.sys_type)
				object_classes := object_class.descendant_object_classes
				from
					object_classes.start
				until
					object_classes.after
				loop
					oc := object_classes.item
					fn := get_descendant_field_name (new_net_field_name, object_class.sys_type, oc.impl_type)
					if (fn.equals (new_net_field_name)) then
						object_class.configuration.iconfig.object_class (oc.impl_type).object_field (fn).rename_ (new_net_field_name)
					end
					object_classes.forth
				end
			else
				object_class.iobject_class.object_field (fieldname).rename_ (new_name)
			end
		end


feature {OBJECT_CLASS, OBJECT_FIELD}

	object_class: OBJECT_CLASS

	fieldname: SYSTEM_STRING


end

