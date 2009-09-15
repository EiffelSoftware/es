note
	description: "Summary description for {AFX_FIX_PROPOSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_PROPOSER

inherit
	AFX_FIX_PROPOSER_I
		undefine
		    is_ready
		end

	TEST_EXECUTOR
		export {AFX_SYSTEM_ADJUSTER}
			compile_project,
			last_compilation_successful
		undefine
			compile_project,
			relaunch_evaluators,
		    conf_type
		redefine
		    start_process_internal,
		    proceed_process,
		    stop_process,
		    is_running,
		    is_finished,
		    abort,
		    retrieve_results
		end

	SHARED_AFX_EVALUATION_ID_CODEC

	SHARED_AFX_SESSION

	SHARED_AFX_LOGGING_INFRASTRUCTURE

	ES_SHARED_PROMPT_PROVIDER

	SHARED_AFX_FIX_ID

	SHARED_AFX_TEST_ID

	SHARED_AFX_FIX_REPOSITORY_NEW

	SHARED_AFX_INTERNAL_PROGRESS_CONSTANT

inherit{NONE}

	TEST_BACKGROUND_EXECUTOR
		undefine
		    start_process_internal,
		    proceed_process,
		    stop_process,
		    is_running,
		    is_finished,
		    abort,
		    retrieve_results,
		    conf_type
		end

create
    make

feature -- Process

	start_process_internal (a_conf: like conf_type)
			-- <Precursor>
		local
		    l_logging_service: like logging_service
		    l_entry_factory: like log_entry_factory
		    l_log_file: AFX_LOG_FILE
		    l_session: like session
		do
		    	-- config the log file
		    create l_log_file.make_standard
		    l_log_file.enable_benchmarking (True)
		    l_log_file.config (a_conf)
		    l_log_file.start_logging

				-- register the log file
		    l_logging_service := logging_service
		    if not l_logging_service.has_registered (l_log_file) then
			    l_logging_service.register_observer (l_log_file)
		    end

				-- share the session info
			create l_session.make (a_conf, Current)
			set_session (l_session)

				-- prepare fix repository
		    set_repository (create {AFX_FIX_REPOSITORY}.make (5))

				-- starting synthesis
			create fix_synthesizer.make
			fix_synthesizer.start

			is_successful := True
			is_running := True
			is_compiled := False

--			internal_progress := Start_phase_finished_fraction

				-- logging
			log_info (Msg_started_fix_proposer)
		end

	proceed_process
			-- <Precursor>
		local
		    l_logging_service: like logging_service
		    l_entry_factory: like log_entry_factory
		    l_potential_fixes: DS_LINEAR [AFX_FIX_INFO_I]
		do
		    if attached fix_synthesizer as l_synthesizer then
		        if is_stop_requested then
		            fix_synthesizer := Void
		        else
		            if not l_synthesizer.is_finished then
		                l_synthesizer.step
		            else
		                l_synthesizer.stop

		                if l_synthesizer.is_successful then
		                	create system_adjuster
		                else
		                    is_successful := False
		                end

		                fix_synthesizer := Void
		            end
		        end

		    elseif attached system_adjuster as l_adjuster then
		        if not is_stop_requested then
    		        	-- adjust the system
    	            l_adjuster.apply_compile_and_restore

    	            if l_adjuster.is_successful then
    	                l_logging_service := logging_service
    	                l_entry_factory := log_entry_factory
    	                l_logging_service.log (l_entry_factory.make_info_entry (Msg_starting_fix_evaluation))

    	                	-- preparation
    	                prepare_for_evaluation

    	                	-- evaluate all fixes over failing tests
    	                tests_under_evaluation := session.conf.failing_tests
    	                fixes_under_evaluation := repository.fixes
    	                start_evaluation

							-- update progress step
    	                delta_progress := (Fix_evaluation_phase_i_finished_fraction - System_adjuster_finished_fraction)
    	                				/ (tests_under_evaluation.count * fixes_under_evaluation.count)

    					is_checking_effectiveness := True
    	            else
    	                is_successful := False
    	            end
		        end

		        	-- reset `system_adjuster' to Void anyway after this step is over
    	        system_adjuster := Void

		    elseif is_checking_effectiveness then
		        	-- synchronize evaluators, retrieve results, and cancel process when `is_stop_requested'
				syncronize_evaluators

				if not is_stop_requested and then evaluators.is_empty then
   						-- collect effective fixes when evaluation finishes
   					evaluation_results.collect_fixes_good_for_tests (fixes_under_evaluation, tests_under_evaluation)
				    l_potential_fixes := evaluation_results.last_good_fix_collection

	                l_logging_service := logging_service
	                l_entry_factory := log_entry_factory
				    if not l_potential_fixes.is_empty then
    	                l_logging_service.log (l_entry_factory.make_info_entry (Msg_starting_fix_validation))

							-- evaluate potential fixes over regression tests
				        fixes_under_evaluation := l_potential_fixes
				        tests_under_evaluation := session.conf.regression_tests
				        start_evaluation

							-- update progress step
    	                delta_progress := (Fix_evaluation_phase_ii_finished_fraction - Fix_evaluation_phase_i_finished_fraction)
    	                				/ (tests_under_evaluation.count * fixes_under_evaluation.count)

				        is_checking_validity := True
				    else
				        l_logging_service.log (l_entry_factory.make_info_entry (Msg_no_fix_to_be_validated))
				        is_finished := True
				    end

						-- effectiveness checking finished
			        is_checking_effectiveness := False
    			end
		    elseif is_checking_validity then
				syncronize_evaluators

				if not is_stop_requested and then evaluators.is_empty then
   						-- collect effective fixes when evaluation finishes
   					evaluation_results.collect_fixes_good_for_tests (fixes_under_evaluation, tests_under_evaluation)
				    valid_fixes := evaluation_results.last_good_fix_collection

					is_checking_validity := False

        				-- autoFix finished !!!
    			    is_finished := True
    			end
		    end

			if not is_successful then
					-- log
			    is_finished := True
			end

	        if is_stop_requested then
	            is_finished := True
	        end
		end

	stop_process
			-- <Precursor>
		local
		    l_logging_service: like logging_service
		    l_entry_factory: like log_entry_factory
		    l_report: STRING
		do
		    l_logging_service := logging_service
		    l_entry_factory := log_entry_factory

		    	-- build report
		    l_report := build_proposer_report

				-- report to user
			prompts.show_info_prompt (l_report, Void, Void)
			l_logging_service.log (l_entry_factory.make_info_entry (Msg_proposer_report_pre + l_report))

			test_map := old_test_map
			is_running := False
			is_finished := False
			is_stop_requested := False
			is_compiled := False
			is_successful := False
			internal_progress := 0

			valid_fixes := Void
			evaluation_results := Void
			l_logging_service.log (l_entry_factory.make_info_entry (Msg_finished_fix_proposer))

				-- finish logging
			l_logging_service.unregister_all
		end

	abort
			-- <Precursor>
			-- introduced in {TEST_EXECUTOR} to set internal data structure to meaningful state before stop.
			-- not used here, since no information should be reported unless the whole process has finished successfully.
		do
		end

