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

	execute
		require
			action.precondition ([argument])
		do
			action.call ([argument])
		ensure
			action.postcondition ([argument])

			action = old action -- remove from modifies
			argument = old argument -- remove from modifies
		end

end
