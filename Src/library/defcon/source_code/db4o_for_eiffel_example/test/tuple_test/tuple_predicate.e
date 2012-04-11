indexing
	description: "Predicate used in Native Queries for TUPLE"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	TUPLE_PREDICATE

inherit
	DB4O_PREDICATE
	GENERICITY_HELPER

feature
	match (t: TUPLE[BOOLEAN]): BOOLEAN is
			-- Does `t' fulfill matching criteria?
		do
			Result := conforms_to_object (t, create {TUPLE[BOOLEAN]})
			Result := Result and then t.is_equal ([True, -123, 'a'])
		end

end
