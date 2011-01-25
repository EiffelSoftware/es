note
	description: "Class to run a customized RapidMiner process file"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_PROCESS_RUNNER

inherit
	RM_CONSTANTS

	PROCESS_HELPER

create
	make

feature{NONE} -- Initialization

	make (a_rapidminer_home: STRING)
			-- Initialize Current.
		do
			set_rapidminer_home (a_rapidminer_home)
			create parameters.make (10)
			parameters.compare_objects
			set_maximal_memory (512)
		end

feature -- Access

	parameters: HASH_TABLE [STRING, STRING]
			-- Input files
			-- Keys are placeholders inside the process file,
			-- Values are strings that should replace the associated placeholders.

	process_file_path: STRING
			-- Absolute path to the process file in RapidMiner format.
			-- Process is a concept of RapidMiner, it includes all the tasks
			-- that the data mining tool will perform, from data loading, data mining,
			-- to result storing.
			-- Usually, you'll first use the GUI version of RapidMiner to design the process,
			-- save it into a process file, and modify the process file to contain placeholders (so
			-- you can customize it, for example, the place of the input/output files).
			-- Use `parameters' to specify the actual values for the placeholders.

	maximal_memory: INTEGER
			-- Number of maximal MB memory that is to be used by RapidMiner
			-- Default: 1024

	rapidminer_home: STRING
			-- Absolute path the directory where RapidMiner is installed.

	last_output: STRING
			-- Output from Rapidminer from last `run'

feature -- Setting

	set_rapidminer_home (a_path: STRING)
			-- Set `rapidminer_home' with `a_path'.
			-- Note: A new string will be created for `rapidminer_home'.
		do
			rapidminer_home := a_path.twin
		ensure
			rapidminer_jar_path_set: rapidminer_home ~ a_path
		end

	set_maximal_memory (a_memory: INTEGER)
			-- Set `maximal_memory' with `a_memory'.
		require
			a_memory_positive: a_memory > 0
		do
			maximal_memory := a_memory
		ensure
			maximal_memory_set: maximal_memory = a_memory
		end

	set_process_file_path (a_path: STRING)
			-- Set `process_file_path' with `a_path'.
			-- Note: a new string will be created for `process_file_path'.
		do
			process_file_path := a_path.twin
		ensure
			process_file_path_set: process_file_path ~ a_path
		end

feature -- Basic operations

	run
			-- Use Rapidminer specified in `rapidminer_home' to run the
			-- process specified in `process_file_path'.
			-- Make output from the execution available in `last_output'
		require
			process_file_path_set: process_file_path /= Void
		do
				-- Steps to run the process:
				-- 1. Load `a_process_file_path'.
				-- 2. Replace all placeholders in the process file with `parameters'.
				-- 3. Execute the new process.
				-- 4. Clean up.
			generate_new_process_file
			run_rapidminer
			cleanup
		end

feature{NONE} -- Implementation

	generate_new_process_file
			-- Generate new process file using `parameters'.
		local
			l_file: PLAIN_TEXT_FILE
			l_content: STRING

		do
				-- Load original process file.
			create l_file.make_open_read (process_file_path)
			l_file.read_stream (l_file.count)
			l_content := l_file.last_string.twin
			l_file.close

				-- Customize the content of the original process file
				-- with `parameters'.
			across parameters as l_params loop
				l_content.replace_substring_all (l_params.key, l_params.item)
			end

				-- Store customized process into a temporary file.			
			create l_file.make_create_read_write (temporary_process_file_path)
			l_file.put_string (l_content)
			l_file.close
		end

	run_rapidminer
			-- Run RapidMiner.
		local
			l_output: STRING
		do
			last_output := output_from_program (command_line, Void)
		end

	cleanup
			-- Clean up after RapidMiner execution.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make (temporary_process_file_path)
			if l_file.exists then
				l_file.delete
			end
		end

	temporary_process_file_path: STRING
			-- Absolute path to the temporary process file
		local
			l_path: FILE_NAME
		do
			create l_path.make_from_string (rm_environment.temp_directory)
			l_path.set_file_name ("temp_process.rmp")
			Result := l_path.out
		end

	command_line: STRING
			-- Command line to run RapidMiner
		local
			l_env: EXECUTION_ENVIRONMENT
			l_classpath: STRING
			l_platform: PLATFORM
			l_rapidminer_jar: FILE_NAME
			l_java: STRING
		do
			create l_env
			l_classpath := l_env.get ("CLASSPATH")
			if l_classpath = Void then
				 create l_classpath.make (64)
			else
				l_classpath := l_classpath.twin
			end

			create l_rapidminer_jar.make_from_string (rapidminer_home)
			l_rapidminer_jar.extend ("lib")
			l_rapidminer_jar.set_file_name ("rapidminer.jar")

			create l_platform
			if not l_classpath.is_empty then
				if l_platform.is_windows then
					l_classpath.append_character (';')
				else
					l_classpath.append_character (':')
				end
			end
			if l_platform.is_windows then
				l_java := "CMD /C java "
			else
				l_java := "/usr/bin/java "
			end
			l_classpath.append (l_rapidminer_jar)

			create Result.make (128)
			Result.append (l_java)
			Result.append (" -Xmx")
			Result.append (maximal_memory.out)
			Result.append_character ('m')
			Result.append (" -cp " )
			Result.append (l_classpath)
			Result.append (" -Drapidminer.home=")
			Result.append (rapidminer_home)
			Result.append (" com.rapidminer.RapidMinerCommandLine -f ")
			Result.append (temporary_process_file_path)
		end

end
