note
	description: "Summary description for {AFX_STATE_CHANGE_ASSIGNER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_CHANGE_ASSIGNER

inherit
	SHARED_WORKBENCH

	REFACTORING_HELPER

create
	default_create

feature -- Access

	last_operation_texts: DS_ARRAYED_LIST [STRING]
			-- Texts of instructions that change program states through assignment.
		do
			if last_operation_texts_cache = Void then
				create last_operation_texts_cache.make_default
			end
			Result := last_operation_texts_cache
		ensure
			result_attached: Result /= Void
		end

feature -- Basic operation

	target_object_detector: AFX_TARGET_OBJECT_DETECTOR
			-- Shared target object detector.
		once
			create Result
		end

	generate_assignment (a_requirement: AFX_STATE_CHANGE_REQUIREMENT)
			-- Generate assignment texts that will fulfil `a_requirement'.
		require
			requirement_attached: a_requirement /= Void
		local
			l_src, l_dest: EPA_EXPRESSION
			l_immediate_target_objects: EPA_HASH_SET [EPA_EXPRESSION]
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_target: EPA_EXPRESSION
			l_operations: EPA_HASH_SET [STRING]
		do
			l_src := a_requirement.src_expr
			l_dest := a_requirement.dest_expr

			target_object_detector.detect_target_objects_for_fixing (l_src)
			fixme ("Cache the target objects for expressions")
			l_immediate_target_objects := target_object_detector.immediate_target_objects
			if l_immediate_target_objects.has (l_src) then
					-- We can directly assign to the source expression.
				last_operation_texts.force_last (l_src.text + " := " + l_dest.text)
			else
				-- Source expression cannot be used as assignment target.
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
					elseif l_target.type.is_reference and then l_target.type.name.as_upper /~ "STRING_8" and then l_target.type.name.as_upper /~ "STRING_32" then
						l_operations := generate_for_reference (l_target)
					end
					if l_operations /= Void then
						last_operation_texts.append_last (l_operations)
					end
					l_cursor.forth
				end
			end
		end

	generate_for_integer (a_integer_expr: EPA_EXPRESSION): EPA_HASH_SET [STRING]
			-- Generate fixng operations for an integer expression.
		local
			l_text: STRING
			l_op: AFX_FIXING_OPERATION_ON_INTEGER
		do
			l_text := a_integer_expr.text
			create Result.make_equal (5)
			Result.force_last (l_text + " := " + l_text + " + 1")
			Result.force_last (l_text + " := " + l_text + " - 1")
			Result.force_last (l_text + " := " + "0")
			Result.force_last (l_text + " := " + "1")
			Result.force_last (l_text + " := " + "-1")
		end

	generate_for_boolean (a_boolean_expr: EPA_EXPRESSION): EPA_HASH_SET [STRING]
			-- Generate fixng operations for a boolean expression.
		local
			l_op: AFX_FIXING_OPERATION_ON_BOOLEAN
		do
			create Result.make_equal (1)
			Result.force_last (a_boolean_expr.text + " := not (" + a_boolean_expr.text + ")")
		end

	generate_for_reference (a_reference_expr: EPA_EXPRESSION): EPA_HASH_SET [STRING]
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
			from
				l_feature_table.start
			until
				l_feature_table.after
			loop
				l_next_feature := l_feature_table.item_for_iteration
				if l_next_feature.is_exported_for (System.any_class.compiled_representation)
						and then l_next_feature.argument_count = 0
						and then not l_next_feature.written_class.is_class_any
						and then (l_next_feature.type = Void or else l_next_feature.type.is_void) then
					Result.force_last (a_reference_expr.text + "." + l_next_feature.feature_name_32)
				end
				l_feature_table.forth
			end
		end


feature {NONE} -- Cache

	last_operation_texts_cache: like last_operation_texts
			-- Cache for `last_operation_texts'.
end
