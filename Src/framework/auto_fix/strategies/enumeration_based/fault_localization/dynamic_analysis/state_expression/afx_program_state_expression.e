note
	description: "Summary description for {AFX_PROGRAM_STATE_EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROGRAM_STATE_EXPRESSION

inherit

	SHARED_WORKBENCH
		undefine
			is_equal
		end

	EPA_AST_EXPRESSION
		rename
			make_with_text as old_make_with_text,
			make_with_feature as old_make_with_feature
		end

--	AFX_SHARED_PROGRAM_STATE_EXPRESSION_EQUALITY_TESTER

create
	make_with_text, make_with_feature

feature -- Initialization

	make_with_text (a_class: like class_; a_feature: like feature_; a_text: like text; a_written_class: like written_class; a_bp_index: INTEGER)
			-- <Precursor>
		do
			old_make_with_text (a_class, a_feature, a_text, a_written_class)
			set_breakpoint_slot (a_bp_index)
		end

	make_with_feature (a_class: like class_; a_feature: like feature_; a_expression: like ast; a_written_class: like written_class; a_bp_index: INTEGER)
			-- <Precursor>
		do
			old_make_with_feature (a_class, a_feature, a_expression, a_written_class)
			set_breakpoint_slot (a_bp_index)
		end

feature -- Access

	breakpoint_slot: INTEGER
			-- Index of the breakpoint slot, to which the state expression is associated.

--	originate_expressions: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
--			-- Expressions from which the current expression originates.
--			-- Initially an expression originats from itself.
--		do
--			if originate_expressions_cache = Void then
--				create originate_expressions_cache.make_equal (2)
--			end
--			Result := originate_expressions_cache
--		end

	sub_expression_collector: AFX_SUB_EXPRESSION_COLLECTOR
			-- Shared sub-expression collector.
		once
			create Result
		end

	sub_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			-- Sub-expressions of the current expression.
		do
--			if sub_expressions_cache = Void then
--				create sub_expressions_cache.make (10)
--				sub_expressions_cache.set_equality_tester (Breakpoint_unspecific_equality_tester)

--				sub_expression_collector.collect_from_text (context_class, feature_, text, True)
--				sub_expressions.append (sub_expression_collector.last_collection_in_written_class)

--				sub_expressions_cache.do_all (
--						agent (a_expr: AFX_PROGRAM_STATE_EXPRESSION; a_bp_index: INTEGER)
--							do a_expr.set_breakpoint_slot (a_bp_index) end (?, breakpoint_slot))
--			end
--			Result := sub_expressions_cache
		end

	sub_expressions_cache: like sub_expressions
			-- Cache for `sub_expressions'.

	set_sub_expressions (a_set: like sub_expressions)
			-- Set `sub_expressions'.
		require
			set_attached: a_set /= Void
		do
			sub_expressions_cache := a_set
		end

	immediate_target_objects: EPA_HASH_SET [EPA_EXPRESSION]
			-- Immediate target objects of the current expression.
			-- Such immediate target objects could be used to change the value of the current expression.
		do
			if immediate_target_objects_cache = Void then
				target_object_detector.detect_target_objects_for_fixing (Current)
				immediate_target_objects_cache := target_object_detector.immediate_target_objects
			end
			Result := immediate_target_objects_cache
		ensure
			result_attached: Result /= Void
		end

	target_object_detector: AFX_TARGET_OBJECT_DETECTOR
			-- Shared target object detector.
		once
			create Result
		end

--	ultimate_originate_expressions: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
--			-- Set of ultimate originate expressions which have no originate expressions.
--		local
--			l_queue: DS_LINKED_QUEUE [AFX_PROGRAM_STATE_EXPRESSION]
--			l_exp, l_org_exp: AFX_PROGRAM_STATE_EXPRESSION
--			l_originates: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
--		do
--			if ultimate_originate_expressions_cache = Void then
--				create ultimate_originate_expressions_cache.make (10)
--				ultimate_originate_expressions_cache.set_equality_tester (Breakpoint_unspecific_equality_tester)

--				create l_queue.make
--				from l_queue.put (Current)
--				until l_queue.is_empty
--				loop
--					l_exp := l_queue.item
--					l_queue.remove

--					if l_exp.originate_expressions.is_empty then
--							ultimate_originate_expressions_cache.force (l_exp)
--					else
--						l_exp.originate_expressions.do_all (agent l_queue.put)
--					end
--				end
--			end

--			Result := ultimate_originate_expressions_cache
--		end

--	ultimate_originate_expressions_cache: like ultimate_originate_expressions
--			-- Cache for `ultimate_originate_expressions'.

--	originate_expressions_cache: like originate_expressions
--			-- Cache for `originate_expressions'.

	related_boolean_expressions: DS_LINKED_LIST [AFX_PROGRAM_STATE_EXPRESSION]
			-- Boolean expressions that are related with the `Current' expression.
			-- The list is ready after a call to `compute_related_boolean_expressions'.
			-- Refer to `compute_related_boolean_expressions' for an explanation about what's in the set.
		do
			if related_boolean_expressions_cache = Void then
				create related_boolean_expressions_cache.make
			end
			Result := related_boolean_expressions_cache
		ensure
			result_attached: Result /= Void
		end

feature -- Status report

	is_bp_spot_specific: BOOLEAN
			-- Is this state expression specific to a breakpoint slot?
			-- Yes, if `breakpoint_slot' is greater than 0;
			-- No, otherwise.
		do
			Result := (breakpoint_slot > 0)
		ensure
			definition: result = (breakpoint_slot > 0)
		end

feature -- Status set

	set_breakpoint_slot (a_slot: INTEGER)
			-- Set the breakpoint slot of `ast'.
		require
			valid_slot: a_slot >= 0
		do
			breakpoint_slot := a_slot
		end

--	adopt_originate_expression (a_exp: AFX_PROGRAM_STATE_EXPRESSION)
--			-- Adopt `a_exp' as an originate expression.
--		require
--			exp_attached: a_exp /= Void
--		do
--			originate_expressions.force (a_exp)
--		end

--	set_originate_expression (a_exp: AFX_PROGRAM_STATE_EXPRESSION)
--			-- Set `originate_expressions' to contain only `a_exp'.
--		require
--			exp_attached: a_exp /= VOid
--			not_current: a_exp /= Current
--		do
--			originate_expressions.wipe_out
--			originate_expressions.force (a_exp)
--		end

--	add_originate_expression (a_exp: AFX_PROGRAM_STATE_EXPRESSION)
--			-- Add an originate expression.
--		require
--			exp_attached: a_exp /= Void
--			not_current: a_exp /= Current
--		do
--			originate_expressions.force (a_exp)
--		end

	immediate_target_objects_cache: like immediate_target_objects
			-- Cache for `immediate_target_objects'.

feature{NONE} -- Cache

	related_boolean_expressions_cache: like related_boolean_expressions
			-- Cache for `related_boolean_expressions'.

--invariant
--	originate_expression_attached: originate_expressions /= Void

end
