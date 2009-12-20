note
	description: "Summary description for {AFX_FIX_SYNTHESIZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_SYNTHESIZER

inherit
	AFX_TASK

	SHARED_AFX_SESSION

	SHARED_AFX_FIX_REPOSITORY_NEW

	SHARED_AFX_LOGGING_INFRASTRUCTURE

	SHARED_AFX_INTERNAL_PROGRESS_CONSTANT

create
    make

feature -- Initialization

	make
			-- initialize a new synthesizer
		do
				-- create the collectors according to the conf
			create {AFX_FIX_POSITION_BASIC_COLLECTOR} fix_position_collector
--			create {AFX_FIX_POSITION_GREEDY_COLLECTOR} fix_position_collector
			create {AFX_FIXING_TARGET_COLLECTOR_BASIC} fixing_target_collector

				-- create central storage
			create exception_call_stack_frames.make_default
			create fix_positions.make_default
			create fixing_targets.make (5)
			fixing_targets.compare_objects

			is_successful := True

			log_info (Msg_created_fix_synthesizer)
		end

feature -- Access

	failing_test: detachable AFX_TEST
			-- test reflecting the failure which we want to fix

	fix_position_collector: AFX_FIX_POSITION_COLLECTER_I
			-- collector for collecting fix positions

	fixing_target_collector: AFX_FIXING_TARGET_COLLECTOR_I
			-- collector for collecting fixing targets

	exception_call_stack_frames: DS_ARRAYED_LIST [AFX_EXCEPTION_CALL_STACK_FRAME_I]
			-- call stack frames when exception was raised

	fix_positions: DS_ARRAYED_LIST [AFX_FIX_POSITION]
			-- fix positions collected in all frames

	fixing_targets: ARRAYED_SET [AFX_FIXING_TARGET_I]
			-- fixing targets

feature -- Progress report

	next_progress_fraction: REAL
			-- how much progress do we have after finishing next step

feature -- execution

	start
			-- <Precursor>
		local
		    l_failing_tests: DS_LINEAR[AFX_TEST]
		    l_failure_explainer: AFX_FAILURE_EXPLAINER
		    l_marking_strategy: AFX_FAULTY_EXCEPTION_CALL_STACK_FRAME_MARKING_STRATEGY_I
