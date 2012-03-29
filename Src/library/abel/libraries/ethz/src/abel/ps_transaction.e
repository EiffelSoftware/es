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

create {PS_EIFFELSTORE_EXPORT}
	make_readonly

feature {NONE} -- Initialization

	make (a_repository: PS_REPOSITORY)
			-- Initialize `Current'
		do
			repository := a_repository
			create {PS_NO_ERROR} error
			is_readonly:=False
		end

	make_readonly (a_repository:PS_REPOSITORY)
			-- Initialize `Current', mark transaction as readonly
		do
			repository := a_repository
			create {PS_NO_ERROR} error
			is_readonly:=True
		end

feature -- Basic operations

	commit
			-- Try to commit the transaction.
		do
			has_commit_been_called:=True
			fixme ("TODO")
		ensure
			commited: has_commit_been_called
		end

	rollback
			-- Rollback all operations within this transaction.
		do
			fixme ("TODO")
		end

feature -- Status report

	has_commit_been_called: BOOLEAN
			-- Has Current.commit been called?


	has_error: BOOLEAN
			-- Has there been an error in any of the operations or the final commit?
		do
			Result := not attached {PS_NO_ERROR} error
		end


	is_readonly:BOOLEAN
			-- Is this a readonly transaction?


feature -- Access


	error: PS_ERROR
			-- Error description

	repository: PS_REPOSITORY
			-- The repository this transaction is bound to.


feature {PS_EIFFELSTORE_EXPORT} -- Internals

	set_error (an_error:PS_ERROR)
			-- Set the error field if an error occured.
		do
			error := an_error
		ensure
			error_set: error = an_error
		end

end

