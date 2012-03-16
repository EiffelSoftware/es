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
			print ("-- Connecting to server...%N")
			create client.make -- uses default values: host "127.0.0.1", user "root", empty password, port 3306
			client.connect
			print ("is_connected: "+client.is_connected.out+"%N%N")

			-- Simple queries
			print ("-- Executing 'DROP TABLE eiffelmysql IF EXISTS'...%N")
			client.execute_query ("DROP TABLE eiffelmysql IF EXISTS")
			print ("-- Executing 'CREATE TABLE eiffelmysql (i INT AUTO_INCREMENT, t TEXT, j DOUBLE, PRIMARY KEY (i))'...%N")
			client.execute_query ("CREATE TABLE eiffelmysql (i INT AUTO_INCREMENT, t TEXT, j DOUBLE, PRIMARY KEY (i))")
			print ("-- Executing 'INSERT INTO eiffelmysql VALUES (1, 'foo', 11.1)'...%N")
			client.execute_query ("INSERT INTO eiffelmysql VALUES (1, 'foo', 11.1)")
			print ("-- Executing 'INSERT INTO eiffelmysql VALUES (NULL, 'bar', 22.2)'...%N")
			client.execute_query ("INSERT INTO eiffelmysql VALUES (NULL, 'bar', 22.2)")
			print ("last_insert_id: "+client.last_insert_id.out+"%N")
			print ("-- Executing 'UPDATE eiffelmysql SET j = j * j'...%N")
			client.execute_query ("UPDATE eiffelmysql SET j = j * j")
			print ("last_affected_rows: "+client.last_affected_rows.out+"%N%N")

			-- Sample Error
			print ("-- Forcing an error by executing 'SELECT * FROM a_table_that_does_not_exist'...%N")
			client.execute_query ("SELECT * FROM a_table_that_does_not_exist")
			print ("last_error: "+client.last_error+" (Error Number: "+client.last_error_number.out+")%N%N")


			-- Simple result
			print ("-- Executing 'SELECT * FROM eiffelmysql'...%N")
			client.execute_query ("SELECT * FROM eiffelmysql")
			print ("Number of rows: "+client.last_result.row_count.out+"%N")
			print ("Number of columns: "+client.last_result.column_count.out+"%N")
			print ("Column 1: "+client.last_result.column_name_at (1)+"%N")
			print ("Column 2: "+client.last_result.column_name_at (2)+"%N")
			print ("Column 3: "+client.last_result.column_name_at (3)+"%N")
			from
				client.last_result.start
			until
				client.last_result.off
			loop
				print ("Row (Using Loop): "+client.last_result.at (1)+", '"+client.last_result.at (2)+"', "+client.last_result.at (3)+"%N")
				client.last_result.forth
			end

			-- Using across syntax
			across
				client.last_result as c
			loop
				print ("Row (Using Across): "+c.item.at (1)+", '"+c.item.at (2)+"', "+c.item.at (3)+"%N")
			end

			-- Close and dispose of the result
			client.last_result.dispose
			print("%N")

			-- Prepared Statement (INSERT)
			print ("-- Preparing and executing 'INSERT INTO eiffelmysql VALUES (?, ?, ?)'...%N")
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
			print ("-- Preparing and executing 'SELECT * FROM eiffelmysql WHERE t = ?'...%N")
			client.prepare_statement("SELECT * FROM eiffelmysql WHERE t = ?")
			stmt := client.last_prepared_statement
			stmt.set_string(1, "foo")
			stmt.execute
			print ("Number of rows: "+stmt.row_count.out+"%N")
			print ("Column 1: "+stmt.column_name_at (1)+"%N")
			print ("Column 2: "+stmt.column_name_at (2)+"%N")
			print ("Column 3: "+stmt.column_name_at (3)+"%N")
			from
				stmt.start
			until
				stmt.off
			loop
				print ("Row (Using Loop): "+stmt.integer_at (1).out+", '"+stmt.string_at (2)+"', "+stmt.double_at (3).out+"%N")
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
			print ("-- Executing 'SELECT * FROM eiffelmysql WHERE t = ?' again...%N")
			stmt.set_string (1, "baz")
			stmt.execute
			print ("Rows: "+stmt.row_count.out+"%N")
			from
				stmt.start
			until
				stmt.off
			loop
				print ("Row (Using Loop): "+stmt.integer_at (1).out+", '"+stmt.string_at (2).out+"', "+stmt.is_null_at (3).out+"%N")
				stmt.forth
			end

			-- Using across syntax
			across
				stmt as c
			loop
				print ("Row (Using Across): "+c.item.at (1)+", '"+c.item.at (2)+"', "+c.item.at (3)+"%N")
			end

			-- Close and dispose of the result and client
			stmt.dispose
			print ("%N")
			print ("-- Executing 'DROP TABLE eiffelmysql'...%N")
			client.execute_query ("DROP TABLE eiffelmysql")
			client.dispose
			print ("Done!%N%N%N")
		end

end
