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
		end

feature -- Access

	is_extracting: BOOLEAN
			-- Shall CDD automatically extract test cases?

	is_executing: BOOLEAN
			-- Shall CDD automatically execute test cases?

	target: CONF_TARGET
			-- Associated target configuration

feature {CONF_ACCESS} -- Status setting

	set_is_extracting (an_is_extracting: like is_extracting) is
			-- Set `is_extracting' to `an_is_extracting'.
		do
			is_extracting := an_is_extracting
		ensure
			is_extracting_set: is_extracting = an_is_extracting
		end

	set_is_executing (an_is_executing: like is_executing) is
			-- Set `is_executing' to `an_is_executing'.
		do
			is_executing := an_is_executing
		ensure
			is_executing_set: is_executing = an_is_executing
		end

invariant
	valid_target: target /= Void and then target.cdd = Current

end
