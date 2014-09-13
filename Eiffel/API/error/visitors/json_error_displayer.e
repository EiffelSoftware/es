note

	description:
		"Displays warnings and errors of compilation."
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision $"

class JSON_ERROR_DISPLAYER

inherit
	DEFAULT_ERROR_DISPLAYER
		redefine
			trace_warnings,
			trace_errors,
			trace
		end
	SHARED_ERROR_TRACER
		export
			{NONE} all
		end
create
	make_with_flag

feature -- initialization

	make_with_flag (ow: like output_window; flag_with_normal: BOOLEAN)
			-- Initialize current with `output_window' to `ow' and set `json_and_normal_output' flag
		do
			output_window := ow
			json_and_normal_output := flag_with_normal
		ensure
			set_window: ow = output_window
			set_flag: flag_with_normal = json_and_normal_output
		end


feature -- Flags

	json_and_normal_output: BOOLEAN
			-- set true if normal output and json output

	warning_and_error: BOOLEAN
			-- false if only warnings and compiled without errors

feature -- Output

	trace (handler: ERROR_HANDLER)
			-- <Precursor>
		do
				-- For batch compilers etc, we report the errors last to ensure they are shown on the terminal
				-- closes to the next operation.
			if handler.has_warning then
				-- flag set since errors included
				warning_and_error := True
				trace_warnings (handler)
				json_tracer.json.close_warning_section
			else
				json_tracer.json.no_warnings
			end
			if handler.has_error then
				json_tracer.json.prepare_error_section
				trace_errors (handler)
				json_tracer.json.close_final_section
			else
				json_tracer.json.no_errors
			end
			separation_line
			print(json_tracer.json.json_object)
		end

	trace_warnings (handler: ERROR_HANDLER)
			-- Display warnings messages from `handler'.
		local
			warning_list: LIST [ERROR];
			a_text_formatter: TEXT_FORMATTER
			l_cursor: CURSOR
			retried: INTEGER
		do
			if json_and_normal_output then
				Precursor {DEFAULT_ERROR_DISPLAYER} (handler)
			end
				a_text_formatter := output_window
				if retried = 0 then
					from
						warning_list := handler.warning_list
						l_cursor := warning_list.cursor
						warning_list.start
					until
						warning_list.after
					loop
						json_tracer.trace (warning_list.item, {ERROR_JSON_TRACER}.normal)
						json_tracer.json.prepare_next
						warning_list.forth;
					end;
					warning_list.go_to (l_cursor)
					if handler.error_list.is_empty then
							-- There is no error in the list
							-- put a separation before the next message
						display_separation_line (a_text_formatter)
					end;
				elseif retried = 1 then
					display_error_error (a_text_formatter)
				end
				if not warning_and_error then
					-- only warnings from compilation
					json_tracer.json.close_warning_section
					json_tracer.json.prepare_error_section
					json_tracer.json.no_errors
					print(json_tracer.json.json_object)
					print("%N")
				end

		rescue
			if not fail_on_rescue then
				retried := retried  + 1;
				retry;
			end;
		end;

	trace_errors (handler: ERROR_HANDLER)
			-- Display error messages from `handler'.
		local
			error_list: LIST [ERROR]
			a_text_formatter: TEXT_FORMATTER
			l_cursor: CURSOR
			retried: INTEGER
		do
			if json_and_normal_output then
				Precursor {DEFAULT_ERROR_DISPLAYER} (handler)
			end
				a_text_formatter := output_window
				if retried = 0 then
					from
						error_list := handler.error_list
						l_cursor := error_list.cursor
						error_list.start
					until
						error_list.after
					loop
						json_tracer.trace (error_list.item, {ERROR_JSON_TRACER}.normal)
						json_tracer.json.prepare_next
						error_list.forth
					end
					error_list.go_to (l_cursor)
					display_additional_info (a_text_formatter)
				elseif retried = 1 then
					display_error_error (a_text_formatter)
				end

		rescue
			if not fail_on_rescue then
				retried := retried + 1
				retry
			end
		end

feature {NONE}

	separation_line
		-- line for separating normal and json output
	do
		print("%N")
		print ("===========================================%
							%====================================");
		print("%N")
		print("%N")
	end

invariant

	non_void_output_window: output_window /= Void

note
	copyright:	"Copyright (c) 1984-2014, Eiffel Software"
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

end -- class JSON_ERROR_DISPLAYER
