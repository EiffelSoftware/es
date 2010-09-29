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
	make,
	make_with_serialization

feature{NONE} -- Initialization

	make (a_context: EPA_CONTEXT; a_variables: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION])
			-- Initialize Current with `a_variables' in `a_context'.
			-- `a_variables' is a table, key is variable names, values is the index of those variables.
		require
			a_variables_valid:
				a_variables.for_all_with_key (
					agent (a_index: INTEGER; a_var: EPA_EXPRESSION; a_ctxt: EPA_CONTEXT): BOOLEAN
						do Result := a_ctxt.has_variable_named (a_var.text) end (?, ?, a_context))
		local
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, EPA_EXPRESSION]
		do
			is_serialization_available := False
			initialize_with_context (a_context)

			from
				l_cursor := a_variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				extend_variable (l_cursor.key, l_cursor.item)
				l_cursor.forth
			end
		end

	make_with_serialization (a_context: EPA_CONTEXT; a_serializatoin: like serialization)
			-- Initialize `context' with `a_context'.
			-- Key of the table is variable name, value is the position of that variables.
			-- `a_serialization' is the serialized data for all objects in `a_context'.`variables'. 			
			-- During initialization, serialize `a_serialization' to setup `objects'.
			-- The serialized data should be of type SPECIAL [detachable ANY], the format is:
			-- [object1_index, object1, object2_index, object2, ... , objectn_index, objectn]
		local
--			l_variables: HASH_TABLE [TYPE_A, STRING]
			l_expr: EPA_EXPRESSION
--			l_variable_count: INTEGER
			l_obj_table: HASH_TABLE [detachable ANY, INTEGER]
			l_objects: like objects
			l_obj_index: INTEGER
			l_obj_name: STRING
		do
			initialize_with_context (a_context)

			serialization := a_serializatoin
--			l_variable_count := l_variables.count

				-- Initialize variables in `a_context' into `variables'.
			l_obj_table := deserialized_variable_table (a_serializatoin)
			create objects_internal.make (l_obj_table.count // 2)
			objects_internal.compare_objects
			l_objects := objects_internal

			from
				l_obj_table.start
			until
				l_obj_table.after
			loop
				l_obj_index := l_obj_table.key_for_iteration
				l_obj_name := once "v_" + l_obj_index.out
				l_expr := variable_expression_from_context (l_obj_name, a_context)
				l_objects.put (l_obj_table.item_for_iteration, l_obj_name)
				extend_variable (l_expr, l_obj_index)
				l_obj_table.forth
			end
			is_serialization_available := True
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

	objects: HASH_TABLE [detachable ANY, STRING]
			-- Objects deserialized from `serialization'
			-- Key is object name, value is the object itself.
		require
			is_serialization_available
		do
			Result := objects_internal
		end

	boosts: DS_HASH_TABLE [DOUBLE, EPA_EQUATION]
			-- Boost values for equations in `properties'
			-- Key is an equation in `properties', value is the boost number associated with that equation.
			-- The boost numbers will be used as boost values for a field (in Lucene sense).

	serialization_as_string: STRING
			-- String representation for `serialization
			-- Format: comma separated ascii code for every natural_8 in `serialization.
		require
			is_serialization_available
		do
			Result := array_as_string (serialization)
		end

feature -- Type status report

	is_objects: BOOLEAN = True
			-- Is Current an object set queryable?

	is_serialization_available: BOOLEAN
			-- Is `serialization' available?
			-- If so, `objects' are also available

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

feature{NONE} -- Implementation

	objects_internal: like objects
			-- Cache for `objects'

	initialize_with_context (a_context: EPA_CONTEXT)
			-- Initialize.
		do
			context := a_context
			context_type := context.class_.actual_type
			create properties.make (20, context.class_, context.feature_)
			create boosts.make (20)
			boosts.set_key_equality_tester (equation_equality_tester)

			create variables.make (20)
			variables.set_equality_tester (expression_equality_tester)
			create variable_positions.make (20)
			create reversed_variable_position.make (20)
		end

invariant
	boosts_valid: boosts.keys.for_all (agent properties.has)
	boosts_key_equality_tester_valid: boosts.key_equality_tester = equation_equality_tester

end
