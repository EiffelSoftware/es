note
	description: "Summary description for {MYSQL_EXAMPLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MYSQL_EXAMPLES

feature

	run_example
		local
			client: MYSQL_CLIENT
			stmt, stmt_insert: MYSQL_PREPARED_STATEMENT
		do
			-- Initialization
			create client.make ("127.0.0.1", "root", "", "test", 0)
			print("is_connected: "+client.is_connected.out+"%N%N")

			if client.is_connected then
				-- Simple queries
			client.execute_query ("DROP TABLE eiffelmysql IF EXISTS")
			client.execute_query ("CREATE TABLE eiffelmysql (i INT AUTO_INCREMENT, t TEXT, j DOUBLE, PRIMARY KEY (i))")
			client.execute_query ("INSERT INTO eiffelmysql VALUES (1, 'foo', 11.1)")
			client.execute_query ("INSERT INTO eiffelmysql VALUES (NULL, 'bar', 22.2)")
			print ("last_insert_id: "+client.last_insert_id.out+"%N")
			client.execute_query ("UPDATE eiffelmysql SET j = j * j")
			print ("last_affected_rows: "+client.last_affected_rows.out+"%N")

			-- Error
			client.execute_query ("SELECT")
			print ("last_error: "+client.last_error+" ("+client.last_error_number.out+"%N%N")

			-- Simple result
			-- It is imperative that the last_result be freed for queries that have a result set (or it will leak memory)
			client.execute_query ("SELECT * FROM eiffelmysql")
			print ("last_result.row_count: "+client.last_result.row_count.out+"%N")
			print ("last_result.field_count: "+client.last_result.column_count.out+"%N")
			print ("%TField 1: "+client.last_result.column_name_at (1)+"%N")
			print ("%TField 2: "+client.last_result.column_name_at (2)+"%N")
			print ("%TField 3: "+client.last_result.column_name_at (3)+"%N")
			from
				client.last_result.start
			until
				client.last_result.off
			loop
				print ("%Tlast_result.at: "+client.last_result.at (1)+", '"+client.last_result.at (2)+"', "+client.last_result.at (3)+"%N")
				client.last_result.forth
			end

			client.last_result.dispose
			print("%N")

			-- Using across syntax
			across
				client.last_result as c
			loop
				print ("%Tlast_result.at: "+c.item.at (1)+", '"+c.item.at (2)+"', "+c.item.at (3)+"%N")
			end

			-- Prepared Statement (INSERT)
			-- It is imperative that the stmt be closed (or it will leak memory)
			client.prepare_statement ("INSERT INTO eiffelmysql VALUES (?, ?, ?)")
			stmt_insert := client.last_prepared_statement
			stmt_insert.set_integer    (1, 3)
			stmt_insert.set_string (2, "baz")
			stmt_insert.set_null   (3)
			stmt_insert.execute
			stmt_insert.set_null   (1)
			stmt_insert.set_string (2, "foo")
			stmt_insert.set_double (3, 44.4)
			stmt_insert.execute

			-- Prepared Statement (SELECT)
			-- It is imperative that the stmt be closed (or it will leak memory)
			client.prepare_statement("SELECT * FROM eiffelmysql WHERE t = ?")
			stmt := client.last_prepared_statement
			stmt.set_string(1, "foo")
			stmt.execute
			print ("stmt.num_rows: "+stmt.row_count.out+"%N")
			print ("%TField 1: "+stmt.column_name_at (1)+"%N")
			print ("%TField 2: "+stmt.column_name_at (2)+"%N")
			print ("%TField 3: "+stmt.column_name_at (3)+"%N")
			from
				stmt.start
			until
				stmt.off
			loop
				print ("%Tstmt.at: "+stmt.integer_at (1).out+", '"+stmt.string_at (2)+"', "+stmt.double_at (3).out+"%N")
				stmt.forth
			end
			print("%N")

			-- Several statements can be open at the same time (INSERT)
			stmt_insert.set_null   (1)
			stmt_insert.set_null   (2)
			stmt_insert.set_double (3, 55.5)
			stmt_insert.execute
			stmt_insert.dispose

			-- Run same query again (SELECT)
			stmt.set_string (1, "baz")
			stmt.execute
			print ("stmt.num_rows: "+stmt.row_count.out+"%N")
			from
				stmt.start
			until
				stmt.off
			loop
				print ("%Tstmt.at: "+stmt.integer_at (1).out+", '"+stmt.string_at (2).out+"', "+stmt.is_null_at (3).out+"%N")
				stmt.forth
			end

			-- Using across syntax
--			across
--				stmt as c
--			loop
--				print ("%Tstmt.at: "+c.item.int_at (1).out+", '"+c.item.string_at (2).out+"', "+c.item.null_at (3).out+"%N")
--			end

			-- Cleanup
			stmt.dispose
			client.execute_query ("DROP TABLE eiffelmysql")
			client.dispose
			end
		end

end
