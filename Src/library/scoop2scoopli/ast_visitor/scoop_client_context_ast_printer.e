indexing
	description: "Summary description for {SCOOP_CLIENT_CONTEXT_AST_PRINTER}. "
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
--			process_create_creation_expr_as,
			process_binary_as,
			process_unary_as,
			process_assign_as
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

	make (a_ctxt: ROUNDTRIP_CONTEXT)  is
			-- Initialize and set `context' with `a_ctxt'.
		require
			a_ctxt_not_void: a_ctxt /= Void
		do
			context := a_ctxt

			-- initialize level handling
			initialize_level_handling
		end

	make_with_default_context is
			-- Initialize and create context of type `ROUNDTRIP_STRING_LIST_CONTEXT'.
		do
			make (create {ROUNDTRIP_STRING_LIST_CONTEXT}.make)

			-- initialize level handling
			initialize_level_handling
		end

feature {NONE} -- Roundtrip: process type expression

	process_class_type_as (l_as: CLASS_TYPE_AS) is
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

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
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

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
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

feature {NONE} -- Roundtrip: 'Current' as first argument in paramenter list

	process_parameter_list_as (l_as: PARAMETER_LIST_AS) is
			-- Process `l_as'.
		do
			safe_process (l_as.lparan_symbol (match_list))
			-- add additional argument 'Current'
			if is_last_call_separate or add_prefix_current_cc then
				add_prefix_current_cc := false
				context.add_string ("Current, ")
			end

			-- process parameters as new expression
			-- save therefore some values for the next nested message.
			increase_nested_level
			process_parameter_list (l_as.parameters)
			decrease_nested_level

			safe_process (l_as.rparan_symbol (match_list))
		end

feature {NONE} -- Roundtrip: process access nodes, call expressions with internal parameters.

	process_access_feat_as (l_as: ACCESS_FEAT_AS) is
		do
			safe_process (l_as.feature_name)

			-- process internal parameters and add current if target is of separate type.
			increase_nested_level
			process_internal_parameters(l_as.internal_parameters)
			decrease_nested_level

			-- get 'is_separate' information about current call for next expr
			set_current_level_is_separate (evaluate_id(l_as.feature_name))
		end

	process_access_inv_as (l_as: ACCESS_INV_AS) is
		do
			safe_process (l_as.dot_symbol (match_list))
			safe_process (l_as.feature_name)

			-- process internal parameters and add current if target is of separate type.
			increase_nested_level
			process_internal_parameters(l_as.internal_parameters)
			decrease_nested_level

			-- get 'is_separate' information about current call for next expr
			set_current_level_is_separate (evaluate_id(l_as.feature_name))
		end

	process_access_id_as (l_as: ACCESS_ID_AS) is
		do
			safe_process (l_as.feature_name)

			-- process internal parameters and add current if target is of separate type.
			increase_nested_level
			process_internal_parameters(l_as.internal_parameters)
			decrease_nested_level

			-- get 'is_separate' information about current call for next expr
			set_current_level_is_separate (evaluate_id(l_as.feature_name))
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS) is
		local
			l_type_visitor: SCOOP_TYPE_VISITOR
			l_class_as: CLASS_TYPE_AS
		do
			safe_process (l_as.feature_keyword (match_list))
			safe_process (l_as.class_type)
			safe_process (l_as.dot_symbol (match_list))

			-- get base class
			create l_type_visitor
			l_type_visitor.setup (parsed_class, match_list, true, true)
			set_current_level_base_class (l_type_visitor.evaluate_class_from_type (l_as.class_type, class_c))

			l_class_as ?= l_as.class_type
			if l_class_as /= Void and then l_class_as.is_separate then
				set_current_level_is_separate (true)
			end

			-- increase current nested level
			increase_nested_level

			safe_process (l_as.feature_name)

			-- process internal parameters and add current if target is of separate type.
			increase_nested_level
			process_internal_parameters(l_as.internal_parameters)
			decrease_nested_level

			-- decrease current nested level
			decrease_nested_level
		end

	process_precursor_as (l_as: PRECURSOR_AS) is
		local
			l_type_visitor: SCOOP_TYPE_VISITOR
		do
			safe_process (l_as.precursor_keyword)
			safe_process (l_as.parent_base_class)
			increase_nested_level
			safe_process (l_as.internal_parameters)
			decrease_nested_level

			-- get separate and base class information
			if feature_as.body.type /= Void then
				create l_type_visitor
				l_type_visitor.setup (parsed_class, match_list, true, true)
				set_current_level_base_class (l_type_visitor.evaluate_class_from_type (feature_as.body.type, class_c))
				set_current_level_is_separate (l_type_visitor.is_separate)
			end
		end

	process_result_as (l_as: RESULT_AS) is
		local
			l_type_visitor: SCOOP_TYPE_VISITOR
		do
			-- process node
			Precursor (l_as)

			-- get separate and base class information
			create l_type_visitor
			l_type_visitor.setup (parsed_class, match_list, true, true)
			set_current_level_base_class (l_type_visitor.evaluate_class_from_type (feature_as.body.type, class_c))
			set_current_level_is_separate (l_type_visitor.is_separate)
		end

	process_current_as (l_as: CURRENT_AS) is
		do
			-- current level is per definition not separate therefore nothing to do
			Precursor (l_as)
		end

