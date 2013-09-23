note
	description: "Summary description for {PS_BINARY_FORMAT}."
	author: "Marco Piccioni, Adrian Schmidmeister"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_BINARY_FORMAT

inherit

	PS_FORMAT

create
	make

feature

	make
		do
			format_code := 20120129
			version := 1 -- to be changed when newer class implementation breaks
				-- compatibility with the older one
			create rebuilt_objects.make (300)
			create l_int
			create visited_objects.make (300)
			visited_objects.compare_references
		end

feature -- Access
			--	representation: ANY
			-- Return type may change
			--			
			-- Binary representation of object passed to `compute_representation'.
			--		do
			--			create Result
			--		end

feature -- Basic operations

	write_header (a_medium: RAW_FILE)
		do
			a_medium.put_integer_32 (format_code)
			a_medium.put_integer_32 (version)
		end

	correct_header (a_medium: RAW_FILE): BOOLEAN
		do
			a_medium.read_integer_32
			if a_medium.last_integer_32 = format_code then
				a_medium.read_integer_32
				if a_medium.last_integer_32 = version then
					result := true
				end
			end
		end

	encode_object (a_field: detachable ANY; l_index: INTEGER; a_medium: RAW_FILE)
		local
			l_dtype: INTEGER
			l_field_count: INTEGER
			i: INTEGER
		do
			if a_field = Void then -- field is void
				a_medium.put_integer_32 (-2) -- void code
				--print ("serializer: void field skiped%N")
			elseif l_int.is_marked (a_field) then -- field is a recurring reference
				a_medium.put_integer_32 (-3) -- reference code
				a_medium.put_integer_32 (l_index) -- field index
				if visited_objects.has (a_field) then
					a_medium.put_integer_32 (visited_objects.index_of (a_field, 1)) -- reference index
				else
					print ("serializer: error while encoding recurring reference%N")
				end
			else
				visited_objects.extend (a_field)
				if l_index >= 0 then -- write field index of parent object if not root (which is -1)
					a_medium.put_integer_32 (l_index)
				end
					-- write dynamic type of object
				l_dtype := l_int.dynamic_type (a_field)
				a_medium.put_integer_32 (l_dtype)
				if attached {SPECIAL [detachable ANY]} a_field as l_sp then -- object is of special type - write fields count
					l_int.mark (l_sp)
					l_field_count := l_sp.count
					a_medium.put_integer_32 (l_field_count)
					from
						i := 0
					until
						i = l_field_count
					loop
						encode_object (l_sp.item (i), i, a_medium) -- recursively encode children
						i := i + 1
					end
				elseif attached {TUPLE} a_field as l_tp then -- object is of tuple type - write fields count
					l_int.mark (l_tp)
					l_field_count := l_tp.count
					a_medium.put_integer_32 (l_field_count)
					from
						i := 1
					until
						i = l_field_count + 1
					loop
						encode_object (l_tp.item (i), i, a_medium) -- recursively encode children
						i := i + 1
					end
				elseif attached {INTEGER_32} a_field as val then -- object is of basic type - write value
					a_medium.put_integer_32 (val)
				elseif attached {BOOLEAN} a_field as val then
					a_medium.put_integer_8 (val.to_integer.as_integer_8)
				elseif attached {INTEGER_8} a_field as val then
					a_medium.put_integer_8 (val)
				elseif attached {INTEGER_16} a_field as val then
					a_medium.put_integer_16 (val)
				elseif attached {INTEGER_64} a_field as val then
					a_medium.put_integer_64 (val)
				elseif attached {NATURAL_8} a_field as val then
					a_medium.put_natural_8 (val)
				elseif attached {NATURAL_16} a_field as val then
					a_medium.put_natural_16 (val)
				elseif attached {NATURAL_32} a_field as val then
					a_medium.put_natural_32 (val)
				elseif attached {NATURAL_64} a_field as val then
					a_medium.put_natural_64 (val)
				elseif attached {CHARACTER_8} a_field as val then
					a_medium.put_character (val)
				elseif attached {CHARACTER_32} a_field as val then
					a_medium.put_integer_32 (val.code)
				elseif attached {DOUBLE} a_field as val then
					a_medium.put_double (val)
				elseif attached {REAL} a_field as val then
					a_medium.put_real (val)
				elseif attached {POINTER} a_field as l_pt then --- does not work, should be saved as an int64
					print ("warning: serializing pointer%N")
					a_medium.put_integer_64 (l_pt.to_integer_32.as_integer_64)
				else -- object is of normal type
					l_int.mark (a_field)
					l_field_count := l_int.field_count_of_type (l_dtype)
					a_medium.put_integer_32 (l_field_count)
					from
						i := 1
					until
						i = l_field_count + 1
					loop
						encode_object (l_int.field (i, a_field), i, a_medium)
						i := i + 1
					end
				end
			end
		end

	extract_object (a_medium: RAW_FILE): ANY
		local
			l_dtype: INTEGER
			l_object: ANY
			l_fields: INTEGER
			l_field: ANY
			l_field_index: INTEGER
			l_ref: INTEGER
			l_i: INTEGER
			l_special: SPECIAL [ANY]
		do
				-- read type of object
			a_medium.read_integer_32
			l_dtype := a_medium.last_integer_32
				-- checks whether l_dtype is a valid dynamic type
			if l_int.is_valid_type_string (l_int.type_name_of_type (l_dtype)) then
					-- checks object type
				if l_int.is_special_type (l_dtype) then -- special basic type
						-- read fields count
					a_medium.read_integer_32
					l_fields := a_medium.last_integer_32
					if l_dtype = l_int.dynamic_type_from_string ("SPECIAL [CHARACTER_8]") then
						create {SPECIAL [CHARACTER_8]} l_special.make_empty (l_fields)
					elseif l_dtype = l_int.dynamic_type_from_string ("SPECIAL [CHARACTER_32]") then
						create {SPECIAL [CHARACTER_32]} l_special.make_empty (l_fields)
					elseif l_dtype = l_int.dynamic_type_from_string ("SPECIAL [INTEGER_8]") then
						create {SPECIAL [INTEGER_8]} l_special.make_empty (l_fields)
					elseif l_dtype = l_int.dynamic_type_from_string ("SPECIAL [INTEGER_16]") then
						create {SPECIAL [INTEGER_16]} l_special.make_empty (l_fields)
					elseif l_dtype = l_int.dynamic_type_from_string ("SPECIAL [INTEGER_32]") then
						create {SPECIAL [INTEGER_32]} l_special.make_empty (l_fields)
					elseif l_dtype = l_int.dynamic_type_from_string ("SPECIAL [INTEGER_64]") then
						create {SPECIAL [INTEGER_64]} l_special.make_empty (l_fields)
					elseif l_dtype = l_int.dynamic_type_from_string ("SPECIAL [NATURAL_8]") then
						create {SPECIAL [NATURAL_8]} l_special.make_empty (l_fields)
					elseif l_dtype = l_int.dynamic_type_from_string ("SPECIAL [NATURAL_16]") then
						create {SPECIAL [NATURAL_16]} l_special.make_empty (l_fields)
					elseif l_dtype = l_int.dynamic_type_from_string ("SPECIAL [NATURAL_32]") then
						create {SPECIAL [NATURAL_32]} l_special.make_empty (l_fields)
					elseif l_dtype = l_int.dynamic_type_from_string ("SPECIAL [NATURAL_64]") then
						create {SPECIAL [NATURAL_64]} l_special.make_empty (l_fields)
					elseif l_dtype = l_int.dynamic_type_from_string ("SPECIAL [REAL]") then
						create {SPECIAL [REAL]} l_special.make_empty (l_fields)
					elseif l_dtype = l_int.dynamic_type_from_string ("SPECIAL [DOUBLE]") then
						create {SPECIAL [DOUBLE]} l_special.make_empty (l_fields)
					elseif l_dtype = l_int.dynamic_type_from_string ("SPECIAL [BOOLEAN]") then
						create {SPECIAL [BOOLEAN]} l_special.make_empty (l_fields)
					elseif l_dtype = l_int.dynamic_type_from_string ("SPECIAL [POINTER]") then
						create {SPECIAL [POINTER]} l_special.make_empty (l_fields)
					else
						l_special := l_int.new_special_any_instance (l_dtype, l_fields)
					end
					rebuilt_objects.extend (l_special)
					from
						l_i := 0
					until
						l_i = l_fields
					loop
							-- read field index
						a_medium.read_integer_32
						l_field_index := a_medium.last_integer_32
						if l_field_index = -3 then -- recurring reference
							a_medium.read_integer_32 -- reading field index
							l_ref := a_medium.last_integer_32
							a_medium.read_integer_32 -- reading reference index
							l_special.force (rebuilt_objects.i_th (a_medium.last_integer_32), l_ref)
						elseif l_field_index /= -2 then -- if not void field, else skip
								-- read object (field)
							l_field := extract_object (a_medium)
							l_special.force (l_field, l_field_index)
						else
							--print ("deserializer: void field skiped%N")
						end
						l_i := l_i + 1
					end
					result := l_special
				elseif l_int.is_tuple_type (l_dtype) then -- tuple type
					l_object := l_int.new_instance_of (l_dtype)
					rebuilt_objects.extend (l_object)
					if attached {TUPLE} l_object as l_tuple then
							-- read fields count
						a_medium.read_integer_32
						l_fields := a_medium.last_integer_32
						from
							l_i := 1
						until
							l_i = l_fields + 1
						loop
								-- read field index
							a_medium.read_integer_32
							l_field_index := a_medium.last_integer_32
							if l_field_index = -3 then -- recurring reference
								a_medium.read_integer_32
								l_ref := a_medium.last_integer_32
								a_medium.read_integer_32
								l_tuple.put_reference (rebuilt_objects.i_th (a_medium.last_integer_32), l_ref)
							elseif l_field_index /= -2 then -- if not void, else skip
									-- read object (field)
								l_field := extract_object (a_medium)
								if attached {BOOLEAN} l_field as val then
									l_tuple.put_boolean (val, l_field_index)
								elseif attached {CHARACTER_8} l_field as val then
									l_tuple.put_character_8 (val, l_field_index)
								elseif attached {CHARACTER_32} l_field as val then
									l_tuple.put_character_32 (val, l_field_index)
								elseif attached {INTEGER_8} l_field as val then
									l_tuple.put_integer_8 (val, l_field_index)
								elseif attached {INTEGER_16} l_field as val then
									l_tuple.put_integer_16 (val, l_field_index)
								elseif attached {INTEGER_32} l_field as val then
									l_tuple.put_integer_32 (val, l_field_index)
								elseif attached {INTEGER_64} l_field as val then
									l_tuple.put_integer_64 (val, l_field_index)
								elseif attached {NATURAL_8} l_field as val then
									l_tuple.put_natural_8 (val, l_field_index)
								elseif attached {NATURAL_16} l_field as val then
									l_tuple.put_natural_16 (val, l_field_index)
								elseif attached {NATURAL_32} l_field as val then
									l_tuple.put_natural_32 (val, l_field_index)
								elseif attached {NATURAL_64} l_field as val then
									l_tuple.put_natural_64 (val, l_field_index)
								elseif attached {REAL} l_field as val then
									l_tuple.put_real (val, l_field_index)
								elseif attached {DOUBLE} l_field as val then
									l_tuple.put_double (val, l_field_index)
								elseif attached {POINTER} l_field as val then
									l_tuple.put_pointer (val, l_field_index)
								else
									l_tuple.put_reference (l_field, l_field_index)
								end
							else
								--print ("deserializer: void field skiped%N")
							end
							l_i := l_i + 1
						end
						result := l_object
					else
						print ("error decoding " + l_int.type_name_of_type (l_dtype) + "%N")
					end
				elseif l_dtype = l_int.dynamic_type_from_string ("BOOLEAN") then -- basic types
					a_medium.read_integer_8
					result := a_medium.last_integer_8.to_boolean
					rebuilt_objects.extend (result)
				elseif l_dtype = l_int.dynamic_type_from_string ("INTEGER_8") then
					a_medium.read_integer_8
					result := a_medium.last_integer_8
					rebuilt_objects.extend (result)
				elseif l_dtype = l_int.dynamic_type_from_string ("INTEGER_16") then
					a_medium.read_integer_16
					result := a_medium.last_integer_16
					rebuilt_objects.extend (result)
				elseif l_dtype = l_int.dynamic_type_from_string ("INTEGER_32") then
					a_medium.read_integer_32
					result := a_medium.last_integer_32
					rebuilt_objects.extend (result)
				elseif l_dtype = l_int.dynamic_type_from_string ("INTEGER_64") then
					a_medium.read_integer_64
					result := a_medium.last_integer_64
					rebuilt_objects.extend (result)
				elseif l_dtype = l_int.dynamic_type_from_string ("NATURAL_8") then
					a_medium.read_natural_8
					result := a_medium.last_natural_8
					rebuilt_objects.extend (result)
				elseif l_dtype = l_int.dynamic_type_from_string ("NATURAL_16") then
					a_medium.read_natural_16
					result := a_medium.last_natural_16
					rebuilt_objects.extend (result)
				elseif l_dtype = l_int.dynamic_type_from_string ("NATURAL_32") then
					a_medium.read_natural_32
					result := a_medium.last_natural_32
					rebuilt_objects.extend (result)
				elseif l_dtype = l_int.dynamic_type_from_string ("NATURAL_64") then
					a_medium.read_natural_64
					result := a_medium.last_natural_64
					rebuilt_objects.extend (result)
				elseif l_dtype = l_int.dynamic_type_from_string ("CHARACTER_8") then
					a_medium.read_character
					result := a_medium.last_character
					rebuilt_objects.extend (result)
				elseif l_dtype = l_int.dynamic_type_from_string ("CHARACTER_32") then
					a_medium.read_integer_32
					result := a_medium.last_integer_32.to_character_32
					rebuilt_objects.extend (result)
				elseif l_dtype = l_int.dynamic_type_from_string ("DOUBLE") then
					a_medium.read_double
					result := a_medium.last_double
					rebuilt_objects.extend (result)
				elseif l_dtype = l_int.dynamic_type_from_string ("REAL") then
					a_medium.read_real
					result := a_medium.last_real
					rebuilt_objects.extend (result)
				elseif l_dtype = l_int.dynamic_type_from_string ("POINTER") then --- does not work, should be saved as int64
					print ("warning: deserializing pointer%N")
					a_medium.read_integer_64
					result := a_medium.default_pointer + a_medium.last_integer_64.as_integer_32
					rebuilt_objects.extend (result)
				else -- normal type
					l_object := l_int.new_instance_of (l_dtype)
					rebuilt_objects.extend (l_object)
						-- read fields count
					a_medium.read_integer_32
					l_fields := a_medium.last_integer_32
					from
						l_i := 1
					until
						l_i = l_fields + 1
					loop
							-- read field index
						a_medium.read_integer_32
						l_field_index := a_medium.last_integer_32
						if l_field_index = -3 then -- recurring reference
							a_medium.read_integer_32
							l_ref := a_medium.last_integer_32
							a_medium.read_integer_32
							l_field := rebuilt_objects.i_th (a_medium.last_integer_32)
							if attached l_field as f then
								l_int.set_reference_field (l_ref, l_object, f)
							end
						elseif l_field_index /= -2 then -- if not void field, else skip
								-- read object (field)
							l_field := extract_object (a_medium)
							if attached {SPECIAL [ANY]} l_field as l_spec then
								l_int.set_reference_field (l_field_index, l_object, l_spec)
							elseif attached {TUPLE} l_field as l_tup then
								l_int.set_reference_field (l_field_index, l_object, l_tup)
							elseif attached {BOOLEAN} l_field as val then
								l_int.set_boolean_field (l_field_index, l_object, val)
							elseif attached {CHARACTER_8} l_field as val then
								l_int.set_character_8_field (l_field_index, l_object, val)
							elseif attached {CHARACTER_32} l_field as val then
								l_int.set_character_32_field (l_field_index, l_object, val)
							elseif attached {INTEGER_8} l_field as val then
								l_int.set_integer_8_field (l_field_index, l_object, val)
							elseif attached {INTEGER_16} l_field as val then
								l_int.set_integer_16_field (l_field_index, l_object, val)
							elseif attached {INTEGER_32} l_field as val then
								l_int.set_integer_32_field (l_field_index, l_object, val)
							elseif attached {INTEGER_64} l_field as val then
								l_int.set_integer_64_field (l_field_index, l_object, val)
							elseif attached {NATURAL_8} l_field as val then
								l_int.set_natural_8_field (l_field_index, l_object, val)
							elseif attached {NATURAL_16} l_field as val then
								l_int.set_natural_16_field (l_field_index, l_object, val)
							elseif attached {NATURAL_32} l_field as val then
								l_int.set_natural_32_field (l_field_index, l_object, val)
							elseif attached {NATURAL_64} l_field as val then
								l_int.set_natural_64_field (l_field_index, l_object, val)
							elseif attached {REAL} l_field as val then
								l_int.set_real_32_field (l_field_index, l_object, val)
							elseif attached {DOUBLE} l_field as val then
								l_int.set_double_field (l_field_index, l_object, val)
							elseif attached {POINTER} l_field as val then
								l_int.set_pointer_field (l_field_index, l_object, val)
							else
								l_int.set_reference_field (l_field_index, l_object, l_field)
							end
						else
							--print ("deserializer: void field skiped%N")
						end
						l_i := l_i + 1
					end
					result := l_object
				end
			else
				print ("error: invalid dynamic type " + l_dtype.out + "%N")
			end
		end

end
