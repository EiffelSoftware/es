indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_WORKITEM_DETAIL_DIALOG

inherit
	EB_DIALOG

	EB_DIALOG_CONSTANTS
		export {NONE}
			all
		undefine
			copy, default_create
		end

create
	make

feature -- Initialization

	make (a_label_text: STRING; a_text_field_text: STRING) is
			-- creation feature
		require
			a_label_text_not_void: a_label_text /= Void
			a_text_field_text_not_void: a_text_field_text /= Void
		do
			default_create

			set_title (interface_names.t_origo_workitem_details)
			set_icon_pixmap (Pixmaps.bm_origo)

			label_text := a_label_text.out
			text_field_text := a_text_field_text.out

			add_widgets
		ensure
			label_text_set: label_text.is_equal (a_label_text)
			text_field_text_set: text_field_text.is_equal (a_text_field_text)
		end

feature {NONE} -- Implementation

	add_widgets is
			-- add all widgets
		local
			l_cell: EV_CELL
			l_text_field: EV_TEXT
			l_label: EV_LABEL
			l_vbox: EV_VERTICAL_BOX
			l_hbox: EV_HORIZONTAL_BOX
			l_cancel_button: EV_BUTTON
		do
			create l_vbox

			-- padding cell
			create l_cell
			l_cell.set_minimum_height (layout_constants.default_padding_size)
			l_vbox.extend (l_cell)
			l_vbox.disable_item_expand (l_cell)

			-- label
			create l_label.make_with_text (label_text)
			l_label.align_text_left
			l_vbox.extend (l_label)
			l_vbox.disable_item_expand (l_label)

			-- padding cell
			create l_cell
			l_cell.set_minimum_height (layout_constants.tiny_padding_size)
			l_vbox.extend (l_cell)
			l_vbox.disable_item_expand (l_cell)

			-- text field
			create l_text_field.make_with_text (text_field_text)
			l_text_field.disable_word_wrapping
			l_text_field.disable_edit
			l_text_field.set_minimum_size (500, 300)
			l_vbox.extend (l_text_field)

			-- padding cell
			create l_cell
			l_cell.set_minimum_height (layout_constants.default_padding_size)
			l_vbox.extend (l_cell)
			l_vbox.disable_item_expand (l_cell)

			-- horizontal box for horizontal padding
			create l_hbox
			extend (l_hbox)

			-- padding cell
			create l_cell
			l_cell.set_minimum_width (layout_constants.default_padding_size)
			l_hbox.extend (l_cell)
			l_hbox.disable_item_expand (l_cell)

			-- vertical box
			l_hbox.extend (l_vbox)

			-- padding cell
			create l_cell
			l_cell.set_minimum_width (layout_constants.default_padding_size)
			l_hbox.extend (l_cell)
			l_hbox.disable_item_expand (l_cell)

			-- add the cancel button (hide it, so that you only have the x in the top right corner)
			create l_cancel_button.make_with_text_and_action ("Cancel", agent destroy)
			l_vbox.extend (l_cancel_button)
			l_cancel_button.hide
			set_default_cancel_button (l_cancel_button)
		end


feature {NONE} -- Implementation

	label_text: STRING
		-- label text

	text_field_text: STRING
		-- text field text

invariant
	label_text_not_void: label_text /= Void
	text_field_text_not_void: text_field_text /= Void
end
