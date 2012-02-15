note
	description:
		"EiffelVision2 Toolbar button,%
		%a specific button that goes in a tool-bar."
	author: "Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_TOOL_BAR_BUTTON_IMP

inherit
	EV_TOOL_BAR_BUTTON_I
		redefine
			interface
		end

	EV_ITEM_IMP
		undefine
			update_for_pick_and_drop
		redefine
			interface,
			make,
			set_pixmap,
			cocoa_view,
			parent_imp
		end

	EV_DOCKABLE_SOURCE_IMP
		redefine
			interface
		end

	EV_SENSITIVE_IMP
		redefine
			interface
		end

	EV_TEXTABLE_IMP
		redefine
			interface,
			set_text
		end

	EV_NS_VIEW
		redefine
			interface,
			cocoa_view
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization of button box and events.
		do
			set_vertical_button_style
			create button.make
			button.set_translates_autoresizing_mask_into_constraints_ (False)
			-- NSRegularSquareBezelStyle = 2
			button.set_bezel_style_ (2)
			-- NSImageAbove = 5
			button.set_image_position_ (5)
			cocoa_view := button
			pixmapable_imp_initialize
--			button.set_action (agent select_actions.call ([]))
			set_is_initialized (True)
		end

feature -- Status Report

	has_vertical_button_style: BOOLEAN
			-- Is the `pixmap' displayed vertically above `text' for
			-- all buttons contained in `Current'? If `False', then
			-- the `pixmap' is displayed to left of `text'.

	is_vertical: BOOLEAN
			-- Are the buttons in `Current' arranged vertically?
		do
			if attached {EV_TOOL_BAR_IMP} parent as tool_bar_imp then
				Result := tool_bar_imp.is_vertical
			end
		end

	has_text: BOOLEAN
			-- Does the button have a text?
		do
			Result := not text.is_empty
		end

	has_pixmap: BOOLEAN
			-- Does the button have a pixmap?
		do
			Result := (pixmap /= Void)
		end

feature -- Access

	gray_pixmap: detachable EV_PIXMAP
			-- Image displayed on `Current'.

feature -- Element change

	disable_sensitive_internal
		do
			disable_sensitive
			button.set_enabled_ (False)
		end


	enable_sensitive_internal
		do
			enable_sensitive
			button.set_enabled_ (True)
		end

	set_text (a_text: READABLE_STRING_GENERAL)
			-- Assign `a_text' to `text'.
		do
			Precursor {EV_TEXTABLE_IMP} (a_text)
			button.set_title_ (create {NS_STRING}.make_with_eiffel_string (a_text.as_string_8))
			set_minsize
		end

	set_pixmap (a_pixmap: EV_PIXMAP)
			-- Assign `a_pixmap' to `pixmap'.
		local
			pixmap_imp: detachable EV_PIXMAP_IMP
		do
			-- First load the pixmap into the button
			pixmap_imp ?= a_pixmap.implementation
			check pixmap_imp /= void end
			button.set_image_ (pixmap_imp.image)
			set_minsize
		end

	set_gray_pixmap (a_gray_pixmap: EV_PIXMAP)
			-- Assign `a_gray_pixmap' to `gray_pixmap'.
		do
			set_pixmap (a_gray_pixmap)
		end

	remove_gray_pixmap
			-- Make `pixmap' `Void'.
		do
			remove_pixmap
		end

	set_vertical_button_style
			-- If vertical button style is set, then text is placed below the pixmap (as opposed to 'to the right of')
		do
		end

	disable_vertical_button_style
			-- If vertical button style is disabled, then text is placed to the right of the pixmap (as opposed to 'below')
		do
		end

feature -- Resizing

	set_minimum_width (a_minimum_width: INTEGER_32)
		do
			-- Do nothing. Tool bar buttons cannot be resized
		end

	set_minimum_height (a_minimum_height: INTEGER_32)
		do
			-- Do nothing. Tool bar buttons cannot be resized
		end

feature {EV_TOOL_BAR_IMP} -- Implementation

	call_select_actions
			-- Call the select_actions for `Current'
		do
		end

	in_select_actions_call: BOOLEAN
		-- Is `Current' in the process of having its select actions called

feature {EV_ANY_I} -- Implementation

	create_select_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Create a select action sequence.
		do
			create Result
		end

	create_drop_down_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- 	Create a drop down action sequence.
		do
			create Result
		end

feature {NONE} -- Implementation

	is_show_requested: BOOLEAN = True

	is_displayed: BOOLEAN = True

	parent_imp: detachable EV_TOOL_BAR_IMP

	set_minsize
		local
			size: NS_SIZE
		do
			if text.is_equal ("") then
				-- NSImageOnly = 1
				button.set_image_position_ (1)
			else
				-- NSImageAbove = 5
				button.set_image_position_ (5)
			end
			if attached {NS_CELL} button.cell as l_cell then
				size := l_cell.cell_size
				-- NSTodo: resize button?
--				set_minimum_size (size.width.rounded, size.height.rounded)
			end
		end

feature -- Implementation

	button: NS_BUTTON;

	cocoa_view: NS_VIEW;

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_TOOL_BAR_BUTTON note option: stable attribute end;

end -- class EV_TOOL_BAR_BUTTON_IMP
