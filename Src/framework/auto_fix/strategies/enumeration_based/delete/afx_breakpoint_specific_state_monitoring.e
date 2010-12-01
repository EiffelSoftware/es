note
	description: "Summary description for {AFX_BREAKPOINT_SPECIFIC_STATE_MONITORING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BREAKPOINT_SPECIFIC_STATE_MONITORING

inherit
	AFX_STATE_MONITORING_STRATEGY

feature -- Basic operation

	register_expressions_at_bp_indexes (a_skeleton: AFX_STATE_SKELETON; a_range: TUPLE[start_index, end_index: INTEGER])
			-- <Precursor>
		local
			l_exp: EPA_EXPRESSION
			l_program_state_exp: AFX_PROGRAM_STATE_EXPRESSION
			l_feature: FEATURE_I
			l_first_index, l_last_index: INTEGER
			l_index: INTEGER
			l_exp_text: STRING
		do
			l_exp := a_skeleton.first
			l_feature := l_exp.feature_

			-- Compute the first and the last bp index.
			l_first_index := a_range.start_index
			l_last_index := a_range.end_index

			from a_skeleton.start
			until a_skeleton.after
			loop
				l_exp := a_skeleton.item_for_iteration
				l_exp_text := l_exp.text

				check attached {AFX_PROGRAM_STATE_EXPRESSION} l_exp as lt_exp then
					l_index := lt_exp.breakpoint_slot
					check valid_index: (l_index /= 0) implies (l_first_index <= l_index and then l_index <= l_last_index) end

					if l_index /= 0 then
						-- Only register expressions with specific breakpoint indexes.
						create {EPA_AST_EXPRESSION} l_exp.make_with_text_and_type (lt_exp.class_, lt_exp.feature_, l_exp_text, lt_exp.written_class, lt_exp.type)
						register_an_expression_at_bp_index (l_exp, l_index)
					end
				end

				a_skeleton.forth
			end
		end

end
