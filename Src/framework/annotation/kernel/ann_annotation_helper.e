note
	description: "Class hosting several helper features for annotation"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ANN_ANNOTATION_HELPER

feature{NONE} -- Implementation

	breakpoints_as_string (a_breakpoints: DS_HASH_SET [INTEGER]): STRING
			-- A comma-separated string representation for `breakpoints'
		local
			l_cursor: DS_HASH_SET_CURSOR [INTEGER]
		do
			create Result.make (32)
			from
				l_cursor := a_breakpoints.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if not Result.is_empty then
					Result.append_character (',')
					Result.append_character (' ')
				end
				Result.append_integer (l_cursor.item)
				l_cursor.forth
			end
		end

end
