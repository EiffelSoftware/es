note
	description: "Summary description for {EPA_EXCEPTION_TRACE_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_EXCEPTION_TRACE_PARSER

feature -- Access

	last_exception_frames: DS_ARRAYED_LIST [EPA_EXCEPTION_TRACE_FRAME]
			-- Exception frames resulted from last analysis.
		do
		    if exception_frames_cache = Void then
		        create exception_frames_cache.make_default
		    end

		    Result := exception_frames_cache
		end

feature -- Status report

	is_successful: BOOLEAN
			-- Is last parsing successful?

feature -- Basic operation

	parse (a_trace: STRING)
			-- Parse the exception trace `a_trace', and make the result exception frames
			--		available in `last_exception_frames'.
		require
		    trace_not_empty: a_trace /= Void and then not a_trace.is_empty
		local
			l_trace: STRING
			l_trace_lines: LIST [STRING]
			l_line: STRING
			l_frame_string: STRING
		do
		    is_successful := True
		    last_exception_frames.wipe_out

			l_trace := a_trace.twin
			-- Get rid of '%N's at the end of the trace to avoid empty strings at the end of the splitted list.
			l_trace.prune_all_trailing ('%N')
			l_trace_lines := l_trace.as_string_8.split ('%N')

			from
				skip_trace_header (l_trace_lines)
			until
			    not is_successful or else l_trace_lines.after
			loop
				-- Construct a frame string.
				from
				    l_frame_string := ""
				until
					l_trace_lines.after or else l_trace_lines.item_for_iteration.starts_with (dash_line)
				loop
					l_frame_string.append (l_trace_lines.item_for_iteration + " ")

				    l_trace_lines.forth
				end

				parse_frame_string (l_frame_string)

				-- Skip the delimiting dash line.
				if not l_trace_lines.after then
    				l_trace_lines.forth
				end
			end
		ensure
			success: is_successful implies (not last_exception_frames.is_empty)
		end

feature{NONE} -- Implementation

	skip_trace_header (a_trace_lines: LIST [STRING])
			-- Move the cursor of `a_trace_lines' over the trace header.
			-- Everything before the header is also skipped.
			-- After this, the cursor of `a_trace_lines' is at the line immediately after the header.
		require
			trace_lines_attached: a_trace_lines /= Void
		local
		    l_line: STRING
		    l_done: BOOLEAN
		do
			-- Locate the first line of dash as the starting line, skipping everything before that.
			from
				a_trace_lines.start
				l_done := False
			until
				l_done or else a_trace_lines.after
			loop
				l_line := a_trace_lines.item_for_iteration
				if l_line.starts_with (dash_line) then
					l_done := True
				end
				a_trace_lines.forth
			end

			if l_done then
				-- Skip the rest of the header.
				if not a_trace_lines.after and then a_trace_lines.item_for_iteration.starts_with (header_line) then
					a_trace_lines.forth
					if not a_trace_lines.after and then a_trace_lines.item_for_iteration.starts_with (dash_line) then
						a_trace_lines.forth
					else
						is_successful := False
					end
				else
					is_successful := False
				end
			else
				is_successful := False
			end
		end

	string_without_extra_space (a_string: STRING): STRING
			-- Result string from replacing any consecutive white space characters with a single blank,
			--		and removing all heading as well as tailing blanks.
		require
			string_attached: a_string /= Void
		local
			l_string: STRING
			l_is_after_blank: BOOLEAN
			i: INTEGER
			l_char: CHARACTER
		do
			-- Replace all consecutive white space characters with a single blank.
			create Result.make (a_string.count)
			l_is_after_blank := False

		    from i := 1
		    until i > a_string.count
		    loop
		        l_char := a_string.item (i)
		    	if l_is_after_blank then
    		        if l_char.is_space then
    		        	-- Do nothing, skipping subsequent spaces.
    		        else
    		            Result.append_character (l_char)
    		            l_is_after_blank := False
    		        end
    		    else
    		        if l_char.is_space then
    		            l_is_after_blank := True
    		        end
   		            Result.append_character (l_char)
		    	end
		        i := i + 1
		    end

		    Result.prune_all_leading (' ')
		    Result.prune_all_trailing (' ')
		end

