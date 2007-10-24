indexing
	description: "A general Sink for program flow events"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PROGRAM_FLOW_SINK

feature --Initialization
	make
			-- Create the controller.
		local
			ctrl: like Current
		do
			create observed_stack.make(200)
			observed_stack.put (False)
		end

feature -- Access

	is_capture_replay_enabled: BOOLEAN
			-- Is Capture/Replay enabled?
			-- This switch is installed to be able to make performance
			-- measurements.

	is_replay_phase: BOOLEAN
			-- Is program currently running in replay phase?
			-- MUST be false if capture/Replay is disabled.

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Basic operations

	put_feature_exit (res: ANY): ANY is
			-- Put a feature exit event with result `res' into the sink.
		deferred end

	put_feature_invocation (feature_name: STRING_8; target: ANY; arguments: TUPLE)
			-- Put a feature invocation event (`target'.`feature_name'(`arguments')) into the sink.
		require
			feature_name_not_void: feature_name /= Void
			target_not_void: target /= Void
			arguments_not_void: arguments /= Void
		deferred end

	put_special_modification(target: SPECIAL[ANY]; size: INTEGER)
			-- Put a special modification event.
		require
			target_not_void: target /= Void
		deferred end

	observed_stack: DS_ARRAYED_STACK [BOOLEAN]
			--Stack of the is_observed Values

		enter is
			-- Enter into the capture/replay management code.
			-- Note: disables Capture/Replay
		do
			is_capture_replay_enabled := False
			is_replay_phase := False
		end

	leave is
			-- Leave the Capture/Replay management code.
			-- note sets Capture/Replay to the original status.
		do
			is_capture_replay_enabled := is_capture_replay_enabled_original
			is_replay_phase := is_replay_phase_original
		end

	accept(visitor: PROGRAM_FLOW_SINK_VISITOR) is
			-- Accept a visitor.
		deferred end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation
	is_capture_replay_enabled_original: BOOLEAN
			-- is c/r really enabled? (not only temporary)

	is_replay_phase_original: BOOLEAN
			-- Is this in fact the replay phase (not only temporary)

	set_capture_replay_enabled(enabled: BOOLEAN) is
			-- Set `is_capture_replay_enabled' to `enabled'
		do
			is_capture_replay_enabled := enabled
			is_capture_replay_enabled_original := enabled
		end

	set_replay_phase(activated: BOOLEAN) is
			-- 	Set `is_replay_phase' to `activated'
		require
			requires_enabled_capture_phase: activated implies is_capture_replay_enabled
		do
			is_replay_phase := activated
			is_replay_phase_original := activated
		end
invariant
	replay_requires_enabled_cr: is_replay_phase implies is_capture_replay_enabled

end
