indexing
	component:   "openEHR Archetype Project"
	description: "[
				 object birectional converter. Errors due to mismatching data and object 
				 model reported in last_op_fail and fail_reason.
				 ]"
	keywords:    "dADL"
	author:      "Thomas Beale"
	support:     "Ocean Informatics <support@OceanInformatics.biz>"
	copyright:   "Copyright (c) 2005 Ocean Informatics Pty Ltd"
	license:     "See notice at bottom of class"

	file:        "$URL: http://www.openehr.org/svn/ref_impl_eiffel/TRUNK/libraries/common_libs/src/structures/data_tree/dt_object_converter.e $"
	revision:    "$LastChangedRevision$"
	last_change: "$LastChangedDate$"

class DT_OBJECT_CONVERTER

inherit
	DT_FACTORY

	MESSAGE_BILLBOARD
		export
			{NONE} all
		end

feature -- access

	show_type
			-- show type of objects which are converted
		do
			type_visible := True
		end

	hide_type
			-- hide type of objects which are converted
		do
			type_visible := False
		end

	type_visible:BOOLEAN
			-- True if type names are to be shown in converted DT

	conversion_successful:BOOLEAN
			-- True if last dt to object conversion was a success

	conversion_error_message:STRING
			-- error message reporting last error

	has_errors:BOOLEAN
			-- errors encountered

	error_message:STRING
			-- error message


feature -- Conversion

	object_to_dt(an_obj: ANY;a_serialized_form_list:ARRAYED_LIST[STRING]): DT_COMPLEX_OBJECT_NODE is
			-- generate a DT_OBJECT from an Eiffel object
		do
			clear_all
			clear_error
			custom_serialization_list := a_serialized_form_list
			if custom_serialization_list /= void then
				custom_serialization_list.compare_objects
			end
			create Result.make_anonymous
			if {l_decoded:GENERAL_DECODED} an_obj then
				populate_dt_from_decoded_object(l_decoded,Result,"")
			else
				populate_dt_from_object(an_obj, Result,"")
			end

		end

	dt_to_object(a_dt_obj: DT_COMPLEX_OBJECT_NODE;a_type_id:INTEGER): ANY is
			-- make an object whose classes and attributes correspond to the structure
			-- of this DT_OBJECT if the type is recognized by the system;
			-- otherwise wrapps all attributes into a object of class DADL_DECODED
		local
			l_type_id:INTEGER
		do
			-- clear data ...convertet could have been accessed directly by a "as_object" method
			clear_all
			clear_error
			root_dt_holder.extend(a_dt_obj)
			path_stack.put ("")
			--check type information
			if a_type_id >= 0 then
				result := dt_to_object_internal(a_dt_obj,a_type_id)
			elseif a_dt_obj.is_typed then
				l_type_id := dynamic_type_from_string (a_dt_obj.rm_type_name)
				if l_type_id >= 0 then
					-- known type to system
					result := dt_to_object_internal(a_dt_obj,l_type_id)
				else
					-- unknown type to system
					result := decode_dt_from_unknown_object(a_dt_obj)
				end
			else
				result := void
				create conversion_error_message.make_from_string("Underlying DT structure has no type information and a_type_id is not recognized by the system.")
			end

			clear_all
			if result /= void then
				conversion_successful := True
			end
		end


