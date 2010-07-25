note
	description: "Hash based set which is also hashed"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_HASH_SET [G -> HASHABLE]

inherit
	EPA_HASH_SET [G]

	HASHABLE
		undefine
			copy,
			is_equal
		end

create
	make

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		local
			l_str: STRING
			l_cursor: like new_cursor
		do
			if hash_code_internal = 0 then
				create l_str.make (256)
				from
					l_cursor := new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_str.append (l_cursor.item.hash_code.out)
					l_str.append_character (',')
					l_cursor.forth
				end
				hash_code_internal := l_str.hash_code
				if hash_code_internal = 0 then
					hash_code_internal := 1
				end
			end

		end

feature{NONE} -- Implementation

	hash_code_internal: INTEGER
			-- Cache for `hash_code'

end