feature {NONE} -- Roundtrip: process nested nodes

	process_nested_as (l_as: NESTED_AS)
			-- Process `l_as'.
		do
			set_current_level_is_separate (false)
			safe_process (l_as.target)
			safe_process (l_as.dot_symbol (match_list))

			-- increase current nested level
			increase_nested_level

			safe_process (l_as.message)

			-- decrease current nested level
			decrease_nested_level
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
			-- Process `l_as'.
		do
			set_current_level_is_separate (false)
			safe_process (l_as.lparan_symbol (match_list))
			safe_process (l_as.target)
			safe_process (l_as.rparan_symbol (match_list))
			safe_process (l_as.dot_symbol (match_list))

			-- increase current nested level
			increase_nested_level

			safe_process (l_as.message)

			-- decrease current nested level
			decrease_nested_level
		end

feature {NONE} -- Roundtrip: process binary expressions

	process_binary_as (l_as: BINARY_AS)
		local
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
			l_type_expression_visitor: SCOOP_TYPE_EXPR_VISITOR
			l_is_left_expression_separate, l_is_right_expression_separate: BOOLEAN
		do
			l_type_expression_visitor := scoop_visitor_factory.new_type_expr_visitor

			l_type_expression_visitor.evaluate_type_from_expr (l_as.left, class_c)
			l_is_left_expression_separate := l_type_expression_visitor.is_last_type_separate

			l_type_expression_visitor.evaluate_type_from_expr (l_as.right, class_c)
			l_is_right_expression_separate := l_type_expression_visitor.is_last_type_separate

			if {l_bin_not_tilde_as: BIN_NOT_TILDE_AS} l_as then
				if not l_is_left_expression_separate and not l_is_right_expression_separate then
					safe_process (l_as.left)
					safe_process (l_as.operator (match_list))
					safe_process (l_as.right)
				else
					context.add_string ("(")
					safe_process (l_as.left); context.add_string (" = Void")
					context.add_string (" or else ")
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" = Void")
					context.add_string (")")
					context.add_string (" or else ")
					context.add_string ("(")
					safe_process (l_as.left); context.add_string (" /= Void")
					context.add_string (" and then ")
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
					context.add_string (" and then ")
					if not l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left)
						safe_process (l_as.operator (match_list))
						safe_process (l_as.right); context.add_string (".implementation_")
					elseif l_is_left_expression_separate and not l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						safe_process (l_as.right)
					elseif l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						safe_process (l_as.right); context.add_string (".implementation_")
					end
					context.add_string (")")
				end

			elseif {l_bin_ne_as: BIN_NE_AS} l_as then
				if not l_is_left_expression_separate and not l_is_right_expression_separate then
					safe_process (l_as.left)
					safe_process (l_as.operator (match_list))
					safe_process (l_as.right)
				else
					context.add_string ("(")
					safe_process (l_as.left); context.add_string (" = Void")
					context.add_string (" and then ")
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
					context.add_string (")")
					context.add_string (" or else ")
					context.add_string ("(")
					safe_process (l_as.left); context.add_string (" /= Void")
					context.add_string (" and then ")
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" = Void")
					context.add_string (")")
					context.add_string (" or else ")
					context.add_string ("(")
					safe_process (l_as.left); context.add_string (" /= Void")
					context.add_string (" and then ")
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
					context.add_string (" and then ")
					if not l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left)
						safe_process (l_as.operator (match_list))
						safe_process (l_as.right); context.add_string (".implementation_")
					elseif l_is_left_expression_separate and not l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						safe_process (l_as.right)
					elseif l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						safe_process (l_as.right); context.add_string (".implementation_")
					end
					context.add_string (")")
				end
			elseif {l_bin_tilde_as: BIN_TILDE_AS} l_as then
				if not l_is_left_expression_separate and not l_is_right_expression_separate then
					safe_process (l_as.left)
					safe_process (l_as.operator (match_list))
					safe_process (l_as.right)
				else
					safe_process (l_as.left); context.add_string (" /= Void")
					context.add_string (" and then ")
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
					context.add_string (" and then ")
					if not l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left)
						safe_process (l_as.operator (match_list))
						safe_process (l_as.right); context.add_string (".implementation_")
					elseif l_is_left_expression_separate and not l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						safe_process (l_as.right)
					elseif l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						safe_process (l_as.right); context.add_string (".implementation_")
					end
				end
			elseif {l_bin_eq_as: BIN_EQ_AS} l_as then
				if not l_is_left_expression_separate and not l_is_right_expression_separate then
					safe_process (l_as.left)
					safe_process (l_as.operator (match_list))
					safe_process (l_as.right)
				else
					context.add_string ("(")
					safe_process (l_as.left); context.add_string (" = Void")
					context.add_string (" and then ")
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" = Void")
					context.add_string (")")
					context.add_string (" or else ")
					context.add_string ("(")
					safe_process (l_as.left); context.add_string (" /= Void")
					context.add_string (" and then ")
					last_index := l_as.operator_index; safe_process (l_as.right); context.add_string (" /= Void")
					context.add_string (" and then ")
					if not l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left)
						safe_process (l_as.operator (match_list))
						safe_process (l_as.right); context.add_string (".implementation_")
					elseif l_is_left_expression_separate and not l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						safe_process (l_as.right)
					elseif l_is_left_expression_separate and l_is_right_expression_separate then
						safe_process (l_as.left); context.add_string (".implementation_")
						safe_process (l_as.operator (match_list))
						safe_process (l_as.right); context.add_string (".implementation_")
					end
					context.add_string (")")
				end
			else
				if l_is_left_expression_separate then
					-- The left expression is separate. Replace the infix call with a non-infix call.
					safe_process (l_as.left)
					-- process infix operator
					l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor
					l_feature_name_visitor.process_infix_str (l_as.operator_ast.name)
					context.add_string ("." + l_feature_name_visitor.get_feature_name)
					last_index := l_as.operator_index

					-- add brackets for non-infix call
					context.add_string ("(Current,")
					increase_nested_level
					increase_nested_level
					safe_process (l_as.right)
					decrease_nested_level
					decrease_nested_level
					context.add_string (")")
				else
					-- left expression of binary operation is not of separate type
					-- process it as usual
					safe_process (l_as.left)
					safe_process (l_as.operator (match_list))
					safe_process (l_as.right)
				end
			end
		end

	process_unary_as (l_as: UNARY_AS) is
		do
			safe_process (l_as.operator (match_list))
			safe_process (l_as.expr)
		end

