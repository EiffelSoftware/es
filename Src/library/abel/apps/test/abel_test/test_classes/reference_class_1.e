note
	description: "Summary description for {REFERENCE_CLASS_1}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REFERENCE_CLASS_1
inherit
	ANY redefine out end


create make

feature

	make (i:INTEGER)
		do
			ref_class_id:= i
			create references.make
--			create ref_arrays.make_filled (Void, 1, 10)
		end

	ref_class_id:INTEGER
	references:LINKED_LIST[REFERENCE_CLASS_1]
	refer: detachable REFERENCE_CLASS_1

	add_ref (ref: REFERENCE_CLASS_1)
		do
			refer:= ref
		end

--	ref_arrays: ARRAY[detachable REFERENCE_CLASS_1]


	out:STRING
	do
		Result:= tagged_out
--		Result:= "id = " + ref_class_id.out + "%N %T references: %N%T%T"
--		across references as cursor
--		loop
--			Result := result + cursor.item.ref_class_id.out + "%N%T%T"
--		end

--		Result:= Result + "%N"
	end

end
