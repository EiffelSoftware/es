note
	description: "Visits all nodes with branches and runs process_n_way_branch"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETR_BRANCH_VISITOR
inherit
	AST_ITERATOR
		undefine
			-- this needs custom processing!
			process_eiffel_list
		redefine
			-- have to redefine all nodes with children!
			process_inline_agent_creation_as,
			process_custom_attribute_as,
			process_static_access_as,
			process_feature_clause_as,
			process_tuple_as,
			process_array_as,
			process_body_as,
			process_access_feat_as,
			process_precursor_as,
			process_nested_expr_as,
			process_nested_as,
			process_creation_expr_as,
			process_type_expr_as,
			process_routine_as,
			process_constant_as,
			process_eiffel_list,
			process_operand_as,
			process_tagged_as,
			process_variant_as,
			process_converted_expr_as,
			process_paran_as,
			process_expr_call_as,
			process_expr_address_as,
			process_routine_creation_as,
			process_unary_as,
			process_binary_as,
			process_bracket_as,
			process_object_test_as,
			process_feature_as,
			process_feature_list_as,
			process_assign_as,
			process_assigner_call_as,
			process_check_as,
			process_creation_as,
			process_if_as,
			process_inspect_as,
			process_instr_call_as,
			process_loop_as,
			process_attribute_as,
			process_do_as,
			process_once_as,
			process_type_dec_as,
			process_class_as,
			process_parent_as,
			process_formal_dec_as,
			process_constraining_type_as,
			process_class_type_as,
			process_generic_class_type_as,
			process_named_tuple_type_as,
			process_rename_as,
			process_invariant_as,
			process_interval_as,
			process_index_as,
			process_export_item_as,
			process_elseif_as,
			process_create_as,
			process_client_as,
			process_case_as,
			process_ensure_as,
			process_ensure_then_as,
			process_require_as,
			process_require_else_as,
			process_convert_feat_as,
			process_local_dec_list_as,
			process_formal_argu_dec_list_as,
			process_debug_key_list_as,
			process_delayed_actual_list_as,
			process_parameter_list_as,
			process_rename_clause_as,
			process_export_clause_as,
			process_undefine_clause_as,
			process_redefine_clause_as,
			process_select_clause_as,
			process_feature_name_alias_as,
			process_address_as
		end

feature {NONE} -- Implementation

	process_n_way_branch(a_parent: AST_EIFFEL; br:TUPLE[AST_EIFFEL]) is
			-- process an n-way branch with parent `a_parent' and branches `br'
		deferred
		end