feature {DT_COMPLEX_OBJECT_NODE} -- Conversion internal

	populate_dt_from_decoded_object(an_obj:GENERAL_DECODED; a_dt_obj:DT_COMPLEX_OBJECT_NODE;a_path:STRING) is
			-- make a data tree from an object of type dadl_decoded
		local
			a_dt_attr: DT_ATTRIBUTE_NODE
			fld_val: ANY
			fld_tuple:TUPLE[object:ANY;name:STRING]
			equiv_prim_type_id,fld_type_id: INTEGER
			fld_name,l_path: STRING
			a_sequence: SEQUENCE[ANY]
			a_hash_table: HASH_TABLE [ANY, HASHABLE]
			a_array:ARRAY[ANY]
			l_is_shared:BOOLEAN
			l_list:ARRAYED_LIST[TUPLE[object:ANY;name:STRING]]
			fld_decoded:GENERAL_DECODED
		do
			if type_visible then
				a_dt_obj.show_type
			end
			a_dt_obj.set_type_name(an_obj.name)
			l_path := path_to_shared_obj(an_obj)
			if  l_path /= void then
				-- object is shared
				create a_dt_attr.make_as_path(l_path)
				a_dt_obj.put_attribute(a_dt_attr)
			else
				-- object is not shared
				remember_object(an_obj,a_path)

				if an_obj.is_generic and then check_generic_decoded_object(an_obj) then
					create a_dt_attr.make_multiple_generic
					create_dt_from_special_decoded_obj(a_dt_attr, an_obj,a_path)
					if type_visible then
						a_dt_attr.set_attr_type (an_obj.generating_type)
						a_dt_attr.show_type
					end
					a_dt_obj.put_attribute(a_dt_attr)
				else
					from
						l_list := an_obj.attribute_values
						l_list.start
					until
						l_list.after
					loop
						fld_tuple ?= l_list.item
						fld_val := fld_tuple.object
						fld_name := fld_tuple.name

						if fld_val /= Void then
							fld_decoded ?= fld_val
							if fld_decoded = Void then
								-- not a dadl_decoded object
								fld_type_id := dynamic_type_from_string (fld_val.generating_type)
								equiv_prim_type_id := any_primitive_conforming_type(fld_type_id)
								if equiv_prim_type_id /= 0 then
									l_is_shared := false
									if not is_primitive_type (fld_type_id) or fld_val.generating_type.starts_with ("STRING") then
										l_path := path_to_shared_obj(fld_val)
										if  l_path /= void then
											l_is_shared := true
											create a_dt_attr.make_single(fld_name)
											from_shared_obj_primitive_type(a_dt_attr,l_path,void,fld_val.generating_type)
											a_dt_obj.put_attribute(a_dt_attr)
										else
											remember_object(fld_val,a_path+"/"+fld_name)
										end
									end
									if not l_is_shared then
										create a_dt_attr.make_single(fld_name)
										populate_prim_type_attribute(an_obj, a_dt_attr, fld_val, equiv_prim_type_id)
										a_dt_obj.put_attribute(a_dt_attr)
									end
								else -- its a complex object, or else a SEQUENCE,SPECIAL,ARRAY,TUPLE or HASH_TABLE of a complex object
									a_hash_table ?= fld_val
									a_sequence ?= fld_val
									a_array ?= fld_val
									if a_hash_table /= Void or a_sequence /= Void or a_array /= void or is_special (fld_val) or is_tuple (fld_val) then
										debug ("DT")
											io.put_string("DT_OBJECT_CONVERTER.populate_dt_from_object: (container type)%N")
										end
										l_path := path_to_shared_obj(fld_val)
										if  l_path /= void then
											create a_dt_attr.make_single(fld_name)
											from_shared_obj_primitive_type(a_dt_attr,l_path,void,fld_val.generating_type)
											a_dt_obj.put_attribute(a_dt_attr)
										else
											remember_object(fld_val,a_path +"/"+fld_name)
											create a_dt_attr.make_multiple(fld_name)

											create_dt_from_generic_obj(a_dt_attr, fld_val,a_path+"/"+fld_name)
											if not a_dt_attr.is_empty then
												if type_visible then
													a_dt_attr.set_attr_type (fld_val.generating_type)
													a_dt_attr.show_type
												end
												a_dt_obj.put_attribute(a_dt_attr)
											end
										end
									else
										debug ("DT")
											io.put_string("DT_OBJECT_CONVERTER.populate_dt_from_object: (normal complex type)%N")
										end
										-- it's a normal complex object
										create a_dt_attr.make_single(fld_name)
										populate_dt_from_object(fld_val, create_complex_object_node(a_dt_attr, Void),a_path+"/"+fld_name)
										a_dt_obj.put_attribute(a_dt_attr)
									end
								end
							else
								-- dadl_decoded object
								if fld_decoded.is_generic and then check_generic_decoded_object(fld_decoded) then
									l_path := path_to_shared_obj(fld_val)
									if  l_path /= void then
										create a_dt_attr.make_single(fld_name)
										from_shared_obj_primitive_type(a_dt_attr,l_path,void,fld_val.generating_type)
										a_dt_obj.put_attribute(a_dt_attr)
									else
										remember_object(fld_decoded,a_path +"/"+fld_name)
										create a_dt_attr.make_multiple(fld_name)

										create_dt_from_special_decoded_obj(a_dt_attr, fld_decoded,a_path+"/"+fld_name)
										if not a_dt_attr.is_empty then
											if type_visible then
												a_dt_attr.set_attr_type (fld_decoded.name)
												a_dt_attr.show_type
											end
											a_dt_obj.put_attribute(a_dt_attr)
										end
									end
								else
									create a_dt_attr.make_single (fld_name)
									populate_dt_from_decoded_object(fld_decoded, create_complex_object_node(a_dt_attr,Void),a_path+"/"+fld_name)
									a_dt_obj.put_attribute(a_dt_attr)
								end
							end
						else
							-- void
							create a_dt_attr.make_single(fld_name)
							from_void_value (a_dt_attr, void)
							a_dt_obj.put_attribute(a_dt_attr)
						end

						l_list.forth
					end
				end

			end



		end



	populate_dt_from_object(an_obj:ANY; a_dt_obj:DT_COMPLEX_OBJECT_NODE;a_path:STRING) is
			-- make a data tree from an object
		local
			a_dt_attr: DT_ATTRIBUTE_NODE
			fld_val: ANY
			fld_dynamic_type,equiv_prim_type_id, i: INTEGER
			fld_name,l_path: STRING
			a_sequence: SEQUENCE[ANY]
			a_hash_table: HASH_TABLE [ANY, HASHABLE]
			a_array:ARRAY[ANY]
			dt_conv: DT_CONVERTIBLE
			fld_lst: ARRAYED_LIST[STRING]
			l_is_shared:BOOLEAN
		do
			if type_visible then
				a_dt_obj.show_type
			end
			a_dt_obj.set_type_name(an_obj.generating_type)
			debug ("DT")
				io.put_string("DT_OBJECT_CONVERTER.populate_dt_from_object: populating from a " +
					an_obj.generating_type + "%N")
			end

			l_path := path_to_shared_obj(an_obj)
			if  l_path /= void then
				-- object is shared
				create a_dt_attr.make_as_path(l_path)
				a_dt_obj.put_attribute(a_dt_attr)
			else
				-- object is not shared
				remember_object(an_obj,a_path)

				-- it is a generic object itself, have to deal with specially
				a_hash_table ?= an_obj
				a_sequence ?= an_obj
				a_array ?= an_obj

				if a_hash_table /= Void or a_sequence /= Void or a_array /= void or is_special (an_obj) or is_tuple (an_obj) then
					l_path := a_path
					if a_dt_obj.attributes.count = 0 and a_dt_obj.parent = void then
						-- just storing a simple object, e.g serialize(LINKED_LIST[INTEGER])
						-- generic object would not be enclosed by normal object otherwise
						create a_dt_attr.make_multiple(format_placeholder_string)
						l_path := l_path + "/" + format_placeholder_string
					else
						create a_dt_attr.make_multiple_generic
					end
					create_dt_from_generic_obj(a_dt_attr, an_obj,l_path)
					if type_visible then
						a_dt_attr.set_attr_type (an_obj.generating_type)
						a_dt_attr.show_type
					end
					a_dt_obj.put_attribute(a_dt_attr)
				else -- its not a container object
					dt_conv ?= an_obj
					if dt_conv /= Void then
						-- backwards compatibility
						fld_lst := dt_conv.persistent_attributes
					else
						-- new way of specifing a custom serialization
						fld_lst := custom_serialization_list
					end
					from
						i := 1
					until
						i > field_count(an_obj)
					loop
						fld_val := field(i, an_obj)
						fld_name := field_name(i, an_obj)
						if fld_lst = Void or else fld_lst.has(fld_name) then
							if fld_val /= Void then
								debug ("DT")
									io.put_string("DT_OBJECT_CONVERTER.populate_dt_from_object: field_name = " + fld_name + "%N")
								end
								fld_dynamic_type := dynamic_type(fld_val)
								equiv_prim_type_id := any_primitive_conforming_type(fld_dynamic_type)
								if equiv_prim_type_id /= 0 then
									l_is_shared := false
									if not is_primitive_type (fld_dynamic_type) or fld_val.generating_type.starts_with ("STRING") then
										l_path := path_to_shared_obj(fld_val)
										if  l_path /= void then
											l_is_shared := true
											create a_dt_attr.make_single(fld_name)
											from_shared_obj_primitive_type(a_dt_attr,l_path,void,fld_val.generating_type)
											a_dt_obj.put_attribute(a_dt_attr)
										else
											remember_object(fld_val,a_path+"/"+fld_name)
										end
									end
									if not l_is_shared then
										create a_dt_attr.make_single(fld_name)
										populate_prim_type_attribute(an_obj, a_dt_attr, fld_val, equiv_prim_type_id)
										a_dt_obj.put_attribute(a_dt_attr)
									end
								else -- its a complex object, or else a SEQUENCE,SPECIAL,ARRAY,TUPLE or HASH_TABLE of a complex object
									debug ("DT")
										io.put_string("DT_OBJECT_CONVERTER.populate_dt_from_object: (complex or container type)%N")
									end
									a_hash_table ?= fld_val
									a_sequence ?= fld_val
									a_array ?= fld_val
									if a_hash_table /= Void or a_sequence /= Void or a_array /= void or is_special (fld_val) or is_tuple (fld_val) then
										debug ("DT")
											io.put_string("DT_OBJECT_CONVERTER.populate_dt_from_object: (container type)%N")
										end
										l_path := path_to_shared_obj(fld_val)
										if  l_path /= void then
											create a_dt_attr.make_single(fld_name)
											from_shared_obj_primitive_type(a_dt_attr,l_path,void,fld_val.generating_type)
											a_dt_obj.put_attribute(a_dt_attr)
										else
											remember_object(fld_val,a_path +"/"+fld_name)
											create a_dt_attr.make_multiple(fld_name)

											create_dt_from_generic_obj(a_dt_attr, fld_val,a_path+"/"+fld_name)
											if not a_dt_attr.is_empty then
												if type_visible then
													a_dt_attr.set_attr_type (fld_val.generating_type)
													a_dt_attr.show_type
												end
												a_dt_obj.put_attribute(a_dt_attr)
											end
										end
									else
										debug ("DT")
											io.put_string("DT_OBJECT_CONVERTER.populate_dt_from_object: (normal complex type)%N")
										end
										-- it's a normal complex object
										create a_dt_attr.make_single(fld_name)
										populate_dt_from_object(fld_val, create_complex_object_node(a_dt_attr, Void),a_path+"/"+fld_name)
										a_dt_obj.put_attribute(a_dt_attr)
									end
								end
							else
								-- void
								create a_dt_attr.make_single(fld_name)
								from_void_value (a_dt_attr, void)
								a_dt_obj.put_attribute(a_dt_attr)
							end
						end
						i := i + 1
					end
				end
			end
		end

	populate_prim_type_attribute(an_obj:ANY; a_dt_attr: DT_ATTRIBUTE_NODE; fld_val:ANY; equiv_prim_type_id: INTEGER) is
			-- FIXME: this routine exists because of the Eiffel expanded
			-- non-conformance problem. It has been made a separate
			-- routine to allow exception handling to function properly
		local
			-- FIXME: all this code just to handle expanded nonconformance of INTERVAL[INTEGER] -> INTERVAL[PART_COMPARABLE]
			-- REMOVE when this problem fixed
			oe_int_real: INTERVAL_EHR[REAL]
			oe_int_integer: INTERVAL_EHR[INTEGER]
			exception_caught: BOOLEAN
			a_seq:SEQUENCE[ANY]
			a_hash_table:HASH_TABLE[ANY,HASHABLE]
		do
			if not exception_caught then
				debug ("DT")
					io.put_string("DT_OBJECT_CONVERTER.populate_dt_from_object: (primitive type)%N")
					io.put_string("%T from_obj_proc.call([DT_ATTRIBUTE_NODE(" +
						a_dt_attr.rm_attr_name + "), " + fld_val.generating_type + ", Void)%N")
				end
				a_seq ?= fld_val
				a_hash_table ?= fld_val
				if a_seq /= void then
					cvt_tbl.item(equiv_prim_type_id).from_obj_proc.call([a_dt_attr, a_seq, Void])
				elseif a_hash_table /= void then
					cvt_tbl.item(equiv_prim_type_id).from_obj_proc.call([a_dt_attr, a_hash_table, Void])
				else
					cvt_tbl.item(equiv_prim_type_id).from_obj_proc.call([a_dt_attr, fld_val, Void])
				end

				debug ("DT")
					io.put_string("%T(return)%N")
				end
			else
				-- FIXME: all this code just to handle expanded nonconformance of INTERVAL[INTEGER] -> INTERVAL[PART_COMPARABLE]
				-- REMOVE when this problem fixed
				oe_int_integer ?= fld_val
				if oe_int_integer /= Void then
					debug ("DT")
						io.put_string("Using INTERVAL[INTEGER_REF] conversion%N")
					end
					cvt_tbl.item(equiv_prim_type_id).from_obj_proc.call([a_dt_attr,
						interval_integer_to_interval_integer_ref(oe_int_integer), Void])
				else
					oe_int_real ?= fld_val
					if oe_int_real /= Void then
						debug ("DT")
							io.put_string("Using INTERVAL[REAL_REF] conversion%N")
						end
						cvt_tbl.item(equiv_prim_type_id).from_obj_proc.call([a_dt_attr,
							interval_real_to_interval_real_ref(oe_int_real), Void])
					else
						debug ("DT")
							io.put_string("No conversion available%N")
						end
					end
				end
			end
		rescue
			if not exception_caught then
				if equiv_prim_type_id /= 0 then -- this must have been an argument type mismatch which killed the from_obj_proc.call[]
					post_error(Current, "populate_prim_type_attribute", "populate_dt_proc_arg_type_mismatch",
						<<type_name(an_obj), a_dt_attr.rm_attr_name, fld_val.generating_type, type_name_of_type(equiv_prim_type_id)>>)
				end
				exception_caught := True
				retry
			else
				post_error(Current, "populate_prim_type_attribute", "unhandled_exception", <<"Failed to convert type">>)
			end
		end

	decode_dt_from_unknown_object(a_dt_obj: DT_COMPLEX_OBJECT_NODE):DADL_DECODED is
			-- type is unknown to system
			-- deserialize attributes and store them in a decoded object
		require
			non_void_dt: a_dt_obj /= void
			is_typed: a_dt_obj.is_typed
		local
			a_dt_attr: DT_ATTRIBUTE_NODE
			a_dt_obj_leaf: DT_OBJECT_LEAF
			fld_name,l_path,l_curr_path: STRING
			fld_type_id, i: INTEGER
			a_gen_field,a_obj,l_shared_obj: ANY
			l_type_name,l_fld_type_name:STRING
			l_attr_count,l_type:INTEGER
			l_is_generic:BOOLEAN
			l_dec:DADL_DECODED
			l_complex_node:DT_COMPLEX_OBJECT_NODE
			l_dt_attr:DT_ATTRIBUTE_NODE
			l_go_for_generic:BOOLEAN
		do
			l_path := path_stack.item
			l_type_name := a_dt_obj.rm_type_name
			l_attr_count := a_dt_obj.attributes.count
			a_dt_obj.start
			if root_dt_holder.is_empty then
				-- we have a direct call with as_object on a dt_complex_object_node not with dt_to_object
				root_dt_holder.extend (a_dt_obj)
			end
			l_dec ?= shared_obj_from_path(l_path)
			if l_dec /= void then
				result := l_dec
			else
				create result.make_by_name(get_next_object_id,l_type_name)
				if l_type_name.starts_with ("SPECIAL[") then
					result.set_is_special
					result.set_special_count(a_dt_obj.item.child_count+1)
				elseif l_type_name.starts_with ("TUPLE[") then
					result.set_is_tuple
				end
				if l_type_name.has ('[') then
					l_is_generic := true
				end

				-- remember object to find shared objects / and also for cyclic object structures
				remember_object(Result,path_stack.item)


				-- additional check needed
				--check whether object is generic or not
				if a_dt_obj.attributes.count = 1 and l_is_generic then
					a_dt_attr := a_dt_obj.item
					if a_dt_attr.representation.node_id.is_equal (a_dt_attr.representation.generic_attr_name) then
						l_go_for_generic := true
					end
				end

				if l_go_for_generic then
					a_dt_attr := a_dt_obj.item
					path_stack.put (l_path+"/"+a_dt_attr.representation.node_id)
					if result.is_special then
						set_special_unknown_object_data_from_dt(result,a_dt_attr)
					elseif result.is_tuple then
						set_tuple_unknown_object_data_from_dt(result,a_dt_attr)
					else
						set_generic_unknown_object_data_from_dt(result,a_dt_attr)
					end
					path_stack.remove
				else
					-- for each field in the object
					from
						i := 1
						a_dt_obj.start
					until
						a_dt_obj.off
					loop
						fld_name := a_dt_obj.item.rm_attr_name
						l_curr_path := l_path+"/"+fld_name
						path_stack.put (l_curr_path)
						a_obj := shared_obj_from_path(l_curr_path)
						if a_obj /= void then
							--shared object
							result.insert_actual_attribute(fld_name,a_obj)
						else
							a_dt_attr := a_dt_obj.item
							l_fld_type_name := a_dt_attr.rm_type_name
							if l_fld_type_name = void then
								l_fld_type_name := a_dt_attr.first_child.rm_type_name
							end
							fld_type_id := dynamic_type_from_string (l_fld_type_name)
							if fld_type_id >= 0 then
								--known type to system
								a_gen_field := set_object_data_from_dt_attribute(a_dt_attr,void,i,fld_type_id,l_curr_path)
								if a_gen_field /= void then
									-- not a primitive type of any form
									result.insert_actual_attribute (fld_name, a_gen_field)
								else
									--primitive type
									a_dt_attr.start
									a_dt_obj_leaf ?= a_dt_attr.item
									if a_dt_obj_leaf /= Void then
										if a_dt_obj_leaf.value = void then
											result.insert_actual_attribute (fld_name, void)
										elseif is_primitive_type (fld_type_id) then
											a_gen_field := get_correct_primitive_type(a_dt_obj_leaf.value,l_fld_type_name)
											result.insert_actual_attribute (fld_name, a_gen_field)
										elseif is_primitive_sequence_conforming_type (fld_type_id) then
											a_gen_field := set_primitive_sequence_data(fld_type_id,a_dt_obj_leaf.value)
											remember_object(a_gen_field,l_curr_path)
											result.insert_actual_attribute (fld_name, a_gen_field)
										elseif is_primitive_interval_type (fld_type_id) then
											-- not converting from REF type to something else
											-- Eiffel should fix all this expanded and REF chaos
											result.insert_actual_attribute (fld_name, a_dt_obj_leaf.value)
										end
									end
								end
							else
								--unknown type
								if a_dt_attr.is_multiple and not a_dt_attr.is_empty then
									create l_dec.make_by_name (get_next_object_id,l_fld_type_name)
									if l_fld_type_name.starts_with ("SPECIAL[")  then
										l_dec.set_is_special
										l_dec.set_special_count (a_dt_attr.child_count+1)
										set_special_unknown_object_data_from_dt(l_dec,a_dt_attr)
									elseif l_fld_type_name.starts_with ("TUPLE[") then
										l_dec.set_is_tuple
										set_tuple_unknown_object_data_from_dt(l_dec,a_dt_attr)
									elseif l_fld_type_name.has ('[') then
										-- could be container object or user defined generic object
										set_generic_unknown_object_data_from_dt(l_dec,a_dt_attr)
									end
									remember_object(l_dec,l_curr_path)
									result.insert_actual_attribute (fld_name, l_dec)
								else
									a_dt_attr.start
									a_dt_obj_leaf ?= a_dt_attr.item
									l_complex_node ?= a_dt_attr.first_child
									if a_dt_obj_leaf /= Void and then {l_path_obj:OG_PATH} a_dt_obj_leaf.value then
										--check if path object
										--shared object
										l_curr_path := l_path_obj.as_string
										if root_dt_holder.i_th (1).has_path (l_curr_path) then
											l_shared_obj := shared_obj_from_path(l_curr_path)
											if l_shared_obj /= Void then
												result.insert_actual_attribute (fld_name, l_shared_obj)
											else
												l_dt_attr := root_dt_holder.i_th (1).attribute_node_at_path (l_curr_path)
												path_stack.put (l_curr_path)
												l_type_name := l_dt_attr.rm_type_name
												if l_type_name = void then
													l_type_name := l_dt_attr.first_child.rm_type_name
												end
												l_type := dynamic_type_from_string (l_type_name)
												if l_type >= 0 then
													--known type
													l_shared_obj := l_dt_attr.first_child.as_object(l_type)
													remember_object(l_shared_obj,l_curr_path)
													result.insert_actual_attribute (fld_name, l_shared_obj)
												else
													l_complex_node ?= l_dt_attr.first_child
													if l_complex_node /= void then
														l_dec := decode_dt_from_unknown_object(l_complex_node)
														remember_object(l_dec,l_curr_path)
														result.insert_actual_attribute (fld_name, l_dec)
													else
														-- unknown object is not parsed as complex object node
														-- user defined simple/expanded type?!
														check
															false
														end
													end
												end
												path_stack.remove
											end
										else
											--TODO
											-- error: path does not exist
										end
									elseif l_complex_node /= void then
										--simple unknown object
										l_dec := decode_dt_from_unknown_object(l_complex_node)
										remember_object(l_dec,l_curr_path)
										result.insert_actual_attribute (fld_name, l_dec)
									else
										-- unknown object is not parsed as complex object node
										-- user defined simple/expanded type?!
										check
											false
										end
									end
								end
							end
						end
						path_stack.remove
						a_dt_obj.forth
						i := i + 1
					end
				end				--end
			end
		end

	set_object_data_from_dt_attribute(a_dt_attr:DT_ATTRIBUTE_NODE;a_obj:ANY;a_index,a_type_id:INTEGER;a_path:STRING):ANY is
			-- sets object data from a_dt_attr and returns result,if its a reference type
			-- returns void if its a primitive type and sets field directly
		local
			l_shared_obj:ANY
			l_type,equiv_prim_type_id:INTEGER
			a_dt_obj_leaf: DT_OBJECT_LEAF
			l_curr_path:STRING
			l_dt_attr:DT_ATTRIBUTE_NODE

		do
			if a_dt_attr.is_multiple and not a_dt_attr.is_empty then
				if is_container_type(a_type_id) then
					-- create container object
					Result := new_instance_of(a_type_id)

					--set_reference_field(a_index, a_obj, a_gen_field)

					-- FIXME: can only deal with one generic parameter for the moment
					set_generic_object_data_from_dt (Result, a_dt_attr)
					remember_object(Result,a_path)
				elseif is_tuple_type(a_type_id) then
					Result := new_instance_of(a_type_id)
					--set_reference_field(a_index, a_obj, a_gen_field)
					set_tuple_object_data_from_dt(Result,a_dt_attr)
					remember_object(Result,a_path)
				elseif is_special_any_type(a_type_id) then
					Result := new_special_any_instance(a_type_id,a_dt_attr.child_count)
					--set_reference_field(a_index, a_obj, a_gen_field)
					set_special_object_data_from_dt(Result,a_dt_attr)
					remember_object(Result,a_path)
				elseif is_special_type(a_type_id) then
					l_type := generic_dynamic_type_of_type (a_type_id, 1)
					Result ?= create_special_base_instance(l_type,a_dt_attr.child_count)
					--set_reference_field(a_index, a_obj, a_gen_field)
					set_special_object_data_from_dt(Result,a_dt_attr)
					remember_object(Result,a_path)
				else

					 check
					 	false
					 end
				end
			else
				a_dt_attr.start
				a_dt_obj_leaf ?= a_dt_attr.item
				if a_dt_obj_leaf /= Void then
					equiv_prim_type_id := any_primitive_conforming_type(a_type_id)
					if {l_path_obj:OG_PATH} a_dt_obj_leaf.value then
						--shared object
						l_curr_path := l_path_obj.as_string
						if root_dt_holder.i_th (1).has_path (l_curr_path) then
							l_shared_obj := shared_obj_from_path(l_curr_path)
							if l_shared_obj /= Void then
								--set_reference_field(a_index, a_obj, l_shared_obj)
								Result := l_shared_obj
							else
								l_dt_attr := root_dt_holder.i_th (1).attribute_node_at_path (l_curr_path)
								path_stack.put (l_curr_path)
								l_shared_obj := l_dt_attr.first_child.as_object(a_type_id)
								remember_object(l_shared_obj,l_curr_path)
								--set_reference_field(a_index, a_obj, l_shared_obj )
								Result := l_shared_obj
								path_stack.remove
							end
						else
							has_errors := true
							error_message := error_message + "%N" + "Path does not exist: " +l_curr_path
						end

					elseif equiv_prim_type_id /= 0 then

						if a_obj /= void then
							-- parent object is a known type; otherwise we can not set field there
							cvt_tbl.item(equiv_prim_type_id).from_dt_proc.call([a_index, a_obj, a_dt_obj_leaf.value])
						end
						Result := Void
					elseif a_dt_obj_leaf.value = void then
						Result := void
					else -- type implied in data is primitive, but it is not a primitive type in Eiffel class
						check
							false
						end
					end
				else -- must be a reference type field
					Result := a_dt_attr.item.as_object(a_type_id)
					remember_object(Result,a_path)
					--set_reference_field(a_index, a_obj,l_obj )
				end
			end
		end



	dt_to_object_internal(a_dt_obj: DT_COMPLEX_OBJECT_NODE; a_type_id: INTEGER): ANY is
			-- make an object whose classes and attributes correspond to the structure
			-- of this DT_OBJECT
		local
			a_dt_attr: DT_ATTRIBUTE_NODE
			a_dt_obj_leaf: DT_OBJECT_LEAF
			fld_name,l_path,l_curr_path: STRING
			fld_type_id, equiv_prim_type_id, i,l_type: INTEGER
			a_gen_field,a_obj: ANY
			a_dt_conv: DT_CONVERTIBLE
			exception_caught: BOOLEAN
		do
			l_path := path_stack.item
			if root_dt_holder.is_empty then
				-- we have a direct call with as_object on a dt_complex_object_node not with dt_to_object
				root_dt_holder.extend (a_dt_obj)
			end
			a_obj := shared_obj_from_path(l_path)
			if a_obj /= void then
				result := a_obj
			else
				if is_special_any_type(a_type_id) then
					-- FIXME: how to determine the length of the SPECIAL?
					-- fix approach by looking at the count of first attribute and count its children
					debug ("DT")
						io.put_string("DT_OBJECT_CONVERTER.dt_to_object: about to call new_special_any_instance(" +
							type_name_of_type(a_type_id) + ")%N")
					end
					a_dt_obj.start
					Result := new_special_any_instance(a_type_id,a_dt_obj.item.child_count+1)

					debug ("DT")
						io.put_string("%T(return)%N")
					end
				elseif is_special_type (a_type_id)  then
					a_dt_obj.start
					l_type := generic_dynamic_type_of_type (a_type_id, 1)
					Result := create_special_base_instance(l_type,a_dt_obj.item.child_count)
				else
					debug ("DT")
						io.put_string("DT_OBJECT_CONVERTER.dt_to_object: about to call new_instance_of(" +
							type_name_of_type(a_type_id) + ")%N")
					end
					Result := new_instance_of(a_type_id)
					debug ("DT")
						io.put_string("%T(return)%N")
					end

					-- FIXME: the following is a hacker's attempt to
					-- reliably call a reasonable make function? Should call at least 'default_create'
					-- Eiffel does not allow this at the moment.
					a_dt_conv ?= Result
					if a_dt_conv /= Void then
						a_dt_conv.make_dt
					end
				end

				if not exception_caught then
					-- remember object to find shared objects / and also for cyclic object structures
					remember_object(Result,path_stack.item)

					if generic_count_of_type(a_type_id) > 0 then
						-- we are on a generic object, and the correspoding DT object must
						-- have a single attribute which is_generic and is_multiple
						-- we don't go through its fields, instead we just go to the next
						-- object level down in the DT tree
						if not a_dt_obj.is_empty then
							a_dt_obj.start -- get first attribute
							a_dt_attr := a_dt_obj.item
							path_stack.put (l_path+"/"+a_dt_attr.representation.node_id)
							set_generic_object_data_from_dt (Result, a_dt_attr)
							path_stack.remove
						end
					else
						-- for each field in the object
						from
							i := 1
						until
							i > field_count(Result)
						loop
							fld_name := field_name(i, Result)
							l_curr_path := l_path+"/"+fld_name
							path_stack.put (l_curr_path)
							if a_dt_obj.has_attribute(fld_name) then
								a_obj := shared_obj_from_path(l_curr_path)
								if a_obj /= void then
									--shared object
									set_reference_field(i,Result,a_obj)
								else
									a_dt_attr := a_dt_obj.attribute_with_name(fld_name)

									fld_type_id := field_static_type_of_type(i, a_type_id)


									a_gen_field := set_object_data_from_dt_attribute(a_dt_attr,result,i,fld_type_id,l_curr_path)
									if a_gen_field /= void then
										if field_type(i, Result) = reference_type then
											-- set reference field
											set_reference_field(i, Result, a_gen_field)
											-- set_object_data method already remembers object, when needed
										elseif field_type(i, Result) = expanded_type then
											check
												expanded_field_set:false
											end
										end

									else
										-- its a primitive type
										-- remember it,when reference type
										if field_type_of_type (i, a_type_id) = reference_type and field (i, Result) /= void then
											remember_object(field (i, Result),l_curr_path)
										end
									end
								end
							end
							path_stack.remove
							i := i + 1
						end
					end
				end
			end
		rescue
			if equiv_prim_type_id /= 0 then -- this must have been an argument type mismatch which killed the from_dt_proc.call[]
				post_error(Current, "dt_to_object", "dt_proc_arg_type_mismatch",
					<<type_name_of_type(a_type_id), fld_name, type_name_of_type(fld_type_id), type_name(a_dt_obj_leaf.value)>>)
			end
			exception_caught := True
			retry
		end

	prim_object_to_dt(a_parent: DT_ATTRIBUTE_NODE; an_obj: ANY; a_node_id: STRING) is
		require
			Type_valid: has_primitive_type(an_obj)
			Obj_exists: an_obj /= Void
			Node_id_valid: a_node_id /= Void implies not a_node_id.is_empty
		do
			debug ("DT")
				io.put_string("DT_OBJECT_CONVERTER.prim_object_to_dt: from_obj_proc.call([DT_ATTRIBUTE_NODE(" +
					a_parent.rm_attr_name + "), " + an_obj.generating_type + ", [a_node_id])%N")
			end
			cvt_tbl.item(any_primitive_conforming_type(dynamic_type(an_obj))).from_obj_proc.call([a_parent, an_obj, a_node_id])
			debug ("DT")
				io.put_string("%T(return)%N")
			end
		end

