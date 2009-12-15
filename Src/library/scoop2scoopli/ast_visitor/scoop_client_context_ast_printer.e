indexing
	description: "Summary description for {SCOOP_CLIENT_CONTEXT_AST_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_CONTEXT_AST_PRINTER

inherit
	SCOOP_CONTEXT_AST_PRINTER
		redefine
			process_class_type_as,
			process_generic_class_type_as,
			process_named_tuple_type_as,
			process_parameter_list_as,
			process_access_feat_as,
			process_access_assert_as,
			process_access_inv_as,
			process_access_id_as,
			process_static_access_as,
			process_precursor_as,
			process_result_as,
			process_current_as,
			process_feature_as,
			process_nested_as,
			process_nested_expr_as,
			process_create_creation_as,
			process_create_creation_expr_as,
			process_bang_creation_expr_as,
			process_binary_as,
			process_bin_and_then_as,
			process_bin_or_else_as,
			process_unary_as,
			process_string_as,
			process_verbatim_string_as,
			process_real_as,
			process_integer_as,
			process_char_as,
			process_typed_char_as,
			process_bool_as,
			process_eiffel_list,
			process_address_as,
			process_assign_as,
			process_if_as,
			process_elseif_as,
			process_object_test_as,
			process_inline_agent_creation_as
		end

	SCOOP_CLASS_NAME
		export
			{NONE} all
		end

	SHARED_ERROR_HANDLER
		export
			{NONE} all
		end

create
	make,
	make_with_default_context

feature {NONE} -- Initialization
	make (a_ctxt: ROUNDTRIP_CONTEXT)
			-- Initialize and set `context' with `a_ctxt'.
		require
			a_ctxt_not_void: a_ctxt /= Void
		do
			context := a_ctxt

			initialize_level_layers
			initialize_object_tests_layers
			initialize_inline_agents_layers
		end

	make_with_default_context
			-- Initialize and create context of type `ROUNDTRIP_STRING_LIST_CONTEXT'.
		do
			make (create {ROUNDTRIP_STRING_LIST_CONTEXT}.make)

			initialize_level_layers
			initialize_object_tests_layers
			initialize_inline_agents_layers
		end

feature {NONE} -- Type expression processing
	process_class_type_as (l_as: CLASS_TYPE_AS)
		do
			safe_process (l_as.lcurly_symbol (match_list))
			safe_process (l_as.attachment_mark (match_list))
			safe_process (l_as.expanded_keyword (match_list))

			-- skip separate keyword and processor tag
			if l_as.is_separate then
				process_leading_leaves (l_as.separate_keyword_index)
				last_index := l_as.class_name.index - 1
				context.add_string (" ")
			end

			-- process class name
			process_leading_leaves (l_as.class_name.index)
			process_class_name (l_as.class_name, l_as.is_separate, context, match_list)
			last_index := l_as.class_name.index

			safe_process (l_as.rcurly_symbol (match_list))
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS)
		local
			l_generics_visitor: SCOOP_GENERICS_VISITOR
		do
			safe_process (l_as.lcurly_symbol (match_list))
			safe_process (l_as.attachment_mark (match_list))
			safe_process (l_as.expanded_keyword (match_list))

			-- skip separate keyword and processor tag
			if l_as.is_separate then
				process_leading_leaves (l_as.separate_keyword_index)
				last_index := l_as.class_name.index - 1
				context.add_string (" ")
			end

			-- process class name
			process_leading_leaves (l_as.class_name.index)
			process_class_name (l_as.class_name, l_as.is_separate, context, match_list)
			context.add_string (" ")
			last_index := l_as.class_name.index

			-- process internal generics
			l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
			l_generics_visitor.process_internal_generics (l_as.internal_generics, true, false)
			if l_as.internal_generics /= Void then
				last_index := l_generics_visitor.get_last_index
			end

			safe_process (l_as.rcurly_symbol (match_list))
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS)
		do
			safe_process (l_as.lcurly_symbol (match_list))
			safe_process (l_as.attachment_mark (match_list))

			-- skip separate keyword and processor tag
			if l_as.is_separate then
				process_leading_leaves (l_as.separate_keyword_index)
				last_index := l_as.class_name.index - 1
				context.add_string (" ")
			end

			-- process class name
			process_leading_leaves (l_as.class_name.index)
			process_class_name (l_as.class_name, l_as.is_separate, context, match_list)
			last_index := l_as.class_name.index

			safe_process (l_as.parameters)
			safe_process (l_as.rcurly_symbol (match_list))
		end

feature {NONE} -- Parameter list processing
	process_parameter_list_as (l_as: PARAMETER_LIST_AS)
			-- Process `l_as'. Add 'Current' as first argument in paramenter list.
		local
			i: INTEGER
			l_count: INTEGER
		do
			safe_process (l_as.lparan_symbol (match_list))

			-- add additional argument 'Current'
			if (levels_layers.item.count > 1 and then is_previous_level_separate) or add_prefix_current_cc then
				add_prefix_current_cc := false
				context.add_string ("Current, ")
			end

			if l_as.parameters.count > 0 then
				from
					l_as.parameters.start
					i := 1
					if l_as.parameters.separator_list /= Void then
						l_count := l_as.parameters.separator_list.count
					end
				until
					l_as.parameters.after
				loop
					-- process the node
					add_levels_layer
					safe_process (l_as.parameters.item)
					remove_current_levels_layer

					if i <= l_count then
						safe_process (l_as.parameters.separator_list_i_th (i, match_list))
						i := i + 1
					end
					l_as.parameters.forth
				end
			end

			safe_process (l_as.rparan_symbol (match_list))
		end

	process_internal_parameters (l_as: PARAMETER_LIST_AS)
			-- adds the paramter 'Current' to the list if
			-- it is a nested call and the target of separate type.
		do
			if l_as /= Void then
				-- add additional argument 'Current' if last target was separate
				-- add a 'dummy level' so that the next target has no type information as basis
				process_parameter_list_as (l_as)
			elseif (levels_layers.item.count > 1 and then is_previous_level_separate) or add_prefix_current_cc then
				-- add additional argument 'Current' if last target was separate
				context.add_string (" (Current)")
			end
		end

