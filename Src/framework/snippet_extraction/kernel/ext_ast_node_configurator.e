note
	description: "Configurator to allow / deny certain AST nodes defined in `{EXT_AST_NODE_CONSTANTS}'."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EXT_AST_NODE_CONFIGURATOR

inherit
	EXT_AST_NODE_CONSTANTS

feature {NONE} -- Initialization

	initialize_ast_node_configurator
			-- Default initialization.
		do
			create internal_allow_set.make_equal (127)
		end

feature -- Access

	node_name_set: DS_HASH_SET [STRING]
			-- Set of all AST node elment names that can be allowed / denied.
		once
			create Result.make_equal (127)
			Result.force (node_access_assert_as)
			Result.force (node_access_feat_as)
			Result.force (node_access_id_as)
			Result.force (node_access_inv_as)
			Result.force (node_address_as)
			Result.force (node_address_current_as)
			Result.force (node_address_result_as)
			Result.force (node_agent_routine_creation_as)
			Result.force (node_all_as)
			Result.force (node_array_as)
			Result.force (node_assign_as)
			Result.force (node_assigner_call_as)
			Result.force (node_attribute_as)
			Result.force (node_bang_creation_as)
			Result.force (node_bang_creation_expr_as)
			Result.force (node_bin_and_as)
			Result.force (node_bin_and_then_as)
			Result.force (node_bin_div_as)
			Result.force (node_bin_eq_as)
			Result.force (node_bin_free_as)
			Result.force (node_bin_ge_as)
			Result.force (node_bin_gt_as)
			Result.force (node_bin_implies_as)
			Result.force (node_bin_le_as)
			Result.force (node_bin_lt_as)
			Result.force (node_bin_minus_as)
			Result.force (node_bin_mod_as)
			Result.force (node_bin_ne_as)
			Result.force (node_bin_not_tilde_as)
			Result.force (node_bin_or_as)
			Result.force (node_bin_or_else_as)
			Result.force (node_bin_plus_as)
			Result.force (node_bin_power_as)
			Result.force (node_bin_slash_as)
			Result.force (node_bin_star_as)
			Result.force (node_bin_tilde_as)
			Result.force (node_bin_xor_as)
			Result.force (node_binary_as)
			Result.force (node_bit_const_as)
			Result.force (node_bits_as)
			Result.force (node_bits_symbol_as)
			Result.force (node_body_as)
			Result.force (node_bool_as)
			Result.force (node_bracket_as)
			Result.force (node_break_as)
			Result.force (node_built_in_as)
			Result.force (node_case_as)
			Result.force (node_char_as)
			Result.force (node_check_as)
			Result.force (node_class_as)
			Result.force (node_class_list_as)
			Result.force (node_class_type_as)
			Result.force (node_client_as)
			Result.force (node_constant_as)
			Result.force (node_constraining_type_as)
			Result.force (node_convert_feat_as)
			Result.force (node_convert_feat_list_as)
			Result.force (node_converted_expr_as)
			Result.force (node_create_as)
			Result.force (node_create_creation_as)
			Result.force (node_create_creation_expr_as)
			Result.force (node_creation_as)
			Result.force (node_creation_expr_as)
			Result.force (node_current_as)
			Result.force (node_custom_attribute_as)
			Result.force (node_debug_as)
			Result.force (node_deferred_as)
			Result.force (node_delayed_actual_list_as)
			Result.force (node_do_as)
			Result.force (node_eiffel_list)
			Result.force (node_elseif_as)
			Result.force (node_ensure_as)
			Result.force (node_ensure_then_as)
			Result.force (node_export_clause_as)
			Result.force (node_export_item_as)
			Result.force (node_expr_address_as)
			Result.force (node_expr_call_as)
			Result.force (node_external_as)
			Result.force (node_external_lang_as)
			Result.force (node_feat_name_id_as)
			Result.force (node_feature_as)
			Result.force (node_feature_clause_as)
			Result.force (node_feature_list_as)
			Result.force (node_feature_name_alias_as)
			Result.force (node_for_all_as)
			Result.force (node_formal_argu_dec_list_as)
			Result.force (node_formal_as)
			Result.force (node_formal_dec_as)
			Result.force (node_formal_generic_list_as)
			Result.force (node_generic_class_type_as)
			Result.force (node_guard_as)
			Result.force (node_id_as)
			Result.force (node_if_as)
			Result.force (node_index_as)
			Result.force (node_indexing_clause_as)
			Result.force (node_infix_prefix_as)
			Result.force (node_inline_agent_creation_as)
			Result.force (node_inspect_as)
			Result.force (node_instr_call_as)
			Result.force (node_integer_as)
			Result.force (node_interval_as)
			Result.force (node_invariant_as)
			Result.force (node_iteration_as)
			Result.force (node_key_list_as)
			Result.force (node_keyword_as)
			Result.force (node_keyword_stub_as)
			Result.force (node_leaf_stub_as)
			Result.force (node_like_cur_as)
			Result.force (node_like_id_as)
			Result.force (node_local_dec_list_as)
			Result.force (node_loop_as)
			Result.force (node_loop_expr_as)
			Result.force (node_named_tuple_type_as)
			Result.force (node_nested_as)
			Result.force (node_nested_expr_as)
			Result.force (node_none_id_as)
			Result.force (node_none_type_as)
			Result.force (node_object_test_as)
			Result.force (node_once_as)
			Result.force (node_operand_as)
			Result.force (node_parameter_list_as)
			Result.force (node_paran_as)
			Result.force (node_parent_as)
			Result.force (node_parent_list_as)
			Result.force (node_precursor_as)
			Result.force (node_qualified_anchored_type_as)
			Result.force (node_real_as)
			Result.force (node_redefine_clause_as)
			Result.force (node_rename_as)
			Result.force (node_rename_clause_as)
			Result.force (node_require_as)
			Result.force (node_require_else_as)
			Result.force (node_result_as)
			Result.force (node_retry_as)
			Result.force (node_reverse_as)
			Result.force (node_routine_as)
			Result.force (node_routine_creation_as)
			Result.force (node_select_clause_as)
			Result.force (node_static_access_as)
			Result.force (node_string_as)
			Result.force (node_symbol_as)
			Result.force (node_symbol_stub_as)
			Result.force (node_tagged_as)
			Result.force (node_there_exists_as)
			Result.force (node_tuple_as)
			Result.force (node_type_dec_as)
			Result.force (node_type_dec_list_as)
			Result.force (node_type_expr_as)
			Result.force (node_type_list_as)
			Result.force (node_typed_char_as)
			Result.force (node_un_free_as)
			Result.force (node_un_minus_as)
			Result.force (node_un_not_as)
			Result.force (node_un_old_as)
			Result.force (node_un_plus_as)
			Result.force (node_un_strip_as)
			Result.force (node_unary_as)
			Result.force (node_undefine_clause_as)
			Result.force (node_unique_as)
			Result.force (node_variant_as)
			Result.force (node_verbatim_string_as)
			Result.force (node_void_as)
		end

	allow_all
			-- Allow the traversal of all AST node elements.
		do
			from
				node_name_set.start
			until
				node_name_set.after
			loop
				allow_node (node_name_set.item_for_iteration)
				node_name_set.forth
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
			from
				node_name_set.start
			until
				node_name_set.after
			loop
				deny_node (node_name_set.item_for_iteration)
				node_name_set.forth
			end
		end

	deny_node (a_name: STRING)
			-- Deny the traversal of an AST node elements denoted by `a_name'.
		do
			set_allow (a_name, False)
		end

	deny_set: like node_name_set
		do
			create Result.make_equal (127)

			Result.merge (node_name_set)
			Result.subtract (internal_allow_set)
		end

	set_allow (a_name: STRING; a_allow: BOOLEAN)
			-- Set if an AST node element denoted by `a_name' is allowed to occour during traversal.
		do
			if a_allow then
				internal_allow_set.force (a_name)
			else
				internal_allow_set.remove (a_name)
			end
		end

feature {NONE} -- Implementaton

	internal_allow_set: like node_name_set
			-- Set of all AST node names that were allowed.	

end
