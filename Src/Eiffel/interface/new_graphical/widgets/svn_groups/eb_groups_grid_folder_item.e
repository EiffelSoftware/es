note
	description: "Summary description for {EB_GROUPS_GRID_FOLDER_ITEM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_GROUPS_GRID_FOLDER_ITEM

inherit
	EB_GROUPS_GRID_ITEM
		redefine
			associate_with_window,
			data,
			set_data,
			stone
		end

create
	make,
	make_sub,
	make_with_option,
	make_with_all_options

feature -- Initialization

	make (a_cluster: EB_SORTED_CLUSTER; a_parent_row: EV_GRID_ROW)
			-- Create a grid item representing `a_cluster' and attach it to `a_parent_row'.
		require
			cluster_not_void: a_cluster /= Void
			parent_row_not_void: a_parent_row /= Void
		do
			make_sub (a_cluster, "", a_parent_row)
		end

	make_sub (a_cluster: EB_SORTED_CLUSTER; a_path: STRING; a_parent_row: EV_GRID_ROW)
			-- Create a grid item representing a subfolder of `a_cluster' and attach it to `a_parent_row'.
		require
			path_not_void: a_path /= Void
			cluster_not_void: a_cluster /= Void
			parent_row_not_void: a_parent_row /= Void
			sub_elements_imply_initialized: not a_path.is_empty implies a_cluster.is_initialized
		do
			default_create
			path := a_path
			if path = Void then
				create path.make_empty
			end
			set_data (a_cluster)
			a_parent_row.insert_subrow (a_parent_row.subrow_count + 1)
			a_parent_row.subrow (a_parent_row.subrow_count).set_item (1, Current)
			is_show_classes := True
			load
		end

		make_with_all_options (a_cluster: EB_SORTED_CLUSTER; a_path: STRING; a_show_classes: BOOLEAN; a_parent_row: EV_GRID_ROW)
			-- Create with various options
		require
			cluster_not_void: a_cluster /= Void
			path_not_void: a_path /= Void
			parent_row_not_void: a_parent_row /= Void
			sub_elements_imply_initialized: not a_path.is_empty implies a_cluster.is_initialized
		do
			make_sub (a_cluster, a_path, a_parent_row)
			is_show_classes := a_show_classes
		end

	make_with_option (a_cluster: EB_SORTED_CLUSTER; a_show_classes: BOOLEAN; a_parent_row: EV_GRID_ROW)
			-- Create with option `a_show_classes'
		require
			cluster_not_void: a_cluster /= Void
			parent_row_not_void: a_parent_row /= Void
		do
			make (a_cluster, a_parent_row)
			is_show_classes := a_show_classes
		end

	is_show_classes: BOOLEAN
		-- Show classes notes?

feature -- Status report

	data: EB_SORTED_CLUSTER
			-- cluster represented by `Current'.

	path: STRING
			-- relative path to cluster location (for recursive clusters).

	full_path: STRING
			-- absolute path of `Current' folder
		do
			Result := data.actual_group.location.evaluated_path + path
		end

feature -- Access

	stone: CLUSTER_STONE
			-- Cluster stone representing `data'.
		local
			l_group: CONF_GROUP
		do
			l_group := data.actual_group
			if l_group.is_cluster then
				create Result.make_subfolder (data.actual_group, path, name)
			else
				create Result.make (data.actual_group)
			end
		end

feature -- Status setting

	set_data (a_cluster: EB_SORTED_CLUSTER)
			-- Affect `a_cluster' to `data'.
		local
			l_group: CONF_GROUP
			l_pos: INTEGER
		do
			data := a_cluster
			l_group := a_cluster.actual_group
			if not path.is_empty then
				l_pos := path.last_index_of ('/', path.count)
				if l_pos > 0 then
					name := path.substring (l_pos+1, path.count)
				else
					create name.make_empty
				end
			end
			if name = Void then
				name := l_group.name
			end
			set_text (name)
--			set_tooltip (tooltip_text)
			set_pixmap (pixmaps.configuration_pixmaps.pixmap_from_group_path (l_group, path))
			if not (l_group.is_readonly) then
