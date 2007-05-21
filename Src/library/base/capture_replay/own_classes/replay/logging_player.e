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
		put_feature_invocation
	end

create
	make

feature -- Initialization

	setup_on_text_files(replay_filename:STRING; log_filename: STRING; a_caller: CALLER) is
			-- Set up the player for replay from `replay_filename', logging to `log_filename' using
			-- `a_caller' to execute calls.
		do
			create recorder.make
			recorder.setup_on_text_serializer (log_filename)
			setup_player_on_textfile (replay_filename,a_caller)
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
		put_feature_invocation (feature_name: STRING_8; target: OBSERVABLE; arguments: TUPLE) is
				--
			do
				Precursor {PLAYER}(feature_name, target, arguments)
				recorder.put_feature_invocation(feature_name,target,arguments)
			end

		put_feature_exit (res: ANY): ANY is
				--
			local
				ignore_result: ANY
			do
				Result := Precursor {PLAYER}(res)
				ignore_result := recorder.put_feature_exit(Result)
			end

invariant
	invariant_clause: True -- Your invariant here

end
