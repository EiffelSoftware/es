indexing
	description: "Configures the Replay System"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	REPLAY_BUILDER

create
	make

feature -- Initialization

	make is
			-- Initialize a REPLAY_BUILDER
		do
			player ?= program_flow_sink
			if player = Void then
				report_and_set_error("Player not found. Maybe Replay is not activated?")
			end
		end


feature -- Access

	has_error: BOOLEAN
		-- Did an error occur during the last operation?

	error_message: STRING
		-- Description of the error.

	log: STRING

	is_prepared_for_replay: BOOLEAN is
			-- Are all the parameters prepared, so that replay can be started?
		do
			Result := log /= Void
		end

feature -- Basic Operations

	read_replay_log_from_string (a_log: STRING) is
			-- Make replay use `a_log'.
		require
			a_log_not_void: a_log /= Void
		do
			log := a_log
		ensure
			log_set:  log = a_log
		end

	start_replay is
			-- Start the replay of the given log.
		require
			no_error: not has_error
			is_prepared_for_replay: is_prepared_for_replay
			is_in_replay_mode: program_flow_sink.is_replay_phase
		local
			erl_caller: ERL_CALLER
		do
			create erl_caller
			player.setup_on_string (log, erl_caller)
			check False end --TODO implement
		end

	register_object(an_object: ANY; id: INTEGER)
			-- Make `an_object' known as object with id `id'
		require
			an_object_not_void: an_object /= Void
			id_valid: id > 0
		do
			player.resolver.associate_object_to_object_id(an_object, id)
		end

feature {NONE} -- Implementation

	report_and_set_error(message: STRING) is
			-- Report `message' and set `has_error'
		require
			message_not_void: message /= Void
		do
			has_error := True
			error_message := message
		end


	player: PLAYER
			-- The player that is responsible for the replay.

invariant
	valid_error_message: has_error implies error_message /= Void
	player_set_or_error: not has_error implies player /= Void

end
