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
		export{AFX_FIX_APPLIER}
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

	AFX_SHARED_TEST_ID_CODEC

	AFX_SHARED_SESSION

	SHARED_AFX_FIX_REPOSITORY

	ES_SHARED_PROMPT_PROVIDER

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
		    l_error_handler: AFX_ERROR_PRINTER
		    l_session: AFX_SESSION
		do
				-- create and share the session information
			create l_error_handler.make_standard
			l_error_handler.config (a_conf)
			l_error_handler.start_logging

			create l_session.make (a_conf, Current, l_error_handler)
			set_session (l_session)

			codec.set_test_count ((a_conf.failing_tests.count + a_conf.regression_tests.count).to_natural_32)

			create generator_task.make
			generator_task.start

			is_running := True
			is_compiled := False
		end

	proceed_process
			-- <Precursor>
		local
		    l_potential_fixes, l_valid_fixes: DS_LINEAR [AFX_FIX_INFO_I]
		    l_fix: AFX_FIX_INFO_I
		    l_output: STRING
		do
		        if attached generator_task as l_generator then
		            if is_stop_requested then
		                	-- TODO: anything else here ??
		                generator_task := Void
		            else
    		        	if l_generator.is_finished then
    			            l_generator.stop

    			            if l_generator.is_successful and then repository.is_healthy then
    			                create applier_task.make
    			                applier_task.start
    			            else
    			                is_finished := True
    			            end

    			          	generator_task := Void
    			        else
    			            l_generator.step
    			        end
		            end

			    elseif attached applier_task as l_applier then
		            if is_stop_requested then
		                	-- TODO: anything else here ??
		                applier_task := Void
		            else
    			        if l_applier.is_finished then
    			            l_applier.stop

    			            if l_applier.is_successful and repository.is_healthy then
    			                	-- prepare for fix evaluation
    			                start_effectiveness_checking
    							is_checking_effectiveness := True
    						else
    						    is_finished := True
    			            end

    			            applier_task := Void
    			        else
    			            l_applier.step
    			        end
    			    end
			    elseif is_checking_effectiveness then
			        	-- synchronize evaluators, retrieve results, and cancel process when `is_stop_requested'
					syncronize_evaluators

					if not is_stop_requested and then evaluators.is_empty then
	   						-- collect effective fixes when evaluation finishes
   					    l_potential_fixes := collect_potential_fixes
   					    if not l_potential_fixes.is_empty then
   					        prompts.show_info_prompt ("Effectiveness-check finished, starting validity checking...", Void, Void)
   					        	-- start fix validation
   					        start_validity_checking (l_potential_fixes)
   					        is_checking_validity := True
   					    else
   					        prompts.show_info_prompt ("Effectiveness-check finished, no potential fix found.", Void, Void)
   					        is_finished := True
   					    end

							-- effectiveness checking finished
				        is_checking_effectiveness := False
    				end
			    elseif is_checking_validity then
			        	-- synchronize evaluators, retrieve results, and cancel process when `is_stop_requested'
					syncronize_evaluators

					if not is_stop_requested and then evaluators.is_empty then
	   						-- collect effective fixes when evaluation finishes
   					    l_valid_fixes := collect_valid_fixes

   					    create l_output.make_empty
						from l_valid_fixes.start
						until l_valid_fixes.after
						loop
						    l_fix := l_valid_fixes.item_for_iteration
						    l_output.append (l_fix.fix_report + "%N")

						    l_valid_fixes.forth
						end

						if l_output.is_empty then
						    l_output := "No valid fix found."
						else
						    l_output := "Valid fix found: %N" + l_output
						end
						prompts.show_info_prompt (l_output, Void, Void)

						is_checking_validity := False

        					-- autoFix finished !!!
    				    is_finished := True
    				end
		        end

		        if is_stop_requested then
		            is_finished := True
		        end
		end

	stop_process
			-- <Precursor>
		do
			test_map := old_test_map
			is_running := False
			is_finished := False
			is_stop_requested := False
			is_compiled := False

			evaluation_results := Void
		end

	abort
			-- <Precursor>
		do

		end

feature -- Access

	generator_task: detachable AFX_FIX_GENERATOR
			-- fix generator

	applier_task: detachable AFX_FIX_APPLIER
			-- fix applier

	old_test_map: like test_map
			-- original test map

	evaluation_results: detachable AFX_FIX_EVALUATION_RESULT
			-- storage for evaluation results

feature -- Status report

	is_checking_effectiveness: BOOLEAN
			-- check if the fixes could eliminate the failure

	is_checking_validity: BOOLEAN
			-- regression test, to see if a fix is valid

	is_running: BOOLEAN
			-- is process running?

	is_finished: BOOLEAN
			-- is process finished?

