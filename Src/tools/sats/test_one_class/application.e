indexing
	description : "[
		Tester for one class
			]"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

	EXECUTION_ENVIRONMENT
		rename
			command_line as current_command_line
		end

	KL_SHARED_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (a_args: ARRAY [STRING])
			-- Run application.
		local
			i: INTEGER
			l_classes: LIST [STRING]
			class_name: STRING
			l_cur_session_index: INTEGER
		do
			project_directory := a_args.item (1)
			config_name := a_args.item (2)
			target_name := a_args.item (3)
			class_name := a_args.item (4).as_upper
			number_of_session := a_args.item (5).to_integer
			session_length := a_args.item (6).to_integer
			desired_host_name := a_args.item (7)
			test_directory := a_args.item (8)
			storage_directory := a_args.item (9)
			starting_session_index := a_args.item (10).to_integer

			if a_args.count = 12 then
				seed_file := a_args.item (11)
				read_seed_file
			end

			create {LINKED_LIST [STRING]} classes_to_test.make
			l_classes := class_name.split (',')
			from
				l_classes.start
			until
				l_classes.after
			loop
				if not l_classes.item.is_empty then
					classes_to_test.extend (l_classes.item)
				end
				l_classes.forth
			end

				-- Tests are performed only when Current machine is the desired machine.
--			if desired_host_name.is_case_insensitive_equal (host_name) then
				from
					i := 1
					l_cur_session_index := starting_session_index
				until
					i > number_of_session
				loop
					from
						classes_to_test.start
					until
						classes_to_test.after
					loop
						io.put_string ("Seed " + seed_of_session (l_cur_session_index).out+ "%N")
						perform_test (l_cur_session_index, classes_to_test.item)
						classes_to_test.forth
					end
					l_cur_session_index := l_cur_session_index + 1
					i := i + 1
				end
--			end
		end

feature -- Access

	starting_session_index: INTEGER
			-- Starting session index

	test_directory: STRING
			-- Directory where test should be performed

	storage_directory: STRING
			-- Directory to store test result

	project_directory: STRING
			-- Location of project used as testee

	config_name: STRING
			-- Config file name

	target_name: STRING
			-- Target of the project used as testee

	number_of_session: INTEGER
			-- Number of sessions for testing `class_name'

	session_length: INTEGER
			-- Length in minute of each session

	desired_host_name: STRING
			-- Host name on which tests are to be performed

	seed_file: STRING
			-- Name of the file containing seeds for each session.
			-- One line in this file contains an integer seed, which will
			-- be used to start the random number generator
			-- If no seed file is provided, current system time will be used as
			-- seed.

	classes_to_test: LIST [STRING]
			-- List of classes to test

feature -- Status report

	is_seed_provided: BOOLEAN is
			-- Is seed for random number generator are already provided?
		do
			Result := seed_file /= Void
		ensure
			good_result: Result = (seed_file /= Void)
		end

feature{NONE} -- Testing

	perform_test (i: INTEGER; a_class_name: STRING) is
			-- Perform `i'-th test.
		require
			i_valid: i >= 1 and then i <= number_of_session
		local
			l_working_directory: STRING
			l_result_directory: STRING
			l_file_name: FILE_NAME
		do
			l_result_directory := result_directory_name (i, a_class_name)
			l_working_directory := current_working_directory.twin
			prepare_test_directory (a_class_name)

			goto_directory (test_directory)

				-- Compile testee project.
			system (ec_command_line (i))

				-- Launch AutoTest.
			system (auto_test_command_line (i, a_class_name))

				-- Prepare result directory.
			prepare_result_directory (i, a_class_name, l_result_directory)

				-- Copy result directory to storage storage directory.
			copy_result_to_storage_directory (i, a_class_name, l_result_directory)

				-- Switch back to original working directory.
			goto_directory (l_working_directory)
		end

	copy_result_to_storage_directory (i: INTEGER; a_class_name: STRING; a_result_directory: STRING) is
			-- Copy result for `i'-th testing session to `storage_directory'.
		local
			l_scp_cmd: STRING
		do
			create l_scp_cmd.make (128)
			l_scp_cmd.append ("scp -r " + a_result_directory + " " + storage_directory)
			system (l_scp_cmd)
		end

	prepare_result_directory (i: INTEGER; a_class_name: STRING; a_result_directory: STRING) is
			-- Prepare result directory.
		local
			l_file_name: FILE_NAME
		do
			file_system.copy_file (proxy_log_file, "proxy_log.txt")
			file_system.copy_file (sat_translator_file, "sat_translator.txt")

			system (zip_command (i))

				-- Copy result file to result directory.
			file_system.create_directory (a_result_directory)
			create l_file_name.make_from_string (a_result_directory)
			l_file_name.set_file_name (result_file_name)
			file_system.copy_file (result_file_name, l_file_name)
			file_system.delete_file (result_file_name)
		end

	result_directory_name (i: INTEGER; a_class_name: STRING): STRING is
			-- Result directory name for `i'-th testing session
		local
			l_time: TIME
		do
			create l_time.make_now
			Result := a_class_name + "_" + session_length.out + "m_" + i.out + "_" + desired_host_name + "_" + l_time.milli_second.out
		ensure
			result_attached: Result /= Void
		end

	result_file_name: STRING is "result.tar.gz"

	ec_command_line (i: INTEGER): STRING is
			-- AutoTest command line for `i'-th test
		require
			i_valid: i >= 1 and then i <= number_of_session
		do
			create Result.make (128)
			Result.append ("ec -config " + config_name + " -target " + target_name + " -instrument_config instrument.config -clean -c_compile")
		ensure
			result_attached: Result /= Void
		end

	auto_test_command_line (i: INTEGER; a_class_name: STRING): STRING is
			-- AutoTest command line for `i'-th test
		require
			i_valid: i >= 1 and then i <= number_of_session
		do
			create Result.make (128)
			Result.append ("ec -config " + config_name + " -target " + target_name + " -instrument_config instrument.config -auto_test -i --time-out " + session_length.out + " --seed " + seed_of_session (i).out + " " + a_class_name)
		ensure
			result_attached: Result /= Void
		end

	zip_command (i: INTEGER): STRING is
			-- Zip command for `i'-th testing session
		do
			create Result.make (128)
			Result.append ("tar -czvf " + result_file_name + " sat_*.log proxy_log.txt sat_translator.txt")
		ensure
			result_attached: Result /= Void
		end

	proxy_log_file: STRING is
			-- Path for `proxy_log.txt"
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string (auto_test_directory)
			l_file_name.set_file_name ("proxy_log.txt")
			Result := l_file_name.out
		ensure
			result_attached: Result /= Void
		end

	sat_translator_file: STRING is
			-- Path for `sat_translator.txt"
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string (w_code_directory)
			l_file_name.set_file_name ("sat_translator.txt")
			Result := l_file_name.out
		ensure
			result_attached: Result /= Void
		end

	auto_test_directory: STRING is
			-- Directory for AutoTest generated files
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string ("")
			l_file_name.set_subdirectory ("EIFGENs")
			l_file_name.set_subdirectory (target_name)
			l_file_name.set_subdirectory ("Testing")
			l_file_name.set_subdirectory ("auto_test")
			l_file_name.set_subdirectory ("log")
			Result := l_file_name.out
		ensure
			result_attached: Result /= Void
		end

	w_code_directory: STRING is
			-- W_code directory for testee project
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string ("")
			l_file_name.set_subdirectory ("EIFGENs")
			l_file_name.set_subdirectory (target_name)
			l_file_name.set_subdirectory ("W_code")
			Result := l_file_name.out
		ensure
			result_attached: Result /= Void
		end

	goto_test_directory is
			-- Switch current directory to `test_directory'.
		do
			change_working_directory (test_directory)
		end

	prepare_test_directory (a_class_name: STRING) is
			-- Prepare testee directory.
		do
				-- Remove everything recursively in `test_directory'.
			file_system.recursive_delete_directory (test_directory)

				-- Copy testee project into `test_directory'.
			file_system.recursive_copy_directory (project_directory, test_directory)

			goto_directory (test_directory)

				-- Generate instrument config file.
			generate_instrument_config (a_class_name)
		end

	generate_instrument_config (a_class_name: STRING) is
			-- Generate instrument config file in current working directory.
		local
			l_plain_text_file: PLAIN_TEXT_FILE
		do
			create l_plain_text_file.make_create_read_write ("instrument.config")
			l_plain_text_file.put_string ("--SET%N")
			l_plain_text_file.put_string ("DCS=true%N")
			l_plain_text_file.put_string ("--DCS%N")
			l_plain_text_file.put_string (a_class_name + "%Tancestor=true%N")
			l_plain_text_file.close
		end

	goto_directory (a_dir: STRING) is
			-- Switch curent working directory to `a_dir'.
		require
			a_dir_attached: a_dir /= Void
		do
			change_working_directory (a_dir)
		end

