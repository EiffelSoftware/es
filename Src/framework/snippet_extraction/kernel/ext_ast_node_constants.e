note
	description: "Summary description for {EXT_AST_NODE_CONSTANTS}."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_NODE_CONSTANTS

feature -- Constants

	node_none_id_as: STRING = "none_id_as"

	node_typed_char_as: STRING = "typed_char_as"

	node_agent_routine_creation_as: STRING = "agent_routine_creation_as"

	node_inline_agent_creation_as: STRING = "inline_agent_creation_as"

	node_create_creation_as: STRING = "create_creation_as"

	node_bang_creation_as: STRING = "bang_creation_as"

	node_create_creation_expr_as: STRING = "create_creation_expr_as"

	node_bang_creation_expr_as: STRING = "bang_creation_expr_as"

	node_keyword_as: STRING = "keyword_as"

	node_symbol_as: STRING = "symbol_as"

	node_break_as: STRING = "break_as"

	node_leaf_stub_as: STRING = "leaf_stub_as"

	node_symbol_stub_as: STRING = "symbol_stub_as"

	node_keyword_stub_as: STRING = "keyword_stub_as"

	node_custom_attribute_as: STRING = "custom_attribute_as"

	node_id_as: STRING = "id_as"

	node_integer_as: STRING = "integer_as"

	node_static_access_as: STRING = "static_access_as"

	node_feature_clause_as: STRING = "feature_clause_as"

	node_unique_as: STRING = "unique_as"

	node_tuple_as: STRING = "tuple_as"

	node_real_as: STRING = "real_as"

	node_bool_as: STRING = "bool_as"

	node_bit_const_as: STRING = "bit_const_as"

	node_array_as: STRING = "array_as"

	node_char_as: STRING = "char_as"

	node_string_as: STRING = "string_as"

	node_verbatim_string_as: STRING = "verbatim_string_as"

	node_body_as: STRING = "body_as"

	node_built_in_as: STRING = "built_in_as"

	node_result_as: STRING = "result_as"

	node_current_as: STRING = "current_as"

	node_access_feat_as: STRING = "access_feat_as"

	node_access_inv_as: STRING = "access_inv_as"

	node_access_id_as: STRING = "access_id_as"

	node_access_assert_as: STRING = "access_assert_as"

	node_precursor_as: STRING = "precursor_as"

	node_nested_expr_as: STRING = "nested_expr_as"

	node_nested_as: STRING = "nested_as"

	node_creation_expr_as: STRING = "creation_expr_as"

	node_routine_as: STRING = "routine_as"

	node_constant_as: STRING = "constant_as"

	node_eiffel_list: STRING = "eiffel_list"

	node_indexing_clause_as: STRING = "indexing_clause_as"

	node_infix_prefix_as: STRING = "infix_prefix_as"

	node_feat_name_id_as: STRING = "feat_name_id_as"

	node_feature_name_alias_as: STRING = "feature_name_alias_as"

	node_feature_list_as: STRING = "feature_list_as"

	node_all_as: STRING = "all_as"

	node_attribute_as: STRING = "attribute_as"

	node_deferred_as: STRING = "deferred_as"

	node_do_as: STRING = "do_as"

	node_once_as: STRING = "once_as"

	node_type_dec_as: STRING = "type_dec_as"

	node_parent_as: STRING = "parent_as"

	node_like_id_as: STRING = "like_id_as"

	node_like_cur_as: STRING = "like_cur_as"

	node_qualified_anchored_type_as: STRING = "qualified_anchored_type_as"

	node_formal_dec_as: STRING = "formal_dec_as"

	node_constraining_type_as: STRING = "constraining_type_as"

	node_none_type_as: STRING = "none_type_as"

	node_bits_as: STRING = "bits_as"

	node_bits_symbol_as: STRING = "bits_symbol_as"

	node_rename_as: STRING = "rename_as"

	node_invariant_as: STRING = "invariant_as"

	node_index_as: STRING = "index_as"

	node_export_item_as: STRING = "export_item_as"

	node_create_as: STRING = "create_as"

	node_client_as: STRING = "client_as"

	node_ensure_as: STRING = "ensure_as"

	node_ensure_then_as: STRING = "ensure_then_as"

	node_require_as: STRING = "require_as"

	node_require_else_as: STRING = "require_else_as"

	node_convert_feat_as: STRING = "convert_feat_as"

	node_convert_feat_list_as: STRING = "convert_feat_list_as"

	node_class_list_as: STRING = "class_list_as"

	node_parent_list_as: STRING = "parent_list_as"

	node_local_dec_list_as: STRING = "local_dec_list_as"

	node_formal_argu_dec_list_as: STRING = "formal_argu_dec_list_as"

	node_key_list_as: STRING = "key_list_as"

	node_delayed_actual_list_as: STRING = "delayed_actual_list_as"

	node_parameter_list_as: STRING = "parameter_list_as"

	node_rename_clause_as: STRING = "rename_clause_as"

	node_export_clause_as: STRING = "export_clause_as"

	node_undefine_clause_as: STRING = "undefine_clause_as"

	node_redefine_clause_as: STRING = "redefine_clause_as"

	node_select_clause_as: STRING = "select_clause_as"

	node_formal_generic_list_as: STRING = "formal_generic_list_as"

	node_iteration_as: STRING = "iteration_as"

	node_tagged_as: STRING = "tagged_as"

	node_variant_as: STRING = "variant_as"

	node_un_strip_as: STRING = "un_strip_as"

	node_converted_expr_as: STRING = "converted_expr_as"

	node_paran_as: STRING = "paran_as"

	node_expr_call_as: STRING = "expr_call_as"

	node_expr_address_as: STRING = "expr_address_as"

	node_address_result_as: STRING = "address_result_as"

	node_address_current_as: STRING = "address_current_as"

	node_address_as: STRING = "address_as"

	node_type_expr_as: STRING = "type_expr_as"

	node_routine_creation_as: STRING = "routine_creation_as"

	node_unary_as: STRING = "unary_as"

	node_un_free_as: STRING = "un_free_as"

	node_un_minus_as: STRING = "un_minus_as"

	node_un_not_as: STRING = "un_not_as"

	node_un_old_as: STRING = "un_old_as"

	node_un_plus_as: STRING = "un_plus_as"

	node_binary_as: STRING = "binary_as"

	node_bin_and_then_as: STRING = "bin_and_then_as"

	node_bin_free_as: STRING = "bin_free_as"

	node_bin_implies_as: STRING = "bin_implies_as"

	node_bin_or_as: STRING = "bin_or_as"

	node_bin_or_else_as: STRING = "bin_or_else_as"

	node_bin_xor_as: STRING = "bin_xor_as"

	node_bin_ge_as: STRING = "bin_ge_as"

	node_bin_gt_as: STRING = "bin_gt_as"

	node_bin_le_as: STRING = "bin_le_as"

	node_bin_lt_as: STRING = "bin_lt_as"

	node_bin_div_as: STRING = "bin_div_as"

	node_bin_minus_as: STRING = "bin_minus_as"

	node_bin_mod_as: STRING = "bin_mod_as"

	node_bin_plus_as: STRING = "bin_plus_as"

	node_bin_power_as: STRING = "bin_power_as"

	node_bin_slash_as: STRING = "bin_slash_as"

	node_bin_star_as: STRING = "bin_star_as"

	node_bin_and_as: STRING = "bin_and_as"

	node_bin_eq_as: STRING = "bin_eq_as"

	node_bin_ne_as: STRING = "bin_ne_as"

	node_bin_tilde_as: STRING = "bin_tilde_as"

	node_bin_not_tilde_as: STRING = "bin_not_tilde_as"

	node_bracket_as: STRING = "bracket_as"

	node_operand_as: STRING = "operand_as"

	node_object_test_as: STRING = "object_test_as"

	node_loop_expr_as: STRING = "loop_expr_as"

	node_void_as: STRING = "void_as"

	node_elseif_as: STRING = "elseif_as"

	node_assign_as: STRING = "assign_as"

	node_assigner_call_as: STRING = "assigner_call_as"

	node_case_as: STRING = "case_as"

	node_check_as: STRING = "check_as"

	node_creation_as: STRING = "creation_as"

	node_debug_as: STRING = "debug_as"

	node_guard_as: STRING = "guard_as"

	node_if_as: STRING = "if_as"

	node_inspect_as: STRING = "inspect_as"

	node_instr_call_as: STRING = "instr_call_as"

	node_interval_as: STRING = "interval_as"

	node_loop_as: STRING = "loop_as"

	node_retry_as: STRING = "retry_as"

	node_reverse_as: STRING = "reverse_as"

	node_external_as: STRING = "external_as"

	node_external_lang_as: STRING = "external_lang_as"

	node_class_as: STRING = "class_as"

	node_class_type_as: STRING = "class_type_as"

	node_generic_class_type_as: STRING = "generic_class_type_as"

	node_named_tuple_type_as: STRING = "named_tuple_type_as"

	node_feature_as: STRING = "feature_as"

	node_formal_as: STRING = "formal_as"

	node_type_list_as: STRING = "type_list_as"

	node_type_dec_list_as: STRING = "type_dec_list_as"

	node_there_exists_as: STRING = "there_exists_as"

	node_for_all_as: STRING = "for_all_as"

end
