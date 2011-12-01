note
	description: "Prints an AST as XML while depending purely on structure information (no matchlist needed)."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_XML_FROM_AST_TRANSFORMER

inherit
	ETR_AST_STRUCTURE_PRINTER
		export
			{AST_EIFFEL} all
		redefine
				-- AST Iterator
			process_bool_as,
			process_char_as,
			process_typed_char_as,
			process_result_as,
			process_retry_as,
			process_unique_as,
			process_deferred_as,
			process_void_as,
			process_string_as,
			process_verbatim_string_as,
			process_current_as,
			process_integer_as,
			process_real_as,
			process_id_as,
			process_access_feat_as,
			process_access_id_as,
			process_paran_as,
			process_binary_as,
			process_unary_as,
			process_nested_as,
			process_if_as,
			process_elseif_as,
			process_loop_as,
			process_tagged_as,
			process_class_as,
			process_feature_clause_as,
			process_class_list_as,
			process_feature_as,
			process_body_as,
			process_type_dec_as,
			process_feat_name_id_as,
			process_assigner_call_as,
			process_assign_as,
			process_check_as,
			process_creation_as,
			process_debug_as,
			process_inspect_as,
			process_instr_call_as,
			process_do_as,
			process_once_as,
			process_routine_as,
			process_constant_as,
			process_require_as,
			process_require_else_as,
			process_ensure_as,
			process_ensure_then_as,
			process_invariant_as,
			process_eiffel_list,
			process_parent_as,
			process_rename_as,
			process_export_item_as,
			process_all_as,
			process_feature_name_alias_as,
			process_bits_as,
			process_class_type_as,
			process_generic_class_type_as,
			process_formal_as,
			process_like_cur_as,
			process_like_id_as,
			process_named_tuple_type_as,
			process_constraining_type_as,
			process_access_inv_as,
			process_creation_expr_as,
			process_tuple_as,
			process_rename_clause_as,
			process_formal_dec_as,
			process_object_test_as,
			process_case_as,
			process_interval_as,
			process_external_as,
			process_inline_agent_creation_as,
			process_operand_as,
			process_agent_routine_creation_as,
			process_attribute_as,
			process_index_as,
			process_bit_const_as,
			process_array_as,
			process_nested_expr_as,
			process_precursor_as,
			process_bracket_as,
			process_variant_as,
			process_none_type_as,
			process_export_clause_as,
			process_undefine_clause_as,
			process_redefine_clause_as,
			process_select_clause_as,
			process_convert_feat_as,
			process_create_as,
			process_client_as,
			process_custom_attribute_as,
			process_static_access_as,
			process_expr_call_as,
			process_expr_address_as,
			process_type_expr_as,
			process_address_as,
			process_address_current_as,
			process_address_result_as,
			process_un_strip_as,
			process_converted_expr_as,
			process_infix_prefix_as,
			process_reverse_as,
			process_formal_argu_dec_list_as,
			process_loop_expr_as,
			process_iteration_as,
			process_there_exists_as,
			process_for_all_as,
				-- AST Iterator (Binary Operators)
		    process_bin_and_as,
		    process_bin_and_then_as,
			process_bin_eq_as,
		    process_bin_ne_as,
		    process_bin_tilde_as,
		    process_bin_not_tilde_as,
		    process_bin_free_as,
		    process_bin_implies_as,
		    process_bin_or_as,
		    process_bin_or_else_as,
		    process_bin_xor_as,
		    	-- AST Iterator (Binary Operators - Comparison)
		   	process_bin_ge_as,
		   	process_bin_gt_as,
		   	process_bin_le_as,
		   	process_bin_lt_as,
		   		-- AST Iterator (Binary Operators - Arithmetic)
			process_bin_div_as,
			process_bin_minus_as,
			process_bin_mod_as,
			process_bin_plus_as,
			process_bin_power_as,
			process_bin_slash_as,
			process_bin_star_as,
		    	-- AST Iterator (Unary Operators)
		    process_un_free_as,
		    process_un_minus_as,
		    process_un_not_as,
		    process_un_old_as,
		    process_un_plus_as,
				-- AST Structure Printer
			is_in_agent_target,
			is_in_inline_agent,
			processing_needed,
			process,
			process_block,
			process_child,
			process_child_list,
			process_child_block,
			process_child_block_list,
			process_child_if_needed,
			process_list_with_separator,
			process_identifier_list,
			output,
			output_as_string,
			print_ast_to_output,
			processing_access_feat_as,
				-- AST Iterator (Creation)
			process_create_creation_as,
			process_bang_creation_as,
			process_create_creation_expr_as,
			process_bang_creation_expr_as
		end

	EXT_AST_NODE_CONSTANTS

	EXT_AST_NODE_CONFIGURATOR

	EXT_AST_NODE_TO_XML_MAPPING

	EXT_XML_CONSTANTS

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make
			-- Default initialization.
		do
				-- Initialize configurator.
			initialize_ast_node_configurator
				-- Apply default setup to configurator.
			Current.allow_all
			Current.deny_node (node_eiffel_list)
			Current.deny_node (node_class_list_as)
--			Current.deny_node (node_constraint_list_as)
			Current.deny_node (node_convert_feat_list_as)
			Current.deny_node (node_formal_generic_list_as)
			Current.deny_node (node_indexing_clause_as)
			Current.deny_node (node_parent_list_as)
			Current.deny_node (node_type_dec_list_as)
			Current.deny_node (node_type_list_as)
--			Current.deny_node (node_use_list_as)
			Current.deny_node (node_feature_list_as)
			Current.deny_node (node_all_as)
			Current.deny_node (node_break_as)
			Current.deny_node (node_break_as)
			Current.deny_node (node_keyword_stub_as)
			Current.deny_node (node_leaf_stub_as)
			Current.deny_node (node_symbol_stub_as)
			Current.deny_node (node_symbol_as)
			Current.deny_node (node_symbol_stub_as)
			Current.deny_node (node_delayed_actual_list_as)
			Current.deny_node (node_formal_argu_dec_list_as)
			Current.deny_node (node_key_list_as)
			Current.deny_node (node_parameter_list_as)

			reset
		end

feature -- Configuration

	reset
			-- Resets the XML file to start a new transformation.
		do
			create output.make_with_xml_root (xml_root_name, xml_ns_eimala_core)
			output.set_character_data_enabled (xml_character_data_enabled)
		end

feature -- Access

	xml_root_name: STRING
		once
			Result := "eiffel"
		end

	xml_document: XML_DOCUMENT
			-- XML document representing the traversed AST.
		do
			Result := output.last_xml_document
		end

	xml_character_data_enabled: BOOLEAN
		once
			Result := True
		end

feature -- Output

	output: EXT_AST_XML_INDENTATION_OUTPUT
			-- Keeping track of XML nodes.

	output_as_string: STRING
			-- unused
		do
		end

	print_ast_to_output (a_ast: detachable AST_EIFFEL)
			-- unused
		do
		end

