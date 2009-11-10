note
	description: "Summary description for {AFX_CLASS_THEORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_THEORY

inherit
	AFX_SMTLIB_CONSTANTS

	DEBUG_OUTPUT

create
	make,
	make_with_feature

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

	make_with_feature (a_class: like class_; a_feature: FEATURE_I)
			-- Initialize Current.
		do
			feature_ := a_feature
			make (a_class)
		ensure
			class_set: class_ = a_class
			feature_set: feature_ = a_feature
		end

feature -- Access

	class_: CLASS_C
			-- Class from which current theroy is extracted

	feature_: detachable FEATURE_I
			-- Feature from which current theory is extracted.
			-- If Void, it means that Current theory is for `class_',
			-- not for a particular feature.

	functions: LINKED_LIST [AFX_SMTLIB_EXPR]
			-- List of functions

	axioms: LINKED_LIST [AFX_SMTLIB_EXPR]
			-- List of axioms

	statements: LINKED_LIST [AFX_SMTLIB_EXPR]
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

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (2048)
			Result.append ("Theory for ")
			Result.append (class_.name)
			if feature_ /= Void then
				Result.append_character ('.')
				Result.append (feature_.feature_name)
			end
			Result.append (":%N")

			statements.do_all (
				agent (a_item: AFX_SMTLIB_EXPR; a_result: STRING)
					do
						a_result.append (a_item.expression)
						a_result.append_character ('%N')
					end (?, Result))
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
				functions.extend (create {AFX_SMTLIB_EXPR}.make (a_statement))
			else
				axioms.extend (create {AFX_SMTLIB_EXPR}.make (a_statement))
			end
		end

	extend_statement (a_stmt: AFX_SMTLIB_EXPR)
			-- Extend `a_stmt' into Current.
		do
			if a_stmt.expression.starts_with (smtlib_function_header) then
				functions.extend (a_stmt)
			else
				axioms.extend (a_stmt)
			end
		end

	append (other: like Current)
			-- Append `other' into Current. Do not change `class_' and `feature_'.
			-- Note: May result in invalid theories if `other' are built from a
			-- different class/feature.
		do
			other.statements.do_all (agent extend_statement)
		end

	extend_function_with_string (a_str: STRING)
			-- Extend `a_str' as a function.
		do
			functions.extend (create {AFX_SMTLIB_EXPR}.make (a_str))
		end

	extend_axiom_with_string (a_str: STRING)
			-- Extend `a_str' as an axiom.
		do
			axioms.extend (create {AFX_SMTLIB_EXPR}.make (a_str))
		end

end
