note
	description: "Summary description for {AFX_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE

inherit
	DS_HASH_SET [AFX_EQUATION]
		rename
			make as make_set
		end

	REFACTORING_HELPER
		undefine
			copy,
			is_equal
		end

	AFX_SMTLIB_LAUNCHER
		undefine
			copy,
			is_equal
		end

	AFX_SHARED_SMTLIB_GENERATOR
		undefine
			copy,
			is_equal
		end

create
	make

convert
	skeleton: {AFX_STATE_SKELETON}

feature{NONE} -- Initialization

	make (n: INTEGER; a_class: like class_; a_feature: like feature_) is
			-- Create an empty container and allocate
			-- memory space for at least `n' items.
			-- Set equality tester to {AFX_PREDICATE_EQUALITY_TESTER}.			
		do
			class_ := a_class
			feature_ := a_feature
			make_set (n)
			set_equality_tester (create {AFX_PREDICATE_EQUALITY_TESTER})
		end

	make_from_object_state (a_state: HASH_TABLE [STRING, STRING]; a_class: like class_; a_feature: like feature_)
			-- Initialize Current with queries and values from `a_state' for `a_class' and `a_feature'.
			-- Key of `a_state' is query name, value is the result of the query.
		do
			make (a_state.count, a_class, a_feature)
			from
				a_state.start
			until
				a_state.after
			loop
				force_last (predicate_from_expression_and_value (a_state.key_for_iteration, a_state.item_for_iteration, a_class, a_feature))
				a_state.forth
			end
		end

feature -- Access

	class_: CLASS_C
			-- Class from which Current state is derived

	feature_: detachable FEATURE_I
			-- Feature from which Current state is derived
			-- If Void, it means that Current state is derived for the whole class,
			-- instead of particular feature.

	skeleton: AFX_STATE_SKELETON
			-- Skeleton of current state
		require
			all_expressions_boolean: for_all (agent (a_equation: AFX_EQUATION): BOOLEAN do Result := a_equation.expression.is_predicate end)
		do
			create Result.make_basic (class_, feature_, count)
			do_all (
				agent (a_pred: AFX_EQUATION; a_skeleton: AFX_STATE_SKELETON)
					do
						a_skeleton.force_last (a_pred.expression)
					end (?, Result))
		ensure
			good_result: Result.count = count
		end

	skeleton_with_value: AFX_STATE_SKELETON
			-- Skeleton consisting of predicate rewritten as predicates
			-- in Current.
		do
			create Result.make_basic (class_, feature_, count)
			do_all (
				agent (a_pred: AFX_EQUATION; a_skeleton: AFX_STATE_SKELETON)
					do
						a_skeleton.force_last (a_pred.as_predicate)
					end (?, Result))
		end

feature -- Status report

	implication alias "implies" (other: AFX_STATE): BOOLEAN
			-- Does Current implies `other'?
			-- The theory of `Current' will be used to support the reasoning.
		do
			Result := skeleton_with_value implies other.skeleton_with_value
		end

feature{NONE} -- Implementation

	predicate_from_expression_and_value (a_expression: STRING; a_value: STRING; a_class: CLASS_C; a_feature: detachable FEATURE_I): AFX_EQUATION
			-- Predicate from `a_expression' and its `a_value'
		local
			l_expr: AFX_AST_EXPRESSION
			l_value: AFX_EXPRESSION_VALUE
			l_written_class: CLASS_C
		do
			if a_feature /= Void then
				l_written_class := a_feature.written_class
			else
				l_written_class := a_class
			end

			create l_expr.make_with_text (a_class, a_feature, a_expression, l_written_class)

			if a_value = Void then
				create {AFX_VOID_VALUE} l_value.make
			else
				if a_value.is_boolean then
					create {AFX_BOOLEAN_VALUE} l_value.make (a_value.to_boolean)
				elseif a_value.is_integer then
					create {AFX_INTEGER_VALUE} l_value.make (a_value.to_integer)
				elseif a_value.is_equal ({AUT_SHARED_CONSTANTS}.nonsensical) then
					create {AFX_NONSENSICAL_VALUE} l_value
				end
			end
			create Result.make (l_expr, l_value)
		end

end
