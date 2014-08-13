note
	description: "AutoTeach command."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_AUTOTEACH

inherit

	EWB_CMD
		redefine
			check_arguments_and_execute
		end

	AT_COMMON

	SHARED_SERVER
		export
			{NONE} all
		end

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_arguments: LIST [STRING])
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
			if attached universe.classes_with_name (a_class_name) as l_c and then not l_c.is_empty then
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

	class_name_list: LIST [STRING]
			-- List of class names for AutoTeach, which have been provided by the user.

feature {NONE} -- Implementation

	print_line (a_string: READABLE_STRING_GENERAL)
			-- Prints `a_string' and a new line to the output window.
		do
			output_window.add (a_string + "%N")
		end

	autoteach_arguments: LIST [STRING]
			-- The command line arguments passed to AutoTeach.

	autoteach_options: AT_OPTIONS
			-- The execution options for AutoTeach.

	can_run: BOOLEAN
			-- Is everything ready for execution after processing arguments?

	process_arguments
			-- Initialization for `Current'. `a_arguments' are the command-line
			-- arguments that are relevant for the Code Analyzer.
		local
			l_errors: ARRAYED_LIST [STRING]
			l_output_dir: DIRECTORY
		do
			can_run := True
			create autoteach_options.make_with_defaults
			create l_errors.make (16)

				-- TODO: One more false positive of CA024 here.
			from
				autoteach_arguments.start
			until
				autoteach_arguments.after
			loop
				if autoteach_arguments.item.same_string ("-at-hinter") then
					autoteach_options.should_run_hinter := true
				elseif autoteach_arguments.item.same_string ("-at-class") or autoteach_arguments.item.same_string ("-at-classes") then
					autoteach_arguments.forth
					if autoteach_arguments.after then
						l_errors.force (at_strings.error_no_class_list)
						can_run := False
					else
						class_name_list := autoteach_arguments.item.split (' ')
					end
				elseif autoteach_arguments.item.same_string ("-at-hint-level") then
					autoteach_arguments.forth
					if autoteach_arguments.after or else not autoteach_arguments.item.is_integer or else not is_valid_hint_level (autoteach_arguments.item.to_integer) then
						l_errors.force (at_strings.error_argument_level)
						can_run := False
					else
						autoteach_options.hint_level := autoteach_arguments.item.to_integer
					end
				elseif autoteach_arguments.item.same_string ("-at-code-placeholder") then
					autoteach_arguments.forth
					if autoteach_arguments.after or else not autoteach_arguments.item.is_boolean then
						l_errors.force ("-at-code-placeholder " + autoteach_arguments.item + "%N" + at_strings.error_boolean_value)
						autoteach_arguments.back
					else
						autoteach_options.insert_code_placeholder := autoteach_arguments.item.to_boolean
					end
				elseif autoteach_arguments.item.same_string ("-at-output-path") then
					autoteach_arguments.forth
					if autoteach_arguments.after then
						l_errors.force (at_strings.error_no_output_dir)
						can_run := False
					else
						create l_output_dir.make_with_path (create {PATH}.make_from_string (autoteach_arguments.item))
						if not l_output_dir.is_writable then
							l_errors.force (at_strings.error_invalid_output_dir)
							can_run := False
						else
							autoteach_options.output_directory := l_output_dir
						end
					end
				elseif autoteach_arguments.item.same_string ("-at-custom-hint-table") then
					autoteach_arguments.forth
					if autoteach_arguments.after then
						l_errors.force (at_strings.error_no_custom_hint_table_path)
						can_run := False
					else
						if not hint_tables.file_exists (autoteach_arguments.item) then
							l_errors.force (at_strings.error_custom_hint_table_file_not_found)
							can_run := False
						else
							hint_tables.load_custom_hint_table (autoteach_arguments.item)
							if attached hint_tables.last_table_load_exception as l_exception then
								l_errors.force (at_strings.error_custom_hint_table_parse_error)
								l_errors.force (l_exception.description.to_string_8)
								can_run := False
							end
						end
					end
				else
					l_errors.force (at_strings.error_unrecognized_argument (autoteach_arguments.item))
					can_run := False
				end
				autoteach_arguments.forth
			end
			if not autoteach_options.should_run_hinter then
				l_errors.force (at_strings.nothing_to_do)
			end
			across
				l_errors as ic
			loop
				print_line (at_strings.error + ": " + ic.item)
			end
		end

	run_autoteach
			-- Runs AutoTeach according to the specified options.
		local
			l_hinter: AT_HINTER
		do
			if autoteach_options.should_run_hinter then
				if attached class_name_list as l_class_name_list then
					create l_hinter.make_with_options (autoteach_options)
					l_hinter.set_message_output_action (agent print_line)
					across
						l_class_name_list as ic
					loop
						try_add_class_with_name (l_hinter, ic.item)
					end
					l_hinter.run_hinter
				else
					print_line (at_strings.error_no_class_list_specified)
				end
			end
		end

feature -- Execution (declared in EWB_CMD)

	execute, check_arguments_and_execute
			-- Execute the AutoTeach command-line tool
		do
			print_line ("%N")
			process_arguments
			if can_run then
				print_line (at_strings.welcome_message)
				run_autoteach
			end
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
