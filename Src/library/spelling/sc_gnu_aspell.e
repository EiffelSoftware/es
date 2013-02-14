note
	description: "Support for GNU Aspell spell checker."

class
	SC_GNU_ASPELL

inherit

	SC_BACK_END
		redefine
			default_create,
			check_words
		end

	UTF_CONVERTER
		export
			{NONE} all
		undefine
			default_create
		end

create
	default_create, make_with_program_name, make_with_language, make_with_program_name_and_language

feature {NONE} -- Initialization

	default_create
			-- Create with default program name and lanuage.
		do
			make_with_program_name (Default_program_name)
		end

	make_with_program_name (a_program_name: READABLE_STRING_32)
			-- Create with `a_program_name' and default language.
		require
			program_name_nonempty: not a_program_name.is_empty
		do
			make
			program_name := a_program_name
			create {LINKED_LIST [STRING_8]} program_arguments.make
			program_arguments.extend (Command_pipeline_mode)
			create process_factory
			create output_lines.make
			create communication_completed.make (0)
			create {BINARY_SEARCH_TREE_SET [READABLE_STRING_32]} volatile_user_dictionary.make
			volatile_user_dictionary.compare_objects
			create {SC_WORD_SET_XML} ignore_dictionary.make_with_file (ignore_dictionary_file)
		end

	make_with_language (a_language: SC_LANGUAGE)
			-- Create with default program name and `a_language'.
		do
			make_with_program_name_and_language (Default_program_name, a_language)
		end

	make_with_program_name_and_language (a_program_name: READABLE_STRING_32; a_language: SC_LANGUAGE)
			-- Create with `a_program_name' and `a_language'.
		require
			program_name_nonempty: not a_program_name.is_empty
		do
			make_with_program_name (a_program_name)
			set_language (a_language)
		end

feature -- Status

	language: SC_LANGUAGE
			-- <Precursor>
		local
			input_lines: LINKED_LIST [READABLE_STRING_32]
		do
			failure_message := ""
			if attached maybe_language as just_language then
				Result := just_language.deep_twin
			else
					-- Find out language by running program.
				create input_lines.make
				input_lines.extend (Symbol_current_language)
				communicate_with_program (input_lines, 2)
				if is_successful then
					create Result.make (output_lines [2])
				else
						-- Any language needed.
					Result := Default_source_code_language
				end
			end
		end

	is_language_available (a_language: SC_LANGUAGE): BOOLEAN
			-- <Precursor>
		local
			arguments: LINKED_LIST [STRING_8]
			input_lines: LINKED_LIST [READABLE_STRING_32]
		do
			failure_message := ""
				-- This avoids expensive start of GNU Aspell when
				-- checking contracts about language availability.
			Result := True
				-- TODO: uncomment.
				--		-- Try to use program with given language and check exit status.
				--	create arguments.make
				--	arguments.extend (Command_pipeline_mode)
				--	arguments.extend (Option_language)
				--	arguments.extend (a_language.simplified_code)
				--	create input_lines.make
				--		-- Use exceptional communication.
				--	communicate_directly_with_program (arguments, input_lines, 1, True)
				--	if is_successful then
				--		Result := output_lines.first.starts_with (Symbol_metadata)
				--	end
		end

	set_language (a_language: SC_LANGUAGE)
			-- <Precursor>
		do
			failure_message := ""
				-- Change program arguments.
			if program_arguments.count = 1 then
					-- No language set yet.
				program_arguments.extend (Option_language)
			else
					-- Remove last language.
				program_arguments.go_i_th (program_arguments.count)
				program_arguments.remove
			end
			program_arguments.extend (a_language.simplified_code)
			maybe_language := a_language.deep_twin
				-- Reset dictionaries.
			volatile_user_dictionary.wipe_out
			create {SC_WORD_SET_XML} ignore_dictionary.make_with_file (ignore_dictionary_file)
		ensure then
			language_set: attached maybe_language as just_language and then just_language.is_equal (a_language)
			volatile_user_dictionary_empty: volatile_user_dictionary.is_empty
		end

