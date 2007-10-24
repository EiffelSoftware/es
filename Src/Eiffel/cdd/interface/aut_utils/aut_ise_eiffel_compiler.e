indexing
	description: "Objects which start the ISE Eiffel compiler (out of process)"
	author: "Andreas Leitner"
	date: "$Date$"
	revision: "$Revision$"

class AUT_ISE_EIFFEL_COMPILER

inherit

	AUT_SHARED_REGISTRY
		export {NONE} all end

	KL_SHARED_FILE_SYSTEM
		export {NONE} all end

	KL_SHARED_OPERATING_SYSTEM
		export {NONE} all end

	KL_SHARED_EXECUTION_ENVIRONMENT
		export {NONE} all end

	PROCESS_FACTORY
		export {NONE} all end

create

	make

feature {NONE} -- Initialization

	make is
			-- Create new eiffel compiler that will silently surpress all output.
		do
		end

feature -- Status

	is_finalizing_enabled: BOOLEAN
			-- Should the compiler be run in finalize mode?
			-- The resulting executable will execute much faster,
			-- but lack debugging support.

	is_running: BOOLEAN
			-- Is compilation currently running?

	was_successful: BOOLEAN is
			-- Was the last compilation successfull?
		require
			not is_running
		do
			Result := (ec_process /= Void) and then
						(ec_process.has_exited) and then
						(ec_process.exit_code = 0)
		end

feature -- Access

	output_handler: PROCEDURE [ANY, TUPLE [STRING]]
			-- Output handler that will be invoked for any compiler output

feature -- Status Settings

	enable_finalize is
			-- Enable finalizing.
		require
			finalizing_disabled: not is_finalizing_enabled
		do
			is_finalizing_enabled := True
		ensure
			finalizing_enabled: is_finalizing_enabled
		end

	disable_finalize is
			-- Disable finalizing.
		require
			finalizing_enabled: is_finalizing_enabled
		do
			is_finalizing_enabled := False
		ensure
			finalizing_disabled: not is_finalizing_enabled
		end

feature -- Setting

	set_output_handler (an_output_handler: like output_handler) is
			-- Set `output_handler' to `an_output_handler'.
		require
			an_output_handler_not_void: an_output_handler /= Void
		do
			output_handler := an_output_handler
		ensure
			output_handler_set: output_handler = an_output_handler
		end

feature -- Execution

	run (a_working_directory: STRING; a_config_filename: STRING; a_system_name: STRING) is
			-- Run ISE Eiffel compiler in directory `a_working_directory'
			-- compiling the system described via `an_config_file_name'.
			-- Do not block, but return as soon as compiler is running.
		require
			a_working_directory_not_void: a_working_directory /= Void
			a_config_filename_not_void: a_config_filename /= Void
			a_system_name_not_void: a_system_name /= Void
			not_running: not is_running
		local
			arguments: ARRAYED_LIST [STRING]
		do
			create arguments.make (8)
			arguments.force ("-batch")
			arguments.force ("-c_compile")
			if is_finalizing_enabled then
				arguments.force ("-finalize")
				arguments.force ("-keep")
			end
			if a_config_filename.count > 4 then
				if a_config_filename.substring (a_config_filename.count - 3, a_config_filename.count).is_equal (".ace") then
					arguments.force ("-ace")
					arguments.force (a_config_filename)
				else
					arguments.force ("-config")
					arguments.force (a_config_filename)
					arguments.force ("-target")
					arguments.force (a_system_name)
				end
				ec_process := process_launcher (eiffel_compiler_executable_name, arguments, a_working_directory)
				ec_process.redirect_output_to_agent (output_handler)
				ec_process.redirect_error_to_same_as_output
				ec_process.set_buffer_size (512)
				ec_process.enable_launch_in_new_process_group
				is_running := True
				ec_process.set_on_exit_handler (agent unset_running)
				ec_process.set_on_fail_launch_handler (agent unset_running)
				ec_process.set_hidden (True)

				output_handler.call (["launching ec:%N"])
				output_handler.call (["working dir:" + a_working_directory + "%N"])
				output_handler.call (["exe:" + eiffel_compiler_executable_name + "%N"])
				from
					arguments.start
				until
					arguments.off
				loop
					output_handler.call (["arg:" + arguments.item + "%N"])
					arguments.forth
				end
				ec_process.launch
			end
		end

	block is
			-- Block until compilation stops.
		require
			is_running: is_running
		do
			if ec_process.is_running then
				ec_process.wait_for_exit
			end
		end

	terminate is
			-- Terminate current compilation.
		require
			is_running: is_running
		do
			if ec_process.is_running then
				ec_process.terminate
			end
		end

