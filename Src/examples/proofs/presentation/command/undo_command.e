indexing
	description: "Summary description for {UNDO_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNDO_COMMAND

inherit
	COMMAND

create
	make_undo

feature

	make_undo (a_action: like action; a_undo_action: like undo_action; a_arg: INTEGER)
		do
			action := a_action
			undo_action := a_undo_action
			argument := a_arg
		ensure
			action = a_action
			undo_action = a_undo_action
			argument = a_arg
		end

	undo_action: !PROCEDURE [ANY, TUPLE [INTEGER]]

	execute_undo (a_arg: INTEGER)
		require
			undo_action.precondition ([a_arg])
		do
			undo_action.call ([a_arg])
		ensure
			undo_action.postcondition ([a_arg])

			undo_action = old undo_action -- remove from modifies
--			argument = old argument -- remove from modifies
		end

end
