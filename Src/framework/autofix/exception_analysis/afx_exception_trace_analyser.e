note
	description: "Summary description for {AFX_EXCEPTION_TRACE_ANALYSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXCEPTION_TRACE_ANALYSER

inherit

    AFX_EXCEPTION_TRACE_ANALYSER_I

feature -- Operation

	analyse (a_trace: STRING)
			-- <Precursor>
		local
			l_trace: STRING
			l_trace_lines: LIST [STRING]
			l_line: STRING
			l_frame_string: STRING
		do
		    is_successful := True
		    last_relevant_exception_frames.wipe_out

				-- Get rid of the "%N" at the end of trace to avoid the empty string at the end of the splitted list.
			l_trace := a_trace.twin
			l_trace.prune_all_trailing ('%N')
			l_trace_lines := l_trace.as_string_8.split ('%N')

			from
				l_trace_lines.start
				skip_trace_header (l_trace_lines)
			until
			    l_trace_lines.after
			loop
					-- Construct a frame string.
				from
				    l_frame_string := ""
				until
					l_trace_lines.after or else l_trace_lines.item_for_iteration.starts_with (dash_line)
				loop
					l_line := l_trace_lines.item_for_iteration

				    l_frame_string := l_frame_string + l_line + " "
				    l_trace_lines.forth
				end

				analyse_frame_string (l_frame_string)

					-- skip the delimiting dash line
				if not l_trace_lines.after then
    				l_trace_lines.forth
				end
			end
		ensure then
		    internal_exception_frames_not_empty: internal_exception_frames /= Void and then not internal_exception_frames.is_empty
		end

feature -- Access

	last_relevant_exception_frames: DS_LINEAR [AFX_EXCEPTION_CALL_STACK_FRAME_I]
			-- <Precursor>
		do
		    if internal_exception_frames = Void then
		        create internal_exception_frames.make_default
		    end

		    Result := internal_exception_frames
		ensure then
		    result_attached: Result /= Void
		end

feature -- Status report

	is_successful: BOOLEAN
			-- <Precursor>

feature{NONE} -- Implementation

	skip_trace_header (a_trace_lines: LIST [STRING])
			-- move the cursor of `a_trace_lines' over the trace header
		require
		    trace_lines_started: a_trace_lines.index = 1
		local
		    l_line: STRING
		do
		    	-- first line of dash
		    l_line := a_trace_lines.item_for_iteration
		    if not l_line.starts_with (dash_line) then
				is_successful := False
		    else
    				-- header
    		    a_trace_lines.forth
    		    l_line := a_trace_lines.item_for_iteration
    		    if not l_line.starts_with (header_line) then
    				is_successful := False
    		    else
        				-- second line of dash
        		    a_trace_lines.forth
        		    l_line := a_trace_lines.item_for_iteration
        		    if not l_line.starts_with (dash_line) then
        				is_successful := False
        		    else
            		    	-- go forward to next line
            		    a_trace_lines.forth
            		end
        		end
    		end
		end

	analyse_frame_string (a_string: STRING)
			-- analyse the trace of one frame, and add the result to `internal_exception_frames'
		require
		    frame_string_not_empty: not a_string.is_empty
		    internal_exception_frames_not_void: internal_exception_frames /= Void
		local
		    l_string: STRING
		    l_is_after_blank: BOOLEAN
		    l_char: CHARACTER
		    l_class_name: STRING
		    l_origin_class_name: STRING
		    l_feature_name: STRING
		    l_bkpt_string: STRING
		    l_next_string: STRING
		    l_tag: STRING
		    l_nature_of_exception: STRING
		    l_bkpt_slot_index: INTEGER
		    l_words: LIST[STRING]
		    l_word: STRING
		    l_frame: AFX_EXCEPTION_CALL_STACK_FRAME_I
		    l_bad_format: BOOLEAN
		    i: INTEGER
		do
				-- replace all subsequent space characters with a single blank
			create l_string.make (a_string.count)
			l_is_after_blank := False

		    from i := 1
		    until i > a_string.count
		    loop
		        l_char := a_string.item (i)
		    	if l_is_after_blank then
    		        if l_char.is_space then
    		            -- do nothing, skipping subsequent spaces
    		        else
    		            l_string.append_character (l_char)
    		            l_is_after_blank := False
    		        end
    		    else
    		        if l_char.is_space then
    		            l_is_after_blank := True
    		        end
   		            l_string.append_character (l_char)
		    	end
		        i := i + 1
		    end
		    l_string.prune_all_leading (' ')
		    l_string.prune_all_trailing (' ')

				-- split trace frames into words
		    l_words := l_string.split (' ')
		    check l_words /= Void and not l_words.is_empty end

		    if l_words.at (1).starts_with (rescue_line_prefix) then
		        	-- rescue frame
		        create {AFX_EXCEPTION_CALL_STACK_FRAME_RESCUE}l_frame
		    else
		    	reset_last_parsing_temp

    			last_word_list := l_words
    			last_list_index := 1

    			parse_context_class_name
                parse_feature_name
                parse_breakpoint_index
                parse_tag
                parse_address
                parse_original_class
                parse_nature_of_exception

				if is_last_parsing_successful then
				    create {AFX_EXCEPTION_CALL_STACK_FRAME}l_frame.make (
				    	last_context_class_name, last_origin_class_name, last_feature_name,
				    	last_tag, last_nature_of_exception, last_breakpoint_slot_index)
				else
					is_successful := False
				end
		    end

			if l_frame /= Void then
				internal_exception_frames.force_last (l_frame)
			end
		end

