note
	description: "Object traversor"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AD_OBJECT_TRAVERSABLE

inherit

	OBJECT_GRAPH_DEPTH_FIRST_TRAVERSABLE
	redefine
			internal_traverse,
			new_dispenser
	end

feature {NONE} -- Implementation


	new_dispenser: ARRAYED_STACK [ TUPLE [object: ANY; field_index: INTEGER] ]
			-- Create the dispenser to use for storing visited objects.
		do
			create Result.make (default_size)
		end

	is_basic_type (an_object: ANY): BOOLEAN
		do
			if attached {INTEGER_32} an_object or else attached {BOOLEAN} an_object or else attached {INTEGER_8} an_object or else attached {INTEGER_16} an_object or else attached {INTEGER_64} an_object or else attached {NATURAL_8} an_object or else attached {NATURAL_16} an_object or else attached {NATURAL_32} an_object or else attached {NATURAL_64} an_object or else attached {CHARACTER_8} an_object or else attached {CHARACTER_32} an_object or else attached {DOUBLE} an_object or else attached {REAL} an_object or else attached {POINTER} an_object then
				Result := True
			else
				Result := False
			end
		end


	internal_traverse
			-- Traverse object structure starting at 'root_object' and call object_action
			-- on every object in the graph.
		local
			i, nb: INTEGER
			l_object: ANY
			l_index: INTEGER
			l_field: detachable ANY
			l_int: INTERNAL
			l_objects_to_visit: like new_dispenser
			--l_ref: HASH_TABLE [INTEGER, ANY]
			l_visited: like visited_objects
			l_visited_index: ARRAYED_LIST [INTEGER]
			l_action: like object_action
			l_dtype: INTEGER
			l_spec: SPECIAL [ANY]
			r: like root_object
		do
			from
				--{MEMORY}.collection_off
				create l_int
				create visited_objects.make (default_size)
				create l_visited.make (default_size)
				create l_visited_index.make (default_size)
				create visited_objects.make (default_size)
				--create l_ref.make (default_size)
				l_objects_to_visit := new_dispenser
				r := root_object
				if r /= Void then
					l_objects_to_visit.put ([r,-1])
					l_int.mark (r)
				end
				l_action := object_action
			until
				l_objects_to_visit.is_empty
			loop
				l_object := l_objects_to_visit.item.object
				l_index := l_objects_to_visit.item.field_index
				l_objects_to_visit.remove
					-- Process and add `l_object' to processed objects
				l_visited.extend (l_object)
				l_visited_index.extend (l_index)

				if
					not is_basic_type (l_object)
					and l_index > -2
				then
						-- Iterate through fields of `l_object'.
						-- There are three major types of object:
						-- 1 - SPECIAL [ANY]
						-- 2 - TUPLE containing references
						-- 3 - Normal objects
					l_dtype := l_int.dynamic_type (l_object)
					if l_int.is_special_type (l_dtype) then
						if attached {SPECIAL [detachable ANY]} l_object as l_sp then
							from
								i := l_sp.count - 1
								nb := -1
							until
								i = nb
							loop
								l_field := l_sp.item (i)
								if l_field /= Void then
									if is_basic_type (l_field) then -- We report that a field of primitive type is visited.
										l_objects_to_visit.put ([l_field,i])
									elseif not l_int.is_marked (l_field) then
										l_int.mark (l_field)
										l_objects_to_visit.put ([l_field,i])
									else
										l_objects_to_visit.put ([l_field,-10-i]) -- recurring reference
									end
								else
									l_objects_to_visit.put ([1,-2]) -- void field
								end
								i := i - 1
							end
						else
							print ("traverser: special case not handled at index "+i.out+": "+l_int.type_name (l_object)+"%N")
						end
					elseif l_int.is_tuple (l_object) then
						if attached {TUPLE} l_object as l_tuple_obj then
							from
								i := l_tuple_obj.count
								nb := 0
							until
								i = nb
							loop
								if l_tuple_obj.is_reference_item (i) then
									l_field := l_tuple_obj.reference_item (i)
									if l_field /= Void and then not l_int.is_marked (l_field) then
										l_int.mark (l_field)
										l_objects_to_visit.put ([l_field,i])
									elseif l_int.is_marked (l_field) then
										l_objects_to_visit.put ([l_field,-10-i]) -- reccurring reference
									else
										l_objects_to_visit.put ([1,-2]) -- void field
									end
								elseif l_tuple_obj.is_integer_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.integer_item (i),i])
								elseif l_tuple_obj.is_boolean_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.boolean_item (i),i])
								elseif l_tuple_obj.is_real_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.real_item (i),i])
								elseif l_tuple_obj.is_double_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.double_item (i),i])
								elseif l_tuple_obj.is_character_8_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.character_8_item (i),i])
								elseif l_tuple_obj.is_character_32_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.character_32_item (i),i])
								elseif l_tuple_obj.is_integer_8_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.integer_8_item (i),i])
								elseif l_tuple_obj.is_integer_16_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.integer_16_item (i),i])
								elseif l_tuple_obj.is_integer_32_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.integer_32_item (i),i])
								elseif l_tuple_obj.is_integer_64_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.integer_64_item (i),i])
								elseif l_tuple_obj.is_natural_8_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.natural_8_item (i),i])
								elseif l_tuple_obj.is_natural_16_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.natural_16_item (i),i])
								elseif l_tuple_obj.is_natural_32_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.natural_32_item (i),i])
								elseif l_tuple_obj.is_natural_64_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.natural_64_item (i),i])
								elseif l_tuple_obj.is_pointer_item (i) then
									l_objects_to_visit.put ([l_tuple_obj.pointer_item (i),i])
								else
									print ("traverser: tuple basic case not handled at index "+i.out+" in "+l_int.type_name (l_object)+"%N")
								end
								i := i - 1
							end
						else
							print ("traverser: tuple case not handled at index "+i.out+" in "+l_int.type_name (l_object)+"%N")
						end
					else
						from
							i := l_int.field_count_of_type (l_dtype)
							nb := 0
						until
							i = nb
						loop
							if l_int.field_type_of_type (i, l_dtype) = {INTERNAL}.reference_type then
								if not is_skip_transient or else not l_int.is_field_transient_of_type (i, l_dtype) then
									l_field := l_int.field (i, l_object)
									if l_field /= Void then
										if is_basic_type (l_field) then -- We report that a field of primitive type is visited.
											l_objects_to_visit.put ([l_field,i])
										elseif not l_int.is_marked (l_field) then
											l_int.mark (l_field)
											l_objects_to_visit.put ([l_field,i])
										else
											l_objects_to_visit.put ([l_field,-10-i]) -- recurring reference
										end
									else
										l_objects_to_visit.put ([1,-2]) -- void field
									end
								else
									print ("traverser: transient case not handled at index "+i.out+" in "+l_int.type_name_of_type (l_dtype)+"%N")
								end
							else
									-- We report that a field of primitive type is visited.
								l_field := l_int.field (i, l_object)
								if l_field /= Void then
									l_objects_to_visit.put ([l_field,i])
								else
									l_objects_to_visit.put ([1,-2]) -- should not happen
								end
							end
							i := i - 1
						variant
							i-nb
						end
					end
				end
			end
				-- Unmark, update recurring references and process items.
			from
				l_visited.start
				l_visited_index.start
				visited_objects.compare_references
			until
				l_visited.off
			loop
				if l_int.is_marked (l_visited.item) then -- unmarking
					l_int.unmark (l_visited.item)
				end
				if l_visited_index.item <= -10 then -- check and then update reference
					print ("processing reference: "+l_int.type_name (l_visited.item)+", "+l_visited_index.item.out+"%N")
					if visited_objects.has (l_visited.item) then -- change object to reference of previous object
						visited_objects.start
						l_visited.put (visited_objects.index_of (l_visited.item, 1))
						print (" -> changed to: " + l_visited.item.out + ", "+l_visited_index.item.out+"%N")
					else -- object referenced will come later so change this index to normal and search for the other object
						print("has to be corrected to ")
						l_visited_index.put (-10 - l_visited_index.item)
						print (l_visited_index.item.out+" and update "+l_visited.occurrences (l_visited.item).out+" other fields%N")
						from
							i := 2
							nb := l_visited.occurrences (l_visited.item)+1
						until
							i = nb
						loop
							print("visiting " + i.out + " of " + l_visited.occurrences (l_visited.item).out+"%N")
							l_index := l_visited.index_of (l_visited.item, i)
							if l_visited_index.i_th (l_index) > -10 then
								l_visited_index.put_i_th (-10 - l_visited_index.i_th (l_index), l_index)
								print("done%N")
							end
							i := i+1
						end
						print(" -> changed to: "+l_int.type_name (l_visited.item)+", "+l_visited_index.item.out+"%N")
					end
				end
														-- Call action.
				if l_action /= Void then
					l_action.call ([l_visited.item, l_visited_index.item]) 	-- 1) valid object: l_object = object, l_index = positive index or -1 for root
																			-- 2) void reference: l_object = 1 (or something not void), l_index = -2
				end															-- 3) recurring reference: l_object = index of referencing object, l_index = -10 - positive index of field


				visited_objects.extend (l_visited.item)
				l_visited.forth
				l_visited_index.forth
			end
			--{MEMORY}.collection_on
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
		Eiffel Software
		5949 Hollister Ave., Goleta, CA 93117 USA
		Telephone 805-685-1006, Fax 805-685-6869
		Website http://www.eiffel.com
		Customer support http://support.eiffel.com
	]"

end
