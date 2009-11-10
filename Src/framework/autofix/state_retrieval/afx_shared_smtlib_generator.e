note
	description: "Summary description for {AFX_SHARED_SMTLIB_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SHARED_SMTLIB_GENERATOR

feature -- Access

	z3_launcher: AFX_SMTLIB_LAUNCHER
			-- Z3 launcher
		once
			create Result
		end

	smtlib_generator: AFX_SMTLIB_FILE_GENERATOR
			-- Z3 SMTLIB file generator
		once
			create Result
		end

end
