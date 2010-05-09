note
	description: "Compilation related utilities"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_COMPILATION_UTILITY

feature -- Basic operations

	compile_project (a_eiffel_project: E_PROJECT; a_c_compilaiton: BOOLEAN)
			-- Compile `a_eiffel_project' when needed.
			-- `a_c_compilation' indicates if C compiler is to be launched.
		do
			a_eiffel_project.quick_melt
			a_eiffel_project.freeze
			if a_c_compilaiton then
				a_eiffel_project.call_finish_freezing_and_wait (True)
			end
		end


end
