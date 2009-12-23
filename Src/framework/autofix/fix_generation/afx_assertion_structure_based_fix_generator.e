note
	description: "Summary description for {AFX_ASSERTION_STRUCTURE_BASED_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_ASSERTION_STRUCTURE_BASED_FIX_GENERATOR

inherit
	AFX_UTILITY

feature{NONE} -- Initialization

	make (a_spot: like exception_spot; a_analyzer: like structure_analyzer; a_fixing_locations: like fixing_locations; a_config: like config)
			-- Initialize.
		require
			a_spot_has_failing_assertion: a_spot.failing_assertion /= Void
			a_analyzer_is_matched: a_analyzer.is_matched
			a_config_attached: a_config /= Void
		do
			create fixes.make
			structure_analyzer := a_analyzer
			exception_spot := a_spot
			fixing_locations := a_fixing_locations.twin
			config := a_config
		end

feature -- Access

	fixes: LINKED_LIST [AFX_FIX_SKELETON]
			-- Fixes generated

	structure_analyzer: AFX_EXPRESSION_STRUCTURE_ANALYZER
			-- Failing assertion structure analyzer

	exception_spot: AFX_EXCEPTION_SPOT
			-- Exception spot containing information of the failing

	fixing_locations: LINKED_LIST [TUPLE [scope_level: INTEGER; instructions: LINKED_LIST [AFX_AST_STRUCTURE_NODE]]]
			-- List of fixing locations

	config: AFX_CONFIG
			-- Config for current AutoFix session

feature -- Constants

	afore_skeleton_complexity: INTEGER is 1
			-- Complexity level for afore fix skeleton

	wrapping_skeleton_complexity: INTEGER is 2
			-- Complexity level for wrapping fix skeleton

feature -- Basic operations

	generate
			-- Generate fixes into `fixes'.
		deferred
		end

feature{NONE} -- Implementation

	new_afore_fix_skeleton (
			a_spot: AFX_EXCEPTION_SPOT;
			a_fixing_location: LINKED_LIST [AFX_AST_STRUCTURE_NODE];
			a_guard: detachable AFX_EXPRESSION;
			a_precondition: detachable AFX_STATE;
			a_postcondition: detachable AFX_STATE;
			a_scope_level: INTEGER): AFX_AFORE_FIX_SKELETON
				-- New afore fix sekelton.
		local
			l_ranking: AFX_FIX_RANKING
		do
			create Result.make (a_spot, config)
			Result.set_guard_condition (a_guard)
			Result.set_precondition (a_precondition)
			Result.set_postcondition (a_postcondition)
			Result.set_relevant_ast (a_fixing_location)

			create l_ranking
			l_ranking.set_fix_skeleton_complexity (afore_skeleton_complexity)
			l_ranking.set_scope_levels (a_scope_level)
			Result.set_ranking (l_ranking)
		end

	new_wrapping_fix_skeleton (
			a_spot: AFX_EXCEPTION_SPOT;
			a_fixing_location: LINKED_LIST [AFX_AST_STRUCTURE_NODE];
			a_guard: detachable AFX_EXPRESSION;
			a_precondition: detachable AFX_STATE;
			a_postcondition: detachable AFX_STATE;
			a_scope_level: INTEGER): AFX_WRAP_FIX_SKELETON
				-- New afore fix sekelton.
		require
			a_fixing_location_attached: a_fixing_location /= Void
			not_a_fixing_location_is_empty: not a_fixing_location.is_empty
		local
			l_ranking: AFX_FIX_RANKING
		do
			create Result.make (a_spot, a_guard, config)
			Result.set_precondition (a_precondition)
			Result.set_postcondition (a_postcondition)
			Result.set_relevant_ast (a_fixing_location)

			create l_ranking
			l_ranking.set_fix_skeleton_complexity (wrapping_skeleton_complexity)
			l_ranking.set_scope_levels (a_scope_level)
			Result.set_ranking (l_ranking)
		end

end
