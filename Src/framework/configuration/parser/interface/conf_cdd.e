indexing
	description: "Settings for CDD"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CONF_CDD

create {CONF_PARSE_FACTORY}
	make

feature {NONE} -- Initialization

	make (a_target: CONF_TARGET) is
			-- Set `target' to `a_target'.
		require
			a_target_not_void: a_target /= Void
		do
			target := a_target
				-- Set `is_extracting' to True by default.
			is_extracting := True
		end

feature -- Access

	is_enabled: BOOLEAN
			-- Is CDD enabled in the current target?

	is_extracting: BOOLEAN
			-- Shall CDD automatically extract test cases?

	is_capture_replay_activated: BOOLEAN
			-- Shall capture/replay be activated in current target?

	target: CONF_TARGET
			-- Associated target configuration

feature {CONF_ACCESS} -- Status setting

	set_is_enabled (an_is_enabled: like is_enabled) is
			-- Set `is_enabled' to `an_is_enabled'.
		do
			is_enabled := an_is_enabled
		ensure
			is_enabled_set: is_enabled = an_is_enabled
		end

	set_is_extracting (an_is_extracting: like is_extracting) is
			-- Set `is_extracting' to `an_is_extracting'.
		do
			is_extracting := an_is_extracting
		ensure
			is_extracting_set: is_extracting = an_is_extracting
		end

	set_is_capture_replay_activated (an_is_capture_replay_activated: like is_capture_replay_activated) is
			-- Set `is_capture_replay_activated' to `an_is_capture_replay_activated'.
		do
			is_capture_replay_activated := an_is_capture_replay_activated
		ensure
			is_capture_replay_activated_set: is_capture_replay_activated = an_is_capture_replay_activated
		end

invariant
	valid_target: target /= Void and then target.cdd = Current

end
