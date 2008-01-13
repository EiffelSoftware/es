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

	change_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be executed whenever `nodes' has changed;
			-- E.g.: test routine added, removed, changed
			-- For efficiency reasons changes are grouped together in transactions.
			-- TODO: Add list of changes as arguments so observers can be more
			-- efficient in updating their state.

feature {NONE} -- Element change

	incremental_update (an_update_list: DS_LINEAR [CDD_TEST_ROUTINE_UPDATE]) is
		require
			an_update_list_valid: an_update_list = Void or else not an_update_list.has (Void)
		do
			-- TODO: implement incremental update
			refresh
		end

	refresh is
			-- Wipe out cache and call observers.
		require
			observing: is_observing
		do
			wipe_out_nodes_cache
			change_actions.call ([Void])
		end

	fill_nodes_cache is
			-- Update `nodes_cache' with information from `test_suite'.
		require
			observing: is_observing
			cache_void: nodes_cache = Void
        local
            cs: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE]
        do
        	wipe_out_nodes_cache
			create nodes_cache.make_default
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

feature {NONE} -- Implementation

	nodes_cache: DS_ARRAYED_LIST [CDD_TREE_NODE]
			-- Cache for `nodes'

	internal_refresh_action: PROCEDURE [ANY, TUPLE]
			-- Agent subscribed in test suite. Needed for
			-- unsubscription.

	change_agent: PROCEDURE [ANY, TUPLE [DS_LINEAR [CDD_TEST_ROUTINE_UPDATE]]]

	wipe_out_nodes_cache is
			-- Remove all entries from nodes cache.
		do
			nodes_cache := Void
		ensure
			nodes_cache_void: nodes_cache = Void
		end

	insert_routine (a_routine: CDD_TEST_ROUTINE) is
			-- Insert routine `a_routine' into the tree.
		require
			a_routine_not_void: a_routine /= Void
		local
			node: CDD_TREE_NODE
		do
			create_path (a_routine.test_class.test_class_name, nodes_cache)
			create node.make_leaf (a_routine, a_routine.name)
			last_node.children.force_last (node)
		end

	create_node_with_tag (a_list: DS_LIST [CDD_TREE_NODE]; a_tag: STRING) is
			-- Create node in `a_list' with tag `a_tag' and make it available via
			-- `last_node'. If `a_list' already contains a node with `a_tag', do
			-- not create a new node but make the existing node available
			-- via `last_node' instead.
		require
			a_list_not_void: a_list /= Void
			a_tag_not_void: a_tag /= Void
		local
			cs: DS_LINEAR_CURSOR [CDD_TREE_NODE]
		do
			from
				cs := a_list.new_cursor
				cs.start
				last_node := Void
			until
				cs.off or last_node /= Void
			loop
				if cs.item.tag.is_equal (a_tag) then
					last_node := cs.item
				end
				cs.forth
			end
			cs.go_after
			if last_node = Void then
				create last_node.make (a_tag)
				a_list.force_last (last_node)
			end
		end

	create_path (a_path: STRING; a_list: DS_LIST [CDD_TREE_NODE]) is
			-- Create path `a_path' starting from list `a_list'. Make
			-- last node of path available via `last_node'. If the whole
			-- or a part of the path already exists, reuse existing part.
		require
			a_path_not_void: a_path /= Void
			a_path_not_empty: not a_path.is_empty
			a_list_not_void: a_list /= Void
			a_list_doesnt_have_void: not a_list.has (Void)
		local
			tokens: LIST [STRING]
			parent: DS_LIST [CDD_TREE_NODE]
		do
			tokens := a_path.split ('.')
			from
				parent := a_list
				tokens.start
			until
				tokens.off
			loop
				create_node_with_tag (parent, tokens.item)
				parent := last_node.children
				tokens.forth
			end
		ensure
			last_node_not_void: last_node /= Void
		end

	last_node: CDD_TREE_NODE
			-- Last node created using `create_path' or
			-- `create_node_with_tag'

invariant

	change_actions_not_void: change_actions /= Void
	filtered_view_not_void: filtered_view /= Void
	change_agent_not_void: change_agent /= Void

end
