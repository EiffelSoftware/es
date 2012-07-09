note
	description: "Processor for runtime data."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DPA_DATA_PROCESSOR

inherit
	EPA_UTILITY

feature -- Access

	last_data: DS_HASH_TABLE [LINKED_LIST [TUPLE [INTEGER, EPA_POSITIONED_VALUE, EPA_POSITIONED_VALUE]], STRING]
			-- Runtime data collected through dynamic means
			-- Keys are program locations and expressions of the form `loc;expr'.
			-- Values are a list of pre-state / post-state pairs containing pre-state and post-state values.

	last_analysis_order: LINKED_LIST [TUPLE [pre_state_bp_slot: INTEGER; post_state_bp_slot: INTEGER]]
			-- List of pre-state / post-state pairs in the order they were analyzed.
			-- Note: The analysis order is not the same as the execution order which is complete
			-- whilst the analysis order only contains the hit pre-state / post-state breakpoint slots.

	last_keys: DS_HASH_SET [STRING]
			-- All keys of the form "loc:expr" that were used during the analysis.

feature -- Setting

	set_prgm_locs_with_exprs (a_prgm_locs_with_exprs: like prgm_locs_with_exprs)
			-- Set `prgm_locs_with_exprs' to `a_prgm_locs_with_exprs'
		require
			a_prgm_locs_with_exprs_not_void: a_prgm_locs_with_exprs /= Void
		do
			prgm_locs_with_exprs := a_prgm_locs_with_exprs
		ensure
			prgm_locs_with_exprs_set: prgm_locs_with_exprs = a_prgm_locs_with_exprs
		end

feature -- Processing

	process (a_bp: BREAKPOINT; a_state: EPA_STATE)
			-- Add `a_bp' and `a_state' to `collected_states'.
		require
			a_bp_not_void: a_bp /= Void
			a_state_not_void: a_state /= Void
			--
		deferred
		end

	post_process
			-- Post-process the `collected_states' for writing
		deferred
		ensure
			last_analysis_order_not_void: last_analysis_order /= Void
			last_data_not_void: last_data /= Void
		end

feature {NONE} -- Implementation

	prgm_locs_with_exprs: DS_HASH_TABLE [DS_HASH_SET [STRING], INTEGER]
			-- Program locations where the associated expressions should
			-- be evaluated.

end
