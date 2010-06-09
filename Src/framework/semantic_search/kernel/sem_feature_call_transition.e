note
	description: "Objects that represent transition materialized through a feature call"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_FEATURE_CALL_TRANSITION

inherit
	SEM_TRANSITION
		redefine
			name,
			is_feature_call
		end

	EPA_HASH_CALCULATOR

	EPA_UTILITY

	DEBUG_OUTPUT

create
	make

feature{NONE} -- Initialization

	make (a_class: like class_; a_feature: like feature_;  a_operands: HASH_TABLE [STRING, INTEGER]; a_context: like context; a_is_creation: BOOLEAN)
			-- Initialize Current as the transition of `a_feature' in `a_class'.
			-- `a_operands' is a table indicating the operands for current transition.
			-- Key of `a_operands' are 0-based operand (including result, if any) indexes,
			-- 0 means target, 1 means the first argument, and so on,
			-- value of `a_operands' is the name of that operands.
			-- All the variables in `a_operands' should also be defined in `a_context'.
		require
			operand_count_valid: operand_count_of_feature (a_feature) = a_operands.count
		do
			class_ := a_class
			feature_ := a_feature
			context := a_context
			context_type := a_context.variables.item (a_operands.item (0))
			is_creation := a_is_creation
			create precondition.make (20, context.class_, context.feature_)
			create postcondition.make (20, context.class_, context.feature_)
			create written_preconditions.make (5, context.class_, context.feature_)
			create written_postconditions.make (5, context.class_, context.feature_)
			initialize_boosts
			initialize (a_operands)
		end

feature -- Access

	feature_: FEATURE_I
			-- Feature which is modeled by current transition.

	class_: CLASS_C
			-- Class from which `feature_' is viewed.

	content: STRING
			-- <Precursor>

	name: STRING
			-- Name of current transition

	as_snippet: SEM_SNIPPET
			-- A snippet version of current feature call transition
			-- Because a feature call is a snippet by nature.
			-- Note: The other way around is not true. In general, a snippet
			-- cannot be translated into a feature call.
		local
			l_positions: HASH_TABLE [INTEGER, STRING]
			l_inputs: DS_HASH_SET [STRING]
			l_outputs: DS_HASH_SET [STRING]
		do
				-- Initialize variable position table `l_positions'.
			create l_positions.make (variable_positions.count)
			l_positions.compare_objects
			variable_positions.do_all_with_key (
				agent (a_pos: INTEGER; a_var: EPA_EXPRESSION; a_tbl: HASH_TABLE [INTEGER, STRING])
					do
						a_tbl.put (a_pos, a_var.text)
					end (?, ?, l_positions))

				-- Initialize input set `l_inputs'.
			create l_inputs.make (inputs.count)
			l_inputs.set_equality_tester (string_equality_tester)
			inputs.do_all (
				agent (a_var: EPA_EXPRESSION; a_set: DS_HASH_SET [STRING])
					do
						a_set.force_last (a_var.text)
					end (?, l_inputs))

				-- Initialize output set `l_outputs'.
			create l_outputs.make (outputs.count)
			l_outputs.set_equality_tester (string_equality_tester)
			outputs.do_all (
				agent (a_var: EPA_EXPRESSION; a_set: DS_HASH_SET [STRING])
					do
						a_set.force_last (a_var.text)
					end (?, l_outputs))

				-- Construct the resulting snippet transition.
			create Result.make (context, l_positions, l_inputs, l_outputs, content)
			Result.set_precondition (precondition)
			Result.set_postcondition (postcondition)
			Result.set_precondition_boosts (precondition_boosts)
			Result.set_postcondition_boosts (postcondition_boosts)
		end

feature -- Status report

	is_creation: BOOLEAN
			-- Is current transition a creation?

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := content_of_transition_internal (variable_type_name)
		end

feature -- Type status report

	is_feature_call: BOOLEAN = True
			-- Is Current a feature call queryable?

