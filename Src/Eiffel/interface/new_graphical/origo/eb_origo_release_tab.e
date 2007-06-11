indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_RELEASE_TAB

	inherit
		EV_VERTICAL_BOX
			export {NONE}
				default_create
			end

		EB_CONSTANTS
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


feature {NONE} -- Implementation

	initialise is
			-- create and add all widgets
		local
			l_label: EV_LABEL
		do
			create l_label.make_with_text ("Sorry, not implemented yet")
			extend (l_label)
		end

feature {NONE} -- Implementation

	parent_window: EB_ORIGO_DIALOG
		-- parent window

invariant
	parent_not_void: parent_window /= Void
end
