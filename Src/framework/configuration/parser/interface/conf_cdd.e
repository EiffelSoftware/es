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
			is_extracting_enabled := True
			is_executing_enabled := True
		ensure
			defaults_set: is_default
		end

feature -- Status report

	is_extracting_enabled: BOOLEAN
			-- Shall CDD automatically extract test cases?

	is_executing_enabled: BOOLEAN
			-- Shall CDD automatically execute test cases?

	is_default: BOOLEAN is
			-- Are all values set to their defaults?
		do
			Result := is_executing_enabled and is_extracting_enabled
		ensure
			definition: Result = (is_executing_enabled and is_extracting_enabled)
		end

feature -- Access

	target: CONF_TARGET
			-- Associated target configuration

feature {ANY} -- Status setting

	enable_extracting is
			-- Set `is_extracting' to True.
		require
			not_extracting: not is_extracting_enabled
		do
			is_extracting_enabled := True
			target.system.store
		ensure
			is_extracting_set: is_extracting_enabled
		end

	enable_executing is
			-- Set `is_executing' to True.
		require
			not_executing: not is_executing_enabled
		do
			is_executing_enabled := True
			target.system.store
		ensure
			is_executing_set: is_executing_enabled
		end

	disable_extracting is
			-- Set `is_extracting' to False.
		require
			is_extracting: is_extracting_enabled
		do
			is_extracting_enabled := False
		ensure
			is_extracting_set: not is_extracting_enabled
		end

	disable_executing is
			-- Set `is_executing' to False.
		require
			is_executing: is_executing_enabled
		do
			is_executing_enabled := False
		ensure
			is_executing_set: not is_executing_enabled
		end

	set_is_extracting (an_is_extracting: like is_extracting_enabled) is
			-- Set `is_extracting' to `an_is_extracting'.
		do
			is_extracting_enabled := an_is_extracting
		ensure
			is_extracting_set: is_extracting_enabled = an_is_extracting
		end

	set_is_executing (an_is_executing: like is_executing_enabled) is
			-- Set `is_executing' to `an_is_executing'.
		do
			is_executing_enabled := an_is_executing
		ensure
			is_executing_set: is_executing_enabled = an_is_executing
		end

invariant
	valid_target: target /= Void and then target.cdd = Current

end
