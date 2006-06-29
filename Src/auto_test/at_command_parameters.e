indexing
	description: "Objects that modify the output parameters of the auto test execution instance."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_COMMAND_PARAMETERS

inherit
	EXECUTION_ENVIRONMENT

	PLATFORM

	SHARED_AUTO_TEST_PROJECT
		rename
			project as at_project
		end

create
	make, build_version

feature -- initialization

	make is
			-- creation procedure
			do
				build_args
				put_into_file
			end

	build_version is
			-- create version string
			do
				create command_arguments.make_from_string (" --version")
				create execute_command.make_from_string ("auto_test" + command_arguments)
				put_into_file
			end


feature -- basic computation

	build_args is
			-- create the arguments string
			local
				tmp_string: STRING
			do
				create tmp_string.make_empty
				if at_project.verbose then
					tmp_string.extend (' ')
					tmp_string.append ("--verbose")
				end
				if at_project.just_test then
					tmp_string.extend (' ')
					tmp_string.append ("--just-test")
				end
				if not at_project.manual_testing then
					tmp_string.extend (' ')
					tmp_string.append ("--disable-manual")
				end
				if not at_project.auto_testing then
					tmp_string.extend (' ')
					tmp_string.append ("--disable-auto")
				end
				if not at_project.minimize then
					tmp_string.extend (' ')
					tmp_string.append ("--disable-minimize")
				end
				if at_project.define then
					-- see gobo! nothing here yet
				end

				tmp_string.extend (' ')
				if at_project.output_directory /= void and then not at_project.output_directory.is_empty then
					tmp_string.append ("--output-dir=%"" + at_project.output_directory + "%"" )
				else
					tmp_string.append ("--output-dir=%"" + current_working_directory + "%"" )
				end


				tmp_string.extend (' ')
				tmp_string.append ("--time-out=" + at_project.time_out.out)

				tmp_string.extend (' ')
				tmp_string.append (at_project.ace_file)

				if at_project.classes_to_test /= Void and then not at_project.classes_to_test.is_empty then
					from
						at_project.classes_to_test.start
					until
						at_project.classes_to_test.after
					loop
						tmp_string.extend (' ')
						tmp_string.append (at_project.classes_to_test.item)
						at_project.classes_to_test.forth
					end
				end

--D				io.put_string ("Argument string: " + tmp_string + "%N")

				create command_arguments.make_from_string (tmp_string)
				create execute_command.make_from_string ("auto_test " + command_arguments)
			end

	put_into_file is
			-- create file for execution
			local
				full_script: STRING
				script_file: PLAIN_TEXT_FILE
			do
				if not is_windows then
					create full_script.make_from_string (file_header)
					full_script.append (command_arguments)

					-- create/open the file and give it execute permission
					create script_file.make_open_write (tmp_script)
					system ("chmod +x " + tmp_script)     -- USE BUILTIN FEATURES INSTEAD

					script_file.start
					script_file.put_string (full_script)
					script_file.close
				end
			end

	delete_tmp_script is
			-- delete the temporary executable script
			local
				script_file: PLAIN_TEXT_FILE
			do
					create script_file.make (tmp_script)
					if script_file.exists then
						script_file.delete
					end
			end


feature -- access

	command_arguments: STRING
			-- string holding the arguments for auto test

	execute_command: STRING
			-- string holding the command line instruction

--	at_project: AUTO_TEST_PROJECT
--			-- current auto test project

	tmp_script: STRING is
			-- path to temporary script
			do
				-- works on UNIX and Windows
				create Result.make_from_string (get ("AUTO_TEST") + "/tmp_execution")
			end

	is_version: BOOLEAN
			-- should the version cmd be built?


feature {NONE} -- implementation

	file_header: STRING is
			-- header of executed script
			once
				-- check what operation system you have
				create Result.make_from_string ("#!/bin/sh%N")
				Result.append ("auto_test")
			end


indexing
	copyright:	"Copyright (c) 2006, The AECCS Team"
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
			The AECCS Team
			Website: https://eiffelsoftware.origo.ethz.ch/index.php/AutoTest_Integration
		]"

end -- class AT_COMMAND_PARAMETERS
