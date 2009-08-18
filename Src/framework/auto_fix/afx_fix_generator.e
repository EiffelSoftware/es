note
	description: "Summary description for {AFX_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_GENERATOR

inherit
	AFX_TASK

	AFX_SHARED_SESSION

	SHARED_AFX_FIX_REPOSITORY

create
    make

feature -- Creation

	make
			-- initialize
		local
		    l_session: detachable AFX_SESSION
		    l_failing_tests: DS_LINEAR[TEST_I]
		    l_test: TEST_I
		    l_exception: AFX_TEST_INVOCATION_EXCEPTION
		    l_repository: AFX_FIX_REPOSITORY
		do
		    	-- get exception information from session
		    l_session := session
		    check session_not_void: l_session /= Void end
		    l_failing_tests := l_session.conf.failing_tests
		    check l_failing_tests.count = 1 end
		    l_test := l_failing_tests.first
		    check l_test.is_outcome_available and l_test.failed end
		    create l_exception.make(l_test.outcomes.last.test_response.exception)

		    	-- create and share the fix repository
		    create l_repository.make (l_exception)
		    set_repository (l_repository)
		end

feature -- execution

	start
			-- <Precursor>
		local
		    l_repository: AFX_FIX_REPOSITORY
		    l_exception: AFX_TEST_INVOCATION_EXCEPTION
		    l_session: like session
		    l_error_handler: AFX_ERROR_PRINTER
		do
--				-- logging
--			l_session := session
--			check l_session /= Void end
--			l_error_handler := l_session.error_handler
--			l_error_handler.report_info_message ("Generator task started.")

		    l_repository := repository
		    l_exception := l_repository.exception
			if l_exception.is_analysable then
			    l_repository.get_exception_positions
			end

			is_successful := True
			is_executing := True
			current_step := Resolve_exception_position_info_step
		end

	step
			-- <Precursor>
		local
		    l_should_cancel: BOOLEAN
		    l_session: detachable AFX_SESSION
		    l_error_handler: AFX_ERROR_HANDLER_I
		do
		    l_session := session
		    check l_session /= Void end
--		    l_error_handler := session.error_handler

		    if not is_cancel_requested and repository.is_healthy then
		        if current_step >= 1 and current_step <= Total_steps then

--		            l_error_handler.report_info_message ("Generator step started: " + Step_names[current_step])
    				inspect
    					current_step
    				when Resolve_exception_position_info_step then
    					repository.resolve_exception_position_info
    				when Mark_relevant_fix_position_step then
    					repository.mark_relevant_exception_positions
    				when Collect_relevant_objects_step then
    					repository.collect_relevant_objects_at_fix_positions
    				when Generate_and_register_fixes_step then
    					repository.generate_and_register_fixes
    				end

--    				l_error_handler.report_info_message ("Generator step finished: " + Step_names[current_step])
    			else
--    			    l_error_handler.report_error_message ("Bad generator step code: " + current_step.out)
		        end

    		    current_step := current_step + 1
    		    if current_step > Total_steps then
    		        is_executing := False
    		        is_finished := True
    		        if attached repository as l_repos and then l_repos.is_healthy then
    		            is_successful := True
    		        end
    		    end
    		end

    		if is_cancel_requested or not repository.is_healthy then
    			current_step := Total_steps + 1
    			is_executing := False
    			is_finished := True
    			is_successful := False

	    		repository.set_health_state (False)
		    end
		end

	stop
			-- <Precursor>
		local
		    l_session: detachable AFX_SESSION
		    l_error_handler: AFX_ERROR_HANDLER_I
		    l_msg: STRING
		do
--		    l_session := session
--		    check l_session /= Void end
--		    l_error_handler := session.error_handler

--		    	-- logging
--		    create l_msg.make_from_string ("Generator task stops ")
--		    if attached repository as l_repos and then l_repos.is_healthy then
--		        l_msg.append_string ("successfully.")
--		    else
--		        l_msg.append_string ("unsuccessfully.")
--		    end
--		    l_error_handler.report_info_message (l_msg)
		end

	cancel
			-- <Precursor>
		do
			is_cancel_requested := True
		end

feature -- Status report

	is_finished: BOOLEAN
			-- is task finished?

	is_cancel_requested: BOOLEAN
			-- should task be cancelled?

	is_successful: BOOLEAN
			-- is the execution successful?

	is_executing: BOOLEAN
			-- is the task executing?


feature -- Access

feature{NONE} -- Implementation

	current_step: INTEGER
			-- current step of the process

	Resolve_exception_position_info_step: INTEGER = 1
			-- step of resolve fix position information like `e_feature' and `breakpoint_info'

	Mark_relevant_fix_position_step: INTEGER = 2
			-- mark some fix positions as relevant, according to the exception type

--	Resolve_fix_positions_step: INTEGER = 3
--			-- compute the positions where fixes should be applied

	Collect_relevant_objects_step: INTEGER = 3
			-- collect relevant objects relevant to the fixing

	Generate_and_register_fixes_step: INTEGER = 4
			-- generate fixes and register them in the repository

	Total_steps: INTEGER = 4
			-- total number of steps

	Step_names: ARRAY[STRING]
			-- names of individual steps
		once
		    Result := <<"Resolve_exception_position_info_step", "Mark_relevant_fix_position_step",
								"Collect_relevant_objects_step", "Generate_and_register_fixes_step" >>
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
