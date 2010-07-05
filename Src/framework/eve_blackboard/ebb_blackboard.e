note
	description: "Summary description for {EBB_BLACKBOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_BLACKBOARD

inherit

	SHARED_WORKBENCH
		export {NONE} all end

	EBB_SHARED_ALL

create {EBB_SHARED_BLACKBOARD}
	make

feature {NONE} -- Initialization

	make
			-- Initialize empty blackboard.
		do
			create data.make
			create {EBB_BASIC_CONTROL} control.make
			create {LINKED_LIST [EBB_TOOL]} tools.make
			create {LINKED_LIST [EBB_FEATURE_VERIFICATION_RESULT]} verification_results.make
		end

feature -- Access

	data: EBB_SYSTEM_DATA
			-- Blackboard data for system.

	control: EBB_CONTROL
			-- Blackboard control.

	tools: LIST [EBB_TOOL]
			-- Available tools for blackboard.

feature -- Basic operations

	add_verification_result (a_result: EBB_FEATURE_VERIFICATION_RESULT)
			-- Add `a_result' to list of verification results.
		do
			verification_results.extend (a_result)
		end

	commit_results
			-- Commit all verification results added since last commit of results.
		do
			across verification_results as l_cursor loop
				data.feature_data (l_cursor.item.associated_feature).update_with_new_result (l_cursor.item)
			end
			verification_results.wipe_out
		end

feature {NONE} -- Implementation

	verification_results: LIST [EBB_FEATURE_VERIFICATION_RESULT]
			-- List of verification results.

end