feature {NONE} -- Conversin to object [unknown type]

	next_object_id:INTEGER
		-- represents the dynamic object id of the next parsed object


	get_next_object_id:INTEGER is
			-- returns the next object id
		do
			result := next_object_id
			next_object_id := next_object_id + 1
		end

	set_primitive_sequence_data (a_type:INTEGER;value: ANY):ANY is
			-- set i-th field of object which is some kind of sequence of a primitive type,
			-- from a value which is either an ARRAYED_LIST or a single object like a INTEGER_REF
		local
			al_val: ARRAYED_LIST[ANY]
			seq: SEQUENCE[ANY]
			val_type: INTEGER
		do
			val_type := dynamic_type(value)
			if val_type = a_type then
				--set_reference_field (i, object, value)
				Result := value
			else
				--convert to correct sequence type
				result := new_instance_of(a_type)
				seq ?= Result
				al_val ?= value
				if al_val /= Void then
					from
						al_val.start
					until
						al_val.off
					loop
						seq.extend(al_val.item)
						al_val.forth
					end
				else
					-- this means we have an object whose field type is a container, but
					-- where the dADL scanned as a single object - this happens with
					-- any list of one item. The dADL syntax is to use "<xx, ...>" to
					-- show it is a list, but this is often forgotten
					-- So...we do a conversion
					seq.extend(value)
				end
				Result := seq
			end
		end


	set_special_unknown_object_data_from_dt(a_decoded_obj:DADL_DECODED;a_dt_attr:DT_ATTRIBUTE_NODE) is
			-- set special values from an unknown type from a_dt_attr
		require
			non_void: a_decoded_obj /= void and a_dt_attr /= void
			valid: a_decoded_obj.is_special
		local
			l_path,l_id:STRING
			a_shared_obj:ANY
			l_curr_path,l_type_name:STRING
			l_dt_attr:DT_ATTRIBUTE_NODE
			l_dt_prim_obj:DT_PRIMITIVE_OBJECT
			l_path_obj:OG_PATH
			l_complex_node:DT_COMPLEX_OBJECT_NODE
			a_dt_obj_leaf: DT_OBJECT_LEAF
			l_dec:DADL_DECODED
		do
			l_path := path_stack.item
			a_dt_attr.start
			l_type_name := a_dt_attr.item.rm_type_name
			from
			until
				a_dt_attr.off
			loop
				l_id := a_dt_attr.item.node_id
				path_stack.put (l_path+"["+a_dt_attr.item.node_id+"]")
				l_dt_prim_obj ?= a_dt_attr.item
				if l_dt_prim_obj /= void and then l_dt_prim_obj.is_path then
					--shared object
					l_path_obj ?= l_dt_prim_obj.value
					l_curr_path := l_path_obj.as_string
					if root_dt_holder.i_th (1).has_path (l_curr_path) then
						a_shared_obj := shared_obj_from_path(l_curr_path)
						if a_shared_obj /= Void then
							a_decoded_obj.insert_actual_attribute (l_id, a_shared_obj)
						else
							l_dt_attr := root_dt_holder.i_th (1).attribute_node_at_path (l_curr_path)
							path_stack.put (l_curr_path)
							l_complex_node ?= l_dt_attr.item
							if l_complex_node /= void then
								l_dec := decode_dt_from_unknown_object(l_complex_node)
								remember_object(l_dec,l_curr_path)
								a_decoded_obj.insert_actual_attribute (l_id, l_dec)
							else
								-- unknown object is not parsed as complex object node
								-- user defined simple/expanded type?!
								check
									false
								end
							end
							path_stack.remove
						end
					else
						has_errors := true
						error_message := error_message + "%N" + "Path does not exist: " +l_curr_path
					end
				else
					l_complex_node ?= a_dt_attr.item
					a_dt_obj_leaf ?= a_dt_attr.item
					if l_complex_node /= void then
						l_dec := decode_dt_from_unknown_object(l_complex_node)
						a_decoded_obj.insert_actual_attribute (l_id, l_dec)
					elseif a_dt_obj_leaf /= void and then a_dt_obj_leaf.value = void then
						a_decoded_obj.insert_actual_attribute (l_id, void)
					else
						-- unknown object is not parsed as complex object node
						-- user defined simple/expanded type?!
						check
							false
						end
					end
				end
				path_stack.remove
				a_dt_attr.forth
			end
		end

	set_tuple_unknown_object_data_from_dt(a_decoded_obj:DADL_DECODED;a_dt_attr:DT_ATTRIBUTE_NODE) is
			-- set tuple values from an unknown type from a_dt_attr
		require
			non_void: a_decoded_obj /= void and a_dt_attr /= void
			valid: a_decoded_obj.is_tuple
		local
			l_type:INTEGER
			l_path,l_type_name,l_id:STRING
			l_gen_obj,a_shared_obj:ANY
			l_curr_path:STRING
			l_dt_attr:DT_ATTRIBUTE_NODE
			l_dt_prim_obj:DT_PRIMITIVE_OBJECT
			l_path_obj:OG_PATH
			l_complex_node:DT_COMPLEX_OBJECT_NODE
			a_dt_obj_leaf: DT_OBJECT_LEAF
			l_dec:DADL_DECODED
		do
			l_path := path_stack.item
			from
				a_dt_attr.start
			until
				a_dt_attr.off
			loop
				l_id := a_dt_attr.item.node_id
				path_stack.put (l_path+"["+a_dt_attr.item.node_id+"]")
				l_dt_prim_obj ?= a_dt_attr.item
				if l_dt_prim_obj /= void and then l_dt_prim_obj.is_path then
					--shared object
					l_path_obj ?= l_dt_prim_obj.value
					l_curr_path := l_path_obj.as_string
					if root_dt_holder.i_th (1).has_path (l_curr_path) then
						a_shared_obj := shared_obj_from_path(l_curr_path)
						if a_shared_obj /= Void then
							a_decoded_obj.insert_actual_attribute (l_id, a_shared_obj)
						else
							l_dt_attr := root_dt_holder.i_th (1).attribute_node_at_path (l_curr_path)
							path_stack.put (l_curr_path)
							l_type_name := l_dt_attr.rm_type_name
							if l_type_name = void then
								l_type_name := l_dt_attr.first_child.rm_type_name
							end
							l_type := dynamic_type_from_string (l_type_name)
							if l_type >= 0 then
								--known type
								a_shared_obj := l_dt_attr.first_child.as_object(l_type)
								remember_object(a_shared_obj,l_curr_path)
								a_decoded_obj.insert_actual_attribute (l_id, a_shared_obj)
							else
								l_complex_node ?= l_dt_attr.first_child
								if l_complex_node /= void then
									l_dec := decode_dt_from_unknown_object(l_complex_node)
									remember_object(l_dec,l_curr_path)
									a_decoded_obj.insert_actual_attribute (l_id, l_dec)
								else
									-- unknown object is not parsed as complex object node
									-- user defined simple/expanded type?!
									check
										false
									end
								end
							end
							path_stack.remove
						end
					else
						has_errors := true
						error_message := error_message + "%N" + "Path does not exist: " +l_curr_path
					end
				else
					l_type_name := a_dt_attr.item.rm_type_name
					l_type := dynamic_type_from_string (l_type_name)
					if l_type >= 0 then
						--known type
						l_gen_obj := a_dt_attr.item.as_object(l_type)
						a_decoded_obj.insert_actual_attribute (l_id, l_gen_obj)
					else
						--unknown type
						l_complex_node ?= a_dt_attr.item
						a_dt_obj_leaf ?= a_dt_attr.item
						if l_complex_node /= void then
							l_dec := decode_dt_from_unknown_object(l_complex_node)
							a_decoded_obj.insert_actual_attribute (l_id, l_dec)
						elseif a_dt_obj_leaf /= void and then a_dt_obj_leaf.value = void then
							a_decoded_obj.insert_actual_attribute (l_id, void)
						else
							-- unknown object is not parsed as complex object node
							-- user defined simple/expanded type?!
							check
								false
							end
						end
					end
				end

				path_stack.remove
				a_dt_attr.forth
			end
		end

	set_generic_unknown_object_data_from_dt(a_decoded_obj:DADL_DECODED;a_dt_attr:DT_ATTRIBUTE_NODE) is
			-- set generic values from an unknown type from a_dt_attr
		require
			non_void: a_decoded_obj /= void and a_dt_attr /= void
		local
			l_path,l_id:STRING
			a_shared_obj:ANY
			l_curr_path,l_type_name:STRING
			l_dt_attr:DT_ATTRIBUTE_NODE
			l_dt_prim_obj:DT_PRIMITIVE_OBJECT
			l_path_obj:OG_PATH
			l_complex_node:DT_COMPLEX_OBJECT_NODE
			a_dt_obj_leaf: DT_OBJECT_LEAF
			l_dec:DADL_DECODED
		do
			l_path := path_stack.item
			a_dt_attr.start
			l_type_name := a_dt_attr.item.rm_type_name
			from
			until
				a_dt_attr.off
			loop
				l_id := a_dt_attr.item.node_id
				path_stack.put (l_path+"["+a_dt_attr.item.node_id+"]")
				l_dt_prim_obj ?= a_dt_attr.item
				if l_dt_prim_obj /= void and then l_dt_prim_obj.is_path then
					--shared object
					l_path_obj ?= l_dt_prim_obj.value
					l_curr_path := l_path_obj.as_string
					if root_dt_holder.i_th (1).has_path (l_curr_path) then
						a_shared_obj := shared_obj_from_path(l_curr_path)
						if a_shared_obj /= Void then
							a_decoded_obj.insert_actual_attribute (l_id, a_shared_obj)
						else
							l_dt_attr := root_dt_holder.i_th (1).attribute_node_at_path (l_curr_path)
							path_stack.put (l_curr_path)
							l_complex_node ?= l_dt_attr.first_child
							if l_complex_node /= void then
								l_dec := decode_dt_from_unknown_object(l_complex_node)
								remember_object(l_dec,l_curr_path)
								a_decoded_obj.insert_actual_attribute (l_id, l_dec)
							else
								-- unknown object is not parsed as complex object node
								-- user defined simple/expanded type?!
								check
									false
								end
							end
							path_stack.remove
						end
					else
						has_errors := true
						error_message := error_message + "%N" + "Path does not exist: " +l_curr_path
					end
				else
					l_complex_node ?= a_dt_attr.item
					a_dt_obj_leaf ?= a_dt_attr.item
					if l_complex_node /= void then
						l_dec := decode_dt_from_unknown_object(l_complex_node)
						a_decoded_obj.insert_actual_attribute (l_id, l_dec)
					elseif a_dt_obj_leaf /= void and then a_dt_obj_leaf.value = void then
						a_decoded_obj.insert_actual_attribute (l_id, void)
					else
						-- unknown object is not parsed as complex object node
						-- user defined simple/expanded type?!
						check
							false
						end
					end
				end
				path_stack.remove
				a_dt_attr.forth
			end
		end


