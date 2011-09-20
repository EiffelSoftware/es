note
	description: "Summary description for {AFX_EXPRESSION_SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SUB_EXPRESSION_SERVER

feature -- Basic operation

	sub_expressions (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS): EPA_HASH_SET [EPA_EXPRESSION]
			-- Set of expressions from `a_feature', in its written class.
		require
			feature_attached: a_feature /= Void
		do
			if not sub_expressions_repository.has (a_feature) then
				sub_expression_collector.collect_from_feature (a_feature)
				sub_expressions_repository.put (sub_expression_collector.last_sub_expressions, a_feature)
			end
			Result := sub_expressions_repository.item (a_feature)
		end

feature -- Shared collector

	sub_expression_collector: AFX_SUB_EXPRESSION_COLLECTOR
			-- Sub-expression collector.
		once
			create Result
			Result.set_should_collect_arguments (True)
			Result.set_should_collect_current (True)
			Result.set_should_collect_result (True)
		end

feature -- Shared storage

	sub_expressions_repository: DS_HASH_TABLE [EPA_HASH_SET [EPA_EXPRESSION], EPA_FEATURE_WITH_CONTEXT_CLASS]
			-- Repository for sub-expressions of features.
		once
			create Result.make_equal (10)
		end

end
