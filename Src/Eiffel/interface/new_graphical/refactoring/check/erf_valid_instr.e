note
	description: "Check if a a string is a valid instruction."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_VALID_INSTR

inherit
	ERF_CHECK

	SHARED_WORKBENCH
		export
			{NONE} all
		end
	ETR_SHARED_PARSERS
create
	make

feature {NONE} -- Initialization

	make (a_instr: STRING)
			-- Create check for `a_instr'.
		require
			a_instr_not_void: a_instr /= void
		do
			instr := a_instr
			error_message := "%"" + a_instr + "%" is not a valid instruction."
		end

feature -- Basic operation

	execute
            -- Execute a check.
        do
        	parsing_helper.parse_instruction(instr)

        	success := parsing_helper.parsed_instruction /= void
        end

feature {NONE} -- Implementation

	instr: STRING;
			-- The expr to check.

note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