feature -- Constants

	eiffel_compiler_executable_name: STRING is
			-- Name of the command line ISE eiffel compiler
		require
			ise_eiffel_installed: is_ise_eiffel_installed
		once
			Result := file_system.pathname (ise_eiffel_bin_path, "ec")
			if operating_system.is_windows then
				Result.append (".exe")
			end
		ensure
			executable_name_not_void: Result /= Void
		end

	is_ise_eiffel_installed: BOOLEAN is
			-- Is ISE Eiffel installed on this computer?
		once
			if operating_system.is_windows then
				check
					registry_available: registry.is_available
				end
				Result := latest_ise_eiffel_key /= Void
			else
				Result := ise_eiffel_variable /= Void and ise_platform_variable /= Void
			end
		end

	ise_eiffel_path: STRING is
			-- Path to ISE Eiffel directory
		require
			ise_eiffel_installed: is_ise_eiffel_installed
		once
			Result := ise_eiffel_variable
			if Result = Void and registry.is_available then
				Result := registry.string_value (latest_ise_eiffel_key + "\ISE_EIFFEL")
			end
		ensure
			path_not_void: Result /= Void
		end

	ise_eiffel_bin_path: STRING is
			-- Path to ISE Eiffel directory
		require
			ise_eiffel_installed: is_ise_eiffel_installed
		once
			Result := file_system.nested_pathname (ise_eiffel_path, <<"studio", "spec", ise_platform_name, "bin">>)
		ensure
			path_not_void: Result /= Void
			path_not_empty: Result.count > 0
		end

	ise_platform_name: STRING is
			-- Platform name of current computer
		require
			ise_eiffel_installed: is_ise_eiffel_installed
		do
			if operating_system.is_windows then
				Result := "windows"
			else
				Result := ise_platform_variable
			end
		ensure
			name_not_void: Result /= Void
			name_not_empty: Result.count > 0
		end

	ise_eiffel_variable_name: STRING is
			-- Name of ISE Eiffel environment variable
		once
			Result := "ISE_EIFFEL"
		ensure
			name_not_void: Result /= Void
			name_correct: Result.is_equal ("ISE_EIFFEL")
		end

	ise_eiffel_variable: STRING is
			-- Content of environment variable ${ISE_EIFFEL};
			-- `Void' if not set.
		once
			Result := execution_environment.variable_value (ise_eiffel_variable_name)
		end

	ise_platform_variable: STRING is
			-- Content of environment variable ${ISE_PLATFORM};
			-- `Void' if not set.
		once
			Result := execution_environment.variable_value ("ISE_PLATFORM")
		end

feature {NONE} -- Implementation

	unset_running is
			-- Set `is_running' to `False'.
		do
			is_running := False
		ensure
			not_running: not is_running
		end

	ec_process: PROCESS
			-- 'ec' process

	ise_eiffel_common_root_key: STRING is "HKEY_LOCAL_MACHINE\SOFTWARE\ISE"
			-- Key where ISE Eiffel installation will register themselves

	latest_ise_eiffel_key: STRING is
			-- Registry key to the latest installed version of ISE Eiffel
			-- or `Void' if no version installed at all
		require
			registry_available: registry.is_available
		local
			list: DS_LINEAR [STRING]
			cs: DS_LINEAR_CURSOR [STRING]
			matcher: RX_PCRE_MATCHER
			version_string: STRING
			version_number: INTEGER
			max_version_number: INTEGER
		do
			create matcher.make
			matcher.compile ("Eiffel([0-9][0-9])")
			check
				compiled_sucessfully: matcher.is_compiled
			end
			from
				list := registry.subkeys (ise_eiffel_common_root_key)
				cs := list.new_cursor
				cs.start
			until
				cs.off
			loop
				matcher.match (cs.item)
				if matcher.has_matched then
					check
						version_number_match: matcher.is_captured_substring_defined (1)
					end
					version_string := matcher.captured_substring (1)
					check
						valid_number: version_string.is_integer
					end
					version_number := version_string.to_integer
					if version_number > max_version_number then
						max_version_number := version_number
						Result := cs.item
					end
				end
				cs.forth
			end
			if Result /= Void then
				Result.prepend_character ('\')
				Result.prepend_string (ise_eiffel_common_root_key)
			end
		ensure
			key_not_empty: Result /= Void implies Result.count > 0
		end

invariant
	is_running_implies_ec_process_not_void: is_running implies (ec_process /= Void)

end
