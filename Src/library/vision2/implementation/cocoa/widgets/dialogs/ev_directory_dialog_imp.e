note
	description: "Eiffel Vision directory dialog."
	author: "Daniel Furrer <daniel.furrer@gmail.com>"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_DIRECTORY_DIALOG_IMP

inherit
	EV_DIRECTORY_DIALOG_I
		redefine
			interface
		select
			copy
		end

	EV_STANDARD_DIALOG_IMP
		undefine
			wrapper_objc_class_name
		redefine
			interface,
			make,
			dispose,
			show_modal_to_window
		end

	NS_OPEN_PANEL
		rename
			item as cocoa_panel_ptr,
			copy as cocoa_copy_panel,
			title as cocoa_title,
			set_background_color_ as cocoa_set_background_color,
			background_color as cocoa_background_color,
			screen as cocoa_screen,
			set_title_ as cocoa_set_title
		undefine
			is_equal
		redefine
			make,
			dispose
		select
			cocoa_panel_ptr,
			cocoa_screen
--			make_panel_window
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Setup action sequences.
		do
			Precursor {NS_OPEN_PANEL}
			set_can_choose_directories_ (True)
			set_can_create_directories_ (True)
			set_can_choose_files_ (False)
			set_prompt_ (create {NS_STRING}.make_with_eiffel_string ("Choose"))
		end

feature -- Access

	directory: STRING_32
			-- Path of the current selected directory
		do
			if selected_button.is_equal (internal_accept) then
				Result := url.path.to_eiffel_string
			else
				create Result.make_empty
			end
		end

	start_directory: STRING_32
			-- Base directory where browsing will start.

feature -- Element change

	set_start_directory (a_path: READABLE_STRING_GENERAL)
			-- Make `a_path' the base directory.
		local
			l_url: NS_URL
		do
			start_directory := a_path.as_string_32.twin
			create l_url.make_file_url_with_path__is_directory_ (create {NS_STRING}.make_with_eiffel_string (a_path.as_string_8), True)
			set_directory_ur_l_ (l_url)
		end

feature {NONE} -- Implementation

	show_modal_to_window (a_window: EV_WINDOW)
			-- Show the
		local
			button: INTEGER
		do
			check attached {EV_WINDOW_IMP} a_window.implementation as l_window then
				button := run_modal.to_integer_32
					-- NSOKButton = 1
				if button =  1 then
					selected_button := internal_accept
					ok_actions.call ([])
					-- NSCancelButton = 0
				elseif button = 0 then
					selected_button := ev_cancel
					cancel_actions.call ([])
				end
			end
		end

	dispose
		do
			Precursor {EV_STANDARD_DIALOG_IMP}
			Precursor {NS_OPEN_PANEL}
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: EV_DIRECTORY_DIALOG;

end -- class EV_DIRECTORY_DIALOG_IMP