feature{NONE} -- Implementation: parsing exception frame

	is_valid_identifier (a_name: STRING): BOOLEAN
			-- Is `a_name' a valid identifier in Eiffel?
		do
		    if not a_name.is_empty and then name_validator.is_valid_identifier (a_name) and then not name_validator.keywords.has (a_name.as_lower) then
		        Result := True
		    end
		end

	parse_context_class_name
		local
		    l_string: STRING
		do
		    if is_last_parsing_successful then
		        if last_list_index < last_word_list.count then
        		    l_string := last_word_list.at (last_list_index)

        		    	-- Possible class name.
        		    if is_valid_identifier (l_string) then
        		        last_context_class_name := l_string.twin

        		        last_list_index := last_list_index + 1
        		    end
        		else
        		    is_last_parsing_successful := False
		        end
		    end
		end

	parse_feature_name
		local
		    l_string: STRING
		do
		    if is_last_parsing_successful then
		        if last_list_index <= last_word_list.count then
		            l_string := last_word_list.at (last_list_index)

		            	-- Possible feature name.
		            if l_string.starts_with ("@") or else l_string.starts_with ("<") then
						last_feature_name := ""
					else
					    last_feature_name := l_string.twin

					    last_list_index := last_list_index + 1
		            end
		        end
		    end
		end

	parse_breakpoint_index
		local
		    l_string: STRING
		do
		    if is_last_parsing_successful then
		        if last_list_index <= last_word_list.count then
		            l_string := last_word_list.at (last_list_index)

		            	-- Possible breakpoint index
		            if l_string.starts_with ("@") then
		                l_string := l_string.substring (2, l_string.count)
		                if l_string.is_integer then
		                    last_breakpoint_slot_index := l_string.to_integer
		                else
		                    is_last_parsing_successful := False
		                end

		                last_list_index := last_list_index + 1
		            end
		        end
		    end
		end

	parse_tag
		local
		    l_string: STRING
		do
		    if is_last_parsing_successful then
		        if last_list_index <= last_word_list.count then
		            l_string := last_word_list.at (last_list_index)

		            	-- Possible tag.
		            if l_string.ends_with (":") then
						last_tag := l_string.substring (1, l_string.index_of (':', 1) - 1)

						last_list_index := last_list_index + 1
		            end
		        end
		    end
		end

	parse_address
		local
		    l_string: STRING
		do
		    if is_last_parsing_successful then
		        if last_list_index <= last_word_list.count then
		            l_string := last_word_list.at (last_list_index)

		            	-- Definite address.
		            if l_string.starts_with ("<") then
		                last_list_index := last_list_index + 1
		            else
		                is_last_parsing_successful := False
		            end
		        end
		    end
		end

	parse_original_class
		local
		    l_string: STRING
		do
		    if is_last_parsing_successful then
		        if last_list_index <= last_word_list.count then
		        	l_string := last_word_list.at (last_list_index)

		        		-- Possible original class
		        	if l_string.starts_with ("(") then
		        	    last_list_index := last_list_index + 1
		        	    if last_list_index > last_word_list.count or else not last_word_list.at (last_list_index).ends_with (")") then
		        	        is_last_parsing_successful := False
		        	    else
		        	        l_string := last_word_list.at (last_list_index)
		        	        last_origin_class_name := l_string.substring (1, l_string.count - 1)

		        	        last_list_index := last_list_index + 1
		        	    end
		        	end
		        end
		    end
		end

	parse_nature_of_exception
		local
		    l_string: STRING
		    l_nature: STRING
		    l_count: INTEGER
		do
		    if is_last_parsing_successful then
		        l_nature := ""
		        from l_count := last_word_list.count
		        until last_list_index > l_count or else last_word_list.at (last_list_index).ends_with(".")
		        loop
		            l_nature.append (last_word_list.at (last_list_index))
		            l_nature.append (" ")
		            last_list_index := last_list_index + 1
		        end

		        if last_list_index <= last_word_list.count and then last_word_list.at (last_list_index).ends_with(".") then
		            l_string := last_word_list.at (last_list_index)
		        	l_nature.append (l_string.substring (1, l_string.count - 1))

		        	last_nature_of_exception := l_nature
		        end
		    end
		end

	reset_last_parsing_temp
			-- Reset the temp storage for parsing.
		do
		    is_last_parsing_successful := True
		    last_word_list := Void
		    last_list_index := 1
		    last_context_class_name := ""
		    last_origin_class_name := ""
		    last_feature_name := ""
		    last_breakpoint_slot_index := 0
		    last_tag := ""
		    last_nature_of_exception := ""
		end

	is_last_parsing_successful: BOOLEAN

	last_word_list: detachable LIST[STRING]

	last_list_index: INTEGER

	last_context_class_name: detachable STRING_8

	last_origin_class_name: detachable STRING_8

	last_feature_name: detachable STRING_8

	last_breakpoint_slot_index: INTEGER

	last_tag: detachable STRING

	last_nature_of_exception: detachable STRING

feature{NONE} -- Implementation

	dash_line: STRING = "-------------------------------------------------------------------------------"

	header_line: STRING = "Class / Object      Routine                Nature of exception           Effect"

	rescue_line_prefix: STRING = "~~~~~~~~~~~~~~~~~~~~~~~~~"

	internal_exception_frames: detachable DS_ARRAYED_LIST [AFX_EXCEPTION_CALL_STACK_FRAME_I]
			-- internal storage for exception frames

	name_validator: EIFFEL_SYNTAX_CHECKER
			-- validator to validate the resolved class/feature names
		once
		    create Result
		end

;note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
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
end
