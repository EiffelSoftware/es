note
	description: "AST iterator for tree traversal with pre- and post-process method hooks."
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_AST_ITERATOR_WITH_HOOKS

inherit
	AST_ITERATOR
		redefine
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

	EPA_AST_VISITOR_EMPTY_PRE_PROCESS_HOOK

	EPA_AST_VISITOR_EMPTY_POST_PROCESS_HOOK

feature -- Roundtrip

	process_none_id_as (l_as: NONE_ID_AS)
		do
			pre_process_none_id_as (l_as)
			Precursor (l_as)
			post_process_none_id_as (l_as)
		end

	process_typed_char_as (l_as: TYPED_CHAR_AS)
		do
			pre_process_typed_char_as (l_as)
			Precursor (l_as)
			post_process_typed_char_as (l_as)
		end

	process_agent_routine_creation_as (l_as: AGENT_ROUTINE_CREATION_AS)
		do
			pre_process_agent_routine_creation_as (l_as)
			Precursor (l_as)
			post_process_agent_routine_creation_as (l_as)
		end

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		do
			pre_process_inline_agent_creation_as (l_as)
			Precursor (l_as)
			post_process_inline_agent_creation_as (l_as)
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
		do
			pre_process_create_creation_as (l_as)
			Precursor (l_as)
			post_process_create_creation_as (l_as)
		end

	process_bang_creation_as (l_as: BANG_CREATION_AS)
		do
			pre_process_bang_creation_as (l_as)
			Precursor (l_as)
			post_process_bang_creation_as (l_as)
		end

	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS)
		do
			pre_process_create_creation_expr_as (l_as)
			Precursor (l_as)
			post_process_create_creation_expr_as (l_as)
		end

	process_bang_creation_expr_as (l_as: BANG_CREATION_EXPR_AS)
		do
			pre_process_bang_creation_expr_as (l_as)
			Precursor (l_as)
			post_process_bang_creation_expr_as (l_as)
		end

feature -- Roundtrip

	process_keyword_as (l_as: KEYWORD_AS)
		do
			pre_process_keyword_as (l_as)
			Precursor (l_as)
			post_process_keyword_as (l_as)
		end

	process_symbol_as (l_as: SYMBOL_AS)
		do
			pre_process_symbol_as (l_as)
			Precursor (l_as)
			post_process_symbol_as (l_as)
		end

	process_break_as (l_as: BREAK_AS)
		do
			pre_process_break_as (l_as)
			Precursor (l_as)
			post_process_break_as (l_as)
		end

	process_leaf_stub_as (l_as: LEAF_STUB_AS)
		do
			pre_process_leaf_stub_as (l_as)
			Precursor (l_as)
			post_process_leaf_stub_as (l_as)
		end

	process_symbol_stub_as (l_as: SYMBOL_STUB_AS)
		do
			pre_process_symbol_stub_as (l_as)
			Precursor (l_as)
			post_process_symbol_stub_as (l_as)
		end

	process_keyword_stub_as (l_as: KEYWORD_STUB_AS)
		do
			pre_process_keyword_stub_as (l_as)
			Precursor (l_as)
			post_process_keyword_stub_as (l_as)
		end

