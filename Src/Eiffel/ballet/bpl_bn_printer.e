indexing
	description: "Print an ASCII representation of the byte node tree of the current class"
	author: "Bernd Schoeller"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_BN_PRINTER

inherit
	BPL_BN_ITERATOR
		redefine
			process_access_expr_b,
			process_address_b,
			process_argument_b,
			process_array_const_b,
			process_assert_b,
			process_assign_b,
			process_attribute_b,
			process_bin_and_b,
			process_bin_and_then_b,
			process_bin_div_b,
			process_bin_eq_b,
			process_bin_free_b,
			process_bin_ge_b,
			process_bin_gt_b,
			process_bin_implies_b,
			process_bin_le_b,
			process_bin_lt_b,
			process_bin_minus_b,
			process_bin_mod_b,
			process_bin_ne_b,
			process_bin_or_b,
			process_bin_or_else_b,
			process_bin_plus_b,
			process_bin_power_b,
			process_bin_slash_b,
			process_bin_star_b,
			process_bin_xor_b,
			process_bit_const_b,
			process_bool_const_b,
			process_byte_list,
			process_case_b,
			process_char_const_b,
			process_char_val_b,
			process_check_b,
			process_constant_b,
			process_creation_expr_b,
			process_current_b,
			process_custom_attribute_b,
			process_debug_b,
			process_elsif_b,
			process_expr_address_b,
			process_external_b,
			process_feature_b,
			process_frame_b,
			process_agent_call_b,
			process_formal_conversion_b,
			process_hector_b,
			process_if_b,
			process_inspect_b,
			process_instr_call_b,
			process_instr_list_b,
			process_int64_val_b,
			process_int_val_b,
			process_integer_constant,
			process_inv_assert_b,
			process_invariant_b,
			process_local_b,
			process_loop_b,
			process_nat64_val_b,
			process_nat_val_b,
			process_nested_b,
			process_once_string_b,
			process_operand_b,
			process_parameter_b,
			process_paran_b,
			process_real_const_b,
			process_require_b,
			process_result_b,
			process_retry_b,
			process_reverse_b,
			process_routine_creation_b,
			process_string_b,
			process_strip_b,
			process_tuple_access_b,
			process_tuple_const_b,
			process_type_expr_b,
			process_typed_interval_b,
			process_un_free_b,
			process_un_minus_b,
			process_un_not_b,
			process_un_old_b,
			process_un_plus_b,
			process_variant_b,
			process_void_b,
			process_feature_i,
			process_feature_without_code
		end

	SHARED_BPL_ENVIRONMENT

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

	process_feature_i (a_feature: FEATURE_I) is
			-- Print feature name
		do
			bpl_out ("// Feature: ")
			bpl_out (a_feature.feature_name)
			bpl_out (" of ")
			bpl_out (a_feature.written_class.name)
			if a_feature.written_in = 1 then
				bpl_out (" (ignored)")
			end
			bpl_out ("%N")
			if a_feature.written_in /= 1 then
				Precursor {BPL_BN_ITERATOR}(a_feature)
			end
		end

	process_feature_without_code (a_feature: FEATURE_I) is
			-- There is no code for `a_feature'.
		do
			bpl_out ("// No BYTE_CODE for feature ")
			bpl_out (a_feature.feature_name)
			bpl_out (" of ")
			bpl_out (a_feature.written_class.name)
			bpl_out ("%N")
		end


feature {BYTE_NODE} -- Visitors

	process_access_expr_b (a_node: ACCESS_EXPR_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("access_expr_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_address_b (a_node: ADDRESS_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("address_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_argument_b (a_node: ARGUMENT_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("argument_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_array_const_b (a_node: ARRAY_CONST_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("array_const_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_assert_b (a_node: ASSERT_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("assert_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_assign_b (a_node: ASSIGN_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("assign_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_attribute_b (a_node: ATTRIBUTE_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("attribute_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_and_b (a_node: BIN_AND_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_and_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_and_then_b (a_node: B_AND_THEN_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_and_then_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_div_b (a_node: BIN_DIV_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_div_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_eq_b (a_node: BIN_EQ_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_eq_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_free_b (a_node: BIN_FREE_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_free_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_ge_b (a_node: BIN_GE_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_ge_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_gt_b (a_node: BIN_GT_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_gt_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_implies_b (a_node: B_IMPLIES_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_implies_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_le_b (a_node: BIN_LE_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_le_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_lt_b (a_node: BIN_LT_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_lt_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_minus_b (a_node: BIN_MINUS_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_minus_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_mod_b (a_node: BIN_MOD_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_mod_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_ne_b (a_node: BIN_NE_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_ne_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_or_b (a_node: BIN_OR_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_or_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_or_else_b (a_node: B_OR_ELSE_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_or_else_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_plus_b (a_node: BIN_PLUS_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_plus_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_power_b (a_node: BIN_POWER_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_power_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_slash_b (a_node: BIN_SLASH_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_slash_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_star_b (a_node: BIN_STAR_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_star_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bin_xor_b (a_node: BIN_XOR_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bin_xor_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bit_const_b (a_node: BIT_CONST_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bit_const_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_bool_const_b (a_node: BOOL_CONST_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("bool_const_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_byte_list (a_node: BYTE_LIST [BYTE_NODE]) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("byte_list")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_case_b (a_node: CASE_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("case_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_char_const_b (a_node: CHAR_CONST_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("char_const_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_char_val_b (a_node: CHAR_VAL_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("char_val_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_check_b (a_node: CHECK_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("check_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_constant_b (a_node: CONSTANT_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("constant_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_creation_expr_b (a_node: CREATION_EXPR_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("creation_expr_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_current_b (a_node: CURRENT_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("current_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_custom_attribute_b (a_node: CUSTOM_ATTRIBUTE_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("custom_attribute_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_debug_b (a_node: DEBUG_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("debug_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_elsif_b (a_node: ELSIF_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("elsif_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_expr_address_b (a_node: EXPR_ADDRESS_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("expr_address_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_external_b (a_node: EXTERNAL_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("external_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_feature_b (a_node: FEATURE_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("feature_b ("+a_node.feature_name+" of ClassID: "+	a_node.written_in.out+")")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_frame_b (a_node: FRAME_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("frame_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_agent_call_b (a_node: AGENT_CALL_B) is
		do
			indent := indent + 1
			put_name ("agent_call_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_formal_conversion_b (a_node: FORMAL_CONVERSION_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("formal_conversion_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_hector_b (a_node: HECTOR_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("hector_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_if_b (a_node: IF_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("if_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_inspect_b (a_node: INSPECT_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("inspect_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_instr_call_b (a_node: INSTR_CALL_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("instr_call_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_instr_list_b (a_node: INSTR_LIST_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("instr_list_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_int64_val_b (a_node: INT64_VAL_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("int64_val_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_int_val_b (a_node: INT_VAL_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("int_val_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_integer_constant (a_node: INTEGER_CONSTANT) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("integer_constant")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_inv_assert_b (a_node: INV_ASSERT_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("inv_assert_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_invariant_b (a_node: INVARIANT_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("invariant_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_local_b (a_node: LOCAL_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("local_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_loop_b (a_node: LOOP_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("loop_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_nat64_val_b (a_node: NAT64_VAL_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("nat64_val_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_nat_val_b (a_node: NAT_VAL_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("nat_val_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_nested_b (a_node: NESTED_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("nested_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_once_string_b (a_node: ONCE_STRING_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("once_string_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_operand_b (a_node: OPERAND_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("operand_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_parameter_b (a_node: PARAMETER_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("parameter_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_paran_b (a_node: PARAN_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("paran_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_real_const_b (a_node: REAL_CONST_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("real_const_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_require_b (a_node: REQUIRE_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("require_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_result_b (a_node: RESULT_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("result_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_retry_b (a_node: RETRY_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("retry_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_reverse_b (a_node: REVERSE_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("reverse_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_routine_creation_b (a_node: ROUTINE_CREATION_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("routine_creation_b")
			-- TODO: Do not understand this
			indent := indent - 1
		end

	process_string_b (a_node: STRING_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("string_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_strip_b (a_node: STRIP_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("strip_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_tuple_access_b (a_node: TUPLE_ACCESS_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("tuple_access_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_tuple_const_b (a_node: TUPLE_CONST_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("tuple_const_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_type_expr_b (a_node: TYPE_EXPR_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("type_expr_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_typed_interval_b (a_node: TYPED_INTERVAL_B [INTERVAL_VAL_B]) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("typed_interval_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_un_free_b (a_node: UN_FREE_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("un_free_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_un_minus_b (a_node: UN_MINUS_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("un_minus_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_un_not_b (a_node: UN_NOT_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("un_not_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_un_old_b (a_node: UN_OLD_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("un_old_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_un_plus_b (a_node: UN_PLUS_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("un_plus_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_variant_b (a_node: VARIANT_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("variant_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

	process_void_b (a_node: VOID_B) is
			-- Process `a_node'.
		do
			indent := indent + 1
			put_name ("void_b")
			Precursor {BPL_BN_ITERATOR}(a_node)
			indent := indent - 1
		end

end
