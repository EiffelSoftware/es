note
	description: "Class to group different database operations into a single unit. Also responsible to propagate errors."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_TRANSACTION

inherit {NONE}
	REFACTORING_HELPER

create
	make

feature

	repository: PS_REPOSITORY
			-- The repository this transaction is bound to.

	commit
			-- Try to commit the transaction.
		do
			is_commited:=True
			fixme ("TODO")
		ensure
			commited: is_commited
		end

	rollback
			-- Rollback all operations within this transaction.
		do
			fixme ("TODO")
		end

	is_commited: BOOLEAN
			-- Has Current.commit been called?

	has_error: BOOLEAN
			-- Has there been an error in any of the operations or the final commit?


	error: detachable ANY
			-- Error description
		require
			has_error
		do
			fixme ("TODO: error system")
		end


	make (a_repository: PS_REPOSITORY)
			-- Initialize `Current'
		do
			repository := a_repository
		end

end