feature {NONE} -- Calls processing
	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			safe_process (l_as.feature_name)

			update_current_level_with_call (l_as)

			-- process internal parameters and add current if target is of separate type.
			process_internal_parameters(l_as.internal_parameters)
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
		do
			safe_process (l_as.feature_name)

			update_current_level_with_call (l_as)

			-- process internal parameters and add current if target is of separate type.
			process_internal_parameters(l_as.internal_parameters)
		end

	process_access_inv_as (l_as: ACCESS_INV_AS)
		do
			safe_process (l_as.dot_symbol (match_list))
			safe_process (l_as.feature_name)

			update_current_level_with_call (l_as)

			-- process internal parameters and add current if target is of separate type.
			process_internal_parameters(l_as.internal_parameters)
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			safe_process (l_as.feature_name)
			update_current_level_with_call (l_as)

			-- process internal parameters and add current if target is of separate type.
			process_internal_parameters(l_as.internal_parameters)
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		do
			safe_process (l_as.feature_keyword (match_list))
			safe_process (l_as.class_type)
			safe_process (l_as.dot_symbol (match_list))
			safe_process (l_as.feature_name)

			update_current_level_with_call (l_as)

			-- process internal parameters and add current if target is of separate type.
			process_internal_parameters(l_as.internal_parameters)
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		do
			safe_process (l_as.precursor_keyword)
			safe_process (l_as.parent_base_class)
			update_current_level_with_call (l_as)
			process_internal_parameters(l_as.internal_parameters)
		end

	process_result_as (l_as: RESULT_AS)
		do
			Precursor (l_as)
			update_current_level_with_call (l_as)
		end

	process_current_as (l_as: CURRENT_AS)
		do
			Precursor (l_as)
			update_current_level_with_call (l_as)
		end

	process_nested_as (l_as: NESTED_AS)
			-- Process `l_as'.
		do
			safe_process (l_as.target)
			safe_process (l_as.dot_symbol (match_list))

			-- increase current nested level
			add_level

			safe_process (l_as.message)

			-- decrease current nested level
			remove_current_level
		end

feature {NONE} -- Expressions processing
	process_nested_expr_as (l_as: NESTED_EXPR_AS)
			-- Process `l_as'.
		do
			safe_process (l_as.lparan_symbol (match_list))
			safe_process (l_as.target)
			safe_process (l_as.rparan_symbol (match_list))
			safe_process (l_as.dot_symbol (match_list))

			-- increase current nested level
			add_level

			safe_process (l_as.message)

			-- decrease current nested level
			remove_current_level
		end

	process_binary_as (l_as: BINARY_AS)
		local
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
			l_is_left_expression_separate, l_is_right_expression_separate: BOOLEAN
			l_left_type : TYPE_A
		do
			l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor
				-- This doesn't handle the convert clauses where the types may be `converted'
				--
				-- TODO: Handle such a case.
			l_type_expression_visitor.evaluate_expression_type_in_workbench (l_as.left, flattened_object_tests_layers, flattened_inline_agents_layers)
			l_is_left_expression_separate := l_type_expression_visitor.is_expression_separate
			l_left_type := l_type_expression_visitor.expression_type

			add_object_tests_layer
			add_multiple_to_current_object_tests_layer (l_type_expression_visitor.object_test_context_update)
			l_type_expression_visitor.evaluate_expression_type_in_workbench (l_as.right, flattened_object_tests_layers, flattened_inline_agents_layers)
			l_is_right_expression_separate := l_type_expression_visitor.is_expression_separate
			remove_current_object_tests_layer

			if {l_bin_not_tilde_as: BIN_NOT_TILDE_AS} l_as then
				if not l_is_left_expression_separate and not l_is_right_expression_separate then
					safe_process (l_as.left)
					safe_process (l_as.operator (match_list))
					add_levels_layer
					safe_process (l_as.right)
					remove_current_levels_layer
				else
					context.add_string ("(")
					add_object_tests_layer
					safe_process (l_as.left); context.add_string (" = Void")
					context.add_string (" or else ")
					add_levels_layer
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" = Void")
					remove_current_levels_layer
					remove_current_object_tests_layer
					context.add_string (")")
					context.add_string (" or else ")
					context.add_string ("(")
					reset_current_levels_layer
					add_object_tests_layer
					safe_process (l_as.left); context.add_string (" /= Void")
					context.add_string (" and then ")
					add_levels_layer
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
					remove_current_levels_layer
					remove_current_object_tests_layer
					context.add_string (" and then ")
					reset_current_levels_layer
					if not l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left)
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right); context.add_string (".implementation_")
						remove_current_levels_layer
					elseif l_is_left_expression_separate and not l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right)
						remove_current_levels_layer
					elseif l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right); context.add_string (".implementation_")
						remove_current_levels_layer
					end
					context.add_string (")")
				end

			elseif {l_bin_ne_as: BIN_NE_AS} l_as then
				if not l_is_left_expression_separate and not l_is_right_expression_separate then
					safe_process (l_as.left)
					safe_process (l_as.operator (match_list))
					add_levels_layer
					safe_process (l_as.right)
					remove_current_levels_layer
				else
					context.add_string ("(")
					add_object_tests_layer
					safe_process (l_as.left); context.add_string (" = Void")
					context.add_string (" and then ")
					add_levels_layer
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
					remove_current_levels_layer
					remove_current_object_tests_layer
					context.add_string (")")
					context.add_string (" or else ")
					context.add_string ("(")
					reset_current_levels_layer
					add_object_tests_layer
					safe_process (l_as.left); context.add_string (" /= Void")
					context.add_string (" and then ")
					add_levels_layer
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" = Void")
					remove_current_levels_layer
					remove_current_object_tests_layer
					context.add_string (")")
					context.add_string (" or else ")
					context.add_string ("(")
					reset_current_levels_layer
					add_object_tests_layer
					safe_process (l_as.left); context.add_string (" /= Void")
					context.add_string (" and then ")
					add_levels_layer
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
					remove_current_levels_layer
					remove_current_object_tests_layer
					context.add_string (" and then ")
					reset_current_levels_layer
					if not l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left)
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right); context.add_string (".implementation_")
						remove_current_levels_layer
					elseif l_is_left_expression_separate and not l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right)
						remove_current_levels_layer
					elseif l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right); context.add_string (".implementation_")
						remove_current_levels_layer
					end
					context.add_string (")")
				end
			elseif {l_bin_tilde_as: BIN_TILDE_AS} l_as then
				if not l_is_left_expression_separate and not l_is_right_expression_separate then
					safe_process (l_as.left)
					safe_process (l_as.operator (match_list))
					add_levels_layer
					safe_process (l_as.right)
					remove_current_levels_layer
				else
					add_object_tests_layer
					safe_process (l_as.left); context.add_string (" /= Void")
					context.add_string (" and then ")
					add_levels_layer
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
					remove_current_levels_layer
					remove_current_object_tests_layer
					context.add_string (" and then ")
					reset_current_levels_layer
					if not l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left)
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right); context.add_string (".implementation_")
						remove_current_levels_layer
					elseif l_is_left_expression_separate and not l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right)
						remove_current_levels_layer
					elseif l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right); context.add_string (".implementation_")
						remove_current_levels_layer
					end
				end
			elseif {l_bin_eq_as: BIN_EQ_AS} l_as then
				if not l_is_left_expression_separate and not l_is_right_expression_separate then
					safe_process (l_as.left)
					safe_process (l_as.operator (match_list))
					add_levels_layer
					safe_process (l_as.right)
					remove_current_levels_layer
				else
					context.add_string ("(")
					add_object_tests_layer
					safe_process (l_as.left); context.add_string (" = Void")
					context.add_string (" and then ")
					add_levels_layer
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" = Void")
					remove_current_levels_layer
					remove_current_object_tests_layer
					context.add_string (")")
					context.add_string (" or else ")
					context.add_string ("(")
					reset_current_levels_layer
					add_object_tests_layer
					safe_process (l_as.left); context.add_string (" /= Void")
					context.add_string (" and then ")
					add_levels_layer
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
					remove_current_levels_layer
					remove_current_object_tests_layer
					context.add_string (" and then ")
					reset_current_levels_layer
					if not l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left)
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right); context.add_string (".implementation_")
						remove_current_levels_layer
					elseif l_is_left_expression_separate and not l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right)
						remove_current_levels_layer
					elseif l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right); context.add_string (".implementation_")
						remove_current_levels_layer
					end
					context.add_string (")")
				end
			else
				if l_is_left_expression_separate then
					-- The left expression is separate. Replace the infix call with a non-infix call.
					safe_process (l_as.left)
					-- process infix operator
					l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor
					-- l_feature_name_visitor.process_infix_str (l_as.operator_ast.name)
					-- context.add_string ("." + l_feature_name_visitor.get_feature_name)
					convert_infix (l_left_type, l_as.operator_ast.name)

					last_index := l_as.operator_index

					-- add brackets for non-infix call
					context.add_string ("(Current,")

					add_levels_layer
					safe_process (l_as.right)
					remove_current_levels_layer

					context.add_string (")")
				else
					-- left expression of binary operation is not of separate type
					-- process it as usual
					safe_process (l_as.left)
					safe_process (l_as.operator (match_list))
					add_levels_layer
					safe_process (l_as.right)
					remove_current_levels_layer
				end
			end
		end

	convert_infix (l_type : TYPE_A; symb : STRING)
		local
			l_feature : FEATURE_I
		do
			l_feature := l_type.associated_class.feature_table.alias_item (symb)
		end

	process_unary_as (l_as: UNARY_AS)
		do
			safe_process (l_as.operator (match_list))
			safe_process (l_as.expr)
		end

	process_bin_and_then_as (l_as: BIN_AND_THEN_AS)
		do
			safe_process (l_as.left)
			safe_process (l_as.and_keyword (match_list))
			safe_process (l_as.then_keyword (match_list))
			add_levels_layer
			safe_process (l_as.right)
			remove_current_levels_layer
		end

	process_bin_or_else_as (l_as: BIN_OR_ELSE_AS)
		do
			safe_process (l_as.left)
			safe_process (l_as.or_keyword (match_list))
			safe_process (l_as.else_keyword (match_list))
			add_levels_layer
			safe_process (l_as.right)
			remove_current_levels_layer
		end

	process_address_as (l_as: ADDRESS_AS)
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_string_as (l_as: STRING_AS)
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_real_as (l_as: REAL_AS)
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_char_as (l_as: CHAR_AS)
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_typed_char_as (l_as: TYPED_CHAR_AS)
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_bool_as (l_as: BOOL_AS)
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS)
			-- Process `l_as'.
		do
			-- TODO
			Precursor(l_as)
			update_current_level_with_call (l_as)
		end

	process_bang_creation_expr_as (l_as: BANG_CREATION_EXPR_AS)
		do
			Precursor(l_as)
			update_current_level_with_call (l_as)
			-- TODO
		end

feature {NONE} -- Features processing
	process_feature_as (l_as: FEATURE_AS)
		do
			set_current_feature_as (l_as)
			Precursor (l_as)
		end

feature {NONE} -- Instructions processing
	process_assign_as (l_as: ASSIGN_AS)
		local
			l_expr_call_as: EXPR_CALL_AS
			l_create_creation_expr_as: CREATE_CREATION_EXPR_AS
			l_processor_visitor: SCOOP_EXPLICIT_PROCESSOR_SPECIFICATION_VISITOR
			l_processor: like locals_processor
		do
			-- TODO: Generalize creation expressions in arbitrary positions, not only in assignments.
			l_expr_call_as ?= l_as.source
			if l_expr_call_as /= Void then
				l_create_creation_expr_as ?= l_expr_call_as.call
			end
			if l_create_creation_expr_as /= Void then
				-- get explicit processor specification of type if there is any
				l_processor_visitor := scoop_visitor_factory.new_explicit_processor_specification_visitor(class_c)
				l_processor := l_processor_visitor.get_explicit_processor_specification (l_create_creation_expr_as.type)

				-- test if there is an explicit processor specification with handler
				if l_processor.has_explicit_processor_specification then
					-- indentation
					context.add_string (match_list.i_th (last_index + 1).text (match_list))
					if l_processor.has_handler then
						-- add processor void test
						context.add_string ("check " + l_processor.entity_name + " /= Void and then " + l_processor.entity_name + ".processor_ /= Void end ")
					else
						-- add processor void test
						context.add_string ("if " + l_processor.entity_name + " = Void then ")
						context.add_string (l_processor.entity_name + ".set_processor_(scoop_scheduler.new_processor_) end ")
					end
				end

				-- process the target and also the assignment symbol
				safe_process (l_as.target)
				safe_process (l_as.assignment_symbol (match_list))

				-- process the create creation expression
				process_create_creation_expr (l_create_creation_expr_as, l_as.target.access_name)
			else
				-- process now the assigner call node
				Precursor (l_as)
			end
		end

	process_create_creation_expr (l_as: CREATE_CREATION_EXPR_AS; a_target_name: STRING)
			-- Process `l_as'.
		local
			is_separate: BOOLEAN
			l_class_c: CLASS_C
			l_class_name: STRING
			l_type_visitor: SCOOP_TYPE_VISITOR
			l_processor_visitor: SCOOP_EXPLICIT_PROCESSOR_SPECIFICATION_VISITOR
			l_processor: like locals_processor
		do
			create l_type_visitor
			l_type_visitor.setup (parsed_class, match_list, true, true)

			-- get separate and the information of the explicit processor specification status of the current call
			if l_as.type /= Void then
				-- get type by the explicit type
				l_class_c := l_type_visitor.evaluate_class_from_type (l_as.type, class_c)
				-- get separate status
				is_separate := l_type_visitor.is_separate

				if is_separate then
					-- get class name for separate call
					create l_class_name.make_from_string (l_class_c.name.as_lower)
					-- get processor specification
					l_processor_visitor := scoop_visitor_factory.new_explicit_processor_specification_visitor(class_c)
					l_processor := l_processor_visitor.get_explicit_processor_specification (l_as.type)
				end
			else
				-- should not be the case
				error_handler.insert_error (create {INTERNAL_ERROR}.make("SCOOP Unexpected error: {SCOOP_CLIENT_CONTEXT_AST_PRINTER}.process_create_creation_expr_as."))
			end

			if not is_separate then
				-- process it as normal
				safe_process (l_as)
			else
				if not l_processor.has_explicit_processor_specification or not l_processor.has_handler then
					-- current object is separate, but has no explicit processor specification or
					-- current type is separate and has an explicit processor specification
					-- but is not defined by a handler.

					-- create SCOOP object with new processor
					safe_process (l_as.create_keyword (match_list))
					safe_process (l_as.type)
					context.add_string (".set_processor_ (scoop_scheduler.new_processor_); ")
				else
					-- current entity is separate and has an explicit processor specification.
					-- it is defined also by a handler.

					-- the processor not void test is already done in `process_assign_as'.

					-- create SCOOP object with new processor
					safe_process (l_as.create_keyword (match_list))
					safe_process (l_as.type)
					context.add_string (".set_processor_ (" + l_processor.entity_name + ".processor_); ")
				end

				-- process current creation call
				context.add_string ("separate_execute_routine ([ " + a_target_name)
				context.add_string (".processor_], agent " + a_target_name)
				if l_as.call /= Void then
					context.add_string ("." + l_as.call.feature_name.name)
					context.add_string ("_scoop_separate_" + l_class_name)
					-- process internal parameter: first: 'Current'
					add_prefix_current_cc := true
					if l_as.call.internal_parameters /= Void then
						last_index := l_as.call.internal_parameters.first_token (match_list).index
					end
					process_internal_parameters(l_as.call.internal_parameters)
					add_prefix_current_cc := false
				else
					context.add_string (".default_create_scoop_separate_" + l_class_name)
					-- internal parameter: 'Current'
					context.add_string (" (Current)")
				end

				context.add_string (", Void, Void, Void)")
				if l_as.call /= Void and then not (l_as.call.internal_parameters /= Void) then
					last_index := l_as.call.last_token (match_list).index
				end
			end

		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
			-- Process `l_as'.
		local
			is_separate: BOOLEAN
			l_target_name, l_class_name: STRING
			l_class_c: CLASS_C
			l_result_as: RESULT_AS
			l_feature_i: FEATURE_I
			l_type_visitor: SCOOP_TYPE_VISITOR
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
			l_processor_visitor: SCOOP_EXPLICIT_PROCESSOR_SPECIFICATION_VISITOR
			l_processor: like locals_processor
		do
			create l_type_visitor
			l_type_visitor.setup (parsed_class, match_list, true, true)

			if l_as.target /= Void then
				l_target_name := l_as.target.access_name
			end

			-- get separate and the information of the explicit processor specification status of the current call
			l_result_as ?= l_as.target
			if l_result_as /= Void then
				l_class_c := l_type_visitor.evaluate_class_from_type (feature_as.body.type, class_c)
				-- get separate status
				is_separate := l_type_visitor.is_separate

				if is_separate then
					-- get class name for separate call
					create l_class_name.make_from_string (l_class_c.name.as_lower)
					-- get processor specification
					l_processor_visitor := scoop_visitor_factory.new_explicit_processor_specification_visitor(class_c)
					l_processor := l_processor_visitor.get_explicit_processor_specification (feature_as.body.type)
				end
			elseif l_as.type /= Void then
				-- get type by the explicit type
				l_class_c := l_type_visitor.evaluate_class_from_type (l_as.type, class_c)
				-- get separate status
				is_separate := l_type_visitor.is_separate

				if is_separate then
					-- get class name for separate call
					create l_class_name.make_from_string (l_class_c.name.as_lower)
					-- get processor specification
					l_processor_visitor := scoop_visitor_factory.new_explicit_processor_specification_visitor(class_c)
					l_processor := l_processor_visitor.get_explicit_processor_specification (l_as.type)
				end
			elseif l_as.target /= Void then
				if class_c.feature_table.has (l_target_name) then
					-- get type by evaluating l_as.target which is an ACCESS_AS node
					l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor
					-- get separate status
					l_type_expression_visitor.evaluate_call_type_in_workbench (l_as.target, flattened_object_tests_layers, flattened_inline_agents_layers)
					is_separate := l_type_expression_visitor.is_expression_separate
					l_feature_i := class_c.feature_table.item (l_target_name)
					if l_feature_i.type /= Void then
						l_class_c := class_c.feature_table.item (l_target_name).type.associated_class
					end

					if is_separate then
						-- get class name for separate call
						create l_class_name.make_from_string (l_class_c.name.as_lower)
						-- get processor specification
						l_processor_visitor := scoop_visitor_factory.new_explicit_processor_specification_visitor(l_class_c)
						l_processor := l_processor_visitor.get_explicit_processor_specification_by_class (l_target_name, l_class_c)
					end
				elseif is_local (l_target_name) then
					is_separate := is_last_local_separate

					if is_separate and then locals_processor /= Void then
						l_class_name := locals_class_name
						l_processor := locals_processor
					end
				else
					-- should not be the case
					error_handler.insert_error (create {INTERNAL_ERROR}.make("SCOOP Unexpected error: {SCOOP_CLIENT_CONTEXT_AST_PRINTER}.process_create_creation_as."))
				end
			else
				-- should not be the case
				error_handler.insert_error (create {INTERNAL_ERROR}.make("SCOOP Unexpected error: {SCOOP_CLIENT_CONTEXT_AST_PRINTER}.process_create_creation_as."))
			end

			if not is_separate then
				-- process it as normal
				Precursor (l_as)
			else
				l_target_name := l_as.target.access_name
				if not l_processor.has_explicit_processor_specification then
					-- current object is separate, but has no explicit processor specification

					-- create SCOOP object with new processor
					safe_process (l_as.create_keyword (match_list))
					safe_process (l_as.type)
					safe_process (l_as.target)
					context.add_string (".set_processor_ (scoop_scheduler.new_processor_); ")

				elseif not l_processor.has_handler then
					-- current entity is separate and has an explicit processor specification
					-- but is not defined by a handler.

					process_leading_leaves (l_as.create_keyword_index)

					-- add processor void test
					context.add_string ("if " + l_processor.entity_name + " = Void then ")
					context.add_string (l_processor.entity_name + ".set_processor_(scoop_scheduler.new_processor_) end; ")

					-- create SCOOP object with new processor
					safe_process (l_as.create_keyword (match_list))
					safe_process (l_as.type)
					safe_process (l_as.target)
					context.add_string (".set_processor_ (" + l_processor.entity_name + "); ")
				else
					-- current entity is separate and has an explicit processor specification.
					-- it is defined also by a handler.

					process_leading_leaves (l_as.create_keyword_index)

					-- add processor void test
					context.add_string ("check " + l_processor.entity_name + " /= Void and then " + l_processor.entity_name + ".processor_ /= Void end ")

					-- create SCOOP object with new processor
					safe_process (l_as.create_keyword (match_list))
					safe_process (l_as.type)
					safe_process (l_as.target)
					context.add_string (".set_processor_ (" + l_processor.entity_name + ".processor_); ")
				end

				-- process current creation call
				context.add_string ("separate_execute_routine ([")
				last_index := l_as.create_keyword_index
				safe_process (l_as.type)
				safe_process (l_as.target)
				context.add_string (".processor_], agent ")
				last_index := l_as.create_keyword_index
				safe_process (l_as.type)
				safe_process (l_as.target)
				if l_as.call /= Void then
					context.add_string ("." + l_as.call.feature_name.name)
					context.add_string ("_scoop_separate_" + l_class_name)
					-- process internal parameter: first: 'Current'
					add_prefix_current_cc := true
					if l_as.call.internal_parameters /= Void then
						last_index := l_as.call.internal_parameters.first_token (match_list).index
					end
					process_internal_parameters(l_as.call.internal_parameters)
					add_prefix_current_cc := false
				else
					context.add_string (".default_create_scoop_separate_" + l_class_name)
					-- internal parameter: 'Current'
					context.add_string (" (Current)")
				end
				context.add_string (", Void, Void, Void)")
				if l_as.call /= Void then
					last_index := l_as.call.last_token (match_list).index
				end
			end
		end

