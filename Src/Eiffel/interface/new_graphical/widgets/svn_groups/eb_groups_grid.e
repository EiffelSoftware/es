note
	description: "Tree enabled grid that represents the clusters, overrides, libraries and targets of a project"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_GROUPS_GRID

inherit
	ES_GRID

	EB_EDITOR_TOKEN_GRID_SUPPORT
		undefine
			default_create, is_equal, copy
		end

	EB_CLUSTER_MANAGER_OBSERVER
		undefine
			default_create, is_equal, copy
		redefine
			on_class_added, on_class_removed, on_class_moved,
			on_cluster_added, on_cluster_removed, on_cluster_changed, on_cluster_moved,
			on_project_loaded, on_project_unloaded,
			refresh
		end

	EV_KEY_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, is_equal, copy
		end

	EB_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, is_equal, copy
		end

	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		undefine
			default_create, is_equal, copy
		end

	EB_RECYCLABLE
		undefine
			default_create, is_equal, copy
		end

	EB_SHARED_WINDOW_MANAGER
		export
			{NONE} all
		undefine
			default_create, is_equal, copy
		end

	SHARED_WORKBENCH
		undefine
			default_create, is_equal, copy
		end

	ES_SHARED_PROMPT_PROVIDER
		export
			{NONE} all
		undefine
			default_create,
			copy,
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_context_menu_factory: EB_CONTEXT_MENU_FACTORY)
			-- Initialize the tree of clusters.
		do
			default_create
			context_menu_factory := a_context_menu_factory
			prepare
			manager.extend (Current)
--| FIXME XR: When clusters can be moved for real, uncomment this line.
--			drop_actions.extend (~on_cluster_drop)
			create classes_double_click_agents.make
			create cluster_double_click_agents.make
			create classes_single_click_agents.make
			create cluster_single_click_agents.make
			create svn_client.make
			has_targets := True
			is_show_classes := True

			set_item_pebble_function (agent on_pebble_function)
			set_item_accept_cursor_function (agent on_item_accept_cursor_function)
			set_item_deny_cursor_function (agent on_item_deny_cursor_function)

			make_with_grid (Current)
			enable_grid_item_pnd_support

			set_configurable_target_menu_mode
			set_configurable_target_menu_handler (agent on_menu_handler (?, ?, ?, ?))

			row_expand_actions.extend (agent retrieve_status_for_row)
		end

	make_without_targets (a_context_menu_factory: EB_CONTEXT_MENU_FACTORY)
			-- Create a tree where targets of system are not shown.
		do
			make (a_context_menu_factory)
			has_targets := False
		end

	make_for_class_selection (a_context_menu_factory: EB_CONTEXT_MENU_FACTORY)
			-- Create a tree where only existing classes may be shown.
		do
			make (a_context_menu_factory)
			has_targets := False
			is_class_selection_only := True
		end

	make_with_options (a_context_menu_factory: EB_CONTEXT_MENU_FACTORY; a_show_targets, a_show_classes: BOOLEAN)
			-- Create a tree with options
		do
			make (a_context_menu_factory)
			has_targets := a_show_targets
			is_show_classes := a_show_classes
		ensure
			set: has_targets = a_show_targets
			set: is_show_classes = a_show_classes
		end

	prepare
			-- Setup the layout of the grid.
		do
			set_minimum_height (20)
			enable_tree
			enable_last_column_use_all_width
			enable_single_row_selection
			enable_vertical_scrolling_per_item
			enable_default_tree_navigation_behavior (False, False, False, True)

			hide_header
			hide_tree_node_connectors
		end

	build_tree
			-- Remove and replace contents of `Current'.
		local
			l_env: EV_ENVIRONMENT
			l_locked: BOOLEAN
		do
			create l_env
			if window /= Void and l_env.application.locked_window = Void then
					-- Lock update of window, so rebuilding of `Current' is hidden.			
				window.lock_update
				l_locked := True
			end

			build_tree_on_grid

			if window /= Void and l_locked then
					-- Unlock update of window as `Current' has been rebuilt.
				window.unlock_update
			end
		end

	build_tree_on_grid
			-- Build tree on current grid
		local
			l_target: CONF_TARGET
		do
				-- Remove all items, ready for rebuilding.
			if Eiffel_project.workbench.is_universe_ready then
				wipe_out

				l_target := Universe.target

					-- sort clusters
				create cluster_header.make (interface_names.l_class_tree_clusters, pixmaps.icon_pixmaps.top_level_folder_clusters_icon)
				build_group_tree (manager.clusters, cluster_header)
				cluster_header.set_stone (create {DATA_STONE}.make (groups_from_sorted_clusters (manager.clusters, True), agent is_group_valid))

					-- sort overrides
				create override_header.make (interface_names.l_class_tree_overrides, pixmaps.icon_pixmaps.top_level_folder_overrides_icon)
				build_group_tree (manager.overrides, override_header)
				override_header.set_stone (create {DATA_STONE}.make (groups_from_sorted_clusters (manager.overrides, True), agent is_group_valid))

					-- sort libraries
				create library_header.make (interface_names.l_class_tree_libraries, pixmaps.icon_pixmaps.top_level_folder_library_icon)
				build_group_tree (manager.libraries, library_header)
				library_header.set_stone (create {DATA_STONE}.make (groups_from_sorted_clusters (manager.libraries, True), agent is_group_valid))

					-- sort assemblies
				create assembly_header.make (interface_names.l_class_tree_assemblies, pixmaps.icon_pixmaps.top_level_folder_references_icon)
				build_group_tree (manager.assemblies, assembly_header)
				assembly_header.set_stone (create {DATA_STONE}.make (groups_from_sorted_clusters (manager.assemblies, True), agent is_group_valid))

					-- targets
				if has_targets then
					build_target_tree
				end
			end
		end

feature -- Activation

	associate_with_window (a_window: EB_DEVELOPMENT_WINDOW)
			-- Set `window' to `a_window'.
		do
			if window = Void then
				key_press_actions.extend (agent on_key_pushed)
			end
			window := a_window
		end

