indexing
	description: "Predicate used in Native Queries for POINT"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	POINT_PREDICATE

inherit
	DB4O_PREDICATE

feature
	match (pnt: POINT): BOOLEAN is
			-- Is `pnt.x' greater than 10?
		do
			Result := pnt.x > 10
		end


end
