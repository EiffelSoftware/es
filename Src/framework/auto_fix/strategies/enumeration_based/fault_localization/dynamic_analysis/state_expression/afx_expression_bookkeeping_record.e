note
	description: "Summary description for {AFX_EXPRESSION_BOOKKEEPING_RECORD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXPRESSION_BOOKKEEPING_RECORD

create
	make

feature{NONE} -- Initialization

	make (a_expression: EPA_EXPRESSION)
			-- Initialization.
		require
			expression_attached: a_expression /= Void
		do
			expression := a_expression
		ensure
			expression_set: expression = a_expression
		end

feature -- Access

	expression: EPA_EXPRESSION
			-- Expression to which current record is related.

	originate_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			-- Expressions from which the current expression originates.
			-- The set is empty if `expression' doesn't originate from other(s).
		do
			if originate_expressions_cache = Void then
				create originate_expressions_cache.make_equal (2)
			end
			Result := originate_expressions_cache
		end

	ultimate_originate_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			-- Set of ultimate originate expressions of `expression'.
			-- An ultimate originate expression doesn't originate from other(s).
		do
			Result := ultimate_originate_expressions_cache
		end

	sub_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			-- Sub-expressions of `expression'.
		local
			l_sub: EPA_HASH_SET [EPA_EXPRESSION]
		do
			if sub_expressions_cache = Void then
				Sub_expression_collector.collect_from_text (expression.class_, expression.feature_, expression.text, True)
				sub_expressions_cache := Sub_expression_collector.last_collection_in_written_class.twin
			end
			Result := sub_expressions_cache
		end

	immediate_target_objects: EPA_HASH_SET [EPA_EXPRESSION]
			-- Immediate target objects of the current expression.
			-- Such immediate target objects could be used to change the value of the current expression.
		do
			if immediate_target_objects_cache = Void then
				Target_object_detector.detect_target_objects_for_fixing (expression)
				immediate_target_objects_cache := Target_object_detector.immediate_target_objects.twin
			end
			Result := immediate_target_objects_cache
		ensure
			result_attached: Result /= Void
		end

feature -- Basic operation

--	adopt_originate_expression (a_exp: EPA_EXPRESSION)
--			-- Adopt `a_exp' as an originate expression, and keep the existing ones.
--		require
--			exp_attached: a_exp /= Void
--			not_current: a_exp /= Current
--		do
--			originate_expressions.force (a_exp)
--		end

	set_originate_expression (a_exp: AFX_PROGRAM_STATE_EXPRESSION)
			-- Set originate_expressions to contain only `a_exp'.
		require
			exp_attached: a_exp /= Void
			not_current: a_exp /= Current
		do
			originate_expressions.wipe_out
			originate_expressions.force (a_exp)
		end

	add_originate_expression (a_exp: AFX_PROGRAM_STATE_EXPRESSION)
			-- Add an originate expression.
		require
			exp_attached: a_exp /= Void
			not_current: a_exp /= Current
		do
			originate_expressions.force (a_exp)
		end

feature{AFX_EXPRESSION_BOOKKEEPER} -- Status set

	set_ultimate_originate_expressions (a_expressions: EPA_HASH_SET [EPA_EXPRESSION])
			-- Set ultimate originate expressions with `a_expressions'.
		require
			expressions_attached: a_expressions /= Void
		do
			ultimate_originate_expressions_cache := a_expressions
		end

feature{NONE} -- Shared once objects

	Sub_expression_collector: AFX_SUB_EXPRESSION_COLLECTOR
			-- Shared sub-expression collector.
		once
			create Result
		end

	Target_object_detector: AFX_TARGET_OBJECT_DETECTOR
			-- Shared target object detector.
		once
			create Result
		end

feature{NONE} -- Cache

	originate_expressions_cache: like originate_expressions
			-- Cache for originate_expressions.

	sub_expressions_cache: like sub_expressions
			-- Cache for sub_expressions.

	immediate_target_objects_cache: like immediate_target_objects
			-- Cache for immediate_target_objects.

	ultimate_originate_expressions_cache: like ultimate_originate_expressions
			-- Cache for ultimate_originate_expressions.

invariant
	expression_attached:
			expression /= Void

end
