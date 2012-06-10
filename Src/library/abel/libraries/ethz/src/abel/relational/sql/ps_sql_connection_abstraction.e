note
	description: "Summary description for {PS_SQL_CONNECTION_ABSTRACTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_SQL_CONNECTION_ABSTRACTION

feature

	execute_sql (sql_string: STRING)
		deferred
		end

	last_insert_id: INTEGER
		deferred
		end

	last_result: ITERATION_CURSOR[PS_SQL_ROW_ABSTRACTION]
		deferred
		end

end
