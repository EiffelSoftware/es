indexing
	description: "[
					Tree view of test suite; to be chained with filtered view.
				  ]"
	author: "aleitner"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TREE_VIEW

inherit

	CDD_ACTIVE_VIEW

create
	make

feature {NONE} -- Initialization

	make (a_filtered_view: like filtered_view) is
			-- Create a tree view using data from `a_filtered_view'.
		require
			a_filtered_view_not_void: a_filtered_view /= Void
		do
			create change_actions
			filtered_view := a_filtered_view
			change_agent := agent incremental_update
			create last_computed_tag_list.make_default
			create leafs.make_default
		ensure
			filtered_view_set: filtered_view = a_filtered_view
		end

feature {ANY} -- Status Report

	is_observing: BOOLEAN is
			-- Is this filter observing `test_suite'?
			-- If it is then changes to `test_suite' will be
			-- reflected by this filter immediately, otherwise
			-- `refresh' must be called.
		do
			Result := filtered_view.change_actions.has (change_agent)
		end

feature {ANY} -- Access

	filtered_view: CDD_FILTERED_VIEW
			-- Source where test routines are taken from

	nodes: DS_LINEAR [CDD_TREE_NODE] is
			-- Test routines from `test_suite' matching the criteria from
			-- `filters'.
		require
			observing: is_observing
		do
			if nodes_cache = Void then
				fill_nodes_cache
			end
			Result := nodes_cache
		ensure
			nodes_not_void: Result /= Void
			nodes_doesnt_have_void: not Result.has (Void)
		end

feature {ANY} -- Status setting

	enable_observing is
			-- Enable auto update mode.
		do
			filtered_view.change_actions.extend (change_agent)
			filtered_view.add_client
		end

	disable_observing is
			-- Disable auto update mode.
		do
			filtered_view.change_actions.prune (change_agent)
			filtered_view.remove_client
			wipe_out_nodes_cache
		end

feature -- Event handling

	change_actions: ACTION_SEQUENCE [TUPLE [DS_LINEAR [CDD_TREE_NODE_UPDATE]]]
			-- Actions to be executed whenever `nodes' has changed;
			-- E.g.: test routine added, removed, changed
			-- For efficiency reasons changes are grouped together in transactions.
			-- TODO: Add list of changes as arguments so observers can be more
			-- efficient in updating their state.

feature {NONE} -- View definition

	last_computed_tag_list: DS_ARRAYED_LIST [STRING]
			-- Last tag list computed by `compute_tag_list'

	compute_tag_list (a_routine: CDD_TEST_ROUTINE) is
			-- Compute list of tags correpsonding to Current view
			-- for `a_routine' and store them in `last_computed_tag_list'.
			-- NOTE: for now we only have one view, which is of the form
			-- "TEST_CLASS_NAME.test_routine_name"
		local
			l_tag: STRING
			l_cursor: DS_LINEAR_CURSOR [STRING]
		do
			last_computed_tag_list.wipe_out

				-- Tag view
			from
				l_cursor := a_routine.tags.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if not (l_cursor.item.has_substring ("outcome.") or l_cursor.item.has_substring ("name.")
					or l_cursor.item.has_substring ("covers.")) then
					last_computed_tag_list.force_last ("Tag View." + l_cursor.item + "." + a_routine.name)
				end
				l_cursor.forth
			end

				-- Name view
			create l_tag.make (30)
			l_tag.append ("Name View.")
			l_tag.append (a_routine.test_class.test_class_name)
			l_tag.append_character ('.')
			l_tag.append (a_routine.name)
			last_computed_tag_list.force_last (l_tag)

				-- Outcome view
			if not a_routine.outcomes.is_empty then
				create l_tag.make (30)
				l_tag.append ("Outcome View.")
				l_tag.append (a_routine.outcomes.last.text)
				l_tag.append_character ('.')
				l_tag.append (a_routine.name)
				last_computed_tag_list.force_last (l_tag)
			end

			l_cursor := a_routine.tags_with_prefix ("covers.").new_cursor
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				if l_cursor.item.count > 7 then
					l_tag := "Covers View" + l_cursor.item.substring (7, l_cursor.item.count) + "." + a_routine.name
					last_computed_tag_list.force_last (l_tag)
				end
				l_cursor.forth
			end

		end

