note
	description: "Summary description for {AFX_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE

inherit
	AFX_HASH_SET [AFX_EQUATION]
		rename
			make as make_set
		end

	HASHABLE
		undefine
		    copy,
		    is_equal
		end

	AFX_SOLVER_FACTORY
		undefine
		    is_equal,
		    copy
		end

	AFX_HASH_CALCULATOR
		undefine
		    is_equal,
		    copy
		end

	REFACTORING_HELPER
		undefine
			copy,
			is_equal
		end

	SHARED_TYPES
		undefine
		    copy,
		    is_equal
		end

	UC_SHARED_STRING_EQUALITY_TESTER
		undefine
		    copy,
		    is_equal
		end

	DEBUG_OUTPUT
		undefine
			copy,
			is_equal
		end

create
	make, make_chaos, make_from_object_state, make_from_expression_value, make_from_state

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
			set_equality_tester (create {AFX_EQUATION_EQUALITY_TESTER})
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

	make_from_expression_value (a_exp_val: HASH_TABLE [AFX_EXPRESSION_VALUE, AFX_AST_EXPRESSION]; a_class: like class_; a_feature: like feature_)
			-- Initialize a new state from a list of expression-value pairs
		local
		    l_equation: AFX_EQUATION
		do
		    make (a_exp_val.count, a_class, a_feature)
		    from a_exp_val.start
		    until a_exp_val.after
		    loop
		        create l_equation.make (a_exp_val.key_for_iteration, a_exp_val.item_for_iteration)
		        force_last (l_equation)
		        a_exp_val.forth
		    end
		end

	make_from_state (a_state: like Current; a_type: TYPE_A)
			-- Initialize a new state from `a_state', extracting only those predicates conforming to `a_type'
		local
		    l_type: TYPE_A
		    l_equation: AFX_EQUATION
		    l_feature_table: FEATURE_TABLE
		    l_feature_name_set: DS_HASH_SET[STRING]
		    l_feature: FEATURE_I
		do
		    make_set (a_state.count)
		    class_ := a_type.associated_class

		    	-- get feature names in the filtering set
		    l_feature_table := class_.feature_table
		    create l_feature_name_set.make_default
		    l_feature_name_set.set_equality_tester (string_equality_tester)
		    from l_feature_table.start
		    until l_feature_table.after
		    loop
		        l_feature := l_feature_table.item_for_iteration
		        if l_feature.type /= void_type and then l_feature.argument_count = 0 then
    		    	l_feature_name_set.force (l_feature.feature_name)
		        end
		        l_feature_table.forth
		    end

		    from a_state.start
		    until a_state.after
		    loop
		        l_equation := a_state.item_for_iteration
				if l_feature_name_set.has (l_equation.expression.text) then
				    force (l_equation)
				end
		        a_state.forth
		    end
		end

	make_chaos (a_class: like class_)
			-- create a chaos state
		do
		    make (1, a_class, Void)
		    is_chaos := True
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

	padded (a_skeleton: AFX_STATE_SKELETON): like Current
			-- State containing all predicates in `a_skeleton'.
			-- Predicates in `a_skeleton' but not presented in Current
			-- will be assigned to a random value in the returned state.
		require
			current_is_subset: skeleton.is_subset (a_skeleton)
		local
			l_diff: like a_skeleton
		do
				-- Copy existing equations into Result.
			create Result.make (a_skeleton.count, class_, feature_)
			do_all (agent Result.force_last)

				-- Generate random values for expression not appearing in Current.
			l_diff := a_skeleton.subtraction (Result.skeleton)
			if not l_diff.is_empty then
				l_diff.do_all (
					agent (a_expr: AFX_EXPRESSION; a_state: like Current)
						do
							a_state.force_last (a_expr.equation_with_random_value)
						end (?, Result))
			end
		ensure
			result_is_padded: Result.skeleton.is_subset (a_skeleton) and a_skeleton.is_subset (Result.skeleton)
		end

	item_with_expression (a_expr: STRING): detachable AFX_EQUATION
			-- Equation whose expression has text `a_expr'
			-- Void if no such equation is found.
		local
			l_cursor: DS_HASH_SET_CURSOR [AFX_EQUATION]
		do
			l_cursor := new_cursor
			from
				l_cursor.start
			until
				l_cursor.after or Result /= Void
			loop
				if l_cursor.item.expression.text ~ a_expr then
					Result := l_cursor.item
				end
				l_cursor.forth
			end
		end

	to_hash_table: HASH_TABLE [AFX_EXPRESSION_VALUE, STRING]
			-- Hash table representation of Current
			-- Key is the text of the equations,
			-- value is the value associated in those equations.
		do
			create Result.make (count)
			Result.compare_objects
			do_all (
				agent (a_equation: AFX_EQUATION; a_table: HASH_TABLE [AFX_EXPRESSION_VALUE, STRING])
					do
						a_table.force (a_equation.value, a_equation.expression.text)
					end (?, Result))
		end

	only_predicates: like Current
			-- A subset of current which only contains equations of boolean type
		local
			l_cursor: DS_HASH_SET_CURSOR [AFX_EQUATION]
			l_non_predicates: LINKED_LIST [AFX_EQUATION]
		do
			create l_non_predicates.make
			Result := cloned_object

				-- Collect all non-predicates from Current into `l_non_predicates'.
			from
				l_cursor := Result.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if not l_cursor.item.expression.is_predicate then
					l_non_predicates.extend (l_cursor.item)
				end
				l_cursor.forth
			end

				-- Only keep predicates in Result.
			l_non_predicates.do_all (agent Result.remove)
		end

feature -- Status report

	is_chaos: BOOLEAN
			-- does this state stand for a chaos (the state before object creation)?

	implication alias "implies" (other: AFX_STATE): BOOLEAN
			-- Does Current implies `other'?
			-- The theory of `Current' will be used to support the reasoning.
		do
			Result := skeleton_with_value implies other.skeleton_with_value
		end

feature -- Setting

    set_class (a_class: like class_)
		    -- set `class_' with `a_class'.
    	do
    		class_ := a_class
    	ensure
    		class_set: class_ = a_class
    	end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (512)
			do_all (
				agent (a_equation: AFX_EQUATION; a_string: STRING)
					do
						a_string.append (a_equation.debug_output)
						a_string.append_character ('%N')
					end (?, Result))
		end

feature{NONE} -- Implementation

	key_to_hash: DS_LINEAR[INTEGER]
			-- <Precursor>
		local
		    l_list: DS_ARRAYED_LIST[INTEGER]
		do
		    create l_list.make (count)
			from start
			until after
			loop
			    l_list.force_last (item_for_iteration.hash_code)
				forth
			end

			Result := l_list
		end

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

			fixme ("Refactoring the following ugly if statement.")
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
