indexing
	description: "Binary trees"
	author: "Ruihua Jin"
	date: "$Date: 2007/10/19 10:14:59$"
	revision: "$Revision: 1.0$"

class
	BTREE

create
	make_id,
	make_id_parent,
	make

feature {NONE}  -- Initialization

	make_id (i: INTEGER) is
			-- Initialize `id' with `i'.
		do
			set_id (i)
		end

	make_id_parent (i: INTEGER; p: BTREE) is
			-- Initialize `id' with `i' and `parent' with `p'.
		do
			make_id (i)
			set_parent (p)
		end

	make (i: INTEGER; p: BTREE; l: BTREE; r: BTREE) is
			-- Initialize `id' with `i', `parent' with `p',
			-- `left' with `l' and `right' with `r'.
		do
			make_id_parent (i, p)
			set_left (l)
			set_right (r)
		end


feature
	set_parent (p: BTREE) is
			-- Set the parent node `parent' of the current node.
		do
			parent := p
		end

	set_left (l: BTREE) is
			-- Set the left child node `left' of the current node.
		do
			left := l
			if (left /= Void) then
				left.set_parent (Current)
			end
		end

	set_right (r: BTREE) is
			-- Set the right child node `right' of the current node.
		do
			right := r
			if (right /= Void) then
				right.set_parent (Current)
			end
		end

	set_id (i: INTEGER) is
			-- Set `id'.
		do
			id := i
		end

feature  -- Access

	parent: BTREE
			-- The parent node of the current node

	left, right: BTREE
			-- The left and right child nodes of the current node

	id: INTEGER
			-- The ID of the current node

end
