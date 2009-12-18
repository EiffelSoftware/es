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

	process_list_with_separator (l_as: EIFFEL_LIST[AST_EIFFEL]; separator: STRING)
		do
			from
				l_as.start
			until
				l_as.after
			loop
				process_child (l_as.item)
				if l_as.index /= l_as.count then
					output.append_string(separator)
				end
				l_as.forth
			end
		end

	process_identifier_list (l_as: IDENTIFIER_LIST)
		do
			-- process the id's list
			-- which is not an ast but an array of indexes into the names heap
			from
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
		end

	make_with_output,set_output(an_output: like output)
			-- make with `an_output'
		do
			output := an_output
		end

	process_block (l_as: AST_EIFFEL)
			-- process as block
		do
			if attached l_as then
				output.enter_block
				l_as.process (Current)
				output.exit_block
			end
		end

	process_child (l_as: AST_EIFFEL)
			-- process as child
		do
			if attached l_as then
				output.enter_child(l_as.generating_type)
				l_as.process (Current)
				output.exit_child
			end
		end

	process_child_block (l_as: AST_EIFFEL)
			-- process as child and block
		do
			if attached l_as then
				output.enter_child(l_as.generating_type)
				output.enter_block
				l_as.process (Current)
				output.exit_block
				output.exit_child
			end
		end

feature -- Output

	output: ETR_AST_STRUCTURE_OUTPUT

	print_ast_to_output(an_ast: detachable AST_EIFFEL)
			-- prints `an_ast' to `output'
		do
			process_child (an_ast)
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
			process_child(l_as.type)
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
			process_child(l_as.interval)
			output.append_string (" then%N")
			process_child_block (l_as.compound)
		end

	process_interval_as (l_as: INTERVAL_AS)
		do
			process_child(l_as.lower)
			if attached l_as.upper then
				output.append_string ("..")
			end
			process_child(l_as.upper)
		end

	process_inspect_as (l_as: INSPECT_AS)
		do
			output.append_string ("inspect%N")
			process_child_block (l_as.switch)
			output.append_string ("%N")

			process_child (l_as.case_list)

			if attached l_as.else_part then
				output.append_string ("else%N")
				process_child_block (l_as.else_part)
			end

			output.append_string ("end%N")
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			process_child (l_as.call)
			output.append_string("%N")
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			process_child (l_as.target)
			process_child (l_as.source)
			output.append_string("%N")
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			process_child (l_as.target)
			output.append_string(" := ")
			process_child (l_as.source)
			output.append_string("%N")
		end

	process_creation_as (l_as: CREATION_AS)
		do
			output.append_string ("create ")
			l_as.target.process (Current)
			if attached l_as.type then
				output.append_string("{")
				process_child (l_as.type)
				output.append_string("}")
			end

			process_child (l_as.call)
			output.append_string("%N")
		end

	process_debug_as (l_as: DEBUG_AS)
		do
			output.append_string("debug%N")
			process_child_block(l_as.compound)
			output.append_string("end%N")
		end

	process_check_as (l_as: CHECK_AS)
		do
			output.append_string ("check%N")
			process_child_block (l_as.check_list)
			output.append_string ("end%N")
		end

	process_retry_as (l_as: RETRY_AS)
		do
			output.append_string ("retry%N")
		end

	process_if_as (l_as: IF_AS)
		do
			output.append_string ("if ")
			process_child (l_as.condition)
			output.append_string (" then%N")
			process_child_block (l_as.compound)
			process_child (l_as.elsif_list)
			if attached l_as.else_part then
				output.append_string("else%N")
				process_child_block (l_as.else_part)
			end
			output.append_string ("end%N")
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			output.append_string ("elseif ")
			process_child(l_as.expr)
			output.append_string (" then%N")
			process_child_block(l_as.compound)
		end

	process_loop_as (l_as: LOOP_AS)
		do
			output.append_string("from%N")
			process_child_block(l_as.from_part)

			if attached l_as.full_invariant_list as l and then not l.is_empty then
				output.append_string ("invariant%N")
				process_child_block(l)
				output.append_string ("%N")
			end

			if attached l_as.variant_part as v then
				output.append_string ("variant%N")
				process_child_block(v)
				output.append_string ("%N")
			end

			output.append_string ("until%N")
			process_child_block (l_as.stop)
			output.append_string ("%N")

			output.append_string ("loop%N")

			if attached l_as.compound then
				process_child_block(l_as.compound)
			end

			output.append_string ("end%N")
		end