feature {NONE} -- Eiffel list processing
	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
		local
			i, l_count: INTEGER
		do
			if l_as.count > 0 then
				-- reset for routine return type
				if
					{l_instruction_list: EIFFEL_LIST [INSTRUCTION_AS]} l_as or
					{l_type_declaration_list: EIFFEL_LIST [TYPE_DEC_AS]} l_as or
					{l_assertion_clause_list: EIFFEL_LIST [TAGGED_AS]} l_as
				then
					reset_current_levels_layer
				end

				from
					l_as.start
					i := 1
					if l_as.separator_list /= Void then
						l_count := l_as.separator_list.count
					end
				until
					l_as.after
				loop
					safe_process (l_as.item)
					if i <= l_count then
						safe_process (l_as.separator_list_i_th (i, match_list))
						i := i + 1
					end
					if
						{l_instruction_list: EIFFEL_LIST [INSTRUCTION_AS]} l_as or
						{l_type_declaration_list: EIFFEL_LIST [TYPE_DEC_AS]} l_as or
						{l_assertion_clause_list: EIFFEL_LIST [TAGGED_AS]} l_as
					then
						reset_current_levels_layer
					end
					if
						{l_instruction_list: EIFFEL_LIST [INSTRUCTION_AS]} l_as or
						{l_assertion_clause_list: EIFFEL_LIST [TAGGED_AS]} l_as
					then
						reset_current_object_tests_layer
					end
					l_as.forth
				end
			end
		end

