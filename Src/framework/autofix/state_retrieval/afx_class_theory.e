note
	description: "Summary description for {AFX_CLASS_THEORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CLASS_THEORY

inherit
	AFX_SMTLIB_CONSTANTS

create
	make

feature{NONE} -- Initializatoin

	make (a_class: like class_)
			-- Initialize Current.
		do
			class_ := a_class
			create functions.make
			create axioms.make
		ensure
			class_set: class_ = a_class
		end

feature -- Access

	class_: CLASS_C
			-- Class from which current theroy is extracted

	functions: LINKED_LIST [STRING]
			-- List of functions

	axioms: LINKED_LIST [STRING]
			-- List of axioms

	statements: LINKED_LIST [STRING]
			-- All statements consisting both `functions' and `axioms'
			-- A new copy of `functions' and `axioms'.
		do
			create Result.make
			functions.do_all (agent Result.extend)
			axioms.do_all (agent Result.extend)
		ensure
			good_result: Result.count = functions.count + axioms.count
		end

feature -- Status report

	is_statement_valid (a_string: STRING): BOOLEAN
			-- Is `a_string' a valid statement?
		do
			Result :=
				a_string.starts_with (smtlib_function_header) or
				a_string.starts_with (smtlib_axiom_header)
		end

feature -- Basic operations

	extend (a_statement: STRING)
			-- Extend `a_statement' into Current.
			-- Depends on the type of `a_statement', it will be added either
			-- into `functions' or `axioms'.
		require
			a_statement_valid: is_statement_valid (a_statement)
		do
			if a_statement.starts_with (smtlib_function_header) then
				functions.extend (a_statement)
			else
				axioms.extend (a_statement)
			end
		end

end
