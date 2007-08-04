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
		put_attribute_access,
		accept,
		remove_from_observed_stack,
		put_to_observed_stack,
		simulate_unobserved_body
	end

create
	make

feature -- Access

	last_feature_name: STRING

	last_target: ANY

	last_arguments: TUPLE

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
		do
				-- XXX invoking the recorder at this position leads to incorrect object ID's
	            -- But it's necessary to record before the player is invoked to make sure that
	            -- Nested calls are correctly recorded.
	        last_feature_name := feature_name
	        last_target := target
	        last_arguments := arguments

			Precursor {PLAYER}(feature_name, target, arguments)
			if target.is_observed then
				recorder.put_feature_invocation(feature_name,target,arguments)
			end
		end

	put_feature_exit (res: ANY) is
		do
			Precursor {PLAYER} (res)
				-- Invoking the recorder after the player is safe, because the player
				-- doesn't simulate any further feature calls.
			recorder.put_feature_exit (last_result)
		end

	put_attribute_access (attribute_name: STRING_8; target, value: ANY) is
		do
			Precursor {PLAYER} (attribute_name, target, value)
			recorder.put_attribute_access (attribute_name, target, value)
		end

	accept(visitor: PROGRAM_FLOW_SINK_VISITOR) is
			-- Accept a visitor.
		do
			visitor.visit_logging_player (Current)
		end

	put_to_observed_stack (class_is_observed: BOOLEAN) is
			--
		do
			Precursor (class_is_observed)
			recorder.put_to_observed_stack (class_is_observed)
		end

	remove_from_observed_stack is
			--
		do
			Precursor
			recorder.remove_from_observed_stack
		end

	simulate_unobserved_body is
			--
		do
			if not observed_stack_item and then last_target /= Void then
				recorder.put_feature_invocation(last_feature_name, last_target, last_arguments)
			end
			Precursor
		end



invariant
	invariant_clause: True -- Your invariant here
end
