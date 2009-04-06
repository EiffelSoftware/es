indexing
	description: "Summary description for {COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COMMAND

create
	make

feature {NONE} -- Initialization

	make (a_action: like action)
			-- Initialize command.
		do
			action := a_action
		ensure
			action = a_action
		end

feature -- Access

	action: !PROCEDURE [ANY, TUPLE [INTEGER]]
			-- Action being executed

feature -- Basic operations

	execute (a_arg: INTEGER)
			-- Execute `action' with the argument `a_arg'.
		require
			action.precondition ([a_arg])
		do
			action.call ([a_arg])
		ensure
			action.postcondition ([a_arg])

			action = old action -- remove from modifies
		end

end
