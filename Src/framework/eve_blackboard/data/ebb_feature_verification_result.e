note
	description: "Summary description for {EBB_FEATURE_VERIFICATION_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_FEATURE_VERIFICATION_RESULT

inherit

	EBB_FEATURE_VERIFICATION_STATE

create
	make

feature

--	time: DATE_TIME
	tool: EBB_TOOL

	set_time (a_time: like time)
			-- Set `time' to `a_time'.
		do
			time := a_time
		ensure
			time_set: time = a_time
		end

	set_tool (a_tool: like tool)
			-- Set `tool' to `a_tool'.
		do
			tool := a_tool
		ensure
			tool_set: tool = a_tool
		end

end
