note
	description: "Summary description for {EXT_AST_NODE_CONSTANTS}."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_NODE_CONSTANTS

feature -- Constants

	node_none_id_as: STRING = "NONE_ID_AS"

	node_typed_char_as: STRING = "TYPED_CHAR_AS"

	node_agent_routine_creation_as: STRING = "AGENT_ROUTINE_CREATION_AS"

	node_inline_agent_creation_as: STRING = "INLINE_AGENT_CREATION_AS"

	node_create_creation_as: STRING = "CREATE_CREATION_AS"

	node_bang_creation_as: STRING = "BANG_CREATION_AS"

	node_create_creation_expr_as: STRING = "CREATE_CREATION_EXPR_AS"

	node_bang_creation_expr_as: STRING = "BANG_CREATION_EXPR_AS"

	node_keyword_as: STRING = "KEYWORD_AS"

	node_symbol_as: STRING = "SYMBOL_AS"

	node_break_as: STRING = "BREAK_AS"

	node_leaf_stub_as: STRING = "LEAF_STUB_AS"

	node_symbol_stub_as: STRING = "SYMBOL_STUB_AS"

	node_keyword_stub_as: STRING = "KEYWORD_STUB_AS"

	node_custom_attribute_as: STRING = "CUSTOM_ATTRIBUTE_AS"

	node_id_as: STRING = "ID_AS"

	node_integer_as: STRING = "INTEGER_AS"

	node_static_access_as: STRING = "STATIC_ACCESS_AS"

	node_feature_clause_as: STRING = "FEATURE_CLAUSE_AS"

	node_unique_as: STRING = "UNIQUE_AS"

	node_tuple_as: STRING = "TUPLE_AS"

	node_real_as: STRING = "REAL_AS"

	node_bool_as: STRING = "BOOL_AS"

	node_bit_const_as: STRING = "BIT_CONST_AS"

	node_array_as: STRING = "ARRAY_AS"

	node_compiler_array_as: STRING = "COMPILER_ARRAY_AS"

	node_char_as: STRING = "CHAR_AS"

	node_string_as: STRING = "STRING_AS"

	node_verbatim_string_as: STRING = "VERBATIM_STRING_AS"

	node_body_as: STRING = "BODY_AS"

	node_built_in_as: STRING = "BUILT_IN_AS"

	node_result_as: STRING = "RESULT_AS"

	node_current_as: STRING = "CURRENT_AS"

	node_access_feat_as: STRING = "ACCESS_FEAT_AS"

	node_access_inv_as: STRING = "ACCESS_INV_AS"

	node_access_id_as: STRING = "ACCESS_ID_AS"

	node_access_assert_as: STRING = "ACCESS_ASSERT_AS"

	node_precursor_as: STRING = "PRECURSOR_AS"

	node_nested_expr_as: STRING = "NESTED_EXPR_AS"

	node_nested_as: STRING = "NESTED_AS"

	node_creation_expr_as: STRING = "CREATION_EXPR_AS"

	node_routine_as: STRING = "ROUTINE_AS"

	node_constant_as: STRING = "CONSTANT_AS"

	node_eiffel_list: STRING = "EIFFEL_LIST"

	node_indexing_clause_as: STRING = "INDEXING_CLAUSE_AS"

	node_infix_prefix_as: STRING = "INFIX_PREFIX_AS"

	node_feat_name_id_as: STRING = "FEAT_NAME_ID_AS"

	node_feature_name_alias_as: STRING = "FEATURE_NAME_ALIAS_AS"

	node_feature_list_as: STRING = "FEATURE_LIST_AS"

	node_all_as: STRING = "ALL_AS"

	node_attribute_as: STRING = "ATTRIBUTE_AS"

	node_deferred_as: STRING = "DEFERRED_AS"

	node_do_as: STRING = "DO_AS"

	node_once_as: STRING = "ONCE_AS"

	node_type_dec_as: STRING = "TYPE_DEC_AS"

	node_parent_as: STRING = "PARENT_AS"

	node_like_id_as: STRING = "LIKE_ID_AS"

	node_like_cur_as: STRING = "LIKE_CUR_AS"

	node_qualified_anchored_type_as: STRING = "QUALIFIED_ANCHORED_TYPE_AS"

	node_formal_dec_as: STRING = "FORMAL_DEC_AS"

	node_formal_constraint_as: STRING = "FORMAL_CONSTRAINT_AS"

	node_constraining_type_as: STRING = "CONSTRAINING_TYPE_AS"

	node_none_type_as: STRING = "NONE_TYPE_AS"

	node_bits_as: STRING = "BITS_AS"

	node_bits_symbol_as: STRING = "BITS_SYMBOL_AS"

	node_rename_as: STRING = "RENAME_AS"

	node_invariant_as: STRING = "INVARIANT_AS"

	node_index_as: STRING = "INDEX_AS"

	node_export_item_as: STRING = "EXPORT_ITEM_AS"

	node_create_as: STRING = "CREATE_AS"

	node_client_as: STRING = "CLIENT_AS"

	node_ensure_as: STRING = "ENSURE_AS"

	node_ensure_then_as: STRING = "ENSURE_THEN_AS"

	node_require_as: STRING = "REQUIRE_AS"

	node_require_else_as: STRING = "REQUIRE_ELSE_AS"

	node_convert_feat_as: STRING = "CONVERT_FEAT_AS"

	node_convert_feat_list_as: STRING = "CONVERT_FEAT_LIST_AS"

	node_class_list_as: STRING = "CLASS_LIST_AS"

	node_parent_list_as: STRING = "PARENT_LIST_AS"

	node_local_dec_list_as: STRING = "LOCAL_DEC_LIST_AS"

	node_formal_argu_dec_list_as: STRING = "FORMAL_ARGU_DEC_LIST_AS"

	node_key_list_as: STRING = "KEY_LIST_AS"

	node_delayed_actual_list_as: STRING = "DELAYED_ACTUAL_LIST_AS"

	node_parameter_list_as: STRING = "PARAMETER_LIST_AS"

	node_rename_clause_as: STRING = "RENAME_CLAUSE_AS"

	node_export_clause_as: STRING = "EXPORT_CLAUSE_AS"

	node_undefine_clause_as: STRING = "UNDEFINE_CLAUSE_AS"

	node_redefine_clause_as: STRING = "REDEFINE_CLAUSE_AS"

	node_select_clause_as: STRING = "SELECT_CLAUSE_AS"

	node_formal_generic_list_as: STRING = "FORMAL_GENERIC_LIST_AS"

	node_iteration_as: STRING = "ITERATION_AS"

	node_tagged_as: STRING = "TAGGED_AS"

	node_variant_as: STRING = "VARIANT_AS"

	node_un_strip_as: STRING = "UN_STRIP_AS"

	node_converted_expr_as: STRING = "CONVERTED_EXPR_AS"

	node_paran_as: STRING = "PARAN_AS"

	node_expr_call_as: STRING = "EXPR_CALL_AS"

	node_expr_address_as: STRING = "EXPR_ADDRESS_AS"

	node_address_result_as: STRING = "ADDRESS_RESULT_AS"

	node_address_current_as: STRING = "ADDRESS_CURRENT_AS"

	node_address_as: STRING = "ADDRESS_AS"

	node_type_expr_as: STRING = "TYPE_EXPR_AS"

	node_routine_creation_as: STRING = "ROUTINE_CREATION_AS"

	node_unary_as: STRING = "UNARY_AS"

	node_un_free_as: STRING = "UN_FREE_AS"

	node_un_minus_as: STRING = "UN_MINUS_AS"

	node_un_not_as: STRING = "UN_NOT_AS"

	node_un_old_as: STRING = "UN_OLD_AS"

	node_un_plus_as: STRING = "UN_PLUS_AS"

	node_binary_as: STRING = "BINARY_AS"

	node_bin_and_then_as: STRING = "BIN_AND_THEN_AS"

	node_bin_free_as: STRING = "BIN_FREE_AS"

	node_bin_implies_as: STRING = "BIN_IMPLIES_AS"

	node_bin_or_as: STRING = "BIN_OR_AS"

	node_bin_or_else_as: STRING = "BIN_OR_ELSE_AS"

	node_bin_xor_as: STRING = "BIN_XOR_AS"

	node_bin_ge_as: STRING = "BIN_GE_AS"

	node_bin_gt_as: STRING = "BIN_GT_AS"

	node_bin_le_as: STRING = "BIN_LE_AS"

	node_bin_lt_as: STRING = "BIN_LT_AS"

	node_bin_div_as: STRING = "BIN_DIV_AS"

	node_bin_minus_as: STRING = "BIN_MINUS_AS"

	node_bin_mod_as: STRING = "BIN_MOD_AS"

	node_bin_plus_as: STRING = "BIN_PLUS_AS"

	node_bin_power_as: STRING = "BIN_POWER_AS"

	node_bin_slash_as: STRING = "BIN_SLASH_AS"

	node_bin_star_as: STRING = "BIN_STAR_AS"

	node_bin_and_as: STRING = "BIN_AND_AS"

	node_bin_eq_as: STRING = "BIN_EQ_AS"

	node_bin_ne_as: STRING = "BIN_NE_AS"

	node_bin_tilde_as: STRING = "BIN_TILDE_AS"

	node_bin_not_tilde_as: STRING = "BIN_NOT_TILDE_AS"

	node_bracket_as: STRING = "BRACKET_AS"

	node_operand_as: STRING = "OPERAND_AS"

	node_object_test_as: STRING = "OBJECT_TEST_AS"

	node_loop_expr_as: STRING = "LOOP_EXPR_AS"

	node_void_as: STRING = "VOID_AS"

	node_elsif_as: STRING = "ELSIF_AS"

	node_assign_as: STRING = "ASSIGN_AS"

	node_assigner_call_as: STRING = "ASSIGNER_CALL_AS"

	node_case_as: STRING = "CASE_AS"

	node_check_as: STRING = "CHECK_AS"

	node_creation_as: STRING = "CREATION_AS"

	node_debug_as: STRING = "DEBUG_AS"

	node_guard_as: STRING = "GUARD_AS"

	node_if_as: STRING = "IF_AS"

	node_inspect_as: STRING = "INSPECT_AS"

	node_instr_call_as: STRING = "INSTR_CALL_AS"

	node_interval_as: STRING = "INTERVAL_AS"

	node_loop_as: STRING = "LOOP_AS"

	node_retry_as: STRING = "RETRY_AS"

	node_reverse_as: STRING = "REVERSE_AS"

	node_external_as: STRING = "EXTERNAL_AS"

	node_external_lang_as: STRING = "EXTERNAL_LANG_AS"

	node_compiler_external_lang_as: STRING = "COMPILER_EXTERNAL_LANG_AS"

	node_class_as: STRING = "CLASS_AS"

	node_class_type_as: STRING = "CLASS_TYPE_AS"

	node_generic_class_type_as: STRING = "GENERIC_CLASS_TYPE_AS"

	node_named_tuple_type_as: STRING = "NAMED_TUPLE_TYPE_AS"

	node_feature_as: STRING = "FEATURE_AS"

	node_formal_as: STRING = "FORMAL_AS"

	node_type_list_as: STRING = "TYPE_LIST_AS"

	node_type_dec_list_as: STRING = "TYPE_DEC_LIST_AS"

	node_there_exists_as: STRING = "THERE_EXISTS_AS"

	node_for_all_as: STRING = "FOR_ALL_AS"

