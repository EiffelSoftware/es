indexing
	description: "Objects that provide a command line interface for executing test cases"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_CDD_EXECUTOR

inherit

	EWB_CDD_CMD

	THREAD_CONTROL
		export {NONE} all end

feature -- Access

	name: STRING is "Run"

	help_message: STRING is "Run all test cases in system"

	abbreviation: CHARACTER is 'r'

feature -- Execution

	execute is
			-- Execute all test cases.
		local
			l_executor: CDD_TEST_EXECUTOR
			l_tested: PROCEDURE [ANY, TUPLE [DS_LINEAR [CDD_TEST_ROUTINE_UPDATE]]]
			l_executing: BOOLEAN
			output_agent: PROCEDURE [ANY, TUPLE [STRING]]
		do
			if cdd_manager.is_project_initialized then
				l_executor := cdd_manager.background_executor

					-- Create and register testing action handlers
				l_tested := agent filter_updates

				cdd_manager.test_suite.test_routine_update_actions.extend (l_tested)
				output_agent := agent io.put_string
				cdd_manager.output_actions.extend (output_agent)

				io.put_string ("Compiling interpreter...%N")
				from
    -- TODO: what to do with the next line? Do we need it or not?				
	--				l_executor.cancel
					l_executor.start
				until
					not l_executor.has_next_step
				loop
					if l_executor.is_executing and not l_executing then
						io.put_string ("Running test routines...%N")
						l_executing := True
					end
					l_executor.step
					sleep (3000)
				end
				io.put_string ("Done...%N")

					-- Remove action handlers
				cdd_manager.test_suite.test_routine_update_actions.prune (l_tested)
				cdd_manager.output_actions.prune (output_agent)
			else
				io.put_string ("Please compile project first")
			end
		end

feature {NONE} -- Implementation

	filter_updates (an_update_list: DS_LINEAR [CDD_TEST_ROUTINE_UPDATE]) is
			-- Call `print_test_case_outcome' for all new outcome updates in `an_update_list'.
		require
			an_update_list_not_void: an_update_list /= Void
			an_update_list_vali: not an_update_list.has (Void)
		local
			l_cursor: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE_UPDATE]
		do
			l_cursor := an_update_list.new_cursor
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				if l_cursor.item.is_changed then
					print_test_case_outcome (l_cursor.item.test_routine)
				end
				l_cursor.forth
			end
		end

	print_test_case_outcome (a_test_routine: CDD_TEST_ROUTINE) is
			-- Print the last outcome of `a_test_routine'.
		require
			a_test_routine_not_void: a_test_routine /= Void
			has_outcome: not a_test_routine.outcomes.is_empty
		local
			l_last: CDD_TEST_EXECUTION_RESPONSE
		do
			l_last := a_test_routine.outcomes.last
			io.put_string (a_test_routine.test_class.test_class_name + "." + a_test_routine.name + "%N")
			io.put_string ("%TSetup ")
			print_response (l_last.setup_response)
			if not l_last.setup_response.is_bad then
				io.put_string ("%TTest ")
				print_response (l_last.test_response)
				if not l_last.test_response.is_bad then
					io.put_string ("%TTeardown ")
					print_response (l_last.teardown_response)
				end
			end
			io.put_string ("%N")
		end

	print_response (a_response: CDD_ROUTINE_INVOCATION_RESPONSE) is
			-- Print results of `a_response'.
		require
			a_response_not_void: a_response /= Void
		do
			if a_response.is_bad then
				io.put_string ("(bad)%N")
			else
				if a_response.is_normal then
					io.put_string ("(normal)%N")
				else
					io.put_string ("(exceptional)%N")
					io.put_string ("%T%Treason:  " + meaning (a_response.exception.exception_code) + "%N")
					io.put_string ("%T%Ttag:     " + a_response.exception.exception_tag_name + "%N")
					io.put_string ("%T%Tclass:   " + a_response.exception.exception_class_name + "%N")
					io.put_string ("%T%Tfeature: " + a_response.exception.exception_recipient_name + "%N")
					-- TODO: Why is below line commented out?
					--io.put_string ("%T%Tmessage: " + a_response. + "%N")
				end
			end
		end

end