feature {NONE} -- Output

	conditionally_open_xml  (a_name: STRING; a_xml_ns: XML_NAMESPACE)
		do
			if allow_set.has (a_name) then
				output.xml_element_open  (ast_node_to_xml_tag[a_name], a_xml_ns)
			end
		end

	conditionally_open_other_xml  (a_name: STRING; a_xml_ns: XML_NAMESPACE; a_key: STRING)
		do
			if allow_set.has (a_key) then
				output.xml_element_open  (a_name, a_xml_ns)
			end
		end

	conditionally_close_xml (a_name: STRING; a_xml_ns: XML_NAMESPACE)
		do
			if allow_set.has (a_name) then
				output.xml_element_close (ast_node_to_xml_tag[a_name], a_xml_ns)
			end
		end

	conditionally_close_other_xml  (a_name: STRING; a_xml_ns: XML_NAMESPACE; a_key: STRING)
		do
			if allow_set.has (a_key) then
				output.xml_element_close (a_name, a_xml_ns)
			end
		end

	conditionally_add_attribute  (a_name: STRING; a_xml_ns: XML_NAMESPACE; a_value: STRING; a_key: STRING)
		do
			if allow_set.has (a_key) then
				output.xml_add_attribute (a_name, a_xml_ns, a_value)
			end
		end

	conditionally_add_unqualified_attribute  (a_name: STRING; a_value: STRING; a_key: STRING)
		do
			if allow_set.has (a_key) then
				output.xml_add_unqualified_attribute (a_name, a_value)
			end
		end

feature {NONE} -- Implementation (Attributes)

	is_in_agent_target: BOOLEAN
			-- Hack needed to process agent OPERANDS

	is_in_inline_agent: BOOLEAN
			-- Currently processing an inline agent?

