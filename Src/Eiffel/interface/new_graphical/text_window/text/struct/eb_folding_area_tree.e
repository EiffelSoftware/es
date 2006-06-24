indexing
	description: "AVL-like tree with linked leaves for storing FOLDING_AREAs"
	author: "bherlig"
	date: "$06/21/2006$"
	revision: "$0.9$"

class
	EB_FOLDING_AREA_TREE
create
	make

feature -- Initialization

	make is
			-- Initialize empty AVL-Tree.
		do
			root := Void
			first := root
			last := root
		ensure count = 0
		end

feature -- Access

	item (key: like root): like root is
			-- Data stored with `key'; may be Void.
		local
			node: like root
		do
			from
				node := root
			until
				node = Void or else node.is_equal (key)
			loop
				if key < node then
					node := node.left
				else
					node := node.right
				end
			end
			if node /= Void then
				Result := node
			end
		end

	item_with_line (a_line: INTEGER): like root is
			-- searches for a folding-area with starting line 'a_line'
		local
			node: like root
		do
			from
				node := root
			until
				node = Void or else node.start_line.is_equal (a_line)
			loop
				if a_line < node.start_line then
					node := node.left
				else
					node := node.right
				end
			end
			if node /= Void then
				Result := node
			end
		end

	first_item_after_line(a_line: INTEGER): like root is
			-- returns the first folding-area after "a_line"
		do
			if root /= Void then
				result := recursive_first_item_after_line (a_line, root)
			else
				Result := Void
			end
		end


	has(key: like root): BOOLEAN is
			-- does the tree have an item with 'key'?
		local
			data: like root
		do
			data := item(key)
			if (data /= Void) then
				result := true
			else
				result := false
			end
		end


	root: EB_FOLDING_AREA
			-- Tree root.
	first, last: like root
		-- the very first/last element in the linked-list

feature -- Measurement

	count: INTEGER is
			-- Number of nodes in tree.
		do
			Result := count_subtree (root)
		ensure
			Result_not_negative: Result >= 0
		end

	count_subtree (node: like root): INTEGER is
			-- Number of nodes in subtree rooted at `node'.
		do
			if node = Void then
				Result := 0
			else
				Result := 1 + count_subtree (node.left) + count_subtree (node.right)
			end
		ensure
			Result_not_negative: Result >= 0
		end

