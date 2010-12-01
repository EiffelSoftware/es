note
	description: "Summary description for {AFX_DAIKON_VARIABLE_NAME_CODEC}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DAIKON_VARIABLE_NAME_CODEC

feature -- Variable name codec

	escaped_variable_name (a_name: STRING): STRING
			-- Escaped variable name from `a_name'.
			-- Replacing ' ' with "\_", and "\" with "\\".
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		local
			l_index: INTEGER
			l_char: CHARACTER
		do
			create Result.make (a_name.count * 2 + 1)
			from l_index := 1
			until l_index > a_name.count
			loop
				l_char := a_name.item (l_index)

				if l_char = ' ' then
					Result.append ("\_")
				elseif l_char = "\" then
					Result.append ("\\")
				else
					Result.append_character (l_char)
				end

				l_index := l_index + 1
			end
		end

	unescaped_variable_name (a_name: STRING): STRING
			-- Unescape variable names from `a_name'.
			-- Replacing "\_" with " ", and "\\" with "\".
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		local
			l_index: INTEGER
			l_char, l_next_char: CHARACTER
		do
			create Result.make (a_name.count)
			from l_index := 1
			until l_index > a_name.count
			loop
				l_char := a_name.item (l_index)

				if l_char = '\' then
					l_next_char := a_name.item (l_index + 1)
					if l_next_char = '\' then
						Result.append ("\")
					elseif l_next_char = '_' then
						Result.append (" ")
					else
						check should_not_happend: False end
					end
					l_index := l_index + 2
				else
					Result.append_character (l_char)
					l_index := l_index + 1
				end
			end
		end

end
