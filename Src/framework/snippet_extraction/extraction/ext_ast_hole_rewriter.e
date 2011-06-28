note
	description: "Iterator to transform AST and remove nodes irrelevant w.r.t. the snippet."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_HOLE_REWRITER

inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			make_with_output,

			process_access_assert_as,
			process_access_feat_as,
			process_access_id_as,
			process_access_inv_as,
			process_address_as,
			process_address_current_as,
			process_address_result_as,
			process_agent_routine_creation_as,
			process_all_as,
			process_array_as,
			process_assign_as,
			process_assigner_call_as,
			process_attribute_as,
			process_bang_creation_as,
			process_bang_creation_expr_as,
			process_bin_and_as,
			process_bin_and_then_as,
			process_bin_div_as,
			process_bin_eq_as,
			process_bin_free_as,
			process_bin_ge_as,
			process_bin_gt_as,
			process_bin_implies_as,
			process_bin_le_as,
			process_bin_lt_as,
			process_bin_minus_as,
			process_bin_mod_as,
			process_bin_ne_as,
			process_bin_not_tilde_as,
			process_bin_or_as,
			process_bin_or_else_as,
			process_bin_plus_as,
			process_bin_power_as,
			process_bin_slash_as,
			process_bin_star_as,
			process_bin_tilde_as,
			process_bin_xor_as,
			process_binary_as,
			process_bit_const_as,
			process_bits_as,
			process_bits_symbol_as,
			process_body_as,
			process_bool_as,
			process_bracket_as,
			process_break_as,
			process_built_in_as,
			process_case_as,
			process_char_as,
			process_check_as,
			process_class_as,
			process_class_list_as,
			process_class_type_as,
			process_client_as,
			process_constant_as,
			process_constraining_type_as,
			process_convert_feat_as,
			process_convert_feat_list_as,
			process_converted_expr_as,
			process_create_as,
			process_create_creation_as,
			process_create_creation_expr_as,
			process_creation_as,
			process_creation_expr_as,
			process_current_as,
			process_custom_attribute_as,
			process_debug_as,
			process_deferred_as,
			process_delayed_actual_list_as,
			process_do_as,
			process_eiffel_list,
			process_elseif_as,
			process_ensure_as,
			process_ensure_then_as,
			process_export_clause_as,
			process_export_item_as,
			process_expr_address_as,
			process_expr_call_as,
			process_external_as,
			process_external_lang_as,
			process_feat_name_id_as,
			process_feature_as,
			process_feature_clause_as,
			process_feature_list_as,
			process_feature_name_alias_as,
			process_for_all_as,
			process_formal_argu_dec_list_as,
			process_formal_as,
			process_formal_dec_as,
			process_formal_generic_list_as,
			process_generic_class_type_as,
			process_guard_as,
			process_id_as,
			process_if_as,
			process_index_as,
			process_indexing_clause_as,
			process_infix_prefix_as,
			process_inline_agent_creation_as,
			process_inspect_as,
			process_instr_call_as,
			process_integer_as,
			process_interval_as,
			process_invariant_as,
			process_iteration_as,
			process_key_list_as,
			process_keyword_as,
			process_keyword_stub_as,
			process_leaf_stub_as,
			process_like_cur_as,
			process_like_id_as,
			process_local_dec_list_as,
			process_loop_as,
			process_loop_expr_as,
			process_named_tuple_type_as,
			process_nested_as,
			process_nested_expr_as,
			process_none_id_as,
			process_none_type_as,
			process_object_test_as,
			process_once_as,
			process_operand_as,
			process_parameter_list_as,
			process_paran_as,
			process_parent_as,
			process_parent_list_as,
			process_precursor_as,
			process_qualified_anchored_type_as,
			process_real_as,
			process_redefine_clause_as,
			process_rename_as,
			process_rename_clause_as,
			process_require_as,
			process_require_else_as,
			process_result_as,
			process_retry_as,
			process_reverse_as,
			process_routine_as,
			process_routine_creation_as,
			process_select_clause_as,
			process_static_access_as,
			process_string_as,
			process_symbol_as,
			process_symbol_stub_as,
			process_tagged_as,
			process_there_exists_as,
			process_tuple_as,
			process_type_dec_as,
			process_type_dec_list_as,
			process_type_expr_as,
			process_type_list_as,
			process_typed_char_as,
			process_un_free_as,
			process_un_minus_as,
			process_un_not_as,
			process_un_old_as,
			process_un_plus_as,
			process_un_strip_as,
			process_unary_as,
			process_undefine_clause_as,
			process_unique_as,
			process_variant_as,
			process_verbatim_string_as,
			process_void_as
		end

	EPA_UTILITY

	REFACTORING_HELPER

