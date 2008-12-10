indexing
	description: "Config for a decision coverage slot"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_DCS_INSTRUMENT_ITEM

inherit
	HASHABLE

create
	make

feature{NONE} -- Initialization

	make (a_written_class_name: like written_class_name; a_feature_name: like feature_name; a_global_index: like global_slot_index; a_local_index: like local_slot_index; a_branch_indexes: like branch_indexes) is
			-- Initialize Current.
		require
			a_written_class_name_attached: a_written_class_name /= Void
			not_a_written_class_name_is_empty: not a_written_class_name.is_empty
			a_feature_name_attached: a_feature_name /= Void
			not_a_feature_name_is_empty: not a_feature_name.is_empty
			a_global_index_non_negative: a_global_index >= 0
			a_local_index_non_negative: a_local_index >= 0
			a_branch_indexes_attached: a_branch_indexes /= Void
			a_branch_indexes_valid: not a_branch_indexes.is_empty
		do
			set_written_class_name (a_written_class_name)
			set_feature_name (a_feature_name)
			set_global_index (a_global_index)
			set_local_index (a_local_index)
			create branch_indexes.make (a_branch_indexes.count)
			branch_indexes.append (a_branch_indexes)
		ensure
			written_class_name_set: written_class_name.is_equal (a_written_class_name)
			feature_name_set: feature_name.is_equal (a_feature_name)
			global_index_set: global_slot_index = a_global_index
			local_index_set: local_slot_index = a_local_index
		end

feature -- Access

	written_class_name: STRING
			-- Name of the class where current slot is written

	feature_name: STRING
			-- Name of the feature where current slot is written

	global_slot_index: INTEGER
			-- 0-based global index of current slot.
			-- All decision coverage slots in a system (can be in different classes)
			-- have an index, which is this `global_slot_index'.

	local_slot_index: INTEGER
			-- 0-based local index of current slot,
			-- local index is related to the feature where current slot is written.
			-- for each feature, `local_slot_index' starts with 0. And the 0-th local index
			-- is used for feature access check.

	branch_indexes: ARRAYED_LIST [INTEGER]
			-- List of indexes of branches to be covered if current slot is visited.

	hash_code: INTEGER
			-- Hash code value
		do
			Result := global_slot_index
		ensure then
			good_result: Result = global_slot_index
		end

feature -- Setting

	set_written_class_name (a_class_name: like written_class_name) is
			-- Set `written_class_name' with `a_class_name'.
		require
			a_class_name_attached: a_class_name /= Void
			not_a_class_name_is_empty: not a_class_name.is_empty
		do
			written_class_name := a_class_name.twin
		ensure
			written_class_name_set: written_class_name /= Void and then written_class_name.is_equal (a_class_name)
		end

	set_feature_name (a_class_name: like feature_name) is
			-- Set `feature_name' with `a_class_name'.
		require
			a_class_name_attached: a_class_name /= Void
			not_a_class_name_is_empty: not a_class_name.is_empty
		do
			feature_name := a_class_name.twin
		ensure
			feature_name_set: feature_name /= Void and then feature_name.is_equal (a_class_name)
		end

	set_global_index (a_index: INTEGER) is
			-- Set `global_slot_index' with `a_index'.
		require
			a_index_non_negative: a_index >= 0
		do
			global_slot_index := a_index
		ensure
			global_index_set: global_slot_index = a_index
		end

	set_local_index (a_index: INTEGER) is
			-- Set `local_slot_index' with `a_index'.
		require
			a_index_non_negative: a_index >= 0
		do
			local_slot_index := a_index
		ensure
			local_index_set: local_slot_index = a_index
		end

invariant
	written_class_name_attached: written_class_name /= Void
	not_written_class_name_is_empty: not written_class_name.is_empty
	feature_name_attached: feature_name /= Void
	not_feature_name_is_empty: not feature_name.is_empty
	global_index_non_negative: global_slot_index >= 0
	local_index_non_negative: local_slot_index >= 0
	branch_indexes_attached: branch_indexes /= Void

end