feature {AST_EIFFEL} -- Skeleton Visitors

	process_custom_attribute_as (l_as: CUSTOM_ATTRIBUTE_AS)
		do
			pre_process_custom_attribute_as (l_as)
			Precursor (l_as)
			post_process_custom_attribute_as (l_as)
		end

	process_id_as (l_as: ID_AS)
		do
			pre_process_id_as (l_as)
			Precursor (l_as)
			post_process_id_as (l_as)
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			pre_process_integer_as (l_as)
			Precursor (l_as)
			post_process_integer_as (l_as)
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			pre_process_static_access_as (l_as)
			Precursor (l_as)
			post_process_static_access_as (l_as)
		end

	process_feature_clause_as (l_as: FEATURE_CLAUSE_AS)
		do
			pre_process_feature_clause_as (l_as)
			Precursor (l_as)
			post_process_feature_clause_as (l_as)
		end

	process_unique_as (l_as: UNIQUE_AS)
		do
			pre_process_unique_as (l_as)
			Precursor (l_as)
			post_process_unique_as (l_as)
		end

	process_tuple_as (l_as: TUPLE_AS)
		do
			pre_process_tuple_as (l_as)
			Precursor (l_as)
			post_process_tuple_as (l_as)
		end

	process_real_as (l_as: REAL_AS)
		do
			pre_process_real_as (l_as)
			Precursor (l_as)
			post_process_real_as (l_as)
		end

	process_bool_as (l_as: BOOL_AS)
		do
			pre_process_bool_as (l_as)
			Precursor (l_as)
			post_process_bool_as (l_as)
		end

	process_array_as (l_as: ARRAY_AS)
		do
			pre_process_array_as (l_as)
			Precursor (l_as)
			post_process_array_as (l_as)
		end

	process_char_as (l_as: CHAR_AS)
		do
			pre_process_char_as (l_as)
			Precursor (l_as)
			post_process_char_as (l_as)
		end

	process_string_as (l_as: STRING_AS)
		do
			pre_process_string_as (l_as)
			Precursor (l_as)
			post_process_string_as (l_as)
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
		do
			pre_process_verbatim_string_as (l_as)
			Precursor (l_as)
			post_process_verbatim_string_as (l_as)
		end

	process_body_as (l_as: BODY_AS)
		do
			pre_process_body_as (l_as)
			Precursor (l_as)
			post_process_body_as (l_as)
		end

	process_built_in_as (l_as: BUILT_IN_AS)
		do
			pre_process_built_in_as (l_as)
			Precursor (l_as)
			post_process_built_in_as (l_as)
		end

	process_result_as (l_as: RESULT_AS)
		do
			pre_process_result_as (l_as)
			Precursor (l_as)
			post_process_result_as (l_as)
		end

	process_current_as (l_as: CURRENT_AS)
		do
			pre_process_current_as (l_as)
			Precursor (l_as)
			post_process_current_as (l_as)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			pre_process_access_feat_as (l_as)
			Precursor (l_as)
			post_process_access_feat_as (l_as)
		end

	process_access_inv_as (l_as: ACCESS_INV_AS)
		do
			pre_process_access_inv_as (l_as)
			Precursor (l_as)
			post_process_access_inv_as (l_as)
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			pre_process_access_id_as (l_as)
			Precursor (l_as)
			post_process_access_id_as (l_as)
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
		do
			pre_process_access_assert_as (l_as)
			Precursor (l_as)
			post_process_access_assert_as (l_as)
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		do
			pre_process_precursor_as (l_as)
			Precursor (l_as)
			post_process_precursor_as (l_as)
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			pre_process_nested_expr_as (l_as)
			Precursor (l_as)
			post_process_nested_expr_as (l_as)
		end

	process_nested_as (l_as: NESTED_AS)
		do
			pre_process_nested_as (l_as)
			Precursor (l_as)
			post_process_nested_as (l_as)
		end

	process_creation_expr_as (l_as: CREATION_EXPR_AS)
		do
			pre_process_creation_expr_as (l_as)
			Precursor (l_as)
			post_process_creation_expr_as (l_as)
		end

	process_routine_as (l_as: ROUTINE_AS)
		do
			pre_process_routine_as (l_as)
			Precursor (l_as)
			post_process_routine_as (l_as)
		end

	process_constant_as (l_as: CONSTANT_AS)
		do
			pre_process_constant_as (l_as)
			Precursor (l_as)
			post_process_constant_as (l_as)
		end

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
		do
			pre_process_eiffel_list (l_as)
			Precursor (l_as)
			post_process_eiffel_list (l_as)
		end

	process_indexing_clause_as (l_as: INDEXING_CLAUSE_AS)
		do
			pre_process_indexing_clause_as (l_as)
			Precursor (l_as)
			post_process_indexing_clause_as (l_as)
		end

	process_infix_prefix_as (l_as: INFIX_PREFIX_AS)
		do
			pre_process_infix_prefix_as (l_as)
			Precursor (l_as)
			post_process_infix_prefix_as (l_as)
		end

	process_feat_name_id_as (l_as: FEAT_NAME_ID_AS)
		do
			pre_process_feat_name_id_as (l_as)
			Precursor (l_as)
			post_process_feat_name_id_as (l_as)
		end

	process_feature_name_alias_as (l_as: FEATURE_NAME_ALIAS_AS)
		do
			pre_process_feature_name_alias_as (l_as)
			Precursor (l_as)
			post_process_feature_name_alias_as (l_as)
		end

	process_feature_list_as (l_as: FEATURE_LIST_AS)
		do
			pre_process_feature_list_as (l_as)
			Precursor (l_as)
			post_process_feature_list_as (l_as)
		end

	process_all_as (l_as: ALL_AS)
		do
			pre_process_all_as (l_as)
			Precursor (l_as)
			post_process_all_as (l_as)
		end

	process_attribute_as (l_as: ATTRIBUTE_AS)
		do
			pre_process_attribute_as (l_as)
			Precursor (l_as)
			post_process_attribute_as (l_as)
		end

	process_deferred_as (l_as: DEFERRED_AS)
		do
			pre_process_deferred_as (l_as)
			Precursor (l_as)
			post_process_deferred_as (l_as)
		end

	process_do_as (l_as: DO_AS)
		do
			pre_process_do_as (l_as)
			Precursor (l_as)
			post_process_do_as (l_as)
		end

	process_once_as (l_as: ONCE_AS)
		do
			pre_process_once_as (l_as)
			Precursor (l_as)
			post_process_once_as (l_as)
		end

	process_type_dec_as (l_as: TYPE_DEC_AS)
		do
			pre_process_type_dec_as (l_as)
			Precursor (l_as)
			post_process_type_dec_as (l_as)
		end

	process_parent_as (l_as: PARENT_AS)
		do
			pre_process_parent_as (l_as)
			Precursor (l_as)
			post_process_parent_as (l_as)
		end

	process_like_id_as (l_as: LIKE_ID_AS)
		do
			pre_process_like_id_as (l_as)
			Precursor (l_as)
			post_process_like_id_as (l_as)
		end

	process_like_cur_as (l_as: LIKE_CUR_AS)
		do
			pre_process_like_cur_as (l_as)
			Precursor (l_as)
			post_process_like_cur_as (l_as)
		end

	process_qualified_anchored_type_as (l_as: QUALIFIED_ANCHORED_TYPE_AS)
		do
			pre_process_qualified_anchored_type_as (l_as)
			Precursor (l_as)
			post_process_qualified_anchored_type_as (l_as)
		end

	process_formal_dec_as (l_as: FORMAL_DEC_AS)
		do
			pre_process_formal_dec_as (l_as)
			Precursor (l_as)
			post_process_formal_dec_as (l_as)
		end

	process_constraining_type_as (l_as: CONSTRAINING_TYPE_AS)
		do
			pre_process_constraining_type_as (l_as)
			Precursor (l_as)
			post_process_constraining_type_as (l_as)
		end

	process_none_type_as (l_as: NONE_TYPE_AS)
		do
			pre_process_none_type_as (l_as)
			Precursor (l_as)
			post_process_none_type_as (l_as)
		end

	process_rename_as (l_as: RENAME_AS)
		do
			pre_process_rename_as (l_as)
			Precursor (l_as)
			post_process_rename_as (l_as)
		end

	process_invariant_as (l_as: INVARIANT_AS)
		do
			pre_process_invariant_as (l_as)
			Precursor (l_as)
			post_process_invariant_as (l_as)
		end

	process_index_as (l_as: INDEX_AS)
		do
			pre_process_index_as (l_as)
			Precursor (l_as)
			post_process_index_as (l_as)
		end

	process_export_item_as (l_as: EXPORT_ITEM_AS)
		do
			pre_process_export_item_as (l_as)
			Precursor (l_as)
			post_process_export_item_as (l_as)
		end

	process_create_as (l_as: CREATE_AS)
		do
			pre_process_create_as (l_as)
			Precursor (l_as)
			post_process_create_as (l_as)
		end

	process_client_as (l_as: CLIENT_AS)
		do
			pre_process_client_as (l_as)
			Precursor (l_as)
			post_process_client_as (l_as)
		end

	process_ensure_as (l_as: ENSURE_AS)
		do
			pre_process_ensure_as (l_as)
			Precursor (l_as)
			post_process_ensure_as (l_as)
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS)
		do
			pre_process_ensure_then_as (l_as)
			Precursor (l_as)
			post_process_ensure_then_as (l_as)
		end

	process_require_as (l_as: REQUIRE_AS)
		do
			pre_process_require_as (l_as)
			Precursor (l_as)
			post_process_require_as (l_as)
		end

	process_require_else_as (l_as: REQUIRE_ELSE_AS)
		do
			pre_process_require_else_as (l_as)
			Precursor (l_as)
			post_process_require_else_as (l_as)
		end

	process_convert_feat_as (l_as: CONVERT_FEAT_AS)
		do
			pre_process_convert_feat_as (l_as)
			Precursor (l_as)
			post_process_convert_feat_as (l_as)
		end

	process_convert_feat_list_as (l_as: CONVERT_FEAT_LIST_AS)
		do
			pre_process_convert_feat_list_as (l_as)
			Precursor (l_as)
			post_process_convert_feat_list_as (l_as)
		end

	process_class_list_as (l_as: CLASS_LIST_AS)
		do
			pre_process_class_list_as (l_as)
			Precursor (l_as)
			post_process_class_list_as (l_as)
		end

	process_parent_list_as (l_as: PARENT_LIST_AS)
		do
			pre_process_parent_list_as (l_as)
			Precursor (l_as)
			post_process_parent_list_as (l_as)
		end

	process_local_dec_list_as (l_as: LOCAL_DEC_LIST_AS)
		do
			pre_process_local_dec_list_as (l_as)
			Precursor (l_as)
			post_process_local_dec_list_as (l_as)
		end

	process_formal_argu_dec_list_as (l_as: FORMAL_ARGU_DEC_LIST_AS)
		do
			pre_process_formal_argu_dec_list_as (l_as)
			Precursor (l_as)
			post_process_formal_argu_dec_list_as (l_as)
		end

	process_key_list_as (l_as: KEY_LIST_AS)
		do
			pre_process_key_list_as (l_as)
			Precursor (l_as)
			post_process_key_list_as (l_as)
		end

	process_delayed_actual_list_as (l_as: DELAYED_ACTUAL_LIST_AS)
		do
			pre_process_delayed_actual_list_as (l_as)
			Precursor (l_as)
			post_process_delayed_actual_list_as (l_as)
		end

	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
		do
			pre_process_parameter_list_as (l_as)
			Precursor (l_as)
			post_process_parameter_list_as (l_as)
		end

	process_rename_clause_as (l_as: RENAME_CLAUSE_AS)
		do
			pre_process_rename_clause_as (l_as)
			Precursor (l_as)
			post_process_rename_clause_as (l_as)
		end

	process_export_clause_as (l_as: EXPORT_CLAUSE_AS)
		do
			pre_process_export_clause_as (l_as)
			Precursor (l_as)
			post_process_export_clause_as (l_as)
		end

	process_undefine_clause_as (l_as: UNDEFINE_CLAUSE_AS)
		do
			pre_process_undefine_clause_as (l_as)
			Precursor (l_as)
			post_process_undefine_clause_as (l_as)
		end

	process_redefine_clause_as (l_as: REDEFINE_CLAUSE_AS)
		do
			pre_process_redefine_clause_as (l_as)
			Precursor (l_as)
			post_process_redefine_clause_as (l_as)
		end

	process_select_clause_as (l_as: SELECT_CLAUSE_AS)
		do
			pre_process_select_clause_as (l_as)
			Precursor (l_as)
			post_process_select_clause_as (l_as)
		end

	process_formal_generic_list_as (l_as: FORMAL_GENERIC_LIST_AS)
		do
			pre_process_formal_generic_list_as (l_as)
			Precursor (l_as)
			post_process_formal_generic_list_as (l_as)
		end

	process_iteration_as (l_as: ITERATION_AS)
		do
			pre_process_iteration_as (l_as)
			Precursor (l_as)
			post_process_iteration_as (l_as)
		end