feature{NONE} -- Implementation

feature{NONE} -- Implementation

	parse_frame_string (a_frame_string: STRING)
			-- Parse the trace of one frame, and put the result into `last_exception_frames'.
		require
		    frame_string_not_empty: a_frame_string /= Void and then not a_frame_string.is_empty
		local
			l_string: STRING
		    l_frame: EPA_EXCEPTION_TRACE_FRAME
		do
			l_string := string_without_extra_space (a_frame_string)

			if l_string.starts_with (rescue_line_prefix) then
		        -- Rescue frame.
		        create l_frame.make_rescue
--		        create {EPA_EXCEPTION_CALL_STACK_FRAME_RESCUE}l_frame
		    else
				prepare_for_frame_string_parsing

				last_frame_string := l_string
				last_frame_string_index := 1

    			parse_context_class_name
                parse_routine_name
                parse_breakpoint_index
                parse_tag
                skip_address
                parse_written_class_name
                parse_nature_of_exception

				if is_last_frame_parsing_successful then
				    create l_frame.make (
				    	last_context_class_name, last_routine_name, last_breakpoint_slot_index,
				    	last_tag, last_written_class_name, last_nature_of_exception)
				else
					is_successful := False
				end
		    end

			if l_frame /= Void then
				last_exception_frames.force_last (l_frame)
			end
		end

	prepare_for_frame_string_parsing
			-- Prepare for frame string parsing by reset the internal state.
		do
			is_last_frame_parsing_successful := True

			last_context_class_name := ""
			last_written_class_name := ""
			last_routine_name := ""
			last_breakpoint_slot_index := 0
			last_tag := ""
			last_nature_of_exception := ""
		end

	parse_context_class_name
			-- Parse context class_name.
		local
			l_string: STRING
			l_end: INTEGER
		do
			if is_last_frame_parsing_successful and then last_frame_string_index <= last_frame_string.count then
				l_end := last_frame_string.index_of (' ', last_frame_string_index)
				l_string := last_frame_string.substring (last_frame_string_index, l_end - 1)

				if is_valid_identifier (l_string) then
					last_context_class_name := l_string
					last_frame_string_index := l_end + 1
				else
					is_last_frame_parsing_successful := False
				end
			else
				is_last_frame_parsing_successful := False
			end
		end

	parse_routine_name
			-- Parse routine name.
		local
			l_string: STRING
			l_end: INTEGER
		do
			if is_last_frame_parsing_successful and then last_frame_string_index <= last_frame_string.count then
				l_end := last_frame_string.index_of (' ', last_frame_string_index)
				l_string := last_frame_string.substring (last_frame_string_index, l_end - 1)

				if l_string.starts_with ("@") or else l_string.ends_with (":") then
					-- Do nothing -- frame without routine name.
				else
					if l_string ~ "root%'s" then
						-- Dealing with "root's creation".
						l_end := last_frame_string.index_of (' ', l_end + 1)
						l_string := last_frame_string.substring (last_frame_string_index, l_end - 1)
						check root_creation: l_string ~ {EPA_EXCEPTION_TRACE_FRAME}.Routine_name_root_creation end
					end

					last_routine_name := l_string
					last_frame_string_index := l_end + 1
				end
			end
		end

	parse_breakpoint_index
			-- Parse breakpoint slot index.
		local
			l_string: STRING
			l_end: INTEGER
			l_index: INTEGER
		do
			if is_last_frame_parsing_successful and then last_frame_string_index <= last_frame_string.count then
				l_end := last_frame_string.index_of (' ', last_frame_string_index)
				l_string := last_frame_string.substring (last_frame_string_index, l_end - 1)

				if l_string.starts_with ("@") then
					l_string.remove (1)
					if l_string.is_integer then
						last_breakpoint_slot_index := l_string.to_integer

						last_frame_string_index := l_end + 1
					else
						is_last_frame_parsing_successful := False
					end
				else
					-- Do nothing -- frame without breakpoint slot index.
				end
			end
		end

	parse_tag
			-- Parse the tag of the failing assertion.
		local
			l_string: STRING
			l_end: INTEGER
		do
			if is_last_frame_parsing_successful and then last_frame_string_index <= last_frame_string.count then
				l_end := last_frame_string.index_of (':', last_frame_string_index)
				if l_end /= 0 then
					l_string := last_frame_string.substring (last_frame_string_index, l_end - 1)

					-- Ignore cases where tags contain messages of developer exceptions.
					if not l_string.has (' ') then
						last_tag := l_string
					else
						last_tag := once "noname"
					end

					-- Skip ':' and the following ' '.
					last_frame_string_index := l_end + 2
				else
					-- No tag.
					last_tag := once "noname"
				end
			end
		end

	skip_address
			-- Skip the address of the related object.
		local
			l_string: STRING
			l_end: INTEGER
			l_skipped: BOOLEAN
		do
			if is_last_frame_parsing_successful and then last_frame_string_index <= last_frame_string.count then
				l_end := last_frame_string.index_of ('<', last_frame_string_index)
				if l_end /= 0 then
					l_end := last_frame_string.substring_index ("> ", last_frame_string_index)
					if l_end /= 0 then
						last_frame_string_index := l_end + 2
						l_skipped := True
					end
				end
			end

			-- Object address segment must be present.
			if not l_skipped then
				is_last_frame_parsing_successful := False
			end
		end

	parse_written_class_name
			-- Parse the written class name of the failing routine.
		local
			l_string, l_name: STRING
			l_start, l_end: INTEGER
			l_index: INTEGER
		do
			if is_last_frame_parsing_successful and then last_frame_string_index <= last_frame_string.count then
				l_start := last_frame_string.substring_index ("(From ", last_frame_string_index)
				if l_start /= 0 then
					l_start := l_start + 6
					l_end := last_frame_string.index_of (')', l_start)
					check found: l_end /= 0 end
					l_string := last_frame_string.substring (l_start, l_end - 1)

					last_written_class_name := l_string
					last_frame_string_index := l_end + 1
				else
					-- Do nothing.
				end
			end
		end

	parse_nature_of_exception
			-- Parse the nature of exception.
		local
			l_string, l_name: STRING
			l_start, l_end: INTEGER
			l_index: INTEGER
		do
			if is_last_frame_parsing_successful and then last_frame_string_index <= last_frame_string.count then
				l_start := last_frame_string.index_of ('.', last_frame_string_index)
				if l_start = 0 then
					is_last_frame_parsing_successful := False
				else
					l_string := last_frame_string.substring (last_frame_string_index, l_start)
					l_string.prune_all_leading (' ')

					last_nature_of_exception := l_string
				end
			else
				is_last_frame_parsing_successful := False
			end
		end

feature{NONE} -- Access -- parsing exception frame string

	is_last_frame_parsing_successful: BOOLEAN
			-- Is last trace parsing successful?

	last_frame_string: STRING
			-- String for current exception trace frame.

	last_frame_string_index: INTEGER
			-- Index inside `frame_string', from which the following parse continues.

	last_context_class_name: detachable STRING_8

	last_written_class_name: detachable STRING_8

	last_routine_name: detachable STRING_8

	last_breakpoint_slot_index: INTEGER

	last_tag: detachable STRING

	last_nature_of_exception: detachable STRING

feature{NONE} -- Identifier validator

	is_valid_identifier (a_name: STRING): BOOLEAN
			-- Is `a_name' a valid identifier in Eiffel?
		do
		    if not a_name.is_empty and then name_validator.is_valid_identifier (a_name) and then not name_validator.keywords.has (a_name.as_lower) then
		        Result := True
		    end
		end

	name_validator: EIFFEL_SYNTAX_CHECKER
			-- Validator to validate the resolved identifiers, i.e. class/feature names.
		once
		    create Result
		end

feature{NONE} -- Constant

	dash_line: STRING = "-------------------------------------------------------------------------------"

	header_line: STRING = "Class / Object      Routine                Nature of exception           Effect"

	rescue_line_prefix: STRING = "~~~~~~~~~~~~~~~~~~~~~~~~~"

feature{NONE} -- Cache

	exception_frames_cache: detachable DS_ARRAYED_LIST [EPA_EXCEPTION_TRACE_FRAME]
			-- Cache for `last_exception_frames'.

end
