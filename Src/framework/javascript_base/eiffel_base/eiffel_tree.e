note
	description : "JavaScript implementation of EiffelBase class TREE and variations."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBase: TREE, LINKED_TREE"

class
	EIFFEL_TREE[G]

create
	make

feature {NONE} -- Initialization

	make (a_item: G)
		do
			create children.make
			item := a_item
		end

feature -- Basic Operation

	first_element: EIFFEL_TREE[G]
		do
			Result := children[0]
		end

	put_child (a_child: attached EIFFEL_TREE[G])
		do
			children.push (a_child)
		end

	readable : BOOLEAN = true

feature {NONE} -- Implementation

	parent: EIFFEL_TREE[G]
	item: G
	children: attached JS_ARRAY[attached EIFFEL_TREE[G]]

end
