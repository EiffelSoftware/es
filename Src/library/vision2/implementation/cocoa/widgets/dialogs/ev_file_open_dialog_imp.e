note
	description: "Eiffel Vision file open dialog. Cocoa implementation."
	author:	"Daniel Furrer"

class
	EV_FILE_OPEN_DIALOG_IMP

inherit
	EV_FILE_OPEN_DIALOG_I
		redefine
			interface
		end

	EV_FILE_DIALOG_IMP
		undefine
			internal_accept
		redefine
			make,
			interface,
			show_modal_to_window
		end

	NATIVE_STRING_HANDLER

create
	make

feature {NONE} -- Initialization

	make
		do
			create open_panel.make
			save_panel := open_panel
			window_item := open_panel.item
			Precursor {EV_FILE_DIALOG_IMP}
			--set_title ("Open")
		end

	show_modal_to_window (a_window: EV_WINDOW)
			-- Note: OS X does not present a list with file types to select from. The files displayed are any of those in the filter
		local
			button: INTEGER
			l_file_types: NS_MUTABLE_ARRAY
		do
			create l_file_types.make
			from
				filters.start
			until
				filters.after
			loop
					-- cut off the beginning "*." part
				l_file_types.add_object_ (create {NS_STRING}.make_with_eiffel_string (filters.item.filter.substring (3, filters.item.filter.count).as_string_8))
				filters.forth
			end
			open_panel.set_allowed_file_types_ (l_file_types)

			button := open_panel.run_modal.to_integer_32

			if button =  {NS_PANEL}.ok_button then
				set_full_file_path (open_panel.path)
				selected_button := internal_accept
				attached_interface.open_actions.call (Void)
				-- NSCancelButton = 0
			elseif button = 0 then
				set_full_file_path (create {PATH}.make_empty)
				selected_button := ev_cancel
				attached_interface.cancel_actions.call (Void)
			end
		end

feature {NONE} -- Access

	multiple_selection_enabled: BOOLEAN
		-- Is dialog enabled to select multiple files.
		do
			Result := open_panel.allows_multiple_selection
		end

	file_names: ARRAYED_LIST [STRING_32]
			-- List of filenames selected by user
		obsolete
			"Use `file_paths' instead."
		local
			l_paths: like file_paths
		do
			l_paths := file_paths
			create Result.make (l_paths.count)
			from
				l_paths.start
			until
				l_paths.after
			loop
				Result.extend (l_paths.item.name)
				l_paths.forth
			end
		end

	file_paths: ARRAYED_LIST [PATH]
			-- List of filenames selected by user
		local
			l_filenames: NS_ARRAY [NS_STRING]
			l_item: detachable NS_STRING
			i: like ns_uinteger
		do
			create Result.make (1)
			l_filenames := open_panel.ur_ls
			create Result.make (l_filenames.count.to_integer_32)
			from i := 0
			until i > l_filenames.count
			loop
				l_item := l_filenames.item (i)
				check l_item /= Void end
				Result.extend (create {PATH}.make_from_pointer (l_item.item))
				i := i + 1
			end
		end

feature {NONE} -- Setting

	enable_multiple_selection
			-- Enable multiple file selection
		do
			open_panel.set_allows_multiple_selection_ (True)
		end

	disable_multiple_selection
			-- Disable multiple file selection
		do
			open_panel.set_allows_multiple_selection_ (False)
		end

feature {NONE} -- Implementation

	open_panel: NS_OPEN_PANEL

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_FILE_OPEN_DIALOG note option: stable attribute end;

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end -- class EV_FILE_OPEN_DIALOG_IMP
