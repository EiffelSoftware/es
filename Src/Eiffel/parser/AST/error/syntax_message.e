indexing
	description: "To represent a message related to syntax."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SYNTAX_MESSAGE

feature {NONE} -- Initialization

	make (a_line: like line; a_column: like column; a_file_name: like file_name; a_message: like message; b: BOOLEAN) is
			-- Initialize a sytax message
		require
			a_line_positive: a_line > 0
			a_column_positive: a_column > 0
			a_message_attached: a_message /= Void
			not_a_message_is_empty: not a_message.is_empty
			a_file_name_attached: a_file_name /= Void
			not_a_file_name_is_empty: not a_file_name.is_empty
			a_file_name_exists: (create {PLAIN_TEXT_FILE}.make (a_file_name)).exists
		do
			line := a_line
			column := a_column
--			end_line := a_line
--			end_column := a_column
			message := a_message
			file_name := a_file_name
		ensure
			line_set: line = a_line
			column_set: column = a_column
			message_set: message = a_message
			file_name_set: file_name = a_file_name
		end

feature -- Access

	line: INTEGER
			-- Line number of token involved in syntax issue

	column: INTEGER
			-- Column number of token involved in syntax issue

	file_name: STRING
			-- File name where warning occurred

--	end_line: INTEGER assign set_end_line
--			-- End line number of token involved in syntax issue
--
--	end_column: INTEGER assign set_end_column
--			-- End line number of token involved in syntax issue

	message: STRING
			-- Syntax error message

	code: STRING is
			-- Error code
		deferred
		ensure
			result_attached: Result /= Void
			not_result_is_empty: not Result.is_empty
		end

feature -- Query

	syntax_message: STRING is
			-- Full error message
		local
			l_code: like code
			l_message: like message
		do
			l_code := code
			l_message := message
			l_message.put (l_message.item (1).upper, 1)
			create Result.make (l_code.count + l_message.count + 15)
			Result.append (l_code)
			Result.append (once " (")
			Result.append_integer (line)
			Result.append (", ")
			Result.append_integer (column)
			Result.append ("): ")
			Result.append (l_message)
		ensure
			result_attached: Result /= Void
			not_result_is_empty: not Result.is_empty
		end

--feature -- Status Setting
--
--	set_end_line (a_line: like end_line) is
--			-- Set `end_line' with `a_line'
--		require
--			a_line_big_enough: a_line >= line
--		do
--			end_line := a_line
--		ensure
--			end_line_set: end_line = a_line
--		end
--
--	set_end_column (a_column: like end_column) is
--			-- Set `end_column' with `a_column'
--		require
--			a_column_positive: a_column > 0
--			a_column_big_enough: line = end_line implies a_column >= column
--		do
--			end_column := a_column
--		ensure
--			end_columne_set: end_column = a_column
--		end

invariant
	line_positive: line > 0
	column_positive: column > 0
--	end_line_big_enough: end_line >= line
--	end_column_positive: end_column > 0
--	end_column_big_enough: line = end_line implies end_column >= column
	message_attached: message /= Void
	not_message_is_empty: not message.is_empty
	file_name_attached: file_name /= Void
	not_file_name_is_empty: not file_name.is_empty

end -- class SYNTAX_MESSAGE
