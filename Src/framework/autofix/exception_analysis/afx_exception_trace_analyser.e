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

		    	-- prepare internal storage
		    if internal_exception_frames = Void then
		        create internal_exception_frames.make_default
		    else
		        internal_exception_frames.wipe_out
		    end

				-- get rid of the "%N" at the end of trace, so that no empty sub-string will be put at the end of the split-result list
			l_trace := a_trace.twin
			l_trace.prune_all_trailing ('%N')

				-- get list of trace lines
			l_trace_lines := l_trace.as_string_8.split ('%N')

				-- analyse each frame string
			from
				l_trace_lines.start
				skip_trace_header (l_trace_lines)
				create l_frame_string.make_empty
			until
			    l_trace_lines.after
			loop
				l_frame_string.wipe_out

					-- construct a frame string
				from l_line := l_trace_lines.item_for_iteration
				until l_line.starts_with (dash_line)
				loop
				    l_frame_string := l_frame_string + l_line + " "
				    l_trace_lines.forth
				    l_line := l_trace_lines.item_for_iteration
				end

				analyse_frame_string (l_frame_string)

					-- skip the delimiting dash line
				l_trace_lines.forth
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

		    l_class_name := l_words.at (1)

		    if l_class_name.starts_with (rescue_line_prefix) then
		        	-- rescue frame
		        create {AFX_EXCEPTION_CALL_STACK_FRAME_RESCUE}l_frame
		    else
		        if is_valid_identifier (l_class_name) then
    				if l_words.count > 6 then
            		    l_feature_name := l_words.at (2)
            		    if is_valid_identifier (l_feature_name) then
                		    l_bkpt_string := l_words.at (3)

                		    if l_bkpt_string.starts_with ("@") then
                		        l_bkpt_string := l_bkpt_string.substring (2, l_bkpt_string.count)
                		        if l_bkpt_string.is_integer then
                		            l_bkpt_slot_index := l_bkpt_string.to_integer
                		        else
                		            l_bad_format := False
                		        end
                		    else
                		        	-- external features do not have breakpoint slot info
                		        l_bkpt_slot_index := 0
                		    end

							create l_origin_class_name.make_empty
                		    from i := 4
                		    until l_bad_format or else not l_origin_class_name.is_empty or else i > l_words.count
                		    loop
                		        l_word := l_words.at (i)
                		        if l_word ~ "(From" then
                		            check l_words.count >= i + 1 end
                		            l_word := l_words.at (i + 1)
                		            l_origin_class_name := l_word.substring (1, l_word.count - 1)
                		            if not is_valid_identifier (l_origin_class_name) then
                		                l_bad_format := True
                		                l_origin_class_name.wipe_out
                		            end
                		        end
                		        i := i + 1
                		    end
            		    else
            		        l_bad_format := True
            		    end
            		else
            		    l_bad_format := True
    				end
		        else
		            l_bad_format := True
		        end

				if l_bad_format then
					is_successful := False
				else
				    create {AFX_EXCEPTION_CALL_STACK_FRAME}l_frame.make (l_class_name, l_origin_class_name, l_feature_name, l_bkpt_slot_index, 0)
				end
		    end

			internal_exception_frames.force_last (l_frame)
		end

	is_valid_identifier (a_name: STRING): BOOLEAN
			-- Is `a_name' a valid identifier in Eiffel?
		do
		    if not a_name.is_empty and then name_validator.is_valid_identifier (a_name) and then not name_validator.keywords.has (a_name.as_lower) then
		        Result := True
		    end
		end

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
