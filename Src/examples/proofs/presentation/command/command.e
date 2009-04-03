indexing
	description: "Summary description for {COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COMMAND

create
	make

feature

	make (a_action: like action; a_arg: INTEGER)
		do
			action := a_action
			argument := a_arg
		ensure
			action = a_action
			argument = a_arg
		end

	action: !PROCEDURE [ANY, TUPLE [INTEGER]]

	argument: INTEGER

	execute (a_arg: INTEGER)
		require
			action.precondition ([a_arg])
		do
			action.call ([a_arg])
		ensure
			action.postcondition ([a_arg])

			action = old action -- remove from modifies
			--argument = old argument -- remove from modifies
		end

end
