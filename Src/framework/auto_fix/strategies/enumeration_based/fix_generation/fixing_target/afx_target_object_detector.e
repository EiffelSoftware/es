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

create
	default_create

feature -- Access

	immediate_target_objects: EPA_HASH_SET [EPA_EXPRESSION]
			-- Immediate target objects of `current_expression'.
		do
			if immediate_target_objects_cache = Void then
				create immediate_target_objects_cache.make_equal (3)
			end
			Result := immediate_target_objects_cache
		ensure
			result_attached: Result /= Void
		end

feature -- Basic operation

	detect_target_objects_for_fixing (a_expr: EPA_EXPRESSION)
			-- Detect immediate target objects of `a_expr', by changing the value of which we can change that of `a_expr'.
			-- Result immediate target objects are made available in `immediate_target_objects'.
			-- Here we only consider the IMMEDIATE target objects, i.e. the ones that are not sub-expressions of any others.
			-- For example, if "a.b.c" is of type INTEGER, we identify only "a.b", but not "a", as an immediate target.
		require
			expr_attached: a_expr /= Void
		local
			l_context_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_expr_set: EPA_HASH_SET [EPA_EXPRESSION]
		do
			reset_detector

			current_expression := a_expr
			create l_context_feature.make (a_expr.feature_, a_expr.class_)
			expression_collector.collect_from_expression_text (l_context_feature, a_expr.text)
--			expression_collector.collect_from_text (a_expr.feature_, a_expr.text)
			l_expr_set := expression_collector.last_sub_expressions

			detect_immediate_target_objects (l_expr_set)
		end

	reset_detector
			-- Reset detector from last detection.
		do
			current_expression := Void
			immediate_target_objects_cache := Void
		end

feature{NONE} -- Implementation

	detect_immediate_target_objects (a_expr_set: EPA_HASH_SET [EPA_EXPRESSION])
			-- Detect immediate target objects from a set of sub-expressions `a_expr_set',
			--		and make the result available in `immediate_sub_expressions'.
		local
			l_target_objects: DS_ARRAYED_LIST [EPA_EXPRESSION]
			l_equality_tester: AGENT_BASED_EQUALITY_TESTER [EPA_EXPRESSION]
			l_sorter: DS_QUICK_SORTER [EPA_EXPRESSION]
			l_cursor_all_targets: DS_ARRAYED_LIST_CURSOR [EPA_EXPRESSION]
			l_cursor_imm_targets: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_target_object, l_immediate_target: EPA_EXPRESSION
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

feature{NONE} -- Status report

	is_greater_than (a_expr1, a_expr2: EPA_EXPRESSION): BOOLEAN
			-- Is `a_expr1' a greater, i.e. either longer or of the same length but greater lexicographically, expression than `a_expr2'?
		do
			Result := a_expr1.text.count > a_expr2.text.count or else a_expr1.text.is_greater (a_expr2.text)
		end

	can_be_target_object (a_expression: EPA_EXPRESSION): BOOLEAN
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

feature{NONE} -- Access

	current_expression: EPA_EXPRESSION
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

	expression_collector: AFX_SUB_EXPRESSION_COLLECTOR
			-- Expression collector to collect all sub expressions.
		once
			create Result
		end

	immediate_target_objects_cache: like immediate_target_objects
			-- Cache for `immediate_sub_expressions'.

end