feature {NONE} -- Conversion to object [known type]


	set_special_object_data_from_dt (a_gen_obj:ANY; a_dt_attr: DT_ATTRIBUTE_NODE) is
			-- sets special values from a_dt_attr
		require
			Obj_exists: a_gen_obj /= Void
			Dt_attr_node_valid: a_dt_attr /= Void and then a_dt_attr.is_multiple
		local
			l_special:SPECIAL[ANY]
			l_id,gen_param_1_type_id:INTEGER
			l_path:STRING
			l_gen_obj,a_shared_obj:ANY
			l_curr_path:STRING
			l_dt_attr:DT_ATTRIBUTE_NODE
		do
			l_special ?= a_gen_obj
			l_path := path_stack.item
			gen_param_1_type_id := generic_dynamic_type(a_gen_obj, 1)
			if l_special /= void then
				from
					a_dt_attr.start
				until
					a_dt_attr.off
				loop
					l_id := a_dt_attr.item.node_id.to_integer_32
					path_stack.put (l_path+"["+a_dt_attr.item.node_id+"]")
					l_gen_obj := a_dt_attr.item.as_object (gen_param_1_type_id)
					if {l_path_obj:OG_PATH} l_gen_obj then
						--shared object
						l_curr_path := l_path_obj.as_string
						if root_dt_holder.i_th (1).has_path (l_curr_path) then
							a_shared_obj := shared_obj_from_path(l_curr_path)
							if a_shared_obj /= Void then
								l_special.put (a_shared_obj, l_id)
							else
								l_dt_attr := root_dt_holder.i_th (1).attribute_node_at_path (l_curr_path)
								path_stack.put (l_curr_path)
								a_shared_obj := l_dt_attr.first_child.as_object(gen_param_1_type_id)
								remember_object(a_shared_obj,l_curr_path)
								l_special.put (a_shared_obj, l_id)
								path_stack.remove
							end
						else
							has_errors := true
							error_message := error_message + "%N" + "Path does not exist: " +l_curr_path
						end
					else
						l_special.put (l_gen_obj, l_id)
					end

					path_stack.remove
					a_dt_attr.forth
				end
			end
		end

	set_tuple_object_data_from_dt (a_gen_obj:ANY; a_dt_attr: DT_ATTRIBUTE_NODE) is
			-- sets tuple values from a_dt_attr
		require
			Obj_exists: a_gen_obj /= Void
			Dt_attr_node_valid: a_dt_attr /= Void and then a_dt_attr.is_multiple
		local
			l_tuple:TUPLE
			l_id:INTEGER
			l_path:STRING
			l_gen_obj,a_shared_obj:ANY
			l_curr_path:STRING
			l_dt_attr:DT_ATTRIBUTE_NODE
		do
			l_tuple ?= a_gen_obj
			l_path := path_stack.item
			if l_tuple /= void then
				from
					a_dt_attr.start
				until
					a_dt_attr.off
				loop
					l_id := a_dt_attr.item.node_id.to_integer_32
					path_stack.put (l_path+"["+a_dt_attr.item.node_id+"]")
					l_gen_obj := a_dt_attr.item.as_object (dynamic_type_from_string (a_dt_attr.item.rm_type_name))
					if {l_path_obj:OG_PATH} l_gen_obj then
						--shared object
						l_curr_path := l_path_obj.as_string
						if root_dt_holder.i_th (1).has_path (l_curr_path) then
							a_shared_obj := shared_obj_from_path(l_curr_path)
							if a_shared_obj /= Void then
								l_tuple.put (a_shared_obj, l_id)
							else
								l_dt_attr := root_dt_holder.i_th (1).attribute_node_at_path (l_curr_path)
								path_stack.put (l_curr_path)
								a_shared_obj := l_dt_attr.first_child.as_object(dynamic_type_from_string (a_dt_attr.item.rm_type_name))
								remember_object(a_shared_obj,l_curr_path)
								l_tuple.put (a_shared_obj, l_id)
								path_stack.remove
							end
						else
							has_errors := true
							error_message := error_message + "%N" + "Path does not exist: " +l_curr_path
						end
					else
						l_tuple.put (l_gen_obj, l_id)
					end

					path_stack.remove
					a_dt_attr.forth
				end
			end
		end


	set_generic_object_data_from_dt (a_gen_obj:ANY; a_dt_attr: DT_ATTRIBUTE_NODE) is
			-- set generic values in a generic object, from a_dt_attr
			-- only deals with first generic parameter; generally safe for HASH_TABLE and LIST types, arrays, SPECIAL, tuples
		require
			Obj_exists: a_gen_obj /= Void
			Dt_attr_node_valid: a_dt_attr /= Void and then a_dt_attr.is_multiple
		local
			a_sequence: SEQUENCE[ANY]
			an_arrayed_list: ARRAYED_LIST[ANY]
			a_hash_table: HASH_TABLE [ANY, HASHABLE]
			gen_param_1_type_id: INTEGER
			l_gen_obj,l_actual_obj,a_shared_obj:ANY
			l_array:ARRAY[ANY]
			i:INTEGER
			l_path,l_curr_path:STRING
			l_dt_attr:DT_ATTRIBUTE_NODE
			l_path_obj:OG_PATH
		do
			gen_param_1_type_id := generic_dynamic_type(a_gen_obj, 1)
			l_path := path_stack.item
			-- determine dynamic type of generic type
			a_hash_table ?= a_gen_obj
			a_sequence ?= a_gen_obj
			l_array ?= a_gen_obj
			if a_hash_table /= Void then
				a_hash_table.make(0)
				from
					a_dt_attr.start
				until
					a_dt_attr.off
				loop
					-- FIXME: should check to see whether node_id should be converted to another type
					path_stack.put (l_path+"["+a_dt_attr.item.node_id+"]")
					l_gen_obj := a_dt_attr.item.as_object(gen_param_1_type_id)
					l_path_obj ?= l_gen_obj
					if l_path_obj /= void then
						--shared object
						l_curr_path := l_path_obj.as_string
						if root_dt_holder.i_th (1).has_path (l_curr_path) then
							a_shared_obj := shared_obj_from_path(l_curr_path)
							if a_shared_obj /= Void then
								a_hash_table.extend(a_shared_obj, a_dt_attr.item.node_id)
							else
								l_dt_attr := root_dt_holder.i_th (1).attribute_node_at_path (l_curr_path)
								path_stack.put (l_curr_path)
								a_shared_obj := l_dt_attr.first_child.as_object(gen_param_1_type_id)
								remember_object(a_shared_obj,l_curr_path)
								a_hash_table.extend(a_shared_obj, a_dt_attr.item.node_id)
								path_stack.remove
							end
						else
							has_errors := true
							error_message := error_message + "%N" + "Path does not exist: " +l_curr_path
						end
					else
						a_hash_table.extend(l_gen_obj, a_dt_attr.item.node_id)
					end
					path_stack.remove
					a_dt_attr.forth
				end
			elseif a_sequence /= Void then
				from
					a_dt_attr.start
				until
					a_dt_attr.off
				loop
					path_stack.put (l_path+"["+a_dt_attr.item.node_id+"]")
					l_actual_obj := a_dt_attr.item.as_object(gen_param_1_type_id)
					l_gen_obj := new_instance_of (gen_param_1_type_id)
					l_path_obj ?= l_actual_obj
					if l_path_obj /= void then
						--shared object
						l_curr_path := l_path_obj.as_string
						if root_dt_holder.i_th (1).has_path (l_curr_path) then
							a_shared_obj := shared_obj_from_path(l_curr_path)
							if a_shared_obj /= Void then
								a_sequence.extend(a_shared_obj)
							else
								l_dt_attr := root_dt_holder.i_th (1).attribute_node_at_path (l_curr_path)
								path_stack.put (l_curr_path)
								a_shared_obj := l_dt_attr.first_child.as_object(gen_param_1_type_id)
								if l_gen_obj.same_type (a_shared_obj) then
									-- the item.as_objt returns a correct objects which conforms to the expected object (no catcall)
									a_sequence.extend(a_shared_obj)
									remember_object(a_shared_obj,l_curr_path)
								else
									-- manually re-adjust correct object type
									-- due to the fixed type ARRAYED_LIST[....] from DADL2_VALIDATOR class
									-- will result in catcall otherwise
									an_arrayed_list ?= a_shared_obj
									if {a_temp_seq:SEQUENCE[ANY]} l_gen_obj and an_arrayed_list /= void then
										from
											an_arrayed_list.start
										until
											an_arrayed_list.after
										loop
											a_temp_seq.extend(an_arrayed_list.item)
											an_arrayed_list.forth
										end
										a_sequence.extend (a_temp_seq)
										remember_object(a_temp_seq,l_curr_path)
									end
								end
								path_stack.remove
							end
						else
							has_errors := true
							error_message := error_message + "%N" + "Path does not exist: " +l_curr_path
						end
					else
						--not a path to shared object
						l_curr_path := path_stack.item
						if l_gen_obj.same_type (l_actual_obj) then
							-- the item.as_objt returns a correct objects which conforms to the expected object (no catcall)
							a_sequence.extend(l_actual_obj)
							remember_object(l_actual_obj,l_curr_path)
						else
							-- manually re-adjust correct object type
							-- due to the fixed type ARRAYED_LIST[....] from DADL2_VALIDATOR class
							-- will result in catcall otherwise
							an_arrayed_list ?= l_actual_obj
							if {a_temp_seq2:SEQUENCE[ANY]} l_gen_obj and an_arrayed_list /= void then
								from
									an_arrayed_list.start
								until
									an_arrayed_list.after
								loop
									a_temp_seq2.extend(an_arrayed_list.item)
									an_arrayed_list.forth
								end
								a_sequence.extend (a_temp_seq2)
								remember_object(a_temp_seq2,l_curr_path)
							end
						end
					end
					path_stack.remove
					a_dt_attr.forth
				end
			elseif l_array /= void then
				l_array.make(1,a_dt_attr.child_count)
				from
					i := 1
					a_dt_attr.start
				until
					a_dt_attr.off
				loop
					path_stack.put (l_path+"["+a_dt_attr.item.node_id+"]")
					l_gen_obj ?= a_dt_attr.item.as_object(gen_param_1_type_id)
					l_path_obj ?= l_gen_obj
					if l_path_obj /= void then
						--shared object
						l_curr_path := l_path_obj.as_string
						if root_dt_holder.i_th (1).has_path (l_curr_path) then
							a_shared_obj := shared_obj_from_path(l_curr_path)
							if a_shared_obj /= Void then
								l_array.put(a_shared_obj, i)
							else
								l_dt_attr := root_dt_holder.i_th (1).attribute_node_at_path (l_curr_path)
								path_stack.put (l_curr_path)
								a_shared_obj := l_dt_attr.first_child.as_object(gen_param_1_type_id)
								remember_object(a_shared_obj,l_curr_path)
								l_array.put(a_shared_obj, i)
								path_stack.remove
							end
						else
							has_errors := true
							error_message := error_message + "%N" + "Path does not exist: " +l_curr_path
						end
					else
						l_array.put (l_gen_obj, i)
					end
					path_stack.remove
					a_dt_attr.forth
					i := i + 1
				end
			elseif {l_special:SPECIAL[ANY]} a_gen_obj  then
				set_special_object_data_from_dt(l_special,a_dt_attr)
			elseif {l_tuple:TUPLE[ANY]} a_gen_obj then
				set_tuple_object_data_from_dt(l_tuple,a_dt_attr)
			end
		end

	set_primitive_natural_field (i: INTEGER; object: ANY; value: ANY) is
		local
			l_nat8:NATURAL_8_REF
			l_nat16:NATURAL_16_REF
			l_nat32:NATURAL_32_REF
			l_nat64:NATURAL_64_REF
			l_int:INTEGER_32_REF
		do
			if dynamic_type (value) = dynamic_type_from_string ("INTEGER_32") then
				-- parser not distinguishes between naturals and integers
				l_int ?= value
				inspect field_type(i,object)
				when natural_32_type  then
					set_natural_32_field(i,object,l_int.as_natural_32)
				when natural_16_type  then
					set_natural_16_field(i,object,l_int.as_natural_16)
				when natural_8_type  then
					set_natural_8_field(i,object,l_int.as_natural_8)
				when natural_64_type  then
					set_natural_64_field(i,object,l_int.as_natural_64)
				else
					--ERROR
					check
						false
					end
				end
			elseif dynamic_type (value) = dynamic_type_from_string ("NATURAL_8") then
				l_nat8 ?= value
				set_natural_8_field(i,object,l_nat8)
			elseif dynamic_type (value) = dynamic_type_from_string ("NATURAL_16") then
				l_nat16 ?= value
				set_natural_16_field(i,object,l_nat16)
			elseif dynamic_type (value) = dynamic_type_from_string ("NATURAL_32") then
				l_nat32 ?= value
				set_natural_32_field(i,object,l_nat32)
			elseif dynamic_type (value) = dynamic_type_from_string ("NATURAL_64") then
				l_nat64 ?= value
				set_natural_64_field(i,object,l_nat64)
			else
				--ERROR
				check
					false
				end
			end
		end

	set_primitive_integer_field (i: INTEGER; object: ANY; value: ANY) is
		local
			l_int:INTEGER_REF
		do
			l_int ?= value
			set_integer_field (i, object, l_int)
		end

	set_primitive_real_field (i: INTEGER; object: ANY; value: ANY) is
		local
			l_real:REAL_REF
		do
			l_real ?= value
			set_real_field (i, object, l_real)
		end

	set_primitive_double_field (i: INTEGER; object: ANY; value: ANY) is
		local
			l_double:DOUBLE_REF
		do
			l_double ?= value
			set_double_field (i, object, l_double)
		end

	set_primitive_boolean_field (i: INTEGER; object: ANY; value: ANY) is
		local
			l_bool:BOOLEAN_REF
		do
			l_bool ?= value
			set_boolean_field (i, object, l_bool)
		end

	set_primitive_character_field (i: INTEGER; object: ANY; value: ANY) is
		local
			l_char:CHARACTER_REF
		do
			l_char ?= value
			set_character_field (i, object, l_char)
		end

	set_primitive_pointer_field (i: INTEGER; object: ANY; value: ANY) is
		local
			l_pointer:POINTER_REF
		do
			l_pointer ?= value
			set_pointer_field (i, object, l_pointer)
		end


	set_primitive_sequence_field (i: INTEGER; object: ANY; value: ANY) is
			-- set i-th field of object which is some kind of sequence of a primitive type,
			-- from a value which is either an ARRAYED_LIST or a single object like a INTEGER_REF
		require
			object_not_void: object /= Void
			index_large_enough: i >= 1
		local
			al_val, al_field: ARRAYED_LIST[ANY]
			seq: SEQUENCE[ANY]
			val_type, fld_type: INTEGER
		do
			val_type := dynamic_type(value)
			fld_type := field_static_type_of_type(i, dynamic_type(object))
			if val_type = fld_type then
				set_reference_field (i, object, value)
			else
				debug ("DT")
					io.put_string("DT_OBJECT_CONVERTER.set_primitive_sequence_field: about to call new_instance_of(" +
						type_name_of_type(fld_type) + ")%N")
				end
				set_reference_field (i, object, new_instance_of(fld_type))
				debug ("DT")
					io.put_string("%T(return)%N")
				end
				al_field ?= field(i, object)
				if al_field /= Void then
					al_field.make(0)
				end
				seq ?= field(i, object)
				al_val ?= value
				if al_val /= Void then
					from
						al_val.start
					until
						al_val.off
					loop
						seq.extend(al_val.item)
						al_val.forth
					end
				else
					-- this means we have an object whose field type is a container, but
					-- where the dADL scanned as a single object - this happens with
					-- any list of one item. The dADL syntax is to use "<xx, ...>" to
					-- show it is a list, but this is often forgotten
					-- So...we do a conversion
					seq.extend(value)
				end
			end
		end

	set_interval_integer_field (i: INTEGER; object: ANY; value: INTERVAL_EHR[INTEGER_REF]) is
			-- set INTERVAL[INTEGER] field in an object from a value of type INTERVAL[INTEGER_REF]
			-- FIXME: This routine only exists because of the difference between expanded and reference
		local
			fld_type: INTEGER
		do
			fld_type := field_static_type_of_type(i, dynamic_type(object))
			if dynamic_type(value) = fld_type then
				set_reference_field (i, object, value)
			else
				set_reference_field (i, object, interval_integer_ref_to_interval_integer(value))
			end
		end

	set_interval_real_field (i: INTEGER; object: ANY; value: INTERVAL_EHR[REAL_REF]) is
			-- set INTERVAL[REAL] field in an object from a value of type INTERVAL[REAL_REF]
			-- FIXME: This routine only exists because of the difference between expanded and reference
		local
			fld_type: INTEGER
		do
			fld_type := field_static_type_of_type(i, dynamic_type(object))
			if dynamic_type(value) = fld_type then
				set_reference_field (i, object, value)
			else
				set_reference_field (i, object, interval_real_ref_to_interval_real(value))
			end
		end

	set_interval_double_field (i: INTEGER; object: ANY; value: INTERVAL_EHR[DOUBLE_REF]) is
			-- set INTERVAL[DOUBLE] field in an object from a value of type INTERVAL[DOUBLE_REF]
			-- FIXME: This routine only exists because of the difference between expanded and reference
		local
			fld_type: INTEGER
		do
			fld_type := field_static_type_of_type(i, dynamic_type(object))
			if dynamic_type(value) = fld_type then
				set_reference_field (i, object, value)
			else
				set_reference_field (i, object, interval_double_ref_to_interval_double(value))
			end
		end

