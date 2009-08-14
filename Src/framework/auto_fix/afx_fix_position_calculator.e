note
	description: "[
		Given an ast node, immediately surrounding the exception place, in a feature, which is also in the form of ast,
		the calculator locates the most inner instruction-level ast node containing the exception ast. For example, for an exception ast node
		in condition part of `if', the most inner instruction-level ast node would be the one for the `if' instruction.

		To do this, we cache the last possible instruction-level ast node in `last_position_ast', when the exception point
		ast is found, we push `last_position_ast' to the end of `containing_ast'.
		
		TODO: The search should stop when we have found such an ast node.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_POSITION_CALCULATOR

inherit
	AST_ITERATOR
		redefine
		    	-- redefined feature list from `AST_DEBUGGER_BREAKABLE_STRATEGY'
		    	-- `exception_ast' can only be of the these types
--			process_routine_as,		-- only ast inside feature considered
			process_inline_agent_creation_as,
			process_assign_as,
			process_assigner_call_as,
			process_creation_as,
			process_elseif_as,
			process_if_as,
			process_inspect_as,
			process_instr_call_as,
			process_loop_as,
			process_variant_as,
--			process_retry_as,		-- should never fail
			process_reverse_as,
			process_tagged_as,
			process_object_test_as,
			process_nested_as,

				-- complementary redefined feature list
				-- descendants of `INSTRUCTION_AS', before which we can insert fixes
			process_debug_as,
			process_check_as
		end

create
    make

feature

    make (a_feature_ast: CLASS_AS; an_exception_ast: AST_EIFFEL)
    	do
    	    feature_ast := a_feature_ast
    	    exception_ast := an_exception_ast
    	end
feature

    calculate_fix_position
    		-- start calculation
    	do
    	    instruction_ast := Void
    	    last_instruction_ast := Void

    	    feature_ast.process(Current)
    	end

feature -- Access

	exception_ast: AST_EIFFEL
    		-- the ast containing the exception point

    feature_ast: AST_EIFFEL
    		-- the ast of the feature containing `exception_ast'

	last_instruction_ast: detachable AST_EIFFEL
			-- the containing instruction-level ast node of current ast

	instruction_ast: detachable AST_EIFFEL
			-- the instruction-level ast directly containing the `exception_ast'.

	has_found: BOOLEAN
			-- have we already found the instruction-level ast node?
		do
			Result := instruction_ast /= Void
		end

feature -- implementation

	safe_process_if_not_found (l_as: AST_EIFFEL)
			-- process further if `not has_found'
		do
		    if not has_found and then l_as /= Void then
		        l_as.process (Current)
		    end
		end

	test_ast_against_exception_ast (l_as: detachable AST_EIFFEL)
			-- set `instruction_ast' to `last_instruction_ast' if `l_as' is what we are looking for
		do
		    	-- TODO: object comparison is NOT enough
		    if exception_ast.same_type(l_as) and then exception_ast.is_equivalent (l_as)
		    		and then exception_ast.start_position = l_as.start_position then
		    	check
		    		unique_instruction_ast: instruction_ast = Void or else instruction_ast = last_instruction_ast
		    	end
		    	instruction_ast := last_instruction_ast
		    end
		end

feature -- process of insturctions

	process_assign_as (l_as: ASSIGN_AS)
			-- check out the evaluation order
		do
		    last_instruction_ast := l_as

			test_ast_against_exception_ast (l_as)

			Precursor(l_as)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
		    last_instruction_ast := l_as

			test_ast_against_exception_ast (l_as)

			Precursor(l_as)
		end

	process_reverse_as (l_as: REVERSE_AS)
		do
		    last_instruction_ast := l_as

			test_ast_against_exception_ast (l_as)

			Precursor(l_as)
		end

	process_check_as (l_as: CHECK_AS)
		do
		    last_instruction_ast := l_as

			test_ast_against_exception_ast (l_as)

			Precursor(l_as)
		end

	process_debug_as (l_as: DEBUG_AS)
		do
		    last_instruction_ast := l_as

			test_ast_against_exception_ast (l_as)

			Precursor(l_as)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
		    last_instruction_ast := l_as

--			if instruction_ast /= Void then
--			    instruction_ast := l_as
--			end
			test_ast_against_exception_ast (l_as)

