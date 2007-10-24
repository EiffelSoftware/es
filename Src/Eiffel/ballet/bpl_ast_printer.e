indexing
	description: "Print a pretty version of the AST into the output file"
	author: "Bernd Schoeller"
	date: "$Date$"
	revision: "$Revision$"

class

	BPL_AST_PRINTER

inherit

   BPL_VISITOR
		redefine
			process_access_assert_as ,
			process_access_feat_as ,
			process_access_id_as ,
			process_access_inv_as ,
			process_address_as ,
			process_address_current_as ,
			process_address_result_as ,
			process_agent_routine_creation_as ,
			process_all_as ,
			process_array_as ,
			process_assign_as ,
			process_assigner_call_as ,
			process_bang_creation_as ,
			process_bang_creation_expr_as ,
			process_bin_and_as ,
			process_bin_and_then_as ,
			process_binary_as ,
			process_bin_div_as ,
			process_bin_eq_as ,
			process_bin_free_as ,
			process_bin_ge_as ,
			process_bin_gt_as ,
			process_bin_implies_as ,
			process_bin_le_as ,
			process_bin_lt_as ,
			process_bin_minus_as ,
			process_bin_mod_as ,
			process_bin_ne_as ,
			process_bin_or_as ,
			process_bin_or_else_as ,
			process_bin_plus_as ,
			process_bin_power_as ,
			process_bin_slash_as ,
			process_bin_star_as ,
			process_bin_xor_as ,
			process_bit_const_as ,
			process_bits_as ,
			process_bits_symbol_as ,
			process_body_as ,
			process_bool_as ,
			process_bracket_as ,
			process_break_as ,
			process_case_as ,
			process_char_as ,
			process_check_as ,
			process_class_as ,
			process_class_list_as ,
			process_class_type_as ,
			process_client_as ,
			process_constant_as ,
			process_convert_feat_as ,
			process_convert_feat_list_as ,
			process_create_as ,
			process_create_creation_as ,
			process_create_creation_expr_as ,
			process_creation_as ,
			process_creation_expr_as ,
			process_current_as ,
			process_custom_attribute_as ,
			process_debug_as ,
			process_debug_key_list_as ,
			process_deferred_as ,
			process_delayed_actual_list_as ,
			process_do_as ,
			process_elseif_as ,
			process_ensure_as ,
			process_ensure_then_as ,
			process_export_clause_as ,
			process_export_item_as ,
			process_expr_address_as ,
			process_expr_call_as ,
			process_external_as ,
			process_external_lang_as ,
			process_feat_name_id_as ,
			process_feature_as ,
			process_feature_clause_as ,
			process_feature_list_as ,
			process_feature_name_alias_as ,
			process_formal_argu_dec_list_as ,
			process_formal_as ,
			process_formal_dec_as ,
			process_formal_generic_list_as ,
			process_id_as ,
			process_if_as ,
			process_index_as ,
			process_indexing_clause_as ,
			process_infix_prefix_as ,
			process_inline_agent_creation_as ,
			process_inspect_as ,
			process_instr_call_as ,
			process_integer_as ,
			process_interval_as ,
			process_invariant_as ,
			process_keyword_as ,
			process_leaf_stub_as ,
			process_like_cur_as ,
			process_like_id_as ,
			process_local_dec_list_as ,
			process_loop_as,
			process_modify_as,
			process_named_tuple_type_as ,
			process_nested_as ,
			process_nested_expr_as ,
			process_none_id_as ,
			process_none_type_as ,
			process_once_as ,
			process_operand_as ,
			process_parameter_list_as ,
			process_paran_as ,
			process_parent_as ,
			process_parent_list_as ,
			process_precursor_as ,
			process_real_as ,
			process_redefine_clause_as ,
			process_rename_as ,
			process_rename_clause_as ,
			process_require_as ,
			process_require_else_as ,
			process_result_as ,
			process_retry_as ,
			process_reverse_as ,
			process_routine_as ,
			process_routine_creation_as ,
			process_select_clause_as ,
			process_static_access_as ,
			process_string_as ,
			process_symbol_as ,
			process_symbol_stub_as ,
			process_tagged_as ,
			process_tilda_routine_creation_as ,
			process_tuple_as ,
			process_typed_char_as ,
			process_type_dec_as ,
			process_type_dec_list_as ,
			process_type_expr_as ,
			process_type_list_as ,
			process_unary_as ,
			process_undefine_clause_as ,
			process_un_free_as ,
			process_unique_as ,
			process_un_minus_as ,
			process_un_not_as ,
			process_un_old_as ,
			process_un_plus_as ,
			process_un_strip_as ,
			process_use_as,
			process_variant_as ,
			process_verbatim_string_as ,
			process_void_as,
			process_eiffel_list
		end

	EIFFEL_TOKENS
		export
			{NONE} all
		end