feature {NONE} -- Implementation (Access)

	nodes_cache: DS_LINKED_LIST [CDD_TREE_NODE]
			-- Cache for `nodes'

	change_agent: PROCEDURE [ANY, TUPLE [DS_LINEAR [CDD_TEST_ROUTINE_UPDATE]]]
			-- Agent called whenever `filtered_view' changes

	leafs: DS_HASH_TABLE [DS_HASH_TABLE [CDD_TREE_NODE, STRING], CDD_TEST_ROUTINE]
			-- leafs in `nodes_cache' for each test routine
			-- and corresponding tags

	last_node: CDD_TREE_NODE
			-- Last node processed by tree update

	last_updates: DS_ARRAYED_LIST [CDD_TREE_NODE_UPDATE]
			-- Updates since last call to `incemental_update'

	project: E_PROJECT is
			-- Current project
		do
			Result := filtered_view.test_suite.cdd_manager.project
		ensure
			not_void: Result /= Void
		end

feature {NONE} -- Tree update

	refresh is
			-- Wipe out cache and call observers.
		require
			observing: is_observing
		do
			wipe_out_nodes_cache
			change_actions.call ([Void])
		end

	incremental_update (an_update_list: DS_LINEAR [CDD_TEST_ROUTINE_UPDATE]) is
		require
			an_update_list_valid: an_update_list = Void or else not an_update_list.has (Void)
		local
			l_cursor: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE_UPDATE]
		do
			-- TODO: implement incremental update
			if an_update_list /= Void and then nodes_cache /= Void then
				create last_updates.make_default
				l_cursor := an_update_list.new_cursor
				from
					l_cursor.start
				until
					l_cursor.after
				loop
					if l_cursor.item.is_added then
						insert_routine (l_cursor.item.test_routine)
					elseif l_cursor.item.is_removed then
						remove_routine (l_cursor.item.test_routine)
					elseif l_cursor.item.is_changed then
						change_routine (l_cursor.item.test_routine)
					else
						check
							dead_end: False
						end
					end
					l_cursor.forth
				end
				change_actions.call ([last_updates])
				last_updates := Void
			else
				refresh
			end
		end

	fill_nodes_cache is
			-- Update `nodes_cache' with information from `test_suite'.
		require
			observing: is_observing
			cache_void: nodes_cache = Void
		local
			cs: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE]
		do
			create nodes_cache.make
			from
				cs := filtered_view.test_routines.new_cursor
				cs.start
			until
				cs.off
			loop
				insert_routine (cs.item)
				cs.forth
			end
		end

	wipe_out_nodes_cache is
			-- Remove all entries from nodes cache.
		do
			nodes_cache := Void
			leafs.wipe_out
		ensure
			nodes_cache_void: nodes_cache = Void
		end