feature -- Operations

	check_words (words: LIST [READABLE_STRING_32])
			-- <Precursor>
		local
			checked_words: ARRAY [BOOLEAN]
			input_lines: LIST [READABLE_STRING_32]
			checks: INTEGER
		do
			failure_message := ""
			if words.is_empty then
				corrections.wipe_out
			else
					-- Part of user dictionary not persistent.
				input_lines := volatile_user_dictionary_input_lines
					-- Filter words of ignore dictionary.
				create checked_words.make_filled (False, 1, words.count)
				words.start
				from
				until
					words.off
				loop
					if not ignore_dictionary.has (words.item) then
						checked_words [words.index] := True
							-- One line for every word to check.
						input_lines.extend (Symbol_spell_check + words.item)
						checks := checks + 1
					end
					words.forth
				variant
					words.count - words.index + 1
				end
					-- Very first output line is version identification message.
					-- Pairs of answer line and empty line follow.
					-- Ignore very last empty line.
				communicate_with_program (input_lines, checks * 2)
				if is_successful then
						-- Remove every second line.
					output_lines.start
					from
					invariant
						partitioned: output_lines.index - 1 + output_lines.count = checks * 2
					until
						output_lines.off
					loop
						output_lines.remove
						output_lines.forth
					variant
						checks - output_lines.index + 1
					end
						-- Create correction for every word.
					corrections.wipe_out
					words.start
					output_lines.start
					from
					until
						not is_successful or words.off
					loop
						if checked_words [words.index] then
							process_correction (words.item, output_lines.item)
							output_lines.forth
						else
							corrections.extend (create {SC_CORRECTION}.make_from_correct_word (words.item))
						end
						words.forth
					variant
						words.count - words.index + 1
					end
					is_checked := is_successful
				end
			end
		end

	extend_user_dictionary (word: READABLE_STRING_32)
			-- <Precursor>
		do
			failure_message := ""
			volatile_user_dictionary.extend (word)
		end

	store_user_dictionary
			-- <Precursor>
		local
			input_lines: LIST [READABLE_STRING_32]
		do
			failure_message := ""
			if not volatile_user_dictionary.is_empty then
					-- Store difference not yet made persistent.
				input_lines := volatile_user_dictionary_input_lines
					-- This does not give any answer line.
				input_lines.extend (Symbol_store_user_dictionary)
					-- Make sure to know when command completed,
					-- otherwise process may be terminated too early.
				input_lines.extend (Symbol_completion)
					-- Metadata and completion lines expected as answer.
				communicate_with_program (input_lines, 2)
				if is_successful then
					volatile_user_dictionary.wipe_out
				end
			end
		ensure then
			volatile_user_dictionary_empty: is_successful implies volatile_user_dictionary.is_empty
		end

	user_dictionary_words: SET [READABLE_STRING_32]
			-- <Precursor>
		local
			input_lines: LINKED_LIST [READABLE_STRING_32]
			origin: INTEGER
			raw_list: STRING_32
		do
			failure_message := ""
			create {BINARY_SEARCH_TREE_SET [READABLE_STRING_32]} Result.make
			Result.compare_objects
			create input_lines.make
			input_lines.extend (Symbol_current_user_dictionary)
				-- Metadata line followed by persistent part of user dictionary expected.
			communicate_with_program (input_lines, 2)
			if is_successful then
				raw_list := output_lines [2]
				origin := raw_list.substring_index (Symbol_list_origin, 1)
				if origin = 0 then
					failure_message := "Unknown format of current user dictionary."
				else
					Result.deep_copy (volatile_user_dictionary)
					raw_list.remove_head (origin + Symbol_list_origin.count)
					Result.fill (segment_text (raw_list, Symbol_list_separator))
				end
			end
		end

	extend_ignore_dictionary (word: READABLE_STRING_32)
			-- <Precursor>
		do
			ignore_dictionary.extend (word)
			failure_message := ignore_dictionary.failure_message
		end

	store_ignore_dictionary
			-- <Precursor>
		do
			ignore_dictionary.store
			failure_message := ignore_dictionary.failure_message
		end

	ignore_dictionary_words: SET [READABLE_STRING_32]
			-- <Precursor>
		do
			Result := ignore_dictionary.words
			failure_message := ignore_dictionary.failure_message
		end

feature {NONE} -- Implementation

	maybe_language: detachable SC_LANGUAGE
			-- Language if given by user, otherwise Void for default.

	volatile_user_dictionary: SET [READABLE_STRING_32]
			-- Words of user dictionary not stored persistently at this moment.

	volatile_user_dictionary_input_lines: LIST [READABLE_STRING_32]
			-- Input lines to append volatile user dictionary temporarily.
		local
			words: LINEAR [READABLE_STRING_32]
		do
			create {LINKED_LIST [READABLE_STRING_32]} Result.make
			words := volatile_user_dictionary.linear_representation
			words.start
			from
			until
				words.off
			loop
				Result.extend (Symbol_extend_user_dictionary + words.item)
				words.forth
			end
		ensure
			counts_match: Result.count = volatile_user_dictionary.count
		end

	ignore_dictionary: SC_WORD_SET
			-- Full word set to ignore.

	ignore_dictionary_file: FILE
			-- File for persistent storage of ignore dictionary.
		do
			create {PLAIN_TEXT_FILE} Result.make_with_name (language.out + "_ignore_dictionary.xml")
		end

