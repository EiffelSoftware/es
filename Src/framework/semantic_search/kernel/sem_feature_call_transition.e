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

	SEM_SHARED_EQUALITY_TESTER

create
	make,
	make_with_context_type,
	make_with_transition,
	make_interface_transition

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
			create preconditions.make (20, context.class_, context.feature_)
			create postconditions.make (20, context.class_, context.feature_)
			create written_preconditions.make (5, context.class_, context.feature_)
			create written_postconditions.make (5, context.class_, context.feature_)
			create hit_breakpoints.make (20)
			initialize (a_operands)
		end

	make_with_context_type (a_class: like class_; a_feature: like feature_;  a_operands: HASH_TABLE [STRING, INTEGER]; a_context: like context; a_is_creation: BOOLEAN; a_context_type: like context_type)
			-- Initialize Current as the transition of `a_feature' in `a_class'.
			-- `a_operands' is a table indicating the operands for current transition.
			-- Key of `a_operands' are 0-based operand (including result, if any) indexes,
			-- 0 means target, 1 means the first argument, and so on,
			-- value of `a_operands' is the name of that operands.
			-- All the variables in `a_operands' should also be defined in `a_context'.
		require
			operand_count_valid: operand_count_of_feature (a_feature) = a_operands.count
		do
			make (a_class, a_feature, a_operands, a_context,a_is_creation)
			context_type := a_context_type
		end

	make_with_transition (a_transition: like Current)
			-- Initialize Current by copying data from `a_transition'.
		do
			make (a_transition.class_, a_transition.feature_, a_transition.operand_map, a_transition.context, a_transition.is_creation)
			set_description (a_transition.description)
			set_uuid (a_transition.uuid)
			set_name (a_transition.name)
			preconditions := a_transition.preconditions.cloned_object
			postconditions := a_transition.postconditions.cloned_object
			written_preconditions := a_transition.written_preconditions.cloned_object
			written_postconditions := a_transition.written_postconditions.cloned_object
			changes := a_transition.changes.cloned_object
			hit_breakpoints := a_transition.hit_breakpoints.cloned_object
			set_is_passing (a_transition.is_passing)
			interface_variable_positions := a_transition.interface_variable_positions.cloned_object
		end

	make_interface_transition (a_transition: like Current)
			-- Initialize Current by copying ONLY interface related data from `a_transition'.
		local
			l_assertions: like preconditions
			l_chg_cursor: like changes.new_cursor
			l_postconditions, l_written_postconditions: like postconditions
			l_expr: EPA_EXPRESSION
			l_changes: like changes
		do
			make (a_transition.class_, a_transition.feature_, a_transition.operand_map, a_transition.context, a_transition.is_creation)
			set_description (a_transition.description)
			set_uuid (a_transition.uuid)
			set_name (a_transition.name)
			set_is_passing (a_transition.is_passing)
			preconditions := a_transition.interface_preconditions
			postconditions := a_transition.interface_postconditions
			written_preconditions := a_transition.written_preconditions.cloned_object
			written_postconditions := a_transition.written_postconditions.cloned_object
			interface_variable_positions := a_transition.interface_variable_positions.cloned_object
			hit_breakpoints := a_transition.hit_breakpoints.cloned_object
				-- Initialize interface changes.
			from
				l_postconditions := postconditions
				l_written_postconditions := written_postconditions
				l_changes := changes
				l_chg_cursor := a_transition.changes.new_cursor
				l_chg_cursor.start
			until
				l_chg_cursor.after
			loop
				l_expr := l_chg_cursor.key
				if l_postconditions.has_expression (l_expr) or l_written_postconditions.has_expression (l_expr) then
					l_changes.force_last (l_chg_cursor.item, l_expr)
				end
				l_chg_cursor.forth
			end
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
			l_cursor: like variable_positions.new_cursor
		do
				-- Initialize variable position table `l_positions'.
			create l_positions.make (variable_positions.count)
			l_positions.compare_objects
			from
				l_cursor := variable_positions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_positions.put (l_cursor.item, l_cursor.key.text)
				l_cursor.forth
			end

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
			Result.set_preconditions (preconditions)
			Result.set_postconditions (postconditions)
		end

	cloned_object: like Current
			-- Clonded object
		do
			create Result.make_with_transition (Current)
		end

	operand_map: HASH_TABLE [STRING, INTEGER]
			-- Map from 0-based operand index of `feature_' to the name
			-- of the variable associated with that operand
		local
			l_reversed: like reversed_variable_position
			l_opd_index: INTEGER
		do
			l_reversed := reversed_variable_position

			create Result.make (operand_count_of_feature (feature_))
			across operand_index_set (feature_, l_reversed.has (0), True) as l_indexes loop
				l_opd_index := l_indexes.item
				Result.put (l_reversed.item (l_opd_index).text, l_opd_index)
			end
		end

	operand_variable_positions: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
			-- Table from operand variables to their 0-based operand index
			-- Key is variables which are also operands, value is the 0-based operand index for that variable
			-- Variables which are not operands are not included in the resulting table.
		local
			l_positions: like variable_positions
			l_cursor: like variables.new_cursor
			l_position: INTEGER
			l_operand_map: like operand_map
		do
			create Result.make (variables.count)
			Result.set_key_equality_tester (expression_equality_tester)

			l_positions := variable_positions
			l_operand_map := operand_map
			from
				l_cursor := variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_position := l_positions.item (l_cursor.item)
				l_operand_map.search (l_position)
				if l_operand_map.found then
					Result.force_last (l_position, l_cursor.item)
				end
				l_cursor.forth
			end
		end

	as_interface_transition: like Current
			-- Interface transition of Current
			-- Make a copy of current.
		do
			create Result.make_interface_transition (Current)
		end

	all_equations: DS_HASH_SET [SEM_EQUATION]
			-- Equations including `preconditions', `postconditions', `written_preconditions' and
			-- `written_postconditions'.
			-- Note: create a new result set every time, may be slow.
		do
			create Result.make (preconditions.count + postconditions.count + written_preconditions.count + written_postconditions.count)
			Result.set_equality_tester (sem_equation_equality_tester)

			preconditions.do_all (agent extend_equation_into_hash_set (?, True, False, Result))
			postconditions.do_all (agent extend_equation_into_hash_set (?, False, False, Result))
			written_preconditions.do_all (agent extend_equation_into_hash_set (?, True, True, Result))
			written_postconditions.do_all (agent extend_equation_into_hash_set (?, False, True, Result))
		end

	interface_equations: DS_HASH_SET [SEM_EQUATION]
			-- Equations including `interface_preconditions', `interface_postconditions', `written_preconditions' and
			-- `written_postconditions'.
			-- Note: create a new result set every time, may be slow.
		do
			create Result.make (preconditions.count + postconditions.count + written_preconditions.count + written_postconditions.count)
			Result.set_equality_tester (sem_equation_equality_tester)

			interface_preconditions.do_all (agent extend_equation_into_hash_set (?, True, False, Result))
			interface_postconditions.do_all (agent extend_equation_into_hash_set (?, False, False, Result))
			written_preconditions.do_all (agent extend_equation_into_hash_set (?, True, True, Result))
			written_postconditions.do_all (agent extend_equation_into_hash_set (?, False, True, Result))
		end

	all_precondition_equations: DS_HASH_SEt [SEM_EQUATION]
			-- Equations including `preconditions' and `written_preconditions'.
			-- Note: create a new result set every time, may be slow.
		do
			create Result.make (preconditions.count + written_preconditions.count)
			Result.set_equality_tester (sem_equation_equality_tester)

			preconditions.do_all (agent extend_equation_into_hash_set (?, True, False, Result))
			written_preconditions.do_all (agent extend_equation_into_hash_set (?, True, True, Result))
		end

	variable_static_type_table: HASH_TABLE [TYPE_A, STRING]
			-- Table from variable name from `variables' to their dynamic type from `a_feature_transition'
			-- Key of Result is variable name, value is the resolved static type of that variable.
			-- Static type only makes sense for variables which are also operands, for other variables,
			-- dyanmic types are used.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_context_type: detachable TYPE_A
			l_operand_types: like operand_types_with_feature
			l_positions: like variable_positions
			l_variable: EPA_EXPRESSION
			l_operand_map: like operand_map
			l_operand_pos_map: like operand_variable_positions
			l_position: INTEGER
			l_type: TYPE_A
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			if variable_static_type_table_internal = Void then
				l_class := class_
				l_feature := feature_
				l_context_type := context_type
				l_operand_types := resolved_operand_types_with_feature (l_feature, l_class, l_context_type)
				l_context_type := context_type
				l_positions := variable_positions
				l_operand_pos_map := operand_variable_positions

				create variable_static_type_table_internal.make (variables.count)
				variable_static_type_table_internal.compare_objects
				from
					l_cursor := variables.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_variable := l_cursor.item
					l_operand_pos_map.search (l_variable)
					if l_operand_pos_map.found then
						l_position := l_operand_pos_map.found_item
							-- This is an operand variable, static type is used.
						l_type := l_operand_types.item (l_position)
					else
							-- This is not an operand variable, dynamic type is used.
						l_type := l_variable.resolved_type (l_context_type)
					end
					variable_static_type_table_internal.force (l_type, l_variable.text)
					l_cursor.forth
				end
			end
			Result := variable_static_type_table_internal
		end

	dynamic_type_name_table: HASH_TABLE [STRING, STRING]
			-- Table from variable names to their dynamic type
		do
			if dynamic_type_name_table_internal = Void then
				dynamic_type_name_table_internal := type_name_table (variable_dynamic_type_table)
			end
			Result := dynamic_type_name_table_internal
		end

	static_type_name_table: HASH_TABLE [STRING, STRING]
			-- Table from variable names to their static type
		do
			if static_type_name_table_internal = Void then
				static_type_name_table_internal := type_name_table (variable_static_type_table)
			end
			Result := static_type_name_table_internal
		end

	text_in_static_type_form (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' in static type form			
			-- Note: `a_expression' must only mention operands.
		do
			Result := expression_with_replacements (a_expression, static_type_name_table, True)
		end

	text_in_dynamic_type_form (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' in static type form
			-- Note: `a_expression' must only mention operands.
		do
			Result := expression_with_replacements (a_expression, dynamic_type_name_table, True)
		end

	text_in_anonymous_type_form (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' in static type form
			-- Note: `a_expression' must only mention operands.
		do
			Result := anonymous_expression_text (a_expression)
		end

	static_type_of_variable (a_variable: EPA_EXPRESSION): TYPE_A
			-- Static type of `a_variable'
		do
			Result := variable_static_type_table.item (a_variable.text)
		end

	argument_count: INTEGER
			-- Number of arguments in `feature_'
		do
			Result := feature_.argument_count
		end

	operand_count: INTEGER
			-- Number of operands (target + argument) in `feature_'
		do
			Result := argument_count + 1
		end

	interface_variable_count: INTEGER
			-- Number of interface variable count (target + argument + result) in `feature_'
		do
			Result := operand_count
			if is_query then
				Result := Result +  1
			end
		end

	hit_breakpoints: DS_HASH_SET [INTEGER]
			-- List of breakpoints that are hit during the execution of Current transition

feature -- Status report

	is_creation: BOOLEAN
			-- Is current transition a creation?

	is_passing: BOOLEAN
			-- Is current transition from a passing test case?

	is_feature_call: BOOLEAN = True
			-- Is Current a feature call queryable?

	is_query: BOOLEAN
			-- Is `feature_' a query?
		do
			Result := feature_.has_return_value
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := content_of_transition_internal (variable_type_name)
		end

feature -- Setting

	set_is_passing (b: BOOLEAN)
			-- Set `is_passing' with `b'.
		do
			is_passing := b
		ensure
			is_passing_set: is_passing = b
		end

feature -- Visitor

	process (a_visitor: SEM_QUERYABLE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_feature_call (Current)
		end

feature -- Basic operations

	add_written_precondition
			-- Add precondition written in `feature_' into `preconditions'.
		local
			l_state: EPA_STATE
		do
			l_state := rewritten_contracts (contract_extractor.precondition_expression_set (class_, feature_), True)
			adapt_state (l_state, preconditions)
			adapt_state (l_state, written_preconditions)
		end

	add_written_postcondition
			-- Add postcondition written in `feature_' into `postconditions'.
		local
			l_state: EPA_STATE
		do
			l_state := rewritten_contracts (contract_extractor.postcondition_expression_set  (class_, feature_), False)
			adapt_state (l_state, postconditions)
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

			create changes.make (10)
			changes.set_key_equality_tester (expression_equality_tester)

			create interface_variable_positions.make (variables.count)
			interface_variable_positions.set_key_equality_tester (expression_equality_tester)
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

	dynamic_type_name_table_internal: detachable like dynamic_type_name_table
			-- Cache for `dynamic_type_name_table'

	static_type_name_table_internal: detachable like static_type_name_table
			-- Cache for `static_type_name_table'

	variable_static_type_table_internal: detachable like variable_static_type_table
			-- Cache of `variable_static_type_table'			


end
