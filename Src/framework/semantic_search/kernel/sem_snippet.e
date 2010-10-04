note
	description: "Class representing a snippet, that is an arbitrary piece of code, starting from precondition, reaching postcondition"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_SNIPPET

inherit
	SEM_TRANSITION
		redefine
			is_snippet
		end

create
	make,
	make_with_transition

feature{NONE} -- Initialization

	make (a_context: EPA_CONTEXT; a_variable_positions: HASH_TABLE [INTEGER, STRING]; a_inputs: DS_HASH_SET [STRING]; a_outputs: DS_HASH_SET [STRING]; a_content: like content)
			-- Initialize `context' with `a_context'.
			-- `a_variable_positions' is a table defining the position of each variable in `a_context'.`variables'.
			-- Key of the table is variable name, value is the 0-based position of that variables.
			-- `a_inputs' specifies the names of the variables in `a_context'.`variables' which are used as inputs of current snippet.
			-- `a_outputs' specifies the names of the variables in `a_context'.`variables' which are used as outputs of current snippet.
			-- `a_content' is the content of current snippet, all the variables inside it must be normalized, for example {0}.extend ({1}).
		require
			a_variable_positions_valid: is_variable_position_table_valid (a_variable_positions, a_context)
			a_inputs_valid: a_inputs.for_all (agent (a_context.variables).has)
			a_outputs_valid: a_outputs.for_all (agent (a_context.variables).has)
		local
			l_cursor: CURSOR
			l_index: INTEGER
			l_expr: EPA_EXPRESSION
			l_operand_count: INTEGER
			l_context: like context
			l_variables: HASH_TABLE [TYPE_A, STRING]
			l_variable_name: STRING
			l_inputs: like inputs
			l_outputs: like outputs
		do
			context := a_context
			context_type := context.class_.actual_type
			create preconditions.make (20, context.class_, context.feature_)
			create postconditions.make (20, context.class_, context.feature_)
			initialize_tables

			l_inputs := inputs
			l_outputs := outputs

				-- Initialize `variables'.
			l_variables := context.variables
			l_cursor := l_variables.cursor
			from
				l_variables.start
			until
				l_variables.after
			loop
				l_variable_name := l_variables.key_for_iteration
				l_expr := variable_expression_from_context (l_variable_name, a_context)
				extend_variable (l_expr, a_variable_positions.item (l_variable_name))
				if a_inputs.has (l_variable_name) then
					l_inputs.force_last (l_expr)
				end
				if a_outputs.has (l_variable_name) then
					l_outputs.force_last (l_expr)
				end
				l_variables.forth
			end
			l_variables.go_to (l_cursor)

				-- Initialize `content'.
			content := a_content.twin

				-- Initialize `name' and `description'.
			set_name ("")
			set_description ("")
		end

	make_with_transition (a_transition: like Current)
			-- Intialize Current by copying data from `a_transition'.
		do
			make (
				a_transition.context,
				a_transition.variable_name_positions,
				string_set_from_expression_set (a_transition.inputs),
				string_set_from_expression_set (a_transition.outputs),
				a_transition.content)

			preconditions := a_transition.preconditions.cloned_object
			postconditions := a_transition.postconditions.cloned_object
			set_name (a_transition.name)
			set_uuid (a_transition.uuid)
			set_description (a_transition.description)
		end

feature -- Access

	content: STRING
			-- String representing the content of Current transition
			-- Can be a piece of code, should be in a form where all variable names are
			-- normalized, for example:
			-- {1}.extend ({2})
			-- {1} and {2} represent the first and second variable, respectively.

	cloned_object: like Current
			-- Clonded object
		do
			create Result.make_with_transition (Current)
		end

	as_interface_transition: like Current
			-- Interface transition of Current
			-- Make a copy of current.
		do
			Result := cloned_object
		end

feature -- Type status report

	is_snippet: BOOLEAN = True
			-- Is Current a snippet queryable?

feature -- Visitor

	process (a_visitor: SEM_QUERYABLE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_snippet (Current)
		end

feature{SEM_SNIPPET} -- Implementation

	string_set_from_expression_set (a_expr_set: DS_HASH_SET [EPA_EXPRESSION]): DS_HASH_SET [STRING]
			-- String set from `a_expr_set'
		do
			create Result.make (a_expr_set.count)
			Result.set_equality_tester (string_equality_tester)
			a_expr_set.do_all (
				agent (a_expr: EPA_EXPRESSION; a_set: DS_HASH_SET [STRING])
					do
						a_set.force_last (a_expr.text)
					end (?, Result))
		end

end
