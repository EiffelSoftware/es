note
	description: "Summary description for {SCM_STATUS_BOX}."
	date: "$Date$"
	revision: "$Revision$"

class
	SCM_STATUS_BOX

inherit
	EV_VERTICAL_BOX
		redefine
			initialize
		end

	EV_LAYOUT_CONSTANTS
		undefine
			default_create,
			is_equal,
			copy
		end

	EB_SHARED_PIXMAPS
		undefine
			default_create,
			is_equal,
			copy
		end

	SHARED_SCM_NAMES
		undefine
			default_create,
			is_equal,
			copy
		end

	EB_SHARED_WINDOW_MANAGER
		undefine
			default_create,
			is_equal,
			copy
		end

	SHARED_EXECUTION_ENVIRONMENT
		undefine
			default_create,
			is_equal,
			copy
		end

create
	make

feature {NONE} -- Initialization

	make (a_service: SOURCE_CONTROL_MANAGEMENT_S; win: EB_DEVELOPMENT_WINDOW)
		do
			scm_service := a_service
			development_window := win
			default_create
		end

	initialize
		do
			Precursor
			build_interface (Current)
		end

	build_interface (b: EV_VERTICAL_BOX)
		local
			bar: EV_HORIZONTAL_BOX
			but: EV_BUTTON
			unver_cb, hide_cb: EV_CHECK_BUTTON
			l_combo: EV_COMBO_BOX
			pix: EV_PIXMAP
			pix_cell: EV_CELL
		do
			create bar
			bar.set_padding_width (small_padding_size)
			bar.set_border_width (small_border_size)
			b.extend (bar)
			b.disable_item_expand (bar)

--			bar.extend (create {EV_CELL})

			create but.make_with_text (scm_names.button_check_all)
			but.set_pixmap (icon_pixmaps.general_refresh_icon)
			check_all_repo_button := but
			but.select_actions.extend (agent
					do
						update_statuses (Void)
					end
				)
			bar.extend (but); bar.disable_item_expand (but)

--			bar.extend (create {EV_CELL})

			create but.make_with_text (scm_names.button_commit_changelist)
			set_default_size_for_button (but)
			but.set_tooltip (scm_names.button_commit_changelist_tooltip)
			save_all_repo_button := but
			but.disable_sensitive
			but.select_actions.extend (agent on_save)
			bar.extend (but); bar.disable_item_expand (but)


			create l_combo
			l_combo.return_actions.extend (agent on_changelist_combo_changed)
--			l_combo.set_minimum_width (20)
			changelist_combo := l_combo
			update_changelist_combo (l_combo)
			bar.extend (l_combo)

			create pix_cell
			pix := icon_pixmaps.general_remove_icon
			pix_cell.extend (pix)
			pix_cell.set_minimum_size (pix.width, pix.height)
			pix.set_tooltip (scm_names.button_clear_changelist_tooltip)
			pix.pointer_button_release_actions.extend (agent (ix,iy,ibut: INTEGER; r1,r2,r3: REAL_64; i7,i8: INTEGER)
					do
						if ibut = {EV_POINTER_CONSTANTS}.left then
							on_clear_active_changelist
						end
					end)
			bar.extend (pix_cell)
			bar.disable_item_expand (pix_cell)

			create grid_cell
			b.extend (grid_cell)

			create bar
			bar.set_padding_width (small_padding_size)
			bar.set_border_width (small_border_size)
			b.extend (bar)
			b.disable_item_expand (bar)

			create unver_cb.make_with_text (scm_names.question_show_unversioned_files)
			bar.extend (unver_cb); bar.disable_item_expand (unver_cb)
			if scm_service.config.show_unversioned_files_enabled then
				unver_cb.enable_select
			end
			unver_cb.select_actions.extend (agent (a_cb: EV_CHECK_BUTTON)
					do
						include_unversioned_files (a_cb.is_selected)
					end(unver_cb))

			include_unversioned_files_checkbox := unver_cb

			create hide_cb.make_with_text (scm_names.question_hide_location_with_no_change)
			hide_cb.set_tooltip (scm_names.tooltip_question_hide_location_with_no_change)
			bar.extend (hide_cb); bar.disable_item_expand (hide_cb)
			if scm_service.config.hide_location_with_no_change_enabled then
				hide_cb.enable_select
			end
			hide_cb.select_actions.extend (agent (a_cb: EV_CHECK_BUTTON)
					do
						hide_location_with_no_change (a_cb.is_selected)
					end(hide_cb))

			hide_location_with_no_change_checkbox := hide_cb

