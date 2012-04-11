indexing
	description: "Predicate used in Native Queries for GLIST[G]"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"


class
	GLIST_PREDICATE

inherit
	DB4O_PREDICATE
	GENERICITY_HELPER

feature

	match (gl: GLIST[PARALLELOGRAM]): BOOLEAN is
			-- Does `gl' fulfill matching criteria?
		do
			Result := conforms_to_object (gl, create {GLIST[PARALLELOGRAM]})
			Result := Result and then gl.item.height1 > 10
		end


end
