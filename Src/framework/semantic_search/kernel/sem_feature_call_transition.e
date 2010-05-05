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
			is_creation := a_is_creation
			create precondition.make (20, context.class_, context.feature_)
			create postcondition.make (20, context.class_, context.feature_)
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

	description: STRING
			-- Description of current transition

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
			l_operand_count: INTEGER
			l_is_query: BOOLEAN
			l_env_feat: FEATURE_I
			l_env_class: CLASS_C
			l_context: like context
		do
			l_context := context
			l_env_feat := l_context.feature_
			l_env_class := l_context.class_
			l_operand_count := operand_count_of_feature (feature_)
			l_is_query := feature_.has_return_value

			create variables.make (l_operand_count)
			variables.set_equality_tester (expression_equality_tester)

			create variable_positions.make (l_operand_count)

			create reversed_variable_position.make (l_operand_count)
			reversed_variable_position.set_equality_tester (expression_equality_tester)

			create inputs.make (l_operand_count)
			inputs.set_equality_tester (expression_equality_tester)

			create outputs.make (l_operand_count)
			outputs.set_equality_tester (expression_equality_tester)

				-- Put operands into `variables', `inputs' and `outputs'.
			l_cursor := a_operands.cursor
			from
				a_operands.start
			until
				a_operands.after
			loop
				l_expr := variable_expression_from_context (a_operands.item_for_iteration, l_context)
				extend_variable (l_expr, a_operands.key_for_iteration)
				if (l_index = 0 implies not is_creation) and then not (l_index = l_operand_count and then l_is_query) then
					inputs.force_last (l_expr)
				end
				outputs.force_last (l_expr)
				l_index := l_index + 1
				a_operands.forth
			end
			a_operands.go_to (l_cursor)

				-- Initialize `content'.
			content := content_of_transition

				-- Initialize `name' and `description'.
			name :=  class_.name_in_upper + once "." + feature_.feature_name.as_lower
			description := feature_header_comment (feature_)
		end

end
