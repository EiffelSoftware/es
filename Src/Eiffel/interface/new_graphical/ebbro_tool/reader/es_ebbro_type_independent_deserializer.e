note
	description: "Deserializer which can also handle objects of an unknown type."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_TYPE_INDEPENDENT_DESERIALIZER

inherit
	SED_INDEPENDENT_DESERIALIZER
		redefine
			read_header,make,
			decode_object,
			decode,
			read_object_table
		end

create
	make


feature -- creation

	make (a_deserializer: SED_READER_WRITER)
			-- init of reader
		do
			PRECURSOR(a_deserializer)
			next_object_id := 1
			create internal
		end

feature -- Access

	last_header_tuple:HASH_TABLE[STRING,INTEGER]

	first_header_part_offset:INTEGER

	internal: INTERNAL

feature -- basic operations

	decode (a_is_gc_enabled: BOOLEAN)
			-- Decode object graph stored in `deserializer'.
		local
			l_count: NATURAL_32
			l_mem: like memory
			l_is_collecting: BOOLEAN
			retried: BOOLEAN
			l_new_dtype:INTEGER
			l_attr_name:STRING
		do
			if not retried then
	--			has_error := False

					-- Read number of objects we are retrieving
				l_count := deserializer.read_compressed_natural_32
				create object_references.make_empty (l_count.to_integer_32 + 1)

					-- Disable GC as only new memory will be allocated.
				if not a_is_gc_enabled then
					l_mem := memory
					l_is_collecting := l_mem.collecting
					l_mem.collection_off
				end

					-- Read header of serialized data.
				read_header (l_count)

				if not has_error then
						-- Read data from `deserializer' in store it in `object_references'.
					decode_objects (l_count)
				end

				if not has_error then
					-- put reference objects to the right place (connect to attributes)
					from
						attribute_references.start
					until
						attribute_references.after
					loop

						l_new_dtype := attribute_references.item.integer_32_item (2)
						l_attr_name ?= attribute_references.item.item (3)
						decoded_object_storage.item (l_new_dtype).insert_actual_attribute (
							l_attr_name,
							object_references.item (attribute_references.item.integer_32_item (1)),
							attribute_references.item.integer_32_item (4))

						attribute_references.forth
					end
				end

			end
				-- Restore GC status
			if l_is_collecting then
				l_mem.collection_on
			end

				-- Clean data
			clear_internal_data

				--additional cleaning
			unknown_types.wipe_out
			generic_types.wipe_out
			decoded_object_storage.wipe_out
			attribute_references.wipe_out
			header_tuples.wipe_out
			next_object_id := 1
		rescue
			retried := True
			retry
		end

