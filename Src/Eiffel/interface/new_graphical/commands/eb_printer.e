note
	description: "Objects capable of printing."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "Xavier Rousselot"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_PRINTER

inherit
	EIFFEL_LAYOUT
	
	EB_CONSTANTS

	ES_SHARED_PROMPT_PROVIDER
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do

		end

feature -- Status report

	text: STRING
			-- Text that will be printed next time.
			--| To print a file, just generate a TEXT_FORMATTER with one token for example...

	job_name: STRING_GENERAL
			-- Name for the print job.
			--| Optional, only used on Windows.

	context: EV_PRINT_CONTEXT
			-- Options used for the print job.

	window: EV_WINDOW
			-- Window to which dialogs will be relative.

	external_command: STRING
			-- Command line used to print a file.
			--| $target in it will be automatically replaced with the file name when printing.
			--| Necessary only for `print_via_command'.

feature -- Status setting

	set_text (stt: STRING)
			-- Set the text that should be printed next.
		do
			text := stt
		ensure
			text = stt
		end

	set_window (wnd: EV_WINDOW)
			-- Define the window to which dialogs will be relative.
		do
			window := wnd
		ensure
			window = wnd
		end

	set_print_context (pc: EV_PRINT_CONTEXT)
			-- Define the options used for the next print job.
		do
			context := pc
		ensure
			context = pc
		end

	set_job_name (nname: like job_name)
			-- Set the name of the next print job.
			--| Only used on Windows. Optional.
		do
			job_name := nname
		end

	set_external_command (cmd: STRING)
			-- Set the command that should be invoked to print files using an external editor.
		do
			external_command := cmd
		ensure
			command_set: (cmd = Void) = (external_command = Void)
			same_command: cmd /= Void implies cmd.is_equal (external_command)
		end

feature -- Basic operations

	print_text
			-- Launch an effective print job.
		require
			text_set: text /= Void
			options_set: context /= Void
			valid_options: context.output_to_file implies (context.file_path /= Void and then
						(create {RAW_FILE}.make_with_path (context.file_path)).is_creatable)
		local
			f: RAW_FILE
			retried: BOOLEAN
		do
			if not retried then
				if context.output_to_file then
					create f.make_with_path (context.file_path)
					f.create_read_write
					f.put_string (text)
					f.close
				else
					implementation.send_print_request
				end
			end
		rescue
			retried := True
			retry
		end

	ask_and_print
			-- Pop up an EV_PRINT_DIALOG to query the context and then print `text'.
			-- May be cancelled.
		require
			text_set: text /= Void
			window_set: window /= Void
		local
			dial: EV_PRINT_DIALOG
		do
			create dial
			dial.print_actions.extend (agent call_print_from (dial))
			dial.select_all_pages
			dial.disable_page_numbers
			dial.disable_selection

			dial.show_modal_to_window (window)
		end

	print_via_command
			-- Invoke an external command to print `text'.
		require
			cmd_set: external_command /= Void and then not external_command.is_empty
			valid_text_set: text /= Void
		local
			cmd: STRING_32
			sent_txt: STRING
			file: PLAIN_TEXT_FILE
			retried: BOOLEAN
			t: EV_TIMEOUT
		do
			if not retried then
				sent_txt := text
				sent_txt.prune_all ('%R')
				sent_txt.replace_substring_all ("%N", "%R%N")
					-- Generate the file we put the text in.
				create file.make_open_temporary_with_prefix (eiffel_layout.temporary_path.extended ("eb_printer-").name)
				file.put_string (sent_txt)
				file.close
					-- Generate the actual command line.
				create cmd.make_from_string_general (external_command)
				cmd.replace_substring_all ({STRING_32} "$target", file.path.name)
					-- Send the command.
				(create {EXECUTION_ENVIRONMENT}).launch (cmd)
					-- Delete the temporary file.
					--| FIXME XR: It is too soon, the external command didn't have time to load the file!
				create t.make_with_interval (10_000)
				t.actions.extend_kamikaze (agent (f: FILE; i_t: EV_TIMEOUT)
						do
							f.delete
							i_t.set_interval (0)
							i_t.destroy
						end(file, t)
					)
			end
		rescue
			retried := True
			retry
		end

feature {NONE} -- Implementation: graphical interface

	implementation: EB_PRINTER_IMP
			-- Object used to send print requests.
		do
			if internal_implementation = Void then
				create internal_implementation.make (Current)
			end
			Result := internal_implementation
		end

	internal_implementation: EB_PRINTER_IMP
			-- Once per object implementation.

	call_print_from (d: EV_PRINT_DIALOG)
			-- Initialize `Current's parameters with the values in `d' and call `print_text'.
		require
			valid_print_dialog: d /= Void -- and not d.is_destroyed to query it?
			text_set: text /= Void
			window_set: window /= Void
		local
			fn: PATH
			f: FILE
		do
			context := d.print_context
			fn := context.file_path
			if context.output_to_file then
				if fn = Void then
					prompts.show_error_prompt (Warning_messages.w_Cannot_create_file (""), window, Void)
				else
					create {RAW_FILE} f.make_with_path (fn)
					if f.exists or not f.is_creatable then
						prompts.show_error_prompt (Warning_messages.w_Cannot_create_file (fn.name), window, Void)
					else
						print_text
					end
				end
			else
				print_text
			end
		end

note
	copyright:	"Copyright (c) 1984-2023, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end -- class EB_PRINTER
