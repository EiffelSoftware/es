indexing
	description: "Syntax message factory for creating syntax related messages"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SYNTAX_MESSAGE_DEFAULT_FACTORY

feature -- Factory Functions

	new_syntax_warning (a_line: INTEGER; a_column: INTEGER; a_message: STRING; a_file_name: STRING): SYNTAX_WARNING is
			-- Creates a new syntax warning
		do

		end

	new_syntax_error (a_line: INTEGER; a_column: INTEGER; a_message: STRING; a_file_name: STRING): SYNTAX_ERROR is
			-- Creates a new syntax error message
		do

		end

	new_syntax_expected_error (a_line: INTEGER; a_column: INTEGER; a_expected: STRING; a_file_name: STRING): SYNTAX_ERROR is
			-- Creates a new expected text (`a_expected') syntax error message
		do

		end

	new_syntax_expected_before_error (a_line: INTEGER; a_column: INTEGER; a_identifier: STRING; a_expected: STRING; a_file_name: STRING): SYNTAX_ERROR is
			-- Creates a new expected text before `a_identifier' syntax error message
		do

		end

	new_syntax_expected_after_error (a_line: INTEGER; a_column: INTEGER; a_identifier: STRING; a_expected: STRING; a_file_name: STRING): SYNTAX_ERROR is
			-- Creates a new expected text (`a_expected') after `a_identifier' syntax error message
		do

		end

	new_syntax_unexpected_error (a_line: INTEGER; a_column: INTEGER; a_unexpected: STRING; a_file_name: STRING): SYNTAX_ERROR is
			-- Creates a new unexpected text (`a_unexpected') syntax error message
		do

		end

	new_syntax_unmatched_error (a_line: INTEGER; a_column: INTEGER; a_opener_line: INTEGER; a_opener_column: INTEGER; a_opener: STRING; a_closer: STRING; a_found: STRING; a_file_name: STRING): SYNTAX_ERROR is
			-- Creates a new unmatched pair syntax error message
		do

		end

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

end -- class SYNTAX_MESSAGE_DEFAULT_FACTORY