--		    l_explanation: detachable DS_LINEAR [AFX_EXCEPTION_CALL_STACK_FRAME_I]
		do
		    	-- get failing test from session
		    if attached session as l_session then
		    	l_failing_tests := l_session.conf.failing_tests
		    	if l_failing_tests.count = 1 then
			    	failing_test := l_failing_tests.first

			    	check
			    		test_is_a_failure: failing_test.failed
			    	end

        		    create l_failure_explainer
        		    l_failure_explainer.explain (failing_test.test.outcomes.last.test_response.exception.trace)

        		    create {AFX_FAULTY_EXCEPTION_CALL_STACK_FRAME_MARKING_STRATEGY}l_marking_strategy
        		    l_marking_strategy.mark (failing_test.test.outcomes.last.test_response.exception, l_failure_explainer.last_exception_explanation)

        			exception_call_stack_frames.append_last (l_marking_strategy.last_marking_result)
        			check not exception_call_stack_frames.is_empty end

					is_analysing := True
					exception_call_stack_frames.start
						-- update progress fraction
					next_progress_fraction := Position_collection_phase_fraction / exception_call_stack_frames.count
			    else
			    	is_successful := False
			        is_finished := True

			        log_error (Err_bad_failing_test_case_number)
		    	end
		    else
		    	is_successful := False
		        is_finished := True

		        log_error (Err_bad_session_object)
		    end
		    is_executing := True

		    log_info (Msg_started_fix_synthesizer)
		ensure then
		    call_stack_frames_not_empty_if_not_finished:
		    		(not is_finished) implies (exception_call_stack_frames /= Void and then not exception_call_stack_frames.is_empty)
		end

	step
			-- <Precursor>
		local
		    l_frame: AFX_EXCEPTION_CALL_STACK_FRAME_I
		    l_fix_positions: DS_ARRAYED_LIST[AFX_FIX_POSITION]
		    l_position: AFX_FIX_POSITION
		    l_target_collection: HASH_TABLE [AFX_FIXING_TARGET_I, STRING]
		    l_targets: DS_LINEAR [AFX_FIXING_TARGET_I]
		    l_target: AFX_FIXING_TARGET_I
   		    l_tuning_service: AFX_FIXING_TARGET_TUNING_SERVICE

		    l_tunes: DS_LINEAR [AFX_FIX_OPERATION_I]
		    l_tune: AFX_FIX_OPERATION_I
		    l_fix: AFX_FIX_INFO_I
		do
		    if is_cancel_requested then
		    	is_successful := False
		    	is_finished := True
		    else
    		    if is_analysing then
    		        if not exception_call_stack_frames.after then
            		    l_frame := exception_call_stack_frames.item_for_iteration
    		        	if l_frame.is_relevant then
            					-- collect fix positions for this frame and put the result into `fix_positions'
            				fix_position_collector.config (l_frame.origin_feature.e_feature.ast, l_frame)
            				fix_position_collector.collect_fix_positions
            				l_fix_positions := fix_position_collector.last_collection
            				check l_fix_positions /= Void end
            				fix_positions.append_last (l_fix_positions)
            			else
   		        	    	-- we simply skip the frames marked as irrelevant
            			end

            			session.progress (next_progress_fraction)
        				exception_call_stack_frames.forth

        				if exception_call_stack_frames.after then
        				    check not fix_positions.is_empty end
        				    fix_positions.start
        				    next_progress_fraction := Fixing_target_collection_phase_fraction / fix_positions.count
        				end
	    			elseif not fix_positions.after then
        				l_position := fix_positions.item_for_iteration

        				fixing_target_collector.collect_fixing_targets (l_position.exception_position.origin_feature.e_feature, l_position.ast_position)
        				l_target_collection := fixing_target_collector.last_collection

        				l_position.register_fixing_targets (l_target_collection)
        				queue_fixing_targets (l_target_collection)

						session.progress (next_progress_fraction)
        				fix_positions.forth

        				if fix_positions.after then
        				    fixing_targets.start
        				    next_progress_fraction := Tune_generation_phase_fraction / fixing_targets.count
        				end
        			elseif not fixing_targets.after then
        			    l_target := fixing_targets.item

        			    create l_tuning_service
        			    l_tuning_service.tune (l_target)

						session.progress (next_progress_fraction)
        			    fixing_targets.forth

        			    if fixing_targets.after then
        			        is_analysing := False
        			        is_registering_fixes := True

        			        fix_positions.start
        			        repository.start_registration
        			        next_progress_fraction := Fix_registration_phase_fraction / fix_positions.count
        			    end
        			end
    		    elseif is_registering_fixes then
    		    	if not fix_positions.after then
        			    l_position := fix_positions.item_for_iteration
        			    l_targets := l_position.fixing_targets

        					-- register all fixes associated with this position
        			    from l_targets.start
        			    until l_targets.after
        			    loop
        			        l_target := l_targets.item_for_iteration

        					l_tunes := l_target.tunning_operations
        					from l_tunes.start
        					until l_tunes.after
        					loop
        					    l_tune := l_tunes.item_for_iteration

        						create {AFX_FIX_INFO_SIMPLE}l_fix.make (l_position, l_tune)
        						repository.register_fix (l_fix, l_position.exception_position.origin_feature.written_in)

        					    l_tunes.forth
        					end

        			        l_targets.forth
        			    end

						session.progress (next_progress_fraction)
        				fix_positions.forth
       				end

    				if fix_positions.after then
       				    is_registering_fixes := False
       				    is_finished := True
       				    is_successful := not repository.is_empty
       				    next_progress_fraction := 0
    				end
    			else
    			    	-- error
    			    is_finished := True
    			    is_successful := False
    			    next_progress_fraction := 0
    			    check False end
    		    end
    		end -- if is_cancel_requested
		ensure then
		    finish_after_analysis_and_registration: is_finished implies not (is_analysing or is_registering_fixes)
		    successfully_finished_with_repository_non_empty: (is_finished and is_successful) implies not repository.is_empty
		end

	stop
			-- <Precursor>
		do
		    -- log
		end

	cancel
			-- <Precursor>
		do
			is_cancel_requested := True
		end

feature -- Status report

	is_finished: BOOLEAN
			-- <Precursor>

	is_cancel_requested: BOOLEAN
			-- <Precursor>

	is_successful: BOOLEAN
			-- <Precursor>

	is_executing: BOOLEAN
			-- <Precursor>

	is_analysing: BOOLEAN
			-- is synthesizer analysing exception/fix information?

	is_registering_fixes: BOOLEAN
			-- is synthesizer registering fixes?

feature{NONE} -- Implementation

	queue_fixing_targets (a_fixing_targets: HASH_TABLE [AFX_FIXING_TARGET_I, STRING])
			-- queue the fixing target into `fixing_targets'
		do
		    from a_fixing_targets.start
		    until a_fixing_targets.after
		    loop
		        fixing_targets.put (a_fixing_targets.item_for_iteration)
		        a_fixing_targets.forth
		    end
		end

	frame_cursor: detachable DS_LINEAR_CURSOR [AFX_EXCEPTION_CALL_STACK_FRAME_I]
			-- internal cursor to iterate `exception_call_stack_frames'

	position_cursor: detachable DS_LINEAR_CURSOR [AFX_FIX_POSITION]
			-- internal cursor to iterate `fix_positions'


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
