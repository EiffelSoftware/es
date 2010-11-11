note
	description: "Input for Boogie verifier."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_VERIFIER_INPUT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize empty input.
		do
			create boogie_files.make
			boogie_files.compare_objects
			create custom_content.make
		end

feature -- Access

	boogie_files: attached LINKED_LIST [attached STRING]
			-- List of files to include when running Boogie.
			-- These files will be added before `custom_content' in the order
			-- they appear in the list.

	custom_content: attached LINKED_LIST [attached STRING]
			-- Custom content which will be included when running Boogie.

	boogie_file_name: detachable STRING
			-- File name for generated Boogie file.

feature -- Status report

	is_empty: BOOLEAN
			-- Is input empty?
		do
			Result := boogie_files.is_empty and custom_content.is_empty
		end

feature -- Element change

	add_boogie_file (a_file_name: attached STRING)
			-- Add `a_file_name' to `boogie_files'.
		require
			file_exists: (create {PLAIN_TEXT_FILE}.make (a_file_name)).exists
			file_readable: (create {PLAIN_TEXT_FILE}.make (a_file_name)).is_readable
		do
			if not boogie_files.has (a_file_name) then
				boogie_files.extend (a_file_name)
			end
		ensure
			file_added: boogie_files.has (a_file_name)
		end

	add_custom_content (a_string: attached STRING)
			-- Add `a_string' to `custom_content'.
		do
			custom_content.extend (a_string.twin)
		ensure
			custom_content.last.is_equal (a_string)
		end

	set_boogie_file_name (a_file_name: like boogie_file_name)
			-- Set `boogie_file_name' to `a_file_name'.
		require
			a_file_name_not_void: a_file_name /= Void
		do
			create boogie_file_name.make_from_string (a_file_name)
		ensure
			file_name_set: boogie_file_name ~ a_file_name
		end

feature -- Basic operations

	generate_boogie_file
			-- Generate a Boogie file containing all the input at `boogie_file_name'.
		require
			boogie_file_set: boogie_file_name /= Void
		local
			l_output_file: KL_TEXT_OUTPUT_FILE
			l_time: TIME
		do
			create l_output_file.make (boogie_file_name)
			l_output_file.recursive_open_write
			if l_output_file.is_open_write then
				append_header (l_output_file)
				from
					boogie_files.start
				until
					boogie_files.after
				loop
					append_file_content (l_output_file, boogie_files.item)
					boogie_files.forth
				end
				l_output_file.put_string ("// Custom content")
				l_output_file.put_new_line
				l_output_file.put_new_line
				from
					custom_content.start
				until
					custom_content.after
				loop
					l_output_file.put_string (custom_content.item)
					custom_content.forth
				end
				l_output_file.close
			else
					-- TODO: error handling
				check False end
			end
		end

feature -- Removal

	wipe_out
			-- Remove all input.
		do
			boogie_files.wipe_out
			custom_content.wipe_out
		end

feature {NONE} -- Implementation

	append_header (a_file: KL_TEXT_OUTPUT_FILE)
			-- Append header to `a_file'.
		require
			writable: a_file.is_open_write
		local
			l_date_time: DATE_TIME
		do
			create l_date_time.make_now
			a_file.put_string ("// Automatically generated (")
			a_file.put_string (l_date_time.out)
			a_file.put_string (")%N%N")
		end

	append_file_content (a_file: KL_TEXT_OUTPUT_FILE; a_file_name: STRING)
			-- Append content of `a_file_name' to `a_file'.
		require
			writable: a_file.is_open_write
		local
			l_input_file: KL_TEXT_INPUT_FILE
		do
			create l_input_file.make (a_file_name)
			l_input_file.open_read
			if l_input_file.is_open_read then
				l_input_file.read_string (l_input_file.count)
				a_file.put_string ("// File: ")
				a_file.put_string (a_file_name)
				a_file.put_new_line
				a_file.put_new_line
				a_file.put_string (l_input_file.last_string)
				a_file.put_new_line
			else
				a_file.put_string ("// Error: unable to open file ")
				a_file.put_string (a_file_name)
				a_file.put_new_line
				a_file.put_new_line
			end
		end

end