--			bar.extend (create {EV_CELL})

		end

feature -- Access

	scm_service: SOURCE_CONTROL_MANAGEMENT_S

	development_window: EB_DEVELOPMENT_WINDOW

	check_all_repo_button,
	save_all_repo_button: EV_BUTTON

	include_unversioned_files_checkbox,
	hide_location_with_no_change_checkbox: detachable EV_CHECK_BUTTON


feature -- Basic operation

	set_workspace (ws: SCM_WORKSPACE)
		local
			g: like grid
		do
			workspace := ws
			g := grid
			if g /= Void and then attached g.parent as p then
				p.prune_all (g)
			end
			create g.make_with_workspace (Current, ws)
			g.drop_actions.extend (agent stone_dropped_on_grid)

			grid_cell.replace (g)
			grid := g

--			g.set_workspace (ws)
		end

	unversioned_files_included: BOOLEAN
		do
			if attached grid as g then
				Result := g.unversioned_files_included
			else
				Result := attached include_unversioned_files_checkbox as cb and then cb.is_selected
			end
		end

	include_unversioned_files (b: BOOLEAN)
		local
			c: like pointer_style
		do
			scm_service.config.set_show_unversioned_files (b)
			if
				attached include_unversioned_files_checkbox as cb and then
				cb.is_selected /= b
			then
				cb.select_actions.block
				if b then
					cb.enable_select
				else
					cb.disable_select
				end
				cb.select_actions.resume
			end
			if attached grid as g then
				c := pointer_style
				set_pointer_style ((create {EV_STOCK_PIXMAPS}).busy_cursor)
				g.include_unversioned_files (b)
				set_pointer_style (c)
			end
		end

	location_with_no_change_hidden: BOOLEAN
		do
			if attached grid as g then
				Result := g.location_with_no_change_hidden
			else
				Result := attached hide_location_with_no_change_checkbox as cb and then cb.is_selected
			end
		end

	hide_location_with_no_change (b: BOOLEAN)
		local
			c: like pointer_style
		do
			scm_service.config.set_hide_location_with_no_change (b)
			if
				attached hide_location_with_no_change_checkbox as cb and then
				cb.is_selected /= b
			then
				cb.select_actions.block
				if b then
					cb.enable_select
				else
					cb.disable_select
				end
				cb.select_actions.resume
			end
			if attached grid as g then
				c := pointer_style
				set_pointer_style ((create {EV_STOCK_PIXMAPS}).busy_cursor)
				g.hide_location_with_no_change (b)
				set_pointer_style (c)
			end
		end

	stone_dropped_on_grid (a_pebble: STONE)
		local
			p: PATH
		do
			if attached active_changelist as ch then
				if attached {FILED_STONE} a_pebble as l_filed_stone then
					create p.make_from_string (l_filed_stone.file_name)
					if attached scm_service.scm_root_location (p) as l_root then
						if
							attached scm_service.statuses (l_root, p) as l_statuses and then
							attached l_statuses.status (p) as st
						then
							ch.extend_status (l_root, st)
							scm_service.on_changelist_updated (ch)
						end
					end
				end
			end
		end

	update_statuses (loc: detachable SCM_LOCATION)
		do
			scm_service.on_update_statuses_enter
			if attached grid as g then
				g.update_statuses (loc)
			end
			scm_service.on_update_statuses_leave
		end

	update_status (a_status: SCM_STATUS)
		do
			if attached grid as g then
				g.update_status (a_status)
			end
		end

	reset
		do
			if attached grid as g then
				g.reset
			end
		end

	open_save_changelist_dialog (a_changelist: SCM_CHANGELIST_COLLECTION)
		local
			l_save_dialog: SCM_SAVE_DIALOG
		do
			create l_save_dialog.make_with_changelist (scm_service, a_changelist, Current)
			if attached development_window as devwin then
				l_save_dialog.set_size (devwin.dpi_scaler.scaled_size (800).min (devwin.window.width), devwin.dpi_scaler.scaled_size (600).min (devwin.window.height))
			end
			last_scm_dialog := l_save_dialog
			l_save_dialog.set_is_modal (False)
			l_save_dialog.show_on_active_window
			l_save_dialog.close_actions.extend (agent (i_save_dialog: SCM_SAVE_DIALOG; i_changelist: SCM_CHANGELIST_COLLECTION)
				do
					if
						attached i_save_dialog.commit as l_commit
					then
						if l_commit.is_processed then
							if attached {SCM_SINGLE_COMMIT_SET} l_commit as l_single then
								update_statuses (l_single.changelist.root)
							elseif attached {SCM_MULTI_COMMIT_SET} l_commit as l_multi then
								across
									l_multi.changelists as ic
								loop
									update_statuses (ic.item.root)
								end
							end
							i_changelist.wipe_out
						else
							i_changelist.set_description (l_commit.message)
						end
					end
					on_changelist_updated (i_changelist)
					i_save_dialog.destroy
				end(l_save_dialog, a_changelist)
				)
		end

	open_save_dialog (a_commit: SCM_COMMIT_SET)
		local
			l_save_dialog: SCM_SAVE_DIALOG
		do
			create l_save_dialog.make (scm_service, a_commit, Current)
			if attached development_window as devwin then
				l_save_dialog.set_size (devwin.dpi_scaler.scaled_size (800).min (devwin.window.width), devwin.dpi_scaler.scaled_size (600).min (devwin.window.height))
			end
			l_save_dialog.set_is_modal (False)
			last_scm_dialog := l_save_dialog
			l_save_dialog.show_on_active_window
			if a_commit.is_processed then
				if attached {SCM_SINGLE_COMMIT_SET} a_commit as l_single then
					update_statuses (l_single.changelist.root)
				elseif attached {SCM_MULTI_COMMIT_SET} a_commit as l_multi then
					across
						l_multi.changelists as ic
					loop
						update_statuses (ic.item.root)
					end
				end
			end
		end

	open_git_push_dialog (a_git_loc: SCM_GIT_LOCATION)
		local
			l_dlg: SCM_PUSH_DIALOG
		do
			create l_dlg.make (scm_service, a_git_loc, Current)
			if attached development_window as devwin then
				l_dlg.set_size (devwin.dpi_scaler.scaled_size (800).min (devwin.window.width), devwin.dpi_scaler.scaled_size (600).min (devwin.window.height))
			end
			l_dlg.set_is_modal (False)
			last_scm_dialog := l_dlg
			l_dlg.show_on_active_window
			update_statuses (a_git_loc)
		end

	open_git_pull_dialog (a_git_loc: SCM_GIT_LOCATION)
		local
			l_dlg: SCM_PULL_DIALOG
		do
			create l_dlg.make (scm_service, a_git_loc, Current)
			if attached development_window as devwin then
				l_dlg.set_size (devwin.dpi_scaler.scaled_size (800).min (devwin.window.width), devwin.dpi_scaler.scaled_size (600).min (devwin.window.height))
			end
			l_dlg.set_is_modal (False)
			last_scm_dialog := l_dlg
			l_dlg.show_on_active_window
			update_statuses (a_git_loc)
		end

	open_git_rebase_dialog (a_git_loc: SCM_GIT_LOCATION)
		local
			l_dlg: SCM_REBASE_DIALOG
		do
			create l_dlg.make (scm_service, a_git_loc, Current)
			if attached development_window as devwin then
				l_dlg.set_size (devwin.dpi_scaler.scaled_size (800).min (devwin.window.width), devwin.dpi_scaler.scaled_size (600).min (devwin.window.height))
			end
			l_dlg.set_is_modal (False)
			last_scm_dialog := l_dlg
			l_dlg.show_on_active_window
			update_statuses (a_git_loc)
		end

	save_location (loc: SCM_LOCATION)
		local
			l_commit: SCM_SINGLE_COMMIT_SET
		do
			if attached grid.changes_for (loc) as l_changelist then
				create l_commit.make_with_changelist (Void, l_changelist)
				open_save_dialog (l_commit)
				if l_commit.is_processed then
					if not l_commit.has_error then
						l_changelist.wipe_out
					end
				end
			end
		end

	git_push_location (a_git_loc: SCM_GIT_LOCATION)
		do
			open_git_push_dialog (a_git_loc)
		end

	git_pull_location (a_git_loc: SCM_GIT_LOCATION)
		do
			open_git_pull_dialog (a_git_loc)
		end

	git_rebase_location (a_git_loc: SCM_GIT_LOCATION)
		do
			open_git_rebase_dialog (a_git_loc)
		end

	on_save
		do
			if attached active_changelist as lst then
				lst.remove_empty_changelists
				open_save_changelist_dialog (lst)
			end
		end

	on_configuration_updated
		do
			across
				grid.scm_rows as ic
			loop
				ic.item.update
			end
		end

	on_statuses_updated (a_root: SCM_LOCATION; a_location: PATH; a_statuses: detachable SCM_STATUS_LIST)
		do
			if attached grid as g then
				g.on_statuses_updated (a_root, a_location, a_statuses)
			end
		end

	show_diff (a_diff: SCM_DIFF)
		local
			d: SCM_DIFF_DIALOG
		do
			create d.make (scm_service, a_diff)
			d.set_is_modal (False)
			if attached development_window as devwin then
				d.set_size (devwin.dpi_scaler.scaled_size (700).min (devwin.window.width), devwin.dpi_scaler.scaled_size (500).min (devwin.window.height))
			end
			d.set_is_modal (False)
			last_scm_dialog := d
			d.show_on_active_window
		end

	show_status_diff (a_root: detachable SCM_LOCATION; a_status: SCM_STATUS)
		local
			l_root: SCM_LOCATION
			ch_list: SCM_CHANGELIST
			l_ext_cmd: READABLE_STRING_GENERAL
		do
			l_root := a_root
			if l_root = Void then
				l_root := scm_service.scm_root_location (a_status.location)
			end
			if l_root /= Void then
				if
					attached {SCM_GIT_LOCATION} l_root and then
					scm_service.config.use_external_git_diff_command
				then
					l_ext_cmd := scm_service.config.external_git_diff_command (a_status.location)
				elseif
					attached {SCM_SVN_LOCATION} l_root and then
					scm_service.config.use_external_svn_diff_command
				then
					l_ext_cmd := scm_service.config.external_svn_diff_command (a_status.location)
				else
					l_ext_cmd := Void
				end
				if l_ext_cmd /= Void then
					execution_environment.launch (l_ext_cmd)
				else
					create ch_list.make_with_location (l_root)
					ch_list.extend_status (a_status)
					if attached scm_service.diff (ch_list) as diff then
						show_diff (diff)
					end
				end
			end
		end

	show_location_diff (a_root: detachable SCM_LOCATION; a_location: PATH)
		local
			l_root: SCM_LOCATION
			ch_list: SCM_CHANGELIST
			l_ext_cmd: READABLE_STRING_GENERAL
		do
			l_root := a_root
			if l_root = Void then
				l_root := scm_service.scm_root_location (a_location)
			end
			if l_root /= Void then
				if
					attached {SCM_GIT_LOCATION} l_root and then
					scm_service.config.use_external_git_diff_command
				then
					l_ext_cmd := scm_service.config.external_git_diff_command (a_location)
				elseif
					attached {SCM_SVN_LOCATION} l_root and then
					scm_service.config.use_external_svn_diff_command
				then
					l_ext_cmd := scm_service.config.external_svn_diff_command (a_location)
				else
					l_ext_cmd := Void
				end
				if l_ext_cmd /= Void then
					execution_environment.launch (l_ext_cmd)
				else
					create ch_list.make_with_location (l_root)
					ch_list.extend_status (create {SCM_STATUS_UNKNOWN}.make (a_location))
					if attached scm_service.diff (ch_list) as diff then
						show_diff (diff)
					end
				end
			end
		end

	show_revert_operation (a_root: detachable SCM_LOCATION; a_status: SCM_STATUS)
		local
			l_root: SCM_LOCATION
			ch_list: SCM_CHANGELIST
		do
			l_root := a_root
			if l_root = Void then
				l_root := scm_service.scm_root_location (a_status.location)
			end
			if l_root /= Void then
				create ch_list.make_with_location (l_root)
				ch_list.extend_status (a_status)
				if attached scm_service.revert (ch_list) as l_output then
					show_command_execution ("Revert", l_output)
					update_status (a_status)
				end
			end
		end

	show_add_operation (a_root: detachable SCM_LOCATION; a_status: SCM_STATUS)
		local
			l_root: SCM_LOCATION
			ch_list: SCM_CHANGELIST
		do
			l_root := a_root
			if l_root = Void then
				l_root := scm_service.scm_root_location (a_status.location)
			end
			if l_root /= Void then
				create ch_list.make_with_location (l_root)
				ch_list.extend_status (a_status)
				if attached scm_service.add (ch_list) as l_output then
					show_command_execution ("Add", l_output)
					update_status (a_status)
				end
			end
		end

	show_delete_operation (a_root: detachable SCM_LOCATION; a_status: SCM_STATUS)
		local
			l_root: SCM_LOCATION
			ch_list: SCM_CHANGELIST
		do
			l_root := a_root
			if l_root = Void then
				l_root := scm_service.scm_root_location (a_status.location)
			end
			if l_root /= Void then
				create ch_list.make_with_location (l_root)
				ch_list.extend_status (a_status)
				if attached scm_service.delete (ch_list) as l_output then
					show_command_execution ("Delete", l_output)
					update_status (a_status)
				end
			end
		end

	show_update_operation (a_root: detachable SCM_LOCATION; a_status: SCM_STATUS)
		local
			l_root: SCM_LOCATION
			ch_list: SCM_CHANGELIST
		do
			l_root := a_root
			if l_root = Void then
				l_root := scm_service.scm_root_location (a_status.location)
			end
			if l_root /= Void then
				create ch_list.make_with_location (l_root)
				ch_list.extend_status (a_status)
				if attached scm_service.update (ch_list) as l_output then
					show_command_execution ("Update", l_output)
				end
			end
		end

	show_command_execution (a_op: READABLE_STRING_GENERAL; a_output: READABLE_STRING_GENERAL)
		local
			d: SCM_COMMAND_EXECUTION_DIALOG
		do
			create d.make (scm_service, a_op, a_output)
			d.set_is_modal (False)
			last_scm_dialog := d
			if attached development_window as devwin then
				d.set_size (devwin.dpi_scaler.scaled_size (700).min (devwin.window.width), devwin.dpi_scaler.scaled_size (500).min (devwin.window.height))
			end
			d.show_on_active_window
		end

	last_scm_dialog: detachable ES_DIALOG
			-- keep reference on last scm dialog (push, pull, save, ...)

