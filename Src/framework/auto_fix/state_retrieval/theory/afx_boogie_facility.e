note
	description: "Summary description for {AFX_BOOGIE_LAUNCHER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOGIE_FACILITY

inherit
	AFX_SOLVER_FACILITY
		rename
			solver_output as raw_solver_output
		end

	AFX_SHARED_SESSION

	AFX_SOLVER_CONSTANTS

feature{NONE} -- Implementation

	output_file_path: STRING
			-- Full path of the generated smtlib file
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string (session.config.data_directory)
			l_file_name.set_file_name ("autofix.bpl")
			Result := l_file_name
		end

	generate_file (a_content: STRING)
			-- Generate SMTLIB file at `smtlib_file_path' containing
			-- `a_content'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (output_file_path)
			l_file.put_string (a_content)
			l_file.close
		end

	raw_solver_output (a_content: STRING): STRING
			-- Output from the solver for input `a_content'
		do
			generate_file (a_content)
			Result := output_from_program (boogie_command, Void)
		end

	boogie_command: STRING
			-- Command to launch Boogie
		local
			l_boogie_path: STRING
			l_input_path: STRING
		do
			if {PLATFORM}.is_windows then
				Result := "Boogie.exe /trace " + output_file_path
			else
				l_boogie_path := solved_path ("`which Boogie.exe`")
				l_boogie_path.replace_substring_all ("\", "\\")
				l_input_path := solved_path (output_file_path)
				l_input_path.replace_substring_all ("\", "\\")
				Result := "/usr/bin/wine " + l_boogie_path + " /trace " + l_input_path
			end
		end

	solver_output_for_expressions (a_expressions: LINEAR [EPA_EXPRESSION]; a_solver_input: STRING): HASH_TABLE [STRING, EPA_EXPRESSION]
			-- Output from the solver for checking `a_expressions' in the context of `a_solver_input'.
			-- `a_solver_input' is the input fed to the underlying theorem prover.
			-- Result is a table, key is the expression, value is the solver output for that expression':
			-- output can be either "verified" or "error".
		local
			l_raw_output: STRING
			l_parser: AFX_BOOGIE_OUTPUT_PARSER
			l_tbl: like bpl_procedure_to_expression_table
			l_temp_store: HASH_TABLE [STRING, STRING]
		do
			create l_temp_store.make (20)
			l_temp_store.compare_objects
			l_tbl := bpl_procedure_to_expression_table (a_expressions)

				-- Get solver output.
			l_raw_output := raw_solver_output (a_solver_input)

				-- Parse solver output.
			create l_parser.make
			l_parser.on_procedure_verified.extend (
				agent (a_proc_name: STRING; a_result: STRING; a_store: HASH_TABLE [STRING, STRING])
					do
						a_store.put (a_result, a_proc_name)
					end (?, ?, l_temp_store))
			l_parser.parse (l_raw_output)

				-- Build final result.
			create Result.make (l_temp_store.count)
			Result.compare_objects
			from
				l_temp_store.start
			until
				l_temp_store.after
			loop
				Result.put (l_temp_store.item_for_iteration, l_tbl.item (l_temp_store.key_for_iteration))
				l_temp_store.forth
			end
		end

	bpl_procedure_to_expression_table (a_expressions: LINEAR [EPA_EXPRESSION]): HASH_TABLE [EPA_EXPRESSION, STRING]
			-- Table from bpl procedure name to expressions in `a_expressions'.
			-- The order in `a_expressions' is important, and reflected in the procedure name associated with it.
			-- Key is the bpl procedure name, value is its associated expression.
		local
			i: INTEGER
			l_bpl_procedure_name: STRING
		do
			create Result.make (20)
			Result.compare_objects

			from
				i := 1
				a_expressions.start
			until
				a_expressions.after
			loop
				l_bpl_procedure_name := boogie_procedure_name_header + i.out
				Result.put (a_expressions.item_for_iteration, l_bpl_procedure_name)
				i := i + 1
				a_expressions.forth
			end
		end

end