feature -- Status report

	is_empty: BOOLEAN
			-- Does the current grid have no elements?
		do
			Result := row_count = 0
		end

feature {NONE} -- Status report

	has_readonly_items: BOOLEAN
			-- Shall read only items be shown in `Current'?
		do
			Result := True
		end

feature -- Observer pattern

	refresh
			-- Rebuild the tree.
		do
			build_tree
		end

	on_class_added (a_class: EIFFEL_CLASS_I)
			-- Refresh the tree to display the new class.
		do
			refresh
		end

	on_class_removed (a_class: EIFFEL_CLASS_I)
			-- Refresh the tree not to display the old class.
		do
			refresh
		end

	on_class_moved (a_class: CONF_CLASS; old_group: CONF_GROUP; old_path: STRING)
			-- Refresh the tree to display `a_class' in its new folder.
			-- `old_path' is old relative path in `old_group'
		do
			refresh
		end

	on_cluster_added (a_cluster: CLUSTER_I)
			-- Refresh the tree to display the new cluster.
		do
			refresh
		end

	on_cluster_changed (a_cluster: CLUSTER_I)
			-- Refresh the tree to display the modified cluster.
		do
			refresh
		end

	on_cluster_moved (a_cluster: EB_SORTED_CLUSTER; old_cluster: CLUSTER_I)
			-- Refresh the tree to display `a_cluster' in its new folder.
		do
			refresh
		end

	on_cluster_removed (a_group: EB_SORTED_CLUSTER; a_path: STRING)
			-- Refresh the tree not to display the old cluster.
		do
			refresh
		end

	on_project_loaded
			-- Refresh the tree to display the new project.
		do
			refresh
		end

	on_project_unloaded
			-- Erase the tree.
		do
			wipe_out
		end

feature {NONE} -- Rebuilding

	cluster_header: EB_GROUPS_GRID_HEADER_ITEM
			-- Header for clusters.

	override_header: EB_GROUPS_GRID_HEADER_ITEM
			-- Header for overrides.

	assembly_header: EB_GROUPS_GRID_HEADER_ITEM
			-- Header for assemblies.

	library_header: EB_GROUPS_GRID_HEADER_ITEM
			-- Header for libraries.

feature {NONE} -- Context menu handler and construction

	on_menu_handler (a_menu: EV_MENU; a_target_list: ARRAYED_LIST [EV_PND_TARGET_DATA]; a_source: EV_PICK_AND_DROPABLE; a_pebble: ANY)
			-- Context menu handler for classes, clusters, libraries, targets and assemblies
		do
			if a_pebble /= Void then
				context_menu_factory.class_tree_menu (a_menu, a_target_list, a_source, a_pebble)
				extend_working_copy_menu (a_menu, a_pebble)
			end
--			context_menu_factory.clusters_data_menu (a_menu, a_target_list, a_source, a_pebble)
--			context_menu_factory.libraries_data_menu (a_menu, a_target_list, a_source, a_pebble)
--			context_menu_factory.assemblies_data_menu (a_menu, a_target_list, a_source, a_pebble)
		end

	extend_working_copy_menu (a_menu: EV_MENU; a_pebble: ANY)
		local
			l_menu: EV_MENU
			l_menu_item: EV_MENU_ITEM
		do
			create l_menu.make_with_text ("Subversion")
			a_menu.extend (l_menu)

			create l_menu_item.make_with_text_and_action ("Add to working copy", agent svn_add (a_pebble))
			l_menu.extend (l_menu_item)

			create l_menu_item.make_with_text_and_action ("Commit...", agent show_commit_dialog (a_pebble))
			l_menu.extend (l_menu_item)

			create l_menu_item.make_with_text_and_action ("Update", agent svn_update (a_pebble))
			l_menu.extend (l_menu_item)
		end

feature {NONE} -- Event handler

	on_pebble_function (a_item: EV_GRID_ITEM): ANY
			-- Pebble associated with `a_item'
		local
			d: like data_from_item
		do
			if not ev_application.ctrl_pressed then
				d := data_from_item (a_item)
				if attached {CLASS_I}d as ci then
					if ci.is_compiled then
						create {CLASSC_STONE}Result.make (ci.compiled_class)
					else
						create {CLASSI_STONE}Result.make (ci)
					end
				elseif attached {EB_SORTED_CLUSTER}d as cl then
					create {CLUSTER_STONE}Result.make (cl.actual_group)
				end
			end
		end

	on_item_accept_cursor_function (a_item: EV_GRID_ITEM): EV_POINTER_STYLE
			-- Accept cursor computing
		do
			if attached {STONE} on_pebble_function (a_item) as st then
				Result := st.stone_cursor
			end
		end

	on_item_deny_cursor_function (a_item: EV_GRID_ITEM): EV_POINTER_STYLE
			-- Deny cursor computing
		do
			if attached {STONE} on_pebble_function (a_item) as st then
				Result := st.X_stone_cursor
			end
		end

