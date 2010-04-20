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
			description
		end

	EPA_UTILITY

create
	make

feature{SEM_TRANSITION_FACTORY} -- Initialization

	make (a_context_class: like context_class; a_feature: like feature_; a_env_class: like environment_class; a_env_feature: like environment_feature; a_variables: HASH_TABLE [TYPE_A, STRING]; a_operands: HASH_TABLE [INTEGER, STRING]; a_creation: BOOLEAN)
			-- Initialize Curren
			-- `a_variables' are the set of variables in the transition, key is variable name,
			-- value is type of that variable.
			-- `a_operands' is a table for operands of `a_feature', including possible result, if any.
			-- Key is 0-based operand index (0 means target, 1 means the first argument, and so on),
			-- value is the operand name at that index.
			-- `a_creation' indicates if `a_feature' is used as a creation procedure.
		do
			context_class := a_context_class
			feature_ := a_feature
			environment_class := a_env_class
			environment_feature := a_env_feature
			create precondition.make (20, environment_class, environment_feature)
			create postcondition.make (20, environment_class, environment_feature)
			initialize (a_variables, a_operands)
		end

feature -- Access

	feature_: FEATURE_I
			-- Feature which is modeled by current transition.

	context_class: CLASS_C
			-- Class from which `feature_' is viewed.

	environment_feature: FEATURE_I
			-- Feature associated with current transition

	environment_class: CLASS_C
			-- Context class from which `environment_feature' is viewed

	content: STRING
			-- <Precursor>

	description: STRING
			-- Context of current transition

feature -- Status report

	is_creation: BOOLEAN
			-- Is current transition a creation?

feature{NONE} -- Implementation

	content_of_transition: STRING
			-- Content of current transition
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
				Result.append (result_variable.text)
				Result.append (once " := ")
			end
			Result.append (target_variable.text)
			Result.append_character ('.')
			Result.append (feature_.feature_name.as_lower)
			if l_arg_count > 0 then
				Result.append (once " (")
				from
					i := 1
				until
					i <= l_arg_count
				loop
					Result.append (reversed_variable_position.item (i).text)
					if i < l_arg_count then
						Result.append (once ", ")
					end
					i := i + 1
				end
				Result.append_character (')')
			end
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

	initialize (a_variables: HASH_TABLE [TYPE_A, STRING]; a_operands: HASH_TABLE [INTEGER, STRING])
			-- Initialize Current with `a_variables' and `a_operands'.
			-- `a_variables' are the set of variables in the transition, key is variable name,
			-- value is type of that variable.
			-- `a_operands' is a table for operands of `a_feature', including possible result, if any.
			-- Key is 0-based operand index (0 means target, 1 means the first argument, and so on),
			-- value is the operand name at that index.
		local
			l_cursor: CURSOR
			l_index: INTEGER
			l_expr: EPA_AST_EXPRESSION
			l_operand_count: INTEGER
			l_is_query: BOOLEAN
		do
			l_operand_count := feature_.argument_count + 1
			if not feature_.type.is_void then
				l_operand_count := l_operand_count + 1
				l_is_query := True
			end
			create variables.make (a_variables.count)
			create variable_positions.make (a_variables.count)
			create reversed_variable_position.make (a_variables.count)
			create inputs.make (a_operands.count)
			create outputs.make (a_operands.count)

				-- Put operands into `variables', `inputs' and `outputs'.
			l_cursor := a_operands.cursor
			from
				a_operands.start
			until
				a_operands.after
			loop
				create l_expr.make_with_text (environment_class, environment_feature, a_operands.key_for_iteration, environment_class)
				extend_variable (l_expr, a_operands.item_for_iteration)
				if (l_index = 0 implies not is_creation) and then not (l_index = l_operand_count and then l_is_query) then
					inputs.force_last (l_expr)
				end
				outputs.force_last (l_expr)
				l_index := l_index + 1
				a_operands.forth
			end
			a_operands.go_to (l_cursor)

				-- Put `a_variables' in `variables'.
			l_cursor := a_variables.cursor
			from
				a_variables.start
			until
				a_variables.after
			loop
				create l_expr.make_with_text (environment_class, environment_feature, a_variables.key_for_iteration, environment_class)
				if not variables.has (l_expr) then
					extend_variable (l_expr, l_index)
					l_index := l_index + 1
				end
				a_variables.forth
			end
			a_variables.go_to (l_cursor)

				-- Initialize `content'.
			content := content_of_transition

				-- Initialize `description'.
			description :=  context_class.name_in_upper + once "__" + feature_.feature_name.as_lower
		end

end