feature -- Roundtrip: Inheritance

	process_rename_as (l_as: RENAME_AS)
		do
			process_child(l_as.old_name)
			output.append_string (" as ")
			process_child(l_as.new_name)
		end

	process_export_item_as (l_as: EXPORT_ITEM_AS)
		do
			process_child (l_as.clients)
			output.append_string (" ")
			process_child (l_as.features)
			output.append_string ("%N")
		end

	process_all_as (l_as: ALL_AS)
		do
			output.append_string ("all")
		end

	process_parent_as (l_as: PARENT_AS)
		do
			process_child(l_as.type)

			output.append_string ("%N")

			output.enter_block

			if attached l_as.renaming then
				output.append_string ("rename%N")
				output.enter_child(l_as.renaming.generating_type)
				output.enter_block
				process_list_with_separator (l_as.renaming, ",%N")
				output.append_string ("%N")
				output.exit_block
				output.exit_child
			end

			if attached l_as.exports then
				output.append_string ("export%N")
				process_child_block (l_as.exports)
			end

			if attached l_as.undefining then
				output.append_string ("undefine%N")
				output.enter_child(l_as.undefining.generating_type)
				output.enter_block
				process_list_with_separator (l_as.undefining, ",%N")
				output.append_string ("%N")
				output.exit_block
				output.exit_child
			end

			if attached l_as.redefining then
				output.append_string ("redefine%N")
				output.enter_child(l_as.redefining.generating_type)
				output.enter_block
				process_list_with_separator (l_as.redefining, ",%N")
				output.append_string ("%N")
				output.exit_block
				output.exit_child
			end

			if attached l_as.selecting then
				output.append_string ("select%N")
				output.enter_child(l_as.selecting.generating_type)
				output.enter_block
				process_list_with_separator (l_as.selecting, "%N")
				output.append_string ("%N")
				output.exit_block
				output.exit_child
			end

			if attached l_as.renaming or attached l_as.exports or attached l_as.undefining or attached l_as.redefining or attached l_as.selecting then
				output.append_string ("end%N")
			end

			output.exit_block
		end

feature -- Roundtrip: Contracts

	process_variant_as (l_as: VARIANT_AS)
		do
			process_child(l_as.expr)
		end

	process_invariant_as (l_as: INVARIANT_AS)
		do
			output.append_string ("invariant%N")
			process_child_block (l_as.full_assertion_list)
		end

	process_require_as (l_as: REQUIRE_AS)
		do
			output.append_string ("require%N")
			process_child_block (l_as.full_assertion_list)
		end

	process_require_else_as (l_as: REQUIRE_ELSE_AS)
		do

			output.append_string ("require else%N")
			process_child_block (l_as.full_assertion_list)
		end

	process_ensure_as (l_as: ENSURE_AS)
		do
			output.append_string ("ensure%N")
			process_child_block (l_as.full_assertion_list)
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS)
		do
			output.append_string ("ensure then%N")
			process_child_block (l_as.full_assertion_list)
		end

feature -- Roundtrip: Types

	process_bits_as (l_as: BITS_AS)
		do
			output.append_string ("bit ")
			process_child (l_as.bits_value)
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

			process_child(l_as.class_name)
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

			process_child(l_as.class_name)
			output.append_string ("[")
			output.enter_child (l_as.generics.generating_type)
			process_list_with_separator (l_as.generics, ", ")
			output.exit_child
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

			process_child(l_as.class_name)
			process_child(l_as.parameters)
		end

	process_constraining_type_as (l_as: CONSTRAINING_TYPE_AS)
		do
			process_child(l_as.type)
			process_child(l_as.renaming)
		end

	process_like_id_as (l_as: LIKE_ID_AS)
		do
			if l_as.has_attached_mark then
				output.append_string ("attached ")
			elseif l_as.has_detachable_mark then
				output.append_string ("detachable ")
			end

			output.append_string ("like ")
			l_as.anchor.process (Current)
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

			safe_process (l_as.name)
		end

