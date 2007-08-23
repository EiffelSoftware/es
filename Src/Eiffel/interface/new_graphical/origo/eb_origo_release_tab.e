indexing
	description: "Objects that represent an Origo release notebook page"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_RELEASE_TAB

	inherit
		EV_VERTICAL_BOX
			export {NONE}
				default_create
			end

		EB_DIALOG_CONSTANTS
			export {NONE}
				all
			undefine
				copy, is_equal, default_create
			end

create
	make

feature -- Initialisation

	make (a_window: like parent_window) is
			-- create all widgets
		require
			a_window_not_void: a_window /= Void
		do
			parent_window := a_window

			default_create
			initialise
		end


feature -- Access

	release_list: EV_LIST
		-- list to display selected files

feature -- Basic operations

	refresh_release_list is
			-- get the file list from the ftp server and refresh content of `release_list'
		local
			l_file_list: DS_LINKED_LIST [STRING]
			l_list_item: EV_LIST_ITEM
			l_index: INTEGER
			l_warning_dialog: EB_WARNING_DIALOG
		do
			parent_window.state_label.set_text ("Refreshing FTP file list...")
			parent_window.state_label.refresh_now

			l_file_list := parent_window.origo_client.ftp_file_list (parent_window.username, parent_window.password)
			l_file_list.set_equality_tester (create {KL_STRING_EQUALITY_TESTER})

				-- remove all files from `release_list' which are not in the new ftp file list
			from
				release_list.finish
			until
				release_list.before
			loop
					-- if the item has no data (and hence it is a platform seperator) or it is in the received file list keep it
				if release_list.item.data /= Void and then not l_file_list.has (release_list.item.text) then
					release_list.remove
				end
				release_list.back
			end

				-- go one after the end of the files with no platform
			l_index := parent_window.index_of_list_item_with_text (release_list, "", 1)
				-- go after the list if no empty line was found
			if l_index = 0 then
				release_list.finish
				release_list.forth
			else
				release_list.go_i_th (l_index)
			end

			if l_file_list = Void then
				create l_warning_dialog.make_with_text (parent_window.origo_client.last_error)
				l_warning_dialog.show_modal_to_window (parent_window)
				parent_window.state_label.set_text ("An error occurred")
				parent_window.state_label.refresh_now
			else
				from
					l_file_list.start
				until
					l_file_list.after
				loop
						-- check if the file is already in the list
					if parent_window.list_item_with_text (release_list, l_file_list.item_for_iteration, 1) = Void then
						create l_list_item.make_with_text (l_file_list.item_for_iteration)
						release_list.put_left (l_list_item)
						l_list_item.set_data (t_no_platform)
					end


					l_file_list.forth
				end

				parent_window.state_label.set_text ("")
				parent_window.state_label.refresh_now
			end
		end

