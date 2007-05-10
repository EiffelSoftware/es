indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CONTROLLER

feature --Initialization

	make
			-- Create the controller.
		local
			ctrl: like Current
		do
			create observed_stack.make(200)
			observed_stack.put (False)

			set_capture_replay_enabled (False)
			ctrl := set_controller(Current)
		end


feature -- Access

	is_capture_replay_enabled: BOOLEAN
			-- Is Capture/Replay enabled?
			-- This switch is installed to be able to make performance
			-- measurements.

	is_capture_replay_enabled_original: BOOLEAN
			-- is c/r really enabled? (not only temporary)

	is_replay_phase: BOOLEAN
			-- Is program currently running in replay phase?
			-- MUST be false if capture/Replay is disabled.

	observed_stack: ARRAYED_STACK [BOOLEAN]
			--Stack of the is_observed Values

feature -- Measurement

feature -- Status report

feature -- Status setting
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
		end

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	methodbody_end (res: ANY): ANY is
			-- Hook for capture/replay. Is to be placed at the end of a MethodBody
			-- 'res' is the Result of the Method that should be instrumented.
			-- Return the replacement for the Methodbody's return value.
		deferred end

	methodbody_start (feature_name: STRING_8; target: ANY; arguments: TUPLE)
			-- Hook for capture/replay. Is to be placed before the methodbody is evaluated
			-- 'target' is the object whose feature was called
			-- 'arguments' are the arguments of the feature.
		deferred end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

		enter is
				--
			do
				is_capture_replay_enabled := False
			end

		leave is
				--
			do
				is_capture_replay_enabled := is_capture_replay_enabled_original
			end

invariant
	invariant_clause: True -- Your invariant here

end
