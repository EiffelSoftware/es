note
	description: "Class that iterates an AST an check if only allowed AST nodes are traversed."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_EIFFEL_NODE_CHECKER

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

	EXT_CHECKER
		redefine
			passed_check
		end

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make
			-- Default initialization.
		do
			create internal_allow_set.make
			internal_allow_set.compare_objects

			passed_check := True
		end

feature -- Basic Operations

	check_ast (a_ast: AST_EIFFEL)
			-- Checks if `a_ast' conforms to the specified checks and
			-- and makes the result of the check available in `passed_check'.
		do
			passed_check := True
			a_ast.process (Current)
		end

feature -- Access

	passed_check: BOOLEAN
			-- The evaluation of the last iteration by this checker.

	node_name_set: LINKED_SET [STRING]
			-- Set of all AST node elment names that can be allowed / denied.
		once
			create Result.make
			Result.compare_objects
			Result.force ("access_assert_as")
			Result.force ("access_feat_as")
			Result.force ("access_id_as")
			Result.force ("access_inv_as")
			Result.force ("address_as")
			Result.force ("address_current_as")
			Result.force ("address_result_as")
			Result.force ("agent_routine_creation_as")
			Result.force ("all_as")
			Result.force ("array_as")
			Result.force ("assign_as")
			Result.force ("assigner_call_as")
			Result.force ("attribute_as")
			Result.force ("bang_creation_as")
			Result.force ("bang_creation_expr_as")
			Result.force ("bin_and_as")
			Result.force ("bin_and_then_as")
			Result.force ("bin_div_as")
			Result.force ("bin_eq_as")
			Result.force ("bin_free_as")
			Result.force ("bin_ge_as")
			Result.force ("bin_gt_as")
			Result.force ("bin_implies_as")
			Result.force ("bin_le_as")
			Result.force ("bin_lt_as")
			Result.force ("bin_minus_as")
			Result.force ("bin_mod_as")
			Result.force ("bin_ne_as")
			Result.force ("bin_not_tilde_as")
			Result.force ("bin_or_as")
			Result.force ("bin_or_else_as")
			Result.force ("bin_plus_as")
			Result.force ("bin_power_as")
			Result.force ("bin_slash_as")
			Result.force ("bin_star_as")
			Result.force ("bin_tilde_as")
			Result.force ("bin_xor_as")
			Result.force ("binary_as")
			Result.force ("bit_const_as")
			Result.force ("bits_as")
			Result.force ("bits_symbol_as")
			Result.force ("body_as")
			Result.force ("bool_as")
			Result.force ("bracket_as")
			Result.force ("break_as")
			Result.force ("built_in_as")
			Result.force ("case_as")
			Result.force ("char_as")
			Result.force ("check_as")
			Result.force ("class_as")
			Result.force ("class_list_as")
			Result.force ("class_type_as")
			Result.force ("client_as")
			Result.force ("constant_as")
			Result.force ("constraining_type_as")
			Result.force ("convert_feat_as")
			Result.force ("convert_feat_list_as")
			Result.force ("converted_expr_as")
			Result.force ("create_as")
			Result.force ("create_creation_as")
			Result.force ("create_creation_expr_as")
			Result.force ("creation_as")
			Result.force ("creation_expr_as")
			Result.force ("current_as")
			Result.force ("custom_attribute_as")
			Result.force ("debug_as")
			Result.force ("deferred_as")
			Result.force ("delayed_actual_list_as")
			Result.force ("do_as")
			Result.force ("eiffel_list")
			Result.force ("elseif_as")
			Result.force ("ensure_as")
			Result.force ("ensure_then_as")
			Result.force ("export_clause_as")
			Result.force ("export_item_as")
			Result.force ("expr_address_as")
			Result.force ("expr_call_as")
			Result.force ("external_as")
			Result.force ("external_lang_as")
			Result.force ("feat_name_id_as")
			Result.force ("feature_as")
			Result.force ("feature_clause_as")
			Result.force ("feature_list_as")
			Result.force ("feature_name_alias_as")
			Result.force ("for_all_as")
			Result.force ("formal_argu_dec_list_as")
			Result.force ("formal_as")
			Result.force ("formal_dec_as")
			Result.force ("formal_generic_list_as")
			Result.force ("generic_class_type_as")
			Result.force ("guard_as")
			Result.force ("id_as")
			Result.force ("if_as")
			Result.force ("index_as")
			Result.force ("indexing_clause_as")
			Result.force ("infix_prefix_as")
			Result.force ("inline_agent_creation_as")
			Result.force ("inspect_as")
			Result.force ("instr_call_as")
			Result.force ("integer_as")
			Result.force ("interval_as")
			Result.force ("invariant_as")
			Result.force ("iteration_as")
			Result.force ("key_list_as")
			Result.force ("keyword_as")
			Result.force ("keyword_stub_as")
			Result.force ("leaf_stub_as")
			Result.force ("like_cur_as")
			Result.force ("like_id_as")
			Result.force ("local_dec_list_as")
			Result.force ("loop_as")
			Result.force ("loop_expr_as")
			Result.force ("named_tuple_type_as")
			Result.force ("nested_as")
			Result.force ("nested_expr_as")
			Result.force ("none_id_as")
			Result.force ("none_type_as")
			Result.force ("object_test_as")
			Result.force ("once_as")
			Result.force ("operand_as")
			Result.force ("parameter_list_as")
			Result.force ("paran_as")
			Result.force ("parent_as")
			Result.force ("parent_list_as")
			Result.force ("precursor_as")
			Result.force ("qualified_anchored_type_as")
			Result.force ("real_as")
			Result.force ("redefine_clause_as")
			Result.force ("rename_as")
			Result.force ("rename_clause_as")
			Result.force ("require_as")
			Result.force ("require_else_as")
			Result.force ("result_as")
			Result.force ("retry_as")
			Result.force ("reverse_as")
			Result.force ("routine_as")
			Result.force ("routine_creation_as")
			Result.force ("select_clause_as")
			Result.force ("static_access_as")
			Result.force ("string_as")
			Result.force ("symbol_as")
			Result.force ("symbol_stub_as")
			Result.force ("tagged_as")
			Result.force ("there_exists_as")
			Result.force ("tuple_as")
			Result.force ("type_dec_as")
			Result.force ("type_dec_list_as")
			Result.force ("type_expr_as")
			Result.force ("type_list_as")
			Result.force ("typed_char_as")
			Result.force ("un_free_as")
			Result.force ("un_minus_as")
			Result.force ("un_not_as")
			Result.force ("un_old_as")
			Result.force ("un_plus_as")
			Result.force ("un_strip_as")
			Result.force ("unary_as")
			Result.force ("undefine_clause_as")
			Result.force ("unique_as")
			Result.force ("variant_as")
			Result.force ("verbatim_string_as")
			Result.force ("void_as")
		end

	allow_all
			-- Allow the traversal of all AST node elements.
		do
			across
				node_name_set as l_cursor
			loop
				allow_node (l_cursor.item)
			end
		end

	allow_node (a_name: STRING)
			-- Allow the traversal of an AST node elements denoted by `a_name'.
		do
			set_allow (a_name, True)
		end

	allow_set: like node_name_set
		do
			Result := internal_allow_set.twin
		end

	deny_all
			-- Deny the traversal of all AST node elements.			
		do
			across
				node_name_set as l_cursor
			loop
				deny_node (l_cursor.item)
			end
		end

	deny_node (a_name: STRING)
			-- Deny the traversal of an AST node elements denoted by `a_name'.
		do
			set_allow (a_name, False)
		end

	deny_set: like node_name_set
		do
			create Result.make
			Result.compare_objects

			Result.merge (node_name_set)
			Result.subtract (internal_allow_set)
		end

	set_allow (a_name: STRING; a_allow: BOOLEAN)
			-- Set if an AST node element denoted by `a_name' is allowed to occour during traversal.
		do
			if a_allow then
				internal_allow_set.force (a_name)
			else
				internal_allow_set.prune (a_name)
			end
		end

feature {NONE} -- Implementaton

	internal_allow_set: like node_name_set
			-- Set of all AST node names that were allowed.			

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

feature -- Roundtrip

	process_none_id_as (l_as: NONE_ID_AS)
		do
			if deny_set.has (node_none_id_as) then passed_check := False else Precursor (l_as) end
		end

	process_typed_char_as (l_as: TYPED_CHAR_AS)
		do
			if deny_set.has (node_typed_char_as) then passed_check := False else Precursor (l_as) end
		end

	process_agent_routine_creation_as (l_as: AGENT_ROUTINE_CREATION_AS)
		do
			if deny_set.has (node_agent_routine_creation_as) then passed_check := False else Precursor (l_as) end
		end

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		do
			if deny_set.has (node_inline_agent_creation_as) then passed_check := False else Precursor (l_as) end
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
		do
			if deny_set.has (node_create_creation_as) then passed_check := False else Precursor (l_as) end
		end

	process_bang_creation_as (l_as: BANG_CREATION_AS)
		do
			if deny_set.has (node_bang_creation_as) then passed_check := False else Precursor (l_as) end
		end

	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS)
		do
			if deny_set.has (node_create_creation_expr_as) then passed_check := False else Precursor (l_as) end
		end

	process_bang_creation_expr_as (l_as: BANG_CREATION_EXPR_AS)
		do
			if deny_set.has (node_bang_creation_expr_as) then passed_check := False else Precursor (l_as) end
		end

feature -- Roundtrip

	process_keyword_as (l_as: KEYWORD_AS)
		do
			if deny_set.has (node_keyword_as) then passed_check := False else Precursor (l_as) end
		end

	process_symbol_as (l_as: SYMBOL_AS)
		do
			if deny_set.has (node_symbol_as) then passed_check := False else Precursor (l_as) end
		end

	process_break_as (l_as: BREAK_AS)
		do
			if deny_set.has (node_break_as) then passed_check := False else Precursor (l_as) end
		end

	process_leaf_stub_as (l_as: LEAF_STUB_AS)
		do
			if deny_set.has (node_leaf_stub_as) then passed_check := False else Precursor (l_as) end
		end

	process_symbol_stub_as (l_as: SYMBOL_STUB_AS)
		do
			if deny_set.has (node_symbol_stub_as) then passed_check := False else Precursor (l_as) end
		end

	process_keyword_stub_as (l_as: KEYWORD_STUB_AS)
		do
			if deny_set.has (node_keyword_stub_as) then passed_check := False else Precursor (l_as) end
		end

feature {AST_EIFFEL} -- Helpers



feature {AST_EIFFEL} -- Skeleton Visitors

	process_custom_attribute_as (l_as: CUSTOM_ATTRIBUTE_AS)
		do
			if deny_set.has (node_custom_attribute_as) then passed_check := False else Precursor (l_as) end
		end

	process_id_as (l_as: ID_AS)
		do
			if deny_set.has (node_id_as) then passed_check := False else Precursor (l_as) end
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			if deny_set.has (node_integer_as) then passed_check := False else Precursor (l_as) end
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			if deny_set.has (node_static_access_as) then passed_check := False else Precursor (l_as) end
		end

	process_feature_clause_as (l_as: FEATURE_CLAUSE_AS)
		do
			if deny_set.has (node_feature_clause_as) then passed_check := False else Precursor (l_as) end
		end

	process_unique_as (l_as: UNIQUE_AS)
		do
			if deny_set.has (node_unique_as) then passed_check := False else Precursor (l_as) end
		end

	process_tuple_as (l_as: TUPLE_AS)
		do
			if deny_set.has (node_tuple_as) then passed_check := False else Precursor (l_as) end
		end

	process_real_as (l_as: REAL_AS)
		do
			if deny_set.has (node_real_as) then passed_check := False else Precursor (l_as) end
		end

	process_bool_as (l_as: BOOL_AS)
		do
			if deny_set.has (node_bool_as) then passed_check := False else Precursor (l_as) end
		end

	process_bit_const_as (l_as: BIT_CONST_AS)
		do
			if deny_set.has (node_bit_const_as) then passed_check := False else Precursor (l_as) end
		end

	process_array_as (l_as: ARRAY_AS)
		do
			if deny_set.has (node_array_as) then passed_check := False else Precursor (l_as) end
		end

	process_char_as (l_as: CHAR_AS)
		do
			if deny_set.has (node_char_as) then passed_check := False else Precursor (l_as) end
		end

	process_string_as (l_as: STRING_AS)
		do
			if deny_set.has (node_string_as) then passed_check := False else Precursor (l_as) end
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
		do
			if deny_set.has (node_verbatim_string_as) then passed_check := False else Precursor (l_as) end
		end

	process_body_as (l_as: BODY_AS)
		do
			if deny_set.has (node_body_as) then passed_check := False else Precursor (l_as) end
		end

	process_built_in_as (l_as: BUILT_IN_AS)
		do
			if deny_set.has (node_built_in_as) then passed_check := False else Precursor (l_as) end
		end

	process_result_as (l_as: RESULT_AS)
		do
			if deny_set.has (node_result_as) then passed_check := False else Precursor (l_as) end
		end

	process_current_as (l_as: CURRENT_AS)
		do
			if deny_set.has (node_current_as) then passed_check := False else Precursor (l_as) end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			if deny_set.has (node_access_feat_as) then passed_check := False else Precursor (l_as) end
		end

	process_access_inv_as (l_as: ACCESS_INV_AS)
		do
			if deny_set.has (node_access_inv_as) then passed_check := False else Precursor (l_as) end
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			if deny_set.has (node_access_id_as) then passed_check := False else Precursor (l_as) end
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
		do
			if deny_set.has (node_access_assert_as) then passed_check := False else Precursor (l_as) end
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		do
			if deny_set.has (node_precursor_as) then passed_check := False else Precursor (l_as) end
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			if deny_set.has (node_nested_expr_as) then passed_check := False else Precursor (l_as) end
		end

	process_nested_as (l_as: NESTED_AS)
		do
			if deny_set.has (node_nested_as) then passed_check := False else Precursor (l_as) end
		end

	process_creation_expr_as (l_as: CREATION_EXPR_AS)
		do
			if deny_set.has (node_creation_expr_as) then passed_check := False else Precursor (l_as) end
		end

	process_routine_as (l_as: ROUTINE_AS)
		do
			if deny_set.has (node_routine_as) then passed_check := False else Precursor (l_as) end
		end

	process_constant_as (l_as: CONSTANT_AS)
		do
			if deny_set.has (node_constant_as) then passed_check := False else Precursor (l_as) end
		end

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
		do
			if deny_set.has (node_eiffel_list) then passed_check := False else Precursor (l_as) end
		end

	process_indexing_clause_as (l_as: INDEXING_CLAUSE_AS)
		do
			if deny_set.has (node_indexing_clause_as) then passed_check := False else Precursor (l_as) end
		end

	process_infix_prefix_as (l_as: INFIX_PREFIX_AS)
		do
			if deny_set.has (node_infix_prefix_as) then passed_check := False else Precursor (l_as) end
		end

	process_feat_name_id_as (l_as: FEAT_NAME_ID_AS)
		do
			if deny_set.has (node_feat_name_id_as) then passed_check := False else Precursor (l_as) end
		end

	process_feature_name_alias_as (l_as: FEATURE_NAME_ALIAS_AS)
		do
			if deny_set.has (node_feature_name_alias_as) then passed_check := False else Precursor (l_as) end
		end

	process_feature_list_as (l_as: FEATURE_LIST_AS)
		do
			if deny_set.has (node_feature_list_as) then passed_check := False else Precursor (l_as) end
		end

	process_all_as (l_as: ALL_AS)
		do
			if deny_set.has (node_all_as) then passed_check := False else Precursor (l_as) end
		end

	process_attribute_as (l_as: ATTRIBUTE_AS)
		do
			if deny_set.has (node_attribute_as) then passed_check := False else Precursor (l_as) end
		end

	process_deferred_as (l_as: DEFERRED_AS)
		do
			if deny_set.has (node_deferred_as) then passed_check := False else Precursor (l_as) end
		end

	process_do_as (l_as: DO_AS)
		do
			if deny_set.has (node_do_as) then passed_check := False else Precursor (l_as) end
		end

	process_once_as (l_as: ONCE_AS)
		do
			if deny_set.has (node_once_as) then passed_check := False else Precursor (l_as) end
		end

	process_type_dec_as (l_as: TYPE_DEC_AS)
		do
			if deny_set.has (node_type_dec_as) then passed_check := False else Precursor (l_as) end
		end

	process_parent_as (l_as: PARENT_AS)
		do
			if deny_set.has (node_parent_as) then passed_check := False else Precursor (l_as) end
		end

	process_like_id_as (l_as: LIKE_ID_AS)
		do
			if deny_set.has (node_like_id_as) then passed_check := False else Precursor (l_as) end
		end

	process_like_cur_as (l_as: LIKE_CUR_AS)
		do
			if deny_set.has (node_like_cur_as) then passed_check := False else Precursor (l_as) end
		end

	process_qualified_anchored_type_as (l_as: QUALIFIED_ANCHORED_TYPE_AS)
		do
			if deny_set.has (node_qualified_anchored_type_as) then passed_check := False else Precursor (l_as) end
		end

	process_formal_dec_as (l_as: FORMAL_DEC_AS)
		do
			if deny_set.has (node_formal_dec_as) then passed_check := False else Precursor (l_as) end
		end

	process_constraining_type_as (l_as: CONSTRAINING_TYPE_AS)
		do
			if deny_set.has (node_constraining_type_as) then passed_check := False else Precursor (l_as) end
		end

	process_none_type_as (l_as: NONE_TYPE_AS)
		do
			if deny_set.has (node_none_type_as) then passed_check := False else Precursor (l_as) end
		end

	process_bits_as (l_as: BITS_AS)
		do
			if deny_set.has (node_bits_as) then passed_check := False else Precursor (l_as) end
		end

	process_bits_symbol_as (l_as: BITS_SYMBOL_AS)
		do
			if deny_set.has (node_bits_symbol_as) then passed_check := False else Precursor (l_as) end
		end

	process_rename_as (l_as: RENAME_AS)
		do
			if deny_set.has (node_rename_as) then passed_check := False else Precursor (l_as) end
		end

	process_invariant_as (l_as: INVARIANT_AS)
		do
			if deny_set.has (node_invariant_as) then passed_check := False else Precursor (l_as) end
		end

	process_index_as (l_as: INDEX_AS)
		do
			if deny_set.has (node_index_as) then passed_check := False else Precursor (l_as) end
		end

	process_export_item_as (l_as: EXPORT_ITEM_AS)
		do
			if deny_set.has (node_export_item_as) then passed_check := False else Precursor (l_as) end
		end

	process_create_as (l_as: CREATE_AS)
		do
			if deny_set.has (node_create_as) then passed_check := False else Precursor (l_as) end
		end

	process_client_as (l_as: CLIENT_AS)
		do
			if deny_set.has (node_client_as) then passed_check := False else Precursor (l_as) end
		end

	process_ensure_as (l_as: ENSURE_AS)
		do
			if deny_set.has (node_ensure_as) then passed_check := False else Precursor (l_as) end
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS)
		do
			if deny_set.has (node_ensure_then_as) then passed_check := False else Precursor (l_as) end
		end

	process_require_as (l_as: REQUIRE_AS)
		do
			if deny_set.has (node_require_as) then passed_check := False else Precursor (l_as) end
		end

	process_require_else_as (l_as: REQUIRE_ELSE_AS)
		do
			if deny_set.has (node_require_else_as) then passed_check := False else Precursor (l_as) end
		end

	process_convert_feat_as (l_as: CONVERT_FEAT_AS)
		do
			if deny_set.has (node_convert_feat_as) then passed_check := False else Precursor (l_as) end
		end

	process_convert_feat_list_as (l_as: CONVERT_FEAT_LIST_AS)
		do
			if deny_set.has (node_convert_feat_list_as) then passed_check := False else Precursor (l_as) end
		end

	process_class_list_as (l_as: CLASS_LIST_AS)
		do
			if deny_set.has (node_class_list_as) then passed_check := False else Precursor (l_as) end
		end

	process_parent_list_as (l_as: PARENT_LIST_AS)
		do
			if deny_set.has (node_parent_list_as) then passed_check := False else Precursor (l_as) end
		end

	process_local_dec_list_as (l_as: LOCAL_DEC_LIST_AS)
		do
			if deny_set.has (node_local_dec_list_as) then passed_check := False else Precursor (l_as) end
		end

	process_formal_argu_dec_list_as (l_as: FORMAL_ARGU_DEC_LIST_AS)
		do
			if deny_set.has (node_formal_argu_dec_list_as) then passed_check := False else Precursor (l_as) end
		end

	process_key_list_as (l_as: KEY_LIST_AS)
		do
			if deny_set.has (node_key_list_as) then passed_check := False else Precursor (l_as) end
		end

	process_delayed_actual_list_as (l_as: DELAYED_ACTUAL_LIST_AS)
		do
			if deny_set.has (node_delayed_actual_list_as) then passed_check := False else Precursor (l_as) end
		end

	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
		do
			if deny_set.has (node_parameter_list_as) then passed_check := False else Precursor (l_as) end
		end

	process_rename_clause_as (l_as: RENAME_CLAUSE_AS)
		do
			if deny_set.has (node_rename_clause_as) then passed_check := False else Precursor (l_as) end
		end

	process_export_clause_as (l_as: EXPORT_CLAUSE_AS)
		do
			if deny_set.has (node_export_clause_as) then passed_check := False else Precursor (l_as) end
		end

	process_undefine_clause_as (l_as: UNDEFINE_CLAUSE_AS)
		do
			if deny_set.has (node_undefine_clause_as) then passed_check := False else Precursor (l_as) end
		end

	process_redefine_clause_as (l_as: REDEFINE_CLAUSE_AS)
		do
			if deny_set.has (node_redefine_clause_as) then passed_check := False else Precursor (l_as) end
		end

	process_select_clause_as (l_as: SELECT_CLAUSE_AS)
		do
			if deny_set.has (node_select_clause_as) then passed_check := False else Precursor (l_as) end
		end

	process_formal_generic_list_as (l_as: FORMAL_GENERIC_LIST_AS)
		do
			if deny_set.has (node_formal_generic_list_as) then passed_check := False else Precursor (l_as) end
		end

	process_iteration_as (l_as: ITERATION_AS)
		do
			if deny_set.has (node_iteration_as) then passed_check := False else Precursor (l_as) end
		end

feature {AST_EIFFEL} -- Expressions visitors

	process_tagged_as (l_as: TAGGED_AS)
		do
			if deny_set.has (node_tagged_as) then passed_check := False else Precursor (l_as) end
		end

	process_variant_as (l_as: VARIANT_AS)
		do
			if deny_set.has (node_variant_as) then passed_check := False else Precursor (l_as) end
		end

	process_un_strip_as (l_as: UN_STRIP_AS)
		do
			if deny_set.has (node_un_strip_as) then passed_check := False else Precursor (l_as) end
		end

	process_converted_expr_as (l_as: CONVERTED_EXPR_AS)
		do
			if deny_set.has (node_converted_expr_as) then passed_check := False else Precursor (l_as) end
		end

	process_paran_as (l_as: PARAN_AS)
		do
			if deny_set.has (node_paran_as) then passed_check := False else Precursor (l_as) end
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			if deny_set.has (node_expr_call_as) then passed_check := False else Precursor (l_as) end
		end

	process_expr_address_as (l_as: EXPR_ADDRESS_AS)
		do
			if deny_set.has (node_expr_address_as) then passed_check := False else Precursor (l_as) end
		end

	process_address_result_as (l_as: ADDRESS_RESULT_AS)
		do
			if deny_set.has (node_address_result_as) then passed_check := False else Precursor (l_as) end
		end

	process_address_current_as (l_as: ADDRESS_CURRENT_AS)
		do
			if deny_set.has (node_address_current_as) then passed_check := False else Precursor (l_as) end
		end

	process_address_as (l_as: ADDRESS_AS)
		do
			if deny_set.has (node_address_as) then passed_check := False else Precursor (l_as) end
		end

	process_type_expr_as (l_as: TYPE_EXPR_AS)
		do
			if deny_set.has (node_type_expr_as) then passed_check := False else Precursor (l_as) end
		end

	process_routine_creation_as (l_as: ROUTINE_CREATION_AS)
		do
			if deny_set.has (node_routine_creation_as) then passed_check := False else Precursor (l_as) end
		end

	process_un_free_as (l_as: UN_FREE_AS)
		do
			if deny_set.has (node_un_free_as) then passed_check := False else Precursor (l_as) end
		end

	process_un_minus_as (l_as: UN_MINUS_AS)
		do
			if deny_set.has (node_un_minus_as) then passed_check := False else Precursor (l_as) end
		end

	process_un_not_as (l_as: UN_NOT_AS)
		do
			if deny_set.has (node_un_not_as) then passed_check := False else Precursor (l_as) end
		end

	process_un_old_as (l_as: UN_OLD_AS)
		do
			if deny_set.has (node_un_old_as) then passed_check := False else Precursor (l_as) end
		end

	process_un_plus_as (l_as: UN_PLUS_AS)
		do
			if deny_set.has (node_un_plus_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_and_then_as (l_as: BIN_AND_THEN_AS)
		do
			if deny_set.has (node_bin_and_then_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_free_as (l_as: BIN_FREE_AS)
		do
			if deny_set.has (node_bin_free_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_implies_as (l_as: BIN_IMPLIES_AS)
		do
			if deny_set.has (node_bin_implies_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_or_as (l_as: BIN_OR_AS)
		do
			if deny_set.has (node_bin_or_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_or_else_as (l_as: BIN_OR_ELSE_AS)
		do
			if deny_set.has (node_bin_or_else_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_xor_as (l_as: BIN_XOR_AS)
		do
			if deny_set.has (node_bin_xor_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_ge_as (l_as: BIN_GE_AS)
		do
			if deny_set.has (node_bin_ge_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_gt_as (l_as: BIN_GT_AS)
		do
			if deny_set.has (node_bin_gt_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_le_as (l_as: BIN_LE_AS)
		do
			if deny_set.has (node_bin_le_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_lt_as (l_as: BIN_LT_AS)
		do
			if deny_set.has (node_bin_lt_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_div_as (l_as: BIN_DIV_AS)
		do
			if deny_set.has (node_bin_div_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_minus_as (l_as: BIN_MINUS_AS)
		do
			if deny_set.has (node_bin_minus_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_mod_as (l_as: BIN_MOD_AS)
		do
			if deny_set.has (node_bin_mod_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_plus_as (l_as: BIN_PLUS_AS)
		do
			if deny_set.has (node_bin_plus_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_power_as (l_as: BIN_POWER_AS)
		do
			if deny_set.has (node_bin_power_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_slash_as (l_as: BIN_SLASH_AS)
		do
			if deny_set.has (node_bin_slash_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_star_as (l_as: BIN_STAR_AS)
		do
			if deny_set.has (node_bin_star_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_and_as (l_as: BIN_AND_AS)
		do
			if deny_set.has (node_bin_and_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_eq_as (l_as: BIN_EQ_AS)
		do
			if deny_set.has (node_bin_eq_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_ne_as (l_as: BIN_NE_AS)
		do
			if deny_set.has (node_bin_ne_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_tilde_as (l_as: BIN_TILDE_AS)
		do
			if deny_set.has (node_bin_tilde_as) then passed_check := False else Precursor (l_as) end
		end

	process_bin_not_tilde_as (l_as: BIN_NOT_TILDE_AS)
		do
			if deny_set.has (node_bin_not_tilde_as) then passed_check := False else Precursor (l_as) end
		end

	process_bracket_as (l_as: BRACKET_AS)
		do
			if deny_set.has (node_bracket_as) then passed_check := False else Precursor (l_as) end
		end

	process_operand_as (l_as: OPERAND_AS)
		do
			if deny_set.has (node_operand_as) then passed_check := False else Precursor (l_as) end
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			if deny_set.has (node_object_test_as) then passed_check := False else Precursor (l_as) end
		end

	process_loop_expr_as (l_as: LOOP_EXPR_AS)
		do
			if deny_set.has (node_loop_expr_as) then passed_check := False else Precursor (l_as) end
		end

	process_void_as (l_as: VOID_AS)
		do
			if deny_set.has (node_void_as) then passed_check := False else Precursor (l_as) end
		end

	process_unary_as (l_as: UNARY_AS)
		do
			if deny_set.has (node_unary_as) then passed_check := False else Precursor (l_as) end
		end

	process_binary_as (l_as: BINARY_AS)
		do
			if deny_set.has (node_binary_as) then passed_check := False else Precursor (l_as) end
		end

feature {AST_EIFFEL} -- Instructions visitors

	process_elseif_as (l_as: ELSIF_AS)
		do
			if deny_set.has (node_elseif_as) then passed_check := False else Precursor (l_as) end
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			if deny_set.has (node_assign_as) then passed_check := False else Precursor (l_as) end
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			if deny_set.has (node_assigner_call_as) then passed_check := False else Precursor (l_as) end
		end

	process_case_as (l_as: CASE_AS)
		do
			if deny_set.has (node_case_as) then passed_check := False else Precursor (l_as) end
		end

	process_check_as (l_as: CHECK_AS)
		do
			if deny_set.has (node_check_as) then passed_check := False else Precursor (l_as) end
		end

	process_creation_as (l_as: CREATION_AS)
		do
			if deny_set.has (node_creation_as) then passed_check := False else Precursor (l_as) end
		end

	process_debug_as (l_as: DEBUG_AS)
		do
			if deny_set.has (node_debug_as) then passed_check := False else Precursor (l_as) end
		end

	process_guard_as (l_as: GUARD_AS)
		do
			if deny_set.has (node_guard_as) then passed_check := False else Precursor (l_as) end
		end

	process_if_as (l_as: IF_AS)
		do
			if deny_set.has (node_if_as) then passed_check := False else Precursor (l_as) end
		end

	process_inspect_as (l_as: INSPECT_AS)
		do
			if deny_set.has (node_inspect_as) then passed_check := False else Precursor (l_as) end
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			if deny_set.has (node_instr_call_as) then passed_check := False else Precursor (l_as) end
		end

	process_interval_as (l_as: INTERVAL_AS)
		do
			if deny_set.has (node_interval_as) then passed_check := False else Precursor (l_as) end
		end

	process_loop_as (l_as: LOOP_AS)
		do
			if deny_set.has (node_loop_as) then passed_check := False else Precursor (l_as) end
		end

	process_retry_as (l_as: RETRY_AS)
		do
			if deny_set.has (node_retry_as) then passed_check := False else Precursor (l_as) end
		end

	process_reverse_as (l_as: REVERSE_AS)
		do
			if deny_set.has (node_reverse_as) then passed_check := False else Precursor (l_as) end
		end

feature {AST_EIFFEL} -- External visitors

	process_external_as (l_as: EXTERNAL_AS)
		do
			if deny_set.has (node_external_as) then passed_check := False else Precursor (l_as) end
		end

	process_external_lang_as (l_as: EXTERNAL_LANG_AS)
		do
			if deny_set.has (node_external_lang_as) then passed_check := False else Precursor (l_as) end
		end

feature {AST_EIFFEL} -- Clickable visitor

	process_class_as (l_as: CLASS_AS)
		do
			if deny_set.has (node_class_as) then passed_check := False else Precursor (l_as) end
		end

	process_class_type_as (l_as: CLASS_TYPE_AS)
		do
			if deny_set.has (node_class_type_as) then passed_check := False else Precursor (l_as) end
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS)
		do
			if deny_set.has (node_generic_class_type_as) then passed_check := False else Precursor (l_as) end
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS)
		do
			if deny_set.has (node_named_tuple_type_as) then passed_check := False else Precursor (l_as) end
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			if deny_set.has (node_feature_as) then passed_check := False else Precursor (l_as) end
		end

	process_formal_as (l_as: FORMAL_AS)
		do
			if deny_set.has (node_formal_as) then passed_check := False else Precursor (l_as) end
		end

	process_type_list_as (l_as: TYPE_LIST_AS)
		do
			if deny_set.has (node_type_list_as) then passed_check := False else Precursor (l_as) end
		end

	process_type_dec_list_as (l_as: TYPE_DEC_LIST_AS)
		do
			if deny_set.has (node_type_dec_list_as) then passed_check := False else Precursor (l_as) end
		end

feature -- Quantification

	process_there_exists_as (l_as: THERE_EXISTS_AS)
		do
			if deny_set.has (node_there_exists_as) then passed_check := False else Precursor (l_as) end
		end

	process_for_all_as (l_as: FOR_ALL_AS)
		do
			if deny_set.has (node_for_all_as) then passed_check := False else Precursor (l_as) end
		end

end
