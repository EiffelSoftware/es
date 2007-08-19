indexing
	description: "Origo main dialog"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_DIALOG

inherit
	EB_DIALOG

	EB_SHARED_PREFERENCES
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EB_DIALOG_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end

	SHARED_WORKBENCH
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	make

feature -- Initialization

	make is
		local
			l_cancel_button: EV_BUTTON
			l_ok_button: EV_BUTTON
			l_vbox: EV_VERTICAL_BOX
			l_hbox: EV_HORIZONTAL_BOX
			l_button_box: EV_HORIZONTAL_BOX
			l_project_name_label: EV_LABEL
			l_list_item: EV_LIST_ITEM
		do
			default_create

			set_title (interface_names.t_origo)
			set_icon_pixmap (pixmaps.bm_origo)

				-- buttons
			create l_ok_button.make_with_text_and_action (Interface_names.b_Ok, agent
															do
																destroy
															end)
			Layout_constants.set_default_width_for_button (l_ok_button)
			create l_cancel_button.make_with_text_and_action (Interface_names.b_cancel, agent destroy)
			Layout_constants.set_default_width_for_button (l_cancel_button)

				-- labels
			create l_project_name_label.make_with_text (t_project_name)
			l_project_name_label.align_text_left
			create state_label.make_with_text ("")
			state_label.align_text_left

				-- combobox
			create project_list
			project_list.align_text_left
			project_list.disable_edit
			create l_list_item.make_with_text (Interface_names.t_No_origo_project)
			l_list_item.set_data (-1)
			project_list.extend (l_list_item)

				-- notebook tabs
			create upload_tab.make (Current)
			create release_tab.make (Current)

				-- notebook
			create file_notebook
			file_notebook.set_minimum_size (notebook_width, notebook_height)
			file_notebook.extend (upload_tab)
			file_notebook.set_item_text (upload_tab, "Upload")
			file_notebook.extend (release_tab)
			file_notebook.set_item_text (release_tab, "Release")

				-- button box
			create l_button_box
			l_button_box.extend (l_ok_button)
			l_button_box.extend (create {EV_CELL})
			l_button_box.extend (l_cancel_button)

			l_button_box.disable_item_expand (l_ok_button)
			l_button_box.disable_item_expand (l_cancel_button)

				-- main box
			create l_vbox
			add_padding_cell (l_vbox, layout_constants.default_padding_size)
			l_vbox.extend (l_project_name_label)
			add_padding_cell (l_vbox, tiny_padding)
			l_vbox.extend (project_list)
			add_padding_cell (l_vbox, small_padding)
			l_vbox.extend (file_notebook)
			add_padding_cell (l_vbox, small_padding)
			l_vbox.extend (state_label)
			add_padding_cell (l_vbox, small_padding)
			l_vbox.extend (l_button_box)
			l_vbox.disable_item_expand (l_button_box)
			add_padding_cell (l_vbox, layout_constants.default_padding_size)

				-- horizontal padding box
			create l_hbox
			add_padding_cell (l_hbox, layout_constants.default_padding_size)
			l_hbox.extend (l_vbox)
			add_padding_cell (l_hbox, layout_constants.default_padding_size)

			extend (l_hbox)

			set_default_push_button (l_cancel_button)
			set_default_cancel_button (l_cancel_button)

			Current.show_actions.force (agent get_origo_data)

		end

