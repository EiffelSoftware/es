note
	description: "Class that represents a ngram node"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_NGRAM_NODE

create
	make,
	make_as_leaf

feature{NONE} -- Initialization

	make (a_key: STRING)
			-- Initialize current.
		do
			key := a_key
			create next.make (2)
			next.compare_objects
		end

	make_as_leaf (a_key: STRING)
			-- Initialize current as a leaf
		do
			key := a_key
		end

feature -- Access

	key: STRING
			-- Key of current node

	value: DOUBLE
			-- Value of current node

	next: detachable HASH_TABLE [EXT_NGRAM_NODE, STRING]
			-- Next level

feature -- Status report

	is_leaf: BOOLEAN
			-- Is current a leaf node?
		do
			Result :=
				next = Void or else
				next.is_empty
		end

end
