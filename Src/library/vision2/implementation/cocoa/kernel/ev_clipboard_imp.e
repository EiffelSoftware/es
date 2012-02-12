note
	description: "Objects that allow access to the operating system clipboard. Cocoa implementation"
	author: "Daniel Furrer."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_CLIPBOARD_IMP

inherit
	EV_CLIPBOARD_I

create
	make

feature {NONE}-- Initialization

	old_make (an_interface: like interface)
			-- Create `Current' with interface `an_interface'.
		do
			assign_interface (an_interface)
		end

	make
			-- initialize `Current'.
		do
			set_is_initialized (True)
			clipboard := (create {NS_PASTEBOARD_UTILS}).general_pasteboard
		ensure then
			clipboard_not_void: clipboard /= Void
		end

feature -- Access

	has_text: BOOLEAN
			-- Does the clipboard currently contain text?
		local
			l_classes: NS_MUTABLE_ARRAY
			l_string: NS_STRING
		do
			create l_string.make
			create l_classes.make
			l_classes.add_object_ (l_string.class_objc)
			if attached {NS_ARRAY} clipboard.read_objects_for_classes__options_ (l_classes, Void) as l_objects and then l_objects.count > 0 then
				if attached {NS_STRING} l_objects.object_at_index_ (0) as l_text then
					Result := text.is_equal (l_text.to_eiffel_string)
				end
			end
		end

	text: STRING_32
			-- `Result' is current clipboard content.
		do
			create Result.make_empty
		end

feature -- Status Setting

	set_text (a_text: READABLE_STRING_GENERAL)
			-- Assign `a_text' to clipboard.
		do
		end

feature {EV_ANY_I}

	destroy
			-- Destroy `Current'
		do
			set_is_destroyed (True)
		end

feature {NONE} -- Implementation

	clipboard: NS_PASTEBOARD

end -- class EV_CLIPBOARD_IMP
