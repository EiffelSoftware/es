note
	description:
		"Eiffel Vision button. Cocoa implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "press, push, label, pixmap"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_BUTTON_IMP

inherit
	EV_BUTTON_I
		redefine
			interface
		end

	EV_PRIMITIVE_IMP
		redefine
			interface,
			make,
			is_sensitive,
			is_height_resizable,
			enable_sensitive,
			disable_sensitive,
			dispose,
			set_background_color
		end

	EV_PIXMAPABLE_IMP
		redefine
			interface,
			make,
			set_pixmap
		end

	EV_TEXTABLE_IMP
		redefine
			interface,
			make,
			set_text,
			align_text_left,
			align_text_center,
			align_text_right
		end

	EV_FONTABLE_IMP
		redefine
			interface,
			make
		end

	EV_BUTTON_ACTION_SEQUENCES_IMP
		redefine
			interface
		end

	NS_BUTTON
		rename
			font as cocoa_font,
			alignment as cocoa_alignment,
			set_font_ as cocoa_set_font
		undefine
			is_equal,
			copy
		redefine
			make,
			dispose
		end

create
	make

feature {NONE} -- Initialization

	make
			-- `Precursor' initialization,
			-- create button box to hold label and pixmap.
		do
			cocoa_view := Current
			add_objc_callback ("did_press_button:", agent did_press_button)
			Precursor {NS_BUTTON}
			set_translates_autoresizing_mask_into_constraints_ (False)
			set_target_ (Current)
			set_action_ (create {OBJC_SELECTOR}.make_with_name ("did_press_button:"))
			Precursor {EV_PRIMITIVE_IMP}

				-- NSRoundedBezelStyle = 1
			set_bezel_style_ (1)
			align_text_center

			enable_tabable_to
			enable_tabable_from
			initialize_events
			pixmapable_imp_initialize

			set_title_ (create {NS_STRING}.make_with_eiffel_string(""))
		end

feature -- Access

	is_default_push_button: BOOLEAN
			-- Is this button currently a default push button
			-- for a particular container?
		do
			Result := attached top_level_window_imp as l_window and then
						attached l_window.default_button_cell as l_cell and then
							l_cell.item = cell.item
		end

feature -- Status Setting

	align_text_left
			-- <Precursor>
		do
			Precursor
				-- NSLeftTextAlignment = 0
			set_alignment_ (0)
		end

	align_text_center
			-- <Precursor>
		do
			Precursor
				-- NSCenterTextAlignment = 2
			set_alignment_ (2)
		end

	align_text_right
			-- <Precursor>
		do
			Precursor
				-- NSRightTextAlignment = 1
			set_alignment_ (1)
		end

	enable_default_push_button
			-- Set the style of the button corresponding
			-- to the default push button.
		do
			-- WARNING: this causes the application to crash.
--			set_key_equivalent_ (create {NS_STRING}.make_with_eiffel_string ("\r"))
--			window.enable_key_equivalent_for_default_button_cell
--			if attached {NS_BUTTON_CELL} cell as l_cell then
--				window.set_default_button_cell_ (l_cell)
--			end
		end

	disable_default_push_button
			-- Remove the style of the button corresponding
			-- to the default push button.
		do
			if attached top_level_window_imp as l_window then
				l_window.set_default_button_cell_ (Void)
			end
		end

	enable_can_default
		do
		end

	set_text (a_text: READABLE_STRING_GENERAL)
			-- <Precursor>
		do
			Precursor {EV_TEXTABLE_IMP} (a_text)
			set_title_ (create {NS_STRING}.make_with_eiffel_string (a_text.as_string_8))
		end

	set_background_color (a_color: EV_COLOR)
			-- <Precursor>
		do
			Precursor {EV_PRIMITIVE_IMP} (a_color)
			set_bordered_ (False)
			if attached {EV_COLOR_IMP} a_color.implementation as imp and attached {NS_BUTTON_CELL} cell as l_cell then
				l_cell.set_background_color_ (imp.color)
			end
		end

feature -- Sensitivity

	is_sensitive: BOOLEAN
			-- Is the object sensitive to user input.
		do
			Result := is_enabled
		end

	enable_sensitive
			-- Allow the object to be sensitive to user input.
		do
			set_enabled_ (True)
			set_needs_display_ (True)
		end

	disable_sensitive
			-- Set the object to ignore all user input.
		do
			set_enabled_ (False)
			set_needs_display_ (True)
		end

feature {NONE} -- implementation

	internal_set_pixmap (a_pixmap_imp: EV_PIXMAP_IMP; a_width, a_height: INTEGER)
			--
		do
		end

	internal_remove_pixmap
			-- Remove pixmap from Current
		do
		end

	did_press_button (sender: NS_BUTTON)
			-- Code to be executed when `click_me_button' is pressed.
		do
			select_actions.call ([])
		end

	set_pixmap (a_pixmap: EV_PIXMAP)
		do
			if attached {EV_PIXMAP_IMP} a_pixmap.implementation as pixmap_imp then
					-- NSRegularSquareBezelStyle = 2
				set_bezel_style_ (2)
					-- NSImageLeft = 2
				set_image_position_ (2)
				set_image_ (pixmap_imp.image)
			end
		end

feature {EV_ANY_I} -- Implementation

	is_height_resizable: BOOLEAN
			-- Is the height of the wrapped Cocoa widget resizable?
		do
			Result := False
		end

feature {EV_ANY, EV_ANY_I} -- implementation

	dispose
		do
			Precursor {NS_BUTTON}
			Precursor {EV_PRIMITIVE_IMP}
		end

	interface: detachable EV_BUTTON note option: stable attribute end;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

end -- class EV_BUTTON_IMP