feature {NONE} -- Tree modification

	insert_routine (a_routine: CDD_TEST_ROUTINE) is
			-- Insert routine `a_routine' into the tree and
			-- set `last_node' to new created node.
		require
			nodes_cache_not_void: nodes_cache /= Void
			a_routine_not_void: a_routine /= Void
			not_inserted: not leafs.has (a_routine)
		local
			l_ht: DS_HASH_TABLE [CDD_TREE_NODE, STRING]
			l_cursor: DS_LINEAR_CURSOR [STRING]
		do
				-- NOTE: Usually we will only have one tag pre routine
			create l_ht.make (1)
			leafs.force (l_ht, a_routine)
			compute_tag_list (a_routine)
			l_cursor := last_computed_tag_list.new_cursor
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				insert_leaf (a_routine, l_cursor.item)
				leafs.item (a_routine).force (last_node, l_cursor.item)
				l_cursor.forth
			end
		ensure
			inserted: leafs.has (a_routine)
		end

	remove_routine (a_routine: CDD_TEST_ROUTINE) is
			-- Remove `a_routine' from tree.
		require
			nodes_cache_not_void: nodes_cache /= Void
			a_routine_not_void: a_routine /= Void
			inserted: leafs.has (a_routine)
		local
			l_cursor: DS_HASH_TABLE_CURSOR [CDD_TREE_NODE, STRING]
		do
			l_cursor := leafs.item (a_routine).new_cursor
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				remove_leaf (l_cursor.item)
				leafs.item (a_routine).remove (l_cursor.key)
			end
			leafs.remove (a_routine)
		ensure
			removed: not leafs.has (a_routine)
		end

	change_routine (a_routine: CDD_TEST_ROUTINE) is
			-- Change routine `a_routine' in tree.
			-- This usualy only consists of finding the appropriate
			-- leaf in the tree and creating a change update for it.
		require
			nodes_cache_not_void: nodes_cache /= Void
			a_routine_not_void: a_routine /= Void
			inserted: leafs.has (a_routine)
		local
			l_new, l_old: DS_HASH_TABLE [CDD_TREE_NODE, STRING]
			l_cursor: DS_LINEAR_CURSOR [STRING]
		do
				-- NOTE: Usually we will only have one tag pre routine
			create l_new.make (1)
			l_old := leafs.item (a_routine)
			leafs.force (l_new, a_routine)
			compute_tag_list (a_routine)
			l_cursor := last_computed_tag_list.new_cursor
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				l_old.search (l_cursor.item)
				if l_old.found then
					l_new.force (l_old.found_item, l_cursor.item)
					refresh_leaf (l_old.found_item)
					l_old.remove_found_item
				else
					insert_leaf (a_routine, l_cursor.item)
					l_new.force (last_node, l_cursor.item)
				end
				l_cursor.forth
			end

			from
				l_old.start
			until
				l_old.after
			loop
				remove_leaf (l_old.item_for_iteration)
				l_old.forth
			end
		end

	insert_leaf (a_routine: CDD_TEST_ROUTINE; a_tag: STRING) is
			-- Insert a new path into `nodes_cache' for `a_routine'
			-- displaying `a_tag'. Set `last_node' to new created leaf.
		require
			nodes_cache_not_void: nodes_cache /= Void
			a_routine_not_void: a_routine /= Void
			a_tag_not_empty: a_tag /= Void and then not a_tag.is_empty
		local
			l_node, l_next, l_first_created: CDD_TREE_NODE
			l_tokens: LIST [STRING]
			l_token: STRING
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TREE_NODE]
			l_path: DS_ARRAYED_LIST [INTEGER]
			l_update: CDD_TREE_NODE_UPDATE
		do
			l_tokens := a_tag.split ('.')
			create l_path.make (2)
			from
				l_tokens.start
				l_cursor := nodes_cache.new_cursor
			until
				l_tokens.after
			loop
				l_token := l_tokens.item
				find_position (l_cursor, l_token)
					-- We have to create a new node if:
					--	* The cursor is after or there is no existing
					--	  node with the same token (case insensitive)
					--	* We are looking at the last token: in this case
					--	  we will add a new leaf after the existing node
					--	* There is an existing node with same token which
					--	  is a leaf: then we will add a new node before the
					--    existing leaf
				if l_cursor.after or else not l_cursor.item.tag.is_case_insensitive_equal (l_token) or else
				   l_tokens.index = l_tokens.count or else l_cursor.item.is_leaf then
						-- NOTE: For now we know just check if `l_token' is a class name.
						-- In future, this piece of code will have to be replaced
						-- with something more sofisticated to be more efficient
						-- and support different clickable tokens.
					if l_tokens.index = l_tokens.count then
						create l_next.make_leaf (a_routine, l_token)
						if l_cursor.after or else not l_cursor.item.tag.is_case_insensitive_equal (l_token) then
							l_cursor.put_left (l_next)
							l_cursor.back
						else
							l_cursor.put_right (l_next)
							l_cursor.forth
						end
						last_node := l_next
					else
						create_node (l_token, l_node)
						l_next := last_node
						l_cursor.put_left (l_next)
						l_cursor.back
					end
					l_next.set_parent (l_node)
					if l_first_created = Void then
						l_first_created := l_next
					end
				else
					l_next := l_cursor.item
				end
					-- Add path indexes until we are in the new subtree
				if l_first_created = Void or l_first_created = l_next then
					l_path.force_last (l_cursor.index)
				end
				l_cursor.go_after
				l_tokens.forth
				if not l_next.is_leaf then
					l_node := l_next
					l_cursor := l_node.internal_children.new_cursor
				end
			end

				-- Create update object if necessary
			if last_updates /= Void then
				create l_update.make_added (l_first_created)
				l_update.path.extend_first (l_path)
				last_updates.force_last (l_update)
			end

		ensure
			last_node_valid: last_node /= Void and then last_node.is_leaf and then
				last_node.test_routine = a_routine
		end

	remove_leaf (a_leaf: CDD_TREE_NODE) is
			-- Remove leaf for `a_routine' and `a_tag' and all
			-- parents remaining without any children.
		require
			nodes_cache_not_void: nodes_cache /= Void
			a_leaf_valid: a_leaf /= Void and then a_leaf.is_leaf
		local
			l_node: CDD_TREE_NODE
			l_remove: CDD_TREE_NODE
			l_path: DS_LINKED_LIST [INTEGER]
			l_update: CDD_TREE_NODE_UPDATE
		do
			create l_path.make

				-- Traverse path from `a_leaf' to its root. Store tag
				-- represented by path in `l_tag' and find correct
				-- node to remove along the path so there are no non-leaf
				-- nodes remaining without any children
			from
				l_node := a_leaf
			until
				l_node = Void
			loop
				if l_node = a_leaf then
					l_remove := l_node
				else
					if l_node = l_remove.parent and l_node.children.count = 1 then
						l_remove := l_node
						l_path.remove_first
					end
				end
				l_path.put_first (index_of_node (l_node))
				l_node := l_node.parent
			end

				-- Remove node from tree and leaf from `leafs'
			remove_node (l_remove)

				-- Create update object if necessary
			if last_updates /= Void then
				create l_update.make_removed (l_remove)
				l_update.path.extend_first (l_path)
				last_updates.force_last (l_update)
			end
		end

	refresh_leaf (a_leaf: CDD_TREE_NODE) is
			-- Refresh `a_leaf' and all parents.
			-- Create status update if necessary.
		require
			nodes_cache_not_void: nodes_cache /= Void
			a_leaf_valid: a_leaf /= Void and then a_leaf.is_leaf
		local
			l_node: CDD_TREE_NODE
			l_path: DS_LINKED_LIST [INTEGER]
			l_update: CDD_TREE_NODE_UPDATE
		do
			create l_path.make
			from
				l_node := a_leaf
			until
				l_node = Void
			loop
				l_path.put_first (index_of_node (l_node))
				l_node := l_node.parent
			end
			if last_updates /= Void then
				create l_update.make_changed (a_leaf)
				l_update.path.extend_first (l_path)
				last_updates.force_last (l_update)
			end
		end

