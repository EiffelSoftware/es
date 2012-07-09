note
	description: "Summary description for {EPA_DATA_WRITER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DPA_DATA_WRITER

inherit
	EPA_EXPRESSION_VALUE_TYPE_CONSTANTS

feature -- Basic operations

	write
			--
		deferred
		end

feature -- Access

	context_class: CLASS_C
			-- Context class to which `analyzed_feature' belongs.

	analyzed_feature: FEATURE_I
			-- Feature which was analyzed through dynamic means.

	collected_runtime_data: DS_HASH_TABLE [LINKED_LIST [TUPLE [INTEGER, EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]], STRING]
			-- Runtime data collected through dynamic means
			-- Keys are program locations and expressions of the form `loc;expr'.
			-- Values are a list of pre-state / post-state pairs containing pre-state and post-state values.

	analysis_order: LINKED_LIST [TUPLE [pre_state_bp: INTEGER; post_state_bp: INTEGER]]
			-- List of pre-state / post-state pairs in the order they were analyzed.
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoint slots.

feature -- Setting

	set_collected_data (a_collected_runtime_data: like collected_runtime_data)
			-- Set `collected_runtime_data' to `a_collected_runtime_data'.
		require
			a_collected_runtime_data_not_void: a_collected_runtime_data /= Void
		do
			collected_runtime_data := a_collected_runtime_data
		ensure
			collected_runtime_data_set: collected_runtime_data = a_collected_runtime_data
		end

	set_analysis_order (a_analysis_order: like analysis_order)
			--
		require
			a_analysis_order_not_void: a_analysis_order /= Void
		do
			analysis_order := a_analysis_order
		ensure
			analysis_order_set: analysis_order = a_analysis_order
		end

end
