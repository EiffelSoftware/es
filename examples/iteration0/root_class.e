indexing
	description: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_CLASS

inherit
	OBSERVABLE

create
	make

feature -- Initialization

	make
			-- Creation procedure.
		local
			recorder: RECORDER
			player: PLAYER
			logging_player: LOGGING_PLAYER

			caller: EXAMPLE_CALLER

			bank: BANK
			atm: ATM
			ui: ATM_UI
			mode: INTEGER_32
			test_performance: BOOLEAN
			ignore_result: ANY
		do
		-- Start of C/R setup
			mode := Replay_logged
--			mode := Capture
			inspect mode
			when capture then
				create recorder.make
				recorder.setup_on_text_serializer ("run.log")
			when replay_simple then
				create player.make
				create caller
				player.setup_on_text_file ("run.log", caller)
				player.play
			when replay_logged then
				create logging_player.make
				create caller
				logging_player.setup_on_text_files ("run.log", "replay_run.log", caller)
				logging_player.play
			when performance_test_normal then
				create recorder.make --run with not set-up recorder == without instrumentation.
				test_performance := True
			when performance_test_capture then
				create recorder.make
				recorder.setup_on_text_serializer ("run.log")
				test_performance := True
			else
				print ("executing a normal run of the application.")
			end
			test_performance := False
			-- End of C/R Setup




			-- <methodbody_start name="make" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("make", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				create bank.make
				atm := bank.atm
				if test_performance then
					create {PERFORMANCE_TESTER_ATM_UI} ui.make (atm)
					atm.set_ui (ui)
				else
					ui := atm.ui
				end
				ui.run
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

feature --Access
-- Modes for the example application:

	capture: INTEGER_32 is unique

	normal_run: INTEGER_32 is unique

	performance_test_capture: INTEGER_32 is unique

	performance_test_normal: INTEGER_32 is unique

	replay_logged: INTEGER_32 is unique

	replay_simple: INTEGER_32 is unique

invariant
		-- from OBSERVABLE
	invariant_clause: True

end -- class ROOT_CLASS

