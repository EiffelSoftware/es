note
	description: "Summary description for {AFX_STATE_MONITORING_STRATEGY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_STATE_MONITORING_STRATEGY

feature -- Access

	expression_bp_registration: attached DS_HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], INTEGER]
			-- Registration of breakpoint indexes and the set of expressions that would be
			--		monitored at these indexes.
		do
			if expression_bp_registration_cache = Void then
				create expression_bp_registration_cache.make_equal (10)
			end
			Result := expression_bp_registration_cache
		ensure
			result_attached: Result /= Void
		end

feature -- Basic operation

	set_up_monitoring (a_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER; a_skeleton: AFX_STATE_SKELETON; a_range: TUPLE[start_index: INTEGER; end_index: INTEGER]; a_action: PROCEDURE [ANY, TUPLE [BREAKPOINT, EPA_STATE]])
			-- Set up monitoring of the expressions for `a_spot' according to the current strategy.
			-- `a_manager' is the breakpoint manager, and `a_action' will be called to process the monitored values.
		local
			l_registration: DS_HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], INTEGER]
			l_index: INTEGER
			l_exp_set: DS_HASH_SET [EPA_EXPRESSION]
		do
			register_expressions_at_bp_indexes (a_skeleton, a_range)

			-- Set up monitoring at breakpoints.
			l_registration := expression_bp_registration
			l_registration.do_all_with_key (
					agent (aa_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER; aa_set: DS_HASH_SET[EPA_EXPRESSION]; aa_index: INTEGER; aa_action: PROCEDURE [ANY, TUPLE [BREAKPOINT, EPA_STATE]])
						do
							aa_manager.set_breakpoint_with_expression_and_action (aa_index, aa_set, aa_action)
						end (a_manager, ?, ?, a_action))
		end


feature{NONE} -- Cache

	expression_bp_registration_cache: like expression_bp_registration
			-- Cache for `expression_bp_registration'.

feature{NONE} -- Implementation

	register_expressions_at_bp_indexes (a_skeleton: AFX_STATE_SKELETON; a_range: TUPLE [INTEGER, INTEGER])
			-- Register expressions at breakpoint indexes where they are to be monitored.
		require
			skeleton_not_empty: not a_skeleton.is_empty
		deferred
		end

	register_an_expression_at_all_bp_indexes (a_exp: EPA_EXPRESSION; a_start_index, a_end_index: INTEGER)
			-- Register an expression `a_exp' at all breakpoint indexes, from `a_start_index' to `a_end_index'.
		require
			exp_attached: a_exp /= Void
			valid_index_range: a_start_index <= a_end_index
		local
			l_index: INTEGER
		do
			from l_index := a_start_index
			until l_index > a_end_index
			loop
				register_an_expression_at_bp_index (a_exp, l_index)
				l_index := l_index + 1
			end
		end

	register_an_expression_at_bp_index (a_exp: EPA_EXPRESSION; a_index: INTEGER)
			-- Register an expression `a_exp' at breakpoint `a_index'.
		require
			exp_attached: a_exp /= Void
			index_valid: a_index > 0
		local
			l_set: DS_HASH_SET [EPA_EXPRESSION]
			l_exp: EPA_EXPRESSION
			l_exp_table: DS_HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], INTEGER]
		do
			l_exp_table := expression_bp_registration

			if l_exp_table.has (a_index) then
				l_set := l_exp_table.item (a_index)
				if not l_set.has (l_exp) then
					l_set.force (l_exp)
				end
			else
				create l_set.make_equal (5)
				l_set.force (l_exp)
				l_exp_table.force (l_set, a_index)
			end
		end


end
