indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ANY
	redefine
		is_observed
	end

create
	make

feature -- Access
	is_observed: BOOLEAN is False

feature -- Initialization

	make is
			-- Creation procedure.
		local
			observed_object: OBSERVED_CLASS
			configurator: CONFIGURATION_HELPER
			player: PLAYER
			caller: APPLICATION_CALLER
		do
			create caller
			create configurator.make
			configurator.set_caller (caller)
			configurator.configure_program_flow_sink (program_flow_sink)
			player ?= program_flow_sink
			if player /= Void then
				player.play
				program_flow_sink.enter
			else
				create observed_object.make
				observed_object.check_literal_string_from_unobserved
				observed_object.check_string_from_file
				program_flow_sink.enter --we're not interested in the events that occur during cleanup.
			end
		end

feature {NONE} -- Implementation

end -- class APPLICATION
