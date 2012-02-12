note
	description: "Summary description for {EV_TEXT_FIELD_DELEGATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_TEXT_FIELD_DELEGATE

inherit
	NS_OBJECT
		redefine
			make
		end

	NS_TEXT_FIELD_DELEGATE_PROTOCOL

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			add_objc_callback ("controlTextDidChange", agent control_text_did_change_)
			Precursor {NS_OBJECT}
		end

feature -- Callbacks

	control_text_did_change_ (a_notification: NS_NOTIFICATION)
		do
			print ("Text changed%N")
		end

end