feature {NONE} -- Basic operations

	data_from_item (a_item: EV_GRID_ITEM): ANY
			-- Data related to `a_item'
		do
			if a_item /= Void then
				Result := a_item.data
			end
		end

	path_from_pebble (a_pebble: ANY): TUPLE [working_path, target: STRING_8]
			-- Working path and file name of `a_pebble', which can be a cluster or a file
		local
			l_path_components: LIST[STRING_8]
			l_item: EV_GRID_ITEM
		do
			create Result
			if attached {CLASSI_STONE}a_pebble as ci then
				Result.working_path := ci.file_name
			elseif attached {CLUSTER_STONE}a_pebble as cl then
					-- The selected row holds the full path of the cluster or folder
					l_item := selected_rows.i_th (1).item (1)
					if attached {EB_GROUPS_GRID_FOLDER_ITEM}l_item as f then
						Result.working_path := f.full_path
					end
			end
			l_path_components := Result.working_path.split ('/')
			Result.target := l_path_components.last
			Result.working_path := Result.working_path.substring (1, Result.working_path.count - Result.target.count)
		end

feature {NONE} -- Implementation

	on_key_pushed (a_key: EV_KEY)
			-- If `a_key' is enter, set a stone in the development window.
		local
			l_item: EV_GRID_ITEM
			testfile: RAW_FILE
		do
			if selected_rows.count > 0 then
				l_item := selected_rows.i_th (1).item (1)
			end
			if
				a_key.code = Key_enter and then
				window /= Void and then
				l_item /= Void
			then
				if attached {EB_GROUPS_GRID_CLASS_ITEM}l_item as conv_class then
					create testfile.make (conv_class.data.file_name)
					if testfile.exists and then testfile.is_readable then
						window.set_stone (conv_class.stone)
					else
						prompts.show_warning_prompt ("Class file could not be read. Removing class from the system.", Void, Void)
						manager.remove_class (conv_class.data)
					end
				elseif attached {EB_GROUPS_GRID_FOLDER_ITEM}l_item as conv_cluster then
					window.set_stone (conv_cluster.stone)
				end
			end
		end

	window: EB_DEVELOPMENT_WINDOW
			-- Development window classes should be associated with.

	textable: EV_TEXT_COMPONENT
			-- Text component classes should be associated with.

	build_group_tree (a_grps: DS_ARRAYED_LIST [EB_SORTED_CLUSTER]; a_header: EB_GROUPS_GRID_HEADER_ITEM)
			-- Build a tree for `a_grps' under `a_header' and add it to the tree if we have elements.
			-- Attach the grid items to `Current'
		require
			a_grps_not_void: a_grps /= Void
			a_header_not_void: a_header /= Void
		local
			l_item: EB_GROUPS_GRID_FOLDER_ITEM
			l_group: EB_SORTED_CLUSTER
		do
			extend (a_header)
			from
				a_grps.start
			until
				a_grps.after
			loop
				l_group := a_grps.item_for_iteration
				if not l_group.actual_group.is_internal and (has_readonly_items or l_group.is_writable) then
					l_item := create_folder_item (l_group, a_header.row)

					if textable /= Void and not is_show_classes then
						l_item.set_associated_textable (textable)
					end

					l_item.associate_with_window (window)
					if textable /= Void then
						l_item.associate_textable_with_classes (textable)
					end
				end
				a_grps.forth
			end
			if a_header.is_empty then
				remove_row (a_header.row_index)
			end
		end

	build_target_tree
			-- Build a tree for the targets of the current system, that make up the application target.
		local
			l_target: detachable CONF_TARGET
			l_item, l_new_item: EB_GROUPS_GRID_TARGET_ITEM
		do
			l_target := universe.target
			if attached l_target then
				from
					create l_item.make (l_target)
				until
					l_target.extends = Void
				loop
					l_target := l_target.extends

					create l_new_item.make (l_target)
					l_new_item.extend_subrow (l_item)
					l_item := l_new_item
				end
				extend (l_item)
				l_item.associate_with_window (window)
			end
		end

	has_targets: BOOLEAN
			-- Is tree showing targets?

	groups_from_sorted_clusters (a_sorted_clusters: DS_LIST [EB_SORTED_CLUSTER]; a_recursive: BOOLEAN): LIST [CONF_GROUP]
			-- List of groups from `a_sorted_clusters'.
			-- If `a_recursive' is True, retrieve groups recursively.
		local
			l_group_set: DS_HASH_SET [CONF_GROUP]
			l_set_cursor: DS_HASH_SET_CURSOR [CONF_GROUP]
			l_list_cursor: DS_LIST_CURSOR [EB_SORTED_CLUSTER]
		do
			create {LINKED_LIST [CONF_GROUP]} Result.make
			if a_sorted_clusters /= Void then
				create l_group_set.make (10)
				l_list_cursor := a_sorted_clusters.new_cursor
				from
					l_list_cursor.start
				until
					l_list_cursor.after
				loop
					find_groups (l_list_cursor.item, l_group_set, a_recursive)
					l_list_cursor.forth
				end

				l_set_cursor := l_group_set.new_cursor
				from
					l_set_cursor.start
				until
					l_set_cursor.after
				loop
					Result.extend (l_set_cursor.item)
					l_set_cursor.forth
				end
			end
		ensure
			result_attached: Result /= Void
		end

	find_groups (a_source: EB_SORTED_CLUSTER; a_group_set: DS_HASH_SET [CONF_GROUP]; a_recursive: BOOLEAN)
			-- Find groups from `a_source' and store them in `a_group_set'.
			-- If `a_recursive' is True, search for groups recursively.
		require
			a_source_attached: a_source /= Void
			a_group_set_attached: a_group_set /= Void
		local
			l_group: CONF_GROUP
			l_children: DS_LINKED_LIST [EB_SORTED_CLUSTER]
			l_cursor: DS_LINKED_LIST_CURSOR [EB_SORTED_CLUSTER]
		do
			l_group := a_source.actual_group
			if l_group /= Void and then not a_group_set.has (l_group) then
				a_group_set.force_last (l_group)
				if a_recursive then
					create l_children.make
					safe_append_list (l_children, a_source.clusters)
					safe_append_list (l_children, a_source.overrides)
					safe_append_list (l_children, a_source.libraries)
					safe_append_list (l_children, a_source.assemblies)
					l_cursor := l_children.new_cursor
					from
						l_cursor.start
					until
						l_cursor.after
					loop
						find_groups (l_cursor.item, a_group_set, a_recursive)
						l_cursor.forth
					end
				end
			end
		end

	safe_append_list (a_source: DS_LIST [EB_SORTED_CLUSTER]; a_dest: DS_LIST [EB_SORTED_CLUSTER])
			-- If `a_dest' is not Void, append it to `a_source'.
		require
			a_source_attached: a_source /= Void
		do
			if a_dest /= Void then
				a_source.append_last (a_dest)
			end
		end

	is_group_valid (a_data: ANY): BOOLEAN
			-- Does `a_data' contain valid groups information?
		local
			l_groups: LIST [CONF_GROUP]
		do
			if a_data = Void then
				Result := True
			else
				l_groups ?= a_data
				if l_groups /= Void then
					Result := l_groups.for_all (agent (a_group: CONF_GROUP): BOOLEAN do Result := a_group /= Void and then a_group.is_valid end)
				end
			end
		end

	is_show_classes: BOOLEAN
			-- Show classes notes?

	is_class_selection_only: BOOLEAN
			-- Is tree only used for the purpose of selecting an existing class from the universe?

	item_from_status (a_status: SVN_CLIENT_FOLDER; a_name: STRING_8): SVN_CLIENT_ITEM
			-- Item in `a_status' that has the same name as `a_name', if any
		require
			status_not_void: a_status /= Void
			name_not_void: a_name /= Void
		do
			from a_status.start
			until a_status.after
			loop
				if a_status.item_for_iteration.name.same_string (a_name) then
					Result := a_status.item_for_iteration
				end
				a_status.forth
			end
		end

	retrieve_status_for_row (a_row: EV_GRID_ROW)
		require
			row_not_void: a_row /= Void
		do
				-- Perform status only if `a_row' is in the cluster group
			if attached {EB_GROUPS_GRID_HEADER_ITEM}a_row.parent_row_root.item(1) as l_header and then l_header.is_clusters_group then
				if attached {EB_GROUPS_GRID_FOLDER_ITEM}a_row.item (1) as f then
					svn_client.set_working_path (f.full_path)
					svn_client.status.put_option ("--depth", "immediates")
					svn_client.status.set_did_finish_handler (agent on_retrieved_status (f))
					svn_client.status.execute
				end
			end
		end

	on_retrieved_status (a_folder_item: EB_GROUPS_GRID_FOLDER_ITEM)
		require
			folder_item_not_void: a_folder_item /= Void
		local
			l_status: SVN_CLIENT_FOLDER
			l_item: SVN_CLIENT_ITEM
			l_row_index: INTEGER
		do
				-- Reset previous status
			from l_row_index := 1
			until l_row_index > a_folder_item.row.subrow_count
			loop
				if attached {EB_GROUPS_GRID_ITEM}a_folder_item.row.subrow (l_row_index).item (1) as gi then
					gi.set_subversion_pixmap (pixmaps.icon_pixmaps.general_blank_icon)
				end
				l_row_index := l_row_index + 1
			end

			l_status := svn_client.status.last_status
			from l_row_index := 1
			until l_row_index > a_folder_item.row.subrow_count
			loop
				if attached {EB_GROUPS_GRID_ITEM}a_folder_item.row.subrow (l_row_index).item (1) as gi then
					l_item := item_from_status (l_status, gi.name)
					if l_item /= Void then
							-- The pixmaps will change as soon as the actual images are added to the project
						inspect l_item.properties.at (1)
						when 'A' then
								-- item has been added to the working copy
							gi.set_subversion_pixmap (pixmaps.icon_pixmaps.information_edit_auto_node_icon)
						when 'C' then
								-- item is in conflict
							gi.set_subversion_pixmap (pixmaps.icon_pixmaps.general_close_all_documents_icon)
						when 'D' then
								-- item has been deleted from the working copy
							gi.set_subversion_pixmap (pixmaps.icon_pixmaps.tool_error_icon)
						when 'I' then
								-- item is being ignored
							gi.set_subversion_pixmap (pixmaps.icon_pixmaps.testing_see_failure_trace_icon)
						when 'M' then
								-- item has been modified
							gi.set_subversion_pixmap (pixmaps.icon_pixmaps.view_editor_icon)
						when 'R' then
								-- item has been replaced
							gi.set_subversion_pixmap (pixmaps.icon_pixmaps.view_flat_icon)
						when 'X' then
								-- unversioned directory created by an externals definition
							gi.set_subversion_pixmap (pixmaps.icon_pixmaps.general_close_icon)
						when '?' then
								-- item is not under version control
							gi.set_subversion_pixmap (pixmaps.icon_pixmaps.debug_attach_icon)
						when '!' then
								-- item is missing or incomplete
							gi.set_subversion_pixmap (pixmaps.icon_pixmaps.tool_warning_icon)
						when '~' then
								-- item obstructed by some item of a different kind
							gi.set_subversion_pixmap (pixmaps.icon_pixmaps.breakpoints_delete_icon)
						else
								-- No modification occurred
							gi.set_subversion_pixmap (pixmaps.icon_pixmaps.general_blank_icon)
						end
					end

				end
				l_row_index := l_row_index + 1
			end
		end

feature -- Tree construction

	extend (a_grid_item: EV_GRID_ITEM)
			-- Add a new row to the end of the current grid and assign `a_grid_item' to it
		require
			grid_item_not_void: a_grid_item /= Void
		do
			extended_new_row.set_item (1, a_grid_item)
		end

