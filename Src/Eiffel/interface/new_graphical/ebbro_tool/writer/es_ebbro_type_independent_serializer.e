note
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_TYPE_INDEPENDENT_SERIALIZER
inherit
	SED_INDEPENDENT_SERIALIZER
	redefine
		make,
		--root_object,
		set_root_object,
		write_header,
		type_table,
		encode_objects,
		write_object_table,
		attributes_dynamic_types
	end

create
	make

feature --Creation

	make (a_serializer: SED_READER_WRITER)
			-- Initialize current instance
		do
			create internal
			create object_indexes.make (1)
			traversable := decoded_breadth_first_traversable
			serializer := a_serializer
			create visited_objects.make
		end


feature {NONE} -- Implementation

	--root_object: DECODED
	dynamic_type_count: INTEGER_32
	visited_objects: LINKED_LIST[ANY] --visited objects for 'object_count'
	--object_types: HASH_TABLE[STRING_8,INTEGER_32] --all object types in 'root_object'. format: dynamic_type, generic_type
	decoded_map: HASH_TABLE[BINARY_DECODED,INTEGER]
		-- mapping of all decoded objects found using `traversable.traverse'

	decoded_breadth_first_traversable: ES_EBBRO_DECODED_GRAPH_BREADTH_FIRST_TRAVERSABLE
			-- Return an instance of DECODED_GRAPH_BREADTH_FIRST_TRAVERSABLE.
		once
			Result := create {ES_EBBRO_DECODED_GRAPH_BREADTH_FIRST_TRAVERSABLE}
		end

	decoded_depth_first_traversable: ES_EBBRO_DECODED_GRAPH_DEPTH_FIRST_TRAVERSABLE
			-- Return an instance of DECODED_GRAPH_DEPTH_FIRST_TRAVERSABLE.
		once
			Result := create {ES_EBBRO_DECODED_GRAPH_DEPTH_FIRST_TRAVERSABLE}
		end



feature -- Access

	set_root_object (a_decoded_object: BINARY_DECODED )
			-- Make 'an_object' the root_object.
		do
			traversable.set_root_object (a_decoded_object)
			is_root_object_set := true
		end

	write_header (a_list: ARRAYED_LIST [ANY])
			-- Write header of storable.
		local
			l_dtype_table, l_attr_dtype_table: like type_table
			l_dtype: INTEGER
			l_ser: like serializer
			l_int: like internal
		do
			l_ser := serializer
			l_int := internal

			l_dtype_table := type_table (a_list)

				-- Write mapping dynamic type and their string representation for alive objects.
			from
					-- Write number of types being written
				l_ser.write_compressed_natural_32 (l_dtype_table.count.to_natural_32)
				l_dtype_table.start
			until
				l_dtype_table.after
			loop
					-- Write dynamic type
				l_dtype := l_dtype_table.item_for_iteration
				l_ser.write_compressed_natural_32 (l_dtype.to_natural_32)
					-- Write type name
				--l_ser.write_string_8 (l_int.type_name_of_type (l_dtype))
				--get the type name from 'decoded_type_map', not from 'INTERNAL'
				if decoded_map.has (l_dtype) then
					l_ser.write_string_8 (decoded_map.item (l_dtype).name)
				else
					l_ser.write_string_8 (l_int.type_name_of_type (l_dtype))
				end

				l_dtype_table.forth
			end

			from
					-- Write number of types being written
				l_attr_dtype_table := attributes_dynamic_types (l_dtype_table)
				l_ser.write_compressed_natural_32 (l_attr_dtype_table.count.to_natural_32)
				l_attr_dtype_table.start
			until
				l_attr_dtype_table.after
			loop
					-- Write dynamic type
				l_dtype := l_attr_dtype_table.item_for_iteration
				l_ser.write_compressed_natural_32 (l_dtype.abs.to_natural_32)

				-- Write type name
				if attached {BINARY_DECODED} root_object as l_root_dec then
			--	if {l_root_dec: BINARY_DECODED} root_object then
					if l_root_dec.header_tuple_array.has (-l_dtype) then
						l_ser.write_string_8 (l_root_dec.header_tuple_array.item(-l_dtype))
					else
						l_ser.write_string_8 (l_int.type_name_of_type (l_dtype))
					end
				else
					l_ser.write_string_8 (l_int.type_name_of_type (l_dtype))
				end
				l_attr_dtype_table.forth
			end

				-- Write attribute description mapping
			from
				l_ser.write_compressed_natural_32 (l_dtype_table.count.to_natural_32)
				l_dtype_table.start
			until
				l_dtype_table.after
			loop
					-- Write dynamic type
				l_dtype := l_dtype_table.item_for_iteration
				l_ser.write_compressed_natural_32 (l_dtype.to_natural_32)
					-- Write attributes description
				if decoded_map.has (l_dtype) then
					write_attributes_decoded (decoded_map.item (l_dtype))
				else
					write_attributes (l_dtype)
				end
				l_dtype_table.forth
			end

				-- Write object table if necessary.
			write_object_table (a_list)
		end




	type_table (a_list: ARRAYED_LIST [ANY]): HASH_TABLE [INTEGER, INTEGER]
			-- Given a list of objects `a_list', builds a compact table of the
			-- dynamic type IDs present in `a_list'.
			-- it also records the type NAMES in this version
		local
			l_dtype: INTEGER
			l_int: like internal
			l_array: detachable ARRAY [ANY]
			l_area: SPECIAL [ANY]
			i, nb: INTEGER

			l_decoded: BINARY_DECODED
			l_type_name: STRING_8
		do
			l_int := internal
			create decoded_map.make (a_list.count)

			from
					-- There is no good way to estimate how many different types
					-- there will be in the system, we guessed that 500 should give
					-- us a good initial number in most cases.
				create Result.make (500)
				l_array := a_list.to_array
				l_area := l_array.area
				l_array := Void
				i := 0
				nb := a_list.count
			until
				i = nb
			loop
				l_decoded ?= l_area.item (i)

				-- for normal objects
				if l_decoded = Void then
					l_dtype := l_int.dynamic_type (l_area.item (i))
					l_type_name := l_int.type_name_of_type (l_dtype)
				else
				-- for decoded objects
					l_dtype := l_decoded.generic_type
					l_type_name := l_decoded.name
					decoded_map.put (l_decoded, l_dtype)
				end
				Result.put (l_dtype, l_dtype)
				i := i + 1
			end
		end

	write_attributes_decoded (a_decoded: BINARY_DECODED)
			-- Write attribute description for type whose dynamic type id is `a_dtype'.
			-- if the object to be written is a decoded
		local
			l_int: like internal
			l_ser: like serializer
			nb: INTEGER
			l_attributes: ARRAYED_LIST[TUPLE[ANY,STRING_8]]
			l_types: ARRAYED_LIST[TUPLE[INTEGER,STRING_8]]
			l_any: ANY
			l_dec: BINARY_DECODED
			l_name: STRING_8
			l_dtype: INTEGER
		do
			l_int := internal
			l_ser := serializer
			l_attributes := a_decoded.attribute_values
			l_types := a_decoded.attribute_generic_types
			if a_decoded.is_special or a_decoded.is_tuple then
				l_ser.write_compressed_natural_32(0)
			else
				from
					--nb := l_int.field_count_of_type (a_dtype)
					nb := a_decoded.attribute_values.count
					l_ser.write_compressed_natural_32 (nb.to_natural_32)
					l_attributes.start
					l_types.start
				until
					l_attributes.after
				loop
					l_any := l_attributes.item_for_iteration.item (1)
					l_name ?= l_attributes.item_for_iteration.item (2)
					l_dtype ?= l_types.item_for_iteration.item (1)
					l_dec ?= l_any
					if l_dec /= Void then
							-- Write the attribute information of a `decoded' object
							-- Write attribute static type
						l_ser.write_compressed_natural_32 (l_dec.generic_type.to_natural_32)
							-- Write attribute name
						l_ser.write_string_8 (l_name.to_string_8)
					else
							-- Write the attribute information of a known, non-decoded object

							-- Write attribute static type
						if l_any /= Void then
							l_ser.write_compressed_natural_32 (l_int.dynamic_type (l_any).to_natural_32)
						else
						--	if {l_root_dec: BINARY_DECODED} root_object then
						if attached {BINARY_DECODED} root_object as l_root_dec then
								if l_root_dec.header_tuple_array.has (l_dtype) and then l_int.dynamic_type_from_string (l_root_dec.header_tuple_array.item (l_dtype)) >= 0 then
									l_dtype := l_int.dynamic_type_from_string (l_root_dec.header_tuple_array.item (l_dtype))
								end
							end
							l_ser.write_compressed_natural_32 ( l_dtype.to_natural_32 )
						end

							-- Write attribute name
						l_ser.write_string_8 (l_name.to_string_8)
					end

					l_attributes.forth
					l_types.forth
				end
			end
		end


	encode_objects (a_list: ARRAYED_LIST [ANY])
			-- Encode all objects referenced in `a_list'.
			-- allow encoding of `DECODED' objects.
		local
			l_int: like internal
			l_ser: like serializer
			l_spec_mapping: like special_type_mapping
			l_object_indexes: like object_indexes
			l_is_for_slow_retrieval: BOOLEAN
			l_dtype, l_spec_item_type: INTEGER
			l_obj: ANY
			i, nb: INTEGER
			l_area: SPECIAL [ANY]
			l_array: detachable ARRAY [ANY]
			l_dec: BINARY_DECODED
		do
			l_int := internal
			l_ser := serializer
			l_object_indexes := object_indexes
			l_spec_mapping := special_type_mapping
			l_is_for_slow_retrieval := not is_for_fast_retrieval


			from
				l_array := a_list.to_array
				l_area := l_array.area
				l_array := Void
				i := 0
				nb := a_list.count
			until
				i = nb
			loop
				l_obj := l_area.item (i)
				i := i + 1

				l_dec ?= l_obj

				if l_dec /= Void then
					-- encode an object wrapped in a DECODED object

					if l_is_for_slow_retrieval then
						-- Write object dtype
						l_ser.write_compressed_natural_32 (l_dec.generic_type.to_natural_32)
					end

						-- Write object reference ID.
					l_ser.write_compressed_natural_32 (l_object_indexes.index (l_obj))



					if l_dec.is_special then
						if l_is_for_slow_retrieval then
								-- Store the fact it is a SPECIAL
							l_ser.write_natural_8 (is_special_flag)


							l_spec_item_type := l_dec.attribute_generic_types.i_th (1).dtype
							l_ser.write_compressed_integer_32 (l_spec_item_type)

							--l_ser.write_compressed_integer_32 (INTERNAL.reference_type)

							l_ser.write_compressed_integer_32 (l_dec.special_count)
						end

						encode_special_decoded (l_dec)

					elseif l_dec.is_tuple then
						if l_is_for_slow_retrieval then
							l_ser.write_natural_8 (is_tuple_flag)
						end
						encode_tuple_decoded (l_dec)
					else
						if l_is_for_slow_retrieval then
							l_ser.write_natural_8 (0)
						end
						encode_normal_decoded (l_dec)
					end

				else
					-- decode a normal object not wrapped in a DECODED

						-- Get object data.
					l_dtype := l_int.dynamic_type (l_obj)

					if l_is_for_slow_retrieval then
							-- Write object dtype
						l_ser.write_compressed_natural_32 (l_dtype.to_natural_32)
					end

						-- Write object reference ID.
					l_ser.write_compressed_natural_32 (l_object_indexes.index (l_obj))

						-- Write object flags if in slow retrieval mode, then data.
					if l_int.is_special (l_obj) then
							-- Get the abstract element type of the SPECIAL.
						l_spec_mapping.search (l_int.generic_dynamic_type_of_type (l_dtype, 1))
						if l_spec_mapping.found then
							l_spec_item_type := l_spec_mapping.found_item
						else
							l_spec_item_type := {INTERNAL}.reference_type
						end

						if l_is_for_slow_retrieval then
								-- Store the fact it is a SPECIAL
							l_ser.write_natural_8 (is_special_flag)

								-- Store the type of special
							l_ser.write_compressed_integer_32 (l_spec_item_type)

								-- Store count of special
						--	if {l_abstract_spec: ABSTRACT_SPECIAL} l_obj then
							if attached {ABSTRACT_SPECIAL} l_obj as l_abstract_spec then
								l_ser.write_compressed_integer_32 (l_abstract_spec.count)
							else
								check l_abstract_spec_attached: False end
							end
						end
						encode_special (l_obj, l_dtype, l_spec_item_type)
					elseif l_int.is_tuple (l_obj) then
						if l_is_for_slow_retrieval then
							l_ser.write_natural_8 (is_tuple_flag)
						end
					--	if {l_tuple: TUPLE} l_obj then
						if attached {TUPLE} l_obj as l_tuple then
							encode_tuple_object (l_tuple)
						else
							check
								l_tuple_attached: False
							end
						end
					else
						if l_is_for_slow_retrieval then
							l_ser.write_natural_8 (0)
						end
						encode_normal_object (l_obj, l_dtype)
					end
				end
			end
		end


	write_object_table (a_list: ARRAYED_LIST [ANY])
			-- Write mapping between object's reference ID in `a_list' with
			-- all the necessary information necessary to recreate it at a
			-- later time.
		local
			l_int: like internal
			l_ser: like serializer
			l_object_indexes: like object_indexes
			l_spec_mapping: like special_type_mapping
			i, nb: INTEGER
			l_dtype, l_spec_item_type: INTEGER
			l_obj: ANY
			l_area: SPECIAL [ANY]
			l_array: detachable ARRAY [ANY]
			l_dec: BINARY_DECODED
		do
			if is_for_fast_retrieval then
					-- Mark data with information that shows we have a mapping
					-- between reference IDs and objects.
				serializer.write_boolean (True)
				l_int := internal
				l_ser := serializer
				l_object_indexes := object_indexes
				l_spec_mapping := special_type_mapping

				from
					l_array := a_list.to_array
					l_area := l_array.area
					l_array := Void
					i := 0
					nb := a_list.count
				until
					i = nb
				loop
					l_obj := l_area.item (i)
					i := i + 1


					l_dec ?= l_obj
					if l_dec /= Void then
						-- for DECODED object
							--write object dtype
						l_ser.write_compressed_natural_32 (l_dec.generic_type.to_natural_32)

							--write object reference ID
							--TODO: check if working correctl
						l_ser.write_compressed_natural_32 (l_object_indexes.index (l_obj))

						--write object flags, then data
						if l_dec.is_special then
							l_ser.write_natural_8 (is_special_flag)

								-- get the abstract element type of the SPECIAL and write it

							l_spec_item_type := l_dec.special_type
							l_ser.write_compressed_integer_32 (l_spec_item_type)

							-- Write number of elements in SPECIAL
							l_ser.write_compressed_integer_32 (l_dec.special_count)

						elseif l_dec.is_tuple then
							l_ser.write_natural_8 (is_tuple_flag)
						else
							l_ser.write_natural_8 (0)
						end

					else
							-- for non-DECODED objects

							-- Get object data.
						l_dtype := l_int.dynamic_type (l_obj)

							-- Write object dtype.
						l_ser.write_compressed_natural_32 (l_dtype.to_natural_32)

							-- Write object reference ID.
						l_ser.write_compressed_natural_32 (l_object_indexes.index (l_obj))


							-- Write object flags, then data.
						if l_int.is_special (l_obj) then
								-- Write special flag.
							l_ser.write_natural_8 (is_special_flag)

								-- Get the abstract element type of the SPECIAL and write it.
							l_spec_mapping.search (l_int.generic_dynamic_type_of_type (l_dtype, 1))
							if l_spec_mapping.found then
								l_spec_item_type := l_spec_mapping.found_item
							else
								l_spec_item_type := {INTERNAL}.reference_type
							end
							l_ser.write_compressed_integer_32 (l_spec_item_type)

								-- Write number of elements in SPECIAL
						--	if {l_abstract_spec: ABSTRACT_SPECIAL} l_obj then
							if attached {ABSTRACT_SPECIAL} l_obj as l_abstract_spec then
								l_ser.write_compressed_integer_32 (l_abstract_spec.count)
							else
								check
									l_abstract_spec_attached: False
								end
							end

						elseif l_int.is_tuple (l_obj) then
							l_ser.write_natural_8 (is_tuple_flag)
						else
							l_ser.write_natural_8 (0)
						end
					end
				--i := 0 + 1
				end
			else
					-- No mapping here.
				serializer.write_boolean (False)
			end
		end




	encode_special_decoded(a_decoded: BINARY_DECODED)
			-- encode a special type object wrapped in a DECODED object
			-- note: this has to be of type SPECIAL[ANY], otherwise it wouldn't be wrapped in a DECODED
		require
			is_special_decoded: a_decoded.is_special
		local
			i, nb: INTEGER
		do
			from
				i := 1
				nb := a_decoded.special_count + 1
			until
				i = nb
			loop
				encode_reference (a_decoded.attribute_values.i_th (i).object)
				i := i + 1
			end
		end

	encode_tuple_decoded(a_decoded: BINARY_DECODED)
			-- encode a tuple object wrapped in a DECODED object
		require
			is_tuple_decoded: a_decoded.is_tuple
		local
			i, nb: INTEGER
			l_ser: like serializer
			l_int: INTERNAL
			l_attr: ANY
		do
			from
				create l_int
				l_ser := serializer
				i := 1
				nb := a_decoded.tuple_length + 1
			until
				i = nb
			loop
				l_attr := a_decoded.attribute_values.i_th (i).object

				if l_attr /= void then
				--	if {l_attr_dec: BINARY_DECODED} l_attr then
					if attached {BINARY_DECODED} l_attr as l_attr_dec then
						-- of type DECODED
						l_ser.write_natural_8 ({TUPLE}.reference_code)
						encode_reference (l_attr_dec)
					else
						-- known type

						if attached {CHARACTER_8} l_attr as l_char8 then
							l_ser.write_natural_8 ({TUPLE}.character_8_code)
							l_ser.write_character_8 (l_char8)
						elseif attached {CHARACTER_32} l_attr as l_char32 then
							l_ser.write_natural_8 ({TUPLE}.character_32_code)
							l_ser.write_character_32 (l_char32)

						elseif attached {BOOLEAN} l_attr as l_bool then
							l_ser.write_natural_8 ({TUPLE}.boolean_code)
							l_ser.write_boolean ( l_bool )

						elseif attached {NATURAL_8} l_attr as l_nat8 then
							l_ser.write_natural_8 ({TUPLE}.natural_8_code)
							l_ser.write_natural_8 (l_nat8)
						elseif attached {NATURAL_16} l_attr as l_nat16 then
							l_ser.write_natural_8 ({TUPLE}.natural_16_code)
							l_ser.write_natural_16 (l_nat16)
						elseif attached {NATURAL_32} l_attr as l_nat32 then
							l_ser.write_natural_8 ({TUPLE}.natural_32_code)
							l_ser.write_natural_32 (l_nat32)
						elseif attached {NATURAL_64} l_attr as l_nat64 then
							l_ser.write_natural_8 ({TUPLE}.natural_64_code)
							l_ser.write_natural_64 (l_nat64)

						elseif attached {INTEGER_8} l_attr as l_int8 then
							l_ser.write_natural_8 ({TUPLE}.integer_8_code)
							l_ser.write_integer_8 (l_int8)
						elseif attached {INTEGER_16} l_attr as l_int16 then
							l_ser.write_natural_8 ({TUPLE}.integer_16_code)
							l_ser.write_integer_16 (l_int16)
						elseif attached {INTEGER_32} l_attr as l_int32 then
							l_ser.write_natural_8 ({TUPLE}.integer_32_code)
							l_ser.write_integer_32 (l_int32)
						elseif attached {INTEGER_64} l_attr as l_int64 then
							l_ser.write_natural_8 ({TUPLE}.integer_64_code)
							l_ser.write_integer_64 (l_int64)
						elseif attached {REAL_32} l_attr as l_real32 then
							l_ser.write_natural_8 ({TUPLE}.real_32_code)
							l_ser.write_real_32 (l_real32)
						elseif attached {REAL_64} l_attr as l_real64 then
							l_ser.write_natural_8 ({TUPLE}.real_64_code)
							l_ser.write_real_64 (l_real64)
						elseif attached {POINTER} l_attr as l_pointer then
							l_ser.write_natural_8 ({TUPLE}.pointer_code)
							l_ser.write_pointer (l_pointer)
						else
							l_ser.write_natural_8 ({TUPLE}.reference_code)
							encode_reference (l_attr)
						end
					end
				else
					-- TODO: correct? what happens if l_attr = void? where to get the type from?
					l_ser.write_natural_8 ({TUPLE}.reference_code)
					l_ser.write_compressed_natural_32 (0)
				end
				i := i + 1
			end
		end


	encode_normal_decoded(a_decoded: BINARY_DECODED)
			-- encode a normal DECODED object
		require
			a_decoded_not_special: not a_decoded.is_special
			a_decoded_not_tuple: not a_decoded.is_tuple
		local
			i, nb: INTEGER
			l_int: like internal
			l_ser: like serializer
			l_field: ANY
			l_gen_type: INTEGER
			l_char8: CHARACTER_8
			l_char32: CHARACTER_32
			l_bool: BOOLEAN
			l_nat8: NATURAL_8
			l_nat16: NATURAL_16
			l_nat32: NATURAL_32
			l_nat64: NATURAL_64
			l_int8: INTEGER_8
			l_int16: INTEGER_16
			l_int32: INTEGER_32
			l_int64: INTEGER_64
			l_real32: REAL_32
			l_real64: REAL_64
			l_pointer: POINTER
		do
			from
				l_int := internal
				l_ser := serializer
				i := 1
				nb := a_decoded.attribute_values.count + 1
			until
				i = nb
			loop

				l_field := a_decoded.attribute_values.i_th (i).object
				l_gen_type := a_decoded.attribute_generic_types.i_th (i).dtype

			--	if {l_field_dec: BINARY_DECODED} l_field then
				if attached {BINARY_DECODED} l_field as l_field_dec then
						-- field is another DECODED object
					encode_reference (l_field_dec)
				else
						-- field is not a DECODED object
					inspect l_gen_type

					when {INTERNAL}.boolean_type then
						l_bool ?= l_field
						l_ser.write_boolean (l_bool)

					when {INTERNAL}.character_8_type then
						l_char8 ?= l_field
						l_ser.write_character_8 (l_char8)
					when {INTERNAL}.character_32_type then
						l_char32 ?= l_field
						l_ser.write_character_32 (l_char32)

					when {INTERNAL}.natural_8_type then
						l_nat8 ?= l_field
						l_ser.write_natural_8 (l_nat8)
					when {INTERNAL}.natural_16_type then
						l_nat16 ?= l_field
						l_ser.write_natural_16 (l_nat16)
					when {INTERNAL}.natural_32_type then
						l_nat32 ?= l_field
						l_ser.write_natural_32 (l_nat32)
					when {INTERNAL}.natural_64_type then
						l_nat64 ?= l_field
						l_ser.write_natural_64 (l_nat64)

					when {INTERNAL}.integer_8_type then
						l_int8 ?= l_field
						l_ser.write_integer_8 (l_int8)
					when {INTERNAL}.integer_16_type then
						l_int16 ?= l_field
						l_ser.write_integer_16 (l_int16)
					when {INTERNAL}.integer_32_type then
						l_int32 ?= l_field
						l_ser.write_integer_32 (l_int32)
					when {INTERNAL}.integer_64_type then
						l_int64 ?= l_field
						l_ser.write_integer_64 (l_int64)

					when {INTERNAL}.real_32_type then
						l_real32 ?= l_field
						l_ser.write_real_32 (l_real32)
					when {INTERNAL}.real_64_type then
						l_real64 ?= l_field
						l_ser.write_real_64 (l_real64)

					when {INTERNAL}.pointer_type then
						l_pointer ?= l_field
						l_ser.write_pointer (l_pointer)

					when {INTERNAL}.reference_type then
						encode_reference (l_field)
					else
						--it is a reference field -> l_gen_type corresponds to the old dtype
						encode_reference (l_field)
