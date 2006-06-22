indexing

	description:
		"Syntax error."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision $"

class SYNTAX_UNEXPECTED_ERROR

inherit
	SYNTAX_ERROR
		rename
			make as make_error
		end

create
	make

feature {NONE} -- Initialization

	make (a_line: like line; a_column: like column; a_unexpected: like unexpected; a_file_name: like file_name) is
			-- Initialize a sytax message
		require
			a_line_positive: a_line > 0
			a_column_positive: a_column > 0
			a_unexpected_attached: a_unexpected /= Void
			not_a_unexpected_is_empty: not a_unexpected.is_empty
			a_file_name_attached: a_file_name /= Void
			not_a_file_name_is_empty: not a_file_name.is_empty
			a_file_name_exists: (create {PLAIN_TEXT_FILE}.make (a_file_name)).exists
		do
			make_error (a_line, a_column, a_file_name, once "Unexpected `" + a_unexpected + "' in class text.", false)
			unexpected := a_unexpected
		ensure
			line_set: line = a_line
			column_set: column = a_column
			unexpected_set: unexpected = a_unexpected
			file_name_set: file_name = a_file_name
		end

feature -- Access

	unexpected: STRING;
			-- Unxpected text

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

end -- class SYNTAX_UNEXPECTED_ERROR
