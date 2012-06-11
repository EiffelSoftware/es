note
	description: "Summary description for {PS_MYSQL_CONNECTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_MYSQL_CONNECTION

inherit
	PS_SQL_CONNECTION_ABSTRACTION

create
	make

feature {PS_EIFFELSTORE_EXPORT}

	execute_sql (sql_string: STRING)
		do
			internal_connection.execute_query (sql_string)
			if internal_connection.has_error then
				print (sql_string)
				print (internal_connection.last_error_message)
--				check sql_error: FALSE end
			end
		end

	last_insert_id: INTEGER
		do
			Result:= internal_connection.last_result.last_insert_id
		end

	last_result: ITERATION_CURSOR[PS_SQL_ROW_ABSTRACTION]
		local
			result_list: LINKED_LIST[PS_SQL_ROW_ABSTRACTION]
		do
			create result_list.make

			across internal_connection.last_result as res loop
				result_list.extend (create {PS_MYSQL_ROW}.make (res.item))
			end
			Result:= result_list.new_cursor
		end



feature {PS_MYSQL_DATABASE} -- Initialization

	make (a_connection: MYSQLI_CLIENT)
			-- Initialization for `Current'.
		do
			internal_connection:= a_connection
		end

	internal_connection: MYSQLI_CLIENT

end
