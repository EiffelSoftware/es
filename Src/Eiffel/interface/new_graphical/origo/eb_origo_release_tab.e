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
		do
			parent_window.state_label.set_text ("Refreshing FTP file list...")
			parent_window.state_label.refresh_now

				-- remove all files from `release_list'
			from
				release_list.finish
			until
				release_list.before
			loop
					-- if the item has no data (and hence it is a platform seperator) keep it
				if release_list.item.data /= Void then
					release_list.remove
				end
				release_list.back
			end

			l_file_list := parent_window.origo_client.ftp_file_list (parent_window.username, parent_window.password)

			if l_file_list = Void then
				parent_window.state_label.set_text ("An error occurred")
				parent_window.state_label.refresh_now
			else
				from
					l_file_list.start
				until
					l_file_list.after
				loop
					create l_list_item.make_with_text (l_file_list.item_for_iteration)
					release_list.force (l_list_item)
					l_list_item.set_data (t_no_platform)
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
			l_dialog: EV_INFORMATION_DIALOG
		do
			create l_dialog.make_with_text ("Sorry, not implemented yet")
			l_dialog.show_modal_to_window (parent_window)
		end

	release_button_clicked is
			-- event handler for a click on release button
		local
			l_dialog: EV_INFORMATION_DIALOG
		do
			create l_dialog.make_with_text ("Sorry, not implemented yet")
			l_dialog.show_modal_to_window (parent_window)
		end

	platform_button_clicked is
			-- event handler for a click on platform button
		local
			l_dialog: EB_INPUT_DIALOG
			l_list_item: EV_LIST_ITEM
		do
			create l_dialog.make_with_text ("Please enter a platform")
			l_dialog.show_modal_to_window (parent_window)

			if l_dialog.input /= Void and not l_dialog.input.is_equal ("") then
				create l_list_item.make_with_text (l_dialog.input)
				platform_list.force (l_list_item)
			end

		end

	platform_selection_changed is
			-- event handler for a selection on `platform_list'
		do
		end

	release_list_selection_changed is
			-- event handler for a selection on `release_list'
		local
			l_items: DYNAMIC_LIST [EV_LIST_ITEM]
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
				is_ignoring_selection_change := False
			end
		ensure
			is_ignoring_selection_change_not_changed: is_ignoring_selection_change = old is_ignoring_selection_change
		end

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