--			Precursor(l_as)
		end

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		do
			test_ast_against_exception_ast (l_as)

			Precursor(l_as)
		end

	process_creation_as (l_as: CREATION_AS)
		do
		    last_instruction_ast := l_as

			test_ast_against_exception_ast (l_as)

			Precursor(l_as)
		end

feature -- process expressions

	process_variant_as (l_as: VARIANT_AS)
		do
		    	-- failure in expression should be fixed before the enclosing instruction
		    -- last_instruction_ast := l_as

			test_ast_against_exception_ast (l_as)

			Precursor(l_as)
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
		    	-- assertion failure should always be fixed before the assertion
		    -- last_instruction_ast := l_as

			test_ast_against_exception_ast (l_as)

			Precursor(l_as)
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
		    	-- failure in expression should be fixed before the enclosing instruction
		    -- last_instruction_ast := l_as

			test_ast_against_exception_ast (l_as)

			Precursor(l_as)
		end

	process_nested_as (l_as: NESTED_AS)
		do
		    	-- failure in expression should be fixed before the enclosing instruction
		    -- last_instruction_ast := l_as

			test_ast_against_exception_ast (l_as)

			Precursor(l_as)
		end

feature -- process of program structs

	process_if_as (l_as: IF_AS)
		local
		    l_elsif: detachable ELSIF_AS
		do
		    last_instruction_ast := l_as

				-- fix should be applied before `IF_AS' for exceptions in evaluating condition of `if'
			test_ast_against_exception_ast (l_as)

				-- fix should be applied before `IF_AS' for exceptions in evaluating conditions of `elseif'
			if attached l_as.elsif_list as l_elseif_list then
			    from l_elseif_list.start
			    until l_elseif_list.after
			    loop
			        l_elsif := l_elseif_list.item_for_iteration
			        test_ast_against_exception_ast (l_elsif)
			        l_elseif_list.forth
			    end
			end

			Precursor (l_as)
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
		    last_instruction_ast := l_as

			-- although `exception_ast' could be of type `ELSIF_AS', we do NOT test here
			-- To avoid reporting `exception_ast' in `ELSIF_AS' multiple times, they should have be caught in `process_if_as'
			-- test_ast_against_exception_ast (l_as)

			Precursor(l_as)
		end

	process_inspect_as (l_as: INSPECT_AS)
		do
		    last_instruction_ast := l_as

				-- for exceptions raised during evaluating the inspect expression
			test_ast_against_exception_ast (l_as)

			Precursor(l_as)
		end

	process_loop_as (l_as: LOOP_AS)
		do
		    last_instruction_ast := l_as

			test_ast_against_exception_ast (l_as)

	        	-- special order, see `AST_DEBUGGER_BREAKABLE_STRATEGY'
	        safe_process_if_not_found (l_as.stop)

	        safe_process_if_not_found (l_as.from_part)
	        safe_process_if_not_found (l_as.invariant_part)
	        safe_process_if_not_found (l_as.compound)
	        safe_process_if_not_found (l_as.variant_part)
		end


--	process_retry_as (l_as: RETRY_AS)
--		do
--		end

--		: consists instruction list
--	process_case_as (l_as: CASE_AS)
--		do
--		end

--		:
--	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS)
--			-- Process `l_as'.
--		do
--			process_creation_expr_as (l_as)
--		end

