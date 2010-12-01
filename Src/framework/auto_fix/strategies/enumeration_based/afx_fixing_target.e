note
	description: "Summary description for {AFX_FIXING_TARGET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIXING_TARGET

inherit

	EPA_HASH_CALCULATOR
		redefine
			is_equal
		end

	DEBUG_OUTPUT
		redefine
			is_equal
		end

create
	make

feature -- Initialization

	make (a_expressions: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]; a_bp_index: INTEGER; a_rank: REAL)
			-- Initialization.
		require
			expressions_attached: a_expressions /= Void
			bp_index_valid: a_bp_index >= 0
			rank_non_negative: a_rank >= 0
		do
			expressions := a_expressions
			bp_index := a_bp_index
			suspiciousness_value := a_rank
		end

feature -- Access

	context_class: CLASS_C
			-- Context class of the fixing target.
		require
			expressions_not_empty: expressions /= Void and then not expressions.is_empty
		do
			Result := expressions.first.context_class
		end

	context_feature: FEATURE_I
			-- Context feature of the fixing target.
		require
			expressions_not_empty: expressions /= Void and then not expressions.is_empty
		do
			Result := expressions.first.feature_
		end

	written_class: CLASS_C
			-- Written class of the fixing target.
		require
			expressions_not_empty: expressions /= Void and then not expressions.is_empty
		do
			Result := expressions.first.written_class
		end

	expressions: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			-- Expressions as the target of fixing.

	most_relevant_fixing_condition: AFX_FIXING_TARGET assign set_most_relevant_fixing_condition
			-- The most relevant fixing condition for the current target.

	bp_index: INTEGER
			-- Breakpoint index where `target' is considered as a fixing target.

	control_distance: INTEGER
			-- Distance of the fixing position, i.e. specified using `bp_index',
			--		from the failing position.

	data_distance: INTEGER
			-- Data distance between `expressions' and the failing assertion.
			-- It is equal to the number of common sub-expressions shared between them.

	suspiciousness_value: REAL
			-- Suspiciousness value of this fixing target.
			-- Based only on the statistical data from execution traces.

	rank: REAL
			-- Rank of the current fixing target.

feature -- Status set

	set_suspiciousness_value (a_value: REAL)
			-- Set `suspiciousness_value'.
		require
			value_non_negative: a_value >= 0
		do
			suspiciousness_value := a_value
		end

	set_control_distance (a_distance: INTEGER)
			-- Set `control_distance'.
		require
			distance_ge_zero: a_distance >= 0
		do
			control_distance := a_distance
		end

	set_data_distance (a_distance: INTEGER)
			-- Set `data_distance'.
		require
			distance_ge_zero: a_distance >= 0
		do
			data_distance := a_distance
		end

	set_rank (a_rank: REAL)
			-- Set `rank'.
		do
			rank := a_rank
		end

	set_most_relevant_fixing_condition (a_cond: like most_relevant_fixing_condition)
			-- Set `most_relevant_fixing_condition'.
		do
			most_relevant_fixing_condition := a_cond
		end

	update_most_relevant_fixing_condition (a_target: AFX_FIXING_TARGET)
			-- Update the most relevant fixing condition, using more relevant one of `Current'.`most_relevant_fixing_condition' and that of `a_target'.
		require
			target_with_single_boolean_expression: a_target /= Void implies
						(a_target.expressions.count = 1 and then a_target.expressions.first.type.is_boolean)
		do
			if (most_relevant_fixing_condition = Void) or else (most_relevant_fixing_condition.suspiciousness_value < a_target.suspiciousness_value) then
				set_most_relevant_fixing_condition (a_target)
			end
		end

feature -- Status report

	is_about_the_same_target (a_target: like Current): BOOLEAN
			-- Is the current object and `a_target' about the same fixing target?
		do
			if bp_index = a_target.bp_index and then hash_code = a_target.hash_code and then expressions ~ a_target.expressions then
				Result := True
			end
		end

	is_equal (a_target: like Current): BOOLEAN
			-- <Precursor>
		do
			if a_target /= Void and then expressions ~ a_target.expressions and then bp_index = a_target.bp_index and then suspiciousness_value = a_target.suspiciousness_value then
				Result := True
			end
		end

feature -- Debug output

	debug_output: STRING
			-- <Precursor>
		do
			create Result.make_empty
			from expressions.start
			until expressions.after
			loop
				Result.append (expressions.item_for_iteration.text)
				Result.append (",")
				expressions.forth
			end
			if not Result.is_empty then
				Result.remove (Result.count)
			end
			Result.append ("@" + bp_index.out + "[" + suspiciousness_value.out + "]")
		end

feature -- Hash

	key_to_hash: DS_LINEAR [INTEGER]
			-- <Precursor>
		local
			l_keys: DS_LINKED_LIST [INTEGER]
		do
			create l_keys.make

			-- Since, in the future, we might need to localize faults across-features,
			--		it's important that we can distinguish between targets from different features.
			l_keys.force_last (context_class.class_id)
			l_keys.force_last (context_feature.feature_id)
			l_keys.force_last (bp_index)
			from expressions.start
			until expressions.after
			loop
				l_keys.force_last (expressions.item_for_iteration.hash_code)
				expressions.forth
			end
			l_keys.force_last (bp_index)

			Result := l_keys
		end

invariant

	expression_attached: expressions /= Void
	bp_index_valid: bp_index >= 0
	rank_non_negative: suspiciousness_value >= 0

end