feature {NONE} -- Conversion from decoded object


	get_correct_primitive_type(an_obj:ANY;a_type_name:STRING):ANY is
			--
		local
			l_type_name:STRING
		do
			create l_type_name.make_from_string (a_type_name)
			l_type_name.replace_substring_all ("_REF", "")

			if l_type_name.is_equal ("INTEGER") then
				result := an_obj.out.to_integer
			elseif l_type_name.is_equal ("INTEGER_8") then
				result := an_obj.out.to_integer_8
			elseif l_type_name.is_equal ("INTEGER_16") then
				result := an_obj.out.to_integer_16
			elseif l_type_name.is_equal ("INTEGER_32") then
				result := an_obj.out.to_integer_32
			elseif l_type_name.is_equal ("INTEGER_64") then
				result := an_obj.out.to_integer_64
			elseif l_type_name.is_equal ("NATURAL") then
				result := an_obj.out.to_natural
			elseif l_type_name.is_equal ("NATURAL_8") then
				result := an_obj.out.to_natural_8
			elseif l_type_name.is_equal ("NATURAL_16") then
				result := an_obj.out.to_natural_16
			elseif l_type_name.is_equal ("NATURAL_32") then
				result := an_obj.out.to_natural_32
			elseif l_type_name.is_equal ("NATURAL_64") then
				result := an_obj.out.to_natural
			else
				result := an_obj
			end
		end


	check_generic_decoded_object(a_dec:GENERAL_DECODED):BOOLEAN is
			-- checks whether it is a generic object
			-- if it really conforms to something like
			-- ["1"] asdf
			-- ["2"] asdf2
		do
			if not a_dec.attribute_names.is_empty and then a_dec.attribute_names.first.is_integer then
				Result := True
			else
				Result := False
			end
		end


	create_dt_from_special_decoded_obj(a_dt_attr:DT_ATTRIBUTE_NODE;an_obj:GENERAL_DECODED;a_path:STRING) is
			--
		local
			l_list:ARRAYED_LIST[TUPLE[object:ANY;name:STRING]]
			l_tuple:TUPLE[object:ANY;name:STRING]
			l_item:ANY
			l_decoded:GENERAL_DECODED
			i:INTEGER
			l_start_path,l_path,l_curr_path:STRING
			l_is_shared:BOOLEAN
		do
			if a_path.ends_with ("]") then
				--insert generic attribute name
				l_start_path := a_path +"/"+a_dt_attr.representation.generic_attr_name
			else
				l_start_path := a_path
			end

			from
				l_list := an_obj.attribute_values
				l_list.start
				i := 1
			until
				l_list.after
			loop
				l_tuple ?= l_list.item
				l_item := l_tuple.object
				l_curr_path := l_start_path+"["+i.out+"]"
				if l_item /= void then
					l_decoded ?= l_item
					if l_decoded = void then
						if is_any_primitive_conforming_type(dynamic_type (l_item)) then
							if not is_primitive_type (dynamic_type (l_item)) or l_item.generating_type.starts_with ("STRING") then
								l_path := path_to_shared_obj (l_item)
								if l_path /= Void then
									l_is_shared := True
									from_shared_obj_primitive_type (a_dt_attr,l_path,i.out,l_item.generating_type)
								else
									l_is_shared := false
									remember_object (l_item,l_curr_path )
								end
							end
							if not l_is_shared then
								cvt_tbl.item(any_primitive_conforming_type(dynamic_type(l_item))).from_obj_proc.call([a_dt_attr,l_item, i.out])
							end
						else
							populate_dt_from_object(l_item,create_complex_object_node(a_dt_attr, i.out),l_curr_path)
						end
					else
						populate_dt_from_decoded_object(l_decoded,create_complex_object_node(a_dt_attr, i.out),l_curr_path)
					end
				end
				i := i+1
				l_list.forth
			end


		end


