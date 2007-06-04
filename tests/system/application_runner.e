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
			config: CONFIGURATION_HELPER
			bank: BANK
			atm: ATM
			ui: ATM_UI
			recorder: RECORDER
			player: PLAYER
			caller: EXAMPLE_CALLER
		do
			create caller
			create config.make(caller)
			config.configure_program_flow_sink (program_flow_sink)
			player ?= program_flow_sink
			if player /= Void then
				player.play
				player.enter
				if player.has_error then
					exceptions.raise("Replay finished with error.")
				end
			end
--			if recorder /= Void then
--				print("APPLICATION_RUNNER: Record phase detected.")
--				recorder.setup_on_text_serializer ("run.log")
--				create bank.make
--				atm := bank.atm
--				create {PERFORMANCE_TESTER_ATM_UI} ui.make (atm)
--				atm.set_ui (ui)
--				ui.run
--			elseif log_player /= Void then
--				print("APPLICATION_RUNNER: Replay phase detected.")
--				create caller
--				log_player.setup_on_text_files ("run.log", "replay_run.log",caller)
--				log_player.play
--			end
		end

feature {NONE}

	exceptions: EXCEPTIONS is
			--
		once
			create Result
		end


end -- class APPLICATION_RUNNER
