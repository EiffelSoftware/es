indexing
	description: "Summary description for {BANK_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT_COMMAND

create
	make

feature

	make (a_action: like action)
		do
			action := a_action
		ensure
			action = a_action
		end

	action: !PROCEDURE [ANY, TUPLE [ACCOUNT, INTEGER]]

	execute (a_account: ACCOUNT; a_arg: INTEGER)
		require
			action.precondition ([a_account, a_arg])
		do
			action.call ([a_account, a_arg])
		ensure
			action.postcondition ([a_account, a_arg])

			action = old action -- remove from modifies
			--argument = old argument -- remove from modifies
		end

end
