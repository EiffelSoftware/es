indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION_RUNNER

create
	make

feature -- Initialization

	make is
			-- run the example application in performance - testing mode...
		local
			bank: BANK
			atm: ATM
			ui: ATM_UI
			recorder: RECORDER
			log_player: LOGGING_PLAYER
			caller: EXAMPLE_CALLER
		do
			--XXX this should vanish with the next interface change...
			recorder ?= program_flow_sink
			log_player ?= program_flow_sink
			if recorder /= Void then
				print("APPLICATION_RUNNER: Record phase detected.")
				recorder.setup_on_text_serializer ("run.log")
				create bank.make
				atm := bank.atm
				create {PERFORMANCE_TESTER_ATM_UI} ui.make (atm)
				atm.set_ui (ui)
				ui.run
			elseif log_player /= Void then
				print("APPLICATION_RUNNER: Replay phase detected.")
				create caller
				log_player.setup_on_text_files ("run.log", "replay_run.log",caller)
				log_player.play
			end
		end

end -- class APPLICATION_RUNNER
