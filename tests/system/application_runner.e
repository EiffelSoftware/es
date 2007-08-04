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
		do
			create config.make
			config.configure_program_flow_sink (program_flow_sink)
			program_flow_sink.enter
			player ?= program_flow_sink
			recorder ?= program_flow_sink
            if recorder /= Void then
                             print("APPLICATION_RUNNER: Record phase detected.")
                             recorder.leave
                             create bank.make
                             atm := bank.atm
                             create {PERFORMANCE_TESTER_ATM_UI} ui.make (atm)
                             atm.set_ui (ui)
                             ui.run
			elseif player /= Void then
				print("APPLICATION_RUNNER: replay phase detected.")
				player.leave
				player.play
				player.enter
				if player.has_error then
					exceptions.raise("Replay finished with error.")
				end
			end
		end

feature {NONE}

	exceptions: EXCEPTIONS is
			--
		once
			create Result
		end


end -- class APPLICATION_RUNNER