feature {NONE} -- Visitor implementation

	process_feature_as (l_as: FEATURE_AS) is
		do
			set_current_feature_as (l_as)
			Precursor (l_as)
		end

feature {NONE} -- Visitor implementation: creation

	process_assign_as (l_as: ASSIGN_AS) is
		local
			l_expr_call_as: EXPR_CALL_AS
			l_create_creation_expr_as: CREATE_CREATION_EXPR_AS
			l_processor_visitor: SCOOP_EXPLICIT_PROCESSOR_SPECIFICATION_VISITOR
			l_processor: like locals_processor
		do
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

	process_create_creation_expr (l_as: CREATE_CREATION_EXPR_AS; a_target_name: STRING) is
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
					increase_nested_level
					increase_nested_level
					add_prefix_current_cc := true
					if l_as.call.internal_parameters /= Void then
						last_index := l_as.call.internal_parameters.start_position
					end
					process_internal_parameters(l_as.call.internal_parameters)
					add_prefix_current_cc := false
					decrease_nested_level
					decrease_nested_level
				else
					context.add_string (".default_create_scoop_separate_" + l_class_name)
					-- internal parameter: 'Current'
					context.add_string (" (Current)")
				end
				context.add_string (", Void, Void, Void)")
				if l_as.call /= Void and then not (l_as.call.internal_parameters /= Void) then
					last_index := l_as.call.end_position
				end
			end
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS) is
			-- Process `l_as'.
		local
			is_separate: BOOLEAN
			l_target_name, l_class_name: STRING
			l_class_c: CLASS_C
			l_result_as: RESULT_AS
			l_feature_i: FEATURE_I
			l_type_visitor: SCOOP_TYPE_VISITOR
			l_type_expression_visitor: SCOOP_CLIENT_TYPE_EXPR_VISITOR
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
					l_type_expression_visitor := scoop_visitor_factory.new_client_type_expr_visitor
					-- get separate status
					is_separate := l_type_expression_visitor.is_access_as_separate (l_as.target)
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
					increase_nested_level
					increase_nested_level
					add_prefix_current_cc := true
					if l_as.call.internal_parameters /= Void then
						last_index := l_as.call.internal_parameters.start_position
					end
					process_internal_parameters(l_as.call.internal_parameters)
					add_prefix_current_cc := false
					decrease_nested_level
					decrease_nested_level
				else
					context.add_string (".default_create_scoop_separate_" + l_class_name)
					-- internal parameter: 'Current'
					context.add_string (" (Current)")
				end
				context.add_string (", Void, Void, Void)")
				if l_as.call /= Void then
					last_index := l_as.call.end_position
				end
			end
		end

feature {NONE} -- Implementation

	process_internal_parameters (l_as: PARAMETER_LIST_AS) is
			-- adds the paramter 'Current' to the list if
			-- it is a nested call and the target of separate type.
		do
			if l_as /= Void then
				-- add additional argument 'Current' if last target was separate
				-- add a 'dummy level' so that the next target has no type information as basis
				process_parameter_list_as (l_as)
			elseif is_last_call_separate or add_prefix_current_cc then
				-- add additional argument 'Current' if last target was separate
				context.add_string (" (Current)")
			end
		end

	process_parameter_list (l_as: EIFFEL_LIST [AST_EIFFEL]) is
			-- Process parameter eiffel list like `process_eiffel_list'
			-- but create for each new parameter a new visitor
		local
			i, l_count: INTEGER
		do
			if l_as.count > 0 then
				from
					l_as.start
					i := 1
					if l_as.separator_list /= Void then
						l_count := l_as.separator_list.count
					end
				until
					l_as.after
				loop

					-- reset current level flags for each paramter
					reset_current_level
					-- process the node
					safe_process (l_as.item)

					if i <= l_count then
						safe_process (l_as.separator_list_i_th (i, match_list))
						i := i + 1
					end
					l_as.forth
				end
			end
		end