feature -- Roundtrip: Expressions

	process_converted_expr_as (l_as: CONVERTED_EXPR_AS)
		do
			process_child(l_as.expr)
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
			process_child(l_as.feature_name)
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			process_child(l_as.call)
		end

	process_expr_address_as (l_as: EXPR_ADDRESS_AS)
		do
			output.append_string ("$(")
			process_child(l_as.expr)
			output.append_string (")")
		end

	process_type_expr_as (l_as: TYPE_EXPR_AS)
		do
			process_child (l_as.type)
		end

	process_custom_attribute_as (l_as: CUSTOM_ATTRIBUTE_AS)
		do
			process_child (l_as.creation_expr)
			process_child (l_as.tuple)
		end

	process_array_as (l_as: ARRAY_AS)
		do
			output.append_string ("<< ")
			output.enter_child (l_as.expressions.generating_type)
			process_list_with_separator (l_as.expressions, ", ")
			output.exit_child
			output.append_string (" >>")
		end

	process_bracket_as (l_as: BRACKET_AS)
		do
			process_child(l_as.target)
			output.append_string ("[")

			output.enter_child (l_as.operands.generating_type)
			process_list_with_separator (l_as.operands, ", ")
			output.exit_child

			output.append_string ("]")
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			if attached {BINARY_AS}l_as.target or attached {UNARY_AS}l_as.target or attached {OBJECT_TEST_AS}l_as.target then
				output.append_string ("(")
				process_child(l_as.target)
				output.append_string (")")
			else
				process_child(l_as.target)
			end

			output.append_string (".")
			process_child(l_as.message)
		end

	process_tuple_as (l_as: TUPLE_AS)
		do
			output.append_string ("[")
			output.enter_child (l_as.expressions.generating_type)
			process_list_with_separator (l_as.expressions, ", ")
			output.exit_child
			output.append_string ("]")
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
			if attached l_as.tag then
				process_child(l_as.tag)
				output.append_string(": ")
			end

			process_child(l_as.expr)
			output.append_string ("%N")
		end

	process_void_as (l_as: VOID_AS)
		do
			output.append_string ("void")
		end

	process_paran_as (l_as: PARAN_AS)
		do
			output.append_string ("(")
			process_child(l_as.expr)
			output.append_string (")")
		end

	process_binary_as (l_as: BINARY_AS)
		do
			process_child (l_as.left)
			output.append_string (" ")
			output.append_string (l_as.op_name.name)
			output.append_string (" ")
			process_child (l_as.right)
		end

	process_unary_as (l_as: UNARY_AS)
		do
			output.append_string (l_as.operator_name)
			output.append_string (" ")
			process_child (l_as.expr)
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			if l_as.is_attached_keyword then
				output.append_string ("attached ")
				if attached l_as.type then
					output.append_string ("{")
					process_child (l_as.type)
					output.append_string ("}")
				end
				process_child (l_as.expression)
				output.append_string (" as ")
				output.append_string (l_as.name.name)
			else
				fixme("How does this look / is this possible ?")
				process_child(l_as.type)
				process_child(l_as.expression)
			end
		end

feature -- Roundtrip: Access

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			output.append_string ("feature {")
			process_child(l_as.class_type)
			output.append_string ("}.")
			output.append_string (l_as.feature_name.name)
			if attached l_as.parameters then
				output.append_string ("(")
				output.enter_child (l_as.parameters.generating_type)
				process_list_with_separator (l_as.parameters, ", ")
				output.exit_child
				output.append_string (")")
			end
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		do
			output.append_string ("precursor ")
			if attached l_as.parent_base_class then
				output.append_string ("{")
				process_child(l_as.parent_base_class)
				output.append_string ("}")
			end
			process_child(l_as.parameters)
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
			output.append_string(".")
			process_child(l_as.feature_name)
			process_child(l_as.parameters)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			output.append_string (l_as.access_name)

			if attached l_as.parameters as l_para then
				output.append_string (" (")
				output.enter_child (l_para.generating_type)
				process_list_with_separator (l_para, ", ")
				output.exit_child
				output.append_string (")")
			end
		end

