note
	description: "Class containing the dynamically analyzed feature, the execution order and the collected runtime data."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_COLLECTED_RUNTIME_DATA

create
	make

feature -- Initialization

	make (a_class: like context_class; a_feature: like analyzed_feature; a_order: like analysis_order; a_data: like collected_runtime_data)
			-- Initialize `context_class' with `a_class',
			-- `analyzed_feature' with `a_feature',
			-- `execution_order' with `a_order' and
			-- `collected_runtime_data' with `a_data'.
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
			a_order_not_void: a_order /= Void
			a_data_not_void: a_data /= Void
		do
			context_class := a_class
			analyzed_feature := a_feature
			analysis_order := a_order
			collected_runtime_data := a_data
		ensure
			context_class_set: context_class = a_class
			analyzed_feature_set: analyzed_feature = a_feature
			analysis_order_set: analysis_order = a_order
			collected_runtime_data_set: collected_runtime_data = a_data
		end

feature -- Access

	context_class: CLASS_C
			-- Context class to which `analyzed_feature' belongs

	analyzed_feature: FEATURE_I
			-- Feature which was analyzed through dynamic means

	analysis_order: LINKED_LIST [TUPLE [INTEGER, INTEGER]]
			-- List of pre-state / post-state pairs in the order they were analyzed.
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoint slots.

	collected_runtime_data: DS_HASH_TABLE [LINKED_LIST [TUPLE [call_stack_count: INTEGER; pre_state_value: EPA_POSITIONED_VALUE; post_state_value: EPA_POSITIONED_VALUE]], STRING]
			-- Runtime data collected through dynamic means
			-- Keys are program locations and expressions of the form `loc;expr'.
			-- Values are a list of pre-state / post-state pairs containing pre-state and post-state values.

end