feature -- Visitor

	process (a_visitor: SEM_QUERYABLE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_feature_call (Current)
		end

feature -- Basic operations

	add_written_precondition
			-- Add precondition written in `feature_' into `precondition'.
		local
			l_state: EPA_STATE
		do
			l_state := rewritten_contracts (contract_extractor.precondition_expression_set (class_, feature_), True)
			adapt_state (l_state, precondition)
			adapt_state (l_state, written_preconditions)
		end

	add_written_postcondition
			-- Add postcondition written in `feature_' into `postcondition'.
		local
			l_state: EPA_STATE
		do
			l_state := rewritten_contracts (contract_extractor.postcondition_expression_set  (class_, feature_), False)
			adapt_state (l_state, postcondition)
			adapt_state (l_state, written_postconditions)
		end

feature{NONE} -- Implementation

	content_of_transition_internal (a_variable_display_type: INTEGER): STRING
			-- Content of current transition
			-- `a_variable_display_type' indicates how variables are outputed.
		require
			a_variable_display_type_valid: is_valid_variable_display_type (a_variable_display_type)
		local
			l_target_index: INTEGER
			l_result_index: INTEGER
			l_arg_count: INTEGER
			i: INTEGER
		do
			l_arg_count := feature_.argument_count
			l_result_index := l_arg_count + 1
			create Result.make (64)
			if is_creation then
				Result.append (once "create ")
			elseif not feature_.type.is_void then
				Result.append (variable_name (result_variable, a_variable_display_type))
				Result.append (once " := ")
			end
			Result.append (variable_name (target_variable, a_variable_display_type))
			Result.append_character ('.')
			Result.append (feature_.feature_name.as_lower)
			if l_arg_count > 0 then
				Result.append (once " (")
				from
					i := 1
				until
					i > l_arg_count
				loop
					Result.append (variable_name (reversed_variable_position.item (i), a_variable_display_type))
					if i < l_arg_count then
						Result.append (once ", ")
					end
					i := i + 1
				end
				Result.append_character (')')
			end
		end

	content_of_transition: STRING
			-- Content of current transition
		do
			Result := content_of_transition_internal (variable_position_name)
		end

	target_variable: EPA_EXPRESSION
			-- Variable in `variables' for target of the feature call
		do
			Result := reversed_variable_position.item (0)
		end

	result_variable: EPA_EXPRESSION
			-- Variable in `variables' for result of the feature call, if any
		require
			feature_is_query: not feature_.type.is_void
		do
			Result := reversed_variable_position.item (feature_.argument_count + 1)
		end

feature{NONE} -- Implementation

	key_to_hash: DS_LINEAR [INTEGER_32]
			-- <Precursor>
		local
			l_list: DS_ARRAYED_LIST[INTEGER_32]
		do
			create l_list.make (4)
			l_list.force_last (class_.hash_code)
			l_list.force_last (feature_.feature_name_id)

			-- FIXME: Make EPA_STATE hashable.
--			l_list.force_last (precondition.hash_code)
--			l_list.force_last ((postcondition.hash_code)
		end

	initialize (a_operands: HASH_TABLE [STRING, INTEGER])
			-- Initialize Current with `a_variables' and `a_operands'.
			-- `a_operands' is a table for operands of `a_feature', including possible result, if any.
			-- Key is 0-based operand index (0 means target, 1 means the first argument, and so on),
			-- value is the operand name at that index.
			-- All operand names should be in `context'.`variables'.			
		local
			l_cursor: CURSOR
			l_index: INTEGER
			l_expr: EPA_EXPRESSION
			l_is_query: BOOLEAN
			l_env_feat: FEATURE_I
			l_env_class: CLASS_C
			l_context: like context
			l_operand_count: INTEGER
			l_operand_set: DS_HASH_SET [EPA_EXPRESSION]
			l_intermediate_vars: DS_HASH_SET [EPA_EXPRESSION]
			l_variables: HASH_TABLE [TYPE_A, STRING]
		do
			l_context := context
			l_env_feat := l_context.feature_
			l_env_class := l_context.class_
			l_operand_count := operand_count_of_feature (feature_)
			l_is_query := feature_.has_return_value

			initialize_tables
			create l_operand_set.make (a_operands.count)
			l_operand_set.set_equality_tester (expression_equality_tester)

				-- Put operands into `variables', `inputs' and `outputs'.
			l_cursor := a_operands.cursor
			from
				a_operands.start
			until
				a_operands.after
			loop
				l_expr := variable_expression_from_context (a_operands.item_for_iteration, l_context)
				l_operand_set.force_last (l_expr)
				extend_variable (l_expr, a_operands.key_for_iteration)
				if (l_index = 0 implies not is_creation) and then not (l_index = l_operand_count and then l_is_query) then
					inputs.force_last (l_expr)
				end
				outputs.force_last (l_expr)
				l_index := l_index + 1
				a_operands.forth
			end
			a_operands.go_to (l_cursor)

				-- Initialize intermediate variables.
			l_variables := l_context.variables
			l_cursor := l_variables.cursor
			from
				l_index := l_operand_set.count
				l_variables.start
			until
				l_variables.after
			loop
				l_expr := variable_expression_from_context (l_variables.key_for_iteration, l_context)
				if not l_operand_set.has (l_expr) then
					extend_variable (l_expr, l_index)
					l_index := l_index + 1
				end
				l_variables.forth
			end
			l_variables.go_to (l_cursor)

				-- Initialize `content'.
			content := content_of_transition

				-- Initialize `name' and `description'.
			set_name (class_.name_in_upper + once "." + feature_.feature_name.as_lower)
			set_description (feature_header_comment (feature_))
		end

	rewritten_contracts (a_assertions: DS_HASH_SET [EPA_EXPRESSION]; a_precondition: BOOLEAN): EPA_STATE
			-- A state containing assertions from `a_assertions', but rewritten in `context'
			-- `a_precondition' indicates if `a_assertions' are from preconditions.
		local
			l_rewriter: EPA_CONTRACT_REWRITE_VISITOR
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_target_prefix: STRING
			l_arg_tbl: HASH_TABLE [STRING, INTEGER]
			l_context: like context
			l_context_class: CLASS_C
			l_context_feature: FEATURE_I
		do
			l_context := context
			l_context_class := l_context.class_
			l_context_feature := l_context.feature_
			create Result.make (a_assertions.count, l_context_class, l_context_feature)

				-- Prepare arguments to `rewrite'.				
			l_arg_tbl := variable_position_name_map
			l_target_prefix := reversed_variable_position.item (0).text

				-- Rewrite `a_assertions' in `context'.
			create l_rewriter
			from
				l_cursor := a_assertions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_rewriter.rewrite (l_cursor.item.ast, feature_, l_cursor.item.written_class, class_, l_target_prefix, l_arg_tbl)
				if attached {EPA_EXPRESSION} expression_from_text (l_rewriter.assertion.twin, l_context) as l_expr then
					Result.force_last (create {EPA_EQUATION}.make (l_expr, create {EPA_BOOLEAN_VALUE}.make (True)))
				end
				l_cursor.forth
			end
		end

end