feature {NONE} -- Conversion from object

	create_dt_from_generic_obj(a_dt_attr: DT_ATTRIBUTE_NODE; an_obj: ANY; a_path:STRING) is
			-- generate DT structure from a generic object such as: SEQUENCE,SPECIAL,HASH_TABLE,ARRAY,TUPLE
		local
			generic_param_type,nb,i: INTEGER
			a_sequence: SEQUENCE[ANY]
			a_hash_table: HASH_TABLE [ANY, HASHABLE]
			a_special:SPECIAL[ANY]
			a_array:ARRAY[ANY]
			a_tuple:TUPLE
			l_item:ANY
			l_node:DT_COMPLEX_OBJECT_NODE
			l_is_shared:BOOLEAN
			l_path,l_curr_path,l_start_path:STRING
		do
			a_hash_table ?= an_obj
			a_sequence ?= an_obj
			a_special ?= an_obj
			a_tuple ?= an_obj
			a_array ?= an_obj

			generic_param_type := generic_dynamic_type(an_obj, 1)

			if a_path.ends_with ("]") then
				--insert generic attribute name
				l_start_path := a_path +"/"+a_dt_attr.representation.generic_attr_name
			else
				l_start_path := a_path
			end

			if a_hash_table /= Void then
				from
					a_hash_table.start
				until
					a_hash_table.off
				loop
					l_item ?= a_hash_table.item_for_iteration
					l_curr_path := l_start_path+"["+a_hash_table.key_for_iteration.out+"]"
					if l_item /= void then
						if is_any_primitive_conforming_type(dynamic_type (l_item)) then
							debug ("DT")
								io.put_string("DT_OBJECT_CONVERTER.create_dt_from_generic_obj: from_obj_proc.call([DT_ATTRIBUTE_NODE(" +
									a_dt_attr.rm_attr_name + "), " + l_item.generating_type +
									", " + a_hash_table.key_for_iteration.out + ")%N")
							end
							if not is_primitive_type (dynamic_type (l_item)) or l_item.generating_type.starts_with ("STRING") then
								l_path := path_to_shared_obj (l_item)
								if l_path /= Void then
									l_is_shared := True
									from_shared_obj_primitive_type (a_dt_attr,l_path,a_hash_table.key_for_iteration.out,l_item.generating_type)
								else
									l_is_shared := false
									remember_object (l_item,l_curr_path )
								end
							end
							if not l_is_shared then
								cvt_tbl.item(any_primitive_conforming_type(dynamic_type(l_item))).from_obj_proc.call([a_dt_attr,
									l_item, a_hash_table.key_for_iteration.out])
							end

							debug ("DT")
								io.put_string("%T(return)%N")
							end
						else
							populate_dt_from_object(l_item,
								create_complex_object_node(a_dt_attr, a_hash_table.key_for_iteration.out),l_curr_path)
						end
					else
						-- void
						from_void_value (a_dt_attr, a_hash_table.key_for_iteration.out)
					end
					a_hash_table.forth
				end
			elseif a_sequence /= Void then
				from
					a_sequence.start
				until
					a_sequence.off
				loop
					l_item ?= a_sequence.item
					l_curr_path := l_start_path+"["+a_sequence.index.out+"]"
					if l_item /= void then
						if is_any_primitive_conforming_type(dynamic_type (l_item)) then
							debug ("DT")
								io.put_string("DT_OBJECT_CONVERTER.create_dt_from_generic_obj(2): from_obj_proc.call([DT_ATTRIBUTE_NODE(" +
									a_dt_attr.rm_attr_name + "), " + l_item.generating_type +
									", " + a_sequence.index.out + ")%N")
							end
							if not is_primitive_type (dynamic_type (l_item)) or l_item.generating_type.starts_with ("STRING") then
								l_path := path_to_shared_obj (l_item)
								if l_path /= Void then
									l_is_shared := True
									from_shared_obj_primitive_type (a_dt_attr,l_path,a_sequence.index.out,l_item.generating_type)
								else
									l_is_shared := false
									remember_object (l_item,l_curr_path )
								end
							end
							if not l_is_shared then
								cvt_tbl.item(any_primitive_conforming_type(dynamic_type (l_item))).from_obj_proc.call([a_dt_attr,
									l_item, a_sequence.index.out])
							end
							debug ("DT")
								io.put_string("%T(return)%N")
							end
						else
							populate_dt_from_object(l_item, create_complex_object_node(a_dt_attr, a_sequence.index.out),l_curr_path)
						end
					else
						-- void
						from_void_value (a_dt_attr, a_sequence.index.out)
					end
					a_sequence.forth
				end
			elseif a_special /= void then
				from
					nb := a_special.count
					i := 0
				until
					nb = i
				loop
					l_item ?= a_special.item (i)
					l_curr_path := l_start_path+"["+i.out+"]"
					if l_item /= void then
						if is_any_primitive_conforming_type(dynamic_type (l_item)) then
							if not is_primitive_type (dynamic_type (l_item)) or l_item.generating_type.starts_with ("STRING") then
								l_path := path_to_shared_obj (l_item)
								if l_path /= Void then
									l_is_shared := True
									from_shared_obj_primitive_type (a_dt_attr,l_path,i.out,l_item.generating_type)
								else
									l_is_shared := false
									remember_object (l_item,l_curr_path )
								end
							end
							if not l_is_shared then
								cvt_tbl.item(any_primitive_conforming_type(dynamic_type (l_item))).from_obj_proc.call([a_dt_attr,l_item, i.out])
							end
						else
							populate_dt_from_object(l_item,
								create_complex_object_node(a_dt_attr, i.out),l_curr_path)
						end
					else
						-- void
						from_void_value (a_dt_attr, i.out)
					end
					i := i + 1
				end
			elseif a_tuple /= void then
				from
					i := 1
					nb := a_tuple.count + 1
				until
					i = nb
				loop
					l_item ?= a_tuple.item (i)
					l_curr_path := l_start_path+"["+i.out+"]"
					if l_item /= void then
						if is_any_primitive_conforming_type(dynamic_type (l_item)) then
							if not is_primitive_type (dynamic_type (l_item)) or l_item.generating_type.starts_with ("STRING") then
								l_path := path_to_shared_obj (l_item)
								if l_path /= Void then
									l_is_shared := True
									from_shared_obj_primitive_type (a_dt_attr,l_path,i.out,l_item.generating_type)
								else
									l_is_shared := false
									remember_object (l_item, l_curr_path)
								end
							end
							if not l_is_shared then
								cvt_tbl.item(any_primitive_conforming_type(dynamic_type (l_item))).from_obj_proc.call([a_dt_attr,l_item, i.out])
							end
						else
							-- force to show tuple type in DT -- otherwise problems when deserializing
							l_node := create_complex_object_node(a_dt_attr, i.out)
							l_node.show_type
							populate_dt_from_object(l_item,l_node,l_curr_path)
						end
					else
						-- void
						from_void_value (a_dt_attr, i.out)
					end
					i := i + 1
				end
			elseif a_array /= void then
				from
					i := 1
					nb := a_array.count + 1
				until
					i = nb
				loop
					l_item ?= a_array.item (i)
					l_curr_path := l_start_path+"["+i.out+"]"
					if l_item /= void then
						if is_any_primitive_conforming_type(dynamic_type (l_item)) then
							--from_obj_primitive_type(a_dt_attr, a_tuple.item (i), i.out)
							if not is_primitive_type (dynamic_type (l_item)) or l_item.generating_type.starts_with ("STRING") then
								l_path := path_to_shared_obj (l_item)
								if l_path /= Void then
									l_is_shared := True
									from_shared_obj_primitive_type (a_dt_attr,l_path,i.out,l_item.generating_type)
								else
									l_is_shared := false
									remember_object (l_item, l_curr_path)
								end
							end
							if not l_is_shared then
								cvt_tbl.item(any_primitive_conforming_type(dynamic_type (l_item))).from_obj_proc.call([a_dt_attr,l_item, i.out])
							end
						else
							populate_dt_from_object(l_item, create_complex_object_node(a_dt_attr, i.out),l_curr_path)
						end
					else
						-- void
						from_void_value (a_dt_attr, i.out)
					end
					i := i + 1
				end
			end
		end


	from_shared_obj_primitive_type(a_parent: DT_ATTRIBUTE_NODE; a_path: STRING; a_node_id:STRING;a_type_name:STRING) is
		local
			l_dt_obj: DT_PRIMITIVE_OBJECT
			l_path_obj:OG_PATH
		do
			create l_path_obj.make_from_string (a_path)
			if a_node_id /= void then
				create l_dt_obj.make_identified (l_path_obj, a_node_id)
			else
				create l_dt_obj.make_anonymous (l_path_obj)
			end
			l_dt_obj.set_type_name (a_type_name)
			if type_visible then
				l_dt_obj.show_type
			end
			a_parent.put_child (l_dt_obj)
		end

	from_void_value(a_parent: DT_ATTRIBUTE_NODE; a_node_id: STRING) is
		local
			a_dt_obj: DT_PRIMITIVE_OBJECT
		do
			if a_node_id /= Void then
				create a_dt_obj.make_identified (void, a_node_id)
			else
				create a_dt_obj.make_anonymous (void)
			end
			a_parent.put_child (a_dt_obj)
			if type_visible then
				a_dt_obj.show_type
			end
		end

	from_obj_primitive_type(a_parent: DT_ATTRIBUTE_NODE; an_obj: ANY; a_node_id: STRING) is
		local
			a_dt_obj: DT_PRIMITIVE_OBJECT
		do
			debug("DT")
				io.put_string("--->ENTER from_obj_primitive_type(DT_ATTIBUTE_NODE, " +
							an_obj.generating_type + ", [a_node_id])%N")
			end
			a_dt_obj := create_primitive_object(a_parent, an_obj, a_node_id)
			if type_visible then
				a_dt_obj.show_type
			end
			debug("DT")
				io.put_string("<---EXIT from_obj_primitive_type%N")
			end
		end

	from_obj_sequence_primitive_type(a_parent: DT_ATTRIBUTE_NODE; an_obj: ANY; a_node_id: STRING) is
		local
			a_dt_obj: DT_PRIMITIVE_OBJECT_LIST
			a_seq:SEQUENCE[ANY]
		do
			debug("DT")
				io.put_string("--->ENTER from_obj_sequence_primitive_type(DT_ATTIBUTE_NODE, " +
							an_obj.generating_type + ", [node_id])%N")
			end
			a_seq ?= an_obj -- prevent catcall error (do cast here and define header just as ANY)
			if a_node_id /= Void then
				create a_dt_obj.make_identified(a_seq, a_node_id)
			else
				create a_dt_obj.make_anonymous(a_seq)
			end
			if type_visible then
				a_dt_obj.show_type
			end
			a_parent.put_child(a_dt_obj)
			debug("DT")
				io.put_string("<---EXIT from_obj_sequence_primitive_type%N")
			end
		end

	from_obj_interval_primitive_type(a_parent: DT_ATTRIBUTE_NODE; an_obj: INTERVAL_EHR[PART_COMPARABLE]; a_node_id: STRING) is
		local
			a_dt_obj: DT_PRIMITIVE_OBJECT_INTERVAL
		do
			debug("DT")
				io.put_string("--->ENTER from_obj_interval_primitive_type(DT_ATTIBUTE_NODE, " +
							an_obj.generating_type + ", [a_node_id])%N")
			end
			if a_node_id /= Void then
				create a_dt_obj.make_identified(an_obj, a_node_id)
			else
				create a_dt_obj.make_anonymous(an_obj)
			end
			if type_visible then
				a_dt_obj.show_type
			end
			a_parent.put_child(a_dt_obj)
			debug("DT")
				io.put_string("<---EXIT from_obj_interval_primitive_type%N")
			end
		end

