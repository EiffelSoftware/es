note
	description: "Calculator to measure the change from an expression to another expression"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_EXPRESSION_CHANGE_CALCULATOR

feature -- Basic operation

	change_set (a_source: EPA_EQUATION; a_target: EPA_EQUATION): EPA_EXPRESSION_CHANGE_VALUE_SET
			-- Change set from `a_source' to `a_target'
			-- This means when we APPLY the result change to `a_source', we should get `a_target'.
			-- For example, `a_source" is "index = 1", and `a_target' is "index = 2", then
		deferred
		end

end