feature -- Access

	fix_synthesizer: detachable AFX_FIX_SYNTHESIZER
			-- synthesizer task

	system_adjuster: detachable AFX_SYSTEM_ADJUSTER
			-- adjuster to adjust the system and apply the fixes

	old_test_map: like test_map
			-- original test map

	evaluation_results: detachable AFX_FIX_EVALUATION_RESULT
			-- storage for evaluation results

	fixes_under_evaluation: DS_LINEAR [AFX_FIX_INFO_I]
			-- fixes currently been evaluated

	tests_under_evaluation: DS_LINEAR [AFX_TEST]
			-- tests currently been evaluate

	valid_fixes: detachable DS_LINEAR [AFX_FIX_INFO_I]
			-- fixes passed all the tests

feature -- Status report

	is_checking_effectiveness: BOOLEAN
			-- check if the fixes could eliminate the failure

	is_checking_validity: BOOLEAN
			-- regression test, to see if a fix is valid

	is_running: BOOLEAN
			-- is process running?

	is_finished: BOOLEAN
			-- is process finished?

	is_successful: BOOLEAN
			-- is processing successful so far?

feature{AFX_SESSION} -- Progress report

	update_progress (a_delta: REAL)
			-- update the progress of process
		do
		    internal_progress := (internal_progress + a_delta).min(1.0)
		    log_info ("Internal_progress = " + internal_progress.out)
		end