feature {NONE} -- Implementation

	format_placeholder_string:STRING is "placeholder"
		-- string used to guarantee correct dADL syntax

	root_object_path:STRING is "/"
		-- path string for objects which share the root

	custom_serialization_list:ARRAYED_LIST[STRING]
		-- list which specified which attributes to store

	path_stack:LINKED_STACK[STRING]
		-- keep track of current path
		once
			create result.make
		end

	root_dt_holder:LINKED_LIST[DT_COMPLEX_OBJECT_NODE]
		-- holds the root complex object node of a dADL structure
		once
			create result.make
		end

	obj_paths:LINKED_LIST[STRING]
		-- stores the object paths which are already serialized / deserialized
		once
			create result.make
			result.compare_objects
		end

	obj_storage:LINKED_LIST[ANY]
		-- stores the objects which are already serialized / deserialized
		once
			create result.make
		end

	path_to_shared_obj(a_obj:ANY):STRING is
			-- returns path to shared object if any
			-- otherwise result is VOID
		local
			l_index:INTEGER
		do
			l_index := obj_storage.index_of (a_obj, 1)
			if l_index /= 0 then
				Result := obj_paths @ l_index
			else
				Result := Void
			end
		end

	shared_obj_from_path(a_path:STRING):ANY is
			-- returns object at this path if any
			-- otherwise result is VOID
		local
			l_index:INTEGER
		do
			l_index := obj_paths.index_of (a_path, 1)
			if l_index /= 0 then
				Result := obj_storage @ l_index
			else
				Result := Void
			end
		end


	remember_object(a_obj:ANY;a_path:STRING) is
			-- remembers object - to compare later on for shared object existence
		require
			a_obj_not_void: a_obj /= void
		do
			if a_path.is_empty then
				obj_paths.extend (root_object_path)
			else
				obj_paths.extend(a_path)
			end
			obj_storage.extend(a_obj)
		end

	clear_all is
			-- clears internal data for next conversion
		do
			root_dt_holder.wipe_out
			obj_storage.wipe_out
			obj_paths.wipe_out
			path_stack.wipe_out
			next_object_id := 1
		end

	clear_error is
			-- removes all previous errors
		do
			conversion_successful := false
			has_errors := false
			conversion_error_message := void
			error_message := void
		end


	create_special_base_instance(a_type,a_count:INTEGER):SPECIAL[ANY] is
			-- creates instance of SPECIAL[ "any base type" ] e.g SPECIAL[INTEGER]
		local
			l_spec_mapping: like special_type_mapping
			l_spec_type:INTEGER
		do

			l_spec_mapping := special_type_mapping
			l_spec_mapping.search (a_type)
			if l_spec_mapping.found then
				l_spec_type := l_spec_mapping.found_item
			else
				l_spec_type := {INTERNAL}.reference_type
			end

			inspect l_spec_type
			when {INTERNAL}.boolean_type then
				result := create {SPECIAL[BOOLEAN]}.make (a_count)

			when {INTERNAL}.character_8_type then
				result := create {SPECIAL[CHARACTER_8]}.make (a_count)

			when {INTERNAL}.character_32_type then
				result := create {SPECIAL[CHARACTER_32]}.make (a_count)

			when {INTERNAL}.natural_8_type then
				result := create {SPECIAL[NATURAL_8]}.make (a_count)

			when {INTERNAL}.natural_16_type then
				result := create {SPECIAL[NATURAL_16]}.make (a_count)

			when {INTERNAL}.natural_32_type then
				result := create {SPECIAL[NATURAL_32]}.make (a_count)

			when {INTERNAL}.natural_64_type then
				result := create {SPECIAL[NATURAL_64]}.make (a_count)

			when {INTERNAL}.integer_8_type then
				result := create {SPECIAL[INTEGER_8]}.make (a_count)

			when {INTERNAL}.integer_16_type then
				result := create {SPECIAL[INTEGER_16]}.make (a_count)

			when {INTERNAL}.integer_32_type then
				result := create {SPECIAL[INTEGER_32]}.make (a_count)

			when {INTERNAL}.integer_64_type then
				result := create {SPECIAL[INTEGER_64]}.make (a_count)

			when {INTERNAL}.real_32_type then
				result := create {SPECIAL[REAL_32]}.make (a_count)

			when {INTERNAL}.real_64_type then
				result := create {SPECIAL[REAL_64]}.make (a_count)

			when {INTERNAL}.pointer_type then
				result := create {SPECIAL[POINTER]}.make (a_count)

			else
				-- should actually not happen - because case is tested before hand
				check an_item_type_valid: a_type = {INTERNAL}.reference_type end
				result := new_special_any_instance (a_type, a_count)
			end
		end


	cvt_tbl: HASH_TABLE [DT_CONV_DESC, INTEGER] is
		local
			a_dt_conv: DT_CONV_DESC
		once
			create Result.make (0)

			-- primitive types
			create a_dt_conv.make (agent from_obj_primitive_type (?, ?, ?), agent set_primitive_integer_field (?, ?, ?))
			Result.put (a_dt_conv, dynamic_type (create {INTEGER}))
			Result.put (a_dt_conv, dynamic_type (create {INTEGER_REF}))
			Result.put (a_dt_conv, dynamic_type_from_string ("INTEGER_32_REF"))
			Result.put (a_dt_conv, dynamic_type_from_string ("INTEGER_32"))
			Result.put (a_dt_conv, dynamic_type_from_string ("INTEGER_8"))
			Result.put (a_dt_conv, dynamic_type_from_string ("INTEGER_16"))
			Result.put (a_dt_conv, dynamic_type_from_string ("INTEGER_64"))


			create a_dt_conv.make (agent from_obj_primitive_type (?, ?, ?), agent set_primitive_natural_field (?, ?, ?))
			Result.put (a_dt_conv, dynamic_type (create {NATURAL}))
			Result.put (a_dt_conv, dynamic_type_from_string ("NATURAL_32"))
			Result.put (a_dt_conv, dynamic_type_from_string ("NATURAL_8"))
			Result.put (a_dt_conv, dynamic_type_from_string ("NATURAL_16"))
			Result.put (a_dt_conv, dynamic_type_from_string ("NATURAL_64"))
			Result.put (a_dt_conv, dynamic_type_from_string ("NATURAL_32_REF"))
			Result.put (a_dt_conv, dynamic_type_from_string ("NATURAL_16_REF"))
			Result.put (a_dt_conv, dynamic_type_from_string ("NATURAL_8_REF"))
			Result.put (a_dt_conv, dynamic_type_from_string ("NATURAL_64_REF"))


			create a_dt_conv.make (agent from_obj_primitive_type (?, ?, ?), agent set_primitive_boolean_field (?, ?, ?))
			Result.put (a_dt_conv, dynamic_type (create {BOOLEAN}))
			Result.put (a_dt_conv, dynamic_type (create {BOOLEAN_REF}))
			Result.put (a_dt_conv, dynamic_type_from_string ("BOOLEAN"))

			create a_dt_conv.make (agent from_obj_primitive_type (?, ?, ?), agent set_primitive_real_field (?, ?, ?))
			Result.put (a_dt_conv, dynamic_type (create {REAL}))
			Result.put (a_dt_conv, dynamic_type (create {REAL_REF}))
			Result.put (a_dt_conv, dynamic_type_from_string ("REAL_32"))

			create a_dt_conv.make (agent from_obj_primitive_type (?, ?, ?), agent set_primitive_double_field (?, ?, ?))
			Result.put (a_dt_conv, dynamic_type (create {DOUBLE}))
			Result.put (a_dt_conv, dynamic_type (create {DOUBLE_REF}))
			Result.put (a_dt_conv, dynamic_type_from_string ("REAL_64"))

			create a_dt_conv.make (agent from_obj_primitive_type (?, ?, ?), agent set_primitive_character_field (?, ?, ?))
			Result.put (a_dt_conv, dynamic_type (create {CHARACTER}))
			Result.put (a_dt_conv, dynamic_type (create {CHARACTER_REF}))
			Result.put (a_dt_conv, dynamic_type_from_string ("CHARACTER_8"))
			Result.put (a_dt_conv, dynamic_type_from_string ("CHARACTER_32"))

			create a_dt_conv.make (agent from_obj_primitive_type (?, ?, ?), agent set_primitive_pointer_field (?, ?, ?))
			Result.put (a_dt_conv, dynamic_type (create {POINTER}))
			Result.put (a_dt_conv, dynamic_type (create {POINTER_REF}))


			create a_dt_conv.make (agent from_obj_primitive_type (?, ?, ?), agent set_reference_field (?, ?, ?))
			Result.put (a_dt_conv, dynamic_type (create {STRING}.make_empty))
			Result.put (a_dt_conv, dynamic_type (create {DATE}.make_now))
			Result.put (a_dt_conv, dynamic_type (create {DATE_TIME}.make_now))
			Result.put (a_dt_conv, dynamic_type (create {TIME}.make_now))
			Result.put (a_dt_conv, dynamic_type (create {DATE_TIME_DURATION}.make_definite (1, 0, 0, 0)))
			Result.put (a_dt_conv, dynamic_type (create {URI}.make_from_string ("http://no.way.home")))
			Result.put (a_dt_conv, dynamic_type (create {CODE_PHRASE}))

			-- primitive sequence types
			from
				primitive_sequence_types.start
			until
				primitive_sequence_types.off
			loop
				create a_dt_conv.make (agent from_obj_sequence_primitive_type (?, ?, ?), agent set_primitive_sequence_field (?, ?, ?))
				Result.put (a_dt_conv, primitive_sequence_types.item)
				primitive_sequence_types.forth
			end

			-- primitive interval types
			create a_dt_conv.make (agent from_obj_interval_primitive_type (?, ?, ?), agent set_interval_integer_field (?, ?, ?))
			Result.put (a_dt_conv, dynamic_type (create {INTERVAL_EHR [INTEGER]}))

			create a_dt_conv.make (agent from_obj_interval_primitive_type (?, ?, ?), agent set_interval_real_field (?, ?, ?))
			Result.put (a_dt_conv, dynamic_type (create {INTERVAL_EHR [REAL]}))

			create a_dt_conv.make (agent from_obj_interval_primitive_type (?, ?, ?), agent set_interval_double_field (?, ?, ?))
			Result.put (a_dt_conv, dynamic_type (create {INTERVAL_EHR [DOUBLE]}))

			create a_dt_conv.make (agent from_obj_interval_primitive_type (?, ?, ?), agent set_reference_field (?, ?, ?))
			Result.put (a_dt_conv, dynamic_type (create {INTERVAL_EHR [DOUBLE_REF]}))
			Result.put (a_dt_conv, dynamic_type (create {INTERVAL_EHR [REAL_REF]}))
			Result.put (a_dt_conv, dynamic_type (create {INTERVAL_EHR [INTEGER_REF]}))
			Result.put (a_dt_conv, dynamic_type (create {INTERVAL_EHR [DATE]}))
			Result.put (a_dt_conv, dynamic_type (create {INTERVAL_EHR [DATE_TIME]}))
			Result.put (a_dt_conv, dynamic_type (create {INTERVAL_EHR [TIME]}))
			Result.put (a_dt_conv, dynamic_type (create {INTERVAL_EHR [DATE_TIME_DURATION]}))

