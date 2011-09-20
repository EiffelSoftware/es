note
	description: "Summary description for {AFX_EXPRESSIONS_TO_MONITOR_COLLECTOR_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_EXPRESSIONS_TO_MONITOR_COLLECTOR_I

feature -- Access

	expressions_to_monitor: EPA_HASH_SET [EPA_EXPRESSION]
			-- Expressions to monitor from last collecting.
		deferred
		ensure
			result_attached: Result /= Void
		end

feature -- Basic operation

	collect_from_feature_with_base_expressions (a_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS; a_base_set: EPA_HASH_SET [EPA_EXPRESSION])
			-- Collect expressions to monitor from `a_feature_with_context'
			-- Make the result available in `expressions_to_monitor'.
			-- `a_feature_with_context': feature from which to collect expressions;
			-- `a_base_set': set of expressions that should also be considered.
		require
			feature_with_context_attached: a_feature_with_context /= Void
		deferred
		end

	collect_from (a_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS; a_expressions: EPA_HASH_SET [EPA_EXPRESSION])
			-- Collect expressions to monitor, based on `a_expressions', in the context of `a_class'.`a_feature'.
			-- Make the result available in `expressions_to_monitor'.
		require
			class_attached: a_class /= Void
			feature_attached: a_feature /= Void
			expressions_attached: a_expressions /= Void
		deferred
		end

end