--	process_bang_creation_expr_as (l_as: BANG_CREATION_EXPR_AS)
--			-- Process `l_as'.
--		do
--			process_creation_expr_as (l_as)
--		end

--feature {NONE} -- Implementation

--	process_custom_attribute_as (l_as: CUSTOM_ATTRIBUTE_AS)
--		do
--			l_as.creation_expr.process (Current)
--			safe_process (l_as.tuple)
--		end

--	process_id_as (l_as: ID_AS)
--		do
--				-- Nothing to be done
--		end

--	process_integer_as (l_as: INTEGER_AS)
--		do
--				-- Nothing to be done
--		end

--	process_static_access_as (l_as: STATIC_ACCESS_AS)
--		do
--			l_as.class_type.process (Current)
--			safe_process (l_as.internal_parameters)
--		end

--	process_feature_clause_as (l_as: FEATURE_CLAUSE_AS)
--		do
--			safe_process (l_as.clients)
--			l_as.features.process (Current)
--		end

--	process_unique_as (l_as: UNIQUE_AS)
--		do
--				-- Nothing to be done
--		end

--	process_tuple_as (l_as: TUPLE_AS)
--		do
--			l_as.expressions.process (Current)
--		end

--	process_real_as (l_as: REAL_AS)
--		do
--				-- Nothing to be done
--		end

--	process_bool_as (l_as: BOOL_AS)
--		do
--				-- Nothing to be done
--		end

--	process_bit_const_as (l_as: BIT_CONST_AS)
--		do
--				-- Nothing to be done
--		end

--	process_array_as (l_as: ARRAY_AS)
--		do
--			l_as.expressions.process (Current)
--		end

--	process_char_as (l_as: CHAR_AS)
--		do
--				-- Nothing to be done
--		end

--	process_string_as (l_as: STRING_AS)
--		do
--				-- Nothing to be done
--		end

--	process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
--		do
--				-- Nothing to be done
--		end

--		: consists
--	process_body_as (l_as: BODY_AS)
--		do
--			safe_process (l_as.arguments)
--			safe_process (l_as.type)
--			safe_process (l_as.assigner)
--			safe_process (l_as.content)
--		end

--	process_built_in_as (l_as: BUILT_IN_AS)
--			-- Process `l_as'.
--		do
--			process_external_as (l_as)
--		end

--	process_result_as (l_as: RESULT_AS)
--		do
--				-- Nothing to be done
--		end

--	process_current_as (l_as: CURRENT_AS)
--		do
--				-- Nothing to be done
--		end

--	process_access_feat_as (l_as: ACCESS_FEAT_AS)
--		do
--			safe_process (l_as.internal_parameters)
--		end

--	process_access_inv_as (l_as: ACCESS_INV_AS)
--		do
--			process_access_feat_as (l_as)
--		end

--	process_access_id_as (l_as: ACCESS_ID_AS)
--		do
--			process_access_feat_as (l_as)
--		end

--	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
--		do
--			process_access_feat_as (l_as)
--		end

--	process_precursor_as (l_as: PRECURSOR_AS)
--		do
--			safe_process (l_as.parent_base_class)
--			safe_process (l_as.internal_parameters)
--		end

--	process_nested_expr_as (l_as: NESTED_EXPR_AS)
--		do
--			l_as.target.process (Current)
--			l_as.message.process (Current)
--		end

--	process_nested_as (l_as: NESTED_AS)
--		do
--			l_as.target.process (Current)
--			l_as.message.process (Current)
--		end

--	process_creation_expr_as (l_as: CREATION_EXPR_AS)
--		do
--			l_as.type.process (Current)
--			safe_process (l_as.call)
--		end

--	process_type_expr_as (l_as: TYPE_EXPR_AS)
--		do
--			l_as.type.process (Current)
--		end

--	process_routine_as (l_as: ROUTINE_AS)
--		do
--			safe_process (l_as.precondition)
--			safe_process (l_as.locals)
--			l_as.routine_body.process (Current)
--			safe_process (l_as.postcondition)
--			safe_process (l_as.rescue_clause)
--		end

--	process_constant_as (l_as: CONSTANT_AS)
--		do
--			l_as.value.process (Current)
--		end

--	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
--		local
--			l_cursor: INTEGER
--		do
--			from
--				l_cursor := l_as.index
--				l_as.start
--			until
--				l_as.after
--			loop
--				l_as.item.process (Current)
--				l_as.forth
--			end
--			l_as.go_i_th (l_cursor)
--		end

--	process_indexing_clause_as (l_as: INDEXING_CLAUSE_AS)
--		do
--			process_eiffel_list (l_as)
--		end

--	process_operand_as (l_as: OPERAND_AS)
--		do
--			safe_process (l_as.class_type)
--			safe_process (l_as.expression)
--			safe_process (l_as.target)
--		end

--	process_tagged_as (l_as: TAGGED_AS)
--		do
--			safe_process (l_as.expr)
--				-- It is valid to have tags without expressions.
--		end

--	process_variant_as (l_as: VARIANT_AS)
--		do
--			l_as.expr.process (Current)
--		end