--			from
--				primitive_interval_types.start
--			until
--				primitive_interval_types.off
--			loop
--				create a_dt_conv.make (agent from_obj_interval_primitive_type (?, ?, ?), agent set_primitive_interval_field (?, ?, ?))
--				Result.put (a_dt_conv, primitive_interval_types.item)
--				primitive_interval_types.forth
--			end
		end

	special_type_mapping: HASH_TABLE [INTEGER_32, INTEGER_32]
			-- Mapping betwwen dynamic type of SPECIAL instances
			-- to abstract element types.
		once
			create Result.make (10)
			Result.put ({INTERNAL}.boolean_type, dynamic_type_from_string ("BOOLEAN"))
			Result.put ({INTERNAL}.character_8_type, dynamic_type_from_string ("CHARACTER_8"))
			Result.put ({INTERNAL}.character_32_type, dynamic_type_from_string ("CHARACTER_32"))
			Result.put ({INTERNAL}.natural_8_type, dynamic_type_from_string ("NATURAL_8"))
			Result.put ({INTERNAL}.natural_16_type, dynamic_type_from_string ("NATURAL_16"))
			Result.put ({INTERNAL}.natural_32_type, dynamic_type_from_string ("NATURAL_32"))
			Result.put ({INTERNAL}.natural_64_type, dynamic_type_from_string ("NATURAL_64"))
			Result.put ({INTERNAL}.integer_8_type, dynamic_type_from_string ("INTEGER_8"))
			Result.put ({INTERNAL}.integer_16_type, dynamic_type_from_string ("INTEGER_16"))
			Result.put ({INTERNAL}.integer_32_type, dynamic_type_from_string ("INTEGER_32"))
			Result.put ({INTERNAL}.integer_64_type, dynamic_type_from_string ("INTEGER_64"))
			Result.put ({INTERNAL}.real_32_type, dynamic_type_from_string ("REAL_32"))
			Result.put ({INTERNAL}.real_64_type, dynamic_type_from_string ("REAL_64"))
			Result.put ({INTERNAL}.pointer_type, dynamic_type_from_string ("POINTER"))
		end

end


--|
--| ***** BEGIN LICENSE BLOCK *****
--| Version: MPL 1.1/GPL 2.0/LGPL 2.1
--|
--| The contents of this file are subject to the Mozilla Public License Version
--| 1.1 (the 'License'); you may not use this file except in compliance with
--| the License. You may obtain a copy of the License at
--| http://www.mozilla.org/MPL/
--|
--| Software distributed under the License is distributed on an 'AS IS' basis,
--| WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
--| for the specific language governing rights and limitations under the
--| License.
--|
--| The Original Code is dt_object_converter.e.
--|
--| The Initial Developer of the Original Code is Thomas Beale.
--| Portions created by the Initial Developer are Copyright (C) 2005
--| the Initial Developer. All Rights Reserved.
--|
--| Contributor(s):
--|
--| Alternatively, the contents of this file may be used under the terms of
--| either the GNU General Public License Version 2 or later (the 'GPL'), or
--| the GNU Lesser General Public License Version 2.1 or later (the 'LGPL'),
--| in which case the provisions of the GPL or the LGPL are applicable instead
--| of those above. If you wish to allow use of your version of this file only
--| under the terms of either the GPL or the LGPL, and not to allow others to
--| use your version of this file under the terms of the MPL, indicate your
--| decision by deleting the provisions above and replace them with the notice
--| and other provisions required by the GPL or the LGPL. If you do not delete
--| the provisions above, a recipient may use your version of this file under
--| the terms of any one of the MPL, the GPL or the LGPL.
--|
--| ***** END LICENSE BLOCK *****
--|