feature {AST_EIFFEL} -- Expressions visitors

	process_tagged_as (l_as: TAGGED_AS)
		do
			pre_process_tagged_as (l_as)
			Precursor (l_as)
			post_process_tagged_as (l_as)
		end

	process_variant_as (l_as: VARIANT_AS)
		do
			pre_process_variant_as (l_as)
			Precursor (l_as)
			post_process_variant_as (l_as)
		end

	process_un_strip_as (l_as: UN_STRIP_AS)
		do
			pre_process_un_strip_as (l_as)
			Precursor (l_as)
			post_process_un_strip_as (l_as)
		end

	process_converted_expr_as (l_as: CONVERTED_EXPR_AS)
		do
			pre_process_converted_expr_as (l_as)
			Precursor (l_as)
			post_process_converted_expr_as (l_as)
		end

	process_paran_as (l_as: PARAN_AS)
		do
			pre_process_paran_as (l_as)
			Precursor (l_as)
			post_process_paran_as (l_as)
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			pre_process_expr_call_as (l_as)
			Precursor (l_as)
			post_process_expr_call_as (l_as)
		end

	process_expr_address_as (l_as: EXPR_ADDRESS_AS)
		do
			pre_process_expr_address_as (l_as)
			Precursor (l_as)
			post_process_expr_address_as (l_as)
		end

	process_address_result_as (l_as: ADDRESS_RESULT_AS)
		do
			pre_process_address_result_as (l_as)
			Precursor (l_as)
			post_process_address_result_as (l_as)
		end

	process_address_current_as (l_as: ADDRESS_CURRENT_AS)
		do
			pre_process_address_current_as (l_as)
			Precursor (l_as)
			post_process_address_current_as (l_as)
		end

	process_address_as (l_as: ADDRESS_AS)
		do
			pre_process_address_as (l_as)
			Precursor (l_as)
			post_process_address_as (l_as)
		end

	process_type_expr_as (l_as: TYPE_EXPR_AS)
		do
			pre_process_type_expr_as (l_as)
			Precursor (l_as)
			post_process_type_expr_as (l_as)
		end

	process_routine_creation_as (l_as: ROUTINE_CREATION_AS)
		do
			pre_process_routine_creation_as (l_as)
			Precursor (l_as)
			post_process_routine_creation_as (l_as)
		end

	process_un_free_as (l_as: UN_FREE_AS)
		do
			pre_process_un_free_as (l_as)
			Precursor (l_as)
			post_process_un_free_as (l_as)
		end

	process_un_minus_as (l_as: UN_MINUS_AS)
		do
			pre_process_un_minus_as (l_as)
			Precursor (l_as)
			post_process_un_minus_as (l_as)
		end

	process_un_not_as (l_as: UN_NOT_AS)
		do
			pre_process_un_not_as (l_as)
			Precursor (l_as)
			post_process_un_not_as (l_as)
		end

	process_un_old_as (l_as: UN_OLD_AS)
		do
			pre_process_un_old_as (l_as)
			Precursor (l_as)
			post_process_un_old_as (l_as)
		end

	process_un_plus_as (l_as: UN_PLUS_AS)
		do
			pre_process_un_plus_as (l_as)
			Precursor (l_as)
			post_process_un_plus_as (l_as)
		end

	process_bin_and_then_as (l_as: BIN_AND_THEN_AS)
		do
			pre_process_bin_and_then_as (l_as)
			Precursor (l_as)
			post_process_bin_and_then_as (l_as)
		end

	process_bin_free_as (l_as: BIN_FREE_AS)
		do
			pre_process_bin_free_as (l_as)
			Precursor (l_as)
			post_process_bin_free_as (l_as)
		end

	process_bin_implies_as (l_as: BIN_IMPLIES_AS)
		do
			pre_process_bin_implies_as (l_as)
			Precursor (l_as)
			post_process_bin_implies_as (l_as)
		end

	process_bin_or_as (l_as: BIN_OR_AS)
		do
			pre_process_bin_or_as (l_as)
			Precursor (l_as)
			post_process_bin_or_as (l_as)
		end

	process_bin_or_else_as (l_as: BIN_OR_ELSE_AS)
		do
			pre_process_bin_or_else_as (l_as)
			Precursor (l_as)
			post_process_bin_or_else_as (l_as)
		end

	process_bin_xor_as (l_as: BIN_XOR_AS)
		do
			pre_process_bin_xor_as (l_as)
			Precursor (l_as)
			post_process_bin_xor_as (l_as)
		end

	process_bin_ge_as (l_as: BIN_GE_AS)
		do
			pre_process_bin_ge_as (l_as)
			Precursor (l_as)
			post_process_bin_ge_as (l_as)
		end

	process_bin_gt_as (l_as: BIN_GT_AS)
		do
			pre_process_bin_gt_as (l_as)
			Precursor (l_as)
			post_process_bin_gt_as (l_as)
		end

	process_bin_le_as (l_as: BIN_LE_AS)
		do
			pre_process_bin_le_as (l_as)
			Precursor (l_as)
			post_process_bin_le_as (l_as)
		end

	process_bin_lt_as (l_as: BIN_LT_AS)
		do
			pre_process_bin_lt_as (l_as)
			Precursor (l_as)
			post_process_bin_lt_as (l_as)
		end

	process_bin_div_as (l_as: BIN_DIV_AS)
		do
			pre_process_bin_div_as (l_as)
			Precursor (l_as)
			post_process_bin_div_as (l_as)
		end

	process_bin_minus_as (l_as: BIN_MINUS_AS)
		do
			pre_process_bin_minus_as (l_as)
			Precursor (l_as)
			post_process_bin_minus_as (l_as)
		end

	process_bin_mod_as (l_as: BIN_MOD_AS)
		do
			pre_process_bin_mod_as (l_as)
			Precursor (l_as)
			post_process_bin_mod_as (l_as)
		end

	process_bin_plus_as (l_as: BIN_PLUS_AS)
		do
			pre_process_bin_plus_as (l_as)
			Precursor (l_as)
			post_process_bin_plus_as (l_as)
		end

	process_bin_power_as (l_as: BIN_POWER_AS)
		do
			pre_process_bin_power_as (l_as)
			Precursor (l_as)
			post_process_bin_power_as (l_as)
		end

	process_bin_slash_as (l_as: BIN_SLASH_AS)
		do
			pre_process_bin_slash_as (l_as)
			Precursor (l_as)
			post_process_bin_slash_as (l_as)
		end

	process_bin_star_as (l_as: BIN_STAR_AS)
		do
			pre_process_bin_star_as (l_as)
			Precursor (l_as)
			post_process_bin_star_as (l_as)
		end

	process_bin_and_as (l_as: BIN_AND_AS)
		do
			pre_process_bin_and_as (l_as)
			Precursor (l_as)
			post_process_bin_and_as (l_as)
		end

	process_bin_eq_as (l_as: BIN_EQ_AS)
		do
			pre_process_bin_eq_as (l_as)
			Precursor (l_as)
			post_process_bin_eq_as (l_as)
		end

	process_bin_ne_as (l_as: BIN_NE_AS)
		do
			pre_process_bin_ne_as (l_as)
			Precursor (l_as)
			post_process_bin_ne_as (l_as)
		end

	process_bin_tilde_as (l_as: BIN_TILDE_AS)
		do
			pre_process_bin_tilde_as (l_as)
			Precursor (l_as)
			post_process_bin_tilde_as (l_as)
		end

	process_bin_not_tilde_as (l_as: BIN_NOT_TILDE_AS)
		do
			pre_process_bin_not_tilde_as (l_as)
			Precursor (l_as)
			post_process_bin_not_tilde_as (l_as)
		end

	process_bracket_as (l_as: BRACKET_AS)
		do
			pre_process_bracket_as (l_as)
			Precursor (l_as)
			post_process_bracket_as (l_as)
		end

	process_operand_as (l_as: OPERAND_AS)
		do
			pre_process_operand_as (l_as)
			Precursor (l_as)
			post_process_operand_as (l_as)
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			pre_process_object_test_as (l_as)
			Precursor (l_as)
			post_process_object_test_as (l_as)
		end

	process_loop_expr_as (l_as: LOOP_EXPR_AS)
		do
			pre_process_loop_expr_as (l_as)
			Precursor (l_as)
			post_process_loop_expr_as (l_as)
		end

	process_void_as (l_as: VOID_AS)
		do
			pre_process_void_as (l_as)
			Precursor (l_as)
			post_process_void_as (l_as)
		end

	process_unary_as (l_as: UNARY_AS)
		do
			pre_process_unary_as (l_as)
			Precursor (l_as)
			post_process_unary_as (l_as)
		end

	process_binary_as (l_as: BINARY_AS)
		do
			pre_process_binary_as (l_as)
			Precursor (l_as)
			post_process_binary_as (l_as)
		end