feature -- Operation

	start_effectiveness_checking
			-- launch executors to see whether a fix can eliminate the failure
		local
		    l_session: like session
		    l_conf: AFX_FIX_PROPOSER_CONF_I
		    l_cursor: DS_LINEAR_CURSOR [attached TEST_I]
		    l_list: attached DS_ARRAYED_LIST[attached TEST_I]
		    l_sorter: DS_QUICK_SORTER [attached TEST_I]
		    l_comparator: TAG_COMPARATOR [attached TEST_I]
		    l_repository: like repository
		    l_codec: AFX_TEST_ID_CODEC
		    l_fixes: DS_LINEAR [AFX_FIX_INFO_I]

		    l_test_index: INTEGER
		    l_fix_index: INTEGER

		    l_fix_count: INTEGER
		    l_test_count: INTEGER

		    l_test_id: NATURAL
		    l_test_id_list: DS_ARRAYED_LIST[NATURAL]
		do
			l_session := session
			check l_session /= VOid end
			l_conf := l_session.conf

			create l_test_id_list.make_default

				-- save the old test map, so that they can be restored after evaluation
		    old_test_map := test_map

		    	-- TODO: do we need to sort tests ??
		    create l_list.make_from_linear (l_conf.failing_tests)
		    create l_comparator.make (l_conf.sorter_prefix)
		    create l_sorter.make (l_comparator)
		    l_list.sort (l_sorter)

				-- list of all fixes
			l_repository := repository
			check l_repository /= Void end
			l_fixes := l_repository.fixes

				-- test id encoder
			l_codec := codec
			check l_codec.is_valid end

				-- although only failing tests are run in this step, the test id is computed on the basis of all tests and fixes
			l_test_count := l_conf.failing_tests.count + l_conf.regression_tests.count
			l_fix_count := l_fixes.count

			check l_test_count = codec.test_count.to_integer_32 and l_fix_count = codec.fix_count.to_integer_32 end

				-- prepare test_map with customized test id
				-- one test for each [test, fix] tuple
				-- only FAILING tests would be considered now
				-- all fixes are considered
		    create test_map.make (l_list.count * l_fix_count)
		    from
		        l_cursor := l_list.new_cursor
		        l_cursor.start
		        l_test_index := 1
		    until
		        l_cursor.after
		    loop
		        from
		            l_fixes.start
		        until
		            l_fixes.after
		        loop
		            l_fix_index := l_fixes.item_for_iteration.id
		            l_codec.encode_test_id (l_test_index.to_natural_32, l_fix_index.to_natural_32)
		            l_test_id := l_codec.last_test_id
			        test_map.force_last (l_cursor.item, l_test_id)
			        l_test_id_list.force_last (l_test_id)

			        l_fixes.forth
		        end
		        l_cursor.forth
		        l_test_index := l_test_index + 1
		    end

		    create assigner.make_from_list (l_test_id_list)

		    	-- `evaluation_results' for all evaluations
		    create evaluation_results.make(l_fix_count.to_integer_32, l_test_count.to_integer_32)

		    evaluator_count := l_conf.evaluator_count
		    initialize_evaluators

		    completed_tests_count := 0
		end

	start_validity_checking (a_potential_fixes: DS_LINEAR [AFX_FIX_INFO_I])
			-- launch executors to see whether potential fixes can pass the regression test
		local
		    l_session: like session
		    l_conf: AFX_FIX_PROPOSER_CONF_I
		    l_cursor: DS_LINEAR_CURSOR [attached TEST_I]
		    l_list: attached DS_ARRAYED_LIST[attached TEST_I]
		    l_sorter: DS_QUICK_SORTER [attached TEST_I]
		    l_comparator: TAG_COMPARATOR [attached TEST_I]
		    l_repository: like repository
		    l_codec: AFX_TEST_ID_CODEC
		    l_fixes: DS_LINEAR [AFX_FIX_INFO_I]

		    l_test_index_offset: INTEGER
		    l_fix_index: INTEGER
		    l_test_index: INTEGER

		    l_fix_count: INTEGER
		    l_test_count: INTEGER

		    l_test_id: NATURAL
		    l_test_id_list: DS_ARRAYED_LIST[NATURAL]
		do
			l_session := session
			check l_session /= VOid end
			l_conf := l_session.conf

				-- index offset of regression tests
			l_test_index_offset := l_conf.failing_tests.count

		    	-- sort tests
		    create l_list.make_from_linear (l_conf.regression_tests)
		    create l_comparator.make (l_conf.sorter_prefix)
		    create l_sorter.make (l_comparator)
		    l_list.sort (l_sorter)

				-- list of all fixes
			l_repository := repository
			check l_repository /= Void end
			l_fixes := l_repository.fixes

				-- test id encoder
			l_codec := codec
			check l_codec /= Void end

				-- although only failing tests are run in this step, the test id is computed on the basis of all tests and fixes
			l_test_count := l_conf.failing_tests.count + l_conf.regression_tests.count
			l_fix_count := l_fixes.count

				-- prepare test_map with customized test id
				-- one test for each [test, fix] tuple
				-- only REGRESSION tests are considered now
				-- only fixes in `a_potential_fixes' are considered
		    create test_map.make (l_list.count * a_potential_fixes.count)
		    create l_test_id_list.make (l_list.count * a_potential_fixes.count)
		    from
		        l_cursor := l_list.new_cursor
		        l_cursor.start
		        l_test_index := l_test_index_offset + 1
		    until
		        l_cursor.after
		    loop
		        from
		            a_potential_fixes.start
		        until
		            a_potential_fixes.after
		        loop
		            l_fix_index := a_potential_fixes.item_for_iteration.id
		            l_codec.encode_test_id (l_test_index.to_natural_32, l_fix_index.to_natural_32)
		            l_test_id := l_codec.last_test_id
			        test_map.force_last (l_cursor.item, l_test_id)
			        l_test_id_list.force_last (l_test_id)

			        a_potential_fixes.forth
		        end
		        l_cursor.forth
		        l_test_index := l_test_index + 1
		    end

		    create assigner.make_from_list (l_test_id_list)

		    evaluator_count := l_conf.evaluator_count
		    initialize_evaluators

		    completed_tests_count := 0
		end

	retrieve_results (a_evaluator: attached TEST_EVALUATOR_CONTROLLER)
			-- <Precursor>
		local
			l_tuple: attached TUPLE [index: NATURAL; outcome: detachable EQA_TEST_RESULT; attempts: NATURAL]
			l_codec: detachable AFX_TEST_ID_CODEC
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
				    l_codec.decode_test_id (l_id)
				    l_test_index := l_codec.last_test_index
				    l_fix_index := l_codec.last_fix_index

					test_map.search (l_id)
					if test_map.found and not assigner.is_aborted (l_id) then
						l_test := test_map.found_item
						check l_test /= Void end -- implied by `found'
						l_outcome := l_tuple.outcome
						if l_outcome /= Void then
							completed_tests_count := completed_tests_count + 1

								-- put result into `evaluation_results'
							evaluation_results[l_fix_index.to_integer_32, l_test_index.to_integer_32] := l_outcome
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

