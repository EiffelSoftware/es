note
	description: "Provides an interface for a wrapper to a single row of an SQL result."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_SQL_ROW_ABSTRACTION

feature {PS_EIFFELSTORE_EXPORT}

	get_value (column_name: STRING): STRING
		-- Get the value in column `column_name'
		deferred
		end


	get_value_by_index (index:INTEGER):STRING
		-- Get the value at index `index'
		require
			positive_index: index > 0
		deferred
		end
end
