indexing
	description: "System Level Test for the capture/replay example application"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TEST_CAPTURE_REPLAY

inherit
	TS_TEST_CASE
	redefine
		set_up,
		tear_down
	end

feature -- Helpers
	set_up
			-- Set up the environment
		do
		end

	tear_down
			-- tear down the environment.
		do
		end

feature -- Testing the tests:

	test_testing --just for experiments
		do
		end


	test_run_recording_application is
			--Run the example application in recording mode.
		local
			command: DP_SHELL_COMMAND
		do
			--activate recording
			create command.make("export CR_MODE=capture &&" + example_application_path)
			command.execute
			assert_equal ("record run succeeded",0, command.exit_code)
		end

	test_run_replaying_application is
			--Run the example application in recording mode.
		local
			command: DP_SHELL_COMMAND
		do
			--activate recording
			create command.make("export CR_MODE=log_replay &&" + example_application_path)
			command.execute
			assert_equal ("replay run succeeded",0, command.exit_code)
		end

feature {NONE} -- Implementation

	example_application_path: STRING is "EIFGENs/application/W_code/application"

invariant
	invariant_clause: True -- Your invariant here

end
