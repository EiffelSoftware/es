note
	description: "Provides an interface for a wrapper to a database connection."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_SQL_CONNECTION_ABSTRACTION
inherit
	ITERABLE[PS_SQL_ROW_ABSTRACTION]

feature {PS_EIFFELSTORE_EXPORT} -- Database operations

	execute_sql (statement: STRING)
		-- Execute the SQL statement `statement', and store the result (if any) in `Current.last_result'
		-- In case of an error, it will report it in `last_error' and raise an exception.
		deferred
		end

	commit
		-- Commit the currently active transaction.
		-- In case of an error, it will report it in `last_error' and raise an exception.
		-- (Note that by default autocommit should be disabled)
		deferred
		end

	rollback
		-- Rollback the currently active transaction.
		-- In case of an error, it will report it in `last_error' and raise an exception.
		-- (Note that by default autocommit should be disabled)
		deferred
		end

feature {PS_EIFFELSTORE_EXPORT} -- Database results

	last_result: ITERATION_CURSOR[PS_SQL_ROW_ABSTRACTION]
		-- The result of the last database operation
		deferred
		end

	last_error: PS_ERROR
		-- The last occured error
		deferred
		end



feature {PS_EIFFELSTORE_EXPORT} -- Utilities

	new_cursor:ITERATION_CURSOR[PS_SQL_ROW_ABSTRACTION]
		-- Get a cursor over the `last_result' (Convenience function to support the `across' syntax)
		do
			Result:= last_result
		end

end