feature -- Implementation

	prepare_for_evaluation
			-- prepare the executor for fix evaluation
		local
		    l_conf: AFX_FIX_PROPOSER_CONF_I
		    l_fix_count: INTEGER
		    l_test_count: INTEGER
		do
		    l_conf := session.conf

		    old_test_map := test_map

			l_test_count := l_conf.failing_tests.count + l_conf.regression_tests.count
			l_fix_count := repository.fixes.count

		    check global_test_id = l_test_count + 1 end
		    check global_fix_id = l_fix_count + 1 end

				-- shared evaluation id codec
		    codec.set_fix_count (l_fix_count.to_natural_32)
		    codec.set_test_count (l_test_count.to_natural_32)

		    evaluator_count := l_conf.evaluator_count

		    	-- `evaluation_results' for all evaluations
		    create evaluation_results.make (l_fix_count, l_test_count)

		    log_info (Msg_ready_for_evaluation_1 + l_fix_count.out + Msg_ready_for_evaluation_2 + l_test_count.out + Msg_ready_for_evaluation_3)
		end

	start_evaluation
			-- prepare for evaluating the effect of fixes in `a_fixes' to tests in `a_tests'
		local
		    l_session: like session
		    l_conf: AFX_FIX_PROPOSER_CONF_I
		    l_tests: DS_LINEAR [AFX_TEST]
		    l_fixes: DS_LINEAR [AFX_FIX_INFO_I]
		    l_codec: AFX_EVALUATION_ID_CODEC
		    l_evaluation_id_list: DS_ARRAYED_LIST[NATURAL]
		    l_test: AFX_TEST
		    l_fix: AFX_FIX_INFO_I
		    l_test_id: NATURAL
		    l_fix_id: NATURAL
		    l_evaluation_id: NATURAL
		do
		    l_session := session
		    check l_session /= Void end
		    l_conf := l_session.conf

		    l_tests := tests_under_evaluation
		    l_fixes := fixes_under_evaluation

				-- evaluation id encoder
			l_codec := codec
			check l_codec.is_valid end

				-- prepare test_map with customized test id
				-- one test for each [test, fix] tuple
				-- only FAILING tests would be considered now
				-- all fixes are considered
		    create test_map.make (l_tests.count * l_fixes.count)
		    create l_evaluation_id_list.make (l_tests.count * l_fixes.count)

		    from
		        l_tests.start
		    until
		        l_tests.after
		    loop
		        l_test := l_tests.item_for_iteration
		        l_test_id := l_test.test_id.to_natural_32
		        from
		            l_fixes.start
		        until
		            l_fixes.after
		        loop
		            l_fix := l_fixes.item_for_iteration
		            l_fix_id := l_fix.fix_id.to_natural_32

		            l_codec.encode_evaluation_id (l_test_id, l_fix_id)
		            l_evaluation_id := l_codec.last_evaluation_id
			        test_map.put (l_test.test, l_evaluation_id)
			        l_evaluation_id_list.force_last (l_evaluation_id)

			        l_fixes.forth
		        end
		        l_tests.forth
		    end
		    create assigner.make_from_list (l_evaluation_id_list)

		    initialize_evaluators

		    completed_tests_count := 0

		    log_info ((l_tests.count * l_fixes.count).out + Msg_evaluations_started)
		end

	retrieve_results (a_evaluator: attached TEST_EVALUATOR_CONTROLLER)
			-- <Precursor>
		local
			l_tuple: attached TUPLE [index: NATURAL; outcome: detachable EQA_TEST_RESULT; attempts: NATURAL]
			l_codec: detachable AFX_EVALUATION_ID_CODEC
			l_done, l_terminate: BOOLEAN
			l_test: detachable TEST_I
			l_outcome: EQA_TEST_RESULT
			l_id: NATURAL_32
			l_test_index, l_fix_index: NATURAL_32
		do
			from
			until
				l_done
			loop
				l_terminate := False
				l_tuple := a_evaluator.status.fetch_progress
				if l_tuple.index /= 0 then
				    l_id := l_tuple.index

				    	-- decode test index and fix index
				    l_codec := codec
				    check l_codec /= Void end
				    l_codec.decode_evaluation_id (l_id)
				    l_test_index := l_codec.last_test_id
				    l_fix_index := l_codec.last_fix_id

					test_map.search (l_id)
					if test_map.found and not assigner.is_aborted (l_id) then
						l_test := test_map.found_item
						check l_test /= Void end -- implied by `found'
						l_outcome := l_tuple.outcome
						if l_outcome /= Void then
							completed_tests_count := completed_tests_count + 1

								-- put result into `evaluation_results'
							evaluation_results[l_fix_index.to_integer_32, l_test_index.to_integer_32] := l_outcome
							update_progress (delta_progress)

							log_info (Msg_evaluation_result_1 + l_fix_index.out + Msg_evaluation_result_2 + l_test_index.out
										+ Msg_evaluation_result_3 + (l_outcome /= Void and then l_outcome.is_pass).out)
						end
					else
							-- If map does not contain test, we could terminate here. However if the evaluator has
							-- already produced a result, we simply won't propagate it and let it execute the next
							-- test in the queue.
						l_terminate := True
					end
					l_done := l_tuple.outcome = Void
				else
					l_done := True
				end
			end
			if l_terminate then
				a_evaluator.status.set_forced_termination
				a_evaluator.terminate
			end
		end

	build_proposer_report: STRING
			-- build the report of proposer processor
		require
		    is_finished: is_finished
		local
		    l_output: STRING
		    l_valid_fixes: detachable like valid_fixes
		    l_fix: AFX_FIX_INFO_I
		do
		    create l_output.make_empty
		    l_valid_fixes := valid_fixes

		    if is_stop_requested then
		        l_output := "Fix proposer canceled by user."
		    elseif not is_successful then
		        l_output := "Internal error, fix proposer failed."
		    elseif l_valid_fixes = Void or else l_valid_fixes.is_empty then
		        l_output := "Fix proposer did not find any valid fixes."
		    else
		        check valid_fixes /= Void and then not valid_fixes.is_empty end
		        l_output.append (l_valid_fixes.count.out + " valid fix(es) found:%N")

    		    from l_valid_fixes.start
    		    until l_valid_fixes.after
    		    loop
    		        l_fix := l_valid_fixes.item_for_iteration
    		        l_fix.build_fix_report
    		        l_output.append (l_fix.last_fix_report)
    		        l_valid_fixes.forth
    		    end
		    end

			Result := l_output
		end

	delta_progress: REAL
			-- delta progress we are making for each step

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
