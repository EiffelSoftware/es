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

	EB_CONSTANTS
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
			cancel_button: EV_BUTTON
			ok_button: EV_BUTTON
			vbox: EV_VERTICAL_BOX
			hbox: EV_HORIZONTAL_BOX
			button_box: EV_HORIZONTAL_BOX
			project_name_label: EV_LABEL
			list_item: EV_LIST_ITEM
			l_user_opts: USER_OPTIONS
		do
			default_create
			set_size (dialog_width, dialog_height)
			set_title (interface_names.t_origo)
			disable_user_resize

				-- buttons
			create ok_button.make_with_text_and_action (Interface_names.b_Ok, agent
															do
																save_data
																destroy
															end)
			Layout_constants.set_default_width_for_button (ok_button)
			create cancel_button.make_with_text_and_action (Interface_names.b_cancel, agent destroy)
			Layout_constants.set_default_width_for_button (cancel_button)

				-- labels
			create project_name_label.make_with_text (t_project_name)
			project_name_label.align_text_left
			create state_label.make_with_text ("")
			state_label.align_text_left

				-- combobox
			create project_list
			project_list.align_text_left
			project_list.disable_edit
			create list_item.make_with_text (Interface_names.t_No_origo_project)
			project_list.extend (list_item)
			l_user_opts := lace.user_options
			if not l_user_opts.origo_project_name.is_equal (interface_names.t_no_origo_project.to_string_8) then
				create list_item.make_with_text (l_user_opts.origo_project_name)
				project_list.extend (list_item)
				project_list.select_region (2, 2)
			end
			project_list.list_shown_actions.force (agent refresh_project_list)

				-- button box
			create button_box
			button_box.extend (ok_button)
			button_box.extend (create {EV_CELL})
			button_box.extend (cancel_button)

			button_box.disable_item_expand (ok_button)
			button_box.disable_item_expand (cancel_button)

				-- main box
			create vbox
			add_padding_cell (vbox)
			vbox.extend (project_name_label)
			vbox.extend (project_list)
			vbox.extend (state_label)
			vbox.extend (button_box)
			vbox.disable_item_expand (button_box)
			add_padding_cell (vbox)

				-- horizontal padding box
			create hbox
			add_padding_cell (hbox)
			hbox.extend (vbox)
			add_padding_cell (hbox)

			extend (hbox)

			set_default_push_button (cancel_button)
			set_default_cancel_button (cancel_button)
		end

feature {NONE} -- Implementation

	add_padding_cell (box: EV_BOX) is
			-- add a padding cell to box
		local
			cell: EV_CELL
		do
			create cell
			cell.set_minimum_size (padding, padding)
			box.extend (cell)
			box.disable_item_expand (cell)
		end

	refresh_project_list is
			-- refresh content of project list combo box
		local
			l_list_item: EV_LIST_ITEM
			l_preferences: EB_ORIGO_DATA
			l_origo_client: EB_ORIGO_API_CALLS
			l_session: STRING
			l_username: STRING
			l_project_names: DS_LINKED_LIST [STRING]
		do
			create l_origo_client.make (Current)
			state_label.set_text ("Logging in...")
			state_label.refresh_now
			l_session := l_origo_client.login

				-- login was successful
			if l_session /= Void then
				state_label.set_text ("Receiving username...")
				state_label.refresh_now
				l_username := l_origo_client.my_username (l_session)
			end

				-- username was received
			if l_username /= Void then
				state_label.set_text ("Receiving project list...")
				state_label.refresh_now
				l_project_names := l_origo_client.project_list_of_user (l_session, l_username)
			end

				-- project list was received
			if l_project_names /= Void then
				-- initalize project list
				project_list.wipe_out
				create l_list_item.make_with_text (Interface_names.t_no_origo_project)
				project_list.force (l_list_item)

				-- fill project list
				from
					l_project_names.start
				until
					l_project_names.after
				loop
					create l_list_item.make_with_text (l_project_names.item_for_iteration)
					project_list.force (l_list_item)
					l_project_names.forth
				end
				state_label.set_text ("")

				-- something went wrong
			else
				state_label.set_text ("An error ocurred")
			end
--			io.output.put_string (session)
--			io.output.new_line
--			io.output.put_string (preferences.origo_data.user_key)
--			io.output.new_line
--			io.output.put_string (preferences.origo_data.xml_rpc_client_path)
--			io.output.new_line
--			create l_list_item.make_with_text ("moo")
--			project_list.extend (l_list_item)
		end

	save_data is
			-- save selected project name
		local
			l_user_opts: USER_OPTIONS
			l_user_factory: USER_OPTIONS_FACTORY
		do
			l_user_opts := lace.user_options
			l_user_opts.set_origo_project_name (project_list.selected_item.text)
			create l_user_factory
			l_user_factory.store (lace.user_options)
		end



feature {NONE} -- Implementation

		-- widgets
	state_label: EV_LABEL
	project_list: EV_COMBO_BOX

		-- dialog size
	dialog_height: INTEGER is 132
	dialog_width: INTEGER is 190
	padding: INTEGER is 10

		-- strings
	t_project_name: STRING is "Origo Project Name"



end
