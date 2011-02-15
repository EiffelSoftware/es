note
	description: "Summary description for {AFX_SERVER_EXPRESSIONS_FROM_FEATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SERVER_EXPRESSIONS_FROM_FEATURE

inherit
	EPA_NESTED_HASH_TABLE [AFX_PROGRAM_STATE_EXPRESSION, INTEGER, INTEGER]

create
	make

feature -- Basic operation

	expressions_from_feature (a_context_class: CLASS_C; a_context_feature: FEATURE_I): EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Expressions that appear directly in `a_context_feature' from `a_context_class'.
		require
			context_class_attached: a_context_class /= Void
			context_feature_attached: a_context_feature /= Void
		local
			l_class_id, l_feature_id: INTEGER
		do
			l_class_id := a_context_class.class_id
			l_feature_id := a_context_feature.feature_id

			if attached value_set (l_feature_id, l_class_id) as lt_set then
				Result := lt_set
			else
				Result := expressions_from_feature_internal (a_context_class, a_context_feature)
				put_value_set (Result, l_feature_id, l_class_id)
			end
		end

feature{NONE} -- Implementation

	expressions_from_feature_internal (a_context_class: CLASS_C; a_context_feature: FEATURE_I): EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Expressions that appear directly in `a_context_feature' from `a_context_class'.
		require
			context_class_attached: a_context_class /= VOid
			context_feature_attached: a_context_feature /= Void
		local
			l_collector: AFX_PROGRAM_STATE_EXPRESSION_COLLECTOR
			l_collection: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
		do
			-- Collect expressions originated from the feature.
			create l_collector
			l_collector.collect_from_feature (a_context_class, a_context_feature, True)
			Result := l_collector.last_collection_in_written_class
		end

end