--				drop_actions.set_veto_pebble_function (agent droppable)
--				drop_actions.extend (agent on_class_drop)
--| FIXME XR: When clusters can be moved effectively, uncomment this line.
--				drop_actions.extend (~on_cluster_drop)
			end
		ensure then
			data = a_cluster
			name_set: name /= Void
		end

feature -- Interactivity

	associate_with_window (a_window: EB_STONABLE)
			-- Recursively associate `a_window' with sub-classes so they can call `set_stone' on `a_window'.
		local
			l_item: EV_GRID_ITEM
			l_row_index: INTEGER
		do
			Precursor (a_window)
			from
				l_row_index := 1
			until
				l_row_index > row.subrow_count
			loop
				l_item := row.subrow (l_row_index).item (1)
				if attached {EB_GROUPS_GRID_FOLDER_ITEM}l_item as conv_folder then
					conv_folder.associate_with_window (a_window)
				elseif attached{EB_GROUPS_GRID_CLASS_ITEM}l_item as conv_class then
					conv_class.associate_with_window (a_window)
				end
				l_row_index := l_row_index + 1
			end
		end

feature {EB_GROUPS_GRID_CLASS_ITEM} -- Interactivity

	 load
			-- Load the classes and the sub_clusters of `data'.
		local
			subfolders: SORTABLE_ARRAY [STRING]
			classes: DS_LIST [CLASS_I]
			l_subfolder: EB_GROUPS_GRID_FOLDER_ITEM
			a_class: EB_GROUPS_GRID_CLASS_ITEM
			orig_count: INTEGER
			i, up: INTEGER
			l_dir: KL_DIRECTORY
			l_set: ARRAY [STRING]
			l_hash_set: DS_HASH_SET [STRING]
			cluster: CLUSTER_I
			group: CONF_GROUP
			l_sub_path: STRING
			l_fr: CONF_FILE_RULE
			l_name: STRING
		do
			orig_count := row.subrow_count_recursive

			if not data.is_initialized then
				data.initialize
			end

				-- Build the tree.

				-- if we aren't a subfolder show clusters
			if path.is_empty then
				show_groups (data.clusters)
			end

				-- if we are a recursive cluster show subfolders
			group := data.actual_group
			cluster ?= group
			if cluster /= Void and then cluster.is_recursive then
				create l_dir.make (group.location.build_path (path, ""))
				l_set := l_dir.directory_names
				if l_set /= Void then
					create subfolders.make_from_array (l_set)
					subfolders.sort
					from
					l_fr := cluster.active_file_rule (universe.conf_state)
						i := subfolders.lower
						up := subfolders.upper
					until
						i > up
					loop
						l_sub_path := path + cluster_separator + subfolders[i]
						if l_fr.is_included (l_sub_path) then
							l_subfolder := create_folder_item_with_options (data, l_sub_path, row)
							l_subfolder.associate_with_window (associated_window)
							if associated_textable /= Void then
								l_subfolder.associate_textable_with_classes (associated_textable)
							end

							if associated_textable /= Void and not is_show_classes then
								l_subfolder.set_associated_textable (associated_textable)
							end
						end
						i := i + 1
					end
				end
				-- if we are an assembly show subfolders
			elseif group.is_assembly or group.is_physical_assembly then
				l_hash_set := data.sub_folders.item (path + cluster_separator)
				if l_hash_set /= Void then
					create subfolders.make (1, l_hash_set.count)
					from
						l_hash_set.start
						i := 1
					until
						l_hash_set.after
					loop
						subfolders.force (l_hash_set.item_for_iteration, i)
						i := i + 1
						l_hash_set.forth
					end
					subfolders.sort
					from
						i := subfolders.lower
						up := subfolders.upper
					until
						i > up
					loop
						l_subfolder := create_folder_item_with_options (data, path+ cluster_separator +subfolders[i], row)
						l_subfolder.associate_with_window (associated_window)
						if associated_textable /= Void then
							l_subfolder.associate_textable_with_classes (associated_textable)
						end
						if associated_textable /= Void and not is_show_classes then
							l_subfolder.set_associated_textable (associated_textable)
						end
						extend_subrow (l_subfolder)
						i := i + 1
					end
				end
			end

			if data.is_library then
					-- show overrides for libraries
				show_groups (data.overrides)

					-- show libraries for libraries
				show_groups (data.libraries)

					-- show assemblies for libraries
				show_groups (data.assemblies)
			end

				-- show assembly dependencies for assemblies if we are on not a subfolder
			if path.is_empty and (data.is_assembly or data.is_physial_assembly) then
				show_groups (data.assemblies)
			end

				-- show classes for clusters and assemblies
			if data.is_cluster or (data.is_assembly or data.is_physial_assembly) then
				if is_show_classes then
					classes := data.sub_classes.item (path + cluster_separator)
					if classes /= Void then
						from
							classes.start
						until
							classes.after
						loop
							if classes.item_for_iteration.is_valid then
								l_name := classes.item_for_iteration.name.twin
								if data.renaming.has (l_name) then
									l_name := data.renaming.item (l_name)
								end
								l_name.prepend (data.name_prefix)
								create a_class.make (classes.item_for_iteration, l_name)
								a_class.associate_with_window (associated_window)
								if associated_textable /= Void then
									a_class.set_associated_textable (associated_textable)
								end

								a_class.load_overriden_children
								extend_subrow (a_class)
							end
							classes.forth
						end
					end
				else
					if associated_textable /= Void then
						set_associated_textable (associated_textable)
					end
				end
			end

				-- We now remove all the items that were present at the beginning.
				--| We cannot wipe_out at first because under GTK it collapses `Current'.
			from
				i := 0
