note
	description: "Summary description for {AFX_SOLVER_LAUNCHER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_SOLVER_LAUNCHER

feature -- Basic operations

	is_unsat (a_content: STRING): BOOLEAN
			-- Is the SMTLIB content `a_content' unsatisfiable?
		deferred
		end

end