feature {NONE} -- Separate status evaluation

	evaluate_id (l_as: ID_AS): BOOLEAN is
			-- evaluates the separated state of the entity behind id
		local
			l_type_expr_visitor: SCOOP_TYPE_EXPR_VISITOR
		do
			-- get is_separate information of the current call
			if is_last_level_separate then
				-- Propagation of 'is_separate' state
				-- Creates for nested calls for every following call an argument 'Current'
				Result := true
			else
				create l_type_expr_visitor
				l_type_expr_visitor.setup (parsed_class, match_list, true, true)
				if last_base_class /= Void then
					l_type_expr_visitor.evaluate_type_from_expr (l_as, last_base_class)
				else
					l_type_expr_visitor.evaluate_type_from_expr (l_as, class_c)
				end
				set_current_level_base_class (l_type_expr_visitor.get_new_base_class)
				Result := l_type_expr_visitor.is_last_type_separate
			end
		end

	is_local (an_access_name: STRING): BOOLEAN is
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

feature {NONE} -- Level handling

	initialize_level_handling is
			-- Initialize level handling attributes
		local
			l_tuple: like current_level
		do
			-- set current level handling
			create nested_level
			nested_level := 0
			create nested_levels.make

			-- create current level
			create l_tuple
			l_tuple.level := nested_level
			nested_levels.put_front (l_tuple)
		end

	current_level: TUPLE [level: INTEGER; is_separate: BOOLEAN; base_class: CLASS_C] is
			-- Returns the current `nested_levels' tuple.
		do
			Result := nested_levels.first
		ensure
			Result_not_void: Result /= Void
		end

	is_last_call_separate: BOOLEAN is
			-- Returns `is_separate' of level -2.
		local
			l_result_tuple: like current_level
		do
			if nested_level - 2 >= 0 then
				-- go to third item
				nested_levels.start
				nested_levels.forth
				nested_levels.forth

				l_result_tuple := nested_levels.item

				Result := l_result_tuple.is_separate
			end
		end

	is_last_level_separate: BOOLEAN is
			-- Returns `is_separate' of level -1.
		local
			l_result_tuple: like current_level
		do
			if nested_level - 1 >= 0 then
				-- go to second item
				nested_levels.start
				nested_levels.forth

				l_result_tuple := nested_levels.item

				Result := l_result_tuple.is_separate
			end
		end

	last_base_class: CLASS_C is
			-- Returns `base_class' of `nested_levels's item(nested_level - 1)
		local
			l_result_tuple: like current_level
		do
			if nested_level - 1 >= 0 then

				-- go to second item
				nested_levels.start
				nested_levels.forth

				-- get item
				l_result_tuple := nested_levels.item

				Result := l_result_tuple.base_class
			end
		end

	set_current_level_is_separate (a_value: BOOLEAN) is
			-- Marks current level's `is_separate' information with `a_value'
		local
			l_tuple: like current_level
		do
			l_tuple := current_level
			l_tuple.is_separate := a_value
		end

	set_current_level_base_class (a_base_class: CLASS_C) is
			-- Marks current level's `is_separate' information with `a_value'
		local
			l_tuple: like current_level
		do
			l_tuple := current_level
			l_tuple.base_class := a_base_class
		end

	reset_current_level is
			-- Resets the current level's tuple
		local
			l_tuple: like current_level
		do
			l_tuple := current_level
			l_tuple.is_separate := false
			l_tuple.base_class := Void
		end

	increase_nested_level is
			-- Increases the current level
		local
			l_tuple: like current_level
		do
			-- increase current nested level
			nested_level := nested_level + 1

			-- create tuple for current level
			create l_tuple
			l_tuple.level := nested_level
			nested_levels.put_front (l_tuple)
		end

	decrease_nested_level is
			-- Decreases the current level
		do
			-- remove current level
			nested_levels.start
			nested_levels.remove

			-- decrease current nested level
			nested_level := nested_level - 1
		end

feature {NONE} -- Implementation

	nested_levels: LINKED_LIST[TUPLE [level: INTEGER; is_separate: BOOLEAN; base_class: CLASS_C]]
		-- saves `is_separate' information for nested calls in levels

	nested_level: INTEGER
		-- current nested call level

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

invariant
	valid_nested_level: nested_level >= 0
	nested_levels_not_void: nested_levels /= Void
	nested_leve_inv: nested_level = nested_levels.count - 1

end
