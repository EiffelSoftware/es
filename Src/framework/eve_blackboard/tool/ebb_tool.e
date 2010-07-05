note
	description: "Parent class for all tools which work on the blackboard."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EBB_TOOL

feature -- Access

	name: STRING
			-- Name of tool.
		deferred
		end

	configurations: LIST [EBB_TOOL_CONFIGURATION]
			-- List of available tool configurations.
		deferred
		ensure
			not_empty: not Result.is_empty
		end

feature -- Basic operations

	run (a_input: EBB_TOOL_INPUT; a_configuration: EBB_TOOL_CONFIGURATION)
			-- Run on `a_input' in mode `a_configuration'.
		deferred
		end

end
