note
	description: "Summary description for {AFX_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE

inherit
	DS_HASH_SET [AFX_PREDICATE]
		rename
			make as make_set
		end

	REFACTORING_HELPER
		undefine
			copy,
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (n: INTEGER; a_class: like class_; a_feature: like feature_) is
			-- Create an empty container and allocate
			-- memory space for at least `n' items.
			-- Set equality tester to {AFX_PREDICATE_EQUALITY_TESTER}.			
		do
			class_ := a_class
			feature_ := a_feature
			make_set (n)
			set_equality_tester (create {AFX_PREDICATE_EQUALITY_TESTER})
		end

feature -- Access

	class_: CLASS_C
			-- Class from which Current state is derived

	feature_: detachable FEATURE_I
			-- Feature from which Current state is derived
			-- If Void, it means that Current state is derived for the whole class,
			-- instead of particular feature.

	skeleton: AFX_STATE_SKELETON
			-- Skeleton of current state
		do
			create Result.make_basic (class_, feature_, count)
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
