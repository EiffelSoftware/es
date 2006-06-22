indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SYNTAX_EXPECTED_BEFORE_ERROR

inherit
	SYNTAX_ERROR
		rename
			make as make_error
		end

create
	make

feature {NONE} -- Initialization

	make (a_line: like line; a_column: like column; a_identifier: like identifier; a_expected: like expected; a_file_name: like file_name) is
			-- Initialize a syntax error for unmatched opending declarations or symbols.
		require
			a_line_positive: a_line > 0
			a_column_positive: a_column > 0
			a_identifier_attached: a_identifier /= Void
			not_a_identifier_is_empty: not a_identifier.is_empty
			a_expected_attached: a_expected /= Void
			not_a_expected_is_empty: not a_expected.is_empty
			a_file_name_attached: a_file_name /= Void
			not_a_file_name_is_empty: not a_file_name.is_empty
			a_file_name_exists: (create {PLAIN_TEXT_FILE}.make (a_file_name)).exists
		local
			l_message: like message
		do
			create l_message.make (a_identifier.count + a_expected.count + 41)
			l_message.append (a_identifier)
			l_message.append (once " is expected to be precceded by ")
			l_message.append (a_expected)
			l_message.append (once ".")
			make_error (a_line, a_column, a_file_name, l_message, false)
			identifier := a_identifier
			expected := a_expected
		ensure
			line_set: line = a_line
			column_set: column = a_column
			identifier_set: identifier = a_identifier
			expected_set: expected = a_expected
			file_name_set: file_name = a_file_name
		end

feature -- Access

	identifier: STRING
			-- Identifier `expected' was suppose to appear after

	expected: STRING
			-- Expected text

end -- class SYNTAX_EXPECTED_BEFORE_ERROR
