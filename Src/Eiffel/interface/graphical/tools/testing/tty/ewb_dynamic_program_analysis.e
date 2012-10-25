note
	description: "Command for dynamic program analysis."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_DYNAMIC_PROGRAM_ANALYSIS

inherit
	EWB_CMD
		rename
			arguments as raw_arguments
		export
			{NONE} all
			{ANY} workbench
		end

	CI_SHARED_SESSION
		export
			{NONE} all
		end

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_arguments: like arguments)
			-- Initialize command.
		require
			a_arguments_not_void: a_arguments /= Void
		do
			create arguments.make
			a_arguments.do_all (agent arguments.extend)
		ensure
			arguments_not_void: arguments /= Void
			arguments_set: arguments.count = a_arguments.count
		end

feature -- Access

	arguments: LINKED_LIST [STRING]
			-- Arguments to dynamic program analysis command line.

feature -- Properties

	name: STRING
		once
			Result := "Dynamic Program Analysis"
		end

	help_message: STRING_GENERAL
		once
			Result := "Dynamic Program Analysis"
		end

	abbreviation: CHARACTER
		once
			Result := 't'
		end

	execute
			-- Action performed when invoked from the command line.
		local
			l_parser: DPA_COMMAND_LINE_PARSER
			l_configuration: DPA_CONFIGURATION
			l_command: DPA_COMMAND
		do
			create l_configuration.make (system)
			create l_parser.make (arguments, l_configuration)
			l_parser.parse
			l_configuration := l_parser.last_configuration

			create l_command.make (l_configuration)
			l_command.execute
		end

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
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