feature {NONE} -- Subversion context menu commands

	show_commit_dialog (a_pebble: ANY)
		require
			pebble_not_void: a_pebble /= Void
		local
			l_commit_dialog: EB_COMMIT_DIALOG
			l_path: like path_from_pebble
		do
			l_path := path_from_pebble (a_pebble)
			create l_commit_dialog.make_default (l_path.target)
			l_commit_dialog.set_commit_action (agent svn_commit (l_path.working_path, l_path.target, ?))
			l_commit_dialog.show
		end

	svn_add (a_pebble: ANY)
		require
			pebble_not_void: a_pebble /= Void
		local
			l_path: like path_from_pebble
		do
			l_path := path_from_pebble (a_pebble)
			svn_client.set_working_path (l_path.working_path)
			svn_client.add.set_target (l_path.target)
			svn_client.add.set_error_handler (agent error)
			svn_client.add.execute
		end

	svn_commit (a_working_path, a_target, a_message: STRING_8)
		require
			working_path_not_void: a_working_path /= Void
			target_not_void: a_target /= Void
			message_not_void: a_message /= Void
		do
			svn_client.set_working_path (a_working_path)
			svn_client.commit.set_target (a_target)
			svn_client.commit.put_option ("-m", a_message)
			svn_client.commit.execute
		end

	svn_update (a_pebble: ANY)
		require
			pebble_not_void: a_pebble /= Void
		local
			l_path: like path_from_pebble
		do
			l_path := path_from_pebble (a_pebble)
			svn_client.set_working_path (l_path.working_path)
			svn_client.update.set_target (l_path.target)
			svn_client.update.execute
		end

	error (s: STRING)
		local
			l_error_dialog: EV_ERROR_DIALOG
		do
