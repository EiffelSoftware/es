note
	description: "Summary description for {AFX_FIXING_OPERATION_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIXING_OPERATION_GENERATOR

inherit

	AFX_FIXING_OPERATION_CONSTANT

	AFX_SHARED_SESSION

	SHARED_WORKBENCH

create
	default_create

feature -- Access

	last_fixing_operations: EPA_HASH_SET [AFX_FIXING_OPERATION]
			-- Fixing operations from last generation.
		do
			if last_fixing_operations_cache = Void then
				create last_fixing_operations_cache.make_equal (10)
			end
			Result := last_fixing_operations_cache
		end

feature -- Basic operation

	generate_fixing_operations (a_target: AFX_FIXING_TARGET)
			-- Generate fixing operations regarding `a_target'.
			-- Make the result operations available in `last_fixing_operations'.
		require
			target_attached: a_target /= Void
		local
			l_target_expressions, l_immediate_target_objects: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_cursor: DS_HASH_SET_CURSOR [AFX_PROGRAM_STATE_EXPRESSION]
			l_target1, l_target2: AFX_PROGRAM_STATE_EXPRESSION
		do
			reset_generator

			current_fixing_target := a_target
			l_target_expressions := a_target.expressions
			if l_target_expressions.count = 1 then
				-- For a single target expression, apply fixing operations on the `immediate_target_objects'.
				l_target1 := l_target_expressions.first
				l_immediate_target_objects := l_target1.immediate_target_objects
				from
					l_cursor := l_immediate_target_objects.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					generate_for_one_target_object (l_cursor.item)

					l_cursor.forth
				end
			elseif l_target_expressions.count = 2 then
				generate_for_two_target_objects (l_target_expressions)
			else
				check should_not_happen: False end
			end
		end

	reset_generator
			-- Reset the state of the generator.
		do
			last_fixing_operations_cache := Void
		end

feature{NONE} -- Implementation

	generate_for_one_target_object (a_expr: AFX_PROGRAM_STATE_EXPRESSION)
			-- Generate fixing operations to be applied to `a_expr'.
			-- Append the operations to `last_fixing_operations'.
		local
			l_target_expressions, l_immediate_target_objects: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_cursor: DS_HASH_SET_CURSOR [AFX_PROGRAM_STATE_EXPRESSION]
			l_target: AFX_PROGRAM_STATE_EXPRESSION
			l_operations: EPA_HASH_SET [AFX_FIXING_OPERATION]
		do
			l_immediate_target_objects := a_expr.immediate_target_objects
			from
				l_cursor := l_immediate_target_objects.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_target := l_cursor.item

				if l_target.type.is_integer then
					l_operations := generate_for_integer (l_target)
				elseif l_target.type.is_boolean then
					l_operations := generate_for_boolean (l_target)
				elseif l_target.type.is_reference then
					l_operations := generate_for_reference (l_target)
				end

				if l_operations /= Void then
					last_fixing_operations.append (l_operations)
				end

				l_cursor.forth
			end
		end

	generate_for_two_target_objects (a_expressions: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION])
			-- Generate fixing operations regarding two target objects, represented by expressions from `a_expressions'.
			-- Append the operations to `last_fixing_operations'.
		require
			two_objects: a_expressions.count = 2
			integer_objects: a_expressions.first.type.is_integer and then a_expressions.last.type.is_integer
		local
			l_expr1, l_expr2: AFX_PROGRAM_STATE_EXPRESSION
			l_immediate_target_objects1, l_immediate_target_objects2: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_op: AFX_FIXING_OPERATION_ON_INTEGERS
			l_operations: EPA_HASH_SET [AFX_FIXING_OPERATION]
		do
			create l_operations.make_equal (6)

			l_expr1 := a_expressions.first
			l_expr2 := a_expressions.last
			l_immediate_target_objects1 := l_expr1.immediate_target_objects
			l_immediate_target_objects2 := l_expr2.immediate_target_objects

			if l_immediate_target_objects1.has (l_expr1) then
				create l_op.make (current_fixing_target, l_expr1, l_expr2, Fixing_operation_integers_set_equal_forward)
				l_operations.force_last (l_op)
				create l_op.make (current_fixing_target, l_expr1, l_expr2, Fixing_operation_integers_set_bigger_by_one_forward)
				l_operations.force_last (l_op)
				create l_op.make (current_fixing_target, l_expr1, l_expr2, Fixing_operation_integers_set_less_by_one_forward)
				l_operations.force_last (l_op)

				generate_for_one_target_object (l_expr1)
			end

			if l_immediate_target_objects2.has (l_expr2) then
				create l_op.make (current_fixing_target, l_expr2, l_expr1, Fixing_operation_integers_set_equal_forward)
				l_operations.force_last (l_op)
				create l_op.make (current_fixing_target, l_expr2, l_expr1, Fixing_operation_integers_set_bigger_by_one_forward)
				l_operations.force_last (l_op)
				create l_op.make (current_fixing_target, l_expr2, l_expr1, Fixing_operation_integers_set_less_by_one_forward)
				l_operations.force_last (l_op)

				generate_for_one_target_object (l_expr2)
			end

			last_fixing_operations.append (l_operations)
		end

	generate_for_integer (a_integer_expr: AFX_PROGRAM_STATE_EXPRESSION): EPA_HASH_SET [AFX_FIXING_OPERATION]
			-- Generate fixng operations for an integer expression.
		local
			l_op: AFX_FIXING_OPERATION_ON_INTEGER
		do
			create Result.make_equal (5)

			create l_op.make (current_fixing_target, a_integer_expr, Fixing_operation_integer_increase_by_one)
			Result.force_last (l_op)
			create l_op.make (current_fixing_target, a_integer_expr, Fixing_operation_integer_decrease_by_one)
			Result.force_last (l_op)
			create l_op.make (current_fixing_target, a_integer_expr, Fixing_operation_integer_set_to_zero)
			Result.force_last (l_op)
			create l_op.make (current_fixing_target, a_integer_expr, Fixing_operation_integer_set_to_one)
			Result.force_last (l_op)
			create l_op.make (current_fixing_target, a_integer_expr, Fixing_operation_integer_set_to_minus_one)
			Result.force_last (l_op)
		end

	generate_for_boolean (a_boolean_expr: AFX_PROGRAM_STATE_EXPRESSION): EPA_HASH_SET [AFX_FIXING_OPERATION]
			-- Generate fixng operations for a boolean expression.
		local
			l_op: AFX_FIXING_OPERATION_ON_BOOLEAN
		do
			create Result.make_equal (1)

			create l_op.make (current_fixing_target, a_boolean_expr, Fixing_operation_boolean_negate)
			Result.force_last (l_op)
		end

	generate_for_reference (a_reference_expr: AFX_PROGRAM_STATE_EXPRESSION): EPA_HASH_SET [AFX_FIXING_OPERATION]
			-- Generate fixng operations for a reference expression.
		local
			l_class: CLASS_C
			l_class_id: INTEGER_32
			l_feature_table: FEATURE_TABLE
			l_names: EPA_HASH_SET [STRING_8]
			l_next_feature: FEATURE_I
			l_feature_type: TYPE_A
			l_feature_name: STRING_32
			l_op: AFX_FIXING_OPERATION_ON_REFERENCE
		do
			l_class := a_reference_expr.type.associated_class
			l_feature_table := l_class.feature_table
			create Result.make_equal (l_feature_table.count)
			from l_feature_table.start
			until l_feature_table.after
			loop
				l_next_feature := l_feature_table.item_for_iteration
				if l_next_feature.is_exported_for (system.any_class.compiled_representation)
						and then l_next_feature.argument_count = 0
						and then (l_next_feature.type = Void or else l_next_feature.type.is_void)
				then
					create l_op.make (current_fixing_target, a_reference_expr, l_next_feature, Fixing_operation_reference_call_command)
					Result.force_last (l_op)
				end
				l_feature_table.forth
			end
		end

feature{NONE} -- Access

	current_fixing_target: AFX_FIXING_TARGET
			-- Fixing target the generator is working on currently.

feature{NONE} -- Cache

	last_fixing_operations_cache: like last_fixing_operations
			-- Cache for `last_fixing_operations'.

end
