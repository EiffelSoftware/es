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
			initialize_with_context (a_context)
			create objects_internal.make (a_variables.count)
			objects_internal.set_key_equality_tester (expression_equality_tester)

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

	make_with_serialization (a_context: EPA_CONTEXT; a_serializatoin: like serialization_as_array)
			-- Initialize `context' with `a_context'.
			-- Key of the table is variable name, value is the position of that variables.
			-- `a_serialization' is the serialized data for all objects in `a_context'.`variables'. 			
			-- During initialization, serialize `a_serialization' to setup `objects'.
			-- The serialized data should be of type SPECIAL [detachable ANY], the format is:
			-- [object1_index, object1, object2_index, object2, ... , objectn_index, objectn]
			-- The variable names in `a_context'.`variables' should start with "v_" and the
			-- integers that follow should be consistent with the object indexes inside `a_serialization'.
		local
			l_expr: EPA_EXPRESSION
			l_obj_table: HASH_TABLE [detachable ANY, INTEGER]
			l_objects: like objects
			l_obj_index: INTEGER
			l_obj_name: STRING
			l_name_prefix: STRING
		do
			initialize_with_context (a_context)

			serialization_internal := a_serializatoin
				-- Initialize variables in `a_context' into `variables'.
			l_obj_table := deserialized_variable_table (a_serializatoin)

				-- Iterate through all objects in `a_serialization'.
			from
				create objects_internal.make (l_obj_table.count // 2)
				objects_internal.set_key_equality_tester (expression_equality_tester)
				l_objects := objects_internal
				l_name_prefix := {ITP_SHARED_CONSTANTS}.variable_name_prefix
				l_obj_table.start
			until
				l_obj_table.after
			loop
				l_obj_index := l_obj_table.key_for_iteration
				l_obj_name := l_name_prefix + l_obj_index.out
				l_expr := variable_expression_from_context (l_obj_name, a_context)
				l_objects.force_last (l_obj_table.item_for_iteration, l_expr)
				extend_variable (l_expr, l_obj_index)
				l_obj_table.forth
			end
		ensure
			context_set: context = a_context
		end

feature -- Access

	properties: EPA_STATE
			-- Set of properties among `variables' that can be queries		

	objects: DS_HASH_TABLE [detachable ANY, EPA_EXPRESSION]
			-- Objects deserialized from `serialization_as_array'
			-- Key is variable name for an object, value is the object itself.
		do
			Result := objects_internal
		end

	serialization_as_array: ARRAY [NATURAL_8]
			-- Serialized data for all objects in `a_context'.`variables'.
			-- The serialized data should be of type SPECIAL [detachable ANY], the format is:
			-- [object1_index, object1, object2_index, object2, ... , objectn_index, objectn]
		do
			if attached {ARRAY [NATURAL_8]} serialization_internal as l_serialization then
					-- If original serialization is available, return it.
				Result := l_serialization
			else
					-- If no original serialization is available, calculate from `objects'.
					-- Note: the calculation is done every time when this query is called.					
				Result := ascii_string_as_array (serialized_object (object_list))
			end
		end

	serialization_as_string: STRING
			-- String representation for `serialization
			-- Format: comma separated ascii code for every natural_8 in `serialization.
		do
			Result := array_as_string (serialization_as_array)
		end

	dynamic_type_name_table: HASH_TABLE [STRING, STRING]
			-- Table from variable names to their dynamic type
		do
			if dynamic_type_name_table_internal = Void then
				dynamic_type_name_table_internal := type_name_table (variable_dynamic_type_table)
			end
			Result := dynamic_type_name_table_internal
		end

	text_in_static_type_form (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' in static type form
		do
			static_type_form_generator.generate (context, a_expression, dynamic_type_name_table)
			Result := static_type_form_generator.output.string_representation
		end

	text_in_dynamic_type_form (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' in static type form
		do
			Result := expression_with_replacements (a_expression, dynamic_type_name_table, True)
		end

	text_in_anonymous_type_form (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' in static type form
		do
			Result := anonymous_expression_text (a_expression)
		end

	static_type_of_variable (a_variable: EPA_EXPRESSION): TYPE_A
			-- Static type of `a_variable'
			-- For objects, there is no static type, dynamic type of objects are used.
		do
			Result := a_variable.type
		end

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

	set_serialization_internal (a_serialization: like serialization_internal)
			-- Set `serialization_internal' with `a_serialization'.
		do
			serialization_internal := a_serialization
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

	serialization_internal: detachable like serialization_as_array
			-- Cache for `serialization_as_array'

	initialize_with_context (a_context: EPA_CONTEXT)
			-- Initialize.
		do
			context := a_context
			context_type := context.class_.actual_type
			create properties.make (20, context.class_, context.feature_)

			create variables.make (20)
			variables.set_equality_tester (expression_equality_tester)
			create variable_positions.make (20)
			create reversed_variable_position.make (20)
		end

	object_list: SPECIAL [detachable ANY]
			-- List of objects along with their indexes from `objects', the format is:
			-- [object1_index, object1, object2_index, object2, ... , objectn_index, objectn]			
		local
			l_cursor: like variable_positions.new_cursor
			l_objects: like objects
			l_var_expr: EPA_EXPRESSION
			l_var_pos: INTEGER
			i: INTEGER
			l_obj: detachable ANY
		do
			l_objects := objects
			create Result.make_filled (Void, variables.count)

			from
				i := 0
				l_cursor := variable_positions.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_var_expr := l_cursor.key
				l_var_pos := l_cursor.item
				l_objects.search (l_var_expr)
				if l_objects.found then
					l_obj := l_objects.found_item
				else
					l_obj := Void
				end
				Result.put (l_var_pos, i)
				i := i + 1
				Result.put (l_obj, i)
				i := i + 1
				l_cursor.forth
			end
		end

	dynamic_type_name_table_internal: detachable like dynamic_type_name_table
			-- Cache for `dynamic_type_name_table'	

end