--	process_un_strip_as (l_as: UN_STRIP_AS)
--		do
--				-- Nothing to be done
--		end

--	process_converted_expr_as (l_as: CONVERTED_EXPR_AS)
--		do
--			l_as.expr.process (Current)
--		end

--	process_paran_as (l_as: PARAN_AS)
--		do
--			l_as.expr.process (Current)
--		end

--	process_expr_call_as (l_as: EXPR_CALL_AS)
--		do
--			l_as.call.process (Current)
--		end

--	process_expr_address_as (l_as: EXPR_ADDRESS_AS)
--		do
--			l_as.expr.process (Current)
--		end

--	process_address_result_as (l_as: ADDRESS_RESULT_AS)
--		do
--				-- Nothing to be done
--		end

--	process_address_current_as (l_as: ADDRESS_CURRENT_AS)
--		do
--				-- Nothing to be done
--		end

--	process_address_as (l_as: ADDRESS_AS)
--		do
--				-- Nothing to be done
--		end

--	process_routine_creation_as (l_as: ROUTINE_CREATION_AS)
--		do
--			safe_process (l_as.target)
--			safe_process (l_as.feature_name)
--			safe_process (l_as.operands)
--		end

--	process_unary_as (l_as: UNARY_AS)
--		do
--			l_as.expr.process (Current)
--		end

--	process_un_free_as (l_as: UN_FREE_AS)
--		do
--			process_unary_as (l_as)
--		end

--	process_un_minus_as (l_as: UN_MINUS_AS)
--		do
--			process_unary_as (l_as)
--		end

--	process_un_not_as (l_as: UN_NOT_AS)
--		do
--			process_unary_as (l_as)
--		end

--	process_un_old_as (l_as: UN_OLD_AS)
--		do
--			process_unary_as (l_as)
--		end

--	process_un_plus_as (l_as: UN_PLUS_AS)
--		do
--			process_unary_as (l_as)
--		end

--	process_binary_as (l_as: BINARY_AS)
--		do
--			l_as.left.process (Current)
--			l_as.right.process (Current)
--		end