feature {NONE} -- Level handling
	levels_layers: STACK[LINKED_LIST[TUPLE [is_separate: BOOLEAN; type: TYPE_A]]]

	initialize_level_layers
		do
			-- set current level handling
			create {LINKED_STACK[LINKED_LIST[TUPLE [is_separate: BOOLEAN; type: TYPE_A]]]} levels_layers.make
			add_levels_layer
		end

	add_levels_layer
		local
			l_tuple: like current_level
		do
			levels_layers.put (create {LINKED_LIST[TUPLE [is_separate: BOOLEAN; type: TYPE_A]]}.make)
			create l_tuple
			levels_layers.item.put_front (l_tuple)
		end

	remove_current_levels_layer
		do
			levels_layers.remove
		end

	reset_current_levels_layer
		do
			levels_layers.item.wipe_out
			add_level
		end

	add_level
		local
			l_tuple: like current_level
		do
			create l_tuple
			levels_layers.item.put_front (l_tuple)
		end

	remove_current_level
		do
			levels_layers.item.start
			levels_layers.item.remove
		end

	current_level: TUPLE [is_separate: BOOLEAN; type: TYPE_A]
		do
			Result := levels_layers.item.first
		ensure
			Result_not_void: Result /= Void
		end

	update_current_level_with_call (l_as: CALL_AS)
		local
			l_call_expression: EXPR_CALL_AS
		do
			create l_call_expression.initialize (l_as)
			update_current_level_with_expression (l_call_expression)
		end

	update_current_level_with_expression (l_as: EXPR_AS)
		local
			l_type_expr_visitor: SCOOP_TYPE_EXPR_VISITOR
		do
			-- get is_separate information of the current call
			l_type_expr_visitor := scoop_visitor_factory.new_type_expr_visitor

			if levels_layers.item.count = 1 then
				if feature_as /= Void then
					l_type_expr_visitor.evaluate_expression_type_in_class_and_feature (
						l_as,
						class_c,
						class_c.feature_table.item (feature_as.feature_name.name),
						flattened_object_tests_layers,
						flattened_inline_agents_layers
					)
				else
					l_type_expr_visitor.evaluate_expression_type_in_class (
						l_as,
						class_c,
						flattened_object_tests_layers,
						flattened_inline_agents_layers
					)
				end
			else
				check previous_level_type /= Void end
				l_type_expr_visitor.evaluate_expression_type_in_type (
					l_as,
					previous_level_type,
					flattened_object_tests_layers,
					flattened_inline_agents_layers
				)
			end

			if l_type_expr_visitor.is_query then
				set_current_level_type (l_type_expr_visitor.expression_type)
				if levels_layers.item.count > 1 and then is_previous_level_separate then
					-- Propagation of 'is_separate' state
					-- Creates for nested calls for every following call an argument 'Current'
					set_current_level_is_separate(true)
				else
					set_current_level_is_separate(l_type_expr_visitor.is_expression_separate)
				end
			end
		end

	set_current_level_is_separate (a_value: BOOLEAN)
		local
			l_tuple: like current_level
		do
			l_tuple := current_level
			l_tuple.is_separate := a_value
		end

	set_current_level_type (a_type: TYPE_A)
		local
			l_tuple: like current_level
		do
			l_tuple := current_level
			l_tuple.type := a_type
		end

	is_previous_level_separate: BOOLEAN
		require
			levels_layers.item.count > 1
		do
			Result := levels_layers.item.i_th(2).is_separate
		end

	previous_level_type: TYPE_A
			-- Returns `base_class' of `nested_levels's item(nested_level - 1)
		require
			levels_layers.item.count > 1
		do
			levels_layers.item.start
			levels_layers.item.forth

			Result := levels_layers.item.item.type
		end

