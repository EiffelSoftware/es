indexing
	description: "Dialog to enter information about an Origo dialog"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_RELEASE_DIALOG

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
			l_label: EV_LABEL
		do
			default_create

			set_title (interface_names.t_origo_release)
			set_icon_pixmap (Pixmaps.bm_origo)

			create l_vbox
			add_padding_cell (l_vbox, layout_constants.default_padding_size)

				-- name label
			create l_label.make_with_text (t_name)
			l_label.align_text_left
			l_vbox.extend (l_label)
			l_vbox.disable_item_expand (l_label)

				-- padding cell
			add_padding_cell (l_vbox, tiny_padding)

				-- name field
			create name_field
			l_vbox.extend (name_field)
			l_vbox.disable_item_expand (name_field)

				-- padding cell
			add_padding_cell (l_vbox, layout_constants.default_padding_size)

				-- version label
			create l_label.make_with_text (t_version)
			l_label.align_text_left
			l_vbox.extend (l_label)
			l_vbox.disable_item_expand (l_label)

				-- padding cell
			add_padding_cell (l_vbox, tiny_padding)

				-- version field
			create version_field
			l_vbox.extend (version_field)
			l_vbox.disable_item_expand (version_field)

				-- padding cell
			add_padding_cell (l_vbox, layout_constants.default_padding_size)

				-- description label
			create l_label.make_with_text (t_description)
			l_label.align_text_left
			l_vbox.extend (l_label)

				-- padding cell
			add_padding_cell (l_vbox, tiny_padding)

				-- description text
			create description_text
			description_text.set_minimum_size (270, 100)
			l_vbox.extend (description_text)

				-- padding cell
			add_padding_cell (l_vbox, layout_constants.default_padding_size)

				-- buttons
			create l_ok_button.make_with_text_and_action (Interface_names.b_Ok, agent ok_button_clicked)
			Layout_constants.set_default_width_for_button (l_ok_button)
			create l_cancel_button.make_with_text_and_action (Interface_names.b_cancel, agent destroy)
			Layout_constants.set_default_width_for_button (l_cancel_button)

				-- button box
			create l_button_box
			l_vbox.extend (l_button_box)
			l_vbox.disable_item_expand (l_button_box)
				-- cell
			l_button_box.extend (create {EV_CELL})
				-- ok button
			l_button_box.extend (l_ok_button)
			l_button_box.disable_item_expand (l_ok_button)
				-- padding cell
			add_padding_cell (l_button_box, layout_constants.Default_padding_size)
				-- cancel button
			l_button_box.extend (l_cancel_button)
			l_button_box.disable_item_expand (l_cancel_button)
				-- cell
			l_button_box.extend (create {EV_CELL})

			-- bottom padding cell
			add_padding_cell (l_vbox, layout_constants.Default_padding_size)

				-- horizontal padding box
			create l_hbox
			add_padding_cell (l_hbox, layout_constants.default_padding_size)
			l_hbox.extend (l_vbox)
			add_padding_cell (l_hbox, layout_constants.default_padding_size)

			extend (l_hbox)

			set_default_cancel_button (l_cancel_button)
		end

feature -- Access

	name: STRING
	version: STRING
	description: STRING
	closed_with_ok: BOOLEAN

feature {NONE} -- Implementation

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

	ok_button_clicked is
			-- handle click on the ok button
		local
			l_info: EB_INFORMATION_DIALOG
		do
				-- remove all blank spaces at the beginning an the end of all inputs
			name_field.text.prune_all_leading (' ')
			name_field.text.prune_all_trailing (' ')
			version_field.text.prune_all_leading (' ')
			version_field.text.prune_all_trailing (' ')
			description_text.text.prune_all_leading (' ')
			description_text.text.prune_all_trailing (' ')

				-- check if everything was filled out
			if
				name_field.text.is_empty or
				version_field.text.is_empty or
				description_text.text.is_empty
			then
				create l_info.make_with_text ("All fields must contain a text.")
				l_info.show_modal_to_window (Current)

			elseif
				name_field.text.has ('"') or
				version_field.text.has ('"') or
				description_text.text.has ('"')
			then
				create l_info.make_with_text ("There are no %" allowed in any of the texts here.")
				l_info.show_modal_to_window (Current)
			else
				closed_with_ok := True
				name := name_field.text.out
				version := version_field.text.out
				description := description_text.text.out
				destroy
			end
		ensure
			name_set: closed_with_ok implies (name /= Void and name.is_equal (name_field.text))
			version_set: closed_with_ok implies (version /= Void and version.is_equal (version_field.text))
			description_set: closed_with_ok implies (description /= Void and description.is_equal (description_text.text))
		end


feature {NONE} -- Implementation

		-- widgets
	name_field: EV_TEXT_FIELD
	version_field: EV_TEXT_FIELD
	description_text: EV_TEXT


		-- strings
	t_name: STRING is "Name"
	t_version: STRING is "Version"
	t_description: STRING is "Description"


invariant
	name_field_not_void: name /= Void
	version_field_not_void: version /= Void
	description_text_not_void: description /= Void
end

