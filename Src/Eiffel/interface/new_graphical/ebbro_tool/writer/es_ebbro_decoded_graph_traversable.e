indexing
	description: "Objects that traverse a DECODED object graph starting at a specified root DECODED object"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_EBBRO_DECODED_GRAPH_TRAVERSABLE

inherit
	OBJECT_GRAPH_TRAVERSABLE
	redefine
		internal_traverse
	end

feature -- implementation

	internal_traverse is

	local
		i, nb: INTEGER
		l_object: ANY
		l_field: ?ANY
		l_int: INTERNAL
		l_objects_to_visit: like new_dispenser
		l_visited: like visited_objects
		l_action: like object_action
		l_tuple: TUPLE [ANY]
		l_dtype: INTEGER
		l_spec: SPECIAL [ANY]
		l_arr: ?ARRAY [ANY]
		r: like root_object
		l_decoded: BINARY_DECODED
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
			create l_tuple
		until
			l_objects_to_visit.is_empty
		loop
			l_object := l_objects_to_visit.item
			l_objects_to_visit.remove

				-- Add `l_object' to processed objects.
			l_visited.extend (l_object)

				-- Call action.
			if l_action /= Void then
				l_tuple.put_reference (l_object, 1)
				l_action.call (l_tuple)
			end

			l_decoded ?= l_object
			if l_decoded = Void then
			-- we're dealing with a primitive object that is not wrapped in a 'DECODED' object
				-- Iterate through fields of `l_object'.
				-- There are three major types of object:
				-- 1 - SPECIAL [ANY]
				-- 2 - TUPLE containing references
				-- 3 - Normal objects
				l_dtype := l_int.dynamic_type (l_object)
				if l_int.is_special_type (l_dtype) then
					if l_int.is_special_any_type (l_dtype) then
						if {l_sp: SPECIAL [ANY]} l_object then
							from
								i := 0
								nb := l_sp.count
							until
								i = nb
							loop
								l_field := l_sp.item (i)
								if l_field /= Void and then not l_int.is_marked (l_field) then
									l_int.mark (l_field)
									l_objects_to_visit.put (l_field)
								end
								i := i + 1
							end
						end
					end
				elseif l_int.is_tuple (l_object) then
					if {l_tuple_obj: TUPLE} l_object then
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
							end
							i := i + 1
						end
					end
				else
					from
						i := 1
						nb := l_int.field_count_of_type (l_dtype) + 1
					variant
						nb - i
					until
						i = nb
					loop
						if l_int.field_type_of_type (i, l_dtype) = {INTERNAL}.reference_type then
							l_field := l_int.field (i, l_object)
							if l_field /= Void and then not l_int.is_marked (l_field) then
								l_int.mark (l_field)
								l_objects_to_visit.put (l_field)
							end
						end
						i := i + 1
					end
				end
-----------------------------------------------------------------------------
			else
				-- we're dealing with a 'DECODED' object
				from
					i := 1
					nb := l_decoded.attribute_values.count + 1
				variant
					nb - i
				until
					i = nb
				loop
					l_field := l_decoded.attribute_values.i_th (i).object
					if l_field /= Void  then
						if not l_int.is_marked (l_field) then
							--this is a hack INTERNAL is able to check if an object is of a reference type:
					----------------------------------------------
							l_int.mark (l_field)
							if l_int.is_marked (l_field) then
									-- only reference types can be marked
								l_objects_to_visit.put (l_field)
							end
					----------------------------------------------
						end
					end
					i := i + 1
				end
			end

------------------------------------------------------------------------------				

		end

			-- Unmark all objects.
		from
			i := 0
			nb := l_visited.count
			l_arr := l_visited
			l_spec := l_arr.area
			l_arr := Void
		until
			i = nb
		loop
			l_int.unmark (l_spec.item (i))
			i := i + 1
		end

			-- Set `visited_objects'.
		visited_objects := l_visited
	end




end
