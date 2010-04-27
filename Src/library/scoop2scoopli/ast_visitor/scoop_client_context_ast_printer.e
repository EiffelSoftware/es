note
	description: "[
					A roundtrip visitor for the generation of common client class elements. In particular:
					
					- It analyses call chains in terms of types. It also writes call chains that involve SCOOP processing using the generated SCOOP classes. These generated call chains either involve both proxies and clients or just clients. This is controlled with the avoid proxy calls in call chains flag.
					- It translates comparison operators.
					- It replaces separate types with proxy class types.
					- It transformes creation instructions and creation expressions.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
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
			process_void_as,
			process_eiffel_list,
			process_address_as,
			process_assign_as,
			process_if_as,
			process_elseif_as,
			process_object_test_as,
			process_inline_agent_creation_as,
			process_agent_routine_creation_as
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
			-- Initialize the level layers, the object tests layers and the inline agents layers.
			-- Initialize the visitor to use proxy calls in generated call chains.
		require
			a_ctxt_not_void: a_ctxt /= Void
		do
			context := a_ctxt

			initialize_level_layers
			initialize_object_tests_layers
			initialize_inline_agents_layers

			avoid_proxy_calls_in_call_chains := false
		end

	make_with_default_context
			-- Initialize and create context of type `ROUNDTRIP_STRING_LIST_CONTEXT'.
			-- Initialize the level layers, the object tests layers and the inline agents layers.
			-- Initialize the visitor to use proxy calls in generated call chains.
		do
			make (create {ROUNDTRIP_STRING_LIST_CONTEXT}.make)

			initialize_level_layers
			initialize_object_tests_layers
			initialize_inline_agents_layers

			avoid_proxy_calls_in_call_chains := false
		end

feature {NONE} -- Type expression processing

	process_class_type_as (l_as: CLASS_TYPE_AS)
			-- Adapt the type 'l_as' for generated SCOOP classes.
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
			-- Adapt the type 'l_as' for generated SCOOP classes.
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
			l_generics_visitor.process_internal_generics (l_as.internal_generics, false, False)
			if l_as.internal_generics /= Void then
				last_index := l_generics_visitor.get_last_index
			end

			safe_process (l_as.rcurly_symbol (match_list))
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS)
			-- Adapt the type 'l_as' for generated SCOOP classes.
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
			-- For each parameter temporarily add a new levels layer.
		local
			i: INTEGER
			l_count: INTEGER
		do
			safe_process (l_as.lparan_symbol (match_list))

			-- add additional argument 'Current'
			if (previous_level_exists and then previous_level.is_separate) or add_prefix_current_cc then
				add_prefix_current_cc := False
				context.add_string ("Current, ")
			end

			if l_as.parameters /= Void and then l_as.parameters.count > 0 then
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
			elseif (previous_level_exists and then previous_level.is_separate) or add_prefix_current_cc then
				-- add additional argument 'Current' if last target was separate
				context.add_string (" (Current)")
			end
		end

feature {NONE} -- Calls processing

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
			-- Update the current level with 'l_as'.
		do
			safe_process (l_as.feature_name)

			update_current_level_with_call (l_as)

			-- process internal parameters and add current if target is of separate type.
			process_internal_parameters(l_as.internal_parameters)

			if avoid_proxy_calls_in_call_chains then
				if current_level.type.is_separate then
					context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
					set_current_level_is_separate (false)
				end
			end
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
			-- Update the current level with 'l_as'.
		do
			safe_process (l_as.feature_name)

			update_current_level_with_call (l_as)

			-- process internal parameters and add current if target is of separate type.
			process_internal_parameters(l_as.internal_parameters)

			if avoid_proxy_calls_in_call_chains then
				if current_level.type.is_separate then
					context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
					set_current_level_is_separate (false)
				end
			end
		end

	process_access_inv_as (l_as: ACCESS_INV_AS)
			-- Update the current level with 'l_as'.
		do
			safe_process (l_as.dot_symbol (match_list))
			safe_process (l_as.feature_name)

			update_current_level_with_call (l_as)

			-- process internal parameters and add current if target is of separate type.
			process_internal_parameters(l_as.internal_parameters)

			if avoid_proxy_calls_in_call_chains then
				if current_level.type.is_separate then
					context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
					set_current_level_is_separate (false)
				end
			end
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
			-- Update the current level with 'l_as'.
		do
			safe_process (l_as.feature_name)
			update_current_level_with_call (l_as)

			-- process internal parameters and add current if target is of separate type.
			process_internal_parameters(l_as.internal_parameters)

			if avoid_proxy_calls_in_call_chains then
				if current_level.type.is_separate then
					context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
					set_current_level_is_separate (false)
				end
			end
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
			-- Update the current level with 'l_as'.
		do
			safe_process (l_as.feature_keyword (match_list))
			safe_process (l_as.class_type)
			safe_process (l_as.dot_symbol (match_list))
			safe_process (l_as.feature_name)

			update_current_level_with_call (l_as)

			-- process internal parameters and add current if target is of separate type.
			process_internal_parameters(l_as.internal_parameters)

			if avoid_proxy_calls_in_call_chains then
				if current_level.type.is_separate then
					context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
					set_current_level_is_separate (false)
				end
			end
		end

	process_precursor_as (l_as: PRECURSOR_AS)
			-- Update the current level with 'l_as'.
		do
			safe_process (l_as.precursor_keyword)
			safe_process (l_as.parent_base_class)
			update_current_level_with_call (l_as)
			process_internal_parameters(l_as.internal_parameters)

			if avoid_proxy_calls_in_call_chains then
				if current_level.type.is_separate then
					context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
					set_current_level_is_separate (false)
				end
			end
		end

	process_result_as (l_as: RESULT_AS)
			-- Update the current level with 'l_as'.
		do
			Precursor (l_as)
			update_current_level_with_call (l_as)

			if avoid_proxy_calls_in_call_chains then
				if current_level.type.is_separate then
					context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
					set_current_level_is_separate (false)
				end
			end
		end

	process_current_as (l_as: CURRENT_AS)
			-- Update the current level with 'l_as'.
		do
			Precursor (l_as)
			update_current_level_with_call (l_as)

			if avoid_proxy_calls_in_call_chains then
				if current_level.type.is_separate then
					context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
					set_current_level_is_separate (false)
				end
			end
		end

	process_nested_as (l_as: NESTED_AS)
			-- Update the current level with the type of the target and temporarily add a new level to the current levels layer for the message. The current level does not get reset to be in line with the behavior of non-nested calls.
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

	process_assign_as (l_as: ASSIGN_AS)
		do
			-- process now the assigner call node
			safe_process (l_as.target)
			safe_process (l_as.assignment_symbol (match_list))

			-- Prepare the levels layer for the assignment source
			reset_current_levels_layer

			safe_process (l_as.source)
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
			-- Populate the current level with the type of the target and temporarily add a new level to the current levels layer for the message. The current level does not get reset to be in line with the behavior of non-nested calls.
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
			-- Update the current level with 'l_as'.
			-- Transform comparison operators '=', '/=', '~', and '/~' so that they are based on client objects.
		local
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
			l_is_left_expression_separate, l_is_right_expression_separate: BOOLEAN
			l_left_type : TYPE_A
		do
			-- Check whether we are generating proxy calls in the call chains. The processing of binary nodes differs significantly, depending on this option.
			if not avoid_proxy_calls_in_call_chains then
				-- Most operations of a binary expression are features declared in classes.
				-- There are only few exceptions from this rule. The boolean comparison operators '=', '/=', '~', and '/~' are not represented as features of a class. The compiler knows these symbols and matches them to features initially declared in 'ANY'. Therefore these operators need special treatment.
				-- For the handling of a binary operation it is important to know the separateness and the type of the left and right expression.
				-- Note: A binary operator can be nested within another binary or unary operator. But it is always at the beginning of a call chain.

				-- Determine the separateness and the type of the left expression.
				l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor
				-- TODO: This doesn't handle the convert clauses where the types may be `converted'
				l_type_expression_visitor.evaluate_expression_type_in_workbench (l_as.left, flattened_object_tests_layers, flattened_inline_agents_layers)
				l_is_left_expression_separate := l_type_expression_visitor.is_expression_separate
				l_left_type := l_type_expression_visitor.expression_type

				-- Determine the separateness and the type of the left expression.
				-- The left expression could introduce object test locals that need to be available in the evaluation of the right expression.
				-- For this we add an object tests layer to accomodate all these object test locals.
				-- Once the right expression has been evaluated the new object tests layer can be removed once again.
				add_object_tests_layer
				add_multiple_to_current_object_tests_layer (l_type_expression_visitor.object_test_context_update)
				l_type_expression_visitor.evaluate_expression_type_in_workbench (l_as.right, flattened_object_tests_layers, flattened_inline_agents_layers)
				l_is_right_expression_separate := l_type_expression_visitor.is_expression_separate
				remove_current_object_tests_layer

				-- Process the binary operator.
				-- What kind of operator do we have?
				if attached {BIN_NOT_TILDE_AS} l_as as l_bin_not_tilde_as then
					-- We have a '/~' operator. It is not a feature. We must make sure that the comparison is based on the client objects and not on the proxy objects.
					-- An expression 'left_separate /~ right_separate' gets translated to:
					-- 	(left_separate = Void or else right_separate = Void) or else
					--	(
					--		left_separate /= Void and then right_separate /= Void and then
					--		left_separate.implementation_ /~ right_separate.implementation_
					--	)
					-- An expression 'left_separate /~ right_non_separate' gets translated to:
					--	(left_separate = Void or else right_non_separate = Void) or else
					--	(
					--		left_separate /= Void and then right_non_separate /= Void and then
					--		left_separate.implementation_ /~ right_non_separate
					--	)
					-- An expression 'left_non_separate /~ right_separate' gets translated to:
					--	(left_non_separate = Void or else right_separate = Void) or else
					--	(
					--		left_non_separate /= Void and then right_separate /= Void and then
					--		left_non_separate /~ right_separate.implementation_
					--	)
					-- An expression 'left_non_separate /~ right_non_separate' gets translated to:
					--	left_non_separate /~ right_non_separate

					-- What is the separateness of the left and the right expression?
					if not l_is_left_expression_separate and not l_is_right_expression_separate then
						-- Both expressions are non separate.
						safe_process (l_as.left)
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right)
						remove_current_levels_layer
					else
						-- At least one of the expression is separate.

						-- Create the beginning of the common void check part. Levels layers and object tests layers temporarily get added for the processing of the left and the right expression during the generation of the void checks.
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
						reset_current_levels_layer

						context.add_string ("(")
						add_object_tests_layer
						safe_process (l_as.left); context.add_string (" /= Void")
						context.add_string (" and then ")
						add_levels_layer
						last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
						remove_current_levels_layer
						remove_current_object_tests_layer
						context.add_string (" and then ")
						reset_current_levels_layer

						-- Create the operation invocation part on the client objects.
						if not l_is_left_expression_separate and l_is_right_expression_separate then
							safe_process (l_as.left)
							safe_process (l_as.operator (match_list))
							add_levels_layer
							safe_process (l_as.right); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							remove_current_levels_layer
						elseif l_is_left_expression_separate and not l_is_right_expression_separate then
							safe_process (l_as.left); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							safe_process (l_as.operator (match_list))
							add_levels_layer
							safe_process (l_as.right)
							remove_current_levels_layer
						elseif l_is_left_expression_separate and l_is_right_expression_separate then
							safe_process (l_as.left); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							safe_process (l_as.operator (match_list))
							add_levels_layer
							safe_process (l_as.right); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							remove_current_levels_layer
						end

						-- Create the end of the common void check part.
						context.add_string (")")
					end

					-- We want to remember the type of the binary expression. It is not determine by the left or the right expression. Instead it is just a boolean.
					reset_current_levels_layer
					update_current_level_with_type (False, create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
				elseif attached {BIN_NE_AS} l_as as l_bin_ne_as then
					-- We have a '/=' operator. It is not a feature. We must make sure that the comparison is based on the client objects and not on the proxy objects.
					-- An expression 'left_separate /= right_separate' gets translated to:
					-- 	(left_separate = Void and then right_separate /= Void) or else
					--	(left_separate /= Void and then right_separate = Void) or else
					--	(
					--		left_separate /= Void and then right_separate /= Void and then
					--		left_separate.implementation_ /= right_separate.implementation_
					--	)
					-- An expression 'left_separate /= right_non_separate' gets translated to:
					--	(left_separate = Void and then right_non_separate /= Void) or else
					--	(left_separate /= Void and then right_non_separate = Void) or else
					--	(
					--		left_separate /= Void and then right_non_separate /= Void and then
					--		left_separate.implementation_ /= right_non_separate
					--	)
					-- An expression 'left_non_separate /= right_separate' gets translated to:
					--	(left_non_separate = Void and then right_separate /= Void) or else
					--	(left_non_separate /= Void and then right_separate = Void) or else
					--	(
					--		left_non_separate /= Void and then right_separate /= Void and then
					--		left_non_separate /= right_separate.implementation_
					--	)
					-- An expression 'left_non_separate /= right_non_separate' gets translated to:
					--	left_non_separate /= right_non_separate

					-- What is the separateness of the left and the right expression?
					if not l_is_left_expression_separate and not l_is_right_expression_separate then
						-- Both expressions are non-separate.
						safe_process (l_as.left)
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right)
						remove_current_levels_layer
					else
						-- At least one of the expression is separate.

						-- Create the beginning of the common void check part. Levels layers and object tests layers temporarily get added for the processing of the left and the right expression during the generation of the void checks.
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
						reset_current_levels_layer

						context.add_string ("(")
						add_object_tests_layer
						safe_process (l_as.left); context.add_string (" /= Void")
						context.add_string (" and then ")
						add_levels_layer
						last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" = Void")
						remove_current_levels_layer
						remove_current_object_tests_layer
						context.add_string (")")
						context.add_string (" or else ")
						reset_current_levels_layer

						context.add_string ("(")
						add_object_tests_layer
						safe_process (l_as.left); context.add_string (" /= Void")
						context.add_string (" and then ")
						add_levels_layer
						last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
						remove_current_levels_layer
						remove_current_object_tests_layer
						context.add_string (" and then ")
						reset_current_levels_layer

						-- Create the operation invocation part on the client objects.
						if not l_is_left_expression_separate and l_is_right_expression_separate then
							safe_process (l_as.left)
							safe_process (l_as.operator (match_list))
							add_levels_layer
							safe_process (l_as.right); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							remove_current_levels_layer
						elseif l_is_left_expression_separate and not l_is_right_expression_separate then
							safe_process (l_as.left); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							safe_process (l_as.operator (match_list))
							add_levels_layer
							safe_process (l_as.right)
							remove_current_levels_layer
						elseif l_is_left_expression_separate and l_is_right_expression_separate then
							safe_process (l_as.left); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							safe_process (l_as.operator (match_list))
							add_levels_layer
							safe_process (l_as.right); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							remove_current_levels_layer
						end

						-- Create the end of the common void check part.
						context.add_string (")")
					end

					-- We want to remember the type of the binary expression. It is not determine by the left or the right expression. Instead it is just a boolean.
					reset_current_levels_layer
					update_current_level_with_type (False, create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
				elseif attached {BIN_TILDE_AS} l_as as l_bin_tilde_as then
					-- We have a '~' operator. It is not a feature. We must make sure that the comparison is based on the client objects and not on the proxy objects.
					-- An expression 'left_separate ~ right_separate' gets translated to:
					-- 	left_separate /= Void and then
					--	right_separate /= Void and then
					--	left_separate.implementation_ ~ right_separate.implementation_
					-- An expression 'left_separate ~ right_non_separate' gets translated to:
					--	left_separate /= Void and then
					--	right_non_separate /= Void and then
					--	left_separate.implementation_ ~ right_non_separate
					-- An expression 'left_non_separate ~ right_separate' gets translated to:
					--	left_non_separate /= Void and then
					--	right_separate /= Void and then
					--	left_non_separate ~ right_separate.implementation_
					-- An expression 'left_non_separate ~ right_non_separate' gets translated to:
					--	left_non_separate ~ right_non_separate

					-- What is the separateness of the left and the right expression?
					if not l_is_left_expression_separate and not l_is_right_expression_separate then
						-- Both expressions are non-separate.
						safe_process (l_as.left)
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right)
						remove_current_levels_layer
					else
						-- At least one of the expression is separate.

						-- Create the common void check part. Levels layers and object tests layers temporarily get added for the processing of the left and the right expression during the generation of the void checks.
						add_object_tests_layer
						safe_process (l_as.left); context.add_string (" /= Void")
						context.add_string (" and then ")
						add_levels_layer
						last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
						remove_current_levels_layer
						remove_current_object_tests_layer
						context.add_string (" and then ")
						reset_current_levels_layer

						-- Create the operation invocation part on the client objects.
						if not l_is_left_expression_separate and l_is_right_expression_separate then
							safe_process (l_as.left)
							safe_process (l_as.operator (match_list))
							add_levels_layer
							safe_process (l_as.right); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							remove_current_levels_layer
						elseif l_is_left_expression_separate and not l_is_right_expression_separate then
							safe_process (l_as.left); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							safe_process (l_as.operator (match_list))
							add_levels_layer
							safe_process (l_as.right)
							remove_current_levels_layer
						elseif l_is_left_expression_separate and l_is_right_expression_separate then
							safe_process (l_as.left); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							safe_process (l_as.operator (match_list))
							add_levels_layer
							safe_process (l_as.right); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							remove_current_levels_layer
						end
					end

					-- We want to remember the type of the binary expression. It is not determine by the left or the right expression. Instead it is just a boolean.
					reset_current_levels_layer
					update_current_level_with_type (False, create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
				elseif attached {BIN_EQ_AS} l_as as l_bin_eq_as then
					-- We have a '=' operator. It is not a feature. We must make sure that the comparison is based on the client objects and not on the proxy objects.
					-- An expression 'left_separate = right_separate' gets translated to:
					-- 	(left_separate = Void and then right_separate = Void) or else
					-- 	(
					--		left_separate /= Void and then right_separate /= Void and then
					--		left_separate.implementation_ = right_separate.implementation_
					--	)
					-- An expression 'left_separate = right_non_separate' gets translated to:
					--	(left_separate = Void and then right_non_separate = Void) or else
					--	(
					--		left_separate /= Void and then right_non_separate /= Void and then
					--		left_separate.implementation_ = right_non_separate
					--	)
					-- An expression 'left_non_separate = right_separate' gets translated to:
					--	(left_non_separate = Void and then right_separate = Void) or else
					--	(
					--		left_non_separate /= Void and then right_separate /= Void and then
					--		left_non_separate = right_separate.implementation_
					--	)
					-- An expression 'left_non_separate = right_non_separate' gets translated to:
					--	left_non_separate = right_non_separate

					-- What is the separateness of the left and the right expression?
					if not l_is_left_expression_separate and not l_is_right_expression_separate then
						-- Both expressions are non-separate.
						safe_process (l_as.left)
						safe_process (l_as.operator (match_list))
						add_levels_layer
						safe_process (l_as.right)
						remove_current_levels_layer
					else
						-- At least one of the expression is separate.

						-- Create the beginning of the common void check part. Levels layers and object tests layers temporarily get added for the processing of the left and the right expression during the generation of the void checks.
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
						reset_current_levels_layer

						context.add_string ("(")
						add_object_tests_layer
						safe_process (l_as.left); context.add_string (" /= Void")
						context.add_string (" and then ")
						add_levels_layer
						last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
						remove_current_levels_layer
						remove_current_object_tests_layer
						context.add_string (" and then ")
						reset_current_levels_layer

						-- Create the operation invocation part on the client objects.
						if not l_is_left_expression_separate and l_is_right_expression_separate then
							safe_process (l_as.left)
							safe_process (l_as.operator (match_list))
							add_levels_layer
							safe_process (l_as.right); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							remove_current_levels_layer
						elseif l_is_left_expression_separate and not l_is_right_expression_separate then
							safe_process (l_as.left); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							safe_process (l_as.operator (match_list))
							add_levels_layer
							safe_process (l_as.right)
							remove_current_levels_layer
						elseif l_is_left_expression_separate and l_is_right_expression_separate then
							safe_process (l_as.left); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							safe_process (l_as.operator (match_list))
							add_levels_layer
							safe_process (l_as.right); context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
							remove_current_levels_layer
						end

						-- Create the end of the common void check part.
						context.add_string (")")
					end

					-- We want to remember the type of the binary expression. It is not determine by the left or the right expression. Instead it is just a boolean.
					reset_current_levels_layer
					update_current_level_with_type (False, create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
				else
					-- We have an operator different than '=', '/=', '~', or '/~'. It is a feature of the left expression and the right expression is the argument.

					-- Is the left expression separate?
					if l_is_left_expression_separate then
						-- Yes, the left expression is separate: Replace the infix call with a non-infix call, because the proxy doesn't have aliases anymore.

						-- Process the left expression and update the current level with its type to resolve the operator in this type. Processing the left expression only maintains this type while the expression is processed. We use the type expression visitor to update the current level.
						safe_process (l_as.left)
						reset_current_levels_layer
						update_current_level_with_type (l_is_left_expression_separate, l_left_type)

						-- Add a level, process the operator as a non-infix, non-alias feature and update the new level.
						add_level
						l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor
						-- l_feature_name_visitor.process_infix_str (l_as.operator_ast.name)
						-- context.add_string ("." + l_feature_name_visitor.get_feature_name)
						convert_infix (l_left_type, l_as.operator_ast.name)
						last_index := l_as.operator_index
						update_current_level_with_name (l_as.infix_function_name)
						-- Note: This class could inherit from PREFIX_INFIX_NAMES.. then it can be used to resolve symbols to prefix or infix names

						-- Process the right expression as an argument. The target is a separate and therefore it is a proxy object. Thus we need to add the caller as a first actual argument.
						context.add_string ("(Current,")
						add_levels_layer
						safe_process (l_as.right)
						remove_current_levels_layer
						context.add_string (")")
					else
						-- No, the left expression is not separate: Process it as usual.

						-- Process the left expression and update the current level with its type to resolve the operator in this type. Processing the left expression only maintains this type while the expression is processed. We use the type expression visitor to update the current level.
						safe_process (l_as.left)
						reset_current_levels_layer
						update_current_level_with_type (l_is_left_expression_separate, l_left_type)

						-- Add a level, process the operator and update the new level.
						add_level
						if attached {BIN_AND_THEN_AS} l_as as l_bin_and_then_as then
							safe_process (l_bin_and_then_as.and_keyword (match_list))
							safe_process (l_bin_and_then_as.then_keyword (match_list))
						elseif attached {BIN_OR_ELSE_AS} l_as as l_or_else_as then
							safe_process (l_or_else_as.or_keyword (match_list))
							safe_process (l_or_else_as.else_keyword (match_list))
						else
							safe_process (l_as.operator (match_list))
						end
						update_current_level_with_name (l_as.infix_function_name)

						-- Process the right expression as an argument.
						add_levels_layer
						safe_process (l_as.right)
						remove_current_levels_layer
					end
				end
			else
				-- Note: The transformation of the operators '=', '/=', '~', and '/~' is not necessary if we do not generated proxy calls in the call chains.

				-- Determine the type of the left expression.
				l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor
				l_type_expression_visitor.evaluate_expression_type_in_workbench (l_as.left, flattened_object_tests_layers, flattened_inline_agents_layers)
				l_left_type := l_type_expression_visitor.expression_type

				-- Process the left expression and update the current level with its type to resolve the operator in this type. Processing the left expression only maintains this type while the expression is processed. We use the type expression visitor to update the current level. The current level is not separate, because we do not generate proxy calls.
				safe_process (l_as.left)
				reset_current_levels_layer
				update_current_level_with_type (false, l_left_type)

				-- Add a level, process the operator and update the new level.
				add_level
				if attached {BIN_AND_THEN_AS} l_as as l_bin_and_then_as then
					safe_process (l_bin_and_then_as.and_keyword (match_list))
					safe_process (l_bin_and_then_as.then_keyword (match_list))
				elseif attached {BIN_OR_ELSE_AS} l_as as l_or_else_as then
					safe_process (l_or_else_as.or_keyword (match_list))
					safe_process (l_or_else_as.else_keyword (match_list))
				else
					safe_process (l_as.operator (match_list))
				end
				update_current_level_with_name (l_as.infix_function_name)

				-- Process the right expression as an argument.
				add_levels_layer
				safe_process (l_as.right)
				remove_current_levels_layer
			end
		end

	convert_infix (l_type : TYPE_A; symb : STRING)
		local
			l_feature : FEATURE_I
		do
			l_feature := l_type.associated_class.feature_table.alias_item (symb)
		end

	process_unary_as (l_as: UNARY_AS)
			-- Update current level with 'l_as'.
		local
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
		do
			-- Note: A unary operator can be nested within another binary or unary operator. But it is always at the beginning of a call chain.
			if attached {UN_OLD_AS} l_as as l_un_old_as then
				safe_process (l_un_old_as.expr)
			else
				l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor
				l_type_expression_visitor.evaluate_expression_type_in_workbench (l_as.expr, flattened_object_tests_layers, flattened_inline_agents_layers)
				safe_process (l_as.operator (match_list))
				safe_process (l_as.expr)
				reset_current_levels_layer
				update_current_level_with_type (l_type_expression_visitor.is_expression_separate, l_type_expression_visitor.expression_type)
				add_level
				update_current_level_with_name (l_as.prefix_feature_name)
			end
		end

	process_bin_and_then_as (l_as: BIN_AND_THEN_AS)
			-- Update current level with 'l_as'.
		do
			process_binary_as (l_as)
		end

	process_bin_or_else_as (l_as: BIN_OR_ELSE_AS)
			-- Update current level with 'l_as'.
		do
			process_binary_as (l_as)
		end

	process_address_as (l_as: ADDRESS_AS)
			-- Update the current level with 'l_as'.
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_string_as (l_as: STRING_AS)
			-- Update the current level with 'l_as'.
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
			-- Update the current level with 'l_as'.
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_real_as (l_as: REAL_AS)
			-- Update the current level with 'l_as'.
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_integer_as (l_as: INTEGER_AS)
			-- Update the current level with 'l_as'.
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_char_as (l_as: CHAR_AS)
			-- Update the current level with 'l_as'.
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_typed_char_as (l_as: TYPED_CHAR_AS)
			-- Update the current level with 'l_as'.
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_bool_as (l_as: BOOL_AS)
			-- Update the current level with 'l_as'.
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_void_as (l_as: VOID_AS)
			-- Update the current level with 'l_as'.
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

	process_bang_creation_expr_as (l_as: BANG_CREATION_EXPR_AS)
			-- Update the current level with 'l_as'.
		do
			Precursor(l_as)
			update_current_level_with_call (l_as)

			if avoid_proxy_calls_in_call_chains then
				if current_level.type.is_separate then
					context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
					set_current_level_is_separate (false)
				end
			end
		end

feature {NONE} -- Features processing

	process_feature_as (l_as: FEATURE_AS)
		do
			set_current_feature_as (l_as)
			Precursor (l_as)
		end

feature {NONE} -- Creation handling

	process_create_creation_as (l_as: CREATE_CREATION_AS)
			-- Process `l_as'.
		local
			is_separate: BOOLEAN
			l_class_name: STRING
			l_feature_i: FEATURE_I
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
			l_target_type: TYPE_A
			l_processor_tag: PROCESSOR_TAG_TYPE
		do

			l_feature_i := class_c.feature_named (feature_as.feature_name.name)
			l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor

			if l_as.type /= Void then
				-- Get type by the explicit type
				l_type_expression_visitor.resolve_type_in_workbench (l_as.type)
				is_separate := l_type_expression_visitor.resolved_type.is_separate
				l_target_type := l_type_expression_visitor.resolved_type
				l_processor_tag := l_type_expression_visitor.resolved_type.processor_tag
				l_class_name := l_type_expression_visitor.expression_type.associated_class.name.as_lower
			elseif l_as.target /= Void then
				l_type_expression_visitor.evaluate_call_type_in_class_and_feature (l_as.target, class_c, l_feature_i, flattened_object_tests_layers, flattened_inline_agents_layers)
				is_separate := l_type_expression_visitor.is_expression_separate
				l_target_type := l_type_expression_visitor.expression_type
				l_processor_tag := l_type_expression_visitor.expression_type.processor_tag
				l_class_name := l_type_expression_visitor.expression_type.associated_class.name.as_lower
			end

			if is_separate then

				------------------------------------------------------------------------------------------
				-- Separate create creation.															--
				------------------------------------------------------------------------------------------
				if not l_processor_tag.has_explicit_tag then
					-- current object is separate, but has no explicit processor specification

					-- create SCOOP object with new processor
					safe_process (l_as.create_keyword (match_list))
					safe_process (l_as.type)
					safe_process (l_as.target)
					context.add_string (".")
					context.add_string("set_processor_ (scoop_scheduler.new_processor_); ")
				elseif not l_processor_tag.has_handler then
					-- current entity is separate and has an explicit processor specification
					-- but is not defined by a handler.

					process_leading_leaves (l_as.create_keyword_index)

					-- add processor void test
					context.add_string ("if " + l_processor_tag.tag_name + " = Void then ")
					context.add_string ( l_processor_tag.tag_name + ":= scoop_scheduler.new_processor_ end; ")

					-- create SCOOP object with new processor
					safe_process (l_as.create_keyword (match_list))
					safe_process (l_as.type)
					safe_process (l_as.target)
					context.add_string (".set_processor_ (" + l_processor_tag.parsed_processor_name + "); ")
				else
					-- current entity is separate and has an explicit processor specification.
					-- it is defined also by a handler.

					process_leading_leaves (l_as.create_keyword_index)

					-- add processor void test
					context.add_string ("check " + l_processor_tag.tag_name + " /= Void and then " + l_processor_tag.tag_name + ".processor_ /= Void end ")

					-- create SCOOP object with new processor
					safe_process (l_as.create_keyword (match_list))
					safe_process (l_as.type)
					safe_process (l_as.target)
					context.add_string (".set_processor_ (" + l_processor_tag.tag_name + ".processor_); ")
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
					add_prefix_current_cc := True
					if l_as.call.internal_parameters /= Void then
						last_index := l_as.call.internal_parameters.first_token (match_list).index
					end
					process_internal_parameters(l_as.call.internal_parameters)
					add_prefix_current_cc := False
				else
					context.add_string (".default_create_scoop_separate_" + l_class_name)
					-- internal parameter: 'Current'
					context.add_string (" (Current)")
				end
				context.add_string (", Void, Void, Void)")
				if l_as.call /= Void then
					last_index := l_as.call.last_token (match_list).index
				end
			else
				------------------------------------------------------------------------------------------
				-- Non separate create creation.														--
				------------------------------------------------------------------------------------------

				-- Does the type of the target has a class type that comes from an excluded library?
				if is_in_ignored_group (l_target_type.associated_class) then
					-- Yes, it does.
					-- Base classes do not get processed. Therefore we cannot set the processor of the target.
					safe_process (l_as.create_keyword (match_list))
					safe_process (l_as.type)
					safe_process (l_as.target)
					safe_process (l_as.call)
				else
					-- No, it doesn't.
					-- The class got processed and we have to set the processor of the target to the current processor.

					-- Create code that calls the processor setter feature as a creation routine. Note that every client class has the processor setter feature as the only constructor.
					safe_process (l_as.create_keyword (match_list))
					safe_process (l_as.type)
					add_levels_layer
					safe_process (l_as.target)
					remove_current_levels_layer
					context.add_string (".")
					context.add_string (
						{SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_setter_name +
						"(Current." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_getter_name + ")"
					)
					context.add_string ("; ")

					-- Create code that calls the creation routine as a normal feature, if an explicit call exists. Note that client classes have no export status anymore.
					if l_as.call /= void then
						-- Does the creation instruction denote a type?
						if l_as.type /= void then
							-- Yes, it does.
							-- Create code that casts the target to the denotes type to call the creation routine as a normal feature.
							last_index := l_as.type.last_token (match_list).index - 1
							context.add_string ("if attached {")
							safe_process (l_as.type)
							context.add_string ("} ")
							safe_process (l_as.target)
							context.add_string (" as target then")
							context.add_string ("target")
							safe_process (l_as.call)
							context.add_string ("end; ")
						else
							-- No, it doesn't.
							-- Create code that calls the creation routine as a normal feature without a cast.
							last_index := l_as.target.last_token (match_list).index - 1
							safe_process (l_as.target)
							safe_process (l_as.call)
						end
					end
				end
				last_index := l_as.last_token (match_list).index
			end
		end

	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS)
			-- Update the current level with 'l_as'.
		local
			wrapper: STRING
			original_context: ROUNDTRIP_CONTEXT
			l_last_index: INTEGER
			l_class_name: STRING
			wrapper_name,feat_name: STRING
			already_inserted: BOOLEAN
			local_wrapper_object: STRING
			arg_postfix,creation_object_name: STRING
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
			l_target_type: TYPE_A
			l_processor_tag: PROCESSOR_TAG_TYPE
		do

			if derived_class_information.create_creations /= void then
				if not derived_class_information.create_creations.has (l_as) then
					derived_class_information.create_creations.go_i_th (derived_class_information.create_creations.count)
					derived_class_information.create_creations.put_right (l_as)
					current_create_creation_position := derived_class_information.create_creations.count
				else
					current_create_creation_position := derived_class_information.create_creations.index_of (l_as, 1)
				end
			end

			l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor
			l_type_expression_visitor.resolve_type_in_workbench (l_as.type)
			l_target_type := l_type_expression_visitor.resolved_type
			l_processor_tag := l_type_expression_visitor.resolved_type.processor_tag
			l_class_name := l_type_expression_visitor.resolved_type.associated_class.name.as_lower

			if l_type_expression_visitor.resolved_type.is_separate then
				------------------------------------------------------------------------------------------
				-- Separate create creation expression: Create a wrapper to generate the correct separate object
				------------------------------------------------------------------------------------------

				create wrapper.make_empty
				if feature_as /= void then
					feat_name := feature_as.feature_name.name+"_"
				else
					-- Invariant
					feat_name := ""
				end

				wrapper_name := feat_name+class_as.class_name.name.as_lower+"_sp_"+{SCOOP_SYSTEM_CONSTANTS}.create_creation_wrapper+"_nr"+current_create_creation_position.out

				if is_processing_assertions then
					context.add_string (wrapper_name)
				else
					context.add_string ("creation_object"+current_create_creation_position.out)
				end

				if is_processing_assertions then
					if l_processor_tag.has_handler then
						-- If processor has handler , pass it on to the wrapper
						context.add_string("("+l_processor_tag.tag_name+")")
					end
				end

				-- Create a new context to process creation
				original_context := context
				l_last_index := last_index
				context := create {ROUNDTRIP_STRING_LIST_CONTEXT}.make

				if is_processing_assertions then

					-- Build wrapper feature and insert it before the current feature
					wrapper.append ("%N%N%T")
					wrapper.append (wrapper_name)

					if l_processor_tag.has_explicit_tag and then l_processor_tag.has_handler then
						-- Pass on the handler:
						wrapper.append ("("+l_processor_tag.tag_name+"_arg: SCOOP_SEPARATE_TYPE)")
					end
				end

				last_index := l_as.type.first_token (match_list).index
				safe_process (l_as.type)
				last_index := l_as.type.last_token (match_list).index

				if is_processing_assertions then
					-- Print processed items
					wrapper.append (": "+context.string_representation.substring (context.string_representation.index_of ('{', 1)+1, context.string_representation.index_of ('}', 1)-1))
					wrapper.append (" is")
					wrapper.append ("%N%T%T")
					wrapper.append ("-- Wrapper for separate create creation expression")
					wrapper.append ("%N%T%Tlocal")
					wrapper.append ("%N%T%T%Tcreation_object: ")
					-- Print processed items
					wrapper.append (context.string_representation.substring (context.string_representation.index_of ('{', 1)+1, context.string_representation.index_of ('}', 1)-1))
					wrapper.append ("%N%T%Tdo%N%T%T%T")

				else
					create local_wrapper_object.make_empty
					if attached {ROUTINE_AS} feature_as.body.content as rout then
						if rout.internal_locals = void then
							feature_object.set_need_local_section(True)
						end
					end

					local_wrapper_object.append ("%N%T%T%T"+{SCOOP_SYSTEM_CONSTANTS}.creation_object+current_create_creation_position.out+": ")
					local_wrapper_object.append (context.string_representation.substring (context.string_representation.index_of ('{', 1)+1, context.string_representation.index_of ('}', 1)-1)+"%N")
				end
				context.clear
				if is_processing_assertions then
					creation_object_name := {SCOOP_SYSTEM_CONSTANTS}.creation_object
					if l_processor_tag.has_explicit_tag and then l_processor_tag.has_handler then
						-- Entity is passed as an argument
						arg_postfix := "_arg"
					else
						arg_postfix := ""
					end
				else
					arg_postfix := ""
					creation_object_name := {SCOOP_SYSTEM_CONSTANTS}.creation_object+current_create_creation_position.out
				end

				if not l_processor_tag.has_explicit_tag then
					wrapper.append ("create "+creation_object_name+"")
					wrapper.append (".set_processor_ (scoop_scheduler.new_processor_); ")
				elseif not l_processor_tag.has_handler then
					process_leading_leaves (l_as.create_keyword_index)
					wrapper.append ("if " + l_processor_tag.tag_name + arg_postfix + " = Void then ")
					wrapper.append (l_processor_tag.tag_name + arg_postfix + ":= scoop_scheduler.new_processor_ end; ")
					wrapper.append ("create "+creation_object_name+".set_processor_ (" + l_processor_tag.tag_name + arg_postfix + "); ")
				else
					process_leading_leaves (l_as.create_keyword_index)
					wrapper.append ("check " + l_processor_tag.tag_name + arg_postfix + " /= Void and then " + l_processor_tag.tag_name + arg_postfix + ".processor_ /= Void end; ")
					wrapper.append ("create "+creation_object_name+".set_processor_ (" + l_processor_tag.tag_name + arg_postfix + ".processor_); ")
				end
				wrapper.append ("separate_execute_routine (["+creation_object_name+".processor_], agent "+creation_object_name+"")
				if l_as.call /= Void then
					wrapper.append ("." + l_as.call.feature_name.name)
					wrapper.append ("_scoop_separate_" + l_class_name)
					add_prefix_current_cc := True
					if l_as.call.internal_parameters /= Void then
						last_index := l_as.call.internal_parameters.first_token (match_list).index
					end
					context.clear
					process_internal_parameters (l_as.call.internal_parameters)
					wrapper.append (context.string_representation)
					add_prefix_current_cc := False
				else
					wrapper.append (".default_create_scoop_separate_" + l_class_name)
					wrapper.append (" (Current)")
				end
				wrapper.append(", Void, Void, Void)")
				if is_processing_assertions then
					wrapper.append ("%N%T%T%TResult := "+{SCOOP_SYSTEM_CONSTANTS}.creation_object)
					wrapper.append ("%N%T%Tend%N")
				end
				context.clear
				-- Restore original Context
				last_index := l_last_index
				context := original_context
				last_index := l_as.last_token (match_list).index
			else
				------------------------------------------------------------------------------------------
				-- Non separate create creation.
				------------------------------------------------------------------------------------------

				create wrapper.make_empty
				if feature_as /= void then
					feat_name := feature_as.feature_name.name+"_"
				else
					-- Invariant
					feat_name := ""
				end

				wrapper_name := feat_name+class_as.class_name.name.as_lower+"_nsp_"+{SCOOP_SYSTEM_CONSTANTS}.create_creation_wrapper+"_nr"+current_create_creation_position.out

				if is_processing_assertions then
					context.add_string (wrapper_name)
				else
					context.add_string ("creation_object"+current_create_creation_position.out)
				end
				-- Create a new context to process creation
				original_context := context
				l_last_index := last_index
				context := create {ROUNDTRIP_STRING_LIST_CONTEXT}.make

				if is_processing_assertions then
					-- Build wrapper feature and insert it before the current feature
					wrapper.append ("%N%N%T")
					wrapper.append (wrapper_name)
				end

				last_index := l_as.type.first_token (match_list).index
				safe_process (l_as.type)
				last_index := l_as.type.last_token (match_list).index

				if is_processing_assertions then
					-- Print processed items
					wrapper.append (": "+context.string_representation.substring (context.string_representation.index_of ('{', 1)+1, context.string_representation.index_of ('}', 1)-1))
					wrapper.append (" is")
					wrapper.append ("%N%T%T")
					wrapper.append ("-- Wrapper for create creation expression")
					wrapper.append ("%N%T%Tlocal")
					wrapper.append ("%N%T%T%T"+{SCOOP_SYSTEM_CONSTANTS}.creation_object+": ")
					-- Print processed items
					wrapper.append (context.string_representation.substring (context.string_representation.index_of ('{', 1)+1, context.string_representation.index_of ('}', 1)-1))
					wrapper.append ("%N%T%Tdo%N%T%T%T")

				else
					create local_wrapper_object.make_empty
					-- Do we need to add a local section at the end?
					if attached {ROUTINE_AS} feature_as.body.content as rout then
						if rout.internal_locals = void then
							feature_object.set_need_local_section(True)
						end
					end

					local_wrapper_object.append ("%N%T%T%T"+{SCOOP_SYSTEM_CONSTANTS}.creation_object+current_create_creation_position.out+": ")
					local_wrapper_object.append (context.string_representation.substring (context.string_representation.index_of ('{', 1)+1, context.string_representation.index_of ('}', 1)-1)+"%N")
				end
				context.clear
				if is_processing_assertions then
					creation_object_name := {SCOOP_SYSTEM_CONSTANTS}.creation_object
				else
					creation_object_name := {SCOOP_SYSTEM_CONSTANTS}.creation_object+current_create_creation_position.out
				end

				-- Does the type of the target has a class type that comes from an excluded library?
				if is_in_ignored_group (l_target_type.associated_class) then
					-- Yes, it does.
					-- Base classes do not get processed. Therefore we cannot set the processor of the target.

					wrapper.append ("create " + creation_object_name)
					if l_as.call /= Void then
						wrapper.append ("." + l_as.call.feature_name.name)
						if l_as.call.internal_parameters /= Void then
							last_index := l_as.call.internal_parameters.first_token (match_list).index
						end
						context.clear
						process_internal_parameters (l_as.call.internal_parameters)
						wrapper.append (context.string_representation)
					end
				else
					-- No, it doesn't.
					-- The class got processed and we have to set the processor of the target to the current processor.

					-- Create code that calls the processor setter feature as a creation routine. Note that every client class has the processor setter feature as the only constructor.
					wrapper.append ("create " + creation_object_name)
					wrapper.append (".")
					wrapper.append (
						{SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_setter_name +
						"(Current." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_processor_getter_name + ")"
					)
					wrapper.append ("; ")

					-- Create code that calls the creation routine as a normal feature, if necessary. Note that client classes have no export status anymore.
					if l_as.call /= Void then
						wrapper.append (creation_object_name)
						wrapper.append (".")
						wrapper.append (l_as.call.feature_name.name)
						if l_as.call.internal_parameters /= Void then
							last_index := l_as.call.internal_parameters.first_token (match_list).index
						end
						context.clear
						process_internal_parameters (l_as.call.internal_parameters)
						wrapper.append (context.string_representation)
					end
				end

				if is_processing_assertions then
					wrapper.append ("%N%T%T%TResult := " + creation_object_name)
					wrapper.append ("%N%T%Tend%N")
				end
				context.clear
				-- Restore original Context
				last_index := l_last_index
				context := original_context
				last_index := l_as.last_token (match_list).index
			end

			-- Output generated objects
			if attached {ROUNDTRIP_STRING_LIST_CONTEXT} context as ctxt then
				if not is_processing_assertions then
					ctxt.insert_after_cursor (local_wrapper_object, feature_object.locals_index)
					ctxt.insert_after_cursor (wrapper+"%N%T%T%T", feature_object.last_instr_call_index)
				else
					-- Check if the assertion was already processed.

					from
						already_inserted := False
						derived_class_information.create_creation_wrappers.start
					until
						derived_class_information.create_creation_wrappers.after
					loop
						if derived_class_information.create_creation_wrappers.item.is_equal (wrapper_name) then
							already_inserted := True
						end
						derived_class_information.create_creation_wrappers.forth
					end

					if not already_inserted then
						ctxt.insert_after_cursor (wrapper, derived_class_information.wrapper_insertion_index)
						derived_class_information.create_creation_wrappers.put_front (wrapper_name)
					end

				end
			end

			update_current_level_with_call (l_as)

			if avoid_proxy_calls_in_call_chains then
				if current_level.type.is_separate then
					context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_library_implementation_getter_name)
					set_current_level_is_separate (false)
				end
			end

		end

	current_create_creation_position: INTEGER
		-- Position of the create creation which is currently beeing processed relative to all create creations in a class.
		-- Used to create uniquely identifiable wrappers

	is_processing_assertions: BOOLEAN
		-- Is the currently processed item part of an assertion?

	add_prefix_current_cc: BOOLEAN
		-- adds a prefix 'Current' as first internal parameter
		-- used for create creation process features.

feature {NONE} -- Eiffel list processing

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
			-- Reset the current levels layer before each non-empty list of instructions, type declarations, or assertion clauses and after each instruction, assertion, or type declaration.
			-- Levels layers are relevant in type declarations because processing a type declaration can involve processing calls in anchor types.
			-- Reset the current object tests layer before each non-empty list of instructions or assertion clauses and after each instruction or assertion clause.
		local
			i, l_count: INTEGER
		do
			if l_as.count > 0 then
				-- Reset the current levels layer before every list of instructions, type declarations, or assertion clauses.
				if
					attached {EIFFEL_LIST [INSTRUCTION_AS]} l_as as l_instruction_list or
					attached {EIFFEL_LIST [TYPE_DEC_AS]} l_as as l_type_declaration_list or
					attached {EIFFEL_LIST [TAGGED_AS]} l_as as l_assertion_clause_list
				then
					reset_current_levels_layer
				end

				-- Reset the current object tests layer before every list of instruction or assertion clauses.
				if
					attached {EIFFEL_LIST [INSTRUCTION_AS]} l_as as l_instruction_list or
					attached {EIFFEL_LIST [TAGGED_AS]} l_as as l_assertion_clause_list
				then
					reset_current_object_tests_layer
				end

				-- Process each list element.
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

					-- Reset the current levels layer after each instruction, type declaration, or assertion clause.
					if
						attached {EIFFEL_LIST [INSTRUCTION_AS]} l_as as l_instruction_list or
						attached {EIFFEL_LIST [TYPE_DEC_AS]} l_as as l_type_declaration_list or
						attached {EIFFEL_LIST [TAGGED_AS]} l_as as l_assertion_clause_list
					then
						reset_current_levels_layer
					end

					-- Reset the current object tests layer after each instruction or assertion clause.
					if
						attached {EIFFEL_LIST [INSTRUCTION_AS]} l_as as l_instruction_list or
						attached {EIFFEL_LIST [TAGGED_AS]} l_as as l_assertion_clause_list
					then
						reset_current_object_tests_layer
					end

					l_as.forth
				end
			end
		end

feature {NONE} -- Level handling

	avoid_proxy_calls_in_call_chains: BOOLEAN
		-- Should proxy calls be avoided in the generated call chains?

	levels_layers: STACK[LINKED_LIST[TUPLE [is_separate: BOOLEAN; type: TYPE_A]]]
		-- The levels layers. It is used to keep track of the type and the separateness of a call chain.
		-- The structure consists of a stack of layers where each layer is a list of levels. Each layer corresponds to a call chain. Every call corresponds to a level.
		-- Each level manages the type of the current call and the information whether the call chain is separate so far.
		-- Initially there is only one layer with one empty level. As a call chain gets traversed each call prepares a new empty level for the next call and / or a new levels layer for a nested call chain.
		-- Example: The call chain 'a.b (x.y)' gets traversed from left to right. At the beginning there is a single layer with an empty level. The first level gets updated with the type of 'a' and a new second level gets created for the next call 'b'. For the handling of the call chain 'x.y' a new levels layer with a single empty level gets added to the top. Once the call chain 'x.y' is processed the top levels layer gets removed. When the processing of the call 'b' is done the corresponding level gets removed. This continues until the beginning of the call chain 'a.b' is reached.

	initialize_level_layers
			-- Initialize the levels layers. The levels layers will contain a single levels layer with a single empty level.
		do
			-- set current level handling
			create {LINKED_STACK[LINKED_LIST[TUPLE [is_separate: BOOLEAN; type: TYPE_A]]]} levels_layers.make
			add_levels_layer
		end

	add_levels_layer
			-- Add a new levels layer to the levels layers. The new layer has a single empty level.
		local
			l_tuple: like current_level
		do
			levels_layers.put (create {LINKED_LIST[TUPLE [is_separate: BOOLEAN; type: TYPE_A]]}.make)
			create l_tuple
			levels_layers.item.put_front (l_tuple)
		end

	remove_current_levels_layer
			-- Remove the current levels layer from the levels layers.
		do
			levels_layers.remove
		end

	reset_current_levels_layer
			-- Reset the current levels layer. It will contain a single empty level.
		do
			levels_layers.item.wipe_out
			add_level
		end

	add_level
			-- Add an empty level to the current levels layer.
		local
			l_tuple: like current_level
		do
			create l_tuple
			levels_layers.item.put_front (l_tuple)
		end

	current_level: TUPLE [is_separate: BOOLEAN; type: TYPE_A]
			-- The latest level in the current levels layer.
		do
			Result := levels_layers.item.first
		ensure
			result_not_void: Result /= Void
		end

	remove_current_level
			-- Remove the current level from the current levels layer.
		do
			levels_layers.item.start
			levels_layers.item.remove
		end

	update_current_level_with_name (l_as: STRING)
			-- Update the current level with the result type of a call with name 'l_as'.
			-- If there is a previous level then the previous level is used for the resolution. The result type combiner is used to determine the separateness of the chain up until the call with name 'l_as' based on the type of the call with name 'l_as' and the separateness of the chain up until the previous level.
			-- Works on top of 'update_current_level_with_call'.
		do
			update_current_level_with_call (
				create {ACCESS_FEAT_AS}.initialize (
					create {ID_AS}.initialize (l_as),
					Void
				)
			)
		end

	update_current_level_with_call (l_as: CALL_AS)
			-- Update the current level with the result type of the call 'l_as'.
			-- If there is a previous level then the previous level is used for the resolution. The result type combiner is used to determine the separateness of the chain up until 'l_as' based on the type of 'l_as' and the separateness of the chain up until the previous level.
			-- Works on top of 'update_current_level_with_expression'.
		do
			update_current_level_with_expression (create {EXPR_CALL_AS}.initialize (l_as))
		end

	update_current_level_with_expression (l_as: EXPR_AS)
			-- Update the current level with the result type of the call 'l_as'.
			-- If there is a previous level then the previous level is used for the resolution. The result type combiner is used to determine the separateness of the chain up until 'l_as' based on the type of 'l_as' and the separateness of the chain up until the previous level.
			-- Works on top of 'update_current_level_with_type'.
		local
			l_type_expr_visitor: SCOOP_TYPE_EXPR_VISITOR
		do
			-- Resolve the type of the call.
			l_type_expr_visitor := scoop_visitor_factory.new_type_expr_visitor
			-- Is this call the first one in the current levels layer?
			if levels_layers.item.count = 1 then
				-- Yes, it is: Resolve the call in the surrounding class.

				-- Are we surrounded by a feature?
				if feature_as /= Void then
					-- Yes, we are: Resolve the call in the surrounding feature and the surrounding class.
					l_type_expr_visitor.evaluate_expression_type_in_class_and_feature (
						l_as,
						class_c,
						class_c.feature_table.item (feature_as.feature_name.name),
						flattened_object_tests_layers,
						flattened_inline_agents_layers
					)
				else
					-- No, we are not: Resolve the call in the surrounding class.
					l_type_expr_visitor.evaluate_expression_type_in_class (
						l_as,
						class_c,
						flattened_object_tests_layers,
						flattened_inline_agents_layers
					)
				end
			else
				-- No, we are not: Resolve the call in the previous type.
				check previous_level_exists and then previous_level.type /= Void end
				l_type_expr_visitor.evaluate_expression_type_in_type (
					l_as,
					previous_level.type,
					flattened_object_tests_layers,
					flattened_inline_agents_layers
				)
			end

			-- Update the current level with the resolved type.
			if l_type_expr_visitor.is_query then
				update_current_level_with_type (l_type_expr_visitor.is_expression_separate, l_type_expr_visitor.expression_type)
			end
		end

	update_current_level_with_type (a_is_call_chain_separate: BOOLEAN; a_type: TYPE_A)
			-- Update the current level with 'a_is_call_chain_separate' and 'a_type'.
		require
			a_type /= Void
		do
			set_current_level_type (a_type)
			if
				previous_level_exists and then
				previous_level.is_separate and
				not a_type.is_expanded
			then
				-- Propagation of 'is_separate' state
				-- Creates for nested calls for every following call an argument 'Current'
				set_current_level_is_separate (True)
			else
				set_current_level_is_separate (a_is_call_chain_separate)
			end
		end

	set_current_level_is_separate (a_value: BOOLEAN)
			-- Set the separateness flag of the current level to 'a_value'.
		local
			l_tuple: like current_level
		do
			l_tuple := current_level
			l_tuple.is_separate := a_value
		end

	set_current_level_type (a_type: TYPE_A)
			-- Set the type of the current level to 'a_value'.
		local
			l_tuple: like current_level
		do
			l_tuple := current_level
			l_tuple.type := a_type
		end

	previous_level_exists: BOOLEAN
			-- Is there a previous level in the current levels layer?
		do
			Result := levels_layers.item.count > 1
		end

	previous_level: TUPLE [is_separate: BOOLEAN; type: TYPE_A]
			-- The level before the curent level in the current levels layer.
		require
			previous_level_exists
		do
			Result := levels_layers.item.i_th (2)
		end

feature {NONE} -- Object test handling

	object_tests_layers: LINKED_STACK[HASH_TABLE[OBJECT_TEST_AS, STRING]]
		-- The object tests layers. It is used to keep track of the object tests locals of a call chain.
		-- The structure consists of a stack of layers where each layer maps names of object test locals to their types. Each layer corresponds to a set of non-nested object tests.
		-- Initially there is a single layer with an empty map. This layer will be used to keep track of the locals in the encountered object tests. A nested object test leads to the generation of a new object tests layer. Nested object tests can only occur in if statements.

	initialize_object_tests_layers
			-- Initialize the object tests layers. It consists of a single empty layer.
		do
			create object_tests_layers.make
			object_tests_layers.put (create {HASH_TABLE[OBJECT_TEST_AS, STRING]}.make(10))
		end

	add_object_tests_layer
			-- Add an empty object tests layer to the objects tests layers.
		do
			object_tests_layers.put (create {HASH_TABLE[OBJECT_TEST_AS, STRING]}.make(10))
		end

	current_object_tests_layer: HASH_TABLE[OBJECT_TEST_AS, STRING]
			-- The latest object tests layer in the object tests layer.
		do
			Result := object_tests_layers.item
		end

	remove_current_object_tests_layer
			-- Remove the current object tests layer from the objects tests layers.
		do
			object_tests_layers.remove
		end

	reset_current_object_tests_layer
			-- Reset the current object tests. It will be empty.
		do
			object_tests_layers.item.wipe_out
		end

	add_to_current_object_tests_layer (a_object_test: OBJECT_TEST_AS)
			-- Add the locals of 'a_object_test' to the current object tests layer. Nameless object test locals will not be added.
		do
			-- Does the object test name a variable?
			if a_object_test.name /= Void then
				-- Yes: We can add it.
				object_tests_layers.item.put (a_object_test, a_object_test.name.name)
			end
		end

	add_multiple_to_current_object_tests_layer (a_object_tests: HASH_TABLE[OBJECT_TEST_AS, STRING])
			-- Add all the locals of 'a_object_tests' to the current object tests layer. Nameless object test locals will not be added.
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
			-- The flattened form of the objects tests layers.
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
			-- Add the object tests of the condition to the current object tests layer. For each compound temporarily add an object tests layer.
		do

			-- Update last_instr_call_index
			process_leading_leaves (l_as.if_keyword (match_list).first_token (match_list).index)
			if attached {ROUNDTRIP_STRING_LIST_CONTEXT} context as ctxt then
				feature_object.set_last_instr_call_index(ctxt.cursor_to_current_position)
			end

			-- Process the if keyword, the condition, and the then part.
			safe_process (l_as.if_keyword (match_list))
			safe_process (l_as.condition)
			safe_process (l_as.then_keyword (match_list))
			add_object_tests_layer
			safe_process (l_as.compound)
			remove_current_object_tests_layer

			-- Process the else if parts.
			safe_process (l_as.elsif_list)

			-- Process the else part.
			safe_process (l_as.else_keyword (match_list))
			add_object_tests_layer
			safe_process (l_as.else_part)
			remove_current_object_tests_layer

			-- Process the end keyword.
			safe_process (l_as.end_keyword)
		end

	process_elseif_as (l_as: ELSIF_AS)
			-- Add the object tests of the condition to the current object tests layer. For each compound temporarily add an object tests layer.
		do
			safe_process (l_as.elseif_keyword (match_list))
			safe_process (l_as.expr)
			safe_process (l_as.then_keyword (match_list))
			add_object_tests_layer
			safe_process (l_as.compound)
			remove_current_object_tests_layer
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
			-- Update the current object tests layer with the object test locals of 'l_as'. After the processing the current object test layer does not get reset, because the locals of 'l_as' might be important in further processing steps.
		do
			Precursor (l_as)
			add_to_current_object_tests_layer (l_as)
		end

feature {NONE} -- Agent handling

	inline_agents_layers: LINKED_STACK[SET[TYPE_DEC_AS]]
		-- The inline agents layers. It is used to keep track of the entities declared in inline agents of a call chain.
		-- The structure consists of a stack of layers where each layer is a set with the entities declared in an inline agent. Each layer related to one inline agent.
		-- Initially there is a single layer with an empty set. This layer will be used to keep track of the entities in the next encountered inline agent. Each encountered inline agent creates a next empty layer for a nested inline agent.

	initialize_inline_agents_layers
			-- Initialize the inline agents layers.
		do
			create inline_agents_layers.make
			inline_agents_layers.put (create {LINKED_SET[TYPE_DEC_AS]}.make)
		end

	add_inline_agents_layer
			-- Add an empty inline agents layer to the inline agents layers.
		do
			inline_agents_layers.put (create {LINKED_SET[TYPE_DEC_AS]}.make)
		end

	current_inline_agents_layer: SET[TYPE_DEC_AS]
			-- The latest inline agents layer in the inline agents layers.
		do
			Result := inline_agents_layers.item
		end

	remove_current_inline_agents_layer
			-- Remove the current inline agents layer from the inline agents layers.
		do
			inline_agents_layers.remove
		end

	reset_current_inline_agents_layer
			-- Reset the current inline agents layer. It will be empty.
		do
			inline_agents_layers.item.wipe_out
		end

	add_to_current_inline_agents_layer (a_type_declaration: TYPE_DEC_AS)
			-- Add the entities from 'a_type_declaration' to the current inline agents layer.
		do
			inline_agents_layers.item.put (a_type_declaration)
		end

	flattened_inline_agents_layers: HASH_TABLE[TYPE_AS, STRING]
			-- The flattened from of the inline agents layers.
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
			-- Populate the current inline agents layer with the entities from 'l_as'. Recursively process each nested inline agent in new inline agents layers. After the processing the current inline agents layer gets reset, because the entities are only relevant in nested inline agents.
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
			if attached {ROUTINE_AS} l_as.body.content as l_routine and then l_routine.locals /= Void then
				from
					i := 1
				until
					i > l_routine.locals.count
				loop
					add_to_current_inline_agents_layer (l_routine.locals.i_th (i))
					i := i + 1
				end
			end

			update_current_level_with_expression (l_as)

			add_inline_agents_layer
			Precursor (l_as)
			remove_current_inline_agents_layer
			reset_current_inline_agents_layer
		end

	process_agent_routine_creation_as (l_as: AGENT_ROUTINE_CREATION_AS)
		do
			Precursor (l_as)
			update_current_level_with_expression (l_as)
		end

note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- SCOOP_CLIENT_CONTEXT_AST_PRINTER
