indexing
	description: "Wrapper class for IOBJECT_CLASS"
	author: "Ruihua Jin"
	date: "$Date: 2008/03/18 13:48:59$"
	revision: "$Revision: 1.0$"

class
	OBJECT_CLASS

inherit
	ATTRIBUTE_NAME_HELPER

create
	make

feature {NONE}  -- Initialization

	make (config: CONFIGURATION; type: SYSTEM_TYPE) is
			-- Initialize `iconfig' with `config',
			-- `sys_type' with `type'.
		do
			configuration := config
			sys_type := type
			impl_type := implementation_type (sys_type)
			iobject_class := configuration.iconfig.object_class (impl_type)
		end

feature -- IOBJECT_CLASS

	call_constructor (flag: BOOLEAN) is
			-- Advise db4o to try instantiating objects of this class with/without calling constructors.
		do
			iobject_class.call_constructor (flag)
		end

	cascade_on_activate (flag: BOOLEAN) is
			-- Set cascaded activation behaviour.
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					configuration.iconfig.object_class (impl_types.item).cascade_on_activate (flag)
					impl_types.forth
				end
			else
				iobject_class.cascade_on_activate (flag)
			end
		end

	cascade_on_delete (flag: BOOLEAN) is
			-- Set cascaded delete behaviour.
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					configuration.iconfig.object_class (impl_types.item).cascade_on_delete (flag)
					impl_types.forth
				end
			else
				iobject_class.cascade_on_delete (flag)
			end
		end

	cascade_on_update (flag: BOOLEAN) is
			-- Set cascaded update behaviour.
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					configuration.iconfig.object_class (impl_types.item).cascade_on_update (flag)
					impl_types.forth
				end
			else
				iobject_class.cascade_on_update (flag)
			end
		end

	compare (attribute_provider: IOBJECT_ATTRIBUTE) is
			-- Register an attribute provider for special query behavior.
		require
			attribute_provider_not_void: attribute_provider /= Void
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					configuration.iconfig.object_class (impl_types.item).compare (attribute_provider)
					impl_types.forth
				end
			else
				iobject_class.compare (attribute_provider)
			end
		end

	enable_replication (setting: BOOLEAN) is
			-- Must be called before databases are created or opened
			-- so that db4o will control versions and generate UUIDs for objects of this class,
			-- which is required for using replication.		
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					configuration.iconfig.object_class (impl_types.item).enable_replication (setting)
					impl_types.forth
				end
			else
				iobject_class.enable_replication (setting)
			end
		end

	generate_uui_ds (setting: BOOLEAN) is
			-- Generate UUIDs for stored objects of this class.
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					configuration.iconfig.object_class (impl_types.item).generate_uui_ds (setting)
					impl_types.forth
				end
			else
				iobject_class.generate_uui_ds (setting)
			end
		end

	generate_version_numbers (setting: BOOLEAN) is
			-- Generate version numbers for stored objects of this class.
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					configuration.iconfig.object_class (impl_types.item).generate_version_numbers (setting)
					impl_types.forth
				end
			else
				iobject_class.generate_version_numbers (setting)
			end
		end

	indexed (flag: BOOLEAN) is
			-- Turn the class index on or off.
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					configuration.iconfig.object_class (impl_types.item).indexed (flag)
					impl_types.forth
				end
			else
				iobject_class.indexed (flag)
			end
		end

	maximum_activation_depth (depth: INTEGER) is
			-- Set the maximum activation depth to `depth'.
		require
			depth_nonnegative: depth >= 0
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					configuration.iconfig.object_class (impl_types.item).maximum_activation_depth (depth)
					impl_types.forth
				end
			else
				iobject_class.maximum_activation_depth (depth)
			end
		end

	minimum_activation_depth: INTEGER is
			-- Configured minimum activation depth
		do
			Result := iobject_class.minimum_activation_depth
		end

	minimum_activation_depth_integer (depth: INTEGER) is
			-- Set the minimum activation depth to `depth'.
		require
			depth_nonnegative: depth >= 0
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					configuration.iconfig.object_class (impl_types.item).minimum_activation_depth (depth)
					impl_types.forth
				end
			end
			iobject_class.minimum_activation_depth (depth)
		end

	object_field (fieldname: SYSTEM_STRING): OBJECT_FIELD is
			-- `OBJECT_FIELD' object to configure the specified field.
		require
			nonempty_fieldname: not {SYSTEM_STRING}.is_null_or_empty (fieldname)
		do
			Result := create {OBJECT_FIELD}.make (Current, fieldname)
		end

	persist_static_field_values is
			-- Turn on storing static field values for this class.
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					configuration.iconfig.object_class (impl_types.item).persist_static_field_values
					impl_types.forth
				end
			else
				iobject_class.persist_static_field_values
			end
		end

	read_as (clazz: SYSTEM_OBJECT) is
			-- Create a temporary mapping of a persistent class to a different class.
		obsolete
			"Use Translators, TypeHandlers, etc. instead"
		require
			clazz_not_void: clazz /= Void
		do
			iobject_class.read_as (clazz)
		end

	rename_ (new_name: SYSTEM_STRING) is
			-- Rename a stored class.
		require
			nonempty_new_name: not {SYSTEM_STRING}.is_null_or_empty (new_name)
		do
			iobject_class.rename_ (new_name)
		end

	store_transient_fields (flag: BOOLEAN) is
			-- Specify if transient fields are to be stored.
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					configuration.iconfig.object_class (impl_types.item).store_transient_fields (flag)
					impl_types.forth
				end
			else
				iobject_class.store_transient_fields (flag)
			end
		end

	translate (translator: IOBJECT_TRANSLATOR) is
			-- Register a translator for this class.
		require
			translator_not_void: translator /= Void
		do
			iobject_class.translate (translator)
		end

	update_depth (depth: INTEGER) is
			-- Specify the update depth for this class.
		require
			depth_nonnegative: depth >= 0
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					configuration.iconfig.object_class (impl_types.item).update_depth (depth)
					impl_types.forth
				end
			else
				iobject_class.update_depth (depth)
			end
		end

feature {OBJECT_CLASS, OBJECT_FIELD}

	descendant_object_classes: LINKED_LIST[OBJECT_CLASS] is
			-- List of `iobject_class' objects for each implementation class of `sys_type'
		local
			impl_types: LINKED_LIST[SYSTEM_TYPE]
		do
			create Result.make
			if (is_eiffel_type (sys_type)) then
				impl_types := get_descendant_types (sys_type)
				from
					impl_types.start
				until
					impl_types.after
				loop
					Result.extend (create {OBJECT_CLASS}.make (configuration, impl_types.item))
					impl_types.forth
				end
			else
				Result.extend (create {OBJECT_CLASS}.make (configuration, sys_type))
			end
		end


feature {OBJECT_CLASS, OBJECT_FIELD}

	configuration: CONFIGURATION
			-- `CONFIGURATION' object for database configurations

	sys_type: SYSTEM_TYPE
			-- An interface type

	impl_type: SYSTEM_TYPE
			-- The corresponding implementation class for `sys_type'

	iobject_class: IOBJECT_CLASS
			-- `IOBJECT_CLASS' for `impl_type'

end
