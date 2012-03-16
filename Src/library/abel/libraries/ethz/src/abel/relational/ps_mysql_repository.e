note
	description: "MySQL relational database implementation class."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_MYSQL_REPOSITORY

inherit

	PS_RDB_REPOSITORY

inherit {NONE}

	PS_LIB_UTILS

--create
--	make_with_mapping

feature -- Access

feature -- Basic operations

	execute_transactional_query (t_query: PS_SQL_TRANSACTION_UNIT)
			-- Execute transactional query `t_query'.
		local
			client: MYSQLI_CLIENT
			i, j: INTEGER
			array_list: ARRAYED_LIST [MYSQLI_ROW]
		do
				--	matched.wipe_out
			create array_list.make (Default_dimension)
			create client.make
			client.set_host (default_host)
			client.set_username (default_user)
			client.set_password (default_password)
			client.set_database (default_database)
			client.connect
				-- Note: support for custom transactions is still work in progress
				-- At the moment the framework is working in autocommit mode
				-- client.execute_query (No_autocommit)
				-- client.execute_query (Begin_transaction)
			if not client.has_error then
				client.execute_query (t_query.query.sql)
					--	if
					--		not client.last_error.is_empty
					--	then
					--		print ("Rolling back transaction...")		
					--	client.execute_query (Rollback_transaction)
					--	else
					--	print ("Committing transaction...")
					--	client.execute_query (Commit_transaction)
					--	end	
				if not client.has_error then
					from
						client.last_result.start
						i := 1
					until
						client.last_result.off
					loop
						from
							j := 1
						until
							j > client.last_result.count --check if this is really what you want
						loop
							if attached client.last_result.at (j) as s then
								array_list.extend (s)
							end
							j := j + 1
						end
						t_query.query.matched.extend (array_list)
						client.last_result.forth
					end
					print ("matched.count: " + t_query.query.matched.count.out)
					print ("%NNumber of affected rows (for delete, update, insert statements: " + client.last_result.affected_rows.out + "%N")
				else
					print ("%N mysql lib error. Last client error number: " + client.last_client_error_number.out)
					print ("%N Last client error message: " + client.last_error_message.out)
					print ("%N Last server error number: " + client.last_server_error_number.out)
					print ("%N Last server error message: " + client.last_server_error_message.out)
				end
				client.close
			else
					-- Problem in opening a connection.
				print (client.last_error_message.out)
			end
		end

feature {NONE} -- MySQL constants

	No_autocommit: STRING = "SET autocommit=0;"

	Begin_transaction: STRING = "BEGIN;"

	Commit_transaction: STRING = "COMMIT;"

	Rollback_transaction: STRING = "ROLLBACK;"

invariant
	invariant_clause: True -- Your invariant here

end
