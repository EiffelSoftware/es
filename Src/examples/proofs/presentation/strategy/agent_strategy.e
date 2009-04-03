indexing
	description: "Summary description for {AGENT_STRATEGY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AGENT_STRATEGY

inherit
	OPERATOR_STRATEGY

create
	make

feature

	make (a_action: like action)
		do
			action := a_action
		ensure
			action = a_action
		end

	action: FUNCTION [ANY, TUPLE [INTEGER, INTEGER], INTEGER]

	execute (a, b: INTEGER)
		do
			last_result := action.item ([a, b])
		end

end
