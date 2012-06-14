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
				last_error:= get_error
				last_error.raise
			end
		end

--	last_insert_id: INTEGER
--		do
--			Result:= internal_connection.last_result.last_insert_id
--		end

	commit
		do
			internal_connection.commit
			if internal_connection.has_error then
				print (internal_connection.last_error_message)
				last_error:= get_error
				last_error.raise
			end
		end

	rollback
		do
			internal_connection.rollback
			if internal_connection.has_error then
				last_error:= get_error
				last_error.raise
			end
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


	last_error: PS_ERROR




feature {PS_MYSQL_DATABASE} -- Initialization

	make (a_connection: MYSQLI_CLIENT)
			-- Initialization for `Current'.
		do
			internal_connection:= a_connection
			create {PS_NO_ERROR} last_error
		end

	internal_connection: MYSQLI_CLIENT


feature {NONE} -- Implementation

	get_error: PS_ERROR
		-- Translate the MySQL specific error code to an ABEL error object.
		local
			error_number: INTEGER
		do
			error_number:= internal_connection.last_server_error_number
			if transaction_errors.has (error_number) then
				create {PS_TRANSACTION_ERROR} Result
			else
				create {PS_GENERAL_ERROR} Result.make (internal_connection.last_error_message)
			end
		end



	transaction_errors: ARRAY[INTEGER]
		once
			Result :=  <<
				1205 -- Lock timeout
				>>
		end

end
