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
			create hash_set.make (1)
		end

feature -- Basic Operation

	count: INTEGER
		do
			Result := hash_set.count
		end

	has (v: G): BOOLEAN
		do
			Result := hash_set.has (v.out)
		end

	extend (v : G)
		do
			hash_set.put (true, v.out)
		end

	is_empty: BOOLEAN
		do
			Result := count = 0
		end

	prune (v : G)
		do
			hash_set.remove (v.out)
		end

	prune_all (v : G)
		do
			hash_set.remove (v.out)
		end

	put (v : G)
		do
			hash_set.put (true, v.out)
		end

	wipe_out
		do
			make
		end

feature {NONE} -- Implementation

	hash_set: attached HASH_TABLE[BOOLEAN, attached STRING]
end
