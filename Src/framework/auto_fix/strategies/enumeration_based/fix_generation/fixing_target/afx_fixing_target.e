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

	make (a_expression: EPA_EXPRESSION; a_bp_index: INTEGER; a_rank: REAL)
			-- Initialization.
		require
			expression_attached: a_expression /= Void
			bp_index_valid: a_bp_index >= 0
			rank_non_negative: a_rank >= 0
		do
			expression := a_expression
			bp_index := a_bp_index
			suspiciousness_value := a_rank
			create program_location.make (create {EPA_FEATURE_WITH_CONTEXT_CLASS}.make (expression.feature_, expression.class_), bp_index)
		end

feature -- Access

	context_class: CLASS_C
			-- Context class of the fixing target.
		do
			Result := expression.context_class
		end

	context_feature: FEATURE_I
			-- Context feature of the fixing target.
		do
			Result := expression.feature_
		end

	written_class: CLASS_C
			-- Written class of the fixing target.
		do
			Result := expression.written_class
		end

	program_location: AFX_PROGRAM_LOCATION
			-- Program location the target is aiming for.

	expression: EPA_EXPRESSION
			-- Expression as the target of fixing.

	bp_index: INTEGER
			-- Breakpoint index where `target' is considered as a fixing target.

	control_distance: INTEGER
			-- Distance of the fixing position, i.e. specified using `bp_index',
			--		from the failing position.

	data_distance: REAL_64
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

	set_data_distance (a_distance: REAL_64)
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

feature -- Status report

	is_about_the_same_target (a_target: like Current): BOOLEAN
			-- Is the current object and `a_target' about the same fixing target?
		do
			if bp_index = a_target.bp_index and then hash_code = a_target.hash_code and then expression ~ a_target.expression then
				Result := True
			end
		end

	is_equal (a_target: like Current): BOOLEAN
			-- <Precursor>
		do
			if a_target /= Void and then expression ~ a_target.expression and then bp_index = a_target.bp_index and then rank = a_target.rank then
				Result := True
			end
		end

feature -- Debug output

	debug_output: STRING
			-- <Precursor>
		do
			create Result.make_empty
			Result.append (expression.text)
			Result.append ("@" + bp_index.out + "[" + rank.out + "]")
		end

feature -- Hash

	key_to_hash: DS_LINEAR [INTEGER]
			-- <Precursor>
		local
			l_keys: DS_LINKED_LIST [INTEGER]
		do
			create l_keys.make
			l_keys.force_last (expression.hash_code)
			l_keys.force_last (bp_index)
			l_keys.force_last ((suspiciousness_value * 1000).truncated_to_integer)

			Result := l_keys
		end

invariant

	expression_attached: expression /= Void
	bp_index_valid: bp_index >= 0
	rank_non_negative: suspiciousness_value >= 0

end
