indexing
	description: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_CLASS

inherit
	OBSERVABLE
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
			caller: EXAMPLE_CALLER
			config: CONFIGURATION_HELPER

			bank: BANK
			atm: ATM
			ui: ATM_UI
			test_performance: BOOLEAN
			ignore_result: ANY
		do
			--Initialize the rest of the PROGRAM_FLOW_SINK:
			create caller
			create config.make (caller)
			config.configure_program_flow_sink (program_flow_sink)
			player ?= program_flow_sink
			if player /= Void then
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
	is_observed: BOOLEAN is False

-- Modes for the example application:

invariant
		-- from OBSERVABLE
	invariant_clause: True

end -- class ROOT_CLASS

