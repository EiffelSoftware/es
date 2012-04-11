indexing
	description: "Predicate used in Native Queries for PARALLELOGRAM"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	PARALLELOGRAM_PREDICATE

inherit
	DB4O_PREDICATE

feature
	match (p: PARALLELOGRAM): BOOLEAN is
			-- Is `p.height1' + `p.height2' greater than 20?
		do
			Result := p.height1 + p.height2 > 20
		end


end
