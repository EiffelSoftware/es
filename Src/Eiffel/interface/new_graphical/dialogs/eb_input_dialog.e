indexing
	description: "Objects that represent a dialog with a single textbox where the user can enter some input."
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_INPUT_DIALOG

inherit
	EB_DIALOG
	export {NONE}
		default_create
	end

	EB_DIALOG_CONSTANTS
	export {NONE}
		all
	undefine
		copy, default_create
	end

create
	make,
	make_with_text,
	make_with_text_and_default_value

feature -- Initialization

	make is
			-- create dialog
		do
			default_create
			create main_box
			initialize_dialog
		end

	make_with_text (a_text: STRING) is
			-- create dialog with a label
		require
			a_text_not_void: a_text /= Void
		local
			l_label: EV_LABEL
			l_cell: EV_CELL
		do
			default_create
			create main_box

			create l_label.make_with_text (a_text)
			l_label.align_text_left
			main_box.extend (l_label)
			main_box.disable_item_expand (l_label)

			create l_cell
			l_cell.set_minimum_height (small_padding)
			main_box.extend (l_cell)
			main_box.disable_item_expand (l_cell)

			initialize_dialog
		end

	make_with_text_and_default_value (a_text: STRING; a_value: STRING) is
			-- create dialog with a label and `a_value' as default value
		do
			if a_text /= Void then
				make_with_text (a_text)
			else
				make
			end

			text_field.set_text (a_value)
		end

feature -- Access

	input: STRING
		-- input entered into `text_field'

	is_ok_selected: BOOLEAN
		-- dialog was closed with pressing ok button

feature {NONE} -- Implementation

		-- widgets
	text_field: EV_TEXT_FIELD
	main_box: EV_VERTICAL_BOX

	initialize_dialog is
			-- adds all widgets needed for a base version of EB_INPUT_DIALOG
		require
			main_box_not_void: main_box /= Void
		local
			l_cell: EV_CELL
			l_cancel_button: EV_BUTTON
			l_ok_button: EV_BUTTON
			l_hbox: EV_HORIZONTAL_BOX
		do
			set_title ("Input")

				-- add top padding cell
			create l_cell
			l_cell.set_minimum_height (layout_constants.default_padding_size)
			main_box.put_front (l_cell)
			main_box.disable_item_expand (l_cell)

				-- add `text_field'
			create text_field
			main_box.extend (text_field)

				-- padding cell between buttons and `text_field'
			create l_cell
			l_cell.set_minimum_height (small_padding)
			main_box.extend (l_cell)
			main_box.disable_item_expand (l_cell)

				-- button box
			create l_hbox
			main_box.extend (l_hbox)
			main_box.disable_item_expand (l_hbox)

				-- cell
			create l_cell
			l_hbox.extend (l_cell)

				-- ok button
			create l_ok_button.make_with_text_and_action (interface_names.b_ok, agent
						do
							input := text_field.text.out
							is_ok_selected := True
							destroy
						end
					)
			layout_constants.set_default_size_for_button (l_ok_button)
			l_hbox.extend (l_ok_button)
			l_hbox.disable_item_expand (l_ok_button)

				-- padding cell between buttons
			create l_cell
			l_cell.set_minimum_width (layout_constants.default_padding_size)
			l_hbox.extend (l_cell)
			l_hbox.disable_item_expand (l_cell)

				-- cancel button
			create l_cancel_button.make_with_text_and_action (interface_names.b_cancel, agent destroy)
			layout_constants.set_default_size_for_button (l_cancel_button)
			l_hbox.extend (l_cancel_button)
			l_hbox.disable_item_expand (l_cancel_button)

				-- cell
			create l_cell
			l_hbox.extend (l_cell)

				-- bottom padding cell
			create l_cell
			l_cell.set_minimum_height (layout_constants.default_padding_size)
			main_box.extend (l_cell)
			main_box.disable_item_expand (l_cell)

				-- add left and right padding cells
			create l_hbox
			l_hbox.extend (main_box)
			extend (l_hbox)

				-- left padding cell
			create l_cell
			l_cell.set_minimum_width (layout_constants.default_padding_size)
			l_hbox.put_front (l_cell)
			l_hbox.disable_item_expand (l_cell)

				-- right padding cell
			create l_cell
			l_cell.set_minimum_width (layout_constants.default_padding_size)
			l_hbox.extend (l_cell)
			l_hbox.disable_item_expand (l_cell)

			set_default_push_button (l_ok_button)
			set_default_cancel_button (l_cancel_button)
		end

invariant
	main_box_not_void: main_box /= Void
	text_field_not_void: text_field /= Void
end
