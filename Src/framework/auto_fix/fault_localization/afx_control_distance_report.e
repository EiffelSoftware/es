note
	description: "Summary description for {AFX_CONTROL_DISTANCE_REPORT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CONTROL_DISTANCE_REPORT

create
	make

feature -- Initialization

	make (a_class: CLASS_C; a_feature: FEATURE_I; a_reference: INTEGER; a_table: DS_HASH_TABLE [INTEGER, INTEGER])
			-- Initialize control distance information using the argument objects.
		require
			context_attached: a_class /= Void and then a_feature /= Void
			reference_valid: a_reference > 0
			table_not_empty: a_table /= Void and then not a_table.is_empty
		do
			context_class := a_class
			context_feature := a_feature
			reference_bp_index := a_reference
			control_distances := a_table
		end

feature -- Access

	context_class: CLASS_C
			-- Context class where control distance is computed.

	context_feature: FEATURE_I
			-- Context feature where control distance is computed.

	reference_bp_index: INTEGER
			-- Reference breakpoint index.

	control_distances: DS_HASH_TABLE [INTEGER, INTEGER]
			-- Control distances between instructions in `context_feature'
			--		and `reference_bp_index'.
			-- Key: bp index of an instruction.
			-- Val: control distance of that instruction to the reference bp index.

	distance_from (a_bp_index: INTEGER): INTEGER
			-- Distance from `a_bp_index' to `reference_bp_index'.
		do
			Result := Infinite_distance
			if control_distances /= Void and then control_distances.has (a_bp_index) then
				Result := control_distances.item (a_bp_index)
			end
		end

feature -- Constant

	Infinite_distance: INTEGER = 1_000_000
			-- Infinite distance for unreachable nodes.

end