--			print ("Error: " + s)
			create l_error_dialog.make_with_text(s)
			l_error_dialog.show
		end

feature {NONE} -- Factory

	create_folder_item (a_group: EB_SORTED_CLUSTER; a_parent_row: EV_GRID_ROW): EB_GROUPS_GRID_FOLDER_ITEM
			-- Create new folder item
		require
			parent_row_not_void: a_parent_row /= Void
		do
			create Result.make_with_option (a_group, is_show_classes, a_parent_row)
		end

feature {EB_CLASSES_TREE_ITEM} -- Protected Properties

	context_menu_factory: EB_CONTEXT_MENU_FACTORY
			-- Context menu factory

	classes_double_click_agents: LINKED_LIST [PROCEDURE [ANY, TUPLE [INTEGER, INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, INTEGER, INTEGER]]]
			-- Agents associated to double-clicks on classes.

	cluster_double_click_agents: LINKED_LIST [PROCEDURE [ANY, TUPLE [INTEGER, INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, INTEGER, INTEGER]]];
			-- Agents associated to double-clicks on clusters.

	classes_single_click_agents: LINKED_LIST [PROCEDURE [ANY, TUPLE [INTEGER, INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, INTEGER, INTEGER]]]
			-- Agents associated to single-click on classes.

	cluster_single_click_agents: LINKED_LIST [PROCEDURE [ANY, TUPLE [INTEGER, INTEGER, INTEGER, DOUBLE, DOUBLE, DOUBLE, INTEGER, INTEGER]]];
			-- Agents associated to single-click on clusters.

	svn_client: SVN_CLIENT
			-- SVN client associated to clusters and classes.

invariant
	classes_double_click_agents_not_void: classes_double_click_agents /= Void
	cluster_double_click_agents_not_void: cluster_double_click_agents /= Void
	classes_single_click_agents_not_void: classes_single_click_agents /= Void
	cluster_single_click_agents_not_void: cluster_single_click_agents /= Void

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
