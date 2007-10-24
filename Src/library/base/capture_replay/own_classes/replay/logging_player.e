indexing
	description: "Event Sink for replay that writes a log while replaying."
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	LOGGING_PLAYER

inherit
	PLAYER
	rename
		setup_on_text_file as setup_player_on_textfile
	redefine
		put_feature_exit,
		put_feature_invocation,
		accept
	end

create
	make

feature -- Initialization

	setup_on_text_files(replay_filename:STRING; log_filename: STRING; a_caller: CALLER) is
			-- Set up the player for replay from `replay_filename', logging to `log_filename' using
			-- `a_caller' to execute calls.
		require
			replay_filename_not_void: replay_filename /= Void
			log_filename_not_void: log_filename /= Void
			a_caller_not_void: a_caller /= Void
		do
			create recorder.make
			recorder.setup_on_text_serializer (log_filename)
			setup_player_on_textfile (replay_filename,a_caller)
		ensure
			capture_replay_enabled: is_capture_replay_enabled
			replay_phase_enabled: is_replay_phase
		end

feature -- Access
	recorder: RECORDER
		-- The recorder to record the events.

feature -- Status setting
	set_recorder(a_recorder: RECORDER) is
			-- Set `recorder'
		require
			a_recorder_not_void: a_recorder /= Void
		do
			recorder := a_recorder
		end

feature -- Basic operations
		put_feature_invocation (feature_name: STRING_8; target: ANY; arguments: TUPLE) is
				--
			do
				-- XXX invoking the recorder at this position leads to incorrect object ID's
				recorder.put_feature_invocation(feature_name,target,arguments)
				Precursor {PLAYER}(feature_name, target, arguments)
			end

		put_feature_exit (res: ANY): ANY is
				--
			local
				ignore_result: ANY
			do
				Result := Precursor {PLAYER}(res)
					-- Invoking the recorder after the player is safe, because the player
					-- doesn't simulate any further feature calls.
				ignore_result := recorder.put_feature_exit(Result)
			end

	accept(visitor: PROGRAM_FLOW_SINK_VISITOR) is
			-- Accept a visitor.
		do
			visitor.visit_logging_player (Current)
		end

invariant
	invariant_clause: True -- Your invariant here
end
