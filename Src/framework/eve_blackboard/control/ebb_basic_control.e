note
	description: "Summary description for {EBB_BASIC_CONTROL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_BASIC_CONTROL

inherit

	EBB_CONTROL

	EBB_SHARED_BLACKBOARD
		export {NONE} all end

	EBB_SHARED_LOG
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize basic control.
		do

		end

feature -- Basic operations

	execute_action
			-- <Precursor>
		local
			l_input: EBB_TOOL_INPUT
			l_tool: EBB_TOOL
			l_config: EBB_TOOL_CONFIGURATION
		do
				-- Select input set
			create l_input.make
			l_input.add_class (blackboard.data.classes.first.associated_class)

				-- Select tool/configuration
			l_tool := blackboard.tools.first
			l_config := l_tool.configurations.first

				-- Run tool
			log.put_line ("Running tool " + l_tool.name)
			l_tool.run (l_input, l_config)
		end

end
