note
	description: "Summary description for {AFX_FIXING_TARGET_DETECTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TARGET_OBJECT_DETECTOR

inherit

	AFX_SHARED_SERVER_VARIABLES_IN_SCOPE

	AFX_SHARED_SESSION

	ETR_TYPE_CHECKER

	AFX_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

create
	default_create

feature -- Access

	immediate_target_objects: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Immediate target objects of `current_expression'.
		do
			if immediate_target_objects_cache = Void then
				create immediate_target_objects_cache.make (3)
				immediate_target_objects_cache.set_equality_tester (Breakpoint_unspecific_equality_tester)
			end
			Result := immediate_target_objects_cache
		ensure
			result_attached: Result /= Void
		end

feature -- Basic operation

	detect_target_objects_for_fixing (a_expr: AFX_PROGRAM_STATE_EXPRESSION)
			-- Detect immediate target objects of `a_expr', by changing the value of which we can change that of `a_expr'.
			-- Result immediate target objects are made available in `immediate_target_objects'.
			-- Here we only consider the IMMEDIATE target objects, i.e. the ones that are not sub-expressions of any others.
			-- For example, if "a.b.c" is of type INTEGER, we identify only "a.b", but not "a", as an immediate target.
		require
			expr_attached: a_expr /= Void
		local
			l_collector: AFX_PROGRAM_STATE_EXPRESSION_COLLECTOR
			l_expr_set: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
		do
			reset_detector

			current_expression := a_expr
			expression_collector.collect_from_expression (a_expr.class_, a_expr.feature_, a_expr.ast, True)
			l_expr_set := expression_collector.last_collection_in_written_class

			detect_immediate_target_objects (l_expr_set)
		end

	reset_detector
			-- Reset detector from last detection.
		do
			current_expression := Void
			immediate_target_objects_cache := Void
		end

feature{NONE} -- Implementation

	detect_immediate_target_objects (a_expr_set: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION])
			-- Detect immediate target objects from a set of sub-expressions `a_expr_set',
			--		and make the result available in `immediate_sub_expressions'.
		local
			l_target_objects: DS_ARRAYED_LIST [AFX_PROGRAM_STATE_EXPRESSION]
			l_equality_tester: AGENT_BASED_EQUALITY_TESTER [AFX_PROGRAM_STATE_EXPRESSION]
			l_sorter: DS_QUICK_SORTER [AFX_PROGRAM_STATE_EXPRESSION]
			l_cursor_all_targets: DS_ARRAYED_LIST_CURSOR [AFX_PROGRAM_STATE_EXPRESSION]
			l_cursor_imm_targets: DS_HASH_SET_CURSOR [AFX_PROGRAM_STATE_EXPRESSION]
			l_target_object, l_immediate_target: AFX_PROGRAM_STATE_EXPRESSION
			l_is_immediate: BOOLEAN
		do
			-- Sort all target objects in decreasing text order.
			create l_target_objects.make (a_expr_set.count)
			a_expr_set.do_if (agent l_target_objects.force_last, agent can_be_target_object)

			create l_equality_tester.make (agent is_greater_than)
			create l_sorter.make (l_equality_tester)
			l_sorter.sort (l_target_objects)

			-- Save a sub expression as immediate, if it is not a sub-expression of any other.
			l_cursor_all_targets := l_target_objects.new_cursor
			l_cursor_imm_targets := immediate_target_objects.new_cursor
			from
				l_cursor_all_targets.start
			until
				l_cursor_all_targets.after
			loop
				l_target_object := l_cursor_all_targets.item

				from
					l_cursor_imm_targets.start
					l_is_immediate := True
				until
					l_cursor_imm_targets.after or else not l_is_immediate
				loop
					l_immediate_target := l_cursor_imm_targets.item
					l_is_immediate := l_immediate_target.text.substring_index (l_target_object.text, 1) <= 0
					l_cursor_imm_targets.forth
				end

				if l_is_immediate then
					immediate_target_objects.force (l_target_object)
				end

				l_cursor_all_targets.forth
			end
		end

--	integer_or_boolean_locals_and_attributes_for_feature (a_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [STRING]
--			-- Set of locals and attributes of type INTEGER/BOOLEAN, from {a_class}.{a_feature}.
--		local
--			l_query_key: STRING
--			l_table: like integer_or_boolean_locals_and_attributes_table
--			l_set: DS_HASH_SET [STRING]
--		do
--			l_query_key := "" + a_class.name + "." + a_feature.feature_name_32
--			l_table := integer_or_boolean_locals_and_attributes_table
--			if not l_table.has (l_query_key) then
--				create l_set.make (20)
--				l_set.set_equality_tester (case_insensitive_string_equality_tester)
--				l_set.append (integer_or_boolean_locals_of_feature (current_context_class, current_context_feature))
--				l_set.append (integer_or_boolean_attributes_of_class (current_context_class))

--				l_table.force (l_set, l_query_key)
--			end
--			check l_table.has (l_query_key) end

--			Result := l_table.item (l_query_key)
--		end

--	integer_or_boolean_locals_of_feature (a_class: CLASS_C; a_feature: FEATURE_I): DS_HASH_SET [STRING]
--			-- Set of local variable names of the feature `a_class'.`a_feature'.
--		require
--			class_attached: a_class /= Void
--			feature_attached: a_feature /= Void
--		local
--			l_local_info: HASH_TABLE [LOCAL_INFO, INTEGER]
--			l_local_type: TYPE_A
--		do
--			create Result.make (20)
--			Result.set_equality_tester (case_insensitive_string_equality_tester)

