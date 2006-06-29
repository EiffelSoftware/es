indexing
	description: "Objects that represent auto test project to be tested"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	AUTO_TEST_PROJECT

inherit
	PLATFORM

create {SHARED_AUTO_TEST_PROJECT}
	make

feature {NONE} -- initialization

	make is
		-- create an instance of `AUTO_TEST_PROJECT' to maintain all
		-- the needed properties to test it.
		do
			-- initialize default data structures
			create line_subscribers.make
			create success_subscribers.make
			create summary_subscribers.make

			create classes_to_test.make
			create ise_eiffel_path.make_empty

			-- default values are defined in class `AT_CONFIG_DATA'

			-- initialize execution status
			is_running := False
		end

feature -- initialization interface

	set_project_name (a_string: STRING) is
		-- initialize the project name
		require
			a_string_not_void_not_empty: a_string /= void and then not a_string.is_empty
		do
			create project_name.make_from_string (a_string)
		end

	set_ace_file (a_file: STRING) is
		-- initialize the ace file to be used
		require
			a_file_not_void_not_empty: a_file /= void and then not a_file.is_empty
		do
			create ace_file.make_from_string (a_file)
		end

	set_ise_eiffel_path (a_path: STRING) is
		-- set `ise_eiffel_path' to `a_path'
		require
			a_path_not_void: a_path /= Void and then not a_path.is_empty
		do
			create ise_eiffel_path.make_from_string (a_path)
		end

feature -- project properties initialization interface

	add_class (a_class: STRING) is
		-- add another class to be tested
		require
			classes_to_test_not_full: not classes_to_test.full
			a_class_not_void_not_empty: a_class /= void and then not a_class.is_empty
		do
			classes_to_test.extend (a_class)
		ensure
			classes_to_test_extended: classes_to_test.has (a_class)
		end

	remove_class (a_class: STRING) is
		-- remove a previously chosen class
		require
			classes_to_test_not_empty: not classes_to_test.is_empty
			a_class_not_void_not_empty: a_class /= void and then not a_class.is_empty
		do
			classes_to_test.prune (a_class)
		end

	set_verbose (bool: BOOLEAN) is
		-- set verbose state
		do
			verbose := bool
		end

	set_just_test (bool: BOOLEAN) is
		-- set just_test option
		do
			just_test := bool
		end

	set_manual_testing (bool: BOOLEAN) is
		-- set manual testing option
		do
			manual_testing := bool
		end

	set_auto_testing (bool: BOOLEAN) is
		-- set auto testing option
		do
			auto_testing := bool
		end

	set_minimize (bool: BOOLEAN) is
		-- set minimize option
		do
			minimize := bool
		end

	set_output_directory (a_directory: STRING) is
		-- set output directory to 'a_directory'
		require
			a_directory_not_void_not_empty: a_directory /= void and then not a_directory.is_empty
			a_directory_exists: True			-- it should be a 'possible' directory
		do
			create output_directory.make_from_string (a_directory)
		end

	set_time_out (value: INTEGER) is
		-- set time out value
		require
			value_in_range: value > 0 and then True  -- insert the upper limit here
		do
			time_out := value
		end

feature -- execution status

	is_running: BOOLEAN

feature -- testing execution

	execute is
		-- start the autotest instance
		require
			not_runnning: not is_running
			all_parameters_not_void: ace_file /= void and then True  -- what else is needed
		do
			create at_cmd_param.make
			if is_unix then
				create proc.initialize (at_cmd_param.tmp_script)
			elseif is_windows then
				create proc.initialize (at_cmd_param.execute_command)
			end
			proc.start
		end


feature -- result retrieval

	subscribe_line_command (a_proc: PROCEDURE [ANY,TUPLE[STRING]]) is
		-- subscribe the procedure 'proc' to be called, whenever a whole line
		-- of output is available
		do
			line_subscribers.extend (a_proc)
		ensure
			proc_subscribed: line_subscribers.count = old line_subscribers.count + 1
		end

	subscribe_success (a_proc: PROCEDURE [ANY,TUPLE[BOOLEAN]]) is
		-- subscribe procedure 'proc' to be called, when testing was successful
		do
			success_subscribers.extend (a_proc)
		ensure
			proc_subscribed: success_subscribers.count = old success_subscribers.count + 1
		end

	subscribe_summary_path (a_proc: PROCEDURE [ANY,TUPLE[STRING]]) is
		-- subscribe procedure 'proc' to be called, when the summary path is available
		do
			summary_subscribers.extend (a_proc)
		ensure
			proc_subscribed: summary_subscribers.count = old summary_subscribers.count + 1
		end


