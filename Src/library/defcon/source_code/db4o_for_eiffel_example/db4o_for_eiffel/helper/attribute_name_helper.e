indexing
	description: "[
			Helper to find the corresponding .NET field name of a given Eiffel attribute name,
			it also finds all the names of a given attribute renamed in descendant types.
		]"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	ATTRIBUTE_NAME_HELPER

inherit
	INTERNAL

feature  -- Mapping of Eiffel attribute names to .NET field names

	get_net_field_name (attrname: SYSTEM_STRING; extent: SYSTEM_TYPE): SYSTEM_STRING is
			-- The corresponding .NET field name for `attrname' in `extenttype'
		require
			attrname_not_void_or_empty: not {SYSTEM_STRING}.is_null_or_empty (attrname)
			extent_not_void: extent /= Void
		local
			extent_implementation: SYSTEM_TYPE
			fields: NATIVE_ARRAY[FIELD_INFO]
			fitem: FIELD_INFO
			i: INTEGER
			found: BOOLEAN
			attr: NATIVE_ARRAY[SYSTEM_OBJECT]
			eiffel_name: EIFFEL_NAME_ATTRIBUTE
		do
			if (not is_eiffel_type (extent)) then
				Result := attrname
			else
				extent_implementation := implementation_type (extent)
				fields := extent_implementation.get_fields ({BINDING_FLAGS}.instance |
							{BINDING_FLAGS}.public | {BINDING_FLAGS}.non_public)
				from
					i := 0
				until
					found or else i = fields.length
				loop
					fitem := fields.item (i)

					-- check whether `fitem' is the Eiffel attribute named `attrname'
					attr := fitem.get_custom_attributes ({EIFFEL_NAME_ATTRIBUTE}, False)
					if (attr /= Void and then attr.count > 0) then
						check
							valid_number_of_custom_attributes: attr.count = 1
						end
						eiffel_name ?= attr.item (0)
						if (eiffel_name.name.equals (attrname)) then
							found := True
							Result := fitem.name
						end
					end

					-- check whether `fitem' is the .NET field named `attrname'
					if (not found) then
						if (fitem.name.equals (attrname)) then
							found := True
							Result := fitem.name
						end
					end
					i := i + 1
				end
			end
		ensure
			Result_not_void_or_empty: not {SYSTEM_STRING}.is_null_or_empty (Result)
		end


	get_all_field_names (netfieldname: SYSTEM_STRING; extenttype: SYSTEM_TYPE): LINKED_LIST[SYSTEM_STRING] is
			-- All related field names of `netfieldname',
			-- including `netfieldname' and its new names in implementation classes of `extenttype'
		require
			netfieldname_not_void_or_empty: not {SYSTEM_STRING}.is_null_or_empty (netfieldname)
			extenttype_not_void: extenttype /= Void
		local
			destypes: LINKED_LIST[SYSTEM_TYPE]
			destype: SYSTEM_TYPE
			desfieldname: SYSTEM_STRING
			found: BOOLEAN
		do
			create Result.make
			Result.extend (netfieldname)
			-- Expanded type cannot inherit from expanded type,
			-- so look for new names only if `extenttype' is an interface.
			if (extenttype.is_interface and then netfieldname.starts_with ("$$")) then
				destypes := get_descendant_eiffel_types (extenttype)
				from
					destypes.start
				until
					destypes.after
				loop
					destype := destypes.item
					desfieldname := get_descendant_field_name (netfieldname, extenttype, destype)
					from
						found := False
						Result.start
					until
						Result.after
					loop
						if (desfieldname.equals (Result.item)) then
							found := True
						end
						Result.forth
					end
					if (not found) then
						Result.extend (desfieldname)
					end
					destypes.forth
				end
			end
		ensure
			Result_not_void: Result /= Void
			no_empty_result: Result.count > 0
		end


	get_descendant_field_name (netfieldname: SYSTEM_STRING; interface: SYSTEM_TYPE; destype: SYSTEM_TYPE): SYSTEM_STRING is
			-- Field name corresponding to `netfieldname' in `destype'
		require
			is_eiffel_field: netfieldname.starts_with ("$$")
			interface: interface.is_interface
			implementation: not destype.is_interface
		local
			methodname: SYSTEM_STRING
			i: INTEGER
			im: INTERFACE_MAPPING
			i_methods: NATIVE_ARRAY[METHOD_INFO]
			t_methods: NATIVE_ARRAY[METHOD_INFO]
			i_m: METHOD_INFO
			t_m: METHOD_INFO
			method_found: BOOLEAN
			tname: SYSTEM_STRING
			new_name: SYSTEM_STRING
			f: FIELD_INFO
			asloc: SYSTEM_STRING
			service_provider: ISERVICE_PROVIDER
			assembly_manager: IASSEMBLY_MANAGER
			assembly: IASSEMBLY
			module: IMODULE
			type_dec: ITYPE_DECLARATION
			method_dec: IMETHOD_DECLARATION
			method_body: IMETHOD_BODY
			instruction: IINSTRUCTION
			mod_enum, type_enum, method_enum, instruction_enum: IENUMERATOR
			found, instr_pnt: BOOLEAN
			instr_string: SYSTEM_STRING
			startindex, length: INTEGER
		do
			methodname := netfieldname.substring (3)
			methodname := netfieldname.substring (2,1).to_upper.insert (1, methodname)
			im := destype.get_interface_map (interface)
			i_methods := im.interface_methods
			t_methods := im.target_methods
			from
				method_found := False
				i := 0
			until
				method_found or else i = i_methods.length
			loop
				i_m := i_methods.item (i)
				if (i_m.name.equals (methodname)) then
					method_found := True
					t_m := t_methods.item (i)
					tname := t_m.name
					if (tname.equals (methodname)) then
						Result := netfieldname
					else
						new_name := tname.substring (0,1).to_lower.insert (1, tname.substring (1))
						new_name := ("$$").to_cil.insert (2, new_name)

						-- check if `new_name' exists in `destype'						
						f := destype.get_field (new_name, {BINDING_FLAGS}.instance | {BINDING_FLAGS}.public | {BINDING_FLAGS}.non_public)
						if (f /= Void) then
							Result := new_name
						else
							-- perhaps attribute of anchor type										
							asloc := destype.assembly.location
							service_provider := create {APPLICATION_MANAGER}.make (Void)
							assembly_manager ?= service_provider.get_service ({IASSEMBLY_MANAGER})
							check
								assembly_manager_not_void: assembly_manager /= Void
							end
							assembly := assembly_manager.load_file (asloc)
							mod_enum := assembly.modules.get_enumerator
							from
								found := False
							until
								found or else not mod_enum.move_next
							loop
								module ?= mod_enum.current_
								check
									module_not_void: module /= Void
								end
								type_enum := module.types.get_enumerator
								from

								until
									found or else not type_enum.move_next
								loop
									type_dec ?= type_enum.current_
									check
										type_dec_not_void: type_dec /= Void
									end
									if (not type_dec.interface and then type_dec.namespace.ends_with (".Impl") and then type_dec.name.equals (destype.name)) then
										method_enum := type_dec.methods.get_enumerator
										from

										until
											found or else not method_enum.move_next
										loop
											method_dec ?= method_enum.current_
											check
												method_dec_not_void: method_dec /= Void
											end
											if (method_dec.name.equals (tname)) then
												found := True
												check
													is_intermediate_method: is_intermediate_method (method_dec)
												end
												method_body ?= method_dec.body
												check
													method_body_not_void: method_body /= Void
												end
												instruction_enum := method_body.instructions.get_enumerator
												instr_pnt := instruction_enum.move_next
												instr_pnt := instruction_enum.move_next
												instruction ?= instruction_enum.current_
												check
													instruction_not_void: instruction /= Void
												end
												instr_string := instruction.to_string
												startindex := instr_string.index_of (".") + 1
												length := instr_string.index_of ("(") - startindex
												new_name := instr_string.substring (startindex, length)
												new_name := new_name.substring (0,1).to_lower.insert (1, new_name.substring (1))
												new_name := ("$$").to_cil.insert (2, new_name)
												check
													field_exists: destype.get_field (new_name, {BINDING_FLAGS}.instance | {BINDING_FLAGS}.public | {BINDING_FLAGS}.non_public) /= Void
												end
												Result := new_name
											end
										end
									end
								end
							end
							check
								attribute_of_anchor_type_found: found
							end
						end
					end
				end
				i := i + 1
			end
			check
				method_exists_in_destype: method_found
			end
		ensure
			Result_not_void_or_empty: not {SYSTEM_STRING}.is_null_or_empty (Result)
		end

