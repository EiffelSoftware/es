note
	description: "An iterator to go through all the nodes of an AST and print struture and content information."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_PRINTER

inherit
	EPA_AST_ITERATOR_WITH_HOOKS
		redefine
			pre_process_access_assert_as,
			pre_process_access_feat_as,
			pre_process_access_id_as,
			pre_process_access_inv_as,
			pre_process_address_as,
			pre_process_address_current_as,
			pre_process_address_result_as,
			pre_process_agent_routine_creation_as,
			pre_process_all_as,
			pre_process_array_as,
			pre_process_assign_as,
			pre_process_assigner_call_as,
			pre_process_attribute_as,
			pre_process_bang_creation_as,
			pre_process_bang_creation_expr_as,
			pre_process_bin_and_as,
			pre_process_bin_and_then_as,
			pre_process_bin_div_as,
			pre_process_bin_eq_as,
			pre_process_bin_free_as,
			pre_process_bin_ge_as,
			pre_process_bin_gt_as,
			pre_process_bin_implies_as,
			pre_process_bin_le_as,
			pre_process_bin_lt_as,
			pre_process_bin_minus_as,
			pre_process_bin_mod_as,
			pre_process_bin_ne_as,
			pre_process_bin_not_tilde_as,
			pre_process_bin_or_as,
			pre_process_bin_or_else_as,
			pre_process_bin_plus_as,
			pre_process_bin_power_as,
			pre_process_bin_slash_as,
			pre_process_bin_star_as,
			pre_process_bin_tilde_as,
			pre_process_bin_xor_as,
			pre_process_binary_as,
			pre_process_body_as,
			pre_process_bool_as,
			pre_process_bracket_as,
			pre_process_break_as,
			pre_process_built_in_as,
			pre_process_case_as,
			pre_process_char_as,
			pre_process_check_as,
			pre_process_class_as,
			pre_process_class_list_as,
			pre_process_class_type_as,
			pre_process_client_as,
			pre_process_constant_as,
			pre_process_constraining_type_as,
			pre_process_convert_feat_as,
			pre_process_convert_feat_list_as,
			pre_process_converted_expr_as,
			pre_process_create_as,
			pre_process_create_creation_as,
			pre_process_create_creation_expr_as,
			pre_process_creation_as,
			pre_process_creation_expr_as,
			pre_process_current_as,
			pre_process_custom_attribute_as,
			pre_process_debug_as,
			pre_process_deferred_as,
			pre_process_delayed_actual_list_as,
			pre_process_do_as,
			pre_process_eiffel_list,
			pre_process_elseif_as,
			pre_process_ensure_as,
			pre_process_ensure_then_as,
			pre_process_export_clause_as,
			pre_process_export_item_as,
			pre_process_expr_address_as,
			pre_process_expr_call_as,
			pre_process_external_as,
			pre_process_external_lang_as,
			pre_process_feat_name_id_as,
			pre_process_feature_as,
			pre_process_feature_clause_as,
			pre_process_feature_list_as,
			pre_process_feature_name_alias_as,
			pre_process_for_all_as,
			pre_process_formal_argu_dec_list_as,
			pre_process_formal_as,
			pre_process_formal_dec_as,
			pre_process_formal_generic_list_as,
			pre_process_generic_class_type_as,
			pre_process_guard_as,
			pre_process_id_as,
			pre_process_if_as,
			pre_process_index_as,
			pre_process_indexing_clause_as,
			pre_process_infix_prefix_as,
			pre_process_inline_agent_creation_as,
			pre_process_inspect_as,
			pre_process_instr_call_as,
			pre_process_integer_as,
			pre_process_interval_as,
			pre_process_invariant_as,
			pre_process_iteration_as,
			pre_process_key_list_as,
			pre_process_keyword_as,
			pre_process_keyword_stub_as,
			pre_process_leaf_stub_as,
			pre_process_like_cur_as,
			pre_process_like_id_as,
			pre_process_local_dec_list_as,
			pre_process_loop_as,
			pre_process_loop_expr_as,
			pre_process_named_tuple_type_as,
			pre_process_nested_as,
			pre_process_nested_expr_as,
			pre_process_none_id_as,
			pre_process_none_type_as,
			pre_process_object_test_as,
			pre_process_once_as,
			pre_process_operand_as,
			pre_process_parameter_list_as,
			pre_process_paran_as,
			pre_process_parent_as,
			pre_process_parent_list_as,
			pre_process_precursor_as,
			pre_process_qualified_anchored_type_as,
			pre_process_real_as,
			pre_process_redefine_clause_as,
			pre_process_rename_as,
			pre_process_rename_clause_as,
			pre_process_require_as,
			pre_process_require_else_as,
			pre_process_result_as,
			pre_process_retry_as,
			pre_process_reverse_as,
			pre_process_routine_as,
			pre_process_routine_creation_as,
			pre_process_select_clause_as,
			pre_process_static_access_as,
			pre_process_string_as,
			pre_process_symbol_as,
			pre_process_symbol_stub_as,
			pre_process_tagged_as,
			pre_process_there_exists_as,
			pre_process_tuple_as,
			pre_process_type_dec_as,
			pre_process_type_dec_list_as,
			pre_process_type_expr_as,
			pre_process_type_list_as,
			pre_process_typed_char_as,
			pre_process_un_free_as,
			pre_process_un_minus_as,
			pre_process_un_not_as,
			pre_process_un_old_as,
			pre_process_un_plus_as,
			pre_process_un_strip_as,
			pre_process_unary_as,
			pre_process_undefine_clause_as,
			pre_process_unique_as,
			pre_process_variant_as,
			pre_process_verbatim_string_as,
			pre_process_void_as
		end

	EXT_SHARED_LOGGER