create
	make

feature -- Output

	put_name (a_string: STRING) is
			-- Put a comment with `indent' intentions followed by
			-- `a_string'.
		local
			i: INTEGER
			s: STRING
		do
			bpl_out("//")
			from i := 1 until i > indent loop
				bpl_out("  ")
				i := i + 1
			end
			s := a_string.twin
			s.replace_substring_all("%N", "%%N")
			bpl_out(s)
			bpl_out("%N")
		end

	indent: INTEGER
			-- Current indentation level

feature -- Processors

	process_keyword_as (l_as: KEYWORD_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("keyword_as (" + token_name (l_as.code) + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_symbol_as (l_as: SYMBOL_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("symbol_as (" + token_name (l_as.code) + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_break_as (l_as: BREAK_AS) is
			-- Process `l_as'.			
		do
			indent := indent + 1
			put_name ("break_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_leaf_stub_as (l_as: LEAF_STUB_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("leaf_stub_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_symbol_stub_as (l_as: SYMBOL_STUB_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("symbol_stub_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bool_as (l_as: BOOL_AS) is
		do
			indent := indent + 1
			put_name ("bool_as (" + l_as.value.out + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_char_as (l_as: CHAR_AS) is
		do
			indent := indent + 1
			put_name ("char_as (" + l_as.value.out + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_result_as (l_as: RESULT_AS) is
		do
			indent := indent + 1
			put_name ("result_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_retry_as (l_as: RETRY_AS) is
		do
			indent := indent + 1
			put_name ("retry_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_unique_as (l_as: UNIQUE_AS) is
		do
			indent := indent + 1
			put_name ("unique_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_deferred_as (l_as: DEFERRED_AS) is
		do
			indent := indent + 1
			put_name ("deferred_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_void_as (l_as: VOID_AS) is
		do
			indent := indent + 1
			put_name ("void_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_string_as (l_as: STRING_AS) is
		do
			indent := indent + 1
			put_name ("string_as (" + l_as.value + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS) is
		do
			indent := indent + 1
			put_name ("verbatim_string_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_current_as (l_as: CURRENT_AS) is
		do
			indent := indent + 1
			put_name ("current_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_integer_as (l_as: INTEGER_AS) is
		do
			indent := indent + 1
			put_name ("integer_as (" + l_as.string_value + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_real_as (l_as: REAL_AS) is
		do
			indent := indent + 1
			put_name ("real_as (" + l_as.value + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_id_as (l_as: ID_AS) is
		do
			indent := indent + 1
			put_name ("id_as (" + l_as + ")")
			Precursor (l_as)
			indent := indent - 1
		end

feature

	process_bit_const_as (l_as: BIT_CONST_AS) is
		do
			indent := indent + 1
			put_name ("bit_const_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_none_id_as (l_as: NONE_ID_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("none_id_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_typed_char_as (l_as: TYPED_CHAR_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("typed_char_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_agent_routine_creation_as (l_as: AGENT_ROUTINE_CREATION_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("agent_routine_creation_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_tilda_routine_creation_as (l_as: TILDA_ROUTINE_CREATION_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("tilda_routine_creation_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("inline_agent_creation_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("create_creation_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bang_creation_as (l_as: BANG_CREATION_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("bang_creation_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("create_creation_expr_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bang_creation_expr_as (l_as: BANG_CREATION_EXPR_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("bang_creation_expr_as")
			Precursor (l_as)
			indent := indent - 1
		end

feature

	process_custom_attribute_as (l_as: CUSTOM_ATTRIBUTE_AS) is
		do
			indent := indent + 1
			put_name ("custom_attribute_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS) is
		do
			indent := indent + 1
			put_name ("static_access_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_feature_clause_as (l_as: FEATURE_CLAUSE_AS) is
		do
			indent := indent + 1
			put_name ("feature_clause_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_tuple_as (l_as: TUPLE_AS) is
		do
			indent := indent + 1
			put_name ("tuple_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_array_as (l_as: ARRAY_AS) is
		do
			indent := indent + 1
			put_name ("array_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_body_as (l_as: BODY_AS) is
		do
			indent := indent + 1
			put_name ("body_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS) is
		do
			indent := indent + 1
			put_name ("access_feat_as (" + l_as.access_name + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_access_inv_as (l_as: ACCESS_INV_AS) is
		do
			indent := indent + 1
			put_name ("access_inv_as (" + l_as.access_name + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_access_id_as (l_as: ACCESS_ID_AS) is
		do
			indent := indent + 1
			put_name ("access_id_as (" + l_as.access_name + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS) is
		do
			indent := indent + 1
			put_name ("access_assert_as (" + l_as.access_name + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_precursor_as (l_as: PRECURSOR_AS) is
		do
			indent := indent + 1
			put_name ("precursor_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS) is
		do
			indent := indent + 1
			put_name ("nested_expr_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_nested_as (l_as: NESTED_AS) is
		do
			indent := indent + 1
			put_name ("nested_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_creation_expr_as (l_as: CREATION_EXPR_AS) is
		do
			indent := indent + 1
			put_name ("creation_expr_as (type = " + l_as.type.out + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_type_expr_as (l_as: TYPE_EXPR_AS) is
		do
			indent := indent + 1
			put_name ("type_expr_as (" + l_as.out + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_routine_as (l_as: ROUTINE_AS) is
		do
			indent := indent + 1
			put_name ("routine_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_constant_as (l_as: CONSTANT_AS) is
		do
			indent := indent + 1
			put_name ("constant_as (" + l_as.value.string_value + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL]) is
		do
			indent := indent + 1
			put_name ("eiffel_list")
			Precursor (l_as)
			indent := indent - 1
		end

	process_indexing_clause_as (l_as: INDEXING_CLAUSE_AS) is
		do
			indent := indent + 1
			put_name ("indexing_clause_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_operand_as (l_as: OPERAND_AS) is
		do
			indent := indent + 1
			put_name ("operand_as (" + l_as.target.access_name  + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_tagged_as (l_as: TAGGED_AS) is
		local
			tag: ID_AS
			tag_name: STRING
		do
			indent := indent + 1

			tag := l_as.tag
			if tag = Void then
				tag_name := "<unnamed>"
			else
				tag_name := tag
			end
			put_name ("tagged_as (" + tag_name + ":)")
			Precursor (l_as)
			indent := indent - 1
		end

	process_variant_as (l_as: VARIANT_AS) is
		do
			indent := indent + 1
			put_name ("variant_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_un_strip_as (l_as: UN_STRIP_AS) is
		do
			indent := indent + 1
			put_name ("un_strip_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_paran_as (l_as: PARAN_AS) is
		do
			indent := indent + 1
			put_name ("paran_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_expr_call_as (l_as: EXPR_CALL_AS) is
		do
			indent := indent + 1
			put_name ("expr_call_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_expr_address_as (l_as: EXPR_ADDRESS_AS) is
		do
			indent := indent + 1
			put_name ("expr_address_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_address_result_as (l_as: ADDRESS_RESULT_AS) is
		do
			indent := indent + 1
			put_name ("address_result_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_address_current_as (l_as: ADDRESS_CURRENT_AS) is
		do
			indent := indent + 1
			put_name ("address_current_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_address_as (l_as: ADDRESS_AS) is
		do
			indent := indent + 1
			put_name ("address_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_routine_creation_as (l_as: ROUTINE_CREATION_AS) is
		do
			indent := indent + 1
			put_name ("routine_creation_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_unary_as (l_as: UNARY_AS) is
		do
			indent := indent + 1
			put_name ("unary_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_un_free_as (l_as: UN_FREE_AS) is
		do
			indent := indent + 1
			put_name ("un_free_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_un_minus_as (l_as: UN_MINUS_AS) is
		do
			indent := indent + 1
			put_name ("un_minus_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_un_not_as (l_as: UN_NOT_AS) is
		do
			indent := indent + 1
			put_name ("un_not_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_un_old_as (l_as: UN_OLD_AS) is
		do
			indent := indent + 1
			put_name ("un_old_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_un_plus_as (l_as: UN_PLUS_AS) is
		do
			indent := indent + 1
			put_name ("un_plus_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_binary_as (l_as: BINARY_AS) is
		do
			indent := indent + 1
			put_name ("binary_as --"+type_for (l_as).associated_class.name)
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_and_then_as (l_as: BIN_AND_THEN_AS) is
		do
			indent := indent + 1
			put_name ("bin_and_then_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_free_as (l_as: BIN_FREE_AS) is
		do
			indent := indent + 1
			put_name ("bin_free_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_implies_as (l_as: BIN_IMPLIES_AS) is
		do
			indent := indent + 1
			put_name ("bin_implies_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_or_as (l_as: BIN_OR_AS) is
		do
			indent := indent + 1
			put_name ("bin_or_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_or_else_as (l_as: BIN_OR_ELSE_AS) is
		do
			indent := indent + 1
			put_name ("bin_or_else_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_xor_as (l_as: BIN_XOR_AS) is
		do
			indent := indent + 1
			put_name ("bin_xor_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_ge_as (l_as: BIN_GE_AS) is
		do
			indent := indent + 1
			put_name ("bin_ge_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_gt_as (l_as: BIN_GT_AS) is
		do
			indent := indent + 1
			put_name ("bin_gt_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_le_as (l_as: BIN_LE_AS) is
		do
			indent := indent + 1
			put_name ("bin_le_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_lt_as (l_as: BIN_LT_AS) is
		do
			indent := indent + 1
			put_name ("bin_lt_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_div_as (l_as: BIN_DIV_AS) is
		do
			indent := indent + 1
			put_name ("bin_div_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_minus_as (l_as: BIN_MINUS_AS) is
		do
			indent := indent + 1
			put_name ("bin_minus_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_mod_as (l_as: BIN_MOD_AS) is
		do
			indent := indent + 1
			put_name ("bin_mod_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_plus_as (l_as: BIN_PLUS_AS) is
		do
			indent := indent + 1
			put_name ("bin_plus_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_power_as (l_as: BIN_POWER_AS) is
		do
			indent := indent + 1
			put_name ("bin_power_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_slash_as (l_as: BIN_SLASH_AS) is
		do
			indent := indent + 1
			put_name ("bin_slash_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_star_as (l_as: BIN_STAR_AS) is
		do
			indent := indent + 1
			put_name ("bin_star_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_and_as (l_as: BIN_AND_AS) is
		do
			indent := indent + 1
			put_name ("bin_and_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_eq_as (l_as: BIN_EQ_AS) is
		do
			indent := indent + 1
			put_name ("bin_eq_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bin_ne_as (l_as: BIN_NE_AS) is
		do
			indent := indent + 1
			put_name ("bin_ne_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bracket_as (l_as: BRACKET_AS) is
		do
			indent := indent + 1
			put_name ("bracket_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_external_lang_as (l_as: EXTERNAL_LANG_AS) is
		do
			indent := indent + 1
			put_name ("external_lang_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_feature_as (l_as: FEATURE_AS) is
		do
			indent := indent + 1
			put_name ("feature_as (" + l_as.feature_name + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_infix_prefix_as (l_as: INFIX_PREFIX_AS) is
		do
			indent := indent + 1
			put_name ("infix_prefix_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_feat_name_id_as (l_as: FEAT_NAME_ID_AS) is
		do
			indent := indent + 1
			put_name ("feat_name_id_as (" + l_as.feature_name + ")")
			Precursor (l_as)
			indent := indent - 1
		end

	process_feature_name_alias_as (l_as: FEATURE_NAME_ALIAS_AS) is
		do
			indent := indent + 1
			put_name ("feature_name_alias_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_feature_list_as (l_as: FEATURE_LIST_AS) is
		do
			indent := indent + 1
			put_name ("feature_list_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_all_as (l_as: ALL_AS) is
		do
			indent := indent + 1
			put_name ("all_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_assign_as (l_as: ASSIGN_AS) is
		do
			indent := indent + 1
			put_name ("assign_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS) is
		do
			indent := indent + 1
			put_name ("assigner_call_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_reverse_as (l_as: REVERSE_AS) is
		do
			indent := indent + 1
			put_name ("reverse_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_check_as (l_as: CHECK_AS) is
		do
			indent := indent + 1
			put_name ("check_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_creation_as (l_as: CREATION_AS) is
		do
			indent := indent + 1
			put_name ("creation_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_debug_as (l_as: DEBUG_AS) is
		do
			indent := indent + 1
			put_name ("debug_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_if_as (l_as: IF_AS) is
		do
			indent := indent + 1
			put_name ("if_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_inspect_as (l_as: INSPECT_AS) is
		do
			indent := indent + 1
			put_name ("inspect_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_instr_call_as (l_as: INSTR_CALL_AS) is
		do
			indent := indent + 1
			put_name ("instr_call_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_loop_as (l_as: LOOP_AS) is
		do
			indent := indent + 1
			put_name ("loop_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_external_as (l_as: EXTERNAL_AS) is
		do
			indent := indent + 1
			put_name ("external_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_do_as (l_as: DO_AS) is
		do
			indent := indent + 1
			put_name ("do_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_once_as (l_as: ONCE_AS) is
		do
			indent := indent + 1
			put_name ("once_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_type_dec_as (l_as: TYPE_DEC_AS) is
		do
			indent := indent + 1
			put_name ("type_dec_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_class_as (l_as: CLASS_AS) is
		do
			indent := indent + 1
			put_name ("class_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_parent_as (l_as: PARENT_AS) is
		do
			indent := indent + 1
			put_name ("parent_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_like_id_as (l_as: LIKE_ID_AS) is
		do
			indent := indent + 1
			put_name ("like_id_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_like_cur_as (l_as: LIKE_CUR_AS) is
		do
			indent := indent + 1
			put_name ("like_cur_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_formal_as (l_as: FORMAL_AS) is
		do
			indent := indent + 1
			put_name ("formal_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_formal_dec_as (l_as: FORMAL_DEC_AS) is
		do
			indent := indent + 1
			put_name ("formal_dec_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_class_type_as (l_as: CLASS_TYPE_AS) is
		do
			indent := indent + 1
			put_name ("class_type_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
		do
			indent := indent + 1
			put_name ("named_tuple_type_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_none_type_as (l_as: NONE_TYPE_AS) is
		do
			indent := indent + 1
			put_name ("none_type_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bits_as (l_as: BITS_AS) is
		do
			indent := indent + 1
			put_name ("bits_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_bits_symbol_as (l_as: BITS_SYMBOL_AS) is
		do
			indent := indent + 1
			put_name ("bits_symbol_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_rename_as (l_as: RENAME_AS) is
		do
			indent := indent + 1
			put_name ("rename_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_invariant_as (l_as: INVARIANT_AS) is
		do
			indent := indent + 1
			put_name ("invariant_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_interval_as (l_as: INTERVAL_AS) is
		do
			indent := indent + 1
			put_name ("interval_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_index_as (l_as: INDEX_AS) is
		do
			indent := indent + 1
			put_name ("index_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_export_item_as (l_as: EXPORT_ITEM_AS) is
		do
			indent := indent + 1
			put_name ("export_item_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_elseif_as (l_as: ELSIF_AS) is
		do
			indent := indent + 1
			put_name ("elseif_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_create_as (l_as: CREATE_AS) is
		do
			indent := indent + 1
			put_name ("create_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_client_as (l_as: CLIENT_AS) is
		do
			indent := indent + 1
			put_name ("client_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_case_as (l_as: CASE_AS) is
		do
			indent := indent + 1
			put_name ("case_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_ensure_as (l_as: ENSURE_AS) is
		do
			indent := indent + 1
			put_name ("ensure_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS) is
		do
			indent := indent + 1
			put_name ("ensure_then_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_require_as (l_as: REQUIRE_AS) is
		do
			indent := indent + 1
			put_name ("require_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_require_else_as (l_as: REQUIRE_ELSE_AS) is
		do
			indent := indent + 1
			put_name ("require_else_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_convert_feat_as (l_as: CONVERT_FEAT_AS) is
		do
			indent := indent + 1
			put_name ("convert_feat_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_type_list_as (l_as: TYPE_LIST_AS) is
		do
			indent := indent + 1
			put_name ("type_list_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_type_dec_list_as (l_as: TYPE_DEC_LIST_AS) is
		do
			indent := indent + 1
			put_name ("type_dec_list_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_convert_feat_list_as (l_as: CONVERT_FEAT_LIST_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("convert_feat_list_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_class_list_as (l_as: CLASS_LIST_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("class_list_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_parent_list_as (l_as: PARENT_LIST_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("parent_list_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_local_dec_list_as (l_as: LOCAL_DEC_LIST_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("local_dec_list_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_formal_argu_dec_list_as (l_as: FORMAL_ARGU_DEC_LIST_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("formal_argu_dec_list_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_debug_key_list_as (l_as: DEBUG_KEY_LIST_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("debug_key_list_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_delayed_actual_list_as (l_as: DELAYED_ACTUAL_LIST_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("delayed_actual_list_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_parameter_list_as (l_as: PARAMETER_LIST_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("parameter_list_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_rename_clause_as (l_as: RENAME_CLAUSE_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("rename_clause_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_export_clause_as (l_as: EXPORT_CLAUSE_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("export_clause_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_undefine_clause_as (l_as: UNDEFINE_CLAUSE_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("undefine_clause_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_redefine_clause_as (l_as: REDEFINE_CLAUSE_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("redefine_clause_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_select_clause_as (l_as: SELECT_CLAUSE_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("select_clause_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_formal_generic_list_as (l_as: FORMAL_GENERIC_LIST_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("formal_generic_list_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_modify_as (l_as: MODIFY_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("modify_as")
			Precursor (l_as)
			indent := indent - 1
		end

	process_use_as (l_as: USE_AS) is
			-- Process `l_as'.
		do
			indent := indent + 1
			put_name ("use_as")
			Precursor (l_as)
			indent := indent - 1
		end

indexing
	copyright:	"Copyright (c) 2006, Bernd Schoeller and others"
	license:	"GPL version 2 or later"
	copying: "[

             This program is free software; you can redistribute it and/or
             modify it under the terms of the GNU General Public License as
             published by the Free Software Foundation; either version 2 of
             the License, or (at your option) any later version.
             
             This program is distributed in the hope that it will be useful,
             but WITHOUT ANY WARRANTY; without even the implied warranty of
             MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
             GNU General Public License for more details.
             
             You should have received a copy of the GNU General Public
             License along with this program; if not, write to the Free Software
             Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
             MA 02110-1301  USA

		]"

end
