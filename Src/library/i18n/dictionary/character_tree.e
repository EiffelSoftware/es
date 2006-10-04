class
	CHARACTER_TREE[G]
inherit
	ANY

create
	default_create,
	make

feature {CHARACTER_TREE} -- Init

	make (a_key: STRING_32; a_character_list: LINKED_LIST[CHARACTER_TREE[G]]) is
			--
		require
			a_key_not_exists: a_key /= Void
			a_character_list_exists: a_character_list /= Void
		do
			key := a_key
			character_trees_list := a_character_list
		end


feature -- Interface

	insert (a_item: G; a_key: STRING_32) is
			-- Insert an `a_item' with `a_key' as key in Current tree
		require
			item_and_key_exist: a_item /= Void and a_key /= Void
			not_yet_in_tree: not has (a_item, a_key)
		local
			tree_el: CHARACTER_TREE[G]
		do
			if not is_leaf then
					-- it is a node
				tree_el:= search_character_tree (a_key.substring (key.count+1, a_key.count))
				if tree_el = Void or  not  a_key.substring (1,key.count).is_equal (key) then
					-- element not in the node
					insert_character_tree (a_item, a_key)
				else -- similar element in the node, insert there
					tree_el.insert (a_item,a_key.substring (key.count+1, a_key.count))
				end
			elseif key = Void then
				-- it is a empty leaf
				key := a_key
				item := a_item
			else
				-- it is a 1 element leaf
				split (a_item, a_key)
			end
		end

	get (a_key: STRING_32): G is
			--
		require
			a_key_exists: a_key /= Void
			a_key_in_tree: has_key (a_key)
		local
			tree_el: CHARACTER_TREE[G]
		do
			if not is_leaf then
				tree_el := search_character_tree (a_key.substring (key.count +1, a_key.count))
				Result := tree_el.get (a_key.substring (key.count +1, a_key.count))
			else
				Result := item
			end
		end


	has (a_item: G; s: STRING_32): BOOLEAN is
			-- Does current tree have `a_item' with `a_key' as key?
		local
			tree_el: CHARACTER_TREE[G]
		do
			if not is_leaf then
				tree_el := search_character_tree (s.substring (key.count +1, s.count))
				Result := tree_el /= Void and then tree_el.has (a_item, s.substring (key.count +1, s.count))
			else
				Result := key /= Void and then (key.is_equal (s) and item.is_equal (a_item))
			end
		end

	has_key (s: STRING_32): BOOLEAN is
			--
		require
			a_key_exists: s /= Void
		local
			tree_el: CHARACTER_TREE[G]
		do
			if not is_leaf then
				tree_el := search_character_tree (s.substring (key.count +1, s.count))
				Result := tree_el /= Void and then tree_el.has_key (s.substring (key.count +1, s.count))
			else
				Result := key /= Void and then key.is_equal (s)
			end

		end


feature {CHARACTER_TREE} -- character_trees_list

	character_trees_list: LINKED_LIST[CHARACTER_TREE[G]]
			-- list of all subtrees

	search_character_tree (a_string: STRING_32): CHARACTER_TREE[G]
			-- search tree which represents a_character
			-- void if not available
		do
			-- User move to front method
				from
					character_trees_list.start
				until
					Result /= Void or character_trees_list.after
				loop
					if character_trees_list.item.key_corresponds(a_string) then
						Result := character_trees_list.item.twin
						character_trees_list.remove
						character_trees_list.put_front (Result)
 						character_trees_list.start
 						Result := character_trees_list.item
					else
						character_trees_list.forth
					end
				end
		end

	insert_character_tree (a_item: G; a_key: STRING_32) is
			-- Insert in `character_trees_list' a subtree with
			-- `a_item' es element and `a_key' as key
			-- If necessary, update `key' and all keys
			-- of the subtrees
		local
			l_tree, new_tree: CHARACTER_TREE[G]
			distance: INTEGER
			l_str: STRING_32
		do
			distance := minimum_distance (a_key)
			if distance < key.count  then
				l_str := key.substring (distance+1, key.count)
				create new_tree.make (l_str, character_trees_list)
				character_trees_list := Void
				create character_trees_list.make
				character_trees_list.extend (new_tree)
				key.keep_head (distance)
			end
			create l_tree
			l_tree.insert (a_item, a_key.substring (key.count+1, a_key.count))
			character_trees_list.put_front (l_tree)
		end

	split (a_item: G; a_string: STRING_32) is
		require
			is_leaf: is_leaf
		local
			distance: INTEGER
			l_key, r_key: STRING_32
			l_tree, r_tree: CHARACTER_TREE[G]
		do
			create character_trees_list.make
			distance := minimum_distance (a_string)
			l_key := key.substring (distance+1, key.count)
			create l_tree
			l_tree.insert (item, l_key)
			character_trees_list.put_front (l_tree)
			r_key := a_string.substring (distance+1, a_string.count)
			create r_tree
			r_tree.insert (a_item, r_key)
			character_trees_list.put_front (r_tree)
			key := key.substring (1, distance)
			item := Void
		end

feature {CHARACTER_TREE} -- Information

	is_leaf: BOOLEAN is
			-- is current element a leaf?
		do
			Result := character_trees_list = Void
		end
	key: STRING_32

	key_corresponds (a_key: STRING_32): BOOLEAN is
			-- does `a_key' correspond to a_string?
		do
			Result := minimum_distance (a_key) > 0
		end

	prepend_to_key (a_string: STRING_32) is
			-- prepend `a_string' to `key'
		do
			key:= a_string + key
		end



	item: G

feature {CHARACTER_TREE} -- Implementation

	minimum_distance (a_key: STRING_32): INTEGER is
			-- find distance between `a_string' and `key'
			-- Result is the amount of equal characters from the beginning
			-- of the two strings
		do
			from
				Result := 1
			until
				Result > a_key.count.min (key.count) or else
				a_key.item (Result) /= key.item (Result)
			loop
				Result := Result + 1
			end
			Result := Result - 1
		end

feature --Debug

	print_tree (t: INTEGER): STRING_32 is
			--
		local
			i : INTEGER
		do
			if is_leaf then
				Result := spaces (t)+"LEAF with item: "+item.out+" ("+key.out+")%N"
			else
				Result := spaces (t)+"NODE with key: "+key.out+"%N"
				from
					character_trees_list.start
					i := 1
				until
					character_trees_list.after
				loop
					Result.append (spaces (t+1)+i.out+"th child%N"+character_trees_list.item.print_tree (t+2))
					character_trees_list.forth
					i := i + 1
				end
			end
		end
feature {NONE} --Debug

	spaces (n: INTEGER): STRING_32 is
			--
		do
			create Result.make_filled (' ',n*2)
		end


invariant
 i2:	is_leaf implies character_trees_list = Void

end -- Class CHARACTER_TREE
