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
		do
			default_create
			set_size (dialog_width, dialog_height)
			set_title (interface_names.t_origo)
			disable_user_resize

				-- buttons
			create ok_button.make_with_text_and_action (Interface_names.b_Ok, agent destroy)
			Layout_constants.set_default_width_for_button (ok_button)
			create cancel_button.make_with_text_and_action (Interface_names.b_cancel, agent destroy)
			Layout_constants.set_default_width_for_button (cancel_button)

				-- labels
			create project_name_label.make_with_text (t_project_name)
			project_name_label.align_text_left
			create state_label.make_with_text (t_state)
			state_label.align_text_left

				-- combobox
			create project_list
			project_list.align_text_left
			project_list.disable_edit
			create list_item.make_with_text ("-- none --")
			project_list.extend (list_item)
			create list_item.make_with_text ("moo")
			project_list.extend (list_item)
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
			session: STRING
		do
			create l_origo_client.make (Current)
			session := l_origo_client.login
--			io.output.put_string (session)
--			io.output.new_line
--			io.output.put_string (preferences.origo_data.user_key)
--			io.output.new_line
--			io.output.put_string (preferences.origo_data.xml_rpc_client_path)
--			io.output.new_line
--			create l_list_item.make_with_text ("moo")
--			project_list.extend (l_list_item)
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
	t_state: STRING is "State"



end
