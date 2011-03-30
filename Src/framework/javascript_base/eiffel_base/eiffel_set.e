note
	description : "JavaScript implementation of EiffelBase class SET and variations."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBase: LINKED_SET, SET"

class
	EIFFEL_SET [G -> attached ANY]

create
	make

feature {NONE} -- Initialization

	make
		do
			create inner_array.make_as_obj
		end

feature -- Basic Operation

	count: INTEGER
		do
			Result := inner_array.length
		end

	has (v: G): BOOLEAN
		do
			Result := inner_array.has_item_by_name (v.out)
		end

	extend (v : G)
		do
			inner_array.set_item_by_name (v.out, true)
		end

	is_empty: BOOLEAN
		do
			Result := count = 0
		end

	prune (v : G)
		do
			inner_array.remove_item_by_name (v.out)
		end

	prune_all (v : G)
		do
			inner_array.remove_item_by_name (v.out)
		end

	put (v : G)
		do
			inner_array.set_item_by_name (v.out, true)
		end

	wipe_out
		do
			make
		end

feature {NONE} -- Implementation

	inner_array: attached JS_ARRAY[BOOLEAN]

end