feature  -- Type information

	is_eiffel_type (t: SYSTEM_TYPE): BOOLEAN is
			 -- Is `t' an Eiffel type?
			 -- Use the fact that every Eiffel type implements `EIFFEL_TYPE_INFO' interface
			 -- to determine whether `t' is an Eiffel type or not.
		require
			t_not_void: t /= Void
		local
			i_type: SYSTEM_TYPE
		do
			i_type := t.get_interface ("EiffelSoftware.Runtime.EIFFEL_TYPE_INFO", True)
			Result := i_type /= Void
		end

	get_descendant_eiffel_types (t: SYSTEM_TYPE): LINKED_LIST[SYSTEM_TYPE] is
			-- A list of all implementation classes of `t'
			-- which are defined in Eiffel assemblies
		require
			t_not_void: t /= Void
		local
			l_assemblies: NATIVE_ARRAY [ASSEMBLY]
			assem: ASSEMBLY
			attrs: NATIVE_ARRAY[SYSTEM_OBJECT]
			types: NATIVE_ARRAY[SYSTEM_TYPE]
			t_item: SYSTEM_TYPE
			i, j: INTEGER
		do
			create Result.make
			if (is_eiffel_type (t)) then
				l_assemblies := {APP_DOMAIN}.current_domain.get_assemblies
				from
					i := 0
				until
					i = l_assemblies.length
				loop
					assem := l_assemblies.item (i)
					attrs := assem.get_custom_attributes ({EIFFEL_CONSUMABLE_ATTRIBUTE}, False)
					if (attrs /= Void and then attrs.length > 0) then
						types := assem.get_types
						from
							j := 0
						until
							j = types.length
						loop
							t_item := types.item (j)
							if (not t_item.is_interface and then t.is_assignable_from (t_item)) then
								Result.extend (t_item)
							end
							j := j + 1
						end
					end
					i := i + 1
				end
			end
		ensure
			Result_not_void: Result /= Void
		end

	get_descendant_types (t: SYSTEM_TYPE): LINKED_LIST[SYSTEM_TYPE] is
			-- A list of all implementation classes of `t'
		require
			t_not_void: t /= Void
		local
			l_assemblies: NATIVE_ARRAY [ASSEMBLY]
			assem: ASSEMBLY
			types: NATIVE_ARRAY[SYSTEM_TYPE]
			t_item: SYSTEM_TYPE
			i, j: INTEGER
		do
			create Result.make
			l_assemblies := {APP_DOMAIN}.current_domain.get_assemblies
			from
				i := 0
			until
				i = l_assemblies.length
			loop
				assem := l_assemblies.item (i)
				types := assem.get_types
				from
					j := 0
				until
					j = types.length
				loop
					t_item := types.item (j)
					if (not t_item.is_interface and then t.is_assignable_from (t_item)) then
						Result.extend (t_item)
					end
					j := j + 1
				end
				i := i + 1
			end
		ensure
			Result_not_void: Result /= Void
		end

feature {NONE} -- Implementation

	is_intermediate_method (md: IMETHOD_DECLARATION): BOOLEAN is
			-- Is `md' a method for the attribute of anchor type?
			-- If body of `md' has following format, then `Result'=`True', otherwise, `Result'=`False'
			-- L0000: 0002			 (IL_0000:  ldarg.0)
			-- L0001: 006F ...		 (IL_0001:  callvirt ...)
			-- ...
		require
			md_not_void: md /= Void
		local
			method_body: IMETHOD_BODY
			instr_col: IINSTRUCTION_COLLECTION
			instr: IINSTRUCTION
			instr_string: SYSTEM_STRING
			instr_enum: IENUMERATOR
			i: INTEGER
		do
			method_body ?= md.body
			check
				method_body_not_void: method_body /= Void
			end
			instr_col := method_body.instructions
			instr_enum := instr_col.get_enumerator
			from
				Result := True
				i := 0
			until
				not Result or not instr_enum.move_next
			loop
				instr ?= instr_enum.current_
				instr_string := instr.to_string
				if (i = 0) then
					Result := instr_string.starts_with ("L0000: 0002")
				elseif (i = 1) then
					Result := instr_string.starts_with ("L0001: 006F")
				end
				i := i + 1
			end
		end


end
