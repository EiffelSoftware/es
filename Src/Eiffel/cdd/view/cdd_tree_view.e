indexing
	description: "[
					Tree view of test suite; to be chained with filtered view. Grouping is 
					defined via test routine tags. Tag A is a child of tag B, iff tag A
					starts with the text of tag B followed by a dot ('.'). A test routine
					can contain any number of tags; the tree key defines which tag is used
					for building the tree structure. Only tags which start with the text of
					the tree key are considered.
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
            node: CDD_TREE_NODE
        do
			create nodes_cache.make_default
                -- TODO: Implement grouping of test routines into a node tree based on
                -- `key'.
			from
				cs := filtered_view.test_routines.new_cursor
				cs.start
			until
				cs.off
			loop
				create node.make_leaf (cs.item)
				nodes_cache.force_last (node)
				cs.forth
			end
			change_actions.call (Void)
        end

feature {NONE} -- Implementation

	nodes_cache: DS_ARRAYED_LIST [CDD_TREE_NODE]
			-- Cache for `nodes'

	internal_refresh_action: PROCEDURE [like Current, TUPLE]
			-- Agent subscribed in test suite. Needed for
			-- unsubscription.

	change_agent: PROCEDURE [ANY, TUPLE]

	wipe_out_nodes_cache is
			-- Remove all entries from nodes cache.
		do
			nodes_cache := Void
		ensure
			nodes_cache_void: nodes_cache = Void
		end

invariant

	filtered_view_not_void: filtered_view /= Void
	key_not_void: key /= Void

end
