indexing
	description: "Translator to store any POINTER as its corresponding type name in db4o"
	author: "Ruihua Jin"
	date: "$Date: 2007/12/17 14:05:57$"
	revision: "$Revision: 1.0$"

class
	POINTER_TRANSLATOR

inherit
	IOBJECT_CONSTRUCTOR

create
	make

feature {NONE} -- Initialization

	make is
			-- Initialization
		do
			register_types_from_assemblies
		end

feature  -- Translation

	stored_class: SYSTEM_TYPE is
			-- SYSTEM_STRING converted to
		do
			RESULT := {SYSTEM_STRING}
		end

	on_instantiate (container: IOBJECT_CONTAINER; stored_object: SYSTEM_OBJECT): SYSTEM_OBJECT is
			-- Convert `stored_object' to a POINTER.
			-- db4o calls this method when `stored_object' needs to be instantiated.
		require else
			container_not_void: container /= Void
			stored_object_not_void: stored_object /= Void
		local
			stored_name: SYSTEM_STRING
			a_pointer: POINTER
			monitor_exited: BOOLEAN
		do
			monitor_exited := True
			stored_name ?= stored_object
			if (stored_name /= Void and not stored_name.equals ("null")) then
				{MONITOR}.enter (Typename_pointer_mapping)
				monitor_exited := False
				Result := Typename_pointer_mapping.item (stored_name)
				monitor_exited := True
				{MONITOR}.exit (Typename_pointer_mapping)
			end
			if (Result = Void) then
				io.put_string ("Exception thrown by POINTER_TRANSLATOR.on_instantiate:")
				io.put_new_line
				io.put_string ("No POINTER found for the type (" + stored_name + ")")
				io.put_new_line
				io.put_string ("The reason could be: the assembly containing the type has been deleted or moved to another location.")
				io.put_new_line
			end
			check
				Result_not_void: Result /= Void
			end
		rescue
			if not monitor_exited then
				monitor_exited := True
				{MONITOR}.exit (Typename_pointer_mapping)
			end
		end

	on_store (container: IOBJECT_CONTAINER; application_object: SYSTEM_OBJECT): SYSTEM_OBJECT is
			-- Convert the POINTER `application_object' to its corresponding type name.
			-- db4o calls this method during storage and query evaluation.
		require else
			container_not_void: container /= Void
			application_object_not_void: application_object /= Void
		local
			a_pointer: POINTER
			monitor_exited: BOOLEAN
		do
			monitor_exited := True
			a_pointer ?= application_object
			if (a_pointer /= Void) then
				{MONITOR}.enter (Pointer_typename_mapping)
				monitor_exited := False
				Result := Pointer_typename_mapping.item (a_pointer)
				monitor_exited := True
				{MONITOR}.exit (Pointer_typename_mapping)
			end
			if (Result = Void) then
				io.put_string ("Exception thrown by POINTER_TRANSLATOR.on_store:")
				io.put_new_line
				io.put_string ("Type could not be found for the POINTER")
				io.put_new_line
			end
			check
				Result_not_void: Result /= Void
			end
		rescue
			if not monitor_exited then
				monitor_exited := True
				{MONITOR}.exit (Pointer_typename_mapping)
			end
		end

	on_activate (container: IOBJECT_CONTAINER; application_object: SYSTEM_OBJECT; stored_object: SYSTEM_OBJECT) is
			-- db4o calls this method during activation.
		do
		end

feature {NONE}  -- Implementation

	register_types_from_assemblies is
			-- Analyzes current loaded assembly in current AppDomain. Assemblies
			-- loaded after are loaded by hooking `register_types_from_assembly'
			-- to the `add_assembly_load' event.
		local
			l_assemblies: NATIVE_ARRAY [ASSEMBLY]
			i, nb: INTEGER
			l_handler: ASSEMBLY_LOAD_EVENT_HANDLER
		do
			l_assemblies := {APP_DOMAIN}.current_domain.get_assemblies
			create l_handler.make (Current, $assembly_load_event)
			{APP_DOMAIN}.current_domain.add_assembly_load (l_handler)
			from
				nb := l_assemblies.count
			until
				i = nb
			loop
				register_types_from_assembly (l_assemblies.item (i))
				i := i + 1
			end
		end

	assembly_load_event (sender: SYSTEM_OBJECT; args: ASSEMBLY_LOAD_EVENT_ARGS) is
			-- Action executed when a new assembly is loaded.
		do
			if args /= Void then
				check
					has_loaded_assembly: args.loaded_assembly /= Void
				end
				register_types_from_assembly (args.loaded_assembly)
			end
		end

	register_types_from_assembly (an_assembly: ASSEMBLY) is
			-- Add key-value pairs (pointer, type_name) and (type_name, pointer)
			-- to `Pointer_typename_mapping' and `Typename_pointer_mapping' hash tables.
		require
			assembly_not_void: an_assembly /= Void
		local
			types: NATIVE_ARRAY[SYSTEM_TYPE]
			i, nb: INTEGER
			pnt: POINTER
			name: SYSTEM_STRING
			monitor1_exited, monitor2_exited, list_monitor_exited: BOOLEAN
			registered: BOOLEAN
		do
			list_monitor_exited := True
			{MONITOR}.enter (registered_assemblies)
			list_monitor_exited := False
			from
				registered_assemblies.start
			until
				registered or else registered_assemblies.after
			loop
				registered := registered_assemblies.item.equals (an_assembly.location)
				registered_assemblies.forth
			end
			list_monitor_exited := True
			{MONITOR}.exit (registered_assemblies)

			if not registered then
				monitor1_exited := True
				monitor2_exited := True
				types := an_assembly.get_types
				{MONITOR}.enter (Pointer_typename_mapping)
				monitor1_exited := False
				{MONITOR}.enter (Typename_pointer_mapping)
				monitor2_exited := False
				from
					nb := types.count
				until
					i = nb
				loop
					pnt := types.item (i).type_handle.value
					name := (types.item (i).full_name + ", " + an_assembly.location).to_cil
					if (not Pointer_typename_mapping.contains_key (pnt)) then
						Pointer_typename_mapping.add (pnt, name)
					end
					if (not Typename_pointer_mapping.contains_key (name)) then
						Typename_pointer_mapping.add (name, pnt)
					end
					i := i + 1
				end
				monitor2_exited := True
				{MONITOR}.exit (Typename_pointer_mapping)
				monitor1_exited := True
				{MONITOR}.exit (Pointer_typename_mapping)

				{MONITOR}.enter (registered_assemblies)
				list_monitor_exited := False
				registered_assemblies.extend (an_assembly.location)
				list_monitor_exited := True
				{MONITOR}.exit (registered_assemblies)
			end
		rescue
			if not list_monitor_exited then
				list_monitor_exited := True
				{MONITOR}.exit (registered_assemblies)
			end
			if not monitor1_exited then
				monitor1_exited := True
				{MONITOR}.exit (Pointer_typename_mapping)
			end
			if not monitor2_exited then
				monitor2_exited := True
				{MONITOR}.exit (Typename_pointer_mapping)
			end
		end

feature {NONE}  -- Data representation

	Pointer_typename_mapping: HASHTABLE is
			-- Hashtable with POINTER as key, type name as value
		once
			create Result.make
		ensure
			pointer_typename_mapping_not_void: Result /= Void
		end

	Typename_pointer_mapping: HASHTABLE is
			-- Hashtable with type name as key, POINTER as value
		once
			create Result.make
		ensure
			typename_pointer_mapping_not_void: Result /= Void
		end

	registered_assemblies: LINKED_LIST[SYSTEM_STRING] is
			-- List of locations of registered assemblies
			-- Used to make sure that every assembly is only registered once.
		once
			create Result.make
		ensure
			list_not_void: Result /= Void
		end

end
