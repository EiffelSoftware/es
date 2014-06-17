note
	description: "AutoTeach command."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_AUTOTEACH

inherit

	EWB_CMD

	AT_COMMON

	SHARED_SERVER
		export
			{NONE} all
		end

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_arguments: attached LIST [STRING])
			-- Initialization for `Current'. `a_arguments' are the command-line
			-- arguments that are relevant for the Code Analyzer.
		do
			autoteach_arguments := a_arguments
		ensure
			arguments_set: autoteach_arguments = a_arguments
		end

	try_add_class_with_name (a_hinter: AT_HINTER; a_class_name: STRING)
			-- Adds class with name `a_class_name' if it is found amongst the compiled
			-- classes to `a_analyzer'.
		do
			if attached universe.classes_with_name (a_class_name) as l_c then
				across
					l_c as ic
				loop
					a_hinter.add_class (ic.item.config_class)
				end
			else
				output_window.add (at_strings.error_class_not_found (a_class_name))
			end
		end

feature {NONE} -- Options

	class_name_list: LINKED_LIST [STRING]
			-- List of class names for analysis, which have been provided by the user.

feature {NONE} -- Implementation

	print_line (a_string: READABLE_STRING_GENERAL)
			-- Prints `a_string' and a new line to the output window.
		do
			output_window.add (a_string + "%N")
		end

	autoteach_arguments: attached LIST [STRING]
			-- `arguments' already exists, inherited from EWB_CMD.

	can_run: BOOLEAN

	process_arguments
			-- Initialization for `Current'. `a_arguments' are the command-line
			-- arguments that are relevant for the Code Analyzer.
		local
			l_hinter: AT_HINTER
			l_options: AT_OPTIONS
			l_errors: ARRAYED_LIST [STRING]
			l_level: INTEGER
		do
			can_run := True
			create l_options.make_with_defaults
			create class_name_list.make
			create l_errors.make (16)
			from
				autoteach_arguments.start
			until
				autoteach_arguments.after
			loop
				if autoteach_arguments.item.is_equal ("-atclass") or autoteach_arguments.item.is_equal ("-atclasses") then
					from
						autoteach_arguments.start
					until
						autoteach_arguments.after or autoteach_arguments.item.starts_with ("-")
					loop
						class_name_list.extend (autoteach_arguments.item)
						autoteach_arguments.forth
					end
				elseif autoteach_arguments.item.is_equal ("-at-hint-level") then
					autoteach_arguments.forth
					if autoteach_arguments.after or else not autoteach_arguments.item.is_integer or else not is_valid_hint_level (autoteach_arguments.item.to_integer) then
						l_errors.force (at_strings.error_argument_level)
						can_run := False
					else
						l_options.hint_level := autoteach_arguments.item.to_integer
					end
				end
				autoteach_arguments.forth
			end
			create l_hinter.make_with_options (l_options)
			l_hinter.set_output_action (agent print_line)
			across
				class_name_list as ic
			loop
				try_add_class_with_name (l_hinter, ic.item)
			end
			across
				l_errors as ic
			loop
				print_line (at_strings.error + ": " + ic.item)
			end
		end

	run_autoteach
		do
			print_line ("Running AutoTeach...")
		end

feature -- Execution (declared in EWB_CMD)

	execute
			-- Execute the Code Analysis command-line tool
		do
			process_arguments
			if can_run then
				run_autoteach
			end
				--			output_window.add ("%NTEST%N")
				--			output_window.add ("----------------%N")
		end

feature -- Info (declared in EWB_CMD)

	name: STRING = "AutoTeach"
			-- Name of this command-line tool.

	help_message: STRING_GENERAL
			-- Help message for this command-line tool.
		do
			Result := at_strings.command_line_help
		end

	abbreviation: CHARACTER = 'a'
			-- One-character abbreviation for this command-line tool.

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