--	process_bin_and_then_as (l_as: BIN_AND_THEN_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_free_as (l_as: BIN_FREE_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_implies_as (l_as: BIN_IMPLIES_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_or_as (l_as: BIN_OR_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_or_else_as (l_as: BIN_OR_ELSE_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_xor_as (l_as: BIN_XOR_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_ge_as (l_as: BIN_GE_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_gt_as (l_as: BIN_GT_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_le_as (l_as: BIN_LE_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_lt_as (l_as: BIN_LT_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_div_as (l_as: BIN_DIV_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_minus_as (l_as: BIN_MINUS_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_mod_as (l_as: BIN_MOD_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_plus_as (l_as: BIN_PLUS_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_power_as (l_as: BIN_POWER_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_slash_as (l_as: BIN_SLASH_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_star_as (l_as: BIN_STAR_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_and_as (l_as: BIN_AND_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_eq_as (l_as: BIN_EQ_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_ne_as (l_as: BIN_NE_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_tilde_as (l_as: BIN_TILDE_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bin_not_tilde_as (l_as: BIN_NOT_TILDE_AS)
--		do
--			process_binary_as (l_as)
--		end

--	process_bracket_as (l_as: BRACKET_AS)
--		do
--			l_as.target.process (Current)
--			l_as.operands.process (Current)
--		end

--	process_object_test_as (l_as: OBJECT_TEST_AS)
--		do
--			if l_as.is_attached_keyword then
--				safe_process (l_as.type)
--				l_as.expression.process (Current)
--				safe_process (l_as.name)
--			else
--				l_as.name.process (Current)
--				l_as.type.process (Current)
--				l_as.expression.process (Current)
--			end
--		end

--	process_external_lang_as (l_as: EXTERNAL_LANG_AS)
--		do
--				-- Nothing to be done
--		end

--	process_feature_as (l_as: FEATURE_AS)
--		do
--			l_as.feature_names.process (Current)
--			l_as.body.process (Current)
--				-- Feature indexing clause is processed after feature body because
--				-- information such as arguments are stored in body so they must be processed first.
--			safe_process (l_as.indexes)
--		end

--	process_infix_prefix_as (l_as: INFIX_PREFIX_AS)
--		do
--				-- Nothing to be done
--		end

--	process_feat_name_id_as (l_as: FEAT_NAME_ID_AS)
--		do
--				-- Nothing to be done
--		end

--	process_feature_name_alias_as (l_as: FEATURE_NAME_ALIAS_AS)
--			-- Process `l_as'.
--		do
--				-- Nothing to be done.
--		end

--	process_feature_list_as (l_as: FEATURE_LIST_AS)
--		do
--			l_as.features.process (Current)
--		end

--	process_all_as (l_as: ALL_AS)
--		do
--				-- Nothing to be done
--		end

--	process_external_as (l_as: EXTERNAL_AS)
--		do
--				-- Nothing to be done
--		end

--	process_deferred_as (l_as: DEFERRED_AS)
--		do
--				-- Nothing to be done
--		end

--	process_attribute_as (l_as: ATTRIBUTE_AS)
--		do
--			safe_process (l_as.compound)
--		end

--	process_do_as (l_as: DO_AS)
--		do
--			safe_process (l_as.compound)
--		end

--	process_once_as (l_as: ONCE_AS)
--		do
--			safe_process (l_as.compound)
--		end

--	process_type_dec_as (l_as: TYPE_DEC_AS)
--		do
--			l_as.type.process (Current)
--		end

--	process_class_as (l_as: CLASS_AS)
--		do
--			safe_process (l_as.top_indexes)
--			l_as.class_name.process (Current)
--			safe_process (l_as.generics)
--			safe_process (l_as.parents)
--			safe_process (l_as.creators)
--			safe_process (l_as.convertors)
--			safe_process (l_as.features)
--			safe_process (l_as.invariant_part)
--			safe_process (l_as.bottom_indexes)
--		end

--	process_parent_as (l_as: PARENT_AS)
--		do
--			l_as.type.process (Current)
--			safe_process (l_as.renaming)
--			safe_process (l_as.exports)
--			safe_process (l_as.undefining)
--			safe_process (l_as.redefining)
--			safe_process (l_as.selecting)
--		end

--	process_like_id_as (l_as: LIKE_ID_AS)
--		do
--				-- Nothing to be done
--		end

--	process_like_cur_as (l_as: LIKE_CUR_AS)
--		do
--				-- Nothing to be done
--		end

--	process_formal_as (l_as: FORMAL_AS)
--		do
--				-- Nothing to be done
--		end

--	process_formal_dec_as (l_as: FORMAL_DEC_AS)
--		do
--			safe_process (l_as.constraints)
--			safe_process (l_as.creation_feature_list)
--		end

--	process_constraining_type_as (l_as: CONSTRAINING_TYPE_AS)
--		do
--			l_as.type.process (Current)
--			safe_process (l_as.renaming)
--		end

--	process_class_type_as (l_as: CLASS_TYPE_AS)
--		do
--			l_as.class_name.process (Current)
--		end

--	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS)
--		do
--			l_as.class_name.process (Current)
--			l_as.internal_generics.process (Current)
--		end

--	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS)
--		do
--			l_as.class_name.process (Current)
--			safe_process (l_as.parameters)
--		end

--	process_none_type_as (l_as: NONE_TYPE_AS)
--		do
--				-- Nothing to be done
--		end

--	process_bits_as (l_as: BITS_AS)
--		do
--				-- Nothing to be done
--		end

--	process_bits_symbol_as (l_as: BITS_SYMBOL_AS)
--		do
--				-- Nothing to be done
--		end

--	process_rename_as (l_as: RENAME_AS)
--		do
--			l_as.old_name.process (Current)
--			l_as.new_name.process (Current)
--		end

--	process_invariant_as (l_as: INVARIANT_AS)
--		do
--			safe_process (l_as.assertion_list)
--		end

--	process_interval_as (l_as: INTERVAL_AS)
--		do
--			l_as.lower.process (Current)
--			safe_process (l_as.upper)
--		end

--	process_index_as (l_as: INDEX_AS)
--		do
--			l_as.index_list.process (Current)
--		end

--	process_export_item_as (l_as: EXPORT_ITEM_AS)
--		do
--			l_as.clients.process (Current)
--			safe_process (l_as.features)
--		end

--	process_elseif_as (l_as: ELSIF_AS)
--		do
--			l_as.expr.process (Current)
--			safe_process (l_as.compound)
--		end

--	process_create_as (l_as: CREATE_AS)
--		do
--			safe_process (l_as.clients)
--			safe_process (l_as.feature_list)
--		end

--	process_client_as (l_as: CLIENT_AS)
--		do
--			l_as.clients.process (Current)
--		end

--	process_ensure_as (l_as: ENSURE_AS)
--		do
--			safe_process (l_as.assertions)
--		end

--	process_ensure_then_as (l_as: ENSURE_THEN_AS)
--		do
--			safe_process (l_as.assertions)
--		end

--	process_require_as (l_as: REQUIRE_AS)
--		do
--			safe_process (l_as.assertions)
--		end

--	process_require_else_as (l_as: REQUIRE_ELSE_AS)
--		do
--			safe_process (l_as.assertions)
--		end

--	process_convert_feat_as (l_as: CONVERT_FEAT_AS)
--		do
--			l_as.feature_name.process (Current)
--			l_as.conversion_types.process (Current)
--		end

--	process_void_as (l_as: VOID_AS)
--		do
--				-- Nothing to be done
--		end

--	process_type_list_as (l_as: TYPE_LIST_AS)
--			-- Process `l_as'.
--		do
--			process_eiffel_list (l_as)
--		end

--	process_type_dec_list_as (l_as: TYPE_DEC_LIST_AS)
--			-- Process `l_as'.
--		do
--			process_eiffel_list (l_as)
--		end

--	process_convert_feat_list_as (l_as: CONVERT_FEAT_LIST_AS)
--			-- Process `l_as'.
--		do
--			process_eiffel_list (l_as)
--		end

--	process_class_list_as (l_as: CLASS_LIST_AS)
--			-- Process `l_as'.
--		do
--			process_eiffel_list (l_as)
--		end

--	process_parent_list_as (l_as: PARENT_LIST_AS)
--			-- Process `l_as'.
--		do
--			process_eiffel_list (l_as)
--		end

--	process_local_dec_list_as (l_as: LOCAL_DEC_LIST_AS)
--			-- Process `l_as'.
--		do
--			l_as.locals.process (Current)
--		end

--	process_formal_argu_dec_list_as (l_as: FORMAL_ARGU_DEC_LIST_AS)
--			-- Process `l_as'.
--		do
--			l_as.arguments.process (Current)
--		end

--	process_debug_key_list_as (l_as: DEBUG_KEY_LIST_AS)
--			-- Process `l_as'.
--		do
--			l_as.keys.process (Current)
--		end

--	process_delayed_actual_list_as (l_as: DELAYED_ACTUAL_LIST_AS)
--			-- Process `l_as'.
--		do
--			l_as.operands.process (Current)
--		end

--	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
--			-- Process `l_as'.
--		local
--			l_list: EIFFEL_LIST [EXPR_AS]
--		do
--			l_list := l_as.parameters
--			if l_list /= Void and then not l_list.is_empty then
--				l_list.process (Current)
--			end
--		end

--	process_rename_clause_as (l_as: RENAME_CLAUSE_AS)
--			-- Process `l_as'.
--		do
--			safe_process (l_as.content)
--		end

--	process_export_clause_as (l_as: EXPORT_CLAUSE_AS)
--			-- Process `l_as'.
--		do
--			safe_process (l_as.content)
--		end

--	process_undefine_clause_as (l_as: UNDEFINE_CLAUSE_AS)
--			-- Process `l_as'.
--		do
--			safe_process (l_as.content)
--		end

--	process_redefine_clause_as (l_as: REDEFINE_CLAUSE_AS)
--			-- Process `l_as'.
--		do
--			safe_process (l_as.content)
--		end

--	process_select_clause_as (l_as: SELECT_CLAUSE_AS)
--			-- Process `l_as'.
--		do
--			safe_process (l_as.content)
--		end

--	process_formal_generic_list_as (l_as: FORMAL_GENERIC_LIST_AS)
--			-- Process `l_as'.
--		do
--			process_eiffel_list (l_as)
--		end


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
