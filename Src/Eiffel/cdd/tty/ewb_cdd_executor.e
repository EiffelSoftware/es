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
			l_output: PROCEDURE [ANY, TUPLE [STRING]]
			l_err: PROCEDURE [ANY, TUPLE]
			l_tested: PROCEDURE [ANY, TUPLE [CDD_TEST_ROUTINE]]
			l_executing: BOOLEAN
		do
			if cdd_manager.is_cdd_enabled then
				l_executor := cdd_manager.background_executor

					-- Create and register testing action handlers
				l_output := agent io.put_string
				l_tested := agent print_test_case_outcome
				l_err := agent io.put_string ("Testing was terminated because of some error%N")

				l_executor.output_actions.extend (l_output)
				l_executor.finished_testing_routine_actions.extend (l_tested)
				l_executor.error_actions.extend (l_err)

				io.put_string ("Compiling interpreter...%N")
				from
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
				l_executor.output_actions.prune (l_output)
				l_executor.finished_testing_routine_actions.prune (l_tested)
				l_executor.error_actions.prune (l_err)
			else
				io.put_string ("CDD is currently not enabled. To create%N, view or run test cases enable CDD through `Status' menu.")
			end
		end

feature {NONE} -- Implementation

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
