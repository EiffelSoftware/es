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

	try_add_class_with_name (a_autoteach_instance: AT_AUTOTEACH; a_class_name: STRING)
			-- Adds class with name `a_class_name' to `a_autoteach_instance',
			-- if it exists and has been compiled.
		do
			if attached universe.classes_with_name (a_class_name.as_upper) as l_c and then not l_c.is_empty then
				across
					l_c as ic
				loop
					a_autoteach_instance.add_class (ic.item.config_class)
				end
			else
				output_window.add (at_strings.error + ": " + at_strings.init_class_not_found (a_class_name))
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
			-- Initialization for `Current'.
		local
			l_errors, l_warnings, l_notices: ARRAYED_LIST [STRING]
			l_output_dir: DIRECTORY
			l_min_max: TUPLE [min, max: NATURAL]
			l_output_dir_specified, l_level_specified: BOOLEAN
			l_mode: AT_MODE
			l_current_path: PATH
		do
			can_run := True
			create autoteach_options.make_with_defaults
			create l_errors.make (16)
			create l_warnings.make (16)
			create l_notices.make (16)
			l_mode := enum_mode.M_auto

				-- TODO: One more false positive of CA024 here.
			from
				autoteach_arguments.start
			until
				autoteach_arguments.after
			loop
				autoteach_arguments.item.to_lower
				if autoteach_arguments.item.same_string (at_strings.at_class) or autoteach_arguments.item.same_string (at_strings.at_classes) then
					autoteach_arguments.forth
					if autoteach_arguments.after then
						l_errors.force (at_strings.init_class_list_expected)
					else
						class_name_list := autoteach_arguments.item.split (' ')
					end
				elseif autoteach_arguments.item.same_string (at_strings.at_hint_level) then
						-- Register that we encountered the switch, even if the parsing should later fail.
					l_level_specified := True

					autoteach_arguments.forth

					if not autoteach_arguments.after then
						if autoteach_arguments.item.has ('-') then
								-- Level range
							l_min_max := parse_natural_range_string (autoteach_arguments.item)
						else
								-- Single level
							if autoteach_arguments.item.is_natural then
								create l_min_max
								l_min_max.min := autoteach_arguments.item.to_natural
								l_min_max.max := l_min_max.min
							end
						end
					end

					if attached l_min_max then
						if l_min_max.min <= l_min_max.max then
							autoteach_options.set_hint_level_range (l_min_max.min, l_min_max.max)
						else
							l_min_max := Void
						end
					end

					if not attached l_min_max then
						l_errors.force (at_strings.init_argument_level_expected)
					end
				elseif autoteach_arguments.item.same_string (at_strings.at_code_placeholder) then
					autoteach_arguments.forth
					if autoteach_arguments.after or else not autoteach_arguments.item.is_boolean then
						l_errors.force (at_strings.at_code_placeholder + " " + if autoteach_arguments.after then "" else autoteach_arguments.item end + "%N" + at_strings.init_boolean_value_expected)
						autoteach_arguments.back
					else
						autoteach_options.must_insert_code_placeholder := autoteach_arguments.item.to_boolean
					end
				elseif autoteach_arguments.item.same_string (at_strings.at_output_path) then
					l_output_dir_specified := True
					autoteach_arguments.forth
					if autoteach_arguments.after then
						l_errors.force (at_strings.init_output_dir_expected)
					else
						create l_output_dir.make_with_path (create {PATH}.make_from_string (autoteach_arguments.item))
						autoteach_options.output_directory := l_output_dir
					end
				elseif autoteach_arguments.item.same_string (at_strings.at_level_subfolders) then
					autoteach_options.must_create_level_subfolders := True
				elseif autoteach_arguments.item.same_string (at_strings.at_mode) then
					autoteach_arguments.forth
					if autoteach_arguments.after then
						l_errors.force (at_strings.init_mode_expected (enum_mode.textual_value_list))
					else
						autoteach_arguments.item.to_lower
						if enum_mode.is_valid_value_name (autoteach_arguments.item) then
							l_mode := enum_mode.value (autoteach_arguments.item)
						else
							l_errors.force (at_strings.init_invalid_mode (autoteach_arguments.item, enum_mode.textual_value_list))
						end
					end
				elseif autoteach_arguments.item.same_string (at_strings.at_custom_hint_tables) then
					autoteach_arguments.forth
					if autoteach_arguments.after then
						l_errors.force (at_strings.cht_no_custom_hint_table_path)
					else
						if not hint_tables.file_exists (autoteach_arguments.item) then
							l_errors.force (at_strings.cht_file_not_found)
						else
							hint_tables.load_custom_hint_table (autoteach_arguments.item)
							if attached hint_tables.last_table_load_exception as l_exception then
								l_errors.force (at_strings.cht_parse_error + "%N" + l_exception.description.to_string_8)
							end
						end
					end
				else
					l_errors.force (at_strings.init_unrecognized_argument (autoteach_arguments.item))
				end
				autoteach_arguments.forth
			end

			if not l_output_dir_specified then
				create l_current_path.make_current
				autoteach_options.output_directory := (create {DIRECTORY}.make_with_path (l_current_path))
				l_notices.force (at_strings.init_no_output_directory_option (l_current_path.absolute_path.out))
			end

			if not l_level_specified then
				autoteach_options.set_hint_level_range (0, 0)
				l_notices.force (at_strings.init_no_level_specified)
			end

			if autoteach_options.min_hint_level /= autoteach_options.max_hint_level and not autoteach_options.must_create_level_subfolders then
				l_notices.force (at_strings.init_no_level_subfolders_option)
			end

			if l_mode = enum_mode.M_custom and not attached hint_tables.custom_hint_table then
				l_errors.force (at_strings.proc_no_custom_hint_table_loaded)
			else
				autoteach_options.switch_to_mode (l_mode)
			end

			can_run := l_errors.is_empty

			across
				l_errors as ic
			loop
				print_line (at_strings.error + ": " + ic.item)
			end

			across
				l_warnings as ic
			loop
				print_line (at_strings.warning + ": " + ic.item)
			end

			across
				l_notices as ic
			loop
				print_line (at_strings.notice + ": " + ic.item)
			end

			print_line ("")
		end

	run_autoteach
			-- Runs AutoTeach according to the specified options.
		local
			l_autoteach: AT_AUTOTEACH
		do
			if attached class_name_list as l_class_name_list then
				create l_autoteach.make_with_options (autoteach_options)
				l_autoteach.set_message_output_action (agent print_line)
				across
					l_class_name_list as ic
				loop
					try_add_class_with_name (l_autoteach, ic.item)
				end
				l_autoteach.run_autoteach
			else
				print_line (at_strings.error + ": " + at_strings.init_no_class_list_specified)
			end
		end

feature -- Execution (declared in EWB_CMD)

	execute, check_arguments_and_execute
			-- Execute the AutoTeach command-line tool
		do
			print_line ("%N")
			process_arguments
			if can_run then
				print_line (at_strings.welcome_message + "%N")
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