feature -- Roundtrip: Inheritance clauses

	process_rename_clause_as (l_as: RENAME_CLAUSE_AS)
		do
			output.append_string (" rename ")
			output.enter_child (l_as.content.generating_type)
			process_list_with_separator (l_as.content, ", ")
			output.exit_child
			output.append_string (" end ")
		end

	process_export_clause_as (l_as: EXPORT_CLAUSE_AS)
		do
			fixme("When/How is this used?")
			process_child(l_as.content)
		end

	process_undefine_clause_as (l_as: UNDEFINE_CLAUSE_AS)
		do
			fixme("When/How is this used?")
			process_child(l_as.content)
		end

	process_redefine_clause_as (l_as: REDEFINE_CLAUSE_AS)
		do
			fixme("When/How is this used?")
			process_child(l_as.content)
		end

	process_select_clause_as (l_as: SELECT_CLAUSE_AS)
		do
			fixme("When/How is this used?")
			process_child(l_as.content)
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

			l_as.alias_name.process (Current)
		end

	process_formal_dec_as (l_as: FORMAL_DEC_AS)
		do
			process_child(l_as.formal)

			output.append_string (" -> ")

			if l_as.constraints.count>1 then
				output.append_string ("{")
			end
			output.enter_child (l_as.constraints.generating_type)
			process_list_with_separator (l_as.constraints, ", ")
			output.exit_child
			if l_as.constraints.count>1 then
				output.append_string ("}")
			end

			if attached l_as.creation_feature_list then
				output.append_string (" create ")
				output.enter_child (l_as.creation_feature_list.generating_type)
				process_list_with_separator (l_as.creation_feature_list, ", ")
				output.exit_child
				output.append_string (" end")
			end
		end

	process_creation_expr_as (l_as: CREATION_EXPR_AS)
		do
			output.append_string ("create {")
			process_child(l_as.type)
			output.append_string ("}")
			process_child(l_as.call)
		end

	process_routine_as (l_as: ROUTINE_AS)
		do
			if attached l_as.obsolete_message then
				output.append_string ("obsolete%N")
				process_child_block (l_as.obsolete_message)
				output.append_string ("%N")
			end

			process_child (l_as.precondition)

			if attached l_as.locals then
				output.append_string ("local%N")
				output.enter_child (l_as.locals.generating_type)
				output.enter_block
				process_list_with_separator (l_as.locals, "%N")
				output.exit_block
				output.exit_child
				output.append_string ("%N")
			end

			process_child(l_as.routine_body)

			process_child (l_as.postcondition)

			if attached l_as.rescue_clause then
				output.append_string("rescue%N")
				process_child_block (l_as.rescue_clause)
			end

			output.append_string("end%N")
		end

	process_constant_as (l_as: CONSTANT_AS)
		do
			safe_process  (l_as.value)
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
				process_child(l_as.item)
				l_as.forth
			end
			l_as.go_i_th (l_cursor)
		end

	process_convert_feat_as (l_as: CONVERT_FEAT_AS)
		do
			process_child(l_as.feature_name)
			output.append_string (": {")
			output.enter_child (l_as.conversion_types.generating_type)
			process_list_with_separator (l_as.conversion_types, ", ")
			output.exit_child
			output.append_string ("}")
		end

	process_feature_name_alias_as (l_as: FEATURE_NAME_ALIAS_AS)
		do
			if l_as.is_frozen then
				output.append_string("frozen ")
			end

			process_child (l_as.feature_name)

			if attached l_as.alias_name then
				output.append_string (" alias ")
				process_child (l_as.alias_name)
			end
		end

	process_feat_name_id_as (l_as: FEAT_NAME_ID_AS)
		do
			if l_as.is_frozen then
				output.append_string("frozen ")
			end

			process_child (l_as.feature_name)

			if attached l_as.alias_name then
				output.append_string (" alias ")
				process_child (l_as.alias_name)
			end
		end

	process_type_dec_as (l_as: TYPE_DEC_AS)
		do
			process_identifier_list (l_as.id_list)
			output.append_string(": ")
			process_child(l_as.type)
		end

	process_body_as (l_as: BODY_AS)
		do
			if attached l_as.arguments then
				output.append_string ("(")
				output.enter_child (l_as.arguments.generating_type)
				process_list_with_separator (l_as.arguments, "; ")
				output.exit_child
				output.append_string (")")
			end

			if attached l_as.type then
				output.append_string (":")
				process_child (l_as.type)
			end

			if l_as.is_constant then
				output.append_string(" is ")
			elseif attached l_as.assigner then
				output.append_string (" assign ")
				process_child (l_as.assigner)
			elseif l_as.is_unique then
				output.append_string (" is unique")
			else
				output.append_string("%N")
			end

			if attached l_as.content then
				output.enter_block
				process_child_block(l_as.content)
				output.exit_block
			end

			output.append_string("%N")

			process_child(l_as.indexing_clause)
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			output.enter_child (l_as.feature_names.generating_type)
			process_list_with_separator (l_as.feature_names, ", ")
			output.exit_child

			process_child(l_as.body)
		end

	process_feature_clause_as (l_as: FEATURE_CLAUSE_AS)
		do
			output.append_string("feature ")
			process_child(l_as.clients)
			output.append_string("%N")
			process_child_block (l_as.features)
		end

	process_class_list_as (l_as: CLASS_LIST_AS)
			-- Process `l_as'.
		do
			output.append_string("{")
			output.enter_child (l_as.generating_type)
			process_list_with_separator (l_as, ", ")
			output.exit_child
			output.append_string ("}")
		end

	process_class_as (l_as: CLASS_AS)
		do
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

			process_child(l_as.top_indexes)
			output.append_string ("class%N")
			output.enter_block
			process_child(l_as.class_name)

			if attached l_as.generics then
				output.append_string ("[")
				output.enter_child (l_as.generics.generating_type)
				process_list_with_separator (l_as.generics, ", ")
				output.exit_child
				output.append_string ("]")
			end
			output.append_string("%N")
			output.exit_block

			if attached l_as.obsolete_message then
				output.append_string("obsolete")
				process_child_block(l_as.obsolete_message)
			end

			if attached l_as.parents as p and then not p.is_empty  then
				output.append_string ("inherit%N")
				process_child_block (p)
			end

			process_child (l_as.creators)

			if attached l_as.convertors as c and then not c.is_empty  then
				output.append_string ("convert%N")
				output.enter_child (c.generating_type)
				output.enter_block
				process_list_with_separator (c, ",%N")
				output.exit_block
				output.exit_child
				output.append_string ("%N")
			end

			output.append_string("%N")

			process_child(l_as.features)
			process_child(l_as.invariant_part)
			process_child(l_as.bottom_indexes)
			output.append_string ("end%N")
		end

	process_index_as (l_as: INDEX_AS)
		do
			process_child(l_as.index_list)
		end

	process_nested_as (l_as: NESTED_AS)
		do
			process_child (l_as.target)
			output.append_string (".")
			process_child (l_as.message)
		end

	process_create_as (l_as: CREATE_AS)
		do
			output.append_string ("create ")
			process_child(l_as.clients)
			output.append_string ("%N")

			output.enter_child (l_as.feature_list.generating_type)
			output.enter_block
			process_list_with_separator (l_as.feature_list, ",%N")
			output.append_string ("%N")
			output.exit_block
			output.exit_child
		end

	process_client_as (l_as: CLIENT_AS)
		do
			output.append_string ("{")
			output.enter_child (l_as.clients.generating_type)
			process_list_with_separator (l_as.clients, ", ")
			output.exit_child
			output.append_string ("}")
		end

feature -- Roundtrip: Routine body

	process_attribute_as (l_as: ATTRIBUTE_AS)
		do
			output.append_string ("attribute%N")
			process_child_block (l_as.compound)
			output.append_string ("%N")
		end

	process_deferred_as (l_as: DEFERRED_AS)
		do
			output.append_string ("deferred%N")
		end

	process_do_as (l_as: DO_AS)
		do
			output.append_string ("do%N")
			process_child_block (l_as.compound)
		end

	process_once_as (l_as: ONCE_AS)
		do
			output.append_string ("once%N")
			process_child_block (l_as.compound)
		end

	process_external_as (l_as: EXTERNAL_AS)
		do
			output.append_string ("external%N")
			output.enter_block
			if l_as.is_built_in then
				output.append_string ("%"built_in%"")
			else
				l_as.language_name.language_name.process (Current)
			end
			output.exit_block
			output.append_string ("%N")

			if attached l_as.alias_name_literal then
				output.append_string ("alias%N")
				process_block (l_as.alias_name_literal)
				output.append_string ("%N")
			end
		end

feature -- Roundtrip: Agents

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		do
			output.enter_block
			output.append_string ("%N")
			output.append_string ("agent ")

			process_child(l_as.body)

			if attached l_as.operands then
				output.append_string ("(")
				output.enter_child (l_as.operands.generating_type)
				process_list_with_separator (l_as.operands, ", ")
				output.exit_child
				output.append_string (")")
			end
			output.exit_block
		end

	process_agent_routine_creation_as (l_as: AGENT_ROUTINE_CREATION_AS)
		do
			output.append_string ("agent ")

			process_child(l_as.target)
			process_child(l_as.feature_name)
			if attached l_as.operands then
				output.append_string ("(")
				output.enter_child (l_as.operands.generating_type)
				process_list_with_separator (l_as.operands, ", ")
				output.exit_child
				output.append_string (")")
			end
		end

	process_operand_as (l_as: OPERAND_AS)
		do
			if l_as.is_open then
				if attached l_as.class_type then
					output.append_string ("{")
					process_child (l_as.class_type)
					output.append_string ("}")
				end
				output.append_string ("?")
			else
				process_child(l_as.target)
				process_child(l_as.expression)
			end
		end
note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
