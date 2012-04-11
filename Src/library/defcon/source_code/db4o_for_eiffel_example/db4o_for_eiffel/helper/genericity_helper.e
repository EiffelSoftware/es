indexing
	description: "[
			Helper to test conformance of one object to another object,
	        and to filter out objects in a collection which do not conform to 
	        the specified object.
	        This class may be used as ancestor by classes needing its facilities,
	        e.g. PREDICATE subclasses used for Native Queries in db4o databases.
	    ]"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	GENERICITY_HELPER

inherit
	INTERNAL

feature  -- Conformance

	conforms_to_object (obj1: ANY; obj2: ANY): BOOLEAN is
			-- Does `obj1' conform to `obj2'?
			-- The result takes conformance of generically derived types into account.
		require
			obj1_not_void: obj1 /= Void
			obj2_not_void: obj2 /= Void
		do
			Result := conforms_to_type (dynamic_type (obj1), dynamic_type (obj2))
		end

feature {INTERNAL}  -- Conformance

	conforms_to_type (type_id1, type_id2: INTEGER): BOOLEAN is
			-- Does `type_id1' conform to `type_id2'?
			-- The result takes conformance of generically derived types into account.
		require
			type_id1_nonnegative: type_id1 >= 0
			type_id2_nonnegative: type_id2 >= 0
		local
			type1, type2: RT_GENERIC_TYPE
			count1, count2: INTEGER
			i: INTEGER
		do
			type1 ?= pure_implementation_type (type_id1)
			type2 ?= pure_implementation_type (type_id2)
			if (type1 = Void and type2 = Void) then
				Result := type_conforms_to (type_id1, type_id2)
			elseif (type1 = Void or type2 = Void) then
				Result := False
			else
				count1 := generic_count_of_type (type_id1)
				count2 := generic_count_of_type (type_id2)
				if ( (count1 /= count2) and not (is_tuple_type (type_id1) and is_tuple_type (type_id2))) then
					Result := False
				elseif (count1 < count2) then
					Result := False
				else
					Result := type_conforms_to (type_id1, type_id2)
					from
						i := 1
					until
						not Result or i = count2 + 1
					loop
						Result := conforms_to_type (generic_dynamic_type_of_type (type_id1, i), generic_dynamic_type_of_type (type_id2, i))
						i := i + 1
					end
				end
			end
		end

feature  -- Filter

	get_conforming_objects (a_list: ILIST; an_object: SYSTEM_OBJECT): LIST[SYSTEM_OBJECT] is
			-- List of objects in `a_list' which conform to `an_object'
		require
			list_not_void: a_list /= Void
			an_object_not_void: an_object /= Void
		local
			obj: SYSTEM_OBJECT
			i: INTEGER
			result_list: LINKED_LIST[SYSTEM_OBJECT]
		do
			create result_list.make
			from
				i := 0
			until
				i = a_list.count
			loop
				obj := a_list.item (i)
				if (obj /= Void and then conforms_to_object (obj, an_object)) then
					result_list.extend (obj)
				end
				i := i + 1
			end
			Result := result_list
		end

end