feature -- environment data structure

	project_name: STRING
		-- name of project to be tested

	ace_file: STRING
		-- which ace file is used

	ise_eiffel_path: STRING
		-- optional path to select version of EiffelStudio
		-- used for compilation of the testcases

feature -- project data structures

	classes_to_test: LINKED_LIST [STRING]
		-- list of classes to be tested

	verbose: BOOLEAN
		-- should information about testing progress be displayed?

	just_test: BOOLEAN
		-- should a previously generated interpreter be reused?

	manual_testing: BOOLEAN
		-- manual testing enabled?

	auto_testing: BOOLEAN
		-- automated testing strategy enabled?

	minimize: BOOLEAN
		-- is automatic minimization of bug reproduction examples enabled?

	define: BOOLEAN
		-- autotest option concerning xace and gobo!(?)

	output_directory: STRING
		-- where should the output of autotest be saved

	output_summary_link: STRING is
		-- where is the html summary saved
		local
			output_summary: FILE_NAME
		do
			-- set the path to the html files relative to `output_directory'
			create output_summary.make_from_string (output_directory)
			output_summary.extend_from_array (<<"result", "index.html">>)
			Result := output_summary.out
		end

	time_out: INTEGER
		-- how long does autotest run in minutes

	test_finished: BOOLEAN
		-- has the execution of autotest already terminated?

	test_successful: BOOLEAN
		-- no errors (maybe not to be testet here)

	auto_test_version: STRING is
			-- which auto test version is available
		local
		    cmd_param: AT_COMMAND_PARAMETERS
		    at_proc: AT_PROCESS
		once
			create cmd_param.build_version
			if is_windows then
				create at_proc.make_version (cmd_param.execute_command)
			else
				create at_proc.make_version (cmd_param.tmp_script)
			end

			create Result.make_from_string (at_proc.autotest_version)
		ensure
			result_not_void: Result /= Void
		end


feature -- implementation

	at_cmd_param: AT_COMMAND_PARAMETERS
		-- reference to command parameters builder

	proc: AT_PROCESS
		-- process, to start external commands

	line_subscribers: LINKED_LIST [PROCEDURE [ANY,TUPLE[STRING]]]
		-- list of all subscribed line agents

	success_subscribers: LINKED_LIST [PROCEDURE [ANY,TUPLE[BOOLEAN]]]
		-- list of all subscribed success agents

	summary_subscribers: LINKED_LIST [PROCEDURE [ANY,TUPLE[STRING]]]
		-- list of all subscribed summary agents

	post_line (a_string: STRING) is
			-- give an output line to all subscribed agents
			require
				a_string_exists: a_string /= void and then not a_string.is_empty
			do
				from
					line_subscribers.start
				until
					line_subscribers.after
				loop
					line_subscribers.item.call ([a_string])
					line_subscribers.forth
				end
			end

	post_success (a_bool: BOOLEAN) is
			-- give an output to all subscribed success agents
			do
				from
					success_subscribers.start
				until
					success_subscribers.after
				loop
					success_subscribers.item.call ([a_bool])
					success_subscribers.forth
				end
				if a_bool = true then
					post_summary (output_summary_link)
				end
				-- remove the temp script
				at_cmd_param.delete_tmp_script
			end

	post_summary (a_path: STRING) is
			-- pass the path to the summary to all subscribed agents
			require
				a_path_exists: a_path /= void and then not a_path.is_empty
			do
				from
					summary_subscribers.start
				until
					summary_subscribers.after
				loop
					summary_subscribers.item.call ([a_path])
					summary_subscribers.forth
				end

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

end -- class AUTO_TEST_PROJECT