--				start
			until
				i = orig_count
			loop
--				remove
				attached_parent.remove_row (row_index + i + 1)
				i := i + 1
			end
				-- By removing `load' from `expand_actions', it ensures that
				-- the contents of the item are no longer created dynamically.
				-- This ensures that the tree retains its state as nodes are contracted and
				-- then expanded.
--			expand_actions.wipe_out
		end

feature {NONE} -- Interactivity

	cluster_separator: STRING = "/"
			-- Cluster sub path separator

feature -- Interactivity

	associate_textable_with_classes (textable: EV_TEXT_COMPONENT)
			-- Recursively associate `textable' with sub-classes so they can write their names in `textable'.
		local
			conv_folder: EB_GROUPS_GRID_FOLDER_ITEM
			conv_class: EB_GROUPS_GRID_CLASS_ITEM
			l_row_index: INTEGER
		do
			associated_textable := textable

			from
				l_row_index := 1
			until
				l_row_index > row.subrow_count
			loop
				conv_folder ?= row.subrow (l_row_index)
				if conv_folder /= Void then
					conv_folder.associate_textable_with_classes (textable)
				else
					conv_class ?= row.subrow (l_row_index)
					conv_class.set_associated_textable (textable)
				end
				l_row_index := l_row_index + 1
			end
		end

feature {NONE} -- Implementation

	show_groups (a_groups: DS_LIST [EB_SORTED_CLUSTER])
			-- Show `a_groups'.
		require
			a_groups_not_void: a_groups /= Void
		local
			a_folder: EB_GROUPS_GRID_FOLDER_ITEM
			l_group: EB_SORTED_CLUSTER
		do
				from
					a_groups.start
				until
					a_groups.after
				loop
					l_group := a_groups.item_for_iteration
					a_folder := create_folder_item (l_group, row)

					a_folder.associate_with_window (associated_window)
					if associated_textable /= Void then
						a_folder.associate_textable_with_classes (associated_textable)
					end
					a_groups.forth
				end
		end

feature {NONE} -- Factory

	create_folder_item_with_options (a_cluster: EB_SORTED_CLUSTER; a_path: STRING_8; a_parent_row: EV_GRID_ROW): EB_GROUPS_GRID_FOLDER_ITEM
			-- Create new folder item and add it to a subrow of `a_parent_row'.
		require
			parent_row_not_void: a_parent_row /= Void
		do
			create Result.make_with_all_options (a_cluster, a_path, is_show_classes, a_parent_row)
		end

	create_folder_item (a_cluster: EB_SORTED_CLUSTER; a_parent_row: EV_GRID_ROW): EB_GROUPS_GRID_FOLDER_ITEM
			-- Create new folder item and add it to a subrow of `a_parent_row'.
		require
			parent_row_not_void: a_parent_row /= Void
		do
			create Result.make_with_option (a_cluster, is_show_classes, a_parent_row)
		end

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
