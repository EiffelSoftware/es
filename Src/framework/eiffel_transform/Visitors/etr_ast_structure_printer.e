note
	description: "Prints an ast while depending purely on structure information (no matchlist needed)"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_STRUCTURE_PRINTER
inherit
	SHARED_NAMES_HEAP
		export
			{NONE} all
		end
	AST_ITERATOR
		redefine
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
			process_infix_prefix_as
		end
	REFACTORING_HELPER
		export
			{NONE} all
		end
create
	make_with_output

feature {NONE} -- Implementation

	processing_needed(an_ast: AST_EIFFEL; a_parent: AST_EIFFEL; a_branch: INTEGER): BOOLEAN
			-- should `an_ast' be processed
		do
			Result := attached an_ast
		end

	process(l_as: AST_EIFFEL; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- Process `l_as'
		do
			if attached l_as then
				l_as.process (Current)
			end
		end

	internal_enter_child_ast(an_ast: AST_EIFFEL) is
			-- enter `an_ast'
		do
			if attached an_ast then
				output.enter_child (an_ast.generating_type)
			else
				output.enter_child ("VOID")
			end
		end

	process_child_list (l_as: EIFFEL_LIST[AST_EIFFEL]; separator: STRING; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- process `l_as' and use `separator' for string output
		do
			internal_enter_child_ast (l_as)
			process_list_with_separator (l_as, separator, a_parent, a_branch)
			output.exit_child
		end

	process_child_block_list (l_as: EIFFEL_LIST[AST_EIFFEL]; separator: STRING; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- process `l_as' and use `separator' for string output
		do
			internal_enter_child_ast (l_as)
			output.enter_block
			process_list_with_separator (l_as, separator, a_parent, a_branch)
			output.exit_block
			output.exit_child
		end

	process_list_with_separator (l_as: detachable EIFFEL_LIST[AST_EIFFEL]; separator: detachable STRING; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- process `l_as' and use `separator' for string output
		local
			l_cursor: INTEGER
		do
			if attached l_as then
				from
					l_cursor := l_as.index
					l_as.start
				until
					l_as.after
				loop
					process_child (l_as.item, l_as, l_as.index)
					if attached separator and l_as.index /= l_as.count then
						output.append_string(separator)
					end
					l_as.forth
				end
				l_as.go_i_th (l_cursor)
			end
		end

	process_identifier_list (l_as: IDENTIFIER_LIST)
			-- process `l_as'
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
				output.append_string(names_heap.item (l_as.item))
				if l_as.index /= l_as.count then
					output.append_string(", ")
				end

				l_as.forth
			end
			l_as.go_i_th (l_cursor)
		end

	make_with_output,set_output(an_output: like output)
			-- make with `an_output'
		do
			output := an_output
		end

	process_block (l_as: AST_EIFFEL; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- process as block
		do
			output.enter_block
			process(l_as, a_parent, a_branch)
			output.exit_block
		end

	process_child (l_as: AST_EIFFEL; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- process as child
		do
			internal_enter_child_ast(l_as)
			process(l_as, a_parent, a_branch)
			output.exit_child
		end

	process_child_block (l_as: AST_EIFFEL; a_parent: AST_EIFFEL; a_branch: INTEGER)
			-- process as child and block
		do
			output.enter_block
			internal_enter_child_ast (l_as)
			process(l_as, a_parent, a_branch)
			output.exit_child
			output.exit_block
		end

feature -- Output

	output: ETR_AST_STRUCTURE_OUTPUT

	print_ast_to_output(an_ast: detachable AST_EIFFEL)
			-- prints `an_ast' to `output'
		do
			process_child (an_ast, void, 0)
		end

feature -- Roundtrip: Atomic

	process_bit_const_as (l_as: BIT_CONST_AS)
		do
			output.append_string (l_as.value.name)
			output.append_string ("b")
		end

	process_bool_as (l_as: BOOL_AS)
		do
			output.append_string (l_as.string_value)
		end

	process_char_as (l_as: CHAR_AS)
		do
			output.append_string (l_as.string_value)
		end

	process_typed_char_as (l_as: TYPED_CHAR_AS)
		do
			output.append_string ("{")
			process_child(l_as.type, l_as, 1)
			output.append_string ("}")
			output.append_string (l_as.string_value)
		end

	process_string_as (l_as: STRING_AS)
		do
			output.append_string (l_as.string_value)
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
		do
			output.append_string (l_as.string_value)
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			output.append_string (l_as.string_value)
		end

	process_real_as (l_as: REAL_AS)
		do
			output.append_string (l_as.value)
		end

	process_id_as (l_as: ID_AS)
		do
			output.append_string (l_as.name)
		end

	process_unique_as (l_as: UNIQUE_AS)
		do
			output.append_string ("unique")
		end

feature -- Roundtrip: Instructions

	process_case_as (l_as: CASE_AS)
		do
			output.append_string ("when ")
			process_child(l_as.interval, l_as, 1)
			output.append_string (" then%N")
			process_child_block (l_as.compound, l_as, 2)
		end

	process_interval_as (l_as: INTERVAL_AS)
		do
			process_child(l_as.lower, l_as, 1)
			if processing_needed (l_as.upper, l_as, 2) then
				output.append_string ("..")
				process_child(l_as.upper, l_as, 2)
			end
		end

	process_inspect_as (l_as: INSPECT_AS)
		do
			output.append_string ("inspect%N")
			process_child_block (l_as.switch, l_as, 1)
			output.append_string ("%N")

			process_child (l_as.case_list, l_as, 2)

			if processing_needed (l_as.else_part, l_as, 3) then
				output.append_string ("else%N")
				process_child_block (l_as.else_part, l_as, 3)
			end

			output.append_string ("end%N")
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			process_child (l_as.call, l_as, 1)
			output.append_string("%N")
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			process_child (l_as.target, l_as, 1)
			process_child (l_as.source, l_as, 2)
			output.append_string("%N")
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			process_child (l_as.target, l_as, 1)
			output.append_string(" := ")
			process_child (l_as.source, l_as, 2)
			output.append_string("%N")
		end

	process_creation_as (l_as: CREATION_AS)
		do
			output.append_string ("create ")

			if processing_needed (l_as.type, l_as, 2) then
				output.append_string("{")
				process_child (l_as.type, l_as, 2)
				output.append_string("} ")
			end
			process(l_as.target, l_as, 1)
			if processing_needed (l_as.call, l_as, 3) then
				output.append_string (".")
			end
			process_child (l_as.call, l_as, 3)
			output.append_string("%N")
		end

	process_debug_as (l_as: DEBUG_AS)
		do
			output.append_string("debug%N")
			process_child_block(l_as.compound, l_as, 1)
			output.append_string("end%N")
		end

	process_check_as (l_as: CHECK_AS)
		do
			output.append_string ("check%N")
			process_child_block (l_as.check_list, l_as, 1)
			output.append_string ("end%N")
		end

	process_retry_as (l_as: RETRY_AS)
		do
			output.append_string ("retry%N")
		end

	process_if_as (l_as: IF_AS)
		do
			output.append_string ("if ")
			process_child (l_as.condition, l_as, 1)
			output.append_string (" then%N")
			process_child_block (l_as.compound, l_as, 2)
			process_child (l_as.elsif_list, l_as, 3)

			if processing_needed (l_as.else_part, l_as, 4) then
				output.append_string("else%N")
				process_child_block_list(l_as.else_part, void, l_as, 4)
			end
			output.append_string ("end%N")
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			output.append_string ("elseif ")
			process_child(l_as.expr, l_as, 1)
			output.append_string (" then%N")
			process_child_block_list(l_as.compound, void, l_as, 2)
		end

	process_loop_as (l_as: LOOP_AS)
		do
			output.append_string("from%N")
			process_child_block(l_as.from_part, l_as, 1)

			if processing_needed (l_as.full_invariant_list, l_as, 2) then
				output.append_string ("invariant%N")
				process_child_block_list(l_as.full_invariant_list, void, l_as, 2)
				output.append_string ("%N")
			end

			if processing_needed (l_as.variant_part, l_as, 5) then
				output.append_string ("variant%N")
				process_child_block(l_as.variant_part, l_as, 5)
				output.append_string ("%N")
			end

			output.append_string ("until%N")
			process_child_block (l_as.stop, l_as, 3)
			output.append_string ("%N")

			output.append_string ("loop%N")

			if processing_needed (l_as.compound, l_as, 4) then
				process_child_block_list(l_as.compound, void, l_as, 4)
			end

			output.append_string ("end%N")
		end

feature -- Roundtrip: Inheritance

	process_rename_as (l_as: RENAME_AS)
		do
			process(l_as.old_name, l_as, 1)
			output.append_string (" as ")
			process (l_as.new_name, l_as, 2)
		end

	process_export_item_as (l_as: EXPORT_ITEM_AS)
		do
			process_child (l_as.clients, l_as, 1)
			output.append_string (" ")
			process_child (l_as.features, l_as, 2)
			output.append_string ("%N")
		end

	process_all_as (l_as: ALL_AS)
		do
			output.append_string ("all")
		end

	process_parent_as (l_as: PARENT_AS)
		local
			was_processed: BOOLEAN
		do
			process_child(l_as.type, l_as, 1)

			output.append_string ("%N")

			output.enter_block

			if processing_needed (l_as.renaming, l_as, 2) then
				output.append_string ("rename%N")
				output.enter_block
				process_child_list(l_as.renaming, ",%N", l_as, 2)
				output.append_string ("%N")
				output.exit_block
				was_processed := true
			end

			if processing_needed (l_as.exports, l_as, 3) then
				output.append_string ("export%N")
				process_child_block_list(l_as.exports, void, l_as, 3)
				was_processed := true
			end

			if processing_needed (l_as.undefining, l_as, 4) then
				output.append_string ("undefine%N")
				output.enter_block
				process_child_list (l_as.undefining, ",%N", l_as, 4)
				output.append_string ("%N")
				output.exit_block
				was_processed := true
			end

			if processing_needed (l_as.redefining, l_as, 5) then
				output.append_string ("redefine%N")
				output.enter_block
				process_child_list (l_as.redefining, ",%N", l_as, 5)
				output.append_string ("%N")
				output.exit_block
				was_processed := true
			end

			if processing_needed (l_as.selecting, l_as, 6) then
				output.append_string ("select%N")
				output.enter_block
				process_child_list (l_as.selecting, "%N", l_as, 6)
				output.append_string ("%N")
				output.exit_block
				was_processed := true
			end

			if was_processed then
				output.append_string ("end%N")
			end

			output.exit_block
		end

feature -- Roundtrip: Contracts

	process_variant_as (l_as: VARIANT_AS)
		do
			process_child(l_as.expr, l_as, 1)
		end

	process_invariant_as (l_as: INVARIANT_AS)
		do
			output.append_string ("invariant%N")
			process_child_block_list(l_as.full_assertion_list, void, l_as, 1)
		end

	process_require_as (l_as: REQUIRE_AS)
		do
			output.append_string ("require%N")
			process_child_block (l_as.full_assertion_list, l_as, 1)
		end

	process_require_else_as (l_as: REQUIRE_ELSE_AS)
		do

			output.append_string ("require else%N")
			process_child_block (l_as.full_assertion_list, l_as, 1)
		end

	process_ensure_as (l_as: ENSURE_AS)
		do
			output.append_string ("ensure%N")
			process_child_block (l_as.full_assertion_list, l_as, 1)
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS)
		do
			output.append_string ("ensure then%N")
			process_child_block (l_as.full_assertion_list, l_as, 1)
		end

feature -- Roundtrip: Types

	process_bits_as (l_as: BITS_AS)
		do
			output.append_string ("bit ")
			process(l_as.bits_value, l_as, 1)
		end

	process_class_type_as (l_as: CLASS_TYPE_AS)
		do
			if l_as.is_separate then
				output.append_string ("separate ")
			end

			if l_as.has_attached_mark then
				output.append_string ("attached ")
			elseif l_as.has_detachable_mark then
				output.append_string ("detachable ")
			end

			process_child(l_as.class_name, l_as, 1)
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS)
		do
			if l_as.is_separate then
				output.append_string ("separate ")
			end

			if l_as.has_attached_mark then
				output.append_string ("attached ")
			elseif l_as.has_detachable_mark then
				output.append_string ("detachable ")
			end


			process_child(l_as.class_name, l_as, 1)
			output.append_string ("[")
			process_child_list (l_as.generics, ", ", l_as, 2)
			output.append_string ("]")
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS)
		do
			if l_as.is_separate then
				output.append_string ("separate ")
			end

			if l_as.has_attached_mark then
				output.append_string ("attached ")
			elseif l_as.has_detachable_mark then
				output.append_string ("detachable ")
			end

			process_child(l_as.class_name, l_as, 1)
			process_child(l_as.parameters, l_as, 2)
		end

	process_constraining_type_as (l_as: CONSTRAINING_TYPE_AS)
		do
			process_child(l_as.type, l_as, 1)
			process_child(l_as.renaming, l_as, 2)
		end

	process_like_id_as (l_as: LIKE_ID_AS)
		do
			if l_as.has_attached_mark then
				output.append_string ("attached ")
			elseif l_as.has_detachable_mark then
				output.append_string ("detachable ")
			end

			output.append_string ("like ")
			process(l_as.anchor, l_as, 1)
		end

	process_like_cur_as (l_as: LIKE_CUR_AS)
		do

		if l_as.has_attached_mark then
				output.append_string ("attached ")
			elseif l_as.has_detachable_mark then
				output.append_string ("detachable ")
			end
			output.append_string ("like current")
		end

	process_formal_as (l_as: FORMAL_AS)
		do
			if l_as.is_expanded then
				output.append_string ("expanded ")
			elseif l_as.is_reference then
				output.append_string ("reference ")
			end

			process (l_as.name, l_as, 1)
		end

feature -- Roundtrip: Expressions

	process_converted_expr_as (l_as: CONVERTED_EXPR_AS)
		do
			process_child(l_as.expr, l_as, 1)
		end

	process_address_result_as (l_as: ADDRESS_RESULT_AS)
		do
			output.append_string ("$result")
		end

	process_address_current_as (l_as: ADDRESS_CURRENT_AS)
		do
			output.append_string ("$current")
		end

	process_un_strip_as (l_as: UN_STRIP_AS)
		do
			output.append_string ("strip (")
			process_identifier_list (l_as.id_list)
			output.append_string (")")
		end

	process_address_as (l_as: ADDRESS_AS)
		do
			output.append_string ("$")
			process_child(l_as.feature_name, l_as, 1)
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			process_child(l_as.call, l_as, 1)
		end

	process_expr_address_as (l_as: EXPR_ADDRESS_AS)
		do
			output.append_string ("$(")
			process_child(l_as.expr, l_as, 1)
			output.append_string (")")
		end

	process_type_expr_as (l_as: TYPE_EXPR_AS)
		do
			process_child (l_as.type, l_as, 1)
		end

	process_custom_attribute_as (l_as: CUSTOM_ATTRIBUTE_AS)
		do
			process_child (l_as.creation_expr, l_as, 1)
			process_child (l_as.tuple, l_as, 2)
		end

	process_array_as (l_as: ARRAY_AS)
		do
			output.append_string ("<< ")
			process_child_list (l_as.expressions, ", ", l_as, 1)
			output.append_string (" >>")
		end

	process_bracket_as (l_as: BRACKET_AS)
		do
			process_child(l_as.target, l_as, 1)
			output.append_string ("[")

			process_child_list (l_as.operands, ", ", l_as, 2)

			output.append_string ("]")
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			if attached {BINARY_AS}l_as.target or attached {UNARY_AS}l_as.target or attached {OBJECT_TEST_AS}l_as.target then
				output.append_string ("(")
				process_child(l_as.target, l_as, 1)
				output.append_string (")")
			else
				process_child(l_as.target, l_as, 1)
			end

			output.append_string (".")
			process_child(l_as.message, l_as, 2)
		end

	process_tuple_as (l_as: TUPLE_AS)
		do
			output.append_string ("[")
			process_child_list (l_as.expressions, ", ", l_as, 1)
			output.append_string ("]")
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
			if processing_needed (l_as.tag, l_as, 1) then
				process(l_as.tag, l_as, 1)
				output.append_string(": ")
			end

			process_child(l_as.expr, l_as, 2)
			output.append_string ("%N")
		end

	process_void_as (l_as: VOID_AS)
		do
			output.append_string ("void")
		end

	process_paran_as (l_as: PARAN_AS)
		do
			output.append_string ("(")
			process_child(l_as.expr, l_as, 1)
			output.append_string (")")
		end

	process_binary_as (l_as: BINARY_AS)
		do
			process_child (l_as.left, l_as, 1)
			output.append_string (" ")
			process_child (l_as.op_name, l_as, 2)
			output.append_string (" ")
			process_child (l_as.right, l_as, 3)
		end

	process_unary_as (l_as: UNARY_AS)
		do
			output.append_string (l_as.operator_name)
			output.append_string (" ")
			process_child (l_as.expr, l_as, 1)
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			if l_as.is_attached_keyword then
				output.append_string ("attached ")
				if processing_needed (l_as.type, l_as, 1) then
					output.append_string ("{")
					process_child (l_as.type, l_as, 1)
					output.append_string ("}")
				end
				process_child (l_as.expression, l_as, 2)
				output.append_string (" as ")
				output.append_string (l_as.name.name)
			else
				fixme("How does this look / is this possible ?")
				process_child(l_as.type, l_as, 1)
				process_child(l_as.expression, l_as, 2)
			end
		end

feature -- Roundtrip: Access

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			output.append_string ("feature {")
			process_child(l_as.class_type, l_as, 1)
			output.append_string ("}.")
			output.append_string (l_as.feature_name.name)
			if processing_needed (l_as.parameters, l_as, 2) then
				output.append_string ("(")
				process_child_list (l_as.parameters, ", ", l_as, 2)
				output.append_string (")")
			end
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		do
			output.append_string ("precursor ")
			if processing_needed (l_as.parent_base_class,l_as,1) then
				output.append_string ("{")
				process_child(l_as.parent_base_class, l_as, 1)
				output.append_string ("}")
			end
			process_child(l_as.parameters, l_as, 2)
		end

	process_result_as (l_as: RESULT_AS)
		do
			output.append_string ("result")
		end

	process_current_as (l_as: CURRENT_AS)
		do
			output.append_string ("current")
		end

	process_access_inv_as (l_as: ACCESS_INV_AS)
		do
			process(l_as.feature_name, l_as, 1)
			if processing_needed (l_as.parameters,l_as,2) then
				output.append_string (" (")
				process_child_list(l_as.parameters, ", ",l_as,2)
				output.append_string (")")
			end
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			output.append_string (l_as.access_name)

			if processing_needed (l_as.parameters,l_as,1) then
				output.append_string (" (")
				process_child_list(l_as.parameters, ", ", l_as, 1)
				output.append_string (")")
			end
		end

feature -- Roundtrip: Inheritance clauses

	process_rename_clause_as (l_as: RENAME_CLAUSE_AS)
		do
			output.append_string (" rename ")
			process_child_list(l_as.content, ", ", l_as, 1)
			output.append_string (" end ")
		end

	process_export_clause_as (l_as: EXPORT_CLAUSE_AS)
		do
			fixme("When/How is this used?")
			process_child(l_as.content, l_as, 1)
		end

	process_undefine_clause_as (l_as: UNDEFINE_CLAUSE_AS)
		do
			fixme("When/How is this used?")
			process_child(l_as.content, l_as, 1)
		end

	process_redefine_clause_as (l_as: REDEFINE_CLAUSE_AS)
		do
			fixme("When/How is this used?")
			process_child(l_as.content, l_as, 1)
		end

	process_select_clause_as (l_as: SELECT_CLAUSE_AS)
		do
			fixme("When/How is this used?")
			process_child(l_as.content, l_as, 1)
		end

feature -- Roundtrip: Misc

	process_infix_prefix_as (l_as: INFIX_PREFIX_AS)
		do
			if l_as.is_frozen then
				output.append_string ("frozen ")
			end

			if l_as.is_prefix then
				output.append_string ("prefix ")
			elseif l_as.is_infix then
				output.append_string ("infix ")
			end

			process(l_as.alias_name, l_as, 1)
		end

	process_formal_dec_as (l_as: FORMAL_DEC_AS)
		do
			process_child(l_as.formal, l_as, 1)

			output.append_string (" -> ")

			if l_as.constraints.count>1 then
				output.append_string ("{")
			end
			process_child_list (l_as.constraints, ", ", l_as, 2)
			if l_as.constraints.count>1 then
				output.append_string ("}")
			end

			if processing_needed (l_as.creation_feature_list, l_as, 3) then
				output.append_string (" create ")
				process_child_list(l_as.creation_feature_list, ", ", l_as, 3)
				output.append_string (" end")
			end
		end

	process_creation_expr_as (l_as: CREATION_EXPR_AS)
		do
			output.append_string ("create {")
			process_child(l_as.type, l_as, 1)
			output.append_string ("}")
			process_child(l_as.call, l_as, 2)
		end

	process_routine_as (l_as: ROUTINE_AS)
		do
			if processing_needed (l_as.obsolete_message, l_as, 1) then
				output.append_string ("obsolete%N")
				process_block (l_as.obsolete_message, l_as, 1)
				output.append_string ("%N")
			end

			process_child (l_as.precondition, l_as, 2)

			if processing_needed (l_as.locals, l_as, 3) then
				output.append_string ("local%N")
				output.enter_block
				process_child_list (l_as.locals, "%N", l_as, 3)
				output.append_string ("%N")
				output.exit_block
			end

			process_child(l_as.routine_body, l_as, 4)

			process_child (l_as.postcondition, l_as, 5)

			if processing_needed (l_as.rescue_clause, l_as, 6) then
				output.append_string("rescue%N")
				process_child_block (l_as.rescue_clause, l_as, 6)
			end

			output.append_string("end%N")
		end

	process_constant_as (l_as: CONSTANT_AS)
		do
			process  (l_as.value, l_as, 1)
		end

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
		local
			l_cursor: INTEGER
		do
			from
				l_cursor := l_as.index
				l_as.start
			until
				l_as.after
			loop
				process_child(l_as.item, l_as, l_as.index)
				l_as.forth
			end
			l_as.go_i_th (l_cursor)
		end

	process_convert_feat_as (l_as: CONVERT_FEAT_AS)
		do
			process_child(l_as.feature_name, l_as, 1)
			output.append_string (": {")
			process_child_list(l_as.conversion_types, ", ", l_as, 2)
			output.append_string ("}")
		end

	process_feature_name_alias_as (l_as: FEATURE_NAME_ALIAS_AS)
		do
			if l_as.is_frozen then
				output.append_string("frozen ")
			end

			process(l_as.feature_name, l_as, 1)

			if processing_needed (l_as.alias_name,l_as,2) then
				output.append_string (" alias ")
				process_child (l_as.alias_name, l_as, 2)
			end
		end

	process_feat_name_id_as (l_as: FEAT_NAME_ID_AS)
		do
			if l_as.is_frozen then
				output.append_string("frozen ")
			end

			process(l_as.feature_name, l_as, 1)

			if processing_needed (l_as.alias_name, l_as, 2) then
				output.append_string (" alias ")
				process_child (l_as.alias_name, l_as, 2)
			end
		end

	process_type_dec_as (l_as: TYPE_DEC_AS)
		do
			process_identifier_list (l_as.id_list)
			output.append_string(": ")
			process_child(l_as.type, l_as, 1)
		end

	process_body_as (l_as: BODY_AS)
		do
			if processing_needed (l_as.arguments, l_as, 1) then
				output.append_string ("(")
				process_child_list(l_as.arguments, "; ", l_as, 1)
				output.append_string (")")
			end

			if processing_needed (l_as.type, l_as, 2) then
				output.append_string (":")
				process_child (l_as.type, l_as, 2)
			end

			if l_as.is_constant then
				output.append_string(" is ")
			elseif processing_needed (l_as.assigner, l_as, 3) then
				output.append_string (" assign ")
				process_child (l_as.assigner, l_as, 3)
			elseif l_as.is_unique then
				output.append_string (" is unique")
			else
				output.append_string("%N")
			end

			if processing_needed (l_as.content, l_as, 4) then
				process_child_block(l_as.content, l_as, 4)
			end

			output.append_string("%N")

			process_child(l_as.indexing_clause, l_as, 5)
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			process_child_list(l_as.feature_names, ", ", l_as, 1)
			process_child(l_as.body, l_as, 2)
		end

	process_feature_clause_as (l_as: FEATURE_CLAUSE_AS)
		do
			output.append_string("feature ")
			process_child(l_as.clients, l_as, 1)
			output.append_string("%N")
			process_child_block (l_as.features, l_as, 2)
		end

	process_class_list_as (l_as: CLASS_LIST_AS)
			-- Process `l_as'.
		do
			output.append_string("{")
			process_child_list(l_as, ", ", l_as, 1)
			output.append_string ("}")
		end

	process_class_as (l_as: CLASS_AS)
		local
			strout: ETR_AST_STRING_OUTPUT
		do
			strout ?= output

			if l_as.is_deferred then
				output.append_string("deferred ")
			end

			if l_as.is_frozen then
				output.append_string("frozen ")
			end

			if l_as.is_expanded then
				output.append_string("expanded ")
			end

			if l_as.is_partial then
				output.append_string("partial ")
			end

			process_child(l_as.top_indexes, l_as, 1)
			output.append_string ("class%N")
			output.enter_block
			process_child(l_as.class_name, l_as, 2)

			if processing_needed (l_as.generics, l_as, 3) then
				output.append_string ("[")
				process_child_list (l_as.generics, ", ", l_as, 3)
				output.append_string ("]")
			end
			output.append_string("%N")
			output.exit_block

			if processing_needed (l_as.obsolete_message, l_as, 4) then
				output.append_string("obsolete")
				process_child_block(l_as.obsolete_message, l_as, 4)
			end

			if processing_needed (l_as.parents, l_as, 5)  then
				output.append_string ("inherit%N")
				process_child_block (l_as.parents, l_as, 5)
			end

			process_child (l_as.creators, l_as, 6)

			if processing_needed (l_as.convertors, l_as, 7)  then
				output.append_string ("convert%N")
				output.enter_block
				process_child_list(l_as.convertors, ",%N", l_as, 7)
				output.append_string ("%N")
				output.exit_block
			end

			output.append_string("%N")

			process_child(l_as.features, l_as, 8)
			process_child(l_as.invariant_part, l_as, 9)
			process_child(l_as.bottom_indexes, l_as, 10)
			output.append_string ("end%N")
		end

	process_index_as (l_as: INDEX_AS)
		do
			process_child(l_as.index_list, l_as, 1)
		end

	process_nested_as (l_as: NESTED_AS)
		do
			process_child (l_as.target, l_as, 1)
			output.append_string (".")
			process_child (l_as.message, l_as, 2)
		end

	process_create_as (l_as: CREATE_AS)
		do
			output.append_string ("create ")
			process_child(l_as.clients, l_as, 1)
			output.append_string ("%N")

			output.enter_block
			process_child_list (l_as.feature_list, ",%N", l_as, 2)
			output.append_string ("%N")
			output.exit_block
		end

	process_client_as (l_as: CLIENT_AS)
		do
			output.append_string ("{")
			process_child_list (l_as.clients, ", ", l_as, 1)
			output.append_string ("}")
		end

feature -- Roundtrip: Routine body

	process_attribute_as (l_as: ATTRIBUTE_AS)
		do
			output.append_string ("attribute%N")
			process_child_block (l_as.compound, l_as, 1)
			output.append_string ("%N")
		end

	process_deferred_as (l_as: DEFERRED_AS)
		do
			output.append_string ("deferred%N")
		end

	process_do_as (l_as: DO_AS)
		do
			output.append_string ("do%N")
			process_child_block (l_as.compound, l_as, 1)
		end

	process_once_as (l_as: ONCE_AS)
		do
			output.append_string ("once%N")
			process_child_block (l_as.compound, l_as, 1)
		end

	process_external_as (l_as: EXTERNAL_AS)
		do
			output.append_string ("external%N")
			output.enter_block
			if l_as.is_built_in then
				output.append_string ("%"built_in%"")
			else
				process(l_as.language_name.language_name, l_as, 1)
			end
			output.exit_block
			output.append_string ("%N")

			if processing_needed (l_as.alias_name_literal, l_as, 2) then
				output.append_string ("alias%N")
				process_block (l_as.alias_name_literal, l_as, 2)
				output.append_string ("%N")
			end
		end

feature -- Roundtrip: Agents

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		do
			output.enter_block
			output.append_string ("%N")
			output.append_string ("agent ")

			process_child(l_as.body, l_as, 1)

			if processing_needed(l_as.operands, l_as, 2) then
				output.append_string ("(")
				process_child_list (l_as.operands, ", ", l_as, 2)
				output.append_string (")")
			end
			output.exit_block
		end

	process_agent_routine_creation_as (l_as: AGENT_ROUTINE_CREATION_AS)
		do
			output.append_string ("agent ")

			process_child(l_as.target,l_as, 1)
			process_child(l_as.feature_name,l_as, 2)
			if processing_needed (l_as.operands,l_as,3) then
				output.append_string ("(")
				process_child_list(l_as.operands, ", ", l_as, 3)
				output.append_string (")")
			end
		end

	process_operand_as (l_as: OPERAND_AS)
		do
			if l_as.is_open then
				if processing_needed (l_as.class_type, l_as, 1) then
					output.append_string ("{")
					process_child (l_as.class_type, l_as, 1)
					output.append_string ("}")
				end
				output.append_string ("?")
			else
				process_child(l_as.target, l_as, 3)
				process_child(l_as.expression, l_as, 2)
			end
		end
note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