feature -- Element change

	extend, force (key: like root) is
			-- Add entry {`key', `data'}.
		do
			recursive_force (key, root, Void)
		end

	remove (key: like root) is
			-- Remove entry with `key' if it exists.
		do
			-- delete link in linked-list
			if key /= Void then
					if (not key.item.feature_name.out.is_equal(first.item.feature_name.out)) then
						key.previous.set_next (key.next)
					else
						first := key.next
						key.set_previous (Void)
					end
					if (not key.item.feature_name.out.is_equal(last.item.feature_name.out)) then
						key.next.set_previous(key.previous)
					else
						last := key.previous
						key.previous.set_next (Void)
					end
					key.set_next(Void)
					key.set_previous (Void)
				end

			-- avl-remove
			recursive_remove (key, root, Void)
		end

feature {NONE} -- Implementation

	must_rotate (node: like root): BOOLEAN is
			-- Must subtree rooted at `node' be rotated?
		do
			Result := node.balance.abs > 1
		end

	rotate (node: like root; parent: like root) is
			-- Rotate subtree rooted at `node'.
		require
			no_parent_of_root: (parent = Void) = (node = root)
			node_is_child: parent /= Void implies (node = parent.left or node = parent.right)
			must_rotate: must_rotate (node)
		local
			temp: like root
		do
			if node.balance = 2 then
				if node.right.balance = -1 then
					temp := node.right.left
					raise_left (node.right)
					node.set_right (temp)
					raise_right (node)
					-- set balances for double rotation
					adjust_balance (temp)
				else
					temp := node.right
					raise_right (node)
					-- set balances for single rotation
					temp.set_balance (temp.balance - 1)
					temp.left.set_balance (-temp.balance)
				end
			else	-- node.balance = -2
				if node.left.balance = 1 then
					temp := node.left.right
					raise_right (node.left)
					node.set_left (temp)
					raise_left (node)
					-- set balances for double rotation
					adjust_balance (temp)
				else
					temp := node.left
					raise_left (node)
					-- set balances for single rotation
					temp.set_balance (temp.balance + 1)
					temp.right.set_balance (-temp.balance)
				end
			end
			append (temp, parent, node, true)
		end

	adjust_balance (node: like root) is
			-- Adjust balances of `node' and its direct children after double rotation
		require
			node_exists: node /= Void
		do
			if node.balance = 1 then
				node.left.set_balance (-1)
			else
				node.left.set_balance (0)
			end
			if node.balance = -1 then
				node.right.set_balance (1)
			else
				node.right.set_balance (0)
			end
			node.set_balance (0)
		ensure
			node_balanced: node.balance = 0
		end

	raise_left (node: like root) is
			-- Make `node.left' the parent of `node'.
		local
			left: like root
		do
			-- rearrange links
			left := node.left
			node.set_left (left.right)
			left.set_right (node)
		end

	raise_right (node: like root) is
			-- Make `node.right' the parent of `node'.
		local
			right: like root
		do
			-- rearrange links
			right := node.right
			node.set_right (right.left)
			right.set_left (node)
		end

	recursive_force (key: like root; node: like root; parent: like root) is
			-- Recursively add entry to subtree rooted at `node'.
		require
			key_exists: key /= Void
		local
			new: like root
			old_balance: INTEGER
		do
			if node = Void then
				if parent = Void then	-- node = root
					create root.make (key.item)

					first := root
					last := root
				else
					create new.make (key.item)
					append (new, parent, key, false)
					increase_height (parent, key, 1)
				end
			elseif key.is_equal (node) then
				node.set_item (key.item)
			else
				old_balance := node.balance
				if key < node then
					recursive_force (key, node.left, node)
				else
					recursive_force (key, node.right, node)
				end
				if must_rotate (node) then
					rotate (node, parent)
				elseif parent /= Void then
					if old_balance = 0 and node.balance.abs = 1 then
						-- 1 for key > node.key, -1 for key < node.key
						increase_height (parent, key, 1)
					end
				end
			end
		end

	recursive_remove (key: like root; node: like root; parent: like root) is
			-- Remove entry `key'.
		require
			key_exists: key /= Void
			--node_exists: node /= Void
		local
			replacement: like root
			old_balance: INTEGER
		do
			if node /= Void then
				old_balance := node.balance
				replacement := node

				-- recursively remove `key'
				if key < node then
					recursive_remove (key, node.left, node)
				elseif key > node then
					recursive_remove (key, node.right, node)
				else
					-- find replacement
					if node.left = Void then
						replacement := node.right
					elseif node.right = Void then
						replacement := node.left
					else
						replacement := rightmost (node.left)
						recursive_remove (replacement, node.left, node)
					end

					-- replace `node' with `replacement'
					if replacement /= Void then
						if replacement /= node.left then
							replacement.set_left (node.left)
						else
							node.set_balance (node.balance + 1)
						end
						if replacement /= node.right then
							replacement.set_right (node.right)
						else
							node.set_balance (node.balance - 1)
						end
						replacement.set_balance (node.balance)
						node.set_left (Void)
						node.set_right (Void)
						node.set_balance (0)
					end
						-- add replacement
						append (replacement, parent, key, true)
				end

				if replacement = Void then
					-- parent height decreased
					if parent /= Void then
						increase_height (parent, key, -1)
					end
				else
					-- rotate if necessary
					if must_rotate (replacement) then
						rotate (replacement, parent)
					end

					-- adjust `parent.balance'
					if parent /= Void then
						-- update `replacement' in case of earlier rotation
						if key < parent then
							replacement := parent.left
						else
							replacement := parent.right
						end
						if old_balance /= 0 and replacement.balance = 0 then
							increase_height (parent, key, -1)
						end
					end
				end
			end
		end

	rightmost (node: like root): like root is
			-- Largest entry in subtree `node'.
		do
			if node.right = Void then
				Result := node
			else
				Result := rightmost (node.right)
			end
		end

	append (node: like root; parent: like root; key: like root; dont_change_links: BOOLEAN) is
			-- Append `node' to `parent' or set `root' to `node'.
			-- `key' indicates which subtree of `parent' to replace.
		require
			key_exists: key /= Void
		do
			if parent = Void then
				root := node
			else
				if key < parent then
					-- avl insert
					parent.set_left (node)

					-- linked-list pointers
					if (not dont_change_links) and (node /= Void) then
						node.set_next (parent)
						node.set_previous(parent.previous)

						if(parent.previous /= Void) then
							parent.previous.set_next(node)
						else
							first := node
						end
						parent.set_previous(node)
					end
				else
					-- avl insert
					parent.set_right (node)

					-- linked-list pointers
					if not dont_change_links and (node /= Void) then
						node.set_previous (parent)
						node.set_next(parent.next)

						if (parent.next /= Void) then
							parent.next.set_previous (node)
						else
							last := node
						end
						parent.set_next(node)
					end
				end
			end
		ensure
			root: (parent = Void) implies (root = node)
			left_child: (parent /= Void and then key < parent) implies (parent.left = node)
			right_child: (parent /= Void and then key > parent) implies (parent.right = node)
		end

	increase_height (node: like root; key: like root; delta: INTEGER) is
			-- Increase height of subtree of `node' containing `key' by `delta'.
		require
			node_exists: node /= Void
		do
			if key < node then
				node.set_balance (node.balance - delta)
			else
				node.set_balance (node.balance + delta)
			end
		end

	recursive_first_item_after_line(a_line: INTEGER; a_node:like root): like root is
			-- recursive call for "first_item_after_line"
		local
			node_line: INTEGER
		do
			node_line := a_node.start_line
			if node_line = a_line then
				result := a_node
			elseif node_line > a_line then
				if a_node.left /= Void then
					result := recursive_first_item_after_line (a_line, a_node.left)
				else
					result := a_node
				end
			else
				-- node_line < a_line
				if a_node.right /= Void then
					result := recursive_first_item_after_line (a_line, a_node.right)
				else
					result := a_node.next
				end
			end
		end


feature {EB_SMART_EDITOR, EB_CLICKABLE_MARGIN} -- Debugging

	recursive_dump (node: like root; prefix_string: STRING; is_left_child: BOOLEAN) is
			-- Dump subtree rooted at `node' with indentation `indent'.
		do
			if node /= Void then
				if is_left_child then
					recursive_dump (node.right, prefix_string + "    ", True)
				else
					recursive_dump (node.right, prefix_string + "|   ", True)
				end

				io.put_string (prefix_string)
				if is_left_child then
					io.put_string ("/- ")
				else
					io.put_string ("\- ")
				end
				io.put_string (node.out)
				io.put_new_line

				if is_left_child then
					recursive_dump (node.left, prefix_string + "|   ", False)
				else
					recursive_dump (node.left, prefix_string + "    ", False)
				end
			end
		end

	dump is
			-- Write complete tree to console, 'inorder'
		do
			if root = Void then
				io.put_string ("no tree")
				io.put_new_line
			else
				recursive_dump (root.right, " ", True)
				io.put_string (root.out)
				io.put_new_line
				recursive_dump (root.left, " ", False)
			end
		end

	is_valid: BOOLEAN is
			-- Is `Current' a valid AVL tree?
		do
			validity := True
			if root /= Void and then root.balance /= height (root.right) - height (root.left) then
				validity := False
			end
			Result := validity
		end

	height (node: like root): INTEGER is
			-- Height of subtree rooted at `node'.
		local
			left, right: INTEGER
		do
			if node = Void then
				Result := 0
			else
				left := height (node.left)
				right := height (node.right)
				if node.balance /= right - left or node.balance.abs > 1 then
					validity := False
				end
				Result := left.max (right) + 1
			end
		end

	validity: BOOLEAN
			-- validity of `Current'; only changed by calling `is_valid'.

	traverse_list_printout is
			-- prints all nodes by traversing the linked list
		local
			node: like root
			i: INTEGER
		do
			from
				node := first
				i := 0
				io.put_string("folding areas:%N%T")
			until
				node = Void or i > 20
			loop
				io.put_string("[" + node.start_line.out + "] ")

				--inc
				node := node.next
				i := i+1
			end
			if first /= Void then
				io.put_new_line
				io.put_string("%Tfirst:%T" + first.start_line.out + "%N%Tlast:%T" + last.start_line.out + "%N")
				io.put_string("%Theight: " + height(root).out + "%N")
			end
		end

invariant
	first_comes_first: (first.previous = Void) and (first.left = Void)
	last_is_last: (last.next = Void) and (last.right = Void)

end -- Class EV_FOLDING_AREA_TREE