feature -- New Ones

	node_ast_eiffel: STRING = "AST_EIFFEL"

	node_integer_constant: STRING = "INTEGER_CONSTANT"

	node_equality_as: STRING = "EQUALITY_AS"

	node_instruction_as: STRING = "INSTRUCTION_AS"

	node_leaf_as: STRING = "LEAF_AS"

	node_type_as: STRING = "TYPE_AS"

	node_expr_as: STRING = "EXPR_AS"

	node_call_as: STRING = "CALL_AS"

	node_atomic_as: STRING = "ATOMIC_AS"

	node_access_as: STRING = "ACCESS_AS"

	node_feature_name: STRING = "FEATURE_NAME"

	node_feature_set_as: STRING = "FEATURE_SET_AS"

	node_content_as: STRING = "CONTENT_AS"

	node_rout_body_as: STRING = "ROUT_BODY_AS"

	node_internal_as: STRING = "INTERNAL_AS"

	node_constraint_list_as: STRING = "CONSTRAINT_LIST_AS"

	node_use_list_as: STRING = "USE_LIST_AS"

feature -- Fake Node

	node_static_access_expr_as: STRING = "STATIC_ACCESS_EXPR_AS"

feature -- Eiffel List (Generics)

	node_eiffel_list_of_interval_as: STRING = "EIFFEL_LIST [INTERVAL_AS]"

	node_eiffel_list_of_instruction_as: STRING = "EIFFEL_LIST [INSTRUCTION_AS]"

	node_eiffel_list_of_case_as: STRING = "EIFFEL_LIST [CASE_AS]"

	node_eiffel_list_of_tagged_as: STRING = "EIFFEL_LIST [TAGGED_AS]"

	node_eiffel_list_of_elsif_as: STRING = "EIFFEL_LIST [ELSIF_AS]"

	node_eiffel_list_of_rename_as: STRING = "EIFFEL_LIST [RENAME_AS]"

	node_eiffel_list_of_export_item_as: STRING = "EIFFEL_LIST [EXPORT_ITEM_AS]"

	node_eiffel_list_of_type_dec_as: STRING = "EIFFEL_LIST [TYPE_DEC_AS]"

	node_eiffel_list_of_feature_name: STRING = "EIFFEL_LIST [FEATURE_NAME]"

	node_eiffel_list_of_expr_as: STRING = "EIFFEL_LIST [EXPR_AS]"

	node_eiffel_list_of_feature_as: STRING = "EIFFEL_LIST [FEATURE_AS]"

	node_eiffel_list_of_formal_dec_as: STRING = "EIFFEL_LIST [FORMAL_DEC_AS]"

	node_eiffel_list_of_parent_as: STRING = "EIFFEL_LIST [PARENT_AS]"

	node_eiffel_list_of_operand_as: STRING = "EIFFEL_LIST [OPERAND_AS]"

	node_eiffel_list_of_atomic_as: STRING = "EIFFEL_LIST [ATOMIC_AS]"

	node_eiffel_list_of_create_as: STRING = "EIFFEL_LIST [CREATE_AS]"

	node_eiffel_list_of_convert_feat_as: STRING = "EIFFEL_LIST [CONVERT_FEAT_AS]"

	node_eiffel_list_of_feature_clause_as: STRING = "EIFFEL_LIST [FEATURE_CLAUSE_AS]"

	node_eiffel_list_of_string_as: STRING = "EIFFEL_LIST [STRING_AS]"

end
