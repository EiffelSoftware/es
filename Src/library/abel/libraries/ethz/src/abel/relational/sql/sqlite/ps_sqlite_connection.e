note
	description: "Wrapper for a SQLite connection."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_SQLITE_CONNECTION

inherit
	PS_SQL_CONNECTION_ABSTRACTION

create
	make

feature {PS_EIFFELSTORE_EXPORT} -- Settings

	set_autocommit (flag:BOOLEAN)
		-- Enable or disable autocommit
		do
			print ("TODO")
		end

feature {PS_EIFFELSTORE_EXPORT} -- Database operations

	execute_sql (statement: STRING)
		-- Execute the SQL statement `statement', and store the result (if any) in `Current.last_result'
		-- In case of an error, it will report it in `last_error' and raise an exception.
		local
			stmt: SQLITE_STATEMENT
			result_list: LINKED_LIST[PS_SQLITE_ROW]
			res: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			create result_list.make
			print (statement)

			create stmt.make (statement + ";", internal_connection)

			if attached stmt.last_exception as ex then
				print (ex.meaning)

			end
			res:= stmt.execute_new

			if stmt.has_error then
				print (stmt.last_exception)
				print (statement)
			end

			from res.start
			until res.after
			loop
				result_list.extend (create {PS_SQLITE_ROW}.make(res.item))
				res.forth
			end

			last_result:= result_list.new_cursor

		end

	commit
		-- Commit the currently active transaction.
		-- In case of an error, it will report it in `last_error' and raise an exception.
		-- (Note that by default autocommit should be disabled)
		do
			internal_connection.commit
			internal_connection.begin_transaction (False)
		end

	rollback
		-- Rollback the currently active transaction.
		-- In case of an error, it will report it in `last_error' and raise an exception.
		-- (Note that by default autocommit should be disabled)
		do
			internal_connection.rollback
			internal_connection.begin_transaction (False)
		end

feature {PS_EIFFELSTORE_EXPORT} -- Database results

	last_result: ITERATION_CURSOR[PS_SQL_ROW_ABSTRACTION]
		-- The result of the last database operation


	last_error: PS_ERROR
		-- The last occured error



feature {PS_SQLITE_DATABASE} -- Initialization

	make (connection: SQLITE_DATABASE)
			-- Initialization for `Current'.
		do
			internal_connection:= connection
			create {PS_NO_ERROR} last_error

			last_result:= (create {LINKED_LIST[PS_SQL_ROW_ABSTRACTION]}.make).new_cursor

		end

	internal_connection: SQLITE_DATABASE

end