feature {NONE} -- Object test handling
	object_tests_layers: LINKED_STACK[HASH_TABLE[OBJECT_TEST_AS, STRING]]

	initialize_object_tests_layers
		do
			create object_tests_layers.make
			object_tests_layers.put (create {HASH_TABLE[OBJECT_TEST_AS, STRING]}.make(10))
		end

	add_object_tests_layer
		do
			object_tests_layers.put (create {HASH_TABLE[OBJECT_TEST_AS, STRING]}.make(10))
		end

	remove_current_object_tests_layer
		require
			object_tests_layers.count >= 1
		do
			object_tests_layers.remove
		end

	reset_current_object_tests_layer
		require
			object_tests_layers.count >= 1
		do
			object_tests_layers.item.wipe_out
		end

	add_to_current_object_tests_layer (a_object_test: OBJECT_TEST_AS)
		require
			object_tests_layers.count >= 1
		do
			if a_object_test.name /= Void then
				object_tests_layers.item.put (a_object_test, a_object_test.name.name)
			end
		end

	add_multiple_to_current_object_tests_layer (a_object_tests: HASH_TABLE[OBJECT_TEST_AS, STRING])
		require
			object_tests_layers.count >= 1
		do
			from
				a_object_tests.start
			until
				a_object_tests.after
			loop
				object_tests_layers.item.put (a_object_tests.item_for_iteration, a_object_tests.key_for_iteration)
				a_object_tests.forth
			end
		end

	flattened_object_tests_layers: HASH_TABLE[OBJECT_TEST_AS, STRING]
		local
			l_object_tests_layers: ARRAYED_LIST[HASH_TABLE[OBJECT_TEST_AS, STRING]]
			l_object_tests_layer: HASH_TABLE[OBJECT_TEST_AS, STRING]
		do
			create {HASH_TABLE[OBJECT_TEST_AS, STRING]} Result.make (100)
			l_object_tests_layers := object_tests_layers.linear_representation
			from
				l_object_tests_layers.start
			until
				l_object_tests_layers.after
			loop
				l_object_tests_layer := l_object_tests_layers.item_for_iteration
				from
					l_object_tests_layer.start
				until
					l_object_tests_layer.after
				loop
					Result.put (l_object_tests_layer.item_for_iteration, l_object_tests_layer.key_for_iteration)
					l_object_tests_layer.forth
				end
				l_object_tests_layers.forth
			end
		end

	process_if_as (l_as: IF_AS)
		do
			safe_process (l_as.if_keyword (match_list))
			safe_process (l_as.condition)
			safe_process (l_as.then_keyword (match_list))
			add_object_tests_layer
			safe_process (l_as.compound)
			remove_current_object_tests_layer
			safe_process (l_as.elsif_list)
			safe_process (l_as.else_keyword (match_list))
			add_object_tests_layer
			safe_process (l_as.else_part)
			remove_current_object_tests_layer
			reset_current_object_tests_layer
			safe_process (l_as.end_keyword)
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			safe_process (l_as.elseif_keyword (match_list))
			safe_process (l_as.expr)
			safe_process (l_as.then_keyword (match_list))
			add_object_tests_layer
			safe_process (l_as.compound)
			remove_current_object_tests_layer
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			Precursor (l_as)
			add_to_current_object_tests_layer (l_as)
		end