feature {AST_EIFFEL} -- Instructions visitors

	process_elseif_as (l_as: ELSIF_AS)
		do
			pre_process_elseif_as (l_as)
			Precursor (l_as)
			post_process_elseif_as (l_as)
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			pre_process_assign_as (l_as)
			Precursor (l_as)
			post_process_assign_as (l_as)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			pre_process_assigner_call_as (l_as)
			Precursor (l_as)
			post_process_assigner_call_as (l_as)
		end

	process_case_as (l_as: CASE_AS)
		do
			pre_process_case_as (l_as)
			Precursor (l_as)
			post_process_case_as (l_as)
		end

	process_check_as (l_as: CHECK_AS)
		do
			pre_process_check_as (l_as)
			Precursor (l_as)
			post_process_check_as (l_as)
		end

	process_creation_as (l_as: CREATION_AS)
		do
			pre_process_creation_as (l_as)
			Precursor (l_as)
			post_process_creation_as (l_as)
		end

	process_debug_as (l_as: DEBUG_AS)
		do
			pre_process_debug_as (l_as)
			Precursor (l_as)
			post_process_debug_as (l_as)
		end

	process_guard_as (l_as: GUARD_AS)
		do
			pre_process_guard_as (l_as)
			Precursor (l_as)
			post_process_guard_as (l_as)
		end

	process_if_as (l_as: IF_AS)
		do
			pre_process_if_as (l_as)
			Precursor (l_as)
			post_process_if_as (l_as)
		end

	process_inspect_as (l_as: INSPECT_AS)
		do
			pre_process_inspect_as (l_as)
			Precursor (l_as)
			post_process_inspect_as (l_as)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			pre_process_instr_call_as (l_as)
			Precursor (l_as)
			post_process_instr_call_as (l_as)
		end

	process_interval_as (l_as: INTERVAL_AS)
		do
			pre_process_interval_as (l_as)
			Precursor (l_as)
			post_process_interval_as (l_as)
		end

	process_loop_as (l_as: LOOP_AS)
		do
			pre_process_loop_as (l_as)
			Precursor (l_as)
			post_process_loop_as (l_as)
		end

	process_retry_as (l_as: RETRY_AS)
		do
			pre_process_retry_as (l_as)
			Precursor (l_as)
			post_process_retry_as (l_as)
		end

	process_reverse_as (l_as: REVERSE_AS)
		do
			pre_process_reverse_as (l_as)
			Precursor (l_as)
			post_process_reverse_as (l_as)
		end

