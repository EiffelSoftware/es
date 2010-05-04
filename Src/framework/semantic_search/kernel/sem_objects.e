note
	description: "Class that represents a set of objects along with their properties, which can be queried"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_OBJECTS

inherit
	SEM_QUERYABLE

create
	make

feature{NONE} -- Initialization

	make (a_context: EPA_CONTEXT; a_variable_positions: HASH_TABLE [INTEGER, STRING])
			-- Initialize `context' with `a_context'.
			-- `a_variable_positions' is a table defining the position of each variable in `a_context'.`variables'.
			-- Key of the table is variable name, value is the 0-based position of that variables.
		require
			a_variable_positions_valid: is_variable_position_table_valid (a_variable_positions, a_context)
		local
			l_variables: HASH_TABLE [TYPE_A, STRING]
			l_cursor: CURSOR
			l_expr: EPA_EXPRESSION
			l_variable_count: INTEGER
		do
			context := a_context
			create properties.make (20, context.class_, context.feature_)

			l_variables := context.variables
			l_variable_count := l_variables.count
			create variables.make (l_variable_count)
			variables.set_equality_tester (expression_equality_tester)

			create variable_positions.make (l_variable_count)

			create reversed_variable_position.make (l_variable_count)
			reversed_variable_position.set_equality_tester (expression_equality_tester)

				-- Initialize variables in `a_context' into `variables'.

			l_cursor := l_variables.cursor
			from
				l_variables.start
			until
				l_variables.after
			loop
				l_expr := variable_expression_from_context (l_variables.key_for_iteration, a_context)
				extend_variable (l_expr, a_variable_positions.item (l_variables.key_for_iteration))
				l_variables.forth
			end
			l_variables.go_to (l_cursor)
		ensure
			context_set: context = a_context
		end

feature -- Access

	properties: EPA_STATE
			-- Set of properties among `variables' that can be queries		

feature -- Setting

	set_properties (a_properties: like properties)
			-- Adapt `a_properties' into `properties'.
			-- Adaption means possible context transformation.
		do
			set_state (a_properties, properties)
		end


feature -- Visitor

	process (a_visitor: SEM_QUERYABLE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_objects (Current)
		end

end
