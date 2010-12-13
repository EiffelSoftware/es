note
	description: "Summary description for {DKN_RESULT_CONCENTRATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_DKN_RESULT_CONCENTRATOR

inherit
	EPA_UTILITY

feature -- Access

	original_results: DS_HASH_TABLE [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT] assign set_original_results
			-- Raw results from Daikon.

	concentrated_results: DS_HASH_TABLE [EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION], DKN_PROGRAM_POINT]
			-- Concentrated results.
			-- After concentration, only expressions that always evaluate to True would be retained.
			-- For example: "(is_empty) = true" and "not (is_empty) = false" would be merged into "(is_empty) = true".
		do
			if concentrated_results_cache = Void then
				create concentrated_results_cache.make_equal (20)
			end
			Result := concentrated_results_cache
		ensure
			result_attached: Result /= Void
		end

	concentrated_results_cache: like concentrated_results
			-- Cache for `concentrated_results'.

feature -- Status set

	set_original_results (a_results: like original_results)
			-- Set `original_results".
		do
			original_results := a_results
			concentrated_results_cache := Void
		end

feature -- Basic operation

	concentrate_results
			-- Concentrate the `original_results' into `concentrated_results'.
		require
			original_results_attached: original_results /= Void
		local
			l_table_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]
			l_inv_set : DS_HASH_SET [DKN_INVARIANT]
			l_set_cursor: DS_HASH_SET_CURSOR [DKN_INVARIANT]
			l_new_inv_set: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]

			l_ppt: DKN_PROGRAM_POINT
			l_inv: DKN_INVARIANT
		do
			from
				l_table_cursor := original_results.new_cursor
				l_table_cursor.start
			until
				l_table_cursor.after
			loop
				l_ppt := l_table_cursor.key
				l_inv_set := l_table_cursor.item

				create l_new_inv_set.make_equal (l_inv_set.count)
				from
					l_set_cursor := l_inv_set.new_cursor
					l_set_cursor.start
				until
					l_set_cursor.after
				loop
					l_inv := l_set_cursor.item

					l_new_inv_set.force (invariant_in_positive_form (l_inv, l_ppt))

					l_set_cursor.forth
				end
				concentrated_results.force (l_new_inv_set, l_ppt)

				l_table_cursor.forth
			end
		end

feature{NONE} -- Implementation

	invariant_in_positive_form (a_inv: DKN_INVARIANT; a_ppt: DKN_PROGRAM_POINT): AFX_PROGRAM_STATE_EXPRESSION
			-- Invariant based on `a_inv', but in positive form, at `a_ppt'.
			-- I.e. the expression in the invariant always evaluates to True at `a_ppt'.
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_bp_index: INTEGER
			l_inv_text, l_inv_exp, l_inv_val: STRING
			l_equal_sign_position: INTEGER
			l_val: BOOLEAN
			l_exp: EPA_AST_EXPRESSION
			l_ast: AST_EIFFEL
		do
			l_class := first_class_starts_with_name (a_ppt.class_name)
			l_feature := l_class.feature_named_32 (a_ppt.feature_name)
			l_bp_index := a_ppt.bp_index

			l_inv_text := a_inv.text
			l_equal_sign_position := l_inv_text.last_index_of ('=', l_inv_text.count)
			l_inv_exp := l_inv_text.substring (1, l_equal_sign_position - 1)

			l_inv_val := l_inv_text.substring (l_equal_sign_position + 1, l_inv_text.count)
			l_inv_val.prune_all_leading (' ')
			l_inv_val.prune_all_trailing (' ')
			if l_inv_val.is_boolean then
				create l_exp.make_with_text (l_class, l_feature, l_inv_exp, l_feature.written_class)
				l_ast := l_exp.ast

				-- Negate the expression if it always evaluates to `False'.
				if not l_inv_val.to_boolean then
					if attached {UN_NOT_AS} l_ast as lt_not then
						l_ast := lt_not.expr
					elseif attached {BIN_NE_AS} l_ast as lt_ne then
						create {BIN_EQ_AS}l_ast.initialize (lt_ne.left, lt_ne.right, Void)
					elseif attached {BIN_EQ_AS} l_ast as lt_eq then
						create {BIN_NE_AS}l_ast.initialize (lt_eq.left, lt_eq.right, Void)
					elseif attached {BIN_GE_AS} l_ast as lt_ge then
						create {BIN_LT_AS}l_ast.initialize (lt_ge.left, lt_ge.right, Void)
					elseif attached {BIN_GT_AS} l_ast as lt_gt  then
						create {BIN_LE_AS}l_ast.initialize (lt_gt.left, lt_gt.right, Void)
					elseif attached {BIN_LE_AS} l_ast as lt_le then
						create {BIN_GT_AS}l_ast.initialize (lt_le.left, lt_le.right, Void)
					elseif attached {BIN_LT_AS} l_ast as lt_lt then
						create {BIN_GE_AS}l_ast.initialize (lt_lt.left, lt_lt.right, Void)
					elseif attached {EXPR_AS}l_ast as lt_expr then
						create {UN_NOT_AS}l_ast.initialize (lt_expr, Void)
					end
				end
				-- Get rid of extra parantheses.
				if attached {PARAN_AS} l_ast as lt_paran then
					l_ast := lt_paran.expr
				end

				if l_ast /= Void then
					create Result.make_with_text (l_class, l_feature, text_from_ast (l_ast), l_feature.written_class, a_ppt.bp_index)
				end
			end
		end

--	context_info_from_program_point (a_ppt: DKN_PROGRAM_POINT): TUPLE[CLASS_C, FEATURE_I]
--			-- Information about the context class and the context feature from `a_ppt'.
--		local
--			l_ppt_name, l_class_name, l_feature_name, l_index_text: STRING
--			l_start_index, l_end_index: INTEGER
--			l_class: CLASS_C
--			l_feature: FEATURE_I
--		do
--			l_ppt_name := a_ppt.name
--			l_start_index := l_ppt_name.index_of ('.', 1)
--			check start_index_positive: l_start_index > 0 end
--			l_class_name := l_ppt_name.substring (1, l_start_index - 1)

--			l_start_index := l_start_index + 1
--			l_end_index := l_ppt_name.substring_index ({DKN_CONSTANTS}.ppt_tag_separator, l_start_index)
--			l_feature_name := l_ppt_name.substring (l_start_index, l_end_index - 1)

--			l_index_text := l_ppt_name.substring (l_end_index + {DKN_CONSTANTS}.ppt_tag_separator.count, l_ppt_name.count)
--			check valid_index: l_index_text.is_integer and then l_index_text.to_integer > 0 end

--			l_class := first_class_starts_with_name (l_class_name)
--			check valid_class: l_class /= Void end
--			l_feature := l_class.feature_named_32 (l_feature_name)
--			check valid_feature: l_feature /= Void end

--			Result := [l_class, l_feature]
--		end

end
