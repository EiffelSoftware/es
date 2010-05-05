note
	description: "Class that represents a set of objects along with their properties, which can be queried"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_OBJECTS

inherit
	SEM_QUERYABLE
		redefine
			is_objects
		end

	EQA_TEST_CASE_SERIALIZATION_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_context: EPA_CONTEXT; a_variable_positions: HASH_TABLE [INTEGER, STRING]; a_serializatoin: like serialization)
			-- Initialize `context' with `a_context'.
			-- `a_variable_positions' is a table defining the position of each variable in `a_context'.`variables'.
			-- Key of the table is variable name, value is the position of that variables.
			-- `a_serialization' is the serialized data for all objects in `a_context'.`variables'. 			
			-- The serialized data should be of type SPECIAL [TUPLE [index: INTEGER; object: detachable ANY]].
			-- `index' of a tuple is the position of that variable,
			-- `object' of the tuple is the serialized data (the data should be serialized by `independent_store' so the data can be deserialized by
			-- another application, even in a different platform) for that object.

		require
			a_variable_positions_valid: is_variable_position_table_valid (a_variable_positions, a_context)
		local
			l_variables: HASH_TABLE [TYPE_A, STRING]
			l_cursor: CURSOR
			l_expr: EPA_EXPRESSION
			l_variable_count: INTEGER
		do
			context := a_context
			serialization := a_serializatoin
			create properties.make (20, context.class_, context.feature_)

			create boosts.make (20)
			boosts.set_key_equality_tester (equation_equality_tester)

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

	serialization: ARRAY [NATURAL_8]
			-- Serialized data for all objects in `a_context'.`variables'.
			-- The serialized data should be of type SPECIAL [TUPLE [index: INTEGER; object: detachable ANY]].
			-- `index' of a tuple is the position of that variable,
			-- `object' of the tuple is the serialized data (the data should be serialized by `independent_store' so the data can be deserialized by
			-- another application, even in a different platform) for that object.

	objects: detachable HASH_TABLE [detachable ANY, INTEGER]
			-- Objects deserialized from `serialization'
			-- Key is object position, value is the object itself.
			-- Return Void if deserialization failed.
		do
			Result := deserialized_variable_table (serialization)
		end

	boosts: DS_HASH_TABLE [DOUBLE, EPA_EQUATION]
			-- Boost values for equations in `properties'
			-- Key is an equation in `properties', value is the boost number associated with that equation.
			-- The boost numbers will be used as boost values for a field (in Lucene sense).

feature -- Type status report

	is_objects: BOOLEAN = True
			-- Is Current an object set queryable?

feature -- Setting

	set_properties (a_properties: like properties)
			-- Adapt `a_properties' into `properties'.
			-- Adaption means possible context transformation.
		do
			set_state (a_properties, properties)
		end

	set_boosts (a_boosts: like boosts)
			-- Set `boosts' with `a_boosts'.
		do
			boosts := a_boosts.cloned_object
		end

feature -- Visitor

	process (a_visitor: SEM_QUERYABLE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_objects (Current)
		end

invariant
	boosts_valid: boosts.keys.for_all (agent properties.has)
	boosts_key_equality_tester_valid: boosts.key_equality_tester = equation_equality_tester

end
