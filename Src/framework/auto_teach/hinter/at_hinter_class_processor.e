note
	description: "Summary description for {AT_HINTER_CLASS_PROCESSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AT_HINTER_CLASS_PROCESSOR

create
	make

feature -- Interface

	process_class (a_class: attached CLASS_C; a_output_file: attached PLAIN_TEXT_FILE)
		require
			file_open_and_writable: a_output_file.is_writable
		do
			-- Proof of concept
			a_output_file.put_string (a_class.original_class.text_8)
		end

feature {NONE} -- Implementation

	make (a_options: attached AT_OPTIONS)
			-- Initialization
		do
			options := a_options
		end

	options: attached AT_OPTIONS

end
