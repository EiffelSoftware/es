note
	description: "Summary description for {DPA_DATA_WRITER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DPA_DATA_WRITER

inherit
	EPA_EXPRESSION_VALUE_TYPE_CONSTANTS

feature -- Access

	class_: CLASS_C
			-- Class belonging to `feature_'.

	feature_: FEATURE_I
			-- Feature which was analyzed.

	analysis_order_pairs: LINKED_LIST [TUPLE [INTEGER, INTEGER]]
			-- List of pre-state / post-state breakpoint pairs in the order they were analyzed.
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoints.

	expression_value_transitions: LINKED_LIST [EPA_EXPRESSION_VALUE_TRANSITION]
			-- Expression value transitions of the last processed state.

feature -- Adding

	add_analysis_order_pairs (a_analysis_order_pairs: like analysis_order_pairs)
			-- Add `a_analysis_order_pairs' to `analysis_order_pairs'.
		require
			a_analysis_order_pairs_not_void: a_analysis_order_pairs /= Void
			analysis_order_pairs_not_void: analysis_order_pairs /= Void
		do
			a_analysis_order_pairs.do_all (agent analysis_order_pairs.extend)
		ensure
			pairs_added: analysis_order_pairs.count = old analysis_order_pairs.count + a_analysis_order_pairs.count
		end

	add_expression_value_transitions (a_expression_value_transitions: like expression_value_transitions)
			-- Add `a_expression_value_transitions' to `expression_value_transitions'.
		require
			a_expression_value_transitions_not_void: a_expression_value_transitions /= Void
			expression_value_transitions_not_void: expression_value_transitions /= Void
		do
			a_expression_value_transitions.do_all (agent expression_value_transitions.extend)
		ensure
			transitions_added: expression_value_transitions.count = old expression_value_transitions.count + a_expression_value_transitions.count
		end

feature -- Writing

	try_write
			-- Try to write data.
		deferred
		end

	write
			-- Write data.
		deferred
		end

feature {NONE} -- Implementation

	number_of_analyses: INTEGER
			-- Number of analyses including current one of `feature_'

end
