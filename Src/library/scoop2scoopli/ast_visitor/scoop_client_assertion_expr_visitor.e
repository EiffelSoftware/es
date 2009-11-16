indexing
	description: "Summary description for {SCOOP_EXPR_VISITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCOOP_CLIENT_ASSERTION_EXPR_VISITOR

inherit
	AST_ROUNDTRIP_ITERATOR
		redefine
			process_tagged_as,
			process_id_as,
			process_binary_as,
			process_expr_call_as,
			process_access_feat_as,
			process_access_inv_as,
			process_access_id_as,
			process_static_access_as,
			process_tuple_as,
			process_precursor_as,
			process_parameter_list_as,
			process_create_creation_expr_as,
			process_bang_creation_expr_as,
			process_nested_expr_as,
			process_nested_as,
			process_void_as
		end
	SHARED_ERROR_HANDLER
		export
			{NONE} all
		end
	SCOOP_WORKBENCH

feature -- Initialisation

	make (an_argument_object: SCOOP_CLIENT_ARGUMENT_OBJECT)
			-- Initialisation with list of the separate internal arguments
		require
			an_argument_object_not_void: an_argument_object /= Void
		do
			arguments := an_argument_object
		end

feature -- Access

	safe_process_expr (l_as: AST_EIFFEL; a_tagged_as: TAGGED_AS) is
			-- interface for recursive calls (binary expression, internal arguments)
		do
			if l_as /= Void then
					-- create new assertion object - for each tagged_as one
				current_assertion := create {SCOOP_CLIENT_ASSERTION_OBJECT}.make

					-- set current tagged_as
				current_assertion.set_tagged_as (a_tagged_as)

					-- new expression, reset.
				reset_assertion_evaluation

					-- set start position
				last_index := l_as.start_position - 1

					-- process expression
				safe_process (l_as)

					-- evaluate the processed expression
				evaluate_assertion
			end
		end

	get_assertion_object: SCOOP_CLIENT_ASSERTIONS is
			-- getter for 'assertions'
		do
			Result := assertions
		end