feature{NONE} -- Implementation


	next_object_id:INTEGER
			-- represents the dynamic object id of the next parsed object

	header_tuples:HASH_TABLE[STRING,INTEGER]
			-- all old_dtypes and strings in the header
		once
			create result.make(10)
		end

	unknown_types:ARRAYED_LIST[INTEGER]
			-- types which are unknown (old dtypes)
		once
			create result.make(10)
		end

	generic_types:HASH_TABLE[ES_EBBRO_UNIVERSAL_TYPE,INTEGER]
			-- all generic types (each one stands for an unknown type old dtype)
		once
			create result.make(10)
		end

	decoded_object_storage:HASH_TABLE[BINARY_DECODED,INTEGER]
			-- all decoded objects (hash is the new object id)
		once
			create result.make(10)
		end

	attribute_references:ARRAYED_LIST[TUPLE[ref_id:INTEGER;new_dtype:INTEGER;attr_name:STRING;generic_type:INTEGER]]
			-- list with all objects which have to be connected to the right decoded object attributes
		once
			create result.make(5)
		end

	get_next_object_id:INTEGER
			-- returns the next object id
		do
			result := next_object_id
			next_object_id := next_object_id + 1
		end

	read_header (a_count: NATURAL_32)
			-- Read header which contains mapping between dynamic type and their
			-- string representation.
		local
			i, nb: INTEGER
			l_deser: like deserializer
			l_int: like internal
			l_table: like dynamic_type_table
			l_old_dtype, l_new_dtype: INTEGER
			l_type_str: STRING
			l_gen_type:ES_EBBRO_UNIVERSAL_TYPE
		do
			l_int := internal
			l_deser := deserializer

				-- Number of dynamic types in storable
			nb := l_deser.read_compressed_natural_32.to_integer_32
			first_header_part_offset := nb
			create l_table.make_empty (nb)
			create attributes_mapping.make_empty (nb)

				-- Read table which will give us mapping between the old dynamic types
				-- and the new ones.
			from
				i := 0
			until
				i = nb
			loop
					-- Read old dynamic type
				l_old_dtype := l_deser.read_compressed_natural_32.to_integer_32

					-- Read type string associated to `l_old_dtype' and find dynamic type
					-- in current system.
				l_type_str := l_deser.read_string_8
				l_new_dtype := l_int.dynamic_type_from_string (l_type_str)

				header_tuples.extend (l_type_str, l_old_dtype)

				if l_new_dtype = -1 then
					-- create new generic type object for this unknown type
					unknown_types.extend (l_old_dtype)
					create l_gen_type.make(l_old_dtype,l_type_str)
					generic_types.put (l_gen_type,l_old_dtype)
				else
					if not l_table.valid_index (l_old_dtype) then
						l_table := l_table.resized_area ((l_old_dtype + 1).max (l_table.count * 2))
					end
					l_table.put (l_new_dtype, l_old_dtype)
				end
				i := i + 1
			end

			if not has_error then
					-- Read table which will give us mapping between the old dynamic types
					-- and the new ones.
				from
					i := 0
					nb := l_deser.read_compressed_natural_32.to_integer_32
				until
					i = nb
				loop
						-- Read old dynamic type
					l_old_dtype := l_deser.read_compressed_natural_32.to_integer_32

						-- Read type string associated to `l_old_dtype' and find dynamic type
						-- in current system.
					l_type_str := l_deser.read_string_8
					l_new_dtype := l_int.dynamic_type_from_string (l_type_str)

					header_tuples.extend (l_type_str, l_old_dtype)


					if l_new_dtype = -1 then
						--l_new_dtype := get_next_object_id
						if not unknown_types.has (l_old_dtype) then
							unknown_types.extend (l_old_dtype)
							create l_gen_type.make(l_old_dtype,l_type_str)
							generic_types.put (l_gen_type,l_old_dtype)
						end
					else
						if not l_table.valid_index (l_old_dtype) then
							l_table := l_table.resized_area ((l_old_dtype + 1).max (l_table.count * 2))
						end
						l_table.put (l_new_dtype, l_old_dtype)
					end
					i := i + 1
				end

				if not has_error then
						-- Now set `dynamic_type_table' as all old dynamic type IDs have
						-- be read and resolved.
					dynamic_type_table := l_table

						-- Read attributes map for each dynamic type.
					from
						i := 0
						nb := l_deser.read_compressed_natural_32.to_integer_32
					until
						i = nb
					loop
							-- Read old dynamic type.
						l_old_dtype := l_deser.read_compressed_natural_32.to_integer_32

						if unknown_types.has (l_old_dtype) then
							read_attributes_unknown_type (generic_types.item(l_old_dtype))
						else
							-- Read attributes description
							read_attributes (l_table.item (l_old_dtype))
						end
						if has_error then
								-- We had an error while retrieving stored attributes
								-- for `l_old_dtype'.
							i := nb - 1	-- Jump out of loop
						end
						i := i + 1
					end

					if not has_error then
						-- Read object_table if any.
						read_object_table (a_count)
					end
				end
			end
		end

	read_object_table (a_count: NATURAL_32)
			-- Read object table if any, which has `a_count' objects.
		local
			l_objs: like object_references
			l_deser: like deserializer
			l_int: like internal
			l_mem: like memory
			l_is_collecting,is_unknown_type: BOOLEAN
			l_nat32: NATURAL_32
			l_ref_id,l_special_type: INTEGER
			l_dtype,l_old_dtype: INTEGER
			i, nb: INTEGER
			l_obj: ANY
			l_new_obj:BINARY_DECODED
		do
			if deserializer.read_boolean then
				is_unknown_type := false
				l_mem := memory
				l_is_collecting := l_mem.collecting
				l_deser := deserializer
				l_int := internal
				l_objs := object_references
				from
					i := 0
					nb := a_count.to_integer_32
				until
					i = nb
				loop
					if l_is_collecting and then i // 2000 = 0 then
						l_mem.collection_off
					end

						-- read old type
					l_old_dtype := l_deser.read_compressed_natural_32.to_integer_32
						-- Read dynamic type
					if unknown_types.has (l_old_dtype) then
						is_unknown_type := true
						l_dtype := l_old_dtype
						create l_new_obj.make(l_dtype,get_next_object_id,generic_types.item (l_dtype).name)
					else
						l_dtype := new_dynamic_type_id (l_old_dtype)
						is_unknown_type := false
					end
						-- Read reference id
					l_nat32 := deserializer.read_compressed_natural_32
					check
						l_nat32_valid: l_nat32 > 0 and l_nat32 < {INTEGER}.max_value.as_natural_32
					end
					l_ref_id := l_nat32.to_integer_32

						-- Read object flags
					inspect
						l_deser.read_natural_8
					when is_special_flag then
							-- We need to first read the `item_type' of the SPECIAL,
							-- and then its count.
						if not is_unknown_type then
							l_obj := new_special_instance (l_dtype,
							l_deser.read_compressed_integer_32,
							l_deser.read_compressed_integer_32)
						else
							l_new_obj.set_is_special
							l_special_type := l_deser.read_compressed_integer_32
							l_new_obj.set_special_count (l_deser.read_compressed_integer_32)
							l_new_obj.set_special_type (l_special_type)
							decoded_object_storage.put (l_new_obj, l_new_obj.dtype)
							l_obj := l_new_obj
						end

					when is_tuple_flag then
						if not is_unknown_type then
							l_obj := l_int.new_instance_of (l_dtype)
						else
							l_new_obj.set_is_tuple
							decoded_object_storage.put (l_new_obj, l_new_obj.dtype)
							l_obj := l_new_obj
						end

					else
						if not is_unknown_type then
							l_obj := l_int.new_instance_of (l_dtype)
						else
							decoded_object_storage.put (l_new_obj, l_new_obj.dtype)
							l_obj := l_new_obj
						end
					end

					l_objs.put (l_obj, l_ref_id)
					i := i + 1
				end
				if l_is_collecting then
					l_mem.collection_on
				end
			else
				check False end
				--is_for_fast_retrieval := False
			end
		end

	read_attributes_unknown_type(a_generic_object:ES_EBBRO_UNIVERSAL_TYPE)
			-- read the attributes of an unknown type and update generic object representing this type
		local
			l_deser: like deserializer
			l_name: STRING
			l_dtype: INTEGER
			i, nb: INTEGER
		do
			l_deser := deserializer

			-- attributes count
			nb := l_deser.read_compressed_natural_32.to_integer_32
			from
				i := 1
				nb := nb + 1
			until
				i = nb
			loop
					-- Read attribute static type
				l_dtype := l_deser.read_compressed_natural_32.to_integer_32
					-- read attribute name
				l_name := l_deser.read_string_8
				a_generic_object.insert_attribute (l_dtype, l_name)
				i := i + 1
			end
		end

	decode_object_unknown_type(a_new_obj:BINARY_DECODED)
			-- decode an object of unknown type and store information to provided object of type decoded
		local
			l_int: like internal
			l_deser: like deserializer
			l_attr:ARRAYED_LIST[TUPLE[INTEGER,STRING]]
			l_name,l_attr_name:STRING
			l_ref_index: INTEGER
			l_ref_tuple:TUPLE[ref_id:INTEGER;new_dtype:INTEGER;attr_name:STRING;generic_type:INTEGER]
		do
			l_int := internal
			l_deser := deserializer

			from
				l_attr := generic_types.item (a_new_obj.generic_type).attributes
				l_attr.start
			until
				l_attr.after
			loop
				if l_attr.item.integer_32_item (1) < dynamic_type_table.count then
					l_name := l_int.type_name_of_type (dynamic_type_table.item(l_attr.item.integer_32_item (1)))
				else
					l_name := "DISPLAYABLE"
				end

				l_attr_name ?= l_attr.item.reference_item (2)
				if l_name.is_equal("BOOLEAN") then
					a_new_obj.insert_actual_attribute (l_attr_name,  l_deser.read_boolean, internal.boolean_type)
				elseif l_name.is_equal("CHARACTER_8") then
					a_new_obj.insert_actual_attribute (l_attr_name, l_deser.read_character_8, internal.character_8_type)
				elseif l_name.is_equal("CHARACTER_32") then
					a_new_obj.insert_actual_attribute (l_attr_name, l_deser.read_character_32, internal.character_32_type)
				elseif l_name.is_equal("NATURAL_8") then
					a_new_obj.insert_actual_attribute (l_attr_name, l_deser.read_natural_8, internal.natural_8_type)
				elseif l_name.is_equal("NATURAL_16") then
					a_new_obj.insert_actual_attribute (l_attr_name, l_deser.read_natural_16, internal.natural_16_type)
				elseif l_name.is_equal("NATURAL_32") then
					a_new_obj.insert_actual_attribute (l_attr_name, l_deser.read_natural_32, internal.natural_32_type)
				elseif l_name.is_equal("NATURAL_64") then
					a_new_obj.insert_actual_attribute (l_attr_name, l_deser.read_natural_64, internal.natural_64_type)
				elseif l_name.is_equal("INTEGER_8") then
					a_new_obj.insert_actual_attribute (l_attr_name, l_deser.read_integer_8, internal.integer_8_type)
				elseif l_name.is_equal("INTEGER_16") then
					a_new_obj.insert_actual_attribute (l_attr_name, l_deser.read_integer_16, internal.integer_16_type)
				elseif l_name.is_equal("INTEGER_32") then
					a_new_obj.insert_actual_attribute (l_attr_name, l_deser.read_integer_32, internal.integer_32_type)
				elseif l_name.is_equal("INTEGER_64") then
					a_new_obj.insert_actual_attribute (l_attr_name, l_deser.read_integer_64, internal.integer_64_type)
				elseif l_name.is_equal("REAL_32") then
					a_new_obj.insert_actual_attribute (l_attr_name, l_deser.read_real_32, internal.real_32_type)
				elseif l_name.is_equal("REAL_64") then
					a_new_obj.insert_actual_attribute (l_attr_name, l_deser.read_real_64, internal.real_64_type)
				elseif l_name.is_equal("POINTER") then
					a_new_obj.insert_actual_attribute (l_attr_name, l_deser.read_pointer, internal.pointer_type)
				else
					-- decode reference
					l_ref_index := deserializer.read_compressed_natural_32.to_integer_32
					create l_ref_tuple
					l_ref_tuple.put_integer (l_ref_index, 1)
					l_ref_tuple.put_integer (a_new_obj.dtype,2)
					l_ref_tuple.put (l_attr_name, 3)
					--l_ref_tuple.put (internal.reference_type,4)
					l_ref_tuple.put (l_attr.item.integer_32_item (1), 4)
					attribute_references.put_front(l_ref_tuple)
				end
				l_attr.forth
			end
		end

	decode_unknown_tuple (a_new_obj:BINARY_DECODED)
			-- Decode TUPLE object of type
		require
			not_void: a_new_obj /= void
			is_tuple: a_new_obj.is_tuple
		local
			l_deser: like deserializer
			i,nb,l_ref_index: INTEGER
			l_ref_tuple:TUPLE[ref_id:INTEGER;new_dtype:INTEGER;attr_name:STRING;generic_type:INTEGER]
		do
			l_deser := deserializer


			from
				i := 1
				nb := a_new_obj.tuple_length + 1
			until
				i = nb
			loop
				inspect l_deser.read_natural_8
				when {TUPLE}.boolean_code then a_new_obj.insert_actual_attribute (i.out,  l_deser.read_boolean, reflector.boolean_type)

				when {TUPLE}.character_8_code then a_new_obj.insert_actual_attribute (i.out,l_deser.read_character_8, reflector.character_8_type)
				when {TUPLE}.character_32_code then a_new_obj.insert_actual_attribute (i.out,l_deser.read_character_32, reflector.character_32_type)

				when {TUPLE}.natural_8_code then a_new_obj.insert_actual_attribute (i.out,l_deser.read_natural_8, reflector.natural_8_type)
				when {TUPLE}.natural_16_code then a_new_obj.insert_actual_attribute (i.out,l_deser.read_natural_16, reflector.natural_16_type)
				when {TUPLE}.natural_32_code then a_new_obj.insert_actual_attribute (i.out,l_deser.read_natural_32, reflector.natural_32_type)
				when {TUPLE}.natural_64_code then a_new_obj.insert_actual_attribute (i.out,l_deser.read_natural_64, reflector.natural_64_type)

				when {TUPLE}.integer_8_code then a_new_obj.insert_actual_attribute (i.out,l_deser.read_integer_8, reflector.integer_8_type)
				when {TUPLE}.integer_16_code then a_new_obj.insert_actual_attribute (i.out,l_deser.read_integer_16, reflector.integer_16_type)
				when {TUPLE}.integer_32_code then a_new_obj.insert_actual_attribute (i.out,l_deser.read_integer_32, reflector.integer_32_type)
				when {TUPLE}.integer_64_code then a_new_obj.insert_actual_attribute (i.out,l_deser.read_integer_64, reflector.integer_64_type)

				when {TUPLE}.real_32_code then a_new_obj.insert_actual_attribute (i.out,l_deser.read_real_32, reflector.real_32_type)
				when {TUPLE}.real_64_code then a_new_obj.insert_actual_attribute (i.out,l_deser.read_real_64, reflector.real_64_type)

				--when {TUPLE}.pointer_code then l_tuple.put_pointer (l_deser.read_pointer, i)

				when {TUPLE}.reference_code then
						-- decode reference
					l_ref_index := deserializer.read_compressed_natural_32.to_integer_32
					create l_ref_tuple
					l_ref_tuple.put_integer (l_ref_index, 1)
					l_ref_tuple.put_integer (a_new_obj.dtype,2)
					l_ref_tuple.put (i.out, 3)
					l_ref_tuple.put (reflector.reference_type, 4)
					attribute_references.put_front(l_ref_tuple)
				else
					check
						False
					end
				end
				i := i + 1
			end
		end

	decode_special_unknown(a_new_obj:BINARY_DECODED)
			-- decode special ...SPECIAL[ANY]
		require
			not_void: a_new_obj /= void
			is_tuple: a_new_obj.is_special
			objects_special_type_valid: a_new_obj.special_type > 0
		local
			l_deser: like deserializer
			i,nb,l_ref_index: INTEGER
			l_ref_tuple:TUPLE[ref_id:INTEGER;new_dtype:INTEGER;attr_name:STRING;generic_type:INTEGER]
		do
			l_deser := deserializer
			from
				i := 1
				nb := a_new_obj.special_count + 1
			until
				i = nb
			loop
				-- decode reference
				l_ref_index := deserializer.read_compressed_natural_32.to_integer_32
				create l_ref_tuple
				l_ref_tuple.put_integer (l_ref_index, 1)
				l_ref_tuple.put_integer (a_new_obj.dtype,2)
				l_ref_tuple.put (i.out, 3)
				l_ref_tuple.put (a_new_obj.special_type, 4)
				attribute_references.put_front(l_ref_tuple)
				i := i + 1
			end
		end


	decode_object (is_root: BOOLEAN)
			-- Decode one object and store it in `last_decoded_object' if `is_root'.
		local
			l_dtype: INTEGER
			l_deser: like deserializer
			l_int: like internal
			l_spec_mapping: like special_type_mapping
			l_obj: ANY
			l_nat32: NATURAL_32
			l_index: INTEGER
			l_flags: NATURAL_8
			l_spec_type, l_spec_count,l_old_dtype: INTEGER
			l_new_obj: BINARY_DECODED
			l_refl_obj: REFLECTED_OBJECT
		do
			l_deser := deserializer
			l_int := internal
			l_spec_mapping := special_type_mapping

				-- Read reference ID.
			l_nat32 := l_deser.read_compressed_natural_32
			check
				l_nat32_valid: l_nat32 < {INTEGER}.max_value.as_natural_32
			end
			l_index := l_nat32.to_integer_32

			l_obj := object_references.item (l_index)
			l_dtype := l_int.dynamic_type (l_obj)

			l_new_obj ?= l_obj
			if l_new_obj /= void then
				--type unknown
				if l_new_obj.is_tuple then
					decode_unknown_tuple (l_new_obj)
				elseif l_new_obj.is_special  then
					decode_special_unknown (l_new_obj)
				else
					decode_object_unknown_type(l_new_obj)
				end
			else
				if l_int.is_special (l_obj) then
					-- Get the abstract element type of the SPECIAL.
					l_spec_mapping.search (l_int.generic_dynamic_type_of_type (l_dtype, 1))
					if l_spec_mapping.found then
						l_spec_type := l_spec_mapping.found_item
					else
						l_spec_type := {INTERNAL}.reference_type
					end

					decode_special (l_obj, l_spec_type)
				elseif l_int.is_tuple (l_obj) then
					decode_tuple (l_obj)
				else
					create l_refl_obj.make (l_obj)
					decode_normal_object (l_refl_obj)
				end
			end
			if is_root then
				last_decoded_object := l_obj
				last_header_tuple := header_tuples.deep_twin()
			end
		end
note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
