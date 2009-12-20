note
	description: "Summary description for {AFX_FAULTY_EXCEPTION_CALL_STACK_FRAME_MARKING_STRATEGY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FAULTY_EXCEPTION_CALL_STACK_FRAME_MARKING_STRATEGY

inherit
	AFX_FAULTY_EXCEPTION_CALL_STACK_FRAME_MARKING_STRATEGY_I

feature -- Operation

	mark (an_exception: EQA_TEST_INVOCATION_EXCEPTION; a_frame_list: DS_LINEAR [AFX_EXCEPTION_CALL_STACK_FRAME_I])
			-- <Precursor>
		local
		    l_exception_frames: like internal_frame_list
		    l_code: INTEGER
		    l_frame: AFX_EXCEPTION_CALL_STACK_FRAME_I
		    l_cur_class: attached CLASS_C
		    i: INTEGER
		    l_count_relevant_frames: INTEGER
		do
		    eliminate_rescued_frames (a_frame_list)

		    l_exception_frames := internal_frame_list
		    if not l_exception_frames.is_empty then
				l_code := an_exception.code
	            if l_code = {EXCEP_CONST}.Precondition
	            		or else l_code = {EXCEP_CONST}.Void_call_target
	            		or else l_code = {EXCEP_CONST}.Check_instruction then
		            l_exception_frames.first.set_relevant (False)
	            end

	            	-- mark the frame from test case as irrelevant
	            l_exception_frames.last.set_relevant (False)

		        	-- mark irrelevant those classes: the test-case class, un-modifiable class, external class and
		        from
		            i := 1
		        until
		            	-- skip the test case feature, i.e. the last of the exception frame list
		            i = l_exception_frames.count
		        loop
		            l_frame := l_exception_frames.at(i)
		            l_cur_class := l_frame.origin_class

		            if l_frame.is_relevant and then l_frame.is_information_complete and then l_frame.is_resolved then
		                if l_cur_class.is_modifiable
   		       	        		and then not l_cur_class.is_external
   		       	        		and then not l_cur_class.is_precompiled then
   		       	        	l_frame.set_relevant (True)
   		       	        else
   		       	            l_frame.set_relevant (False)
   		       	        end
    	            else
    	            		-- exception frames with incomplete information are always irrelevant
    	                l_frame.set_relevant (False)
    	            end

	            	i := i + 1
		        end -- loop
		    end

			from
				l_exception_frames.start
				l_count_relevant_frames := 0
			until l_exception_frames.after
			loop
			    if l_exception_frames.item_for_iteration.is_relevant then
			        l_count_relevant_frames := l_count_relevant_frames + 1
			    end
			    l_exception_frames.forth
			end
		end


feature -- Access

	last_marking_result: DS_LINEAR [AFX_EXCEPTION_CALL_STACK_FRAME_I]
			-- the result of last marking process
		do
		    if internal_frame_list = Void then
		        create internal_frame_list.make_default
		    end

		    Result := internal_frame_list
		end

feature{NONE} -- Implementation

	eliminate_rescued_frames (a_frame_list: DS_LINEAR [AFX_EXCEPTION_CALL_STACK_FRAME_I])
			-- remove rescued frames from top
		require
		    a_frame_list_not_empty: a_frame_list /= Void and then not a_frame_list.is_empty
		local
		    l_frames: DS_ARRAYED_LIST [AFX_EXCEPTION_CALL_STACK_FRAME_I]
		    l_count: INTEGER
		    i: INTEGER
		    l_rescued: BOOLEAN
		do
		    l_count := a_frame_list.count
		    create l_frames.make_from_linear (a_frame_list)
		    create internal_frame_list.make (l_count)

		    from i := l_count
		    until i = 0 or l_rescued
		    loop
    		    if attached {AFX_EXCEPTION_CALL_STACK_FRAME_RESCUE} l_frames.at (i) then
    		        l_rescued := True
    		    else
    		        	-- I could have used `force_last' for performance reasons,
    		        	-- but I chose `force_first' out of respect for the order of exception frames
			        internal_frame_list.force_first (l_frames.at(i))
			    end
    	        i := i - 1
		    end
		ensure
		    internal_frame_list_not_empty: internal_frame_list /= Void and then not internal_frame_list.is_empty
		end

	internal_frame_list: detachable DS_ARRAYED_LIST [AFX_EXCEPTION_CALL_STACK_FRAME_I]
			-- internal storage for intermediate result


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
