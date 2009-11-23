note
	description: "Summary description for {AFX_BOOGIE_LAUNCHER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BOOGIE_LAUNCHER

inherit
	AFX_SOLVER_LAUNCHER

	AFX_SHARED_SESSION

feature -- Basic operations

	is_unsat (a_content: STRING): BOOLEAN
			-- Is the SMTLIB content `a_content' unsatisfiable?
		do
			generate_file (a_content)
		end

feature{NONE} -- Implementation

	smtlib_file_directory: STRING is "/tmp"

	smtlib_file_path: STRING
			-- Full path of the generated smtlib file
		local
			l_file_name: FILE_NAME
		do
			create l_file_name.make_from_string (autofix_config.data_directory)
			l_file_name.set_file_name ("autofix.bpl")
			Result := l_file_name
		end

	z3_command: STRING is "/bin/sh -c %"/home/jasonw/apps/z3/bin/z3.exe /smt: autofix.smt%""
			-- Command to launch Z3 SMT solver

	generate_file (a_content: STRING)
			-- Generate SMTLIB file at `smtlib_file_path' containing
			-- `a_content'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (smtlib_file_path)
			l_file.put_string (a_content)
			l_file.close
		end
end