feature {NONE} -- Process interaction

	Default_program_name: READABLE_STRING_32
			-- Default filename of program by guessing.
		local
			filename: FILE_NAME
		once
			create filename.make
			if {PLATFORM}.is_windows then
				filename.set_volume ("C:")
				filename.set_subdirectory ("Program Files (x86)")
				filename.set_subdirectory ("Aspell")
				filename.set_subdirectory ("bin")
				filename.set_file_name ("aspell")
				filename.add_extension ("exe")
			else
				filename.set_directory ("usr")
				filename.set_subdirectory ("bin")
				filename.set_subdirectory ("aspell")
			end
			Result := utf_8_string_8_to_string_32 (filename.string)
		ensure
			nonempty: not Result.is_empty
		end

	Command_pipeline_mode: STRING_8 = "-a"
			-- Pipeline mode instead of file mode.

	Option_language: STRING_8 = "--lang"
			-- Command-line option for language.

	Success_exit_status: INTEGER = 0
			-- Exit status of program meaning success.

	program_name: READABLE_STRING_32
			-- Full name of command-line interface.
			-- Filename should be absolute, not relative.
		attribute
		ensure
			nonempty: not Result.is_empty
		end

	program_arguments: LIST [STRING_8]
			-- Command-line arguments.

	last_exit_status: INTEGER
			-- Most recent exit status of child process.

	process_factory: PROCESS_FACTORY
			-- Creation of processes.

	communication_completed: SEMAPHORE
			-- Synchronization of parent and child process.

	is_waiting: BOOLEAN
			-- Does parent process expect more information from child process?

	completed_output_lines: INTEGER
			-- Number of completed output lines.

	output_lines: LINKED_LIST [STRING_32]
			-- Output lines so far with last one maybe not yet completed.
			-- Newlines are not present any more, but removed instead.

	communicate_with_program (input_lines: LIST [READABLE_STRING_32]; output_line_count: INTEGER)
			-- Feed program with `input_lines' as input and wait
			-- for `output_line_count' output lines. Use default
			-- program arguments and check exit status.
		do
			communicate_directly_with_program (program_arguments, input_lines, output_line_count, False)
			if is_successful and last_exit_status /= Success_exit_status then
				failure_message := "Unexpected exit status " + last_exit_status.out + " of process."
			end
		end

	communicate_directly_with_program (arguments: LIST [STRING_8]; input_lines: LIST [READABLE_STRING_32]; output_line_count: INTEGER; is_exceptional: BOOLEAN)
			-- Use given command-line `arguments' for program, feed it
			-- with `input_lines' as input and wait for `output_line_count'
			-- output lines. Do not check exit status. In case of
			-- `is_exceptional', program exit or failure is not treated
			-- as failure. Otherwise, these are not expected and cause
			-- failure.
		require
			output_line_count_nonnegative: output_line_count >= 0
		local
			name: STRING_8
			process: PROCESS
			raw_input_line: STRING_8
		do
				-- Assuming that program name needs to be in UTF-8.
			name := string_32_to_utf_8_string_8 (Program_name)
				-- Use current working directory for process.
			process := process_factory.process_launcher (name, arguments, Void)
			process.set_on_fail_launch_handler (agent process_failure("Unable to launch process."))
			if is_exceptional then
					-- Premature termination with failure message is fine.
				process.set_on_exit_handler (Void)
				process.redirect_error_to_agent (agent process_output(output_line_count, ?))
			else
				process.set_on_exit_handler (agent process_failure("Unexpected process exit."))
				process.redirect_error_to_agent (agent process_failure)
			end
			process.redirect_input_to_stream
			process.redirect_output_to_agent (agent process_output(output_line_count, ?))
				-- Reset semaphore just to make sure.
			from
			until
				not communication_completed.try_wait
			loop
			end
				-- Reset means of communication between two processes.
			is_waiting := output_line_count >= 1
			completed_output_lines := 0
			output_lines.wipe_out
			process.launch
			if process.launched then
				across
					input_lines as input_line
				loop
						-- Do not forget to finish with newline.
					raw_input_line := string_32_to_utf_8_string_8 (input_line.item + Default_newline)
					process.put_string (raw_input_line)
				end
				if output_line_count >= 1 then
						-- Wait until failure happens or all desired answer lines completed.
					communication_completed.wait
					check
						is_waiting = False
					end
				end
				if process.force_terminated then
					failure_message := "Process unexpectedly terminated by user."
				else
					process.terminate
						-- Wait for end of process.
					process.wait_for_exit
					if not process.last_termination_successful then
						failure_message := "Unable to terminate process."
					else
						last_exit_status := process.exit_code
						failure_message := ""
					end
				end
			end
		end

	process_failure (message: STRING_8)
			-- Take measures in case of failure with `message'.
		do
				-- Ignore empty messages, because they do not harm so far.
			if not message.is_empty then
				failure_message := utf_8_string_8_to_string_32 (message)
				if is_waiting then
						-- Parent process cannot expect more.
					is_waiting := False
						-- Communication terminated.
					communication_completed.post
				end
			end
		end

	process_output (output_line_count: INTEGER; part: STRING_8)
			-- Until `output_line_count' output lines are completed,
			-- process next `part' of program output.
		local
			text: STRING_32
			newline: TUPLE [base, length: INTEGER]
			is_exhausted: BOOLEAN
		do
			if is_waiting and completed_output_lines < output_line_count then
					-- Relevant information.
				text := utf_8_string_8_to_string_32 (part)
				from
				until
					is_exhausted
				loop
					if completed_output_lines = output_lines.count then
							-- Go to next line.
						output_lines.extend ("")
					end
					newline := first_newline (text)
					if newline.base = 0 then
							-- Not yet terminated with newline.
						output_lines.last.append (text)
						is_exhausted := True
					else
							-- Line completed.
						completed_output_lines := completed_output_lines + 1
						if completed_output_lines = output_line_count then
								-- It is last line.
							text.keep_head (newline.base - 1)
							output_lines.last.append (text)
							is_exhausted := True
								-- Parent process must be happy now.
							is_waiting := False
								-- Signal parent process that answer completed.
							communication_completed.post
						else
							output_lines.last.append (text.substring (1, newline.base - 1))
							text.remove_head (newline.base + newline.length - 1)
							is_exhausted := text.is_empty
						end
					end
				end
			end
		end

