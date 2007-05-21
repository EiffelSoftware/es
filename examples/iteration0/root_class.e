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
			--Initialize the rest of the PROGRAM_FLOW_SINK:
			-- XXX is there a better way to do it? Problem:
			-- at least caller can't be known in ANY, because it
			-- depends on the application.
			recorder ?= program_flow_sink
			if recorder /= Void then
				recorder.setup_on_text_serializer ("run.log")
			end
			player ?= program_flow_sink
			logging_player ?= program_flow_sink
			if logging_player /= Void then
				create caller
				logging_player.setup_on_text_files ("run.log", "replay_run.log", caller)
				logging_player.play
			elseif player /= Void then
				create caller
				player.setup_on_text_file ("run.log", caller)
				player.play
			end


			test_performance := False


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

