indexing
	description: "Objects that ..."
	author: ""
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

--Hint: as the Object Identifiers are written to the logfiles, too, don't allocate more
-- objects on set_up, as it would break all solution log files (the generated ones are compared against)

feature -- Helpers
	set_up
			-- Set up the environment
		do
		end

	tear_down
			-- tear down the environment.
		do
			-- this is already done in the test cases, so it's possible to compare the files
		end

feature -- Testing the tests:

	test_testing --just for experiments
		do
		end

	test_recording
		local
			recorder: RECORDER
			proxy: PROGRAM_FLOW_SINK_PROXY
			bank: BANK
			atm: ATM
			ui: ATM_UI
		do
--			--start recording, set up the example application and start it.
--			create recorder.make
--			recorder.setup_on_text_serializer ("run.log")
--			recorder.enter --no recording before application starts
--			proxy ?= program_flow_sink
--			assert ("program_flow_sink is a proxy", proxy /= Void)

--			proxy.set_sink (recorder)
--			proxy.leave
--			create bank.make
--			atm := bank.atm
--			create {PERFORMANCE_TESTER_ATM_UI} ui.make (atm)
--			atm.set_ui (ui)
--			ui.run
--			proxy.enter
		end

	test_replay is
			--
		local
			proxy: PROGRAM_FLOW_SINK_PROXY
			logging_player: LOGGING_PLAYER
			caller: EXAMPLE_CALLER
		do
			create caller
			create logging_player.make
			logging_player.setup_on_text_files ("run.log", "replay_run.log", caller)
			logging_player.enter
			proxy ?= program_flow_sink
			assert("program_flow_sink is a proxy", proxy /= Void)

			proxy.set_sink(logging_player)
			logging_player.leave
			logging_player.play
			logging_player.enter
		end


feature -- Access

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