--			l_local_info := local_info (a_class, a_feature)
--			from l_local_info.start
--			until l_local_info.after
--			loop
--				l_local_type := explicit_type (l_local_info.item_for_iteration.type, a_class, a_feature)
--				if l_local_type.is_boolean or else l_local_type.is_integer then
--					Result.force (names_heap.item (l_local_info.key_for_iteration).as_lower)
--				end

--				l_local_info.forth
--			end
--		end

--	integer_or_boolean_attributes_of_class (a_class: CLASS_C): DS_HASH_SET [STRING]
--			-- Set of attribute names of a class `a_class'.
--		require
--			class_attached: a_class /= Void
--		local
--			l_feature_table: FEATURE_TABLE
--			l_next_feature: FEATURE_I
--			l_feature_type: TYPE_A
--			l_feature_name: STRING_32
--		do
--			l_feature_table := a_class.feature_table
--			create Result.make (l_feature_table.count + 1)
--			Result.set_equality_tester (case_insensitive_string_equality_tester)

--			-- Attributes of reference types can always be used as target objects.
--			-- Attibutes of INTEGER or BOOLEAN types will be added to the result set.
--			from
--				l_feature_table.start
--			until
--				l_feature_table.after
--			loop
--				l_next_feature := l_feature_table.item_for_iteration

--				if l_next_feature.is_attribute then
--					l_feature_type := l_next_feature.type.instantiation_in (a_class.actual_type, a_class.class_id).actual_type
--					l_feature_type := actual_type_from_formal_type (l_feature_type, a_class)
--					if l_feature_type.is_integer or else l_feature_type.is_boolean then
--						Result.force (l_next_feature.feature_name_32)
--					end
--				end

--				l_feature_table.forth
--			end
--		end

feature{NONE} -- Status report

	is_greater_than (a_expr1, a_expr2: AFX_PROGRAM_STATE_EXPRESSION): BOOLEAN
			-- Is `a_expr1' a greater, i.e. either longer or of the same length but greater lexicographically, expression than `a_expr2'?
		do
			Result := a_expr1.text.count > a_expr2.text.count or else a_expr1.text.is_greater (a_expr2.text)
		end

	can_be_target_object (a_expression: AFX_PROGRAM_STATE_EXPRESSION): BOOLEAN
			-- Can `a_expression' be used as a target object?
			-- Only an expression 1) of reference type or 2) of integer/boolean type, but is a local variable or an attribute,
			--		it can be used as a target object.
		require
			expression_attached: a_expression /= Void
		local
			l_expr_text: STRING
			l_expr_type: TYPE_A
			l_locals: DS_HASH_SET [STRING]
		do
			l_expr_text := a_expression.text
			if a_expression.type /= Void then
				l_expr_type := explicit_type (a_expression.type, current_context_class, current_context_feature)
				if l_expr_type.is_reference then
					Result := True
				elseif server_variables_in_scope.integer_or_boolean_locals_and_attributes_for_feature (current_context_class, current_context_feature).has (l_expr_text) then
					Result := True
				end
			end
		end

--	target_object (a_expression: EPA_PROGRAM_STATE_EXPRESSION): EPA_PROGRAM_STATE_EXPRESSION
			-- Target object from `a_expression'.
			-- If `a_expression' is of reference type, itself can be used as the target object;
			-- If it is a local variable or an attribute of integer or boolean type, itself can be used as the target object;
			-- If it is a

feature{NONE} -- Access

	current_expression: AFX_PROGRAM_STATE_EXPRESSION
			-- Expression whose value need to be changed.

	current_context_class: CLASS_C
			-- Current context class where fixing happens.
		require
			current_expression_attached: current_expression /= Void
		do
			Result := current_expression.class_
		end

	current_context_feature: FEATURE_I
			-- Current context feature where fixing happens.
		require
			current_expression_attached: current_expression /= Void
		do
			Result := current_expression.feature_
		end

feature{NONE} -- Storage

--	integer_or_boolean_locals_and_attributes_table: DS_HASH_TABLE [DS_HASH_SET [STRING], STRING]
--			-- Table mapping a feature to the set of its local variables and attributes, of type integer/boolean.
--			-- Key: class_name.feature_name
--			-- Val: set of names of locals and attributes.
--		once
--			create Result.make (5)
--			Result.set_key_equality_tester (case_insensitive_string_equality_tester)
--		end

	expression_collector: AFX_PROGRAM_STATE_EXPRESSION_COLLECTOR
			-- Expression collector to collect all sub expressions.
		once
			create Result
		end

	immediate_target_objects_cache: like immediate_target_objects
			-- Cache for `immediate_sub_expressions'.

end
