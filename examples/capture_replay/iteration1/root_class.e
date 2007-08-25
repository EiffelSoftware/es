indexing
	description: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_CLASS

inherit
	ANY
	redefine
		is_observed
	end

create
	make

feature -- Initialization

	make
			-- Creation procedure.
		local
			player: PLAYER
			--caller: EXAMPLE_CALLER
			config: CONFIGURATION_HELPER
			bank: BANK
			atm: ATM
			ui: ATM_UI
			test_performance: BOOLEAN
		do
			--Initialize the rest of the PROGRAM_FLOW_SINK:
--			create caller
			create config.make
--no. use erl_g to call...			config.set_caller(caller)
			config.configure_program_flow_sink (program_flow_sink)
			player ?= program_flow_sink
			if player /= Void then
				player.play
				program_flow_sink.enter --avoid unnecessary events at the end of replay...
			else
				test_performance := False
				create bank.make
				atm := bank.atm
				if test_performance then
					create {PERFORMANCE_TESTER_ATM_UI} ui.make (atm)
					atm.set_ui (ui)
				else
					ui := atm.ui
				end
				ui.run
			end
		end

feature --Access
	is_observed: BOOLEAN is False

invariant
	invariant_clause: True

end -- class ROOT_CLASS