feature {AST_EIFFEL} -- External visitors

	process_external_as (l_as: EXTERNAL_AS)
		do
			pre_process_external_as (l_as)
			Precursor (l_as)
			post_process_external_as (l_as)
		end

	process_external_lang_as (l_as: EXTERNAL_LANG_AS)
		do
			pre_process_external_lang_as (l_as)
			Precursor (l_as)
			post_process_external_lang_as (l_as)
		end

feature {AST_EIFFEL} -- Clickable visitor

	process_class_as (l_as: CLASS_AS)
		do
			pre_process_class_as (l_as)
			Precursor (l_as)
			post_process_class_as (l_as)
		end

	process_class_type_as (l_as: CLASS_TYPE_AS)
		do
			pre_process_class_type_as (l_as)
			Precursor (l_as)
			post_process_class_type_as (l_as)
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS)
		do
			pre_process_generic_class_type_as (l_as)
			Precursor (l_as)
			post_process_generic_class_type_as (l_as)
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS)
		do
			pre_process_named_tuple_type_as (l_as)
			Precursor (l_as)
			post_process_named_tuple_type_as (l_as)
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			pre_process_feature_as (l_as)
			Precursor (l_as)
			post_process_feature_as (l_as)
		end

	process_formal_as (l_as: FORMAL_AS)
		do
			pre_process_formal_as (l_as)
			Precursor (l_as)
			post_process_formal_as (l_as)
		end

	process_type_list_as (l_as: TYPE_LIST_AS)
		do
			pre_process_type_list_as (l_as)
			Precursor (l_as)
			post_process_type_list_as (l_as)
		end

	process_type_dec_list_as (l_as: TYPE_DEC_LIST_AS)
		do
			pre_process_type_dec_list_as (l_as)
			Precursor (l_as)
			post_process_type_dec_list_as (l_as)
		end

feature -- Quantification

	process_there_exists_as (l_as: THERE_EXISTS_AS)
		do
			pre_process_there_exists_as (l_as)
			Precursor (l_as)
			post_process_there_exists_as (l_as)
		end

	process_for_all_as (l_as: FOR_ALL_AS)
		do
			pre_process_for_all_as (l_as)
			Precursor (l_as)
			post_process_for_all_as (l_as)
		end

end
