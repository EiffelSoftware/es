-- todo: rewrite using something similar to ERT_AST_LOCATOR.process_n_way_branch

note
	description: "Iterates over all nodes and creates path-indexes"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_AST_PATH_INITIALIZER
inherit
	AST_ITERATOR
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
			process_select_clause_as
		end

feature -- Creation

	process_from_root(a_root: AST_EIFFEL) is
			-- process
		require
			root_set: a_root /= void
		do
			a_root.set_path (create {AST_PATH}.make_as_root(a_root))
			a_root.process (Current)
		end

feature {NONE} -- Implementation

	set_path_safe(a_parent, a_node: AST_EIFFEL; a_branch_number: INTEGER) is
			-- sets path while checking for void
		require
			a_parent /= void
		do
			if a_node /= void then
				set_path(a_parent,a_node,a_branch_number)
			end
		end

	set_path(a_parent, a_node: AST_EIFFEL; a_branch_number: INTEGER) is
			-- sets path
		require
			parent_non_void: a_parent /= void
			node_non_void: a_node /= void
		do
			a_node.set_path (create {AST_PATH}.make_from_parent (a_parent, a_branch_number))
		end

feature -- Roundtrip

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
			-- Process `l_as'.
		do
			set_path_safe(l_as,l_as.body,1)
			safe_process (l_as.body)
			set_path_safe(l_as,l_as.operands,2)
			safe_process (l_as.operands)
		end

	process_custom_attribute_as (l_as: CUSTOM_ATTRIBUTE_AS)
		do
			set_path(l_as,l_as.creation_expr,1)
			l_as.creation_expr.process (Current)
			set_path_safe(l_as,l_as.tuple,2)
			safe_process (l_as.tuple)
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			set_path(l_as,l_as.class_type,1)
			l_as.class_type.process (Current)
			set_path_safe(l_as,l_as.internal_parameters,2)
			safe_process (l_as.internal_parameters)
		end

	process_feature_clause_as (l_as: FEATURE_CLAUSE_AS)
		do
			set_path_safe(l_as,l_as.clients,1)
			safe_process (l_as.clients)
			set_path(l_as,l_as.features,2)
			l_as.features.process (Current)
		end

	process_tuple_as (l_as: TUPLE_AS)
		do
			set_path(l_as,l_as.expressions,1)
			l_as.expressions.process (Current)
		end

	process_array_as (l_as: ARRAY_AS)
		do
			set_path(l_as,l_as.expressions,1)
			l_as.expressions.process (Current)
		end

	process_body_as (l_as: BODY_AS)
		do
			set_path_safe(l_as,l_as.arguments,1)
			safe_process (l_as.arguments)
			set_path_safe(l_as,l_as.type,2)
			safe_process (l_as.type)
			set_path_safe(l_as,l_as.assigner,3)
			safe_process (l_as.assigner)
			set_path_safe(l_as,l_as.content,4)
			safe_process (l_as.content)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			set_path_safe(l_as,l_as.internal_parameters,1)
			safe_process (l_as.internal_parameters)
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		do
			set_path_safe(l_as,l_as.parent_base_class,1)
			safe_process (l_as.parent_base_class)
			set_path_safe(l_as,l_as.internal_parameters,2)
			safe_process (l_as.internal_parameters)
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			set_path(l_as,l_as.target,1)
			l_as.target.process (Current)
			set_path(l_as,l_as.message,2)
			l_as.message.process (Current)
		end

	process_nested_as (l_as: NESTED_AS)
		do
			set_path(l_as,l_as.target,1)
			l_as.target.process (Current)
			set_path(l_as,l_as.message,2)
			l_as.message.process (Current)
		end

	process_creation_expr_as (l_as: CREATION_EXPR_AS)
		do
			set_path(l_as,l_as.type,1)
			l_as.type.process (Current)
			set_path_safe(l_as,l_as.call,2)
			safe_process (l_as.call)
		end

	process_type_expr_as (l_as: TYPE_EXPR_AS)
		do
			set_path(l_as,l_as.type,1)
			l_as.type.process (Current)
		end

	process_routine_as (l_as: ROUTINE_AS)
		do
			set_path_safe(l_as,l_as.precondition,1)
			safe_process (l_as.precondition)
			set_path_safe(l_as,l_as.locals,2)
			safe_process (l_as.locals)
			set_path(l_as,l_as.routine_body,3)
			l_as.routine_body.process (Current)
			set_path_safe(l_as,l_as.postcondition,4)
			safe_process (l_as.postcondition)
			set_path_safe(l_as,l_as.rescue_clause,5)
			safe_process (l_as.rescue_clause)
		end

	process_constant_as (l_as: CONSTANT_AS)
		do
			set_path(l_as,l_as.value,1)
			l_as.value.process (Current)
		end

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
		local
			l_cursor: INTEGER
			i: INTEGER
		do
			from
				l_cursor := l_as.index
				i:=1
				l_as.start
			until
				l_as.after
			loop
				set_path(l_as,l_as.item,i)
				l_as.item.process (Current)
				l_as.forth
				i:=i+1
			end
			l_as.go_i_th (l_cursor)
		end

	process_operand_as (l_as: OPERAND_AS)
		do
			set_path_safe(l_as,l_as.class_type,1)
			safe_process (l_as.class_type)
			set_path_safe(l_as,l_as.expression,2)
			safe_process (l_as.expression)
			set_path_safe(l_as,l_as.target,3)
			safe_process (l_as.target)
		end

	process_tagged_as (l_as: TAGGED_AS)
		do
			set_path_safe(l_as,l_as.expr, 1)
			safe_process (l_as.expr)
				-- It is valid to have tags without expressions.
		end

	process_variant_as (l_as: VARIANT_AS)
		do
			set_path(l_as,l_as.expr,1)
			l_as.expr.process (Current)
		end

	process_converted_expr_as (l_as: CONVERTED_EXPR_AS)
		do
			set_path(l_as,l_as.expr,1)
			l_as.expr.process (Current)
		end

	process_paran_as (l_as: PARAN_AS)
		do
			set_path(l_as,l_as.expr,1)
			l_as.expr.process (Current)
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			set_path(l_as,l_as.call,1)
			l_as.call.process (Current)
		end

	process_expr_address_as (l_as: EXPR_ADDRESS_AS)
		do
			set_path(l_as,l_as.expr,1)
			l_as.expr.process (Current)
		end

	process_routine_creation_as (l_as: ROUTINE_CREATION_AS)
		do
			set_path_safe(l_as,l_as.target,1)
			safe_process (l_as.target)
			set_path_safe(l_as,l_as.feature_name,2)
			safe_process (l_as.feature_name)
			set_path_safe(l_as,l_as.operands,3)
			safe_process (l_as.operands)
		end

	process_unary_as (l_as: UNARY_AS)
		do
			set_path(l_as,l_as.expr,1)
			l_as.expr.process (Current)
		end

	process_binary_as (l_as: BINARY_AS)
		do
			set_path(l_as,l_as.left,1)
			l_as.left.process (Current)
			set_path(l_as,l_as.right,2)
			l_as.right.process (Current)
		end

	process_bracket_as (l_as: BRACKET_AS)
		do
			set_path(l_as,l_as.target,1)
			l_as.target.process (Current)
			set_path(l_as,l_as.operands,2)
			l_as.operands.process (Current)
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			if l_as.is_attached_keyword then
				set_path_safe(l_as,l_as.type,1)
				safe_process (l_as.type)
				set_path(l_as,l_as.expression,2)
				l_as.expression.process (Current)
				set_path_safe(l_as,l_as.name,3)
				safe_process (l_as.name)
			else
				set_path(l_as,l_as.name,1)
				l_as.name.process (Current)
				set_path(l_as,l_as.type,2)
				l_as.type.process (Current)
				set_path(l_as,l_as.expression,3)
				l_as.expression.process (Current)
			end
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			set_path(l_as,l_as.feature_names,1)
			l_as.feature_names.process (Current)
			set_path(l_as,l_as.body,2)
			l_as.body.process (Current)
				-- Feature indexing clause is processed after feature body because
				-- information such as arguments are stored in body so they must be processed first.
			set_path_safe(l_as,l_as.indexes,3)
			safe_process (l_as.indexes)
		end

	process_feature_list_as (l_as: FEATURE_LIST_AS)
		do
			set_path(l_as,l_as.features,1)
			l_as.features.process (Current)
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			set_path(l_as,l_as.target,1)
			l_as.target.process (Current)
			set_path(l_as,l_as.target,2)
			l_as.source.process (Current)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
		do
			set_path(l_as,l_as.target,1)
			l_as.target.process (Current)
			set_path(l_as,l_as.source,2)
			l_as.source.process (Current)
		end

	process_check_as (l_as: CHECK_AS)
		do
			set_path_safe(l_as,l_as.check_list,1)
			safe_process (l_as.check_list)
		end

	process_creation_as (l_as: CREATION_AS)
		do
			set_path(l_as,l_as.target,1)
			l_as.target.process (Current)
			set_path_safe(l_as,l_as.type,2)
			safe_process (l_as.type)
			set_path_safe(l_as,l_as.call,3)
			safe_process (l_as.call)
		end

	process_if_as (l_as: IF_AS)
		do
			set_path(l_as,l_as.condition,1)
			l_as.condition.process (Current)
			set_path_safe(l_as,l_as.compound,2)
			safe_process (l_as.compound)
			set_path_safe(l_as,l_as.elsif_list,3)
			safe_process (l_as.elsif_list)
			set_path_safe(l_as,l_as.else_part,4)
			safe_process (l_as.else_part)
		end

	process_inspect_as (l_as: INSPECT_AS)
		do
			set_path(l_as,l_as.switch,1)
			l_as.switch.process (Current)
			set_path_safe(l_as,l_as.case_list,2)
			safe_process (l_as.case_list)
			set_path_safe(l_as,l_as.else_part,3)
			safe_process (l_as.else_part)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			set_path(l_as,l_as.call,1)
			l_as.call.process (Current)
		end

	process_loop_as (l_as: LOOP_AS)
		do
			set_path_safe(l_as,l_as.from_part,1)
			safe_process (l_as.from_part)
			set_path_safe(l_as,l_as.invariant_part,2)
			safe_process (l_as.invariant_part)
			set_path(l_as,l_as.stop,3)
			l_as.stop.process (Current)
			set_path_safe(l_as,l_as.compound,4)
			safe_process (l_as.compound)
			set_path_safe(l_as,l_as.variant_part,5)
			safe_process (l_as.variant_part)
		end

	process_attribute_as (l_as: ATTRIBUTE_AS)
		do
			set_path_safe(l_as,l_as.compound,1)
			safe_process (l_as.compound)
		end

	process_do_as (l_as: DO_AS)
		do
			set_path_safe(l_as,l_as.compound,1)
			safe_process (l_as.compound)
		end

	process_once_as (l_as: ONCE_AS)
		do
			set_path_safe(l_as,l_as.compound,1)
			safe_process (l_as.compound)
		end

	process_type_dec_as (l_as: TYPE_DEC_AS)
		do
			set_path(l_as,l_as.type,1)
			l_as.type.process (Current)
		end

	process_class_as (l_as: CLASS_AS)
		do
			set_path_safe(l_as,l_as.top_indexes,1)
			safe_process (l_as.top_indexes)
			set_path(l_as,l_as.class_name,2)
			l_as.class_name.process (Current)
			set_path_safe(l_as,l_as.generics,3)
			safe_process (l_as.generics)
			set_path_safe(l_as,l_as.parents,4)
			safe_process (l_as.parents)
			set_path_safe(l_as,l_as.creators,5)
			safe_process (l_as.creators)
			set_path_safe(l_as,l_as.convertors,6)
			safe_process (l_as.convertors)
			set_path_safe(l_as,l_as.features,7)
			safe_process (l_as.features)
			set_path_safe(l_as,l_as.invariant_part,8)
			safe_process (l_as.invariant_part)
			set_path_safe(l_as,l_as.bottom_indexes,9)
			safe_process (l_as.bottom_indexes)
		end

	process_parent_as (l_as: PARENT_AS)
		do
			set_path(l_as,l_as.type,1)
			l_as.type.process (Current)
			set_path_safe(l_as,l_as.renaming,2)
			safe_process (l_as.renaming)
			set_path_safe(l_as,l_as.exports,3)
			safe_process (l_as.exports)
			set_path_safe(l_as,l_as.undefining,4)
			safe_process (l_as.undefining)
			set_path_safe(l_as,l_as.redefining,5)
			safe_process (l_as.redefining)
			set_path_safe(l_as,l_as.selecting,6)
			safe_process (l_as.selecting)
		end

	process_formal_dec_as (l_as: FORMAL_DEC_AS)
		do
			set_path_safe(l_as,l_as.constraints,1)
			safe_process (l_as.constraints)
			set_path_safe(l_as,l_as.creation_feature_list,2)
			safe_process (l_as.creation_feature_list)
		end

	process_constraining_type_as (l_as: CONSTRAINING_TYPE_AS)
		do
			set_path(l_as,l_as.type,1)
			l_as.type.process (Current)
			set_path_safe(l_as,l_as.renaming,2)
			safe_process (l_as.renaming)
		end

	process_class_type_as (l_as: CLASS_TYPE_AS)
		do
			set_path(l_as,l_as.class_name,1)
			l_as.class_name.process (Current)
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS)
		do
			set_path(l_as,l_as.class_name,1)
			l_as.class_name.process (Current)
			set_path(l_as,l_as.internal_generics,2)
			l_as.internal_generics.process (Current)
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS)
		do
			set_path(l_as,l_as.class_name,1)
			l_as.class_name.process (Current)
			set_path_safe(l_as,l_as.parameters,2)
			safe_process (l_as.parameters)
		end

	process_rename_as (l_as: RENAME_AS)
		do
			set_path(l_as,l_as.old_name,1)
			l_as.old_name.process (Current)
			set_path(l_as,l_as.new_name,2)
			l_as.new_name.process (Current)
		end

	process_invariant_as (l_as: INVARIANT_AS)
		do
			set_path_safe(l_as,l_as.assertion_list,1)
			safe_process (l_as.assertion_list)
		end

	process_interval_as (l_as: INTERVAL_AS)
		do
			set_path(l_as,l_as.lower,1)
			l_as.lower.process (Current)
			set_path_safe(l_as,l_as.upper,2)
			safe_process (l_as.upper)
		end

	process_index_as (l_as: INDEX_AS)
		do
			set_path(l_as,l_as.index_list,1)
			l_as.index_list.process (Current)
		end

	process_export_item_as (l_as: EXPORT_ITEM_AS)
		do
			set_path(l_as,l_as.clients,1)
			l_as.clients.process (Current)
			set_path_safe(l_as,l_as.features,2)
			safe_process (l_as.features)
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			set_path(l_as,l_as.expr,1)
			l_as.expr.process (Current)
			set_path_safe(l_as,l_as.compound,2)
			safe_process (l_as.compound)
		end

	process_create_as (l_as: CREATE_AS)
		do
			set_path_safe(l_as,l_as.clients,1)
			safe_process (l_as.clients)
			set_path_safe(l_as,l_as.feature_list,2)
			safe_process (l_as.feature_list)
		end

	process_client_as (l_as: CLIENT_AS)
		do
			set_path(l_as,l_as.clients,1)
			l_as.clients.process (Current)
		end

	process_case_as (l_as: CASE_AS)
		do
			set_path(l_as,l_as.interval,1)
			l_as.interval.process (Current)
			set_path_safe(l_as,l_as.compound,2)
			safe_process (l_as.compound)
		end

	process_ensure_as (l_as: ENSURE_AS)
		do
			set_path_safe(l_as,l_as.assertions,1)
			safe_process (l_as.assertions)
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS)
		do
			set_path_safe(l_as,l_as.assertions,1)
			safe_process (l_as.assertions)
		end

	process_require_as (l_as: REQUIRE_AS)
		do
			set_path_safe(l_as,l_as.assertions,1)
			safe_process (l_as.assertions)
		end

	process_require_else_as (l_as: REQUIRE_ELSE_AS)
		do
			set_path_safe(l_as,l_as.assertions,1)
			safe_process (l_as.assertions)
		end

	process_convert_feat_as (l_as: CONVERT_FEAT_AS)
		do
			set_path(l_as,l_as.feature_name,1)
			l_as.feature_name.process (Current)
			set_path(l_as,l_as.conversion_types,2)
			l_as.conversion_types.process (Current)
		end

	process_local_dec_list_as (l_as: LOCAL_DEC_LIST_AS)
			-- Process `l_as'.
		do
			set_path(l_as,l_as.locals,1)
			l_as.locals.process (Current)
		end

	process_formal_argu_dec_list_as (l_as: FORMAL_ARGU_DEC_LIST_AS)
			-- Process `l_as'.
		do
			set_path(l_as,l_as.arguments,1)
			l_as.arguments.process (Current)
		end

	process_debug_key_list_as (l_as: DEBUG_KEY_LIST_AS)
			-- Process `l_as'.
		do
			set_path(l_as,l_as.keys,1)
			l_as.keys.process (Current)
		end

	process_delayed_actual_list_as (l_as: DELAYED_ACTUAL_LIST_AS)
			-- Process `l_as'.
		do
			set_path(l_as,l_as.operands,1)
			l_as.operands.process (Current)
		end

	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
			-- Process `l_as'.
		local
			l_list: EIFFEL_LIST [EXPR_AS]
		do
			l_list := l_as.parameters
			if l_list /= Void and then not l_list.is_empty then
				set_path(l_as,l_list,1)
				l_list.process (Current)
			end
		end

	process_rename_clause_as (l_as: RENAME_CLAUSE_AS)
			-- Process `l_as'.
		do
			set_path_safe(l_as,l_as.content,1)
			safe_process (l_as.content)
		end

	process_export_clause_as (l_as: EXPORT_CLAUSE_AS)
			-- Process `l_as'.
		do
			set_path_safe(l_as,l_as.content,1)
			safe_process (l_as.content)
		end

	process_undefine_clause_as (l_as: UNDEFINE_CLAUSE_AS)
			-- Process `l_as'.
		do
			set_path_safe(l_as,l_as.content,1)
			safe_process (l_as.content)
		end

	process_redefine_clause_as (l_as: REDEFINE_CLAUSE_AS)
			-- Process `l_as'.
		do
			set_path_safe(l_as,l_as.content,1)
			safe_process (l_as.content)
		end

	process_select_clause_as (l_as: SELECT_CLAUSE_AS)
			-- Process `l_as'.
		do
			set_path_safe(l_as,l_as.content,1)
			safe_process (l_as.content)
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
