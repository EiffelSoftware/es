note
	description: "Summary description for {PS_SQL_ROW_ABSTRACTION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_SQL_ROW_ABSTRACTION

feature

	get_value (table_header: STRING): STRING
		deferred
		end


	get_value_by_index (index:INTEGER):STRING
		deferred
		end
end
