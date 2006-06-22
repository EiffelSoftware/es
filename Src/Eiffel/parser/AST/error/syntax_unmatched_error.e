indexing
	description:
		"Represents a syntax error that was expecting a matching closer, e.g. `(' with `)' or `if' without `then'"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision $"

class SYNTAX_UNMATCHED_ERROR

inherit
	SYNTAX_DUAL_TARGET_ERROR
		rename
			make as make_dual_error,
			alt_line as opener_line,
			alt_column as opener_column
		end

create
	make

feature {NONE} -- Initialization

	make (a_line: like line; a_column: like column; a_opener_line: like opener_line; a_opener_column: like opener_column; a_opener: like opener; a_closer: like expected_closer; a_found: STRING; a_file_name: like file_name) is
			-- Initialize a syntax error for unmatched opending declarations or symbols.
		require
			a_line_positive: a_line > 0
			a_column_positive: a_column > 0
			a_opener_attached: a_opener /= Void
			not_a_opener_is_empty: not a_opener.is_empty
			a_opener_line_positive: a_opener_line > 0
			a_opener_column_positive: a_opener_column > 0
			a_closer_attached: a_closer /= Void
			not_a_closer_is_empty: not a_closer.is_empty
			not_a_found_is_empty: a_found /= Void implies not a_found.is_empty
			a_file_name_attached: a_file_name /= Void
			not_a_file_name_is_empty: not a_file_name.is_empty
			a_file_name_exists: (create {PLAIN_TEXT_FILE}.make (a_file_name)).exists
		local
			l_message: like message
		do
--			create l_message.make (a_opener.count + a_closer.count + 41)
--			l_message.append (a_opener)
--			l_message.append (once " does not have an expected matching ")
--			l_message.append (a_closer)
--			l_message.append (once ".")
--			create l_message.make (100)
			l_message := "Matching " + a_closer + " for " + a_opener + " was expected"
			if a_found /= Void then
				l_message.append (" before '" + a_found + "'")
			end
			l_message.append (".")
			make_dual_error (a_line, a_column, a_opener_line, a_opener_column, l_message, a_file_name)
			opener := a_opener
			expected_closer := a_closer
			found := a_found
		ensure
			line_set: line = a_line
			column_set: column = a_column
			opener_set: opener = a_opener
			opener_line_set: opener_line = a_opener_line
			opener_column_set: opener_column = a_opener_column
			expected_closer_set: expected_closer = a_closer
			found_set: found = a_found
			file_name_set: file_name = a_file_name
		end

feature -- Access

	opener: STRING
			-- Unmatched opener

	expected_closer: STRING
			-- Expected closer

	found: STRING
			-- Found text

invariant
	opener_attached: opener /= Void
	not_opener_is_empty: not opener.is_empty
	expected_closer_attached: expected_closer /= Void
	not_expected_closer_is_empty: not expected_closer.is_empty
	not_found_is_empty: found /= Void implies not found.is_empty

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class SYNTAX_UNMATCHED_ERROR