feature -- Access

	workspace: detachable SCM_WORKSPACE

	grid_cell: EV_CELL

	grid: detachable SCM_STATUS_GRID

feature -- Changelist

	changelists: STRING_TABLE [SCM_CHANGELIST_COLLECTION]
		do
			Result := scm_service.changelists
		end

	changelist_combo: detachable EV_COMBO_BOX

	active_changelist_name: detachable IMMUTABLE_STRING_32

	on_clear_active_changelist
		local
			lst: like active_changelist
		do
			lst := active_changelist
			if lst /= Void then
				lst.wipe_out
				if changelists.count > 1 then
					changelists.remove (lst.name)
				end
				active_changelist_name := Void
				on_changelist_combo_changed
			end
		end

	active_changelist: detachable SCM_CHANGELIST_COLLECTION
		do
			if attached active_changelist_name as n then
				Result := changelists [n]
			elseif
				attached changelist_combo as l_combo and then
				attached {READABLE_STRING_GENERAL} l_combo.selected_item.data as l_name
			then
				Result := changelists [l_name]
			elseif not changelists.is_empty then
				changelists.start
				Result := changelists.item_for_iteration
			end
		end

	on_changelist_combo_changed
		local
			l_new: SCM_CHANGELIST_COLLECTION
			l_coll_name: READABLE_STRING_GENERAL
			s: STRING_32
			i: INTEGER
		do
			if attached changelist_combo as l_combo then
				if
					attached l_combo.selected_item as l_selection and then
					attached {READABLE_STRING_GENERAL} l_selection.data as l_name
				then
					l_coll_name := l_name
				else
					l_coll_name := l_combo.text
				end
				if l_coll_name /= Void then
					i := l_coll_name.index_of ('(', 1)
					if i > 0 then
						s := l_coll_name.head (i - 1)
						s.right_adjust
						l_coll_name := s
					end
					if not changelists.has (l_coll_name) then
						create l_new.make (l_coll_name, 10)
						changelists [l_new.name] := l_new
					end
					if attached changelists [l_coll_name] as sel then
						on_changelist_selected (sel)
					end
				end
				update_changelist_combo (l_combo)
			end
		end

	on_changelist_updated (a_collection: SCM_CHANGELIST_COLLECTION)
		do
			if attached changelist_combo as l_combo then
				update_changelist_combo (l_combo)
				if active_changelist = a_collection then
					if attached grid as g then
						g.apply_changelist_collection (a_collection)
					end
				end
			end
		end

	on_changelist_selected (a_collection: SCM_CHANGELIST_COLLECTION)
			-- Update grid with changelist from `a_collection`
			-- update the grid even if `a_collection` was already the active one.
		do
			active_changelist_name := a_collection.name
			if attached grid as g then
				g.apply_changelist_collection (a_collection)
			end
		end

	update_changelist_combo (a_combo: EV_COMBO_BOX)
		local
			li: EV_LIST_ITEM
			fn: READABLE_STRING_GENERAL
		do
			a_combo.return_actions.block
			a_combo.wipe_out
			across
				changelists as ic
			loop
				if fn = Void then
					fn := ic.item.name
				end
				create li.make_with_text (ic.item.name + {STRING_32} " (" + ic.item.count.out.to_string_32 + {STRING_32} ")")
				li.set_data (ic.item.name)
				a_combo.extend (li)
				if attached active_changelist_name as sel then
					if sel.same_string (ic.item.name) then
						li.enable_select
					end
				elseif a_combo.count = 1 then
					li.enable_select
				end
				li.select_actions.extend (agent on_changelist_selected (ic.item))
				li.set_tooltip (ic.item.count.out + " item(s)")
			end
			if active_changelist_name = Void then
				active_changelist_name := fn
			end
			a_combo.return_actions.resume
		end

invariant
note
	copyright: "Copyright (c) 1984-2022, Eiffel Software"
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