feature {NONE} -- Visitor implementation

	process_tagged_as (l_as: TAGGED_AS) is
		do
				-- create new assertion object - for each tagged_as one
			current_assertion := create {SCOOP_CLIENT_ASSERTION_OBJECT}.make

				-- set current tagged_as
			current_assertion.set_tagged_as (l_as)

				-- new expression, reset.
			reset_assertion_evaluation

				-- not interested in tag and colon symbol
			if l_as /= Void then
				last_index := l_as.colon_symbol_index
			end

				-- process only the expression
			safe_process (l_as.expr)

				-- evaluate the processed expression
			evaluate_assertion
		end

	process_id_as (l_as: ID_AS) is
		local
			a_type_dec: TYPE_DEC_AS
			l_call_tuple: TUPLE [call_name: STRING; is_separate: BOOLEAN]
			l_type_visitor: SCOOP_TYPE_VISITOR
		do
			Precursor (l_as)

			-- analyse call:
			-- calls are traversed from left to right by the roundtrip parser.
			-- therefore we can follow the chain and evaluate the types.
			-- binary expression, lists and internal arguments are treated differently

			-- last id name
			last_id_name := l_as.name

			if is_first_level or last_level_class = Void then
					-- first level: base class is actual parsed class
				last_level_class := class_c
			end

			if not is_call_expression then
				-- we are only interested in call expressions.
				-- e.g. we are not interested in internal arguments of calls.

			elseif arguments.is_separate_argument (l_as.name.as_lower) then
				-- the id is an internal separate argument of the routine.

					-- flag as separate.
				current_assertion.set_is_containing_separate_calls (true)

					-- count occurrence of separate argument
				count_postcondition_arguments(l_as.name.as_lower)

					-- debugging information
				debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
					l_call_tuple := [l_as.name.as_lower, true]
					current_assertion.calls.extend (l_call_tuple)
				end

				a_type_dec := arguments.get_argument_by_name(l_as.name)

				create l_type_visitor
				l_type_visitor.setup (parsed_class, match_list, true, true)
				last_level_class := l_type_visitor.evaluate_class_from_type (a_type_dec.type, last_level_class)

			elseif arguments.is_non_separate_argument (l_as.name) then
				-- the id is an internal non-separate argument of the routine.

					-- flag assertion as containing non separate calls.
				if is_first_level then
					current_assertion.set_is_containing_non_separate_calls (true)

						-- debugging information
					debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
						l_call_tuple := [l_as.name.as_lower, false]
						current_assertion.calls.extend (l_call_tuple)
					end
				end

				a_type_dec := arguments.get_argument_by_name(l_as.name)

				create l_type_visitor
				l_type_visitor.setup (parsed_class, match_list, true, true)
				last_level_class := l_type_visitor.evaluate_class_from_type (a_type_dec.type, last_level_class)

			elseif last_level_class.feature_table.has (l_as.name) then
				-- the id is resolved by the feature table

					-- set separate state.
				if last_level_class.feature_table.item (l_as.name).type.is_separate then
					current_assertion.set_is_containing_separate_calls (true)

						-- debugging information
					debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
						l_call_tuple := [l_as.name.as_lower, true]
						current_assertion.calls.extend (l_call_tuple)
					end
				else
					if is_first_level then
						current_assertion.set_is_containing_non_separate_calls (true)
					end

						-- debugging information
					debug ("SCOOP_CLIENT_ASSERTIONS_EXT")
						l_call_tuple := [l_as.name.as_lower, false]
						current_assertion.calls.extend (l_call_tuple)
					end
				end

				last_level_class := get_class_by_feature_name (last_id_name)

			else
				error_handler.insert_error (create {INTERNAL_ERROR}.make (
						"In {SCOOP_CLIENT_EXPR_VISITOR}.process_id_as could%N%
						%not find a valid type for the id element."))
			end

			if is_first_level then
				is_first_level := false
			end

				-- reset is call flag
			is_call_expression := false
		end

	process_binary_as (l_as: BINARY_AS) is
		local
			l_expression_visitor: like current
			an_assertion_object: SCOOP_CLIENT_ASSERTIONS
		do
				-- process left side as call
			is_call_expression := true

			safe_process (l_as.left)

			safe_process (l_as.operator (match_list))

			-- binary expression are translated in SCOOP into a common call:
			-- 'a + b' -> a.plus(b). So evaluate b as an internal parameter
			-- in a new visitor.

			if l_as /= Void and then l_as.right /= Void then
				l_expression_visitor := create_same_visitor
				l_expression_visitor.setup (parsed_class, match_list, true, true)
					-- evaluate the expression
				l_expression_visitor.safe_process_expr (l_as.right, current_assertion.get_tagged_as)
					-- get the assertion object
				an_assertion_object := l_expression_visitor.get_assertion_object
					-- evaluate the expression
				evaluate_external_assertion_object (an_assertion_object)
			end
		end

	process_expr_call_as (l_as: EXPR_CALL_AS) is
		do
				-- current node is a call
			is_call_expression := true

			Precursor (l_as)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS) is
		do
				-- current node is a call
			is_call_expression := true

			safe_process (l_as.feature_name)

				-- process parameters in a new visitor.
			process_internal_parameters(l_as.internal_parameters)
		end

	process_access_inv_as (l_as: ACCESS_INV_AS) is
		do
			safe_process (l_as.dot_symbol (match_list))
			safe_process (l_as.feature_name)

				-- process parameters in a new visitor.
			process_internal_parameters(l_as.internal_parameters)
		end

	process_access_id_as (l_as: ACCESS_ID_AS) is
		do
				-- current node is a call
			is_call_expression := true

			safe_process (l_as.dot_symbol (match_list))
			safe_process (l_as.feature_name)

				-- process parameters in a new visitor.
			process_internal_parameters(l_as.internal_parameters)
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS) is
		do
				-- current node is a call
			is_call_expression := true

			safe_process (l_as.feature_keyword (match_list))
			safe_process (l_as.class_type)
			safe_process (l_as.dot_symbol (match_list))
			safe_process (l_as.feature_name)

				-- process parameters in a new visitor.
			process_internal_parameters(l_as.internal_parameters)
		end

	process_precursor_as (l_as: PRECURSOR_AS) is
		do
			safe_process (l_as.precursor_keyword)
			safe_process (l_as.parent_base_class)

				-- process parameters in a new visitor.
			process_internal_parameters(l_as.internal_parameters)
		end

	process_tuple_as (l_as: TUPLE_AS) is
		do
			safe_process (l_as.lbracket_symbol (match_list))

				-- process expression list in a new visitor.
			process_tuple_expressions (l_as.expressions)

			safe_process (l_as.rbracket_symbol (match_list))
		end

	process_parameter_list_as (l_as: PARAMETER_LIST_AS) is
			-- Process `l_as'.
		do
			safe_process (l_as.lparan_symbol (match_list))
			if l_as.parameters /= Void then
				process_eiffel_list_with_evaluation (l_as.parameters)
			end
			safe_process (l_as.rparan_symbol (match_list))
		end

	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS) is
			-- Process `l_as'.
		do
				-- current node is a call
			is_call_expression := true

			Precursor (l_as)
		end

	process_bang_creation_expr_as (l_as: BANG_CREATION_EXPR_AS) is
			-- Process `l_as'.
		do
				-- current node is a call
			is_call_expression := true

			Precursor (l_as)
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS) is
		do
				-- current node is a call
			is_call_expression := true

			Precursor (l_as)
		end

	process_nested_as (l_as: NESTED_AS) is
		do
				-- current node is a call
			is_call_expression := true

			Precursor (l_as)
		end

	process_void_as (l_as: VOID_AS) is
		do
			current_assertion.set_is_containing_void (true)

				-- process void_as
			Precursor(l_as)
		end

feature {NONE} -- Implementation

	reset_assertion_evaluation is
			-- resets assertion attributes.
		do
			is_first_level := true
			current_assertion.set_is_containing_void (false)
			current_assertion.set_is_containing_non_separate_calls (false)
			current_assertion.set_is_containing_separate_calls (false)
			current_assertion.set_is_containing_old_or_result (false)

				-- reset also expression evaluation flags
			reset_expression_evaluation
		end

	reset_expression_evaluation is
			-- resets the expression attributes.
		do
			is_expr_containing_non_separate_call := false
			is_expr_separate_assertion := false
			is_call_expression := false
		end

	save_expression_evaluation is
			-- resets expression attributes.
		do
				-- save is_containing_non_separate_call flag
			if current_assertion.is_containing_non_separate_calls then
				is_expr_containing_non_separate_call := current_assertion.is_containing_non_separate_calls
			end

				-- save is_separate_assertion flag
			if current_assertion.is_containing_separate_calls then
				is_expr_separate_assertion := current_assertion.is_containing_separate_calls
			end
		end

	evaluate_assertion is
			-- evaluates expression attributes after visiting the node.
		deferred
			-- analyse call:
			-- calls are traversed from left to right by the roundtrip parser.
			-- therefore we can follow the chain and evaluate the types.
			-- see also 'process_nested_expr_as', 'process_nested_as'.
			-- binary expression: evaluate every expression as a single one.
		end

	evaluate_expression is
			-- evaluates a single expression after visiting the node.
		deferred
			-- analyse call:
			-- calls are traversed from left to right by the roundtrip parser.
			-- therefore we can follow the chain and evaluate the types.
			-- single expression evaluation needed when binary expressions occures
			-- or a list of expressions.
		end

	process_internal_parameters (l_as: PARAMETER_LIST_AS) is
			-- Process 'l_as'. Type of l_as: PARAN_LIST_AS [EIFFEL_LIST [EXPR_AS]]
			-- Create a new visitor which interates the expression list.
		local
			l_expression_visitor: like current
			an_assertion_object: SCOOP_CLIENT_ASSERTIONS
		do
			if l_as /= Void then
				l_expression_visitor := create_same_visitor
				l_expression_visitor.setup (parsed_class, match_list, true, true)
				l_expression_visitor.safe_process_expr (l_as, current_assertion.get_tagged_as)
				an_assertion_object := l_expression_visitor.get_assertion_object
				evaluate_external_assertion_object (an_assertion_object)
			end
		end

	create_same_visitor: SCOOP_CLIENT_ASSERTION_EXPR_VISITOR is
			-- deferred feature to create a visitor of the same type
		deferred
		end

	count_postcondition_arguments(an_argument_name: STRING) is
			-- counts the separate argument
		do
		end

	process_tuple_expressions (l_as: EIFFEL_LIST [EXPR_AS]) is
			-- Process 'l_as'. Type of l_as: EIFFEL_LIST [EXPR_AS]
			-- Create a new visitor which interates the expression list.
		local
			l_expression_visitor: like current
			an_assertion_object: SCOOP_CLIENT_ASSERTIONS
		do
			if l_as /= Void then
				l_expression_visitor := create_same_visitor
				l_expression_visitor.setup (parsed_class, match_list, true, true)
				process_eiffel_list_with_evaluation (l_as)
				an_assertion_object := l_expression_visitor.get_assertion_object
				evaluate_external_assertion_object (an_assertion_object)
			end
		end

	process_eiffel_list_with_evaluation (l_as: EIFFEL_LIST [AST_EIFFEL]) is
		local
			i, l_count: INTEGER
		do
			-- reset expresion evaluation before analysing list
			reset_expression_evaluation

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
						-- reset the expression evaluation
					save_expression_evaluation
						-- visit the node					
					safe_process (l_as.item)
						-- evaluate the expression
					evaluate_expression

					if i <= l_count then
						safe_process (l_as.separator_list_i_th (i, match_list))
						i := i + 1
					end
					l_as.forth
				end
			end
		end

	evaluate_external_assertion_object (an_assertion_object: SCOOP_CLIENT_ASSERTIONS) is
			-- interface for evaluation implementation after getting information from internal paramters.
		require
			an_assertion_object_not_void: an_assertion_object /= Void
		deferred
		end

	get_class_by_feature_name (a_feature_name: STRING): CLASS_C	 is
			-- returns the class of the feature
		do
			if last_level_class.feature_table.has (a_feature_name) then
				Result := last_level_class.feature_table.item (a_feature_name).type.associated_class
			end
		end

feature {NONE} -- Implementation

	current_assertion: SCOOP_CLIENT_ASSERTION_OBJECT
		-- current assertion object

	last_id_name: STRING
		-- current id name

	last_level_class: CLASS_C
		-- current base class of an evaluated call

	is_first_level: BOOLEAN
		-- indicates that the first level of an expression is processed.

	is_expr_separate_assertion: BOOLEAN
		-- indicates the occurrence of a separate call of an already processed binary or list expression.

	is_expr_containing_non_separate_call: BOOLEAN
		-- indicates that the tagged as contains a non separate call of an already processed binary or list expression.

	is_call_expression: BOOLEAN
		-- indicates that last expression was a call.

	arguments: SCOOP_CLIENT_ARGUMENT_OBJECT
		-- object collects processed arguments of processed feature

	assertions: SCOOP_CLIENT_ASSERTIONS
		-- Result object.

invariant
	assertions_not_void: assertions /= Void

end