feature -- Roundtrip

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
			-- Process `l_as'.
		do
			process_n_way_branch(l_as,[l_as.body, l_as.operands])
		end

	process_custom_attribute_as (l_as: CUSTOM_ATTRIBUTE_AS)
		do
			process_n_way_branch(l_as,[l_as.creation_expr, l_as.tuple])
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			process_n_way_branch(l_as,[l_as.class_type, l_as.parameters])
		end

	process_feature_clause_as (l_as: FEATURE_CLAUSE_AS)
		do
			process_n_way_branch(l_as,[l_as.clients, l_as.features])
		end

	process_tuple_as (l_as: TUPLE_AS)
		do
			process_n_way_branch(l_as,[l_as.expressions])
		end

	process_feature_name_alias_as (l_as: FEATURE_NAME_ALIAS_AS)
		do
			process_n_way_branch(l_as,[l_as.feature_name, l_as.alias_name])
		end

	process_array_as (l_as: ARRAY_AS)
		do
			process_n_way_branch(l_as,[l_as.expressions])
		end

	process_body_as (l_as: BODY_AS)
		do
			process_n_way_branch(l_as,[l_as.arguments, l_as.type, l_as.assigner, l_as.content])
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			process_n_way_branch(l_as,[l_as.parameters])
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		do
			process_n_way_branch(l_as,[l_as.parent_base_class, l_as.parameters])
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			process_n_way_branch(l_as,[l_as.target, l_as.message])
		end

	process_nested_as (l_as: NESTED_AS)
		do
			process_n_way_branch(l_as,[l_as.target,l_as.message])
		end

	process_creation_expr_as (l_as: CREATION_EXPR_AS)
		do
			process_n_way_branch(l_as,[l_as.type, l_as.call])
		end

	process_type_expr_as (l_as: TYPE_EXPR_AS)
		do
			process_n_way_branch(l_as,[l_as.type])
		end

	process_routine_as (l_as: ROUTINE_AS)
		do
			process_n_way_branch(l_as,[l_as.precondition, l_as.locals, l_as.routine_body, l_as.postcondition, l_as.rescue_clause])
		end

	process_constant_as (l_as: CONSTANT_AS)
		do
			process_n_way_branch(l_as,[l_as.value])
		end

	process_operand_as (l_as: OPERAND_AS)
		do
			process_n_way_branch(l_as,[l_as.class_type, l_as.expression, l_as.target])
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
			process_n_way_branch(l_as,[l_as.expr])
		end

	process_variant_as (l_as: VARIANT_AS)
		do
			process_n_way_branch(l_as,[l_as.expr])
		end

	process_converted_expr_as (l_as: CONVERTED_EXPR_AS)
		do
			process_n_way_branch(l_as,[l_as.expr])
		end

	process_paran_as (l_as: PARAN_AS)
		do
			process_n_way_branch(l_as,[l_as.expr])
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			process_n_way_branch(l_as,[l_as.call])
		end

	process_address_as (l_as: ADDRESS_AS)
		do
			process_n_way_branch(l_as,[l_as.feature_name])
		end

	process_expr_address_as (l_as: EXPR_ADDRESS_AS)
		do
			process_n_way_branch(l_as,[l_as.expr])
		end

	process_routine_creation_as (l_as: ROUTINE_CREATION_AS)
		do
			process_n_way_branch(l_as,[l_as.target, l_as.feature_name, l_as.operands])
		end

	process_unary_as (l_as: UNARY_AS)
		do
			process_n_way_branch(l_as,[l_as.expr])
		end

	process_binary_as (l_as: BINARY_AS)
		do
			process_n_way_branch(l_as,[l_as.left, l_as.right])
		end

	process_bracket_as (l_as: BRACKET_AS)
		do
			process_n_way_branch(l_as,[l_as.target, l_as.operands])
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			if l_as.is_attached_keyword then
				process_n_way_branch(l_as,[l_as.type, l_as.expression, l_as.name])
			else
				process_n_way_branch(l_as,[l_as.name, l_as.type, l_as.expression])
			end
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			process_n_way_branch(l_as,[l_as.feature_names, l_as.body, l_as.indexes])
		end

	process_feature_list_as (l_as: FEATURE_LIST_AS)
		do
			process_n_way_branch(l_as,[l_as.features])
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			process_n_way_branch(l_as,[l_as.target, l_as.source])
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			process_n_way_branch(l_as,[l_as.target, l_as.source])
		end

	process_check_as (l_as: CHECK_AS)
		do
			process_n_way_branch(l_as,[l_as.check_list])
		end

	process_creation_as (l_as: CREATION_AS)
		do
			process_n_way_branch(l_as,[l_as.target, l_as.type, l_as.call])
		end

	process_if_as (l_as: IF_AS)
		do
			process_n_way_branch(l_as,[l_as.condition, l_as.compound, l_as.elsif_list, l_as.else_part])
		end

	process_inspect_as (l_as: INSPECT_AS)
		do
			process_n_way_branch(l_as,[l_as.switch, l_as.case_list, l_as.else_part])
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			process_n_way_branch(l_as,[l_as.call])
		end

	process_loop_as (l_as: LOOP_AS)
		do
			process_n_way_branch(l_as,[l_as.from_part, l_as.invariant_part, l_as.stop, l_as.compound, l_as.variant_part])
		end

	process_attribute_as (l_as: ATTRIBUTE_AS)
		do
			process_n_way_branch(l_as,[l_as.compound])
		end

	process_do_as (l_as: DO_AS)
		do
			process_n_way_branch(l_as,[l_as.compound])
		end

	process_once_as (l_as: ONCE_AS)
		do
			process_n_way_branch(l_as,[l_as.compound])
		end

	process_type_dec_as (l_as: TYPE_DEC_AS)
		do
			process_n_way_branch(l_as,[l_as.type])
		end
	process_class_as (l_as: CLASS_AS)
		do
			process_n_way_branch (l_as,[l_as.top_indexes, l_as.class_name, l_as.generics, l_as.parents, l_as.creators, l_as.convertors, l_as.features, l_as.invariant_part, l_as.bottom_indexes])
		end

	process_parent_as (l_as: PARENT_AS)
		do
			process_n_way_branch(l_as,[l_as.type, l_as.renaming, l_as.exports, l_as.undefining, l_as.redefining, l_as.selecting])
		end

	process_formal_dec_as (l_as: FORMAL_DEC_AS)
		do
			process_n_way_branch(l_as,[l_as.constraints, l_as.creation_feature_list])
		end

	process_constraining_type_as (l_as: CONSTRAINING_TYPE_AS)
		do
			process_n_way_branch(l_as,[l_as.type, l_as.renaming])
		end

	process_class_type_as (l_as: CLASS_TYPE_AS)
		do
			process_n_way_branch(l_as,[l_as.class_name])
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS)
		do
			process_n_way_branch(l_as,[l_as.class_name, l_as.generics])
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS)
		do
			process_n_way_branch(l_as,[l_as.class_name, l_as.parameters])
		end

	process_rename_as (l_as: RENAME_AS)
		do
			process_n_way_branch(l_as,[l_as.old_name, l_as.new_name])
		end

	process_invariant_as (l_as: INVARIANT_AS)
		do
			process_n_way_branch(l_as,[l_as.assertion_list])
		end

	process_interval_as (l_as: INTERVAL_AS)
		do
			process_n_way_branch(l_as,[l_as.lower, l_as.upper])
		end

	process_index_as (l_as: INDEX_AS)
		do
			process_n_way_branch(l_as,[l_as.index_list])
		end

	process_export_item_as (l_as: EXPORT_ITEM_AS)
		do
			process_n_way_branch(l_as,[l_as.clients, l_as.features])
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			process_n_way_branch(l_as,[l_as.expr, l_as.compound])
		end

	process_create_as (l_as: CREATE_AS)
		do
			process_n_way_branch(l_as,[l_as.clients, l_as.feature_list])
		end

	process_client_as (l_as: CLIENT_AS)
		do
			process_n_way_branch(l_as,[l_as.clients])
		end

	process_case_as (l_as: CASE_AS)
		do
			process_n_way_branch(l_as,[l_as.interval, l_as.compound])
		end

	process_ensure_as (l_as: ENSURE_AS)
		do
			process_n_way_branch(l_as,[l_as.assertions])
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS)
		do
			process_n_way_branch(l_as,[l_as.assertions])
		end

	process_require_as (l_as: REQUIRE_AS)
		do
			process_n_way_branch(l_as,[l_as.assertions])
		end

	process_require_else_as (l_as: REQUIRE_ELSE_AS)
		do
			process_n_way_branch(l_as,[l_as.assertions])
		end

	process_convert_feat_as (l_as: CONVERT_FEAT_AS)
		do
			process_n_way_branch(l_as,[l_as.feature_name, l_as.conversion_types])
		end

	process_local_dec_list_as (l_as: LOCAL_DEC_LIST_AS)
			-- Process `l_as'.
		do
			process_n_way_branch(l_as,[l_as.locals])
		end

	process_formal_argu_dec_list_as (l_as: FORMAL_ARGU_DEC_LIST_AS)
			-- Process `l_as'.
		do
			process_n_way_branch(l_as,[l_as.arguments])
		end

	process_debug_key_list_as (l_as: DEBUG_KEY_LIST_AS)
			-- Process `l_as'.
		do
			process_n_way_branch(l_as,[l_as.keys])
		end

	process_delayed_actual_list_as (l_as: DELAYED_ACTUAL_LIST_AS)
			-- Process `l_as'.
		do
			process_n_way_branch(l_as,[l_as.operands])
		end

	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
			-- Process `l_as'.
		local
			l_list: EIFFEL_LIST [EXPR_AS]
		do
			l_list := l_as.parameters
			if l_list /= Void and then not l_list.is_empty then
				process_n_way_branch(l_as,[l_as.parameters])
			end
		end

	process_rename_clause_as (l_as: RENAME_CLAUSE_AS)
			-- Process `l_as'.
		do
			process_n_way_branch(l_as,[l_as.content])
		end

	process_export_clause_as (l_as: EXPORT_CLAUSE_AS)
			-- Process `l_as'.
		do
			process_n_way_branch(l_as,[l_as.content])
		end

	process_undefine_clause_as (l_as: UNDEFINE_CLAUSE_AS)
			-- Process `l_as'.
		do
			process_n_way_branch(l_as,[l_as.content])
		end

	process_redefine_clause_as (l_as: REDEFINE_CLAUSE_AS)
			-- Process `l_as'.
		do
			process_n_way_branch(l_as,[l_as.content])
		end

	process_select_clause_as (l_as: SELECT_CLAUSE_AS)
			-- Process `l_as'.
		do
			process_n_way_branch(l_as,[l_as.content])
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
