indexing
	description: "Eiffel Vision menu. Carbon implementation."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_MENU_IMP

inherit
	EV_MENU_I
		redefine
			interface
		end

	EV_MENU_ITEM_IMP
		undefine
			parent
		redefine
			interface,
			initialize,
			on_activate,
			destroy,
			show
		end

	EV_MENU_ITEM_LIST_IMP
		redefine
			interface,
			initialize,
			list_widget,
			destroy
		end

create
	make

feature {NONE} -- Initialization

	initialize is
		do

		end

feature -- Basic operations

	show is
			-- Pop up on the current pointer position.
		do
		end

	show_at (a_widget: EV_WIDGET; a_x, a_y: INTEGER) is
			-- Pop up on `a_x', `a_y' relative to the top-left corner
			-- of `a_widget'.
		do
		end

feature {NONE} -- Externals

feature {EV_ANY_I} -- Implementation

	on_activate is
		do
		end

	list_widget: POINTER

	interface: EV_MENU

feature {NONE} -- Implementation

	destroy is
			-- Destroy the menu
		do
		end

indexing
	copyright:	"Copyright (c) 2006, Eiffel.Mac Team"

end -- class EV_MENU_IMP

