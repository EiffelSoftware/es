class OWNERSHIP_SET

inherit

	ANY
		redefine
			default_create
		end

create
	default_create,
	make_from_tuple,
	make_from_array

feature

	default_create
		do
		end

	make_from_tuple (a_tuple: TUPLE)
		do
		end

	make_from_array (a_array: ARRAY [ANY])
		do
		end

end
