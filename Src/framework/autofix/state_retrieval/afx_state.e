note
	description: "Summary description for {AFX_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE

inherit
	DS_HASH_SET [AFX_PREDICATE]

	REFACTORING_HELPER
		undefine
			copy,
			is_equal
		end

create
	make

feature -- Access

	skeleton: AFX_STATE_SKELETON
			-- Skeleton of current state
		do
			create Result.make (count)
			do_all (agent (a_pred: AFX_PREDICATE; a_skeleton: AFX_STATE_SKELETON)
				do
					a_skeleton.force_last (a_pred.expression)
				end (?, Result))
		ensure
			good_result: Result.count = count
		end

feature -- Status report

	implication alias "implies" (other: AFX_STATE): BOOLEAN
			-- Does Current implies `other'?
		do
			to_implement ("Implment this feature. 2009.11.1 Jasonw.")
		end

end
