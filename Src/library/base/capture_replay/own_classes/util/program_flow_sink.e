indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PROGRAM_FLOW_SINK

feature --Initialization

feature -- Access

	is_capture_replay_enabled: BOOLEAN is
			-- Is Capture/Replay enabled?
			-- This switch is installed to be able to make performance
			-- measurements.
	deferred end

	is_replay_phase: BOOLEAN is
			-- Is program currently running in replay phase?
			-- MUST be false if capture/Replay is disabled.
	deferred end

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Basic operations

	put_feature_exit (res: ANY): ANY is
			-- Put a feature exit event with result `res' into the sink.
		deferred end

	put_feature_invocation (feature_name: STRING_8; target: OBSERVABLE; arguments: TUPLE)
			-- Put a feature invocation event (`target'.`feature_name'(`arguments')) into the sink.
		require
			feature_name_not_void: feature_name /= Void
			target_not_void: target /= Void
			arguments_not_void: arguments /= Void
		deferred end

	enter is
			-- Enter into the capture/replay management code.
			-- Note: disables Capture/Replay
		deferred end

	leave is
			-- Leave the Capture/Replay management code.
			-- note sets Capture/Replay to the original status.
		deferred end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	replay_requires_enabled_cr: is_replay_phase implies is_capture_replay_enabled

end