feature -- Implementation

	collect_potential_fixes: DS_LINEAR [AFX_FIX_INFO_I]
			-- collect the fixes which removed the failure
		local
		    l_session: like session
		    l_conf: AFX_FIX_PROPOSER_CONF_I
		    l_min_test_index, l_max_test_index: NATURAL_32
		    l_repository: like repository
		do
		    l_session := session
		    check l_session /= Void end
		    l_conf := l_session.conf

		    l_min_test_index := 1
		    l_max_test_index := l_conf.failing_tests.count.to_natural_32

		    l_repository := repository
		    check l_repository /= Void end

		    Result := evaluation_results.collect_fixes_good_for_tests (l_repository.fixes, l_min_test_index, l_max_test_index)
		end

	collect_valid_fixes: DS_LINEAR [AFX_FIX_INFO_I]
			-- collect and return the valid fixes
		local
		    l_session: like session
		    l_conf: AFX_FIX_PROPOSER_CONF_I
		    l_min_test_index, l_max_test_index: NATURAL_32
		    l_repository: like repository
		do
		    l_session := session
		    check l_session /= Void end
		    l_conf := l_session.conf

				-- check the results of all tests
		    l_min_test_index := 1
		    l_max_test_index := (l_conf.failing_tests.count + l_conf.regression_tests.count).to_natural_32

		    l_repository := repository
		    check l_repository /= Void end

		    Result := evaluation_results.collect_fixes_good_for_tests (l_repository.fixes, l_min_test_index, l_max_test_index)
		end

--feature {NONE} -- Status report

--	relaunch_evaluators: BOOLEAN = True
--			-- <Precursor>

--feature {NONE} -- Status setting

--	compile_project
--			-- <Precursor>
--		do
--			Precursor
--				-- TODO: copy wkbench executable to separate directory
--		end

feature -- To be removed

	arbitor: AFX_FIX_SELECTION_ARBITOR

	evaluator: AFX_FIX_EVALUATION_ROOT

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