feature {NONE} -- Helpers

	create_node (a_tag: STRING; a_parent: CDD_TREE_NODE) is
			--
		require
			a_tag_not_void: a_tag /= Void
		local
			l_universe: UNIVERSE_I
			l_class_list: LIST [CLASS_I]
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			l_universe := project.system.system.universe
			l_class_list := l_universe.classes_with_name (a_tag)
			if not l_class_list.is_empty then
				create last_node.make_with_class (l_class_list.first, a_tag)
			else
				if a_parent /= Void and then a_parent.has_test_class then
					l_class := a_parent.eiffel_class.compiled_class
					if l_class /= Void then
						l_feature := l_class.feature_named (a_tag)
					end
				end
				if l_feature /= Void then
					create last_node.make_with_feature (l_feature, a_tag)
				else
					create last_node.make (a_tag)
				end
			end
		end

	remove_node (a_node: CDD_TREE_NODE) is
			-- Remove `a_node' from tree.
		require
			a_node_not_void: a_node /= Void
			nodes_cache_not_void: nodes_cache /= Void
			valid_node: (a_node.parent /= Void and then a_node.parent.internal_children.has (a_node)) or
				(a_node.parent = Void and then nodes_cache.has (a_node))
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TREE_NODE]
		do
			if a_node.parent = Void then
				l_cursor := nodes_cache.new_cursor
			else
				l_cursor := a_node.parent.internal_children.new_cursor
				a_node.set_parent (Void)
			end
			l_cursor.start
			l_cursor.search_forth (a_node)
			check
				found: not l_cursor.off
			end
			l_cursor.remove
			l_cursor.go_after
		ensure
			removed: (a_node.parent /= Void and then not a_node.parent.internal_children.has (a_node)) or
				(a_node.parent = Void and then not nodes_cache.has (a_node))
		end

	index_of_node (a_node: CDD_TREE_NODE): INTEGER is
			-- If `a_node' is parented, return index of `a_node'
			-- in parents children list. If `a_node' is not parented,
			-- return index of `a_node' in `nodes'.
		require
			nodes_cache_not_void: nodes_cache /= Void
			a_node_not_void: a_node /= Void
			valid_node: (a_node.parent /= Void and then a_node.parent.internal_children.has (a_node)) or
				(a_node.parent = Void and then nodes.has (a_node))
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TREE_NODE]
		do
			if a_node.parent /= Void then
				l_cursor := a_node.parent.internal_children.new_cursor
			else
				l_cursor := nodes_cache.new_cursor
			end
			from
				l_cursor.start
			until
				l_cursor.item = a_node
			loop
				l_cursor.forth
			end
			Result := l_cursor.index
		end

	find_position (a_cursor: DS_LINKED_LIST_CURSOR [CDD_TREE_NODE]; a_token: STRING) is
			-- Find position for new node with `a_token' in list
			-- traversed through `l_cursor' so list remains sorted.
		require
			a_cursor_not_void: a_cursor /= Void
			list_valid: not a_cursor.container.has (Void)
			a_token_not_void: a_token /= Void
		do
			from
				a_cursor.start
			until
				a_cursor.after or else not (a_cursor.item.tag < a_token)
			loop
				a_cursor.forth
			end
		ensure
			valid_position: a_cursor.after or else not (a_cursor.item.tag < a_token)
		end

invariant

	change_actions_not_void: change_actions /= Void
	filtered_view_not_void: filtered_view /= Void
	change_agent_not_void: change_agent /= Void
	last_computed_tag_list_not_void: last_computed_tag_list /= Void
	last_computed_tag_list_valid: not last_computed_tag_list.has (Void)
	leafs_not_void: leafs /= Void
	nodes_cache_void_implies_leafs_empty: (nodes_cache = Void) implies leafs.is_empty

end