--						check
--							False
--						end
					end
				end
				i := i + 1
			end
		end


	attributes_dynamic_types (a_type_table: like type_table): like type_table
			-- Table of dynamic types of attributes appearing in `a_type_table'.
		local
			l_int: like internal
			i, nb: INTEGER
			l_dtype, l_obj_dtype: INTEGER
			l_dec: BINARY_DECODED
			l_attr: ANY
			l_no_put:BOOLEAN
		do
			l_int := internal
			from
				a_type_table.start
				create Result.make (500)
			until
				a_type_table.after
			loop
				l_obj_dtype := a_type_table.item_for_iteration
				if is_dtype_of_decoded (l_obj_dtype) then
					--get all dTypes from the DECODED object
					from
						l_dec := decoded_map.item (l_obj_dtype)
						i := 1
						nb := l_dec.attribute_values.count + 1
					until
						i = nb
					loop
						l_attr := l_dec.attribute_values.i_th (i).object
						if l_attr /= void then
						--	if {l_attr_dec: BINARY_DECODED} l_attr then
							if attached {BINARY_DECODED} l_attr as l_attr_dec then
								l_dtype := l_attr_dec.generic_type
							else
								l_dtype := l_int.dynamic_type (l_attr)
							end
							if not a_type_table.has (l_dtype) then
								-- only add types that are not already in `a_type_table'
								Result.put (l_dtype, l_dtype)
							end
						else
							l_dtype := l_dec.attribute_generic_types.i_th (i).dtype
							l_no_put := false
						--	if {l_root_dec: BINARY_DECODED} root_object then
							if attached {BINARY_DECODED} root_object as l_root_dec then
								if l_root_dec.header_tuple_array.has (l_dtype) and then l_int.dynamic_type_from_string (l_root_dec.header_tuple_array.item (l_dtype)) >= 0 then
									l_dtype := l_int.dynamic_type_from_string (l_root_dec.header_tuple_array.item (l_dtype))
								elseif l_dtype <= l_int.max_predefined_type then
									-- do nothing
									l_no_put := true
								else
									-- set it to negative so later on a possible missmatch with a dynamic type id of the current system should not be possible
									l_dtype := - l_dtype
								end
								if not a_type_table.has (l_dtype.abs) and not l_no_put then
									-- only add types that are not already in `a_type_table'
									Result.put (l_dtype, l_dtype)
								end
							end
						end
						i := i + 1
					end
				else
					--get the types through INTERNAL
					from
						i := 1

						nb := l_int.field_count_of_type (l_obj_dtype)
						nb := nb + 1
					until
						i = nb
					loop
						l_dtype := l_int.field_static_type_of_type (i, l_obj_dtype)
						if not a_type_table.has (l_dtype) then
								-- Only add types that are not already in `a_type_table'.
							Result.put (l_dtype, l_dtype)
						end
						i := i + 1
					end
				end
				a_type_table.forth
			end
		end

	is_dtype_of_decoded(a_dtype: INTEGER): BOOLEAN
			-- tests if a d_type occurs in a DECODED object
		do
			result := decoded_map.has (a_dtype)
		end


note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
