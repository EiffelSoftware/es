note
	description: "Summary description for {MYSQL_EXAMPLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MYSQL_EXAMPLE

feature

	run_example
		local
			client: MYSQL_CLIENT
			stmt, stmt_insert: MYSQL_STMT
		do
			-- Initialization
			create client.make ("127.0.0.1", "root", "", "test")
			print("is_connected: "+client.is_connected.out+"%N%N")

			if client.is_connected then
				-- Simple queries
			client.execute_query ("DROP TABLE eiffelmysql IF EXISTS")
			client.execute_query ("CREATE TABLE eiffelmysql (i INT AUTO_INCREMENT, t TEXT, j INT, PRIMARY KEY (i))")
			client.execute_query ("INSERT INTO eiffelmysql VALUES (1, 'foo', 11)")
			client.execute_query ("INSERT INTO eiffelmysql VALUES (NULL, 'bar', 22)")
			print ("last_insert_id: "+client.last_insert_id.out+"%N")
			client.execute_query ("UPDATE eiffelmysql SET j = j * j")
			print ("last_affected_rows: "+client.last_affected_rows.out+"%N")

			-- Error
			client.execute_query ("SELECT")
			print ("last_error: "+client.last_error+" ("+client.last_errno.out+"%N%N")

			-- Simple result
			-- It is imperative that the last_result be freed for queries that have a result set (or it will leak memory)
			client.execute_query ("SELECT * FROM eiffelmysql")
			print ("last_result.row_count: "+client.last_result.row_count.out+"%N")
			print ("last_result.field_count: "+client.last_result.field_count.out+"%N")
			from
				client.last_result.forth
			until
				client.last_result.off
			loop
				print ("%Tlast_result.at: "+client.last_result.at (0)+", '"+client.last_result.at (1)+"', "+client.last_result.at (2)+"%N")
				client.last_result.forth
			end
			client.last_result.free_result
			print("%N")

			-- Prepared Statement (INSERT)
			-- It is imperative that the stmt be closed (or it will leak memory)
			client.prepare_statement ("INSERT INTO eiffelmysql VALUES (?, ?, ?)")
			stmt_insert := client.last_statement
			stmt_insert.set_int    (0, 3)
			stmt_insert.set_string (1, "baz")
			stmt_insert.set_null   (2)
			stmt_insert.execute
			stmt_insert.set_null   (0)
			stmt_insert.set_string (1, "foo")
			stmt_insert.set_int    (2, 44)
			stmt_insert.execute

			-- Prepared Statement (SELECT)
			-- It is imperative that the stmt be closed (or it will leak memory)
			client.prepare_statement("SELECT * FROM eiffelmysql WHERE t = ?")
			stmt := client.last_statement
			stmt.set_string(0, "foo")
			stmt.execute
			print ("stmt.num_rows: "+stmt.num_rows.out+"%N")
			from
				stmt.forth
			until
				stmt.off
			loop
				print ("%Tstmt.at: "+stmt.int_at (0).out+", '"+stmt.string_at (1)+"', "+stmt.int_at (2).out+"%N")
				stmt.forth
			end
			print("%N")

			-- Several statements can be open at the same time (INSERT)
			stmt_insert.set_null (0)
			stmt_insert.set_null (1)
			stmt_insert.set_int  (2, 55)
			stmt_insert.execute
			stmt_insert.close

			-- Run same query again (SELECT)
			stmt.set_string (0, "baz")
			stmt.execute
			print ("stmt.num_rows: "+stmt.num_rows.out+"%N")
			from
				stmt.forth
			until
				stmt.off
			loop
				print ("%Tstmt.at: "+stmt.int_at (0).out+", '"+stmt.string_at (1).out+"', "+stmt.null_at (2).out+"%N")
				stmt.forth
			end
			stmt.close

			-- Cleanup
			client.execute_query ("DROP TABLE eiffelmysql")
			client.close
			end
		end

end
