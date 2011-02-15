note
	description: "Summary description for {AFX_CLASS_THEORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_THEORY

inherit
	AFX_SOLVER_CONSTANTS

	DEBUG_OUTPUT

	AFX_SOLVER_FACTORY

	INTERNAL_COMPILER_STRING_EXPORTER

create
	make,
	make_with_feature

feature{NONE} -- Initializatoin

	make (a_class: like class_)
			-- Initialize Current.
		do
			class_ := a_class
			create functions.make (50)
			create axioms.make (50)
			functions.set_equality_tester (create {AFX_SOLVER_EXPR_EQUALITY_TESTER})
			axioms.set_equality_tester (create {AFX_SOLVER_EXPR_EQUALITY_TESTER})
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

	functions: DS_HASH_SET [AFX_SOLVER_EXPR]
			-- List of functions

	axioms: DS_HASH_SET [AFX_SOLVER_EXPR]
			-- List of axioms

	statements: DS_HASH_SET [AFX_SOLVER_EXPR]
			-- All statements consisting both `functions' and `axioms'
			-- A new copy of `functions' and `axioms'.
		do
			create Result.make (functions.count + axioms.count)
			functions.do_all (agent Result.force_last)
			axioms.do_all (agent Result.force_last)
		ensure
			good_result: Result.count = functions.count + axioms.count
		end

	union alias "+" (other: like Current): like Current is
			-- Clone of current set to which all items
			-- of `other' have been added
		require
			other_from_same_context: is_from_same_context (other)
		do
			create Result.make_with_feature (class_, feature_)

			functions.do_all (agent Result.extend_function)
			other.functions.do_all (agent Result.extend_function)

			axioms.do_all (agent Result.extend_axiom)
			other.axioms.do_all (agent Result.extend_axiom)
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
				agent (a_item: AFX_SOLVER_EXPR; a_result: STRING)
					do
						a_result.append (a_item.expression)
						a_result.append_character ('%N')
					end (?, Result))
		end

feature -- Status report

	is_statement_valid (a_string: STRING): BOOLEAN
			-- Is `a_string' a valid statement?
		do
			Result := True
		end

	is_from_same_context (other: like Current): BOOLEAN
			-- Is `other' from the same context as Current?
		do
			if class_.class_id = other.class_.class_id then
				Result :=
					((feature_ = Void) = (other.feature_ = Void)) or
					(feature_ /= Void and then other.feature_ /= Void and then feature_.equiv (other.feature_))
			end
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
				extend_function_with_string (a_statement)
			else
				extend_axiom_with_string (a_statement)
			end
		end

	extend_statement (a_stmt: AFX_SOLVER_EXPR)
			-- Extend `a_stmt' into Current.
		do
			if a_stmt.expression.starts_with (smtlib_function_header) then
				extend_function (a_stmt)
			else
				extend_axiom (a_stmt)
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
			extend_function (new_solver_expression_from_string (a_str))
		end

	extend_axiom_with_string (a_str: STRING)
			-- Extend `a_str' as an axiom.
		do
			extend_axiom (new_solver_expression_from_string (a_str))
		end

	extend_function (a_expr: AFX_SOLVER_EXPR)
			-- Extend `a_expr' into `functions'.
		do
			functions.force_last (a_expr)
		end

	extend_axiom (a_expr: AFX_SOLVER_EXPR)
			-- Extend `a_expr' into `axioms'.
		do
			axioms.force_last (a_expr)
		end
end
