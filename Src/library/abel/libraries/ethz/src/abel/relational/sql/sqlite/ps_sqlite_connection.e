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
			autocommit:= flag
--			print ("TODO")
		end

feature {PS_EIFFELSTORE_EXPORT} -- Database operations

	execute_sql (statement: STRING)
		-- Execute the SQL statement `statement', and store the result (if any) in `Current.last_result'
		-- In case of an error, it will report it in `last_error' and raise an exception.
		local
			all_statements: LIST[STRING]
			stmt: SQLITE_QUERY_STATEMENT
			result_list: LINKED_LIST[PS_SQLITE_ROW]
			res: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			-- By default we can get multiple SQL statements - SQLite somehow handles them differently, therefore split them.
			all_statements:=statement.split (';')
			all_statements.do_all (agent {STRING}.trim)
			-- Remove all empty statements and add a `;' to all non-empty ones (as opposed to MySQL, SQLite needs this character)
			from all_statements.start
			until all_statements.after
			loop
				if all_statements.item.is_empty then
					all_statements.remove
				else
					all_statements.item.extend (';')
					all_statements.forth
				end
			end

			-- Void safety...
			create result_list.make

			-- Execute all statements
			across all_statements as current_statement loop

				create result_list.make
				create stmt.make (current_statement.item, internal_connection)
				create res.make (stmt) -- This executes the statement

				-- Error handling for easier debugging
				if stmt.has_error then
					print (current_statement.item)
					if attached stmt.last_exception as ex then
						print (ex.meaning)
					end
					check sql_error: False end
				end

				-- Collect the result (if any)
				from
				until res.after
				loop
					result_list.extend (create {PS_SQLITE_ROW}.make(res.item))
					res.forth
				end
			end

			-- Return the cursor of the result list
			last_result:= result_list.new_cursor

			if autocommit then
			--	internal_connection.commit
			--	internal_connection.begin_transaction (False)
			end

		rescue
			-- Information to faciliate error handling
			if attached internal_connection.last_exception as ex then
				print ("%N%N"+statement + "%N")
				print (ex.meaning + "%N")
			end
		end

	commit
		-- Commit the currently active transaction.
		-- In case of an error, it will report it in `last_error' and raise an exception.
		-- (Note that by default autocommit should be disabled)
		do
		--	internal_connection.commit
		--	internal_connection.begin_transaction (False)
		end

	rollback
		-- Rollback the currently active transaction.
		-- In case of an error, it will report it in `last_error' and raise an exception.
		-- (Note that by default autocommit should be disabled)
		do
		--	internal_connection.rollback
		--	internal_connection.begin_transaction (False)
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

	autocommit: BOOLEAN

end
