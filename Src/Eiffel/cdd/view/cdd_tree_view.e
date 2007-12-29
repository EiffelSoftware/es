indexing
	description: "[
					Tree view of test suite; to be chained with filtered view. Grouping is 
					defined via test routine tags. Tag A is a child of tag B, iff tag A
					starts with the text of tag B followed by a dot ('.'). A test routine
					can contain any number of tags; the tree key defines which tag is used
					for building the tree structure. Only tags which start with the text of
					the tree key are considered. Grouping is documented at
					http://dev.eiffel.com/CddTreeViewSpec .
				  ]"
	author: "aleitner"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TREE_VIEW

create
	make

feature {NONE} -- Initialization

	make (a_filtered_view: like filtered_view) is
			-- Create a tree view using data from `a_filtered_view'.
		require
			a_filtered_view_not_void: a_filtered_view /= Void
		do
			filtered_view := a_filtered_view
			change_agent := agent refresh
			create key.make (0)
			create change_actions
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

	key: STRING
			-- Tree key

	filtered_view: CDD_FILTERED_VIEW
			-- Source where test routines are taken from

	nodes: DS_LINEAR [CDD_TREE_NODE] is
			-- Test routines from `test_suite' matching the criteria from
			-- `filters'.
		do
			if nodes_cache = Void then
				refresh
			end
			Result := nodes_cache
		ensure
			nodes_not_void: Result /= Void
			nodes_doesnt_have_void: not Result.has (Void)
		end

feature {ANY} -- Status setting

	enable_observing is
			-- Enable auto update mode.
		require
			not_observing: not is_observing
		do
			filtered_view.change_actions.force (change_agent)
		ensure
			observing: is_observing
		end

	disable_observing is
			-- Disable auto update mode.
		require
			observing: is_observing
		do
			filtered_view.change_actions.prune (change_agent)
		ensure
			not_observing: not is_observing
		end

feature -- Event handling

	change_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be executed whenever `nodes' has changed;
			-- E.g.: test routine added, removed, changed
			-- For efficiency reasons changes are grouped together in transactions.
			-- TODO: Add list of changes as arguments so observers can be more
			-- efficient in updating their state.

feature {ANY} -- Element change

	set_key (a_key: like key) is
			-- Set `key' to `a_key'.
		require
			a_key_not_void: a_key /= Void
		do
			key := a_key
		ensure
			key_set: key = a_key
		end

	refresh is
			-- Update `nodes_cache' with information from `test_suite'.
        local
            cs: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE]
        do
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
			change_actions.call (Void)
        end

feature {NONE} -- Implementation

	nodes_cache: DS_ARRAYED_LIST [CDD_TREE_NODE]
			-- Cache for `nodes'

	internal_refresh_action: PROCEDURE [ANY, TUPLE]
			-- Agent subscribed in test suite. Needed for
			-- unsubscription.

	change_agent: PROCEDURE [ANY, TUPLE]

	wipe_out_nodes_cache is
			-- Remove all entries from nodes cache.
		do
			nodes_cache := Void
			others_node := Void
		ensure
			nodes_cache_void: nodes_cache = Void
			ohters_node_void: others_node = Void
		end

	insert_routine (a_routine: CDD_TEST_ROUTINE) is
			-- Insert routine `a_routine' into the tree. Place it according
			-- to `key'.
		require
			a_routine_not_void: a_routine /= Void
		local
            tags: DS_LINEAR [STRING]
            cs: DS_LINEAR_CURSOR [STRING]
		do
			from
				tags := a_routine.tags_with_prefix (key)
				cs := tags.new_cursor
				cs.start
			until
				cs.off
			loop
				insert_routine_with_tag (a_routine, cs.item)
				cs.forth
			end
		end

	insert_routine_with_tag (a_routine: CDD_TEST_ROUTINE; a_tag: STRING) is
			-- Insert routine `a_routine' into the tree using `a_tag' as path.
		require
			a_routine_not_void: a_routine /= Void
		local
			tokens: LIST [STRING]
            grand_parent: DS_LIST [CDD_TREE_NODE]
			parent: DS_LIST [CDD_TREE_NODE]
			node: CDD_TREE_NODE
            cs: DS_LINEAR_CURSOR [STRING]
            tag: STRING
		do
			tokens := a_tag.split ('.')
			if tokens /= Void then
				from
					parent := nodes_cache
					tokens.start
				until
					tokens.islast
				loop
					grand_parent := parent
					node := node_with_tag (grand_parent, tokens.item)
					if node = Void then
						create node.make (tokens.item)
						parent := node.children
						grand_parent.force_last (node)
					else
						parent := node.children
					end
					tokens.forth
				end
				tag := tokens.item
			else
				if others_node = Void then
					insert_others_node
					parent := others_node.children
					tag := a_routine.test_class.test_class_name + "." + a_routine.name
				end
			end
			create node.make_leaf (a_routine, tag)
			parent.force_last (node)
		end

	insert_others_node is
			-- Insert "others" node into tree and make it available via
			-- `others_node'.
		require
			others_node_void: others_node = Void
		do
			create others_node.make ("others")
			nodes_cache.force_last (others_node)
		ensure
			others_node_not_void: others_node /= Void
		end

	node_with_tag (a_list: DS_LINEAR [CDD_TREE_NODE]; a_tag: STRING): CDD_TREE_NODE is
			-- Node in `a_list' with tag `a_tag' or Void if
			-- no such node
		require
			a_list_not_void: a_list /= Void
			a_tag_not_void: a_tag /= Void
		local
			cs: DS_LINEAR_CURSOR [CDD_TREE_NODE]
		do
			from
				cs := a_list.new_cursor
				cs.start
			until
				cs.off or Result /= Void
			loop
				if cs.item.tag.is_equal (a_tag) then
					Result := cs.item
				end
				cs.forth
			end
			cs.go_after
		end

	others_node: CDD_TREE_NODE
			-- Node that is parent to all nodes that don't match `key' at all

invariant

	filtered_view_not_void: filtered_view /= Void
	key_not_void: key /= Void

end
