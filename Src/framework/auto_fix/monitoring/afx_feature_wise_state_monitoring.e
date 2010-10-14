note
	description: "Summary description for {AFX_FEATURE_WISE_STATE_MONITORING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FEATURE_WISE_STATE_MONITORING

inherit
	AFX_STATE_MONITORING_STRATEGY

feature -- Basic operation

	register_expressions_at_bp_indexes (a_skeleton: AFX_STATE_SKELETON; a_range: TUPLE[start_index, end_index: INTEGER])
			-- <Precursor>
		local
			l_exp: EPA_EXPRESSION
			l_feature: FEATURE_I
			l_first_index, l_last_index: INTEGER
			l_index: INTEGER
			l_exp_text: STRING
			l_exp_cache: DS_HASH_SET [STRING]
		do
			l_exp := a_skeleton.first
			l_feature := l_exp.feature_

			-- Compute the first and the last bp index.
			l_first_index := a_range.start_index
			l_last_index := a_range.end_index

			-- Use a cache to avoid registering expressions with the same text repeatedly.
			create l_exp_cache.make_equal (5)

			from a_skeleton.start
			until a_skeleton.after
			loop
				l_exp := a_skeleton.item_for_iteration
				l_exp_text := l_exp.text

				if not l_exp_cache.has (l_exp_text) then
					-- Register an expression only if it's not registered yet.

					-- Create a real {EPA_AST_EXPRESSION} object, in case the skeleton contains {EPA_PROGRAM_STATE_EXPRESSION}s.
					-- Because the set uses `is_equal' to compare objects, and `is_equal' can be redefined.
					create {EPA_AST_EXPRESSION} l_exp.make_with_text_and_type (l_exp.class_, l_exp.feature_, l_exp_text, l_exp.written_class, l_exp.type)
					register_an_expression_at_all_bp_indexes (l_exp, l_first_index, l_last_index)

					l_exp_cache.force (l_exp_text)
				end

				a_skeleton.forth
			end
		end

end