create
	make_with_output

feature {NONE} -- Creation

	make_with_output (a_output: like output)
			-- Make with `a_output' and initialize empty `annotations'.
		do
			Precursor (a_output)
		end

feature -- Access

	annotation_context: EXT_ANNOTATION_CONTEXT
		assign set_annotation_context
			-- Contextual information about relevant variables.

	set_annotation_context (a_context: EXT_ANNOTATION_CONTEXT)
			-- Sets `annotation_context' to `a_context'	
		require
			attached a_context
		do
			annotation_context := a_context
		end

feature -- Roundtrip

	process_none_id_as (l_as: NONE_ID_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_typed_char_as (l_as: TYPED_CHAR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_agent_routine_creation_as (l_as: AGENT_ROUTINE_CREATION_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
				output.append_string (Ti_new_line)
			else
				Precursor (l_as)
			end
		end

	process_bang_creation_as (l_as: BANG_CREATION_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
				output.append_string (Ti_new_line)
			else
				Precursor (l_as)
			end
		end

	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bang_creation_expr_as (l_as: BANG_CREATION_EXPR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

feature -- Roundtrip

	process_keyword_as (l_as: KEYWORD_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_symbol_as (l_as: SYMBOL_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_break_as (l_as: BREAK_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_leaf_stub_as (l_as: LEAF_STUB_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_symbol_stub_as (l_as: SYMBOL_STUB_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_keyword_stub_as (l_as: KEYWORD_STUB_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

feature {AST_EIFFEL} -- Helpers



feature {AST_EIFFEL} -- Skeleton Visitors

	process_custom_attribute_as (l_as: CUSTOM_ATTRIBUTE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_id_as (l_as: ID_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_feature_clause_as (l_as: FEATURE_CLAUSE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_unique_as (l_as: UNIQUE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_tuple_as (l_as: TUPLE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_real_as (l_as: REAL_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bool_as (l_as: BOOL_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bit_const_as (l_as: BIT_CONST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_array_as (l_as: ARRAY_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_char_as (l_as: CHAR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_string_as (l_as: STRING_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_body_as (l_as: BODY_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_built_in_as (l_as: BUILT_IN_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_result_as (l_as: RESULT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_current_as (l_as: CURRENT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_access_inv_as (l_as: ACCESS_INV_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_nested_as (l_as: NESTED_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_creation_expr_as (l_as: CREATION_EXPR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_routine_as (l_as: ROUTINE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_constant_as (l_as: CONSTANT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_indexing_clause_as (l_as: INDEXING_CLAUSE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_infix_prefix_as (l_as: INFIX_PREFIX_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_feat_name_id_as (l_as: FEAT_NAME_ID_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_feature_name_alias_as (l_as: FEATURE_NAME_ALIAS_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_feature_list_as (l_as: FEATURE_LIST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_all_as (l_as: ALL_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_attribute_as (l_as: ATTRIBUTE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_deferred_as (l_as: DEFERRED_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_do_as (l_as: DO_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_once_as (l_as: ONCE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_type_dec_as (l_as: TYPE_DEC_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_parent_as (l_as: PARENT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_like_id_as (l_as: LIKE_ID_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_like_cur_as (l_as: LIKE_CUR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_qualified_anchored_type_as (l_as: QUALIFIED_ANCHORED_TYPE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_formal_dec_as (l_as: FORMAL_DEC_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_constraining_type_as (l_as: CONSTRAINING_TYPE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_none_type_as (l_as: NONE_TYPE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bits_as (l_as: BITS_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bits_symbol_as (l_as: BITS_SYMBOL_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_rename_as (l_as: RENAME_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_invariant_as (l_as: INVARIANT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_index_as (l_as: INDEX_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_export_item_as (l_as: EXPORT_ITEM_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_create_as (l_as: CREATE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_client_as (l_as: CLIENT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_ensure_as (l_as: ENSURE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_require_as (l_as: REQUIRE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_require_else_as (l_as: REQUIRE_ELSE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_convert_feat_as (l_as: CONVERT_FEAT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_convert_feat_list_as (l_as: CONVERT_FEAT_LIST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_class_list_as (l_as: CLASS_LIST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_parent_list_as (l_as: PARENT_LIST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_local_dec_list_as (l_as: LOCAL_DEC_LIST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_formal_argu_dec_list_as (l_as: FORMAL_ARGU_DEC_LIST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_key_list_as (l_as: KEY_LIST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_delayed_actual_list_as (l_as: DELAYED_ACTUAL_LIST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_rename_clause_as (l_as: RENAME_CLAUSE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_export_clause_as (l_as: EXPORT_CLAUSE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_undefine_clause_as (l_as: UNDEFINE_CLAUSE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_redefine_clause_as (l_as: REDEFINE_CLAUSE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_select_clause_as (l_as: SELECT_CLAUSE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_formal_generic_list_as (l_as: FORMAL_GENERIC_LIST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_iteration_as (l_as: ITERATION_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

feature {AST_EIFFEL} -- Expressions visitors

	process_tagged_as (l_as: TAGGED_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_variant_as (l_as: VARIANT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_un_strip_as (l_as: UN_STRIP_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_converted_expr_as (l_as: CONVERTED_EXPR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_paran_as (l_as: PARAN_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_expr_address_as (l_as: EXPR_ADDRESS_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_address_result_as (l_as: ADDRESS_RESULT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_address_current_as (l_as: ADDRESS_CURRENT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_address_as (l_as: ADDRESS_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_type_expr_as (l_as: TYPE_EXPR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_routine_creation_as (l_as: ROUTINE_CREATION_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_un_free_as (l_as: UN_FREE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_un_minus_as (l_as: UN_MINUS_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_un_not_as (l_as: UN_NOT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_un_old_as (l_as: UN_OLD_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_un_plus_as (l_as: UN_PLUS_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_and_then_as (l_as: BIN_AND_THEN_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_free_as (l_as: BIN_FREE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_implies_as (l_as: BIN_IMPLIES_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_or_as (l_as: BIN_OR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_or_else_as (l_as: BIN_OR_ELSE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_xor_as (l_as: BIN_XOR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_ge_as (l_as: BIN_GE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_gt_as (l_as: BIN_GT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_le_as (l_as: BIN_LE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_lt_as (l_as: BIN_LT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_div_as (l_as: BIN_DIV_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_minus_as (l_as: BIN_MINUS_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_mod_as (l_as: BIN_MOD_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_plus_as (l_as: BIN_PLUS_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_power_as (l_as: BIN_POWER_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_slash_as (l_as: BIN_SLASH_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_star_as (l_as: BIN_STAR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_and_as (l_as: BIN_AND_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_eq_as (l_as: BIN_EQ_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_ne_as (l_as: BIN_NE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_tilde_as (l_as: BIN_TILDE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bin_not_tilde_as (l_as: BIN_NOT_TILDE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_bracket_as (l_as: BRACKET_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_operand_as (l_as: OPERAND_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_loop_expr_as (l_as: LOOP_EXPR_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_void_as (l_as: VOID_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_unary_as (l_as: UNARY_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_binary_as (l_as: BINARY_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

feature {AST_EIFFEL} -- Instructions visitors

	process_elseif_as (l_as: ELSIF_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
				output.append_string (Ti_new_line)
			else
				Precursor (l_as)
			end
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_case_as (l_as: CASE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_check_as (l_as: CHECK_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_creation_as (l_as: CREATION_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
				output.append_string (Ti_new_line)
			else
				Precursor (l_as)
			end
		end

	process_debug_as (l_as: DEBUG_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_guard_as (l_as: GUARD_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_if_as (l_as: IF_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_inspect_as (l_as: INSPECT_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				process_child (l_as.call, l_as, 1)
			end
			output.append_string (Ti_new_line)
		end

	process_interval_as (l_as: INTERVAL_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_loop_as (l_as: LOOP_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_retry_as (l_as: RETRY_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_reverse_as (l_as: REVERSE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

feature {AST_EIFFEL} -- External visitors

	process_external_as (l_as: EXTERNAL_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_external_lang_as (l_as: EXTERNAL_LANG_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

feature {AST_EIFFEL} -- Clickable visitor

	process_class_as (l_as: CLASS_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_class_type_as (l_as: CLASS_TYPE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_formal_as (l_as: FORMAL_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_type_list_as (l_as: TYPE_LIST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_type_dec_list_as (l_as: TYPE_DEC_LIST_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

feature -- Quantification

	process_there_exists_as (l_as: THERE_EXISTS_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

	process_for_all_as (l_as: FOR_ALL_AS)
		do
			if attached l_as.path as l_path and then annotation_context.has_annotation_hole (l_path) then
				output.append_string (annotation_context.get_first_annotation_hole (l_path).out)
			else
				Precursor (l_as)
			end
		end

end
