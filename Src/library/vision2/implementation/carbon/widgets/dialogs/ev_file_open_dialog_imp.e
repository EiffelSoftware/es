indexing
	description: "Eiffel Vision file open dialog. Carbon implementation."


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
			interface,
			initialize,
			file_name
		end

create
	make

feature {NONE} -- Initialization

	initialize is
		do
			Precursor
			set_title ("Open")
		end

feature {NONE} -- Access

	multiple_selection_enabled: BOOLEAN
		-- Is dialog enabled to select multiple files.

	file_name: STRING_32 is
			-- Retrieve file name selected by user.
		do
		end

	file_names: ARRAYED_LIST [STRING_32] is
			-- List of filenames selected by user
		do
		end

feature {NONE} -- Setting

	enable_multiple_selection is
			-- Enable multiple file selection
		do
		end

	disable_multiple_selection is
			-- Disable multiple file selection
		do
		end

feature {NONE} -- Implementation

	file_chooser_action: INTEGER is
			-- Action constant of the file chooser, ie: to open or save files, etc.
		do
		end

	interface: EV_FILE_OPEN_DIALOG;

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
end -- class EV_FILE_OPEN_DIALOG_IMP