feature {NONE} -- Inline agent handling
	inline_agents_layers: LINKED_STACK[SET[TYPE_DEC_AS]]

	initialize_inline_agents_layers
		do
			create inline_agents_layers.make
			inline_agents_layers.put (create {LINKED_SET[TYPE_DEC_AS]}.make)
		end

	add_inline_agents_layer
		do
			inline_agents_layers.put (create {LINKED_SET[TYPE_DEC_AS]}.make)
		end

	remove_current_inline_agents_layer
		require
			inline_agents_layers.count >= 1
		do
			inline_agents_layers.remove
		end

	reset_current_inline_agents_layer
		require
			inline_agents_layers.count >= 1
		do
			inline_agents_layers.item.wipe_out
		end

	add_to_current_inline_agents_layer (a_type_declaration: TYPE_DEC_AS)
		require
			inline_agents_layers.count >= 1
		do
			inline_agents_layers.item.put (a_type_declaration)
		end

	flattened_inline_agents_layers: HASH_TABLE[TYPE_AS, STRING]
		local
			l_inline_agent_layers: ARRAYED_LIST[SET[TYPE_DEC_AS]]
			l_inline_agent_layer: LINEAR[TYPE_DEC_AS]
			l_type_declaration: TYPE_DEC_AS
			i: INTEGER
		do
			create {HASH_TABLE[TYPE_AS, STRING]} Result.make (20)
			l_inline_agent_layers := inline_agents_layers.linear_representation
			from
				l_inline_agent_layers.start
			until
				l_inline_agent_layers.after
			loop
				l_inline_agent_layer := l_inline_agent_layers.item_for_iteration.linear_representation
				from
					l_inline_agent_layer.start
				until
					l_inline_agent_layer.after
				loop
					l_type_declaration := l_inline_agent_layer.item_for_iteration
					from
						i := 1
					until
						i > l_type_declaration.id_list.count
					loop
						Result.put (l_type_declaration.type, l_type_declaration.item_name (i))
						i := i + 1
					end
					l_inline_agent_layer.forth
				end
				l_inline_agent_layers.forth
			end
		end

	process_inline_agent_creation_as (l_as: INLINE_AGENT_CREATION_AS)
		local
			i: INTEGER
		do
			if l_as.body.arguments /= Void then
				from
					i := 1
				until
					i > l_as.body.arguments.count
				loop
					add_to_current_inline_agents_layer (l_as.body.arguments.i_th (i))
					i := i + 1
				end
			end
			if {l_routine: ROUTINE_AS} l_as.body.content and then l_routine.locals /= Void then
				from
					i := 1
				until
					i > l_routine.locals.count
				loop
					add_to_current_inline_agents_layer (l_routine.locals.i_th (i))
					i := i + 1
				end
			end
			add_inline_agents_layer
			Precursor (l_as)
			remove_current_inline_agents_layer
			reset_current_inline_agents_layer
		end

