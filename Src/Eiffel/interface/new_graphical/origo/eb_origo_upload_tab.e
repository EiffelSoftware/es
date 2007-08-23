indexing
	description: "Objects that represent an Origo upload notebook page"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_UPLOAD_TAB

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

	upload_list: EV_CHECKABLE_LIST
		-- checkable list which contains files to upload

feature {NONE} -- Implementation

	initialise is
			-- create and add all widgets
		local
			l_button_box: EV_HORIZONTAL_BOX
			l_button: EV_BUTTON
			l_cell: EV_CELL
		do

			parent_window.add_padding_cell (Current, small_padding)

			create upload_list
			extend (upload_list)

			parent_window.add_padding_cell (Current, small_padding)

				-- button box
			create l_button_box
			extend (l_button_box)
			disable_item_expand (l_button_box)

				-- open files button
			create l_button.make_with_text ("Open files")
			layout_constants.set_default_size_for_button (l_button)
			l_button_box.extend (l_button)
			l_button_box.disable_item_expand (l_button)
			l_button.select_actions.extend (agent open_files_button_clicked)

				-- upload button
			create l_button.make_with_text ("Upload")
			layout_constants.set_default_size_for_button (l_button)
			l_button_box.extend (l_button)
			l_button_box.disable_item_expand (l_button)
			l_button.select_actions.extend (agent upload_button_clicked)

				-- padding cell
			create l_cell
			l_button_box.extend (l_cell)

			parent_window.add_padding_cell (Current, small_padding)
		end

	open_files_button_clicked is
			-- handles a click on the open file button
		local
			l_file_dialog: EV_FILE_OPEN_DIALOG
			l_list_item: EV_LIST_ITEM
			l_file_list: ARRAYED_LIST [STRING_32]
		do
			create l_file_dialog.make_with_title ("Open files to upload")
			l_file_dialog.enable_multiple_selection
			l_file_dialog.show_modal_to_window (parent_window)

			from
				l_file_list := l_file_dialog.file_names
				l_file_list.start
			until
				l_file_list.after
			loop
				l_list_item := parent_window.list_item_with_text (upload_list, l_file_list.item, 1)
				if l_list_item = Void then
					create l_list_item.make_with_text (l_file_list.item)
					upload_list.force (l_list_item)
				end
				upload_list.check_item (l_list_item)
				l_file_list.forth
			end
		end

	upload_button_clicked is
			-- handles a click on the upload button
		local
			l_message: STRING
			l_confirm_dialog: EB_CONFIRMATION_DIALOG
			l_info_dialog: EB_INFORMATION_DIALOG
			l_checked_items: DYNAMIC_LIST [EV_LIST_ITEM]
		do
				-- confirm upload
			l_message := "Do you really want to upload following files?%N"
			from
				l_checked_items := upload_list.checked_items
				l_checked_items.start
			until
				l_checked_items.after
			loop
				l_message.append (l_checked_items.item.text)
				l_message.append ("%N")
				l_checked_items.forth
			end

			if l_checked_items.count = 0 then
				create l_info_dialog.make_with_text ("Please select some files to upload")
				l_info_dialog.show_modal_to_window (parent_window)
			else
				create l_confirm_dialog.make_with_text (l_message)
				l_confirm_dialog.show_modal_to_window (parent_window)
			end

				-- upload checked files
			if l_checked_items.count > 0 and l_confirm_dialog.is_ok_selected then
				from
					l_checked_items.start
				until
					l_checked_items.after
				loop
						-- update state label
					l_message := "Uploading "
					l_message.append (l_checked_items.item.text)
					parent_window.state_label.set_text (l_message)
					parent_window.state_label.refresh_now

						-- upload file
					parent_window.origo_client.ftp_upload (parent_window.username,
															parent_window.password,
															l_checked_items.item.text)

						-- remove item from `upload_list'
					upload_list.prune (l_checked_items.item)

					l_checked_items.forth
				end

					-- refresh file list				
				parent_window.release_tab.refresh_release_list

			end
		end

feature {NONE} -- Implementation

	parent_window: EB_ORIGO_DIALOG
		-- parent window

invariant
	parent_not_void: parent_window /= Void
	upload_list_not_void: upload_list /= Void
end
