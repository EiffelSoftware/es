note
	description: "Summary description for {DKN_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DKN_UTILITY

inherit
	DKN_CONSTANTS

	EPA_PROCESS_UTILITY

	EPA_TEMPORARY_DIRECTORY_UTILITY

feature -- Access	

	encoded_daikon_name (a_name: STRING): STRING
			-- Escaped variable name from `a_name'.
			-- Replacing ' ' with "\_", and "\" with "\\".
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			create Result.make_from_string (a_name)
			Result.replace_substring_all ("\", "\\")
			Result.replace_substring_all (" ", "\_")
		end

	decoded_daikon_name (a_name: STRING): STRING
			-- Unescape variable names from `a_name'.
			-- Replacing "\_" with " ", and "\\" with "\".
		require
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			create Result.make_from_string (a_name)
			Result.replace_substring_all ("\_", " ")
			Result.replace_substring_all ("\\", "\")
		end

	invariants_from_daikon (a_command: STRING; a_declarations: DKN_DECLARATION; a_trace: DKN_TRACE): DS_HASH_TABLE [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]
			-- Invariants generated from Daikon using `a_command' on data `a_declarations' and `a_trace'
			-- `a_command' is the Daikon command line without input files, for example "java daikon.Daikon"
		local
			l_cmd: STRING
			l_decls_file: STRING
			l_trace_file: STRING
			l_output: STRING
			l_parser: DKN_RESULT_PARSER
			l_file: RAW_FILE
		do
				-- Create temp file for declaractions.
			l_decls_file := file_in_temporary_directory ("daikon_input.decls")
			a_declarations.to_file (l_decls_file)

			l_trace_file := file_in_temporary_directory ("daikon_input.dtrace")
			a_trace.to_file (l_trace_file)

				-- Construct Daikon command line.
			create l_cmd.make (a_command.count + 64)
			l_cmd.append (a_command)
			l_cmd.append_character (' ')
			l_cmd.append (l_decls_file)
			l_cmd.append_character (' ')
			l_cmd.append (l_trace_file)

				-- Run Daikon and parse results.
			l_output := output_from_program (l_cmd, Void)
			create l_parser
			l_parser.parse_from_string (l_output, a_declarations)
			Result := l_parser.last_invariants

				-- Remove temp files.
--			create l_file.make (l_decls_file)
--			l_file.delete

--			create l_file.make (l_trace_file)
--			l_file.delete
		end

end
