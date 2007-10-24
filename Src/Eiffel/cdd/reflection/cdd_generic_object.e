indexing
	description: "Objects that represent reflections of generic objects"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_GENERIC_OBJECT

inherit

	CDD_REGULAR_OBJECT

create
	make_generic

feature {NONE} -- Initialization

	make_generic (a_type: like dynamic_type; a_count: INTEGER; a_gen_type: STRING) is
			-- Create reflection for generic object of type `a_type' with generic parameter `a_gen_type'
			-- `a_count' is number of attributes 'a_type' has defined.
		require
			a_type_not_void: a_type /= Void
			-- NOTE: Produced error with empty generic clause (e.g. TUPLE objects)
			a_gen_type_not_empty: a_gen_type /= Void -- and then not a_gen_type.is_empty
		do
			make_with_count (a_type, a_count)
			type.append (" " + a_gen_type)
		ensure
			type_modified: type.has_substring (a_gen_type)
		end

end