feature {NONE} -- Implementation (Processing)

	processing_needed (an_ast: detachable AST_EIFFEL; a_parent: AST_EIFFEL; a_branch: INTEGER): BOOLEAN
			-- should `an_ast' be processed
		do
			Result := attached an_ast
		end

	process (l_as: detachable AST_EIFFEL; a_parent: detachable AST_EIFFEL; a_branch: INTEGER)
			-- Process `l_as'
		do
			l_as.process (Current)
		end

	process_child_list (l_as: EIFFEL_LIST[AST_EIFFEL]; separator: STRING; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- Process `l_as' and use `separator' for string output
		do
			output.enter_child (l_as)
			process_list_with_separator (l_as, separator, a_parent, a_branch)
			output.exit_child
		end

	process_child_block_list (l_as: EIFFEL_LIST[AST_EIFFEL]; separator: STRING; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- Process `l_as' and use `separator' for string output
		do
			output.enter_child (l_as)
			output.enter_block
			process_list_with_separator (l_as, separator, a_parent, a_branch)
			output.exit_block
			output.exit_child
		end

	process_list_with_separator (l_as: detachable EIFFEL_LIST[AST_EIFFEL]; separator: detachable STRING; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- Process `l_as' and use `separator' for string output
		local
			l_cursor: INTEGER
		do
			from
				l_cursor := l_as.index
				l_as.start
			until
				l_as.after
			loop
				process_child (l_as.item, l_as, l_as.index)
				if attached separator and l_as.index /= l_as.count then
					output.append_string ((separator))
				end
				l_as.forth
			end
			l_as.go_i_th (l_cursor)
		end

	process_identifier_list (l_as: IDENTIFIER_LIST)
			-- Process `l_as'
		local
			l_cursor: INTEGER
		do
			-- process the id's list
			-- which is not an ast but an array of indexes into the names heap
			from
				l_cursor := l_as.index
				l_as.start
			until
				l_as.after
			loop
				output.append_string ((names_heap.item (l_as.item)))
				if l_as.index /= l_as.count then
					output.append_string ((ti_comma+ti_Space))
				end

				l_as.forth
			end
			l_as.go_i_th (l_cursor)
		end

	process_block (l_as: AST_EIFFEL; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- Process as block
		do
			output.enter_block
			process(l_as, a_parent, a_branch)
			output.exit_block
		end

	process_child (l_as: AST_EIFFEL; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- Process as child
		do
			output.enter_child (l_as)
			process(l_as, a_parent, a_branch)
			output.exit_child
		end

	process_child_if_needed (l_as: AST_EIFFEL; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- Process if needed
		do
			if processing_needed (l_as, a_parent, a_branch) then
				process_child (l_as, a_parent, a_branch)
			end
		end

	process_child_block (l_as: AST_EIFFEL; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- Process as child and block
		do
			output.enter_block
			output.enter_child (l_as)
			process(l_as, a_parent, a_branch)
			output.exit_child
			output.exit_block
		end

feature {AST_EIFFEL} -- Roundtrip: Atomic

	process_bit_const_as (l_as: BIT_CONST_AS)
		do
			conditionally_open_xml  (node_bit_const_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_bit_const_as, xml_ns_eimala_core)
		end

	process_bool_as (l_as: BOOL_AS)
		local
			l_value: STRING
		do
			l_value := l_as.string_value
			l_value.to_lower

			conditionally_open_xml  (node_bool_as, xml_ns_eimala_core)
			conditionally_add_unqualified_attribute ("value", l_value, node_bool_as)
			Precursor (l_as)
			conditionally_close_xml (node_bool_as, xml_ns_eimala_core)
		end

	process_char_as (l_as: CHAR_AS)
		do
			conditionally_open_xml  (node_char_as, xml_ns_eimala_core)

			conditionally_add_unqualified_attribute ("value", l_as.string_value, node_char_as)
			output.append_string (l_as.string_value)

			conditionally_close_xml (node_char_as, xml_ns_eimala_core)
		end

	process_typed_char_as (l_as: TYPED_CHAR_AS)
		do
			conditionally_open_xml  (node_typed_char_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_typed_char_as, xml_ns_eimala_core)
		end

	process_string_as (l_as: STRING_AS)
		do
			conditionally_open_xml  (node_string_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_string_as, xml_ns_eimala_core)
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
		do
			conditionally_open_xml  (node_verbatim_string_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_verbatim_string_as, xml_ns_eimala_core)
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			conditionally_open_xml  (node_integer_as, xml_ns_eimala_core)

			if processing_needed (l_as.constant_type, l_as, 1) then
				output.append_string (ti_l_curly)
				process_child (l_as.constant_type, l_as, 1)
				output.append_string (ti_r_curly+ti_space)
			end

			if l_as.has_integer (32) then
				conditionally_add_unqualified_attribute ("value", l_as.string_value, node_integer_as)
				output.append_string (l_as.string_value)
			elseif l_as.has_integer (64) then
				-- Can't be represented as 32bit INT
				-- string_value will fail, use 64bit value
				conditionally_add_unqualified_attribute ("value", l_as.integer_64_value.out, node_integer_as)
				output.append_string (l_as.integer_64_value.out)
			else
				-- Use NATURAL_64 value
				conditionally_add_unqualified_attribute ("value", l_as.natural_64_value.out, node_integer_as)
				output.append_string (l_as.natural_64_value.out)
			end

			conditionally_close_xml (node_integer_as, xml_ns_eimala_core)
		end

	process_real_as (l_as: REAL_AS)
		do
			conditionally_open_xml  (node_real_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_real_as, xml_ns_eimala_core)
		end

	process_id_as (l_as: ID_AS)
		do
			conditionally_open_xml  (node_id_as, xml_ns_eimala_core)
			conditionally_add_unqualified_attribute ("name", l_as.name, node_id_as)

			output.append_string (l_as.name)

			conditionally_close_xml (node_id_as, xml_ns_eimala_core)
		end

	process_unique_as (l_as: UNIQUE_AS)
		do
			conditionally_open_xml  (node_unique_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_unique_as, xml_ns_eimala_core)
		end

feature {AST_EIFFEL} -- Roundtrip: Instructions

	process_case_as (l_as: CASE_AS)
		do
			conditionally_open_xml  (node_case_as, xml_ns_eimala_core)

			output.append_string (ti_When_keyword+ti_Space)

			conditionally_open_other_xml  ("interval_list", xml_ns_eimala_core, node_case_as)
			process_child_list (l_as.interval, ti_comma+ti_space, l_as, 1)
			conditionally_close_other_xml ("interval_list", xml_ns_eimala_core, node_case_as)

			output.append_string (ti_Space+ti_Then_keyword+ti_New_line)
			conditionally_open_other_xml  ("compound", xml_ns_eimala_core, node_case_as)
			if processing_needed (l_as.compound, l_as, 2) then
				process_child_block (l_as.compound, l_as, 2)
			end
			conditionally_close_other_xml ("compound", xml_ns_eimala_core, node_case_as)

			conditionally_close_xml (node_case_as, xml_ns_eimala_core)
		end

	process_interval_as (l_as: INTERVAL_AS)
		do
			conditionally_open_xml  (node_interval_as, xml_ns_eimala_core)

			conditionally_open_other_xml  ("lower", xml_ns_eimala_core, node_interval_as)
			process_child(l_as.lower, l_as, 1)
			conditionally_close_other_xml ("lower", xml_ns_eimala_core, node_interval_as)

			if processing_needed (l_as.upper, l_as, 2) then
				output.append_string (ti_Dotdot)

				conditionally_open_other_xml  ("upper", xml_ns_eimala_core, node_interval_as)
				process_child(l_as.upper, l_as, 2)
				conditionally_close_other_xml ("upper", xml_ns_eimala_core, node_interval_as)
			end

			conditionally_close_xml (node_interval_as, xml_ns_eimala_core)
		end

	process_inspect_as (l_as: INSPECT_AS)
		do
			conditionally_open_xml  (node_inspect_as, xml_ns_eimala_core)

			output.append_string (ti_inspect_keyword+ti_New_line)

			conditionally_open_other_xml  ("switch", xml_ns_eimala_core, node_inspect_as)
			process_child_block (l_as.switch, l_as, 1)
			conditionally_close_other_xml ("switch", xml_ns_eimala_core, node_inspect_as)

			output.append_string (ti_New_line)

			if processing_needed (l_as.case_list, l_as, 2) then
--				conditionally_open_other_xml  ("case_list", xml_ns_eimala_core, node_inspect_as)
				process_child (l_as.case_list, l_as, 2)
--				conditionally_close_other_xml ("case_list", xml_ns_eimala_core, node_inspect_as)
			end

			if processing_needed (l_as.else_part, l_as, 3) then
				output.append_string (ti_else_keyword+ti_New_line)

				conditionally_open_other_xml  ("else_part", xml_ns_eimala_core, node_inspect_as)
				process_child_block (l_as.else_part, l_as, 3)
				conditionally_close_other_xml ("else_part", xml_ns_eimala_core, node_inspect_as)
			end

			output.append_string (ti_End_keyword)

			conditionally_close_xml (node_inspect_as, xml_ns_eimala_core)
			output.append_string (ti_New_line)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			conditionally_open_xml  (node_instr_call_as, xml_ns_eimala_core)
			process_child (l_as.call, l_as, 1)
			conditionally_close_xml (node_instr_call_as, xml_ns_eimala_core)
			output.append_string (ti_New_line)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			conditionally_open_xml  (node_assigner_call_as, xml_ns_eimala_core)

			conditionally_open_other_xml  ("target", xml_ns_eimala_core, node_assigner_call_as)
			process_child (l_as.target, l_as, 1)
			conditionally_close_other_xml ("target", xml_ns_eimala_core, node_assigner_call_as)

			output.append_string (ti_Space+ti_Assign+ti_Space)

			conditionally_open_other_xml  ("source", xml_ns_eimala_core, node_assigner_call_as)
			process_child (l_as.source, l_as, 2)
			conditionally_close_other_xml ("source", xml_ns_eimala_core, node_assigner_call_as)

			conditionally_close_xml (node_assigner_call_as, xml_ns_eimala_core)
			output.append_string (ti_New_line)
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			conditionally_open_xml (node_assign_as, xml_ns_eimala_core)

			conditionally_open_other_xml  ("target", xml_ns_eimala_core, node_assign_as)
			process_child (l_as.target, l_as, 1)
			conditionally_close_other_xml ("target", xml_ns_eimala_core, node_assign_as)

			output.append_string (ti_Space+ti_Assign+ti_Space)

			conditionally_open_other_xml  ("source", xml_ns_eimala_core, node_assign_as)
			process_child (l_as.source, l_as, 2)
			conditionally_close_other_xml ("source", xml_ns_eimala_core, node_assign_as)

			conditionally_close_xml (node_assign_as, xml_ns_eimala_core)
			output.append_string (ti_new_line)
		end

	process_reverse_as (l_as: REVERSE_AS)
		do
			conditionally_open_xml  (node_reverse_as, xml_ns_eimala_core)

			conditionally_open_other_xml  ("target", xml_ns_eimala_core, node_reverse_as)
			process_child (l_as.target, l_as, 1)
			conditionally_close_other_xml ("target", xml_ns_eimala_core, node_reverse_as)

			output.append_string (ti_Space+ti_Reverse_assign+ti_Space)

			conditionally_open_other_xml  ("source", xml_ns_eimala_core, node_reverse_as)
			process_child (l_as.source, l_as, 2)
			conditionally_close_other_xml ("source", xml_ns_eimala_core, node_reverse_as)

			conditionally_close_xml (node_reverse_as, xml_ns_eimala_core)
			output.append_string (ti_New_line)
		end

	process_creation_as (l_as: CREATION_AS)
		do
			conditionally_open_xml  (node_creation_as, xml_ns_eimala_core)

			processing_creation_as (l_as, node_creation_as)

			conditionally_close_xml (node_creation_as, xml_ns_eimala_core)
			output.append_string (ti_New_line)
		end

	process_debug_as (l_as: DEBUG_AS)
		do
			conditionally_open_xml  (node_debug_as, xml_ns_eimala_core)

			output.append_string(ti_debug_keyword+ti_Space)

			if processing_needed (l_as.internal_keys, l_as, 1) then
				output.append_string (ti_l_parenthesis)
				conditionally_open_other_xml  ("keys", xml_ns_eimala_core, node_debug_as)
				process_child_list (l_as.internal_keys.keys, ", ", l_as, 1)
				conditionally_close_other_xml ("keys", xml_ns_eimala_core, node_debug_as)
				output.append_string (ti_r_parenthesis)
			end

			output.append_string(ti_New_line)

			conditionally_open_other_xml  ("compound", xml_ns_eimala_core, node_debug_as)
			if processing_needed (l_as.compound, l_as, 2) then
				process_child_block(l_as.compound, l_as, 2)
			end
			conditionally_close_other_xml ("compound", xml_ns_eimala_core, node_debug_as)

			output.append_string (ti_End_keyword)

			conditionally_close_xml (node_debug_as, xml_ns_eimala_core)
			output.append_string (ti_New_line)
		end

	process_check_as (l_as: CHECK_AS)
		do
			conditionally_open_xml  (node_check_as, xml_ns_eimala_core)

			output.append_string (ti_check_keyword+ti_New_line)
			if processing_needed (l_as.check_list, l_as, 1) then
				process_child_block (l_as.check_list, l_as, 1)
			end
			output.append_string (ti_end_keyword)

			conditionally_close_xml (node_check_as, xml_ns_eimala_core)
			output.append_string (ti_New_line)
		end

	process_retry_as (l_as: RETRY_AS)
		do
			conditionally_open_xml  (node_retry_as, xml_ns_eimala_core)

			output.append_string (ti_retry_keyword)

			conditionally_close_xml (node_retry_as, xml_ns_eimala_core)
			output.append_string (ti_New_line)
		end

	process_if_as (l_as: IF_AS)
		do
			conditionally_open_xml  (node_if_as, xml_ns_eimala_core)

			output.append_string (ti_if_keyword+ti_Space)
			conditionally_open_other_xml  ("condition", xml_ns_eimala_core, node_if_as)
			process_child (l_as.condition, l_as, 1)
			conditionally_close_other_xml ("condition", xml_ns_eimala_core, node_if_as)
			output.append_string (ti_Space+ti_then_keyword+ti_New_line)

			if processing_needed (l_as.compound, l_as, 2) then
				conditionally_open_other_xml  ("compound", xml_ns_eimala_core, node_if_as)
--				conditionally_open_other_xml  ("eiffel_list", xml_ns_eimala_core, node_if_as)
				process_child_block_list (l_as.compound, void, l_as, 2)
--				conditionally_close_other_xml ("eiffel_list", xml_ns_eimala_core, node_if_as)
				conditionally_close_other_xml ("compound", xml_ns_eimala_core, node_if_as)
			end

			if processing_needed (l_as.elsif_list, l_as, 3) then
				process_child (l_as.elsif_list, l_as, 3)
			end

			if processing_needed (l_as.else_part, l_as, 4) then
				output.append_string (ti_else_keyword+ti_New_line)
				conditionally_open_other_xml  ("else_part", xml_ns_eimala_core, node_if_as)
--				conditionally_open_other_xml  ("eiffel_list", xml_ns_eimala_core, node_if_as)
				process_child_block_list(l_as.else_part, void, l_as, 4)
--				conditionally_close_other_xml ("eiffel_list", xml_ns_eimala_core, node_if_as)
				conditionally_close_other_xml ("else_part", xml_ns_eimala_core, node_if_as)
			end
			output.append_string (ti_End_keyword)

			conditionally_close_xml (node_if_as, xml_ns_eimala_core)
			output.append_string (ti_new_line)
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			conditionally_open_xml  (node_elseif_as, xml_ns_eimala_core)

			output.append_string (ti_elseif_keyword+ti_Space)

			conditionally_open_other_xml  ("condition", xml_ns_eimala_core, node_elseif_as)
			process_child(l_as.expr, l_as, 1)
			conditionally_close_other_xml ("condition", xml_ns_eimala_core, node_elseif_as)

			output.append_string (ti_Space+ti_then_keyword+ti_New_line)

			if processing_needed (l_as.compound, l_as, 2) then
				conditionally_open_other_xml  ("compound", xml_ns_eimala_core, node_elseif_as)
				process_child_block_list(l_as.compound, void, l_as, 2)
				conditionally_close_other_xml ("compound", xml_ns_eimala_core, node_elseif_as)
			end

			conditionally_close_xml (node_elseif_as, xml_ns_eimala_core)
		end

	process_loop_as (l_as: LOOP_AS)
		local
			l_loop_tag_name: STRING
		do
			if attached l_as.iteration then
				l_loop_tag_name := "acrossLoop"
			else
				l_loop_tag_name := "standardLoop"
			end

			conditionally_open_other_xml  (l_loop_tag_name, xml_ns_eimala_core, node_loop_as)

			if processing_needed (l_as.iteration, l_as, 6) then
				output.append_string (ti_across_keyword+ti_New_line)
				process_child_block(l_as.iteration, l_as, 6)
				output.append_string (ti_New_line)
			end

			if processing_needed (l_as.from_part, l_as, 1) or not processing_needed (l_as.iteration, l_as, 6) then
				output.append_string (ti_from_keyword+ti_New_line)
			end

			if processing_needed (l_as.from_part, l_as, 1) then
				conditionally_open_other_xml  ("from_part", xml_ns_eimala_core, node_loop_as)
				process_child_block(l_as.from_part, l_as, 1)
				conditionally_close_other_xml ("from_part", xml_ns_eimala_core, node_loop_as)
			end

			if processing_needed (l_as.full_invariant_list, l_as, 2) then
				output.append_string (ti_invariant_keyword+ti_New_line)
				conditionally_open_other_xml  ("invariant", xml_ns_eimala_core, node_loop_as)
				process_child_block_list(l_as.full_invariant_list, void, l_as, 2)
				conditionally_close_other_xml ("invariant", xml_ns_eimala_core, node_loop_as)
				output.append_string (ti_New_line)
			end

			if processing_needed (l_as.variant_part, l_as, 5) then
				output.append_string (ti_variant_keyword+ti_New_line)
				process_child_block(l_as.variant_part, l_as, 5)
				output.append_string (ti_New_line)
			end

			if processing_needed (l_as.stop, l_as, 3)  then
				output.append_string (ti_until_keyword+ti_New_line)
				conditionally_open_other_xml  ("stop", xml_ns_eimala_core, node_loop_as)
				process_child_block (l_as.stop, l_as, 3)
				conditionally_close_other_xml ("stop", xml_ns_eimala_core, node_loop_as)
				output.append_string (ti_New_line)
			end

			output.append_string (ti_loop_keyword+ti_New_line)

			if processing_needed (l_as.compound, l_as, 4) then
				conditionally_open_other_xml  ("compound", xml_ns_eimala_core, node_loop_as)
				process_child_block_list(l_as.compound, void, l_as, 4)
				conditionally_close_other_xml ("compound", xml_ns_eimala_core, node_loop_as)
			end

			output.append_string (ti_end_keyword)

			conditionally_close_other_xml (l_loop_tag_name, xml_ns_eimala_core, node_loop_as)
			output.append_string (ti_New_line)
		end

feature {AST_EIFFEL} -- Roundtrip: Inheritance

	process_rename_as (l_as: RENAME_AS)
		do
			conditionally_open_xml  (node_rename_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_rename_as, xml_ns_eimala_core)
		end

	process_export_item_as (l_as: EXPORT_ITEM_AS)
		do
			conditionally_open_xml  (node_export_item_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_export_item_as, xml_ns_eimala_core)
		end

	process_all_as (l_as: ALL_AS)
		do
			conditionally_open_xml  (node_all_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_all_as, xml_ns_eimala_core)
		end

	process_parent_as (l_as: PARENT_AS)
		do
			conditionally_open_xml  (node_parent_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_parent_as, xml_ns_eimala_core)
		end

feature {AST_EIFFEL} -- Roundtrip: Contracts

	process_variant_as (l_as: VARIANT_AS)
		do
			conditionally_open_xml  (node_variant_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_variant_as, xml_ns_eimala_core)
		end

	process_invariant_as (l_as: INVARIANT_AS)
		do
			conditionally_open_xml  (node_invariant_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_invariant_as, xml_ns_eimala_core)
		end

	process_require_as (l_as: REQUIRE_AS)
		do
			conditionally_open_xml  (node_require_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_require_as, xml_ns_eimala_core)
		end

	process_require_else_as (l_as: REQUIRE_ELSE_AS)
		do
			conditionally_open_xml  (node_require_else_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_require_else_as, xml_ns_eimala_core)
		end

	process_ensure_as (l_as: ENSURE_AS)
		do
			conditionally_open_xml  (node_ensure_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_ensure_as, xml_ns_eimala_core)
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS)
		do
			conditionally_open_xml  (node_ensure_then_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_ensure_then_as, xml_ns_eimala_core)
		end

feature {AST_EIFFEL} -- Roundtrip: Types

	process_bits_as (l_as: BITS_AS)
		do
			conditionally_open_xml  (node_bits_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_bits_as, xml_ns_eimala_core)
		end

	process_none_type_as (l_as: NONE_TYPE_AS)
		do
			conditionally_open_xml  (node_none_type_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_none_type_as, xml_ns_eimala_core)
		end

	process_class_type_as (l_as: CLASS_TYPE_AS)
		do
			conditionally_open_xml  (node_class_type_as, xml_ns_eimala_core)

			if l_as.has_separate_mark then
				output.append_string (ti_separate_keyword+ti_Space)
			end

			if l_as.has_attached_mark then
				output.append_string (ti_attached_keyword+ti_Space)
			elseif l_as.has_detachable_mark then
				output.append_string (ti_detachable_keyword+ti_Space)
			end

--			conditionally_open_other_xml  ("class_name", xml_ns_eimala_core, node_class_type_as)
			process_child(l_as.class_name, l_as, 1)
--			conditionally_close_other_xml ("class_name", xml_ns_eimala_core, node_class_type_as)

			conditionally_close_xml (node_class_type_as, xml_ns_eimala_core)
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS)
		do
			conditionally_open_xml  (node_generic_class_type_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_generic_class_type_as, xml_ns_eimala_core)
		end

	process_formal_argu_dec_list_as (l_as: FORMAL_ARGU_DEC_LIST_AS)
		do
			conditionally_open_xml  (node_formal_argu_dec_list_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_formal_argu_dec_list_as, xml_ns_eimala_core)
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS)
		do
			conditionally_open_xml  (node_named_tuple_type_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_named_tuple_type_as, xml_ns_eimala_core)
		end

	process_constraining_type_as (l_as: CONSTRAINING_TYPE_AS)
		do
			conditionally_open_xml  (node_constraining_type_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_constraining_type_as, xml_ns_eimala_core)
		end

	process_like_id_as (l_as: LIKE_ID_AS)
		do
			conditionally_open_xml  (node_like_id_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_like_id_as, xml_ns_eimala_core)
		end

	process_like_cur_as (l_as: LIKE_CUR_AS)
		do
			conditionally_open_xml  (node_like_cur_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_like_cur_as, xml_ns_eimala_core)
		end

	process_formal_as (l_as: FORMAL_AS)
		do
			conditionally_open_xml  (node_formal_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_formal_as, xml_ns_eimala_core)
		end

feature {AST_EIFFEL} -- Roundtrip: Expressions

	process_converted_expr_as (l_as: CONVERTED_EXPR_AS)
		do
			conditionally_open_xml  (node_converted_expr_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_converted_expr_as, xml_ns_eimala_core)
		end

	process_address_result_as (l_as: ADDRESS_RESULT_AS)
		do
			conditionally_open_xml  (node_address_result_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_address_result_as, xml_ns_eimala_core)
		end

	process_address_current_as (l_as: ADDRESS_CURRENT_AS)
		do
			conditionally_open_xml  (node_address_current_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_address_current_as, xml_ns_eimala_core)
		end

	process_un_strip_as (l_as: UN_STRIP_AS)
		do
			conditionally_open_xml  (node_un_strip_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_un_strip_as, xml_ns_eimala_core)
		end

	process_address_as (l_as: ADDRESS_AS)
		do
			conditionally_open_xml  (node_address_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_address_as, xml_ns_eimala_core)
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			conditionally_open_xml  (node_expr_call_as, xml_ns_eimala_core)
			process_child(l_as.call, l_as, 1)
			conditionally_close_xml (node_expr_call_as, xml_ns_eimala_core)
		end

	process_expr_address_as (l_as: EXPR_ADDRESS_AS)
		do
			conditionally_open_xml  (node_expr_address_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_expr_address_as, xml_ns_eimala_core)
		end

	process_type_expr_as (l_as: TYPE_EXPR_AS)
		do
			conditionally_open_xml  (node_type_expr_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_type_expr_as, xml_ns_eimala_core)
		end

	process_custom_attribute_as (l_as: CUSTOM_ATTRIBUTE_AS)
		do
			conditionally_open_xml  (node_custom_attribute_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_custom_attribute_as, xml_ns_eimala_core)
		end

	process_array_as (l_as: ARRAY_AS)
		do
			conditionally_open_xml  (node_array_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_array_as, xml_ns_eimala_core)
		end

	process_bracket_as (l_as: BRACKET_AS)
		do
			conditionally_open_xml  (node_bracket_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_bracket_as, xml_ns_eimala_core)
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			conditionally_open_xml  (node_nested_expr_as, xml_ns_eimala_core)

			conditionally_open_other_xml  ("target", xml_ns_eimala_core, node_nested_expr_as)
			if attached {BRACKET_AS}l_as.target then
				process_child(l_as.target, l_as, 1)
			else
				output.append_string (ti_l_parenthesis)
				process_child(l_as.target, l_as, 1)
				output.append_string (ti_r_parenthesis)
			end
			conditionally_close_other_xml ("target", xml_ns_eimala_core, node_nested_expr_as)

			output.append_string (ti_dot)

			conditionally_open_other_xml  ("message", xml_ns_eimala_core, node_nested_expr_as)
			process_child(l_as.message, l_as, 2)
			conditionally_close_other_xml ("message", xml_ns_eimala_core, node_nested_expr_as)

			conditionally_close_xml (node_nested_expr_as, xml_ns_eimala_core)
		end

	process_tuple_as (l_as: TUPLE_AS)
		do
			conditionally_open_xml  (node_tuple_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_tuple_as, xml_ns_eimala_core)
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
			conditionally_open_xml  (node_tagged_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_tagged_as, xml_ns_eimala_core)
		end

	process_void_as (l_as: VOID_AS)
		do
			conditionally_open_xml  (node_void_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_void_as, xml_ns_eimala_core)
		end

	process_paran_as (l_as: PARAN_AS)
		do
			conditionally_open_xml  (node_paran_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_paran_as, xml_ns_eimala_core)
		end

	process_binary_as (l_as: BINARY_AS)
		do
			fixme ("Dependency of conditionlally_open and conditionally_open_other.")
--			conditionally_open_xml  (node_binary_as, xml_ns_eimala_core)

			conditionally_open_other_xml  ("left", xml_ns_eimala_core, node_binary_as)
			process_child (l_as.left, l_as, 1)
			conditionally_close_other_xml ("left", xml_ns_eimala_core, node_binary_as)

			output.append_string (ti_Space)

			conditionally_open_other_xml  ("operator", xml_ns_eimala_core, node_binary_as)
			process_child (l_as.op_name, l_as, 2)
			conditionally_close_other_xml ("operator", xml_ns_eimala_core, node_binary_as)

			output.append_string (ti_Space)

			conditionally_open_other_xml  ("right", xml_ns_eimala_core, node_binary_as)
			process_child (l_as.right, l_as, 3)
			conditionally_close_other_xml ("right", xml_ns_eimala_core, node_binary_as)

--			conditionally_close_xml (node_binary_as, xml_ns_eimala_core)
		end

	process_unary_as (l_as: UNARY_AS)
		do
			fixme ("Dependency of conditionlally_open and conditionally_open_other.")
--			conditionally_open_xml  (node_unary_as, xml_ns_eimala_core)

			conditionally_open_other_xml  ("operator", xml_ns_eimala_core, node_unary_as)
			process_child (l_as.operator_ast, l_as, 1)
			conditionally_close_other_xml ("operator", xml_ns_eimala_core, node_unary_as)

			output.append_string (ti_Space)

			fixme ("Tag differs from feature.")
			conditionally_open_other_xml  ("expression", xml_ns_eimala_core, node_unary_as)
			process_child (l_as.expr, l_as, 2)
			conditionally_close_other_xml ("expression", xml_ns_eimala_core, node_unary_as)

--			conditionally_close_xml (node_unary_as, xml_ns_eimala_core)
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			conditionally_open_xml  (node_object_test_as, xml_ns_eimala_core)

			if l_as.is_attached_keyword then
				output.append_string (ti_attached_keyword+ti_Space)
				if processing_needed (l_as.type, l_as, 1) then
					conditionally_open_other_xml  ("type", xml_ns_eimala_core, node_object_test_as)

					output.append_string (ti_l_curly)
					process_child (l_as.type, l_as, 1)
					output.append_string (ti_r_curly)

					conditionally_close_other_xml ("type", xml_ns_eimala_core, node_object_test_as)
				end

				conditionally_open_other_xml  ("expression", xml_ns_eimala_core, node_object_test_as)
				process_child (l_as.expression, l_as, 2)
				conditionally_close_other_xml ("expression", xml_ns_eimala_core, node_object_test_as)

				if processing_needed (l_as.name, l_as, 3) then
					output.append_string (ti_Space+ti_as_keyword+ti_Space)

					conditionally_open_other_xml  ("name", xml_ns_eimala_core, node_object_test_as)
					l_as.name.process (Current)
--					output.append_string (l_as.name.name)
					conditionally_close_other_xml ("name", xml_ns_eimala_core, node_object_test_as)
				end
			else
				-- looks like this:
				-- {name: TYPE} expr

				output.append_string (ti_l_curly)

				if processing_needed (l_as.name, l_as, 3) then
					conditionally_open_other_xml  ("name", xml_ns_eimala_core, node_object_test_as)
					l_as.name.process (Current)
--					output.append_string (l_as.name.name)
					conditionally_close_other_xml ("name", xml_ns_eimala_core, node_object_test_as)

					output.append_string (ti_colon+ti_space)
				end

				if processing_needed (l_as.type, l_as, 1) then
					conditionally_open_other_xml  ("type", xml_ns_eimala_core, node_object_test_as)
					process_child (l_as.type, l_as, 1)
					conditionally_close_other_xml ("type", xml_ns_eimala_core, node_object_test_as)
				end

				output.append_string (ti_r_curly+ti_space)

				if processing_needed (l_as.expression, l_as, 2) then
					conditionally_open_other_xml  ("expression", xml_ns_eimala_core, node_object_test_as)
					process_child (l_as.expression, l_as, 2)
					conditionally_close_other_xml ("expression", xml_ns_eimala_core, node_object_test_as)
				end

			end

			conditionally_close_xml (node_object_test_as, xml_ns_eimala_core)
		end

	process_loop_expr_as (l_as: LOOP_EXPR_AS)
		do
			conditionally_open_xml  (node_loop_expr_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_loop_expr_as, xml_ns_eimala_core)
		end

feature {AST_EIFFEL} -- Roundtrip: Access

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			conditionally_open_xml  (node_static_access_as, xml_ns_eimala_core)
			conditionally_add_unqualified_attribute ("name", l_as.feature_name.name, node_precursor_as)

			output.append_string (ti_feature_keyword+ti_Space+ti_l_curly)
			process_child_if_needed(l_as.class_type, l_as, 1)
			output.append_string (ti_r_curly+ti_dot)
			output.append_string (l_as.feature_name.name)
			if processing_needed (l_as.parameters, l_as, 2) then
				conditionally_open_other_xml  ("parameters", xml_ns_eimala_core, node_static_access_as)
				output.append_string (ti_l_parenthesis)
				process_child_list (l_as.parameters, ti_comma+ti_Space, l_as, 2)
				output.append_string (ti_r_parenthesis)
				conditionally_close_other_xml ("parameters", xml_ns_eimala_core, node_static_access_as)
			end

			conditionally_close_xml (node_static_access_as, xml_ns_eimala_core)
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		do
			conditionally_open_xml  (node_precursor_as, xml_ns_eimala_core)
			conditionally_add_unqualified_attribute ("name", "Precursor", node_precursor_as)

			output.append_string (ti_precursor_keyword+ti_Space)
			if processing_needed (l_as.parent_base_class,l_as,1) then
				output.append_string (ti_l_curly)
				process_child(l_as.parent_base_class, l_as, 1)
				output.append_string (ti_r_curly)
			end
			if processing_needed (l_as.parameters,l_as,2) then
				output.append_string (ti_Space+ti_l_parenthesis)
				conditionally_open_other_xml  ("parameters", xml_ns_eimala_core, node_precursor_as)
				process_child_list(l_as.parameters, ti_comma+ti_Space,l_as,2)
				conditionally_close_other_xml ("parameters", xml_ns_eimala_core, node_precursor_as)
				output.append_string (ti_r_parenthesis)
			end

			conditionally_close_xml (node_precursor_as, xml_ns_eimala_core)
		end

	process_result_as (l_as: RESULT_AS)
		do
			conditionally_open_xml  (node_result_as, xml_ns_eimala_core)
			conditionally_add_unqualified_attribute ("name", l_as.access_name_8, node_result_as)
			Precursor (l_as)
			conditionally_close_xml (node_result_as, xml_ns_eimala_core)
		end

	process_current_as (l_as: CURRENT_AS)
		do
			conditionally_open_xml  (node_current_as, xml_ns_eimala_core)
			conditionally_add_unqualified_attribute ("name", l_as.access_name_8, node_current_as)
			Precursor (l_as)
			conditionally_close_xml (node_current_as, xml_ns_eimala_core)
		end

	process_access_inv_as (l_as: ACCESS_INV_AS)
		do
			conditionally_open_xml  (node_access_inv_as, xml_ns_eimala_core)
			conditionally_add_unqualified_attribute ("name", l_as.access_name_8, node_access_inv_as)

			processing_access_feat_as (l_as)

--			process(l_as.feature_name, l_as, 1)
--			if processing_needed (l_as.parameters,l_as,2) then
--				output.append_string (ti_Space+ti_l_parenthesis)
--				process_child_list(l_as.parameters, ti_comma+ti_Space,l_as,2)
--				output.append_string (ti_r_parenthesis)
--			end

			conditionally_close_xml (node_access_inv_as, xml_ns_eimala_core)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			conditionally_open_xml  (node_access_feat_as, xml_ns_eimala_core)
			conditionally_add_unqualified_attribute ("name", l_as.access_name_8, node_access_feat_as)
			Precursor (l_as)
			conditionally_close_xml (node_access_feat_as, xml_ns_eimala_core)
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			conditionally_open_xml  (node_access_id_as, xml_ns_eimala_core)
			conditionally_add_unqualified_attribute ("name", l_as.access_name_8, node_access_id_as)
			Precursor (l_as)
			conditionally_close_xml (node_access_id_as, xml_ns_eimala_core)
		end

feature {NONE} -- Roundtrip: Expressions (Helper)

	processing_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			output.append_string (l_as.access_name)

			if processing_needed (l_as.parameters,l_as,1) then
				output.append_string (ti_Space)
				conditionally_open_other_xml  ("parameters", xml_ns_eimala_core, node_access_feat_as)
				output.append_string (ti_l_parenthesis)
				process_child_list(l_as.parameters, ti_comma+ti_Space, l_as, 1)
				output.append_string (ti_r_parenthesis)
				conditionally_close_other_xml ("parameters", xml_ns_eimala_core, node_access_feat_as)
			end
		end

	processing_creation_as (l_as: CREATION_AS; a_key: STRING)
		do
			conditionally_open_xml  (a_key, xml_ns_eimala_core)

			output.append_string (ti_create_keyword+ti_Space)

			if processing_needed (l_as.type, l_as, 2) then
				conditionally_open_other_xml  ("type", xml_ns_eimala_core, a_key)
				output.append_string (ti_l_curly)
				process_child (l_as.type, l_as, 2)
				output.append_string (ti_r_curly+ti_Space)
				conditionally_close_other_xml ("type", xml_ns_eimala_core, a_key)
			end

			conditionally_open_other_xml  ("target", xml_ns_eimala_core, a_key)
			process(l_as.target, l_as, 1)
			conditionally_close_other_xml ("target", xml_ns_eimala_core, a_key)

			if processing_needed (l_as.call, l_as, 3) then
				output.append_string (ti_dot)

				conditionally_open_other_xml  ("message", xml_ns_eimala_core, a_key)
				process_child (l_as.call, l_as, 3)
				conditionally_close_other_xml ("message", xml_ns_eimala_core, a_key)
			end

			conditionally_close_xml (a_key, xml_ns_eimala_core)
			output.append_string (ti_New_line)
		end

	processing_creation_expr_as (l_as: CREATION_EXPR_AS; a_key: STRING)
		do
			conditionally_open_xml  (a_key, xml_ns_eimala_core)

			output.append_string (ti_create_keyword+ti_Space)

			conditionally_open_other_xml  ("type", xml_ns_eimala_core, a_key)
			output.append_string(ti_l_curly)
			process_child (l_as.type, l_as, 1)
			output.append_string(ti_r_curly)
			conditionally_close_other_xml ("type", xml_ns_eimala_core, a_key)

			if processing_needed (l_as.call, l_as, 1) then
				output.append_string (ti_dot)
				conditionally_open_other_xml  ("message", xml_ns_eimala_core, a_key)
				process(l_as.call, l_as, 2)
				conditionally_close_other_xml ("message", xml_ns_eimala_core, a_key)
			end

			conditionally_close_xml (a_key, xml_ns_eimala_core)
		end

feature {AST_EIFFEL} -- Roundtrip: Inheritance clauses

	process_rename_clause_as (l_as: RENAME_CLAUSE_AS)
		do
			conditionally_open_xml  (node_rename_clause_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_rename_clause_as, xml_ns_eimala_core)
		end

	process_export_clause_as (l_as: EXPORT_CLAUSE_AS)
		do
			conditionally_open_xml  (node_export_clause_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_export_clause_as, xml_ns_eimala_core)
		end

	process_undefine_clause_as (l_as: UNDEFINE_CLAUSE_AS)
		do
			conditionally_open_xml  (node_undefine_clause_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_undefine_clause_as, xml_ns_eimala_core)
		end

	process_redefine_clause_as (l_as: REDEFINE_CLAUSE_AS)
		do
			conditionally_open_xml  (node_redefine_clause_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_redefine_clause_as, xml_ns_eimala_core)
		end

	process_select_clause_as (l_as: SELECT_CLAUSE_AS)
		do
			conditionally_open_xml  (node_select_clause_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_select_clause_as, xml_ns_eimala_core)
		end

feature {AST_EIFFEL} -- Roundtrip: Misc

	process_iteration_as (l_as: ITERATION_AS)
		do
			conditionally_open_xml  (node_iteration_as, xml_ns_eimala_core)

			conditionally_open_other_xml  ("expression", xml_ns_eimala_core, node_iteration_as)
			process_child (l_as.expression, l_as, 1)
			conditionally_close_other_xml ("expression", xml_ns_eimala_core, node_iteration_as)

			output.append_string (ti_space+ti_as_keyword+ti_space)

			conditionally_open_other_xml  ("identifier", xml_ns_eimala_core, node_iteration_as)
			process_child (l_as.identifier, l_as, 2)
			conditionally_close_other_xml ("identifier", xml_ns_eimala_core, node_iteration_as)

			conditionally_close_xml (node_iteration_as, xml_ns_eimala_core)
		end

	process_infix_prefix_as (l_as: INFIX_PREFIX_AS)
		do
			conditionally_open_xml  (node_infix_prefix_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_infix_prefix_as, xml_ns_eimala_core)
		end

	process_formal_dec_as (l_as: FORMAL_DEC_AS)
		do
			conditionally_open_xml  (node_formal_dec_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_formal_dec_as, xml_ns_eimala_core)
		end

	process_creation_expr_as (a_as: CREATION_EXPR_AS)
		do
			processing_creation_expr_as (a_as, node_creation_expr_as)
		end

	process_routine_as (l_as: ROUTINE_AS)
		do
			conditionally_open_xml  (node_routine_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_routine_as, xml_ns_eimala_core)
		end

	process_constant_as (l_as: CONSTANT_AS)
		do
			conditionally_open_xml  (node_constant_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_constant_as, xml_ns_eimala_core)
		end

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
		do
--			conditionally_open_xml  (node_eiffel_list, xml_ns_eimala_core)
			Precursor (l_as)
--			conditionally_close_xml (node_eiffel_list, xml_ns_eimala_core)
		end

	process_convert_feat_as (l_as: CONVERT_FEAT_AS)
		do
			conditionally_open_xml  (node_convert_feat_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_convert_feat_as, xml_ns_eimala_core)
		end

	process_feature_name_alias_as (l_as: FEATURE_NAME_ALIAS_AS)
		do
			conditionally_open_xml  (node_feature_name_alias_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_feature_name_alias_as, xml_ns_eimala_core)
		end

	process_feat_name_id_as (l_as: FEAT_NAME_ID_AS)
		do
			conditionally_open_xml  (node_feat_name_id_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_feat_name_id_as, xml_ns_eimala_core)
		end

	process_type_dec_as (l_as: TYPE_DEC_AS)
		do
			conditionally_open_xml  (node_type_dec_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_type_dec_as, xml_ns_eimala_core)
		end

	process_body_as (l_as: BODY_AS)
		do
			conditionally_open_xml  (node_body_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_body_as, xml_ns_eimala_core)
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			conditionally_open_xml  (node_feature_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_feature_as, xml_ns_eimala_core)
		end

	process_feature_clause_as (l_as: FEATURE_CLAUSE_AS)
		do
			conditionally_open_xml  (node_feature_clause_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_feature_clause_as, xml_ns_eimala_core)
		end

	process_class_list_as (l_as: CLASS_LIST_AS)
			-- Process `l_as'.
		do
			conditionally_open_xml  (node_class_list_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_class_list_as, xml_ns_eimala_core)
		end

	process_class_as (l_as: CLASS_AS)
		do
			conditionally_open_xml  (node_class_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_class_as, xml_ns_eimala_core)
		end

	process_index_as (l_as: INDEX_AS)
		do
			conditionally_open_xml  (node_index_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_index_as, xml_ns_eimala_core)
		end

	process_nested_as (l_as: NESTED_AS)
		do
			conditionally_open_xml  (node_nested_as, xml_ns_eimala_core)

			conditionally_open_other_xml  ("target", xml_ns_eimala_core, node_nested_as)
			process_child (l_as.target, l_as, 1)
			conditionally_close_other_xml ("target", xml_ns_eimala_core, node_nested_as)

			output.append_string (ti_dot)

			conditionally_open_other_xml  ("message", xml_ns_eimala_core, node_nested_as)
			process_child (l_as.message, l_as, 2)
			conditionally_close_other_xml ("message", xml_ns_eimala_core, node_nested_as)

			conditionally_close_xml (node_nested_as, xml_ns_eimala_core)
		end

	process_create_as (l_as: CREATE_AS)
		do
			conditionally_open_xml  (node_create_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_create_as, xml_ns_eimala_core)
		end

	process_client_as (l_as: CLIENT_AS)
		do
			conditionally_open_xml  (node_client_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_client_as, xml_ns_eimala_core)
		end

feature {AST_EIFFEL} -- Roundtrip: Routine body

	process_attribute_as (l_as: ATTRIBUTE_AS)
		do
			conditionally_open_xml  (node_attribute_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_attribute_as, xml_ns_eimala_core)
		end

	process_deferred_as (l_as: DEFERRED_AS)
		do
			conditionally_open_xml  (node_deferred_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_deferred_as, xml_ns_eimala_core)
		end

	process_do_as (l_as: DO_AS)
		do
			conditionally_open_xml  (node_do_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_do_as, xml_ns_eimala_core)
		end

	process_once_as (l_as: ONCE_AS)
		do
			conditionally_open_xml  (node_once_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_once_as, xml_ns_eimala_core)
		end

	process_external_as (l_as: EXTERNAL_AS)
		do
			conditionally_open_xml  (node_external_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_external_as, xml_ns_eimala_core)
		end

feature {AST_EIFFEL} -- Roundtrip: Agents

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		do
			conditionally_open_xml  (node_inline_agent_creation_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_inline_agent_creation_as, xml_ns_eimala_core)
		end

	process_agent_routine_creation_as (l_as: AGENT_ROUTINE_CREATION_AS)
		do
			conditionally_open_xml  (node_agent_routine_creation_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_agent_routine_creation_as, xml_ns_eimala_core)
		end

	process_operand_as (l_as: OPERAND_AS)
		do
			conditionally_open_xml  (node_operand_as, xml_ns_eimala_core)
			Precursor (l_as)
			conditionally_close_xml (node_operand_as, xml_ns_eimala_core)
		end

feature -- Quantifications

	process_there_exists_as (a_as: THERE_EXISTS_AS)
			-- Process `a_as'.
		do
			conditionally_open_xml  (node_there_exists_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_there_exists_as, xml_ns_eimala_core)
		end

	process_for_all_as (a_as: FOR_ALL_AS)
			-- Process `a_as'.
		do
			conditionally_open_xml  (node_for_all_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_for_all_as, xml_ns_eimala_core)
		end

feature {AST_EIFFEL} -- Binary Operators

	process_bin_and_as (a_as: BIN_AND_AS)
		do
			conditionally_open_xml  (node_bin_and_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_and_as, xml_ns_eimala_core)
		end

	process_bin_and_then_as (a_as: BIN_AND_THEN_AS)
		do
			conditionally_open_xml  (node_bin_and_then_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_and_then_as, xml_ns_eimala_core)
		end

	process_bin_free_as (a_as: BIN_FREE_AS)
		do
			conditionally_open_xml  (node_bin_free_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_free_as, xml_ns_eimala_core)
		end

	process_bin_implies_as (a_as: BIN_IMPLIES_AS)
		do
			conditionally_open_xml  (node_bin_implies_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_implies_as, xml_ns_eimala_core)
		end

	process_bin_or_as (a_as: BIN_OR_AS)
		do
			conditionally_open_xml  (node_bin_or_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_or_as, xml_ns_eimala_core)
		end

	process_bin_or_else_as (a_as: BIN_OR_ELSE_AS)
		do
			conditionally_open_xml  (node_bin_or_else_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_or_else_as, xml_ns_eimala_core)
		end

	process_bin_xor_as (a_as: BIN_XOR_AS)
		do
			conditionally_open_xml  (node_bin_xor_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_xor_as, xml_ns_eimala_core)
		end

	process_bin_eq_as (a_as: BIN_EQ_AS)
		do
			conditionally_open_xml  (node_bin_eq_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_eq_as, xml_ns_eimala_core)
		end

	process_bin_ne_as (a_as: BIN_NE_AS)
		do
			conditionally_open_xml  (node_bin_ne_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_ne_as, xml_ns_eimala_core)
		end

	process_bin_tilde_as (a_as: BIN_TILDE_AS)
		do
			conditionally_open_xml  (node_bin_tilde_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_tilde_as, xml_ns_eimala_core)
		end

	process_bin_not_tilde_as (a_as: BIN_NOT_TILDE_AS)
		do
			conditionally_open_xml  (node_bin_not_tilde_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_not_tilde_as, xml_ns_eimala_core)
		end

feature {AST_EIFFEL} -- Binary Operators (Comparison)

	process_bin_ge_as (a_as: BIN_GE_AS)
		do
			conditionally_open_xml  (node_bin_ge_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_ge_as, xml_ns_eimala_core)
		end

	process_bin_gt_as (a_as: BIN_GT_AS)
		do
			conditionally_open_xml  (node_bin_gt_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_gt_as, xml_ns_eimala_core)
		end

	process_bin_le_as (a_as: BIN_LE_AS)
		do
			conditionally_open_xml  (node_bin_le_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_le_as, xml_ns_eimala_core)
		end

	process_bin_lt_as (a_as: BIN_LT_AS)
		do
			conditionally_open_xml  (node_bin_lt_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_lt_as, xml_ns_eimala_core)
		end

feature {AST_EIFFEL} -- Binary Operators - Arithmetic

	process_bin_div_as (a_as: BIN_DIV_AS)
		do
			conditionally_open_xml  (node_bin_div_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_div_as, xml_ns_eimala_core)
		end

	process_bin_minus_as (a_as: BIN_MINUS_AS)
		do
			conditionally_open_xml  (node_bin_minus_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_minus_as, xml_ns_eimala_core)
		end

	process_bin_mod_as (a_as: BIN_MOD_AS)
		do
			conditionally_open_xml  (node_bin_mod_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_mod_as, xml_ns_eimala_core)
		end

	process_bin_plus_as (a_as: BIN_PLUS_AS)
		do
			conditionally_open_xml  (node_bin_lt_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_lt_as, xml_ns_eimala_core)
		end

	process_bin_power_as (a_as: BIN_POWER_AS)
		do
			conditionally_open_xml  (node_bin_power_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_power_as, xml_ns_eimala_core)
		end

	process_bin_slash_as (a_as: BIN_SLASH_AS)
		do
			conditionally_open_xml  (node_bin_slash_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_slash_as, xml_ns_eimala_core)
		end

	process_bin_star_as (a_as: BIN_STAR_AS)
		do
			conditionally_open_xml  (node_bin_star_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_bin_star_as, xml_ns_eimala_core)
		end


feature {AST_EIFFEL} -- Unary Operators

	process_un_free_as (a_as: UN_FREE_AS)
		do
			conditionally_open_xml  (node_un_free_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_un_free_as, xml_ns_eimala_core)
		end

	process_un_minus_as (a_as: UN_MINUS_AS)
		do
			conditionally_open_xml  (node_un_minus_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_un_minus_as, xml_ns_eimala_core)
		end

	process_un_not_as (a_as: UN_NOT_AS)
		do
			conditionally_open_xml  (node_un_not_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_un_not_as, xml_ns_eimala_core)
		end

	process_un_old_as (a_as: UN_OLD_AS)
		do
			conditionally_open_xml  (node_un_old_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_un_old_as, xml_ns_eimala_core)
		end

	process_un_plus_as (a_as: UN_PLUS_AS)
		do
			conditionally_open_xml  (node_un_plus_as, xml_ns_eimala_core)
			Precursor (a_as)
			conditionally_close_xml (node_un_plus_as, xml_ns_eimala_core)
		end

feature -- Roundtrip Creation

	process_create_creation_as (a_as: CREATE_CREATION_AS)
			-- Process `a_as'.
		do
			processing_creation_as (a_as, node_create_creation_as)
		end

	process_bang_creation_as (a_as: BANG_CREATION_AS)
			-- Process `a_as'.
		do
			processing_creation_as (a_as, node_bang_creation_as)
		end

	process_create_creation_expr_as (a_as: CREATE_CREATION_EXPR_AS)
			-- Process `a_as'.
		do
			processing_creation_expr_as (a_as, node_create_creation_expr_as)
		end

	process_bang_creation_expr_as (a_as: BANG_CREATION_EXPR_AS)
			-- Process `a_as'.
		do
			processing_creation_expr_as (a_as, node_bang_creation_expr_as)
		end

end
