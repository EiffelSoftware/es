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
			ignore_result: ANY
		do
			create caller
			create configurator.make(caller)
			configurator.configure_program_flow_sink (program_flow_sink)
			player ?= program_flow_sink
			if player /= Void then
				player.play
			end
			-- <methodbody_start name="make" args="[]">
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				program_flow_sink.put_feature_invocation("make", Current, [])
				program_flow_sink.leave
			end
			if (not program_flow_sink.is_replay_phase) or is_observed then
			-- </methodbody_start>
				create observed_object.make
				if not observed_object.is_literal_string_correct then
					report_error("literal string incorrect")
				end
				if not observed_object.is_string_from_file_correct then
					report_error("string from file incorrect")
				end
			-- <methodbody_end return_value="False">
			end
			if program_flow_sink.is_capture_replay_enabled then
				program_flow_sink.enter
				ignore_result ?= program_flow_sink.put_feature_exit(Void)
				program_flow_sink.leave
			end
			-- </methodbody_end>
		end

feature {NONE} -- Implementation
	report_error(message: STRING) is
			-- Report an Error with message `message'
		do
			exceptions.raise(message)
		end


	exceptions: EXCEPTIONS is
			-- standard EXCEPTIONS instance
		once
			create Result
		ensure
			result_not_void: Result /= Void
		end

end -- class APPLICATION
