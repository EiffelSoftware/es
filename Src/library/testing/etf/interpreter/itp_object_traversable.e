note
	description: "Object traversor"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ITP_OBJECT_TRAVERSABLE

inherit
	OBJECT_GRAPH_BREADTH_FIRST_TRAVERSABLE
		redefine
			internal_traverse
		end

feature{NONE} -- Implementation

	internal_traverse
			-- Traverse object structure starting at 'root_object' and call object_action
			-- on every object in the graph.
		local
			i, nb: INTEGER
			l_object: ANY
			l_field: detachable ANY
			l_int: INTERNAL
			l_objects_to_visit: like new_dispenser
			l_visited: like visited_objects
			l_action: like object_action
			l_dtype: INTEGER
			l_spec: SPECIAL [ANY]
			r: like root_object
		do
			from
				create l_int
				create l_visited.make (default_size)
				l_objects_to_visit := new_dispenser
				r := root_object
				if r /= Void then
					l_objects_to_visit.put (r)
					l_int.mark (r)
				end
				l_action := object_action
			until
				l_objects_to_visit.is_empty
			loop
				l_object := l_objects_to_visit.item
				l_objects_to_visit.remove

					-- Add `l_object' to processed objects.
				l_visited.extend (l_object)

					-- Call action.
				if l_action /= Void then
					l_action.call ([l_object])
				end

					-- Iterate through fields of `l_object'.
					-- There are three major types of object:
					-- 1 - SPECIAL [ANY]
					-- 2 - TUPLE containing references
					-- 3 - Normal objects
				l_dtype := l_int.dynamic_type (l_object)
				if l_int.is_special_type (l_dtype) then
					if l_int.is_special_any_type (l_dtype) then
						if attached {SPECIAL [detachable ANY]} l_object as l_sp then
							from
								i := 0
								nb := l_sp.count
							until
								i = nb
							loop
								l_field := l_sp.item (i)
								if l_field /= Void then
									if
										attached {INTEGER_32} l_field or else
										attached {BOOLEAN} l_field or else
										attached {INTEGER_8} l_field or else
										attached {INTEGER_16} l_field or else
										attached {INTEGER_64} l_field or else
										attached {NATURAL_8} l_field or else
										attached {NATURAL_16} l_field or else
										attached {NATURAL_32} l_field or else
										attached {NATURAL_64} l_field or else
										attached {CHARACTER_8} l_field or else
										attached {CHARACTER_32} l_field or else
										attached {DOUBLE} l_field or else
										attached {REAL} l_field or else
										attached {POINTER} l_field
									then
											-- We report that a field of primitive type is visited.
										l_field := l_int.field (i, l_object)
										if l_field /= Void and then l_action /= Void then
											l_action.call ([l_field])
										end
									elseif not l_int.is_marked (l_field) then
										l_int.mark (l_field)
										l_objects_to_visit.put (l_field)
									end

								end
								i := i + 1
							end
						end
					end
				elseif l_int.is_tuple (l_object) then
					if attached {TUPLE} l_object as l_tuple_obj then
						from
							i := 1
							nb := l_tuple_obj.count + 1
						until
							i = nb
						loop
							if l_tuple_obj.is_reference_item (i) then
								l_field := l_tuple_obj.reference_item (i)
								if l_field /= Void and then not l_int.is_marked (l_field) then
									l_int.mark (l_field)
									l_objects_to_visit.put (l_field)
								end
							elseif l_tuple_obj.is_integer_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.integer_item (i)])
								end
							elseif l_tuple_obj.is_boolean_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.boolean_item (i)])
								end
							elseif l_tuple_obj.is_real_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.real_item (i)])
								end
							elseif l_tuple_obj.is_double_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.double_item (i)])
								end
							elseif l_tuple_obj.is_character_8_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.character_8_item (i)])
								end
							elseif l_tuple_obj.is_character_32_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.character_32_item (i)])
								end
							elseif l_tuple_obj.is_integer_8_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.integer_8_item (i)])
								end
							elseif l_tuple_obj.is_integer_16_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.integer_16_item (i)])
								end
							elseif l_tuple_obj.is_integer_64_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.integer_64_item (i)])
								end
							elseif l_tuple_obj.is_natural_8_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.natural_8_item (i)])
								end
							elseif l_tuple_obj.is_natural_16_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.natural_16_item (i)])
								end
							elseif l_tuple_obj.is_natural_32_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.natural_32_item (i)])
								end
							elseif l_tuple_obj.is_natural_64_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.natural_64_item (i)])
								end
							elseif l_tuple_obj.is_pointer_item (i) then
								if l_action /= Void then
									l_action.call ([l_tuple_obj.pointer_item (i)])
								end
							end
							i := i + 1
						end
					end
				else
					from
						i := 1
						nb := l_int.field_count_of_type (l_dtype) + 1
					until
						i = nb
					loop
						if l_int.field_type_of_type (i, l_dtype) = {INTERNAL}.reference_type then
							if not is_skip_transient or else not l_int.is_field_transient_of_type (i, l_dtype) then
								l_field := l_int.field (i, l_object)
								if l_field /= Void then
									if
										attached {INTEGER_32} l_field or else
										attached {BOOLEAN} l_field or else
										attached {INTEGER_8} l_field or else
										attached {INTEGER_16} l_field or else
										attached {INTEGER_64} l_field or else
										attached {NATURAL_8} l_field or else
										attached {NATURAL_16} l_field or else
										attached {NATURAL_32} l_field or else
										attached {NATURAL_64} l_field or else
										attached {CHARACTER_8} l_field or else
										attached {CHARACTER_32} l_field or else
										attached {DOUBLE} l_field or else
										attached {REAL} l_field or else
										attached {POINTER} l_field
									then
											-- We report that a field of primitive type is visited.
										l_field := l_int.field (i, l_object)
										if l_field /= Void and then l_action /= Void then
											l_action.call ([l_field])
										end
									elseif not l_int.is_marked (l_field) then
										l_int.mark (l_field)
										l_objects_to_visit.put (l_field)
									end
								end
							end
						else
								-- We report that a field of primitive type is visited.
							l_field := l_int.field (i, l_object)
							if l_field /= Void and then l_action /= Void then
								l_action.call ([l_field])
							end
						end
						i := i + 1
					variant
						nb - i
					end
				end
			end

				-- Unmark all objects.
			from
				i := 0
				nb := l_visited.count
				l_spec := l_visited.area
			until
				i = nb
			loop
				l_int.unmark (l_spec.item (i))
				i := i + 1
			end

				-- Set `visited_objects'.
			visited_objects := l_visited
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
