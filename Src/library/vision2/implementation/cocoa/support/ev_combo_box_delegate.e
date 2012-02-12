note
	description: "Summary description for {EV_COMBO_BOX_DELEGATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_COMBO_BOX_DELEGATE

inherit
	EV_TEXT_FIELD_DELEGATE
		redefine
			make
		end

	NS_COMBO_BOX_DELEGATE_PROTOCOL
		undefine
			combo_box_selection_did_change_
		end

feature {NONE} -- Initialization

	make
		do
			add_objc_callback ("comboBoxSelectionDidChange:", agent combo_box_selection_did_change_)
			Precursor
		end

end