feature {EB_ORIGO_UPLOAD_TAB, EB_ORIGO_RELEASE_TAB} -- Implementation

	add_padding_cell (a_box: EV_BOX; a_padding_size: INTEGER) is
			-- add a padding cell to box
		require
			a_box_not_void: a_box /= Void
			a_padding_size_positive: a_padding_size > 0
		local
			l_cell: EV_CELL
		do
			create l_cell
			l_cell.set_minimum_size (a_padding_size, a_padding_size)
			a_box.extend (l_cell)
			a_box.disable_item_expand (l_cell)
		end

	get_origo_data is
			-- get username, password and session form origo
		local
			l_warning_dialog: EB_WARNING_DIALOG
		do
			create origo_client.make (Current)

			state_label.set_text ("Logging in...")
			state_label.refresh_now
			session := origo_client.login

				-- login failed
			if session = Void then
				create l_warning_dialog.make_with_text (origo_client.last_error)

				-- login was successful
			else
				state_label.set_text ("Receiving username...")
				state_label.refresh_now
				username := origo_client.my_username (session)
				if username = Void then
					create l_warning_dialog.make_with_text (origo_client.last_error)
				end
			end

				-- username was received
			if username /= Void then
				state_label.set_text ("Receiving password...")
				state_label.refresh_now
				password := origo_client.my_password (session)
				if password = Void then
					create l_warning_dialog.make_with_text (origo_client.last_error)
				end
			end

			if password /= Void then
				release_tab.refresh_release_list
				refresh_project_list
			else
				l_warning_dialog.show_modal_to_window (Current)
				destroy
			end
		end

	refresh_project_list is
			-- refresh content of project list combo box
		local
			l_list_item: EV_LIST_ITEM
			l_projects: DS_LINKED_LIST [TUPLE[id: INTEGER; name: STRING; is_owned: BOOLEAN]]
			l_current_project_name: STRING
			l_warning_dialog: EB_WARNING_DIALOG
		do
			state_label.set_text ("Receiving project list...")
			state_label.refresh_now
			l_projects := origo_client.project_list_of_user (session, username)

				-- project list was received
			if l_projects /= Void then

				l_current_project_name := project_list.selected_item.text

				-- initalize project list
				project_list.wipe_out
				create l_list_item.make_with_text (Interface_names.t_no_origo_project)
				l_list_item.set_data (-1)
				project_list.force (l_list_item)

				-- fill project list
				from
					l_projects.start
				until
					l_projects.after
				loop
					if l_projects.item_for_iteration.is_owned then
						create l_list_item.make_with_text (l_projects.item_for_iteration.name)
						l_list_item.set_data (l_projects.item_for_iteration.id)
						project_list.force (l_list_item)
					end

					l_projects.forth
				end
				state_label.set_text ("")

				-- something went wrong
			else
				create l_warning_dialog.make_with_text (origo_client.last_error)
				l_warning_dialog.show_modal_to_window (Current)
				state_label.set_text ("An error ocurred")
			end
		end

	list_item_with_text (a_list: EV_LIST_ITEM_LIST; a_text: STRING; a_occurrence: INTEGER): EV_LIST_ITEM is
			-- returns `a_occurrence'th list item in `a_list' with text `a_text'
		require
			a_list_not_void: a_list /= Void
			a_text_not_void: a_text /= Void
			a_occurrence_positive: a_occurrence > 0
		local
			items_found: INTEGER
			i: INTEGER
		do
			from
				i := 1
			until
				i > a_list.count or items_found = a_occurrence
			loop
				if a_list[i].text.is_equal (a_text) then
					Result := a_list[i]
					items_found := items_found + 1
				end
				i := i + 1
			end
		end

	index_of_list_item_with_text (a_list: EV_LIST_ITEM_LIST; a_text: STRING; a_occurrence: INTEGER): INTEGER is
			-- returns index of `a_occurrence'th list item in `a_list' with text `a_text'
		require
			a_list_not_void: a_list /= Void
			a_text_not_void: a_text /= Void
			a_occurrence_positive: a_occurrence > 0
		local
			items_found: INTEGER
		do
			from
				Result := 1
			until
				Result > a_list.count or items_found = a_occurrence
			loop
				if a_list[Result].text.is_equal (a_text) then
					items_found := items_found + 1
				end
				Result := Result + 1
			end

				-- think about it, it's necessary (becaus it's increased even if the item was found)
			Result := Result - 1

			if items_found < a_occurrence then
				Result := 0
			end
		end

feature {EB_ORIGO_UPLOAD_TAB, EB_ORIGO_RELEASE_TAB} -- Implementation

		-- widgets
	state_label: EV_LABEL
	project_list: EV_COMBO_BOX
	file_notebook: EV_NOTEBOOK
	upload_tab: EB_ORIGO_UPLOAD_TAB
	release_tab: EB_ORIGO_RELEASE_TAB

		-- dialog size
	notebook_height: INTEGER is 350
	notebook_width: INTEGER is 350

		-- strings
	t_project_name: STRING is "Origo Project Name"

		-- other
	username: STRING
	password: STRING
	session: STRING
	origo_client: EB_ORIGO_API_CALLS

invariant
	state_label_not_void: state_label /= Void
	project_list_not_void: project_list /= Void
	file_notebook_not_void: file_notebook /= Void
	upload_tab_not_void: upload_tab /= Void
	release_tab_not_void: release_tab /= Void
	username_not_void: username /= Void
	password_not_void: password /= Void
	session_not_void: session /= Void
	origo_client_not_void: origo_client /= Void
end