feature -- Roundtrip

	pre_process_none_id_as (l_as: NONE_ID_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("none_id_as")
			log.put_string ("%N")
		end

	pre_process_typed_char_as (l_as: TYPED_CHAR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("typed_char_as")
			log.put_string ("%N")
		end

	pre_process_agent_routine_creation_as (l_as: AGENT_ROUTINE_CREATION_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("agent_routine_creation_as")
			log.put_string ("%N")
		end

	pre_process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("inline_agent_creation_as")
			log.put_string ("%N")
		end

	pre_process_create_creation_as (l_as: CREATE_CREATION_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("create_creation_as: " + l_as.target.access_name_8 + "." + l_as.call.access_name_8)
			log.put_string ("%N")
		end

	pre_process_bang_creation_as (l_as: BANG_CREATION_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bang_creation_as")
			log.put_string ("%N")
		end

	pre_process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("create_creation_expr_as")
			log.put_string ("%N")
		end

	pre_process_bang_creation_expr_as (l_as: BANG_CREATION_EXPR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bang_creation_expr_as")
			log.put_string ("%N")
		end

feature -- Roundtrip

	pre_process_keyword_as (l_as: KEYWORD_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("keyword_as")
			log.put_string ("%N")
		end

	pre_process_symbol_as (l_as: SYMBOL_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("symbol_as")
			log.put_string ("%N")
		end

	pre_process_break_as (l_as: BREAK_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("break_as")
			log.put_string ("%N")
		end

	pre_process_leaf_stub_as (l_as: LEAF_STUB_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("leaf_stub_as")
			log.put_string ("%N")
		end

	pre_process_symbol_stub_as (l_as: SYMBOL_STUB_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("symbol_stub_as")
			log.put_string ("%N")
		end

	pre_process_keyword_stub_as (l_as: KEYWORD_STUB_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("keyword_stub_as")
			log.put_string ("%N")
		end

feature {AST_EIFFEL} -- Helpers

	safe_print_ast_path_prefix (l_as: AST_EIFFEL)
		do
			if attached l_as.path as l_path then
				log.put_string ("[" + l_path.as_string + "]        ")
			else
				log.put_string ("[UNKNOWN_AST_PATH]        ")
			end
		end

feature {AST_EIFFEL} -- Skeleton Visitors

	pre_process_custom_attribute_as (l_as: CUSTOM_ATTRIBUTE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("custom_attribute_as")
			log.put_string ("%N")
		end

	pre_process_id_as (l_as: ID_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("id_as")
			log.put_string ("%N")
		end

	pre_process_integer_as (l_as: INTEGER_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("integer_as")
			log.put_string ("%N")
		end

	pre_process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("static_access_as")
			log.put_string ("%N")
		end

	pre_process_feature_clause_as (l_as: FEATURE_CLAUSE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("feature_clause_as")
			log.put_string ("%N")
		end

	pre_process_unique_as (l_as: UNIQUE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("unique_as")
			log.put_string ("%N")
		end

	pre_process_tuple_as (l_as: TUPLE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("tuple_as")
			log.put_string ("%N")
		end

	pre_process_real_as (l_as: REAL_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("real_as")
			log.put_string ("%N")
		end

	pre_process_bool_as (l_as: BOOL_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bool_as")
			log.put_string ("%N")
		end

	pre_process_array_as (l_as: ARRAY_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("array_as")
			log.put_string ("%N")
		end

	pre_process_char_as (l_as: CHAR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("char_as")
			log.put_string ("%N")
		end

	pre_process_string_as (l_as: STRING_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("string_as")
			log.put_string ("%N")
		end

	pre_process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("verbatim_string_as")
			log.put_string ("%N")
		end

	pre_process_body_as (l_as: BODY_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("body_as")
			log.put_string ("%N")
		end

	pre_process_built_in_as (l_as: BUILT_IN_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("built_in_as")
			log.put_string ("%N")
		end

	pre_process_result_as (l_as: RESULT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("result_as: " + l_as.access_name_8)
			log.put_string ("%N")
		end

	pre_process_current_as (l_as: CURRENT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("current_as")
			log.put_string ("%N")
		end

	pre_process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("access_feat_as: " + l_as.access_name_8)
			log.put_string ("%N")
		end

	pre_process_access_inv_as (l_as: ACCESS_INV_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("access_inv_as")
			log.put_string ("%N")
		end

	pre_process_access_id_as (l_as: ACCESS_ID_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("access_id_as: " + l_as.access_name_8)
			log.put_string ("%N")
		end

	pre_process_access_assert_as (l_as: ACCESS_ASSERT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("access_assert_as")
			log.put_string ("%N")
		end

	pre_process_precursor_as (l_as: PRECURSOR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("precursor_as")
			log.put_string ("%N")
		end

	pre_process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("nested_expr_as")
			log.put_string ("%N")
		end

	pre_process_nested_as (l_as: NESTED_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("nested_as")
			log.put_string ("%N")
		end

	pre_process_creation_expr_as (l_as: CREATION_EXPR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("creation_expr_as")
			log.put_string ("%N")
		end

	pre_process_routine_as (l_as: ROUTINE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("routine_as")
			log.put_string ("%N")
		end

	pre_process_constant_as (l_as: CONSTANT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("constant_as")
			log.put_string ("%N")
		end

	pre_process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("eiffel_list")
			log.put_string ("%N")
		end

	pre_process_indexing_clause_as (l_as: INDEXING_CLAUSE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("indexing_clause_as")
			log.put_string ("%N")
		end

	pre_process_infix_prefix_as (l_as: INFIX_PREFIX_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("infix_prefix_as")
			log.put_string ("%N")
		end

	pre_process_feat_name_id_as (l_as: FEAT_NAME_ID_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("feat_name_id_as")
			log.put_string ("%N")
		end

	pre_process_feature_name_alias_as (l_as: FEATURE_NAME_ALIAS_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("feature_name_alias_as")
			log.put_string ("%N")
		end

	pre_process_feature_list_as (l_as: FEATURE_LIST_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("feature_list_as")
			log.put_string ("%N")
		end

	pre_process_all_as (l_as: ALL_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("all_as")
			log.put_string ("%N")
		end

	pre_process_attribute_as (l_as: ATTRIBUTE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("attribute_as")
			log.put_string ("%N")
		end

	pre_process_deferred_as (l_as: DEFERRED_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("deferred_as")
			log.put_string ("%N")
		end

	pre_process_do_as (l_as: DO_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("do_as")
			log.put_string ("%N")
		end

	pre_process_once_as (l_as: ONCE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("once_as")
			log.put_string ("%N")
		end

	pre_process_type_dec_as (l_as: TYPE_DEC_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("type_dec_as")
			log.put_string ("%N")
		end

	pre_process_parent_as (l_as: PARENT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("parent_as")
			log.put_string ("%N")
		end

	pre_process_like_id_as (l_as: LIKE_ID_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("like_id_as")
			log.put_string ("%N")
		end

	pre_process_like_cur_as (l_as: LIKE_CUR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("like_cur_as")
			log.put_string ("%N")
		end

	pre_process_qualified_anchored_type_as (l_as: QUALIFIED_ANCHORED_TYPE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("qualified_anchored_type_as")
			log.put_string ("%N")
		end

	pre_process_formal_dec_as (l_as: FORMAL_DEC_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("formal_dec_as")
			log.put_string ("%N")
		end

	pre_process_constraining_type_as (l_as: CONSTRAINING_TYPE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("constraining_type_as")
			log.put_string ("%N")
		end

	pre_process_none_type_as (l_as: NONE_TYPE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("none_type_as")
			log.put_string ("%N")
		end

	pre_process_rename_as (l_as: RENAME_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("rename_as")
			log.put_string ("%N")
		end

	pre_process_invariant_as (l_as: INVARIANT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("invariant_as")
			log.put_string ("%N")
		end

	pre_process_index_as (l_as: INDEX_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("index_as")
			log.put_string ("%N")
		end

	pre_process_export_item_as (l_as: EXPORT_ITEM_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("export_item_as")
			log.put_string ("%N")
		end

	pre_process_create_as (l_as: CREATE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("create_as")
			log.put_string ("%N")
		end

	pre_process_client_as (l_as: CLIENT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("client_as")
			log.put_string ("%N")
		end

	pre_process_ensure_as (l_as: ENSURE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("ensure_as")
			log.put_string ("%N")
		end

	pre_process_ensure_then_as (l_as: ENSURE_THEN_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("ensure_then_as")
			log.put_string ("%N")
		end

	pre_process_require_as (l_as: REQUIRE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("require_as")
			log.put_string ("%N")
		end

	pre_process_require_else_as (l_as: REQUIRE_ELSE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("require_else_as")
			log.put_string ("%N")
		end

	pre_process_convert_feat_as (l_as: CONVERT_FEAT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("convert_feat_as")
			log.put_string ("%N")
		end

	pre_process_convert_feat_list_as (l_as: CONVERT_FEAT_LIST_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("convert_feat_list_as")
			log.put_string ("%N")
		end

	pre_process_class_list_as (l_as: CLASS_LIST_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("class_list_as")
			log.put_string ("%N")
		end

	pre_process_parent_list_as (l_as: PARENT_LIST_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("parent_list_as")
			log.put_string ("%N")
		end

	pre_process_local_dec_list_as (l_as: LOCAL_DEC_LIST_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("local_dec_list_as")
			log.put_string ("%N")
		end

	pre_process_formal_argu_dec_list_as (l_as: FORMAL_ARGU_DEC_LIST_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("formal_argu_dec_list_as")
			log.put_string ("%N")
		end

	pre_process_key_list_as (l_as: KEY_LIST_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("key_list_as")
			log.put_string ("%N")
		end

	pre_process_delayed_actual_list_as (l_as: DELAYED_ACTUAL_LIST_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("delayed_actual_list_as")
			log.put_string ("%N")
		end

	pre_process_parameter_list_as (l_as: PARAMETER_LIST_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("parameter_list_as")
			log.put_string ("%N")
		end

	pre_process_rename_clause_as (l_as: RENAME_CLAUSE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("rename_clause_as")
			log.put_string ("%N")
		end

	pre_process_export_clause_as (l_as: EXPORT_CLAUSE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("export_clause_as")
			log.put_string ("%N")
		end

	pre_process_undefine_clause_as (l_as: UNDEFINE_CLAUSE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("undefine_clause_as")
			log.put_string ("%N")
		end

	pre_process_redefine_clause_as (l_as: REDEFINE_CLAUSE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("redefine_clause_as")
			log.put_string ("%N")
		end

	pre_process_select_clause_as (l_as: SELECT_CLAUSE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("select_clause_as")
			log.put_string ("%N")
		end

	pre_process_formal_generic_list_as (l_as: FORMAL_GENERIC_LIST_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("formal_generic_list_as")
			log.put_string ("%N")
		end

	pre_process_iteration_as (l_as: ITERATION_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("iteration_as")
			log.put_string ("%N")
		end

feature {AST_EIFFEL} -- Expressions visitors

	pre_process_tagged_as (l_as: TAGGED_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("tagged_as")
			log.put_string ("%N")
		end

	pre_process_variant_as (l_as: VARIANT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("variant_as")
			log.put_string ("%N")
		end

	pre_process_un_strip_as (l_as: UN_STRIP_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("un_strip_as")
			log.put_string ("%N")
		end

	pre_process_converted_expr_as (l_as: CONVERTED_EXPR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("converted_expr_as")
			log.put_string ("%N")
		end

	pre_process_paran_as (l_as: PARAN_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("paran_as")
			log.put_string ("%N")
		end

	pre_process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("expr_call_as")
			log.put_string ("%N")
		end

	pre_process_expr_address_as (l_as: EXPR_ADDRESS_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("expr_address_as")
			log.put_string ("%N")
		end

	pre_process_address_result_as (l_as: ADDRESS_RESULT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("address_result_as")
			log.put_string ("%N")
		end

	pre_process_address_current_as (l_as: ADDRESS_CURRENT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("address_current_as")
			log.put_string ("%N")
		end

	pre_process_address_as (l_as: ADDRESS_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("address_as")
			log.put_string ("%N")
		end

	pre_process_type_expr_as (l_as: TYPE_EXPR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("type_expr_as")
			log.put_string ("%N")
		end

	pre_process_routine_creation_as (l_as: ROUTINE_CREATION_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("routine_creation_as")
			log.put_string ("%N")
		end

	pre_process_un_free_as (l_as: UN_FREE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("un_free_as")
			log.put_string ("%N")
		end

	pre_process_un_minus_as (l_as: UN_MINUS_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("un_minus_as")
			log.put_string ("%N")
		end

	pre_process_un_not_as (l_as: UN_NOT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("un_not_as")
			log.put_string ("%N")
		end

	pre_process_un_old_as (l_as: UN_OLD_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("un_old_as")
			log.put_string ("%N")
		end

	pre_process_un_plus_as (l_as: UN_PLUS_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("un_plus_as")
			log.put_string ("%N")
		end

	pre_process_bin_and_then_as (l_as: BIN_AND_THEN_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_and_then_as")
			log.put_string ("%N")
		end

	pre_process_bin_free_as (l_as: BIN_FREE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_free_as")
			log.put_string ("%N")
		end

	pre_process_bin_implies_as (l_as: BIN_IMPLIES_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_implies_as")
			log.put_string ("%N")
		end

	pre_process_bin_or_as (l_as: BIN_OR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_or_as")
			log.put_string ("%N")
		end

	pre_process_bin_or_else_as (l_as: BIN_OR_ELSE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_or_else_as")
			log.put_string ("%N")
		end

	pre_process_bin_xor_as (l_as: BIN_XOR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_xor_as")
			log.put_string ("%N")
		end

	pre_process_bin_ge_as (l_as: BIN_GE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_ge_as")
			log.put_string ("%N")
		end

	pre_process_bin_gt_as (l_as: BIN_GT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_gt_as")
			log.put_string ("%N")
		end

	pre_process_bin_le_as (l_as: BIN_LE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_le_as")
			log.put_string ("%N")
		end

	pre_process_bin_lt_as (l_as: BIN_LT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_lt_as")
			log.put_string ("%N")
		end

	pre_process_bin_div_as (l_as: BIN_DIV_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_div_as")
			log.put_string ("%N")
		end

	pre_process_bin_minus_as (l_as: BIN_MINUS_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_minus_as")
			log.put_string ("%N")
		end

	pre_process_bin_mod_as (l_as: BIN_MOD_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_mod_as")
			log.put_string ("%N")
		end

	pre_process_bin_plus_as (l_as: BIN_PLUS_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_plus_as")
			log.put_string ("%N")
		end

	pre_process_bin_power_as (l_as: BIN_POWER_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_power_as")
			log.put_string ("%N")
		end

	pre_process_bin_slash_as (l_as: BIN_SLASH_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_slash_as")
			log.put_string ("%N")
		end

	pre_process_bin_star_as (l_as: BIN_STAR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_star_as")
			log.put_string ("%N")
		end

	pre_process_bin_and_as (l_as: BIN_AND_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_and_as")
			log.put_string ("%N")
		end

	pre_process_bin_eq_as (l_as: BIN_EQ_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_eq_as")
			log.put_string ("%N")
		end

	pre_process_bin_ne_as (l_as: BIN_NE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_ne_as")
			log.put_string ("%N")
		end

	pre_process_bin_tilde_as (l_as: BIN_TILDE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_tilde_as")
			log.put_string ("%N")
		end

	pre_process_bin_not_tilde_as (l_as: BIN_NOT_TILDE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bin_not_tilde_as")
			log.put_string ("%N")
		end

	pre_process_bracket_as (l_as: BRACKET_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("bracket_as")
			log.put_string ("%N")
		end

	pre_process_operand_as (l_as: OPERAND_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("operand_as")
			log.put_string ("%N")
		end

	pre_process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("object_test_as")
			log.put_string ("%N")
		end

	pre_process_loop_expr_as (l_as: LOOP_EXPR_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("loop_expr_as")
			log.put_string ("%N")
		end

	pre_process_void_as (l_as: VOID_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("void_as")
			log.put_string ("%N")
		end

	pre_process_unary_as (l_as: UNARY_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("unary_as")
			log.put_string ("%N")
		end

	pre_process_binary_as (l_as: BINARY_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("binary_as")
			log.put_string ("%N")
		end

feature {AST_EIFFEL} -- Instructions visitors

	pre_process_elseif_as (l_as: ELSIF_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("elseif_as")
			log.put_string ("%N")
		end

	pre_process_assign_as (l_as: ASSIGN_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("assign_as")
			log.put_string ("%N")
		end

	pre_process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("assigner_call_as")
			log.put_string ("%N")
		end

	pre_process_case_as (l_as: CASE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("case_as")
			log.put_string ("%N")
		end

	pre_process_check_as (l_as: CHECK_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("check_as")
			log.put_string ("%N")
		end

	pre_process_creation_as (l_as: CREATION_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("creation_as")
			log.put_string ("%N")
		end

	pre_process_debug_as (l_as: DEBUG_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("debug_as")
			log.put_string ("%N")
		end

	pre_process_guard_as (l_as: GUARD_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("guard_as")
			log.put_string ("%N")
		end

	pre_process_if_as (l_as: IF_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("if_as")
			log.put_string ("%N")
		end

	pre_process_inspect_as (l_as: INSPECT_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("inspect_as")
			log.put_string ("%N")
		end

	pre_process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("instr_call_as")
			log.put_string ("%N")
		end

	pre_process_interval_as (l_as: INTERVAL_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("interval_as")
			log.put_string ("%N")
		end

	pre_process_loop_as (l_as: LOOP_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("loop_as")
			log.put_string ("%N")
		end

	pre_process_retry_as (l_as: RETRY_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("retry_as")
			log.put_string ("%N")
		end

	pre_process_reverse_as (l_as: REVERSE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("reverse_as")
			log.put_string ("%N")
		end

feature {AST_EIFFEL} -- External visitors

	pre_process_external_as (l_as: EXTERNAL_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("external_as")
			log.put_string ("%N")
		end

	pre_process_external_lang_as (l_as: EXTERNAL_LANG_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("external_lang_as")
			log.put_string ("%N")
		end

feature {AST_EIFFEL} -- Clickable visitor

	pre_process_class_as (l_as: CLASS_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("class_as")
			log.put_string ("%N")
		end

	pre_process_class_type_as (l_as: CLASS_TYPE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("class_type_as")
			log.put_string ("%N")
		end

	pre_process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("generic_class_type_as")
			log.put_string ("%N")
		end

	pre_process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("named_tuple_type_as")
			log.put_string ("%N")
		end

	pre_process_feature_as (l_as: FEATURE_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("feature_as")
			log.put_string ("%N")
		end

	pre_process_formal_as (l_as: FORMAL_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("formal_as")
			log.put_string ("%N")
		end

	pre_process_type_list_as (l_as: TYPE_LIST_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("type_list_as")
			log.put_string ("%N")
		end

	pre_process_type_dec_list_as (l_as: TYPE_DEC_LIST_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("type_dec_list_as")
			log.put_string ("%N")
		end

feature -- Quantification

	pre_process_there_exists_as (l_as: THERE_EXISTS_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("there_exists_as")
			log.put_string ("%N")
		end

	pre_process_for_all_as (l_as: FOR_ALL_AS)
		do
			safe_print_ast_path_prefix (l_as)
			log.put_string ("for_all_as")
			log.put_string ("%N")
		end

end