feature {NONE} -- Pipeline format

	Symbol_metadata: STRING_32 = "@(#)"
			-- Symbol for version identification message.

	Symbol_word_found: STRING_32 = "*"
			-- Symbol for word found in main or personal dictionary.

	Symbol_suggestions_found: STRING_32 = "&"
			-- Symbol for word not in dictionary, but suggestions exist.

	Symbol_list_origin: STRING_32 = ": "
			-- Symbol to introduce list.

	Symbol_list_separator: STRING_32 = ", "
			-- Symbol to separate elements of list.

	Symbol_no_suggestions: STRING_32 = "#"
			-- Not in dictionary and no suggestions.

	Symbol_extend_user_dictionary: STRING_32 = "*"
			-- Extend user dictionary with word.

	Symbol_store_user_dictionary: STRING_32 = "#"
			-- Make user dictionary persistent.

	Symbol_spell_check: STRING_32 = "^"
			-- Simply check rest of line.

	Symbol_current_user_dictionary: STRING_32 = "$$pp"
			-- Command for all words in current user dictionary.

	Symbol_current_language: STRING_32 = "$$l"
			-- Command for name of current language.

	Symbol_completion: STRING_32
			-- Symbol for any command with always exactly one answer line.
			-- This can be appended to sequence of commands to make sure
			-- that last one completed if it has no answer lines.
		once
			Result := Symbol_current_language
		end

	process_correction (word, raw_correction: READABLE_STRING_32)
			-- Given `word' has correction line `raw_correction'.
			-- Process to use it for corrections.
		require
			word_valid: is_word (word)
		local
			correction: SC_CORRECTION
			origin: INTEGER
			raw_suggestions: READABLE_STRING_32
			suggestions: LIST [READABLE_STRING_32]
		do
			if raw_correction ~ Symbol_word_found then
				create correction.make_from_correct_word (word)
				corrections.extend (correction)
			elseif raw_correction.starts_with (Symbol_suggestions_found) then
				origin := raw_correction.substring_index (Symbol_list_origin, Symbol_suggestions_found.count + 1)
				if origin = 0 then
					failure_message := "Unknown format of suggestions."
				else
					raw_suggestions := raw_correction.substring (origin + Symbol_list_origin.count, raw_correction.count)
					suggestions := segment_text (raw_suggestions, Symbol_list_separator)
					if suggestions.is_empty then
						failure_message := "Empty list of suggestions."
					else
						create correction.make_from_incorrect_word (word, suggestions)
						corrections.extend (correction)
					end
				end
			elseif raw_correction.starts_with (Symbol_no_suggestions) then
				create correction.make_from_word_without_suggestions (word)
				corrections.extend (correction)
			else
				failure_message := "Unknown format of correction %"" + raw_correction + "%"."
			end
		end

invariant
	default_language_argument_count: maybe_language = Void implies program_arguments.count = 1
	given_language_argument_count: maybe_language /= Void implies program_arguments.count = 3

end