feature {NONE} -- Auxiliary Features
	is_last_local_separate: BOOLEAN
		-- returns true if current processed acccess_as node is
		-- a local and separate

	is_last_internal_argument_separate: BOOLEAN
		-- returns true if current processed access_as node is
		-- an internal argument and of separate type

	locals_processor: TUPLE [has_explicit_processor_specification: BOOLEAN; entity_name: STRING; has_handler: BOOLEAN]
		-- remembers the explicit processor specification information when
		-- processing `is_local'

	locals_class_name: STRING
		-- remembers the name of the class type
		-- of a separate declared local

	add_prefix_current_cc: BOOLEAN
		-- adds a prefix 'Current' as first internal parameter
		-- used for create creation process features.

	is_local (an_access_name: STRING): BOOLEAN
			-- Returns true if `an_access_name' is declared locally
		local
			i, j, nb, nbj: INTEGER
			l_routine_as: ROUTINE_AS
			l_local: TYPE_DEC_AS
			l_class_c: CLASS_C
			l_type_visitor: SCOOP_TYPE_VISITOR
			l_processor_visitor: SCOOP_EXPLICIT_PROCESSOR_SPECIFICATION_VISITOR
		do
			-- reset some flags
			is_last_local_separate := false

			if feature_as.body /= Void then
				l_routine_as ?= feature_as.body.content
				if l_routine_as /= Void and then l_routine_as.internal_locals /= Void then
					from
						i := 1
						nb := l_routine_as.internal_locals.locals.count
					until
						i > nb
					loop
						l_local := l_routine_as.internal_locals.locals.i_th (i)
						from
							j :=1
							nbj := l_local.id_list.count
						until
							j > nbj
						loop
							if l_local.item_name (j).is_equal (an_access_name) then
								Result := true
								-- get also separate status of current local
								create l_type_visitor
								l_type_visitor.setup (parsed_class, match_list, true, true)
								l_class_c := l_type_visitor.evaluate_class_from_type (l_local.type, class_c)
								is_last_local_separate := l_type_visitor.is_separate

								-- get processor specification
								if is_last_local_separate then
									l_processor_visitor := scoop_visitor_factory.new_explicit_processor_specification_visitor(class_c)
									locals_processor := l_processor_visitor.get_explicit_processor_specification (l_local.type)
									create locals_class_name.make_from_string (l_class_c.name.as_lower)
								end
							end
							j := j + 1
						end
						i := i + 1
					end
				end
			end
		end
end