feature {NONE} -- Implementation

	initialise is
			-- create and add all widgets
		local
			l_label: EV_LABEL
			l_hbox: EV_HORIZONTAL_BOX
			l_button: EV_BUTTON
			l_list_item: EV_LIST_ITEM
		do

			parent_window.add_padding_cell (Current, small_padding)

				-- top label
			create l_label.make_with_text (t_top_label)
			l_label.align_text_left
			extend (l_label)
			disable_item_expand (l_label)

			parent_window.add_padding_cell (Current, small_padding)

				-- `release_list'
			create release_list
			release_list.enable_multiple_selection
			release_list.select_actions.force (agent release_list_selection_changed)
			extend (release_list)

				-- add items to `release_list'
			release_list.force (create {EV_LIST_ITEM}.make_with_text (t_no_platform))
			release_list.force (create {EV_LIST_ITEM}.make_with_text (t_separator))

			parent_window.add_padding_cell (Current, small_padding)

				-- horizontal box
			create l_hbox
			extend (l_hbox)
			disable_item_expand (l_hbox)

				-- delete button
			create l_button.make_with_text_and_action ("Delete", agent delete_button_clicked)
			l_hbox.extend (l_button)
			l_hbox.disable_item_expand (l_button)

			parent_window.add_padding_cell (l_hbox, small_padding)

				-- release button
			create l_button.make_with_text_and_action ("Release", agent release_button_clicked)
			l_hbox.extend (l_button)
			l_hbox.disable_item_expand (l_button)

			parent_window.add_padding_cell (l_hbox, small_padding)

				-- `platform_list'
			create platform_list
			platform_list.align_text_left
			platform_list.disable_edit
			platform_list.select_actions.force (agent platform_selection_changed)
			create l_list_item.make_with_text (t_no_platform)
			platform_list.extend (l_list_item)
			l_list_item.enable_select
			l_hbox.extend (platform_list)


			parent_window.add_padding_cell (l_hbox, small_padding)

				-- platform button
			create l_button.make_with_text_and_action ("Add platform", agent platform_button_clicked)
			l_hbox.extend (l_button)
			l_hbox.disable_item_expand (l_button)

			parent_window.add_padding_cell (Current, small_padding)
		end

	delete_button_clicked is
			-- event handler for a click on delete button
		local
			l_message: STRING
			l_confirm_dialog: EB_CONFIRMATION_DIALOG
			l_info_dialog: EB_INFORMATION_DIALOG
			l_selected_items: DYNAMIC_LIST [EV_LIST_ITEM]
			l_warning_dialog: EB_WARNING_DIALOG
		do
				-- confirm deletion
			l_message := "Do you really want to delete following files?%N"
			from
				l_selected_items := release_list.selected_items
				l_selected_items.start
			until
				l_selected_items.after
			loop
				l_message.append (l_selected_items.item.text)
				l_message.append ("%N")
				l_selected_items.forth
			end

			if l_selected_items.count = 0 then
				create l_info_dialog.make_with_text ("You have to select the files you want to delete")
				l_info_dialog.show_modal_to_window (parent_window)
			else
				create l_confirm_dialog.make_with_text (l_message)
				l_confirm_dialog.show_modal_to_window (parent_window)
			end

				-- delete selected files
			if l_selected_items.count > 0 and l_confirm_dialog.is_ok_selected then
				from
					l_selected_items.start
				until
					l_selected_items.after
				loop
						-- update state label
					l_message := "Deleting "
					l_message.append (l_selected_items.item.text)
					parent_window.state_label.set_text (l_message)
					parent_window.state_label.refresh_now

						-- delete file
					parent_window.origo_client.ftp_delete (parent_window.username,
															parent_window.password,
															l_selected_items.item.text)

					if not parent_window.origo_client.last_error.is_empty then
						create l_warning_dialog.make_with_text (parent_window.origo_client.last_error)
						l_warning_dialog.show_modal_to_window (parent_window)
					end

						-- remove item from `release_list'
					release_list.prune (l_selected_items.item)

					l_selected_items.forth
				end

					-- refresh file list				
				refresh_release_list
			end
		end

	release_button_clicked is
			-- event handler for a click on release button
		local
			l_dialog: EB_ORIGO_RELEASE_DIALOG
			l_warning_dialog: EB_WARNING_DIALOG
			l_platform: STRING
			l_current_platform: STRING
			l_unused_files: STRING
			l_message: STRING
			l_confirm_dialog: EB_CONFIRMATION_DIALOG
			l_platform_has_files: BOOLEAN
			l_has_unused_files: BOOLEAN
			l_file_list: DS_LINKED_LIST [TUPLE [filename: STRING; platform: STRING]]
			l_file: TUPLE [filename: STRING; platform: STRING]
			l_project_id: INTEGER

		do
			create l_dialog.make
			if parent_window.project_list.selected_item.text.is_equal (interface_names.t_no_origo_project) then
				create l_warning_dialog.make_with_text ("You have to select an Origo project")
				l_warning_dialog.show_modal_to_window (parent_window)
			else
				l_dialog.show_modal_to_window (parent_window)
			end

			if l_dialog.closed_with_ok then
					-- go through the unused files

				l_message := "Do you really want to build this release?%N%N"
				l_message.append ("Origo project name: ")
				l_message.append (parent_window.project_list.selected_item.text.out)
				l_message.append ("%NRelease name: ")
				l_message.append (l_dialog.name)
				l_message.append ("%NVersion: ")
				l_message.append (l_dialog.version)
				l_message.append ("%NDescription:%N")
				l_message.append (l_dialog.description)
				l_message.append ("%N")

				from
					l_unused_files := ""
					release_list.start -- group header
					release_list.forth -- group separator
					release_list.forth -- first file

				until
					release_list.after or release_list.item.data = Void
				loop
					l_has_unused_files := True
					l_unused_files.append ("%T")
					l_unused_files.append (release_list.item.text.out)
					l_unused_files.append ("%N")
					release_list.forth
				end

					-- go thourgh the used files
				create l_file_list.make
				from

				until
					release_list.after
				loop
					-- we are at an empty line
					release_list.forth -- now we are at a group header
					l_platform := release_list.item.text.out
					l_current_platform := release_list.item.text.out
					l_platform.append (" files:%N")
					release_list.forth -- now we are at the seperator line
					release_list.forth -- and now at the first file

					l_platform_has_files := False
					from

					until
						release_list.after or release_list.item.data = Void
					loop
						l_platform.append ("%T")
						l_platform.append (release_list.item.text.out)
						l_platform.append ("%N")

						create l_file
						l_file.filename := release_list.item.text.out
						l_file.platform := l_current_platform.out
						l_file_list.force_last (l_file)

						l_platform_has_files := True
						release_list.forth
					end

					if l_platform_has_files then
						l_message.append ("%N")
						l_message.append (l_platform)
					end
				end

				if l_has_unused_files then
					l_message.append ("%NFiles which are not used for this release:%N")
					l_message.append (l_unused_files)
				end



					-- check if files were selected to release and show a confirmation dialog or a warning dialog
				if not l_file_list.is_empty then
					create l_confirm_dialog.make_with_text (l_message)
					l_confirm_dialog.show_modal_to_window (parent_window)
				else
					create l_warning_dialog.make_with_text ("You have to associate at least one file with a platform")
					l_warning_dialog.show_modal_to_window (parent_window)
				end

					-- call the release api
				if l_confirm_dialog /= Void and then l_confirm_dialog.is_ok_selected then
					l_project_id := parent_window.project_list.selected_item.data.out.to_integer
					parent_window.state_label.set_text ("Building release...")
					parent_window.state_label.refresh_now
					parent_window.origo_client.release (parent_window.session, l_project_id, l_dialog, l_file_list)
					refresh_release_list
				end
			end
		end

	platform_button_clicked is
			-- event handler for a click on platform button
		local
			l_dialog: EB_INPUT_DIALOG
			l_list_item: EV_LIST_ITEM
		do
			create l_dialog.make_with_text ("Please enter a platform")
			l_dialog.show_modal_to_window (parent_window)

			if
				l_dialog.is_ok_selected and
				not l_dialog.input.is_equal ("") and
				parent_window.list_item_with_text (platform_list, l_dialog.input, 1) = Void -- this platform isn't already in the list
			then
					-- add platfrom to `platform_list'
				create l_list_item.make_with_text (l_dialog.input)
				platform_list.force (l_list_item)

					-- add the "group"

					-- empty line
				create l_list_item.make_with_text ("")
				release_list.force (l_list_item)

					-- name
				create l_list_item.make_with_text (l_dialog.input)
				release_list.force (l_list_item)

					-- separator
				create l_list_item.make_with_text (t_separator)
				release_list.force (l_list_item)
			end

		end

	platform_selection_changed is
			-- event handler for a selection on `platform_list'
		local
			l_list_item: EV_LIST_ITEM
			l_items: DYNAMIC_LIST [EV_LIST_ITEM]
			l_platform: STRING
			i: INTEGER
			l_index: INTEGER
			l_item_platform: STRING
		do

			l_platform ?=  platform_list.selected_item.text.out
			if l_platform /= Void and not is_ignoring_selection_change then
				l_list_item := parent_window.list_item_with_text (platform_list, l_platform, 1)
				check
					l_list_item_not_void: l_list_item /= Void
				end

					-- because the user could have a file with the same name as the platform
					-- you have to search the correct one
				from
					i := 1
				until
					l_list_item.data = Void
				loop
					i := i + 1
					l_list_item := parent_window.list_item_with_text (platform_list, l_platform, i)
					check
						l_list_item_not_void: l_list_item /= Void
					end
				end

					-- move the cursor to the group title item
				l_index := parent_window.index_of_list_item_with_text (release_list, l_list_item.text.out, i)
				if l_index /= 0 then
					release_list.go_i_th (l_index)
				else
						-- move cursor to after if the item was not found (which happens when the dialog is opened)
					release_list.finish
					release_list.forth
				end


					-- move the cursor to the next empty line or to the end
				from
				until
					release_list.after or release_list.item.text.is_empty
				loop
					release_list.forth
				end

					-- get the selected items and loop through them
				l_items := release_list.selected_items
				from
					l_items.start
				until
					l_items.after
				loop
					l_item_platform ?= l_items.item.data
					check
						l_item_platform_not_void: l_item_platform /= Void
					end

						-- only handle the ones which aren't already in the correct group
					if not l_item_platform.is_equal (l_platform) then
							-- remove the item
						release_list.prune (l_items.item)

							-- add it before the current position
						l_items.item.set_data (l_platform)
						release_list.put_left (l_items.item)
						l_items.item.enable_select
					end

					l_items.forth
				end

			end
		end

	release_list_selection_changed is
			-- event handler for a selection on `release_list'
		local
			l_items: DYNAMIC_LIST [EV_LIST_ITEM]
			l_platform: STRING
			l_item: EV_LIST_ITEM
		do
			if not is_ignoring_selection_change then
				is_ignoring_selection_change := True

					-- deselect all items which don't have data (which are the platform displayers)
				from
					l_items := release_list.selected_items
					l_items.start
				until
					l_items.after
				loop
					if l_items.item.data = Void then
						l_items.item.disable_select
					end
					l_items.forth
				end


				if release_list.selected_item /= Void then
					l_platform ?= release_list.selected_item.data
				end

				if l_platform /= Void then
					l_item := parent_window.list_item_with_text (platform_list, l_platform, 1)
					check
						l_item_not_void: l_item /= Void
					end
					l_item.enable_select
				end

				is_ignoring_selection_change := False
			end
		ensure
			is_ignoring_selection_change_not_changed: is_ignoring_selection_change = old is_ignoring_selection_change
		end

feature {NONE} -- Implementation



feature {NONE} -- Implementation

		-- strings
	t_top_label: STRING is "Files on FTP Server"
	t_no_platform: STRING is "No platform specified"
	t_separator: STRING is "---------------------------------"

		-- widgets
	platform_list: EV_COMBO_BOX

		-- misc
	parent_window: EB_ORIGO_DIALOG
	is_ignoring_selection_change: BOOLEAN
		-- states whether selection changes in `release_list' and `platform_list' should be ignored

invariant
	parent_not_void: parent_window /= Void
	platform_list_not_void: platform_list /= Void
end