feature{NONE} -- Implementation

	host_name: STRING is
			-- Host name of Current machine
		local
			l_prc_factory: PROCESS_FACTORY
			l_prc: PROCESS
		do
			create l_prc_factory
			create output.make (1024)
			l_prc := l_prc_factory.process_launcher_with_command_line ("hostname", Void)
			l_prc.redirect_output_to_agent (agent store_output)
			l_prc.launch
			l_prc.wait_for_exit
			Result := output.twin
			Result.replace_substring_all ("%R", "")
			Result.replace_substring_all ("%N", "")
		ensure
			result_attached: Result /= Void
		end

	store_output (a_output: STRING) is
			-- Store `a_output' in `output'.
		require
			a_output_attached: a_output /= Void
		do
			check output /= Void end
			output.append (a_output)
		end

	output: STRING
			-- Output from process

	seed_of_session (i: INTEGER): INTEGER is
			-- Seed for `i'-th testing session
			-- If seed file is provided, result value is the `i'-th integer in that file,
			-- if seed file is not provided, result is the integer representation of Current time.
		local
			time:TIME
		do
			if is_seed_provided then
				Result := seeds.item (i)
			else
				create time.make_now
				Result := time.milli_second + 1
			end
		ensure
			result_positive: result > 0
		end

	read_seed_file is
			-- Read seeds from `seed_file' and store them
			-- in `seeds'. The order of seeds as appeared in `seed_file'
			-- is preserved.
		require
			seed_provided: is_seed_provided
		local
			l_file: PLAIN_TEXT_FILE
			i: INTEGER
			l_str: STRING
		do
			create l_file.make_open_read (seed_file)
			create seeds.make (1, 30)
			from
				l_file.read_line
				i := 1
			until
				l_file.after
			loop
				if not l_file.last_string.is_empty then
					l_str := l_file.last_string.twin
					l_str.replace_substring_all ("%T", "")
					l_str.replace_substring_all ("%R", "")
					seeds.force (l_str.to_integer, i)
					i := i + 1
				end
				l_file.read_line
			end
			l_file.close
		end

	seeds: ARRAY [INTEGER]
			-- List of provided seeds from `seed_file'

end
