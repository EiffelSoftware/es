note
	description: "Loaded for a feature call transition"
	author: ""
	date: ""
	revision: ""

class
	SEM_FEATURE_CALL_TRANSITION_LOADER

inherit
	SEM_TRANSITION_LOADER [SEM_FEATURE_CALL_TRANSITION]

	EPA_TYPE_UTILITY

feature -- Access

	prestate_serialization: detachable STRING
			-- Prestate serialization (if available) from last `load'

	poststate_serialization: detachable STRING
			-- Poststate serialization (if available) from last `load'

feature -- Basic operations

	load
			-- Load document from `input', make result
			-- available in `last_document'.
		do
			initialize_data
			load_fields
			fields.search (document_type_field)
			if fields.found and then fields.found_item.value ~ transition_field_value then
				setup_basic_fields
				setup_contracts
			else
				-- Not a feature call transition.
			end
		end

feature{NONE} -- Implementation

	fields: HASH_TABLE [SEM_DOCUMENT_FIELD, STRING]
			-- Table of fields loaded by last `load'
			-- Key is field name, value is that field

feature{NONE} -- Implementation

	load_fields
			-- Load `fields' from `input'.
		local
			l_done: BOOLEAN
			l_lines: ARRAYED_LIST [STRING]
			l_field: SEM_DOCUMENT_FIELD
		do
			create fields.make (200)
			fields.compare_objects

			from
				create l_lines.make (4)
				l_done := not input.readable
			until
				l_done
			loop
				input.read_line
				if attached {STRING} input.last_string as l_line then
					if l_line.is_empty then
						if l_lines.count = 4 then
							create l_field.make (l_lines.first, l_lines.i_th (4), l_lines.i_th (3), l_lines.i_th (2).to_double)
							fields.force (l_field, l_field.name)
							l_done := (l_field.name ~ end_field)
						end
						l_lines.wipe_out
					else
						l_lines.extend (l_line.twin)
					end
				else
					l_done := True
				end
			end
		end

	initialize_data
			-- Initialize relevant data.
		do
			prestate_serialization := Void
			poststate_serialization := Void
			last_queryable := Void
		end

	setup_basic_fields
			-- Setup basic fields that are needed to construct a feature
			-- call transition.
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_context: EPA_CONTEXT
			l_ok: BOOLEAN
			l_fields: like fields
			l_positions: STRING
			l_variable_type_table: like variable_type_table
			l_variable_position_table: like variable_position_table
			l_operand_variable_indexes: like operand_variable_indexes
			l_is_creation: BOOLEAN
		do
			l_ok := True
			l_fields := fields

				-- Setup class.
			l_fields.search (class_field)
			l_ok := l_fields.found
			if l_ok then
				l_class := first_class_starts_with_name (l_fields.found_item.value)
			end

				-- Setup feature.
			if l_ok then
				l_fields.search (feature_field)
				l_ok := l_fields.found
				if l_ok then
					l_feature := l_class.feature_named  (l_fields.found_item.value)
				end
			end

				-- Setup context.
			if l_ok then
				l_fields.search (variable_position_field)
				l_ok := l_fields.found
				l_positions := l_fields.found_item.value
				if l_ok then
					l_fields.search (variables_field)
					l_ok := l_fields.found
					if l_ok then
						l_variable_type_table := variable_type_table (l_fields.found_item.value)
						l_variable_position_table := variable_position_table (l_positions)
						l_context := transition_context (l_variable_type_table, l_variable_position_table)
					end
				end
			end

				-- Setup operands.
			if l_ok then
				l_fields.search (operand_variable_indexes_field)
				l_ok := l_fields.found
				if l_ok then
					l_operand_variable_indexes := operand_variable_indexes (l_fields.found_item.value)
				end
			end

				-- Setup `l_is_creation'.
			if l_ok then
				l_fields.search (is_feature_under_test_creation_field)
				l_ok := l_fields.found
				if l_ok then
					l_is_creation := l_fields.found_item.value.to_boolean
				end
			end

				-- Construct `last_queryable'.
			create last_queryable.make (l_class, l_feature, l_operand_variable_indexes, l_context, l_is_creation)

		end

	variable_position_table (a_data: STRING): HASH_TABLE [STRING, INTEGER]
			-- Variable position table from `a_data'
			-- Key is 0-based variable position, value is name of that variable.
		local
			l_vars: LIST [STRING]
			l_var_name: STRING
			l_var_pos: INTEGER
		do
			l_vars := a_data.split (',')
			create Result.make (l_vars.count // 2)
			from
				l_vars.start
			until
				l_vars.after
			loop
				l_var_name := l_vars.item_for_iteration
				l_vars.forth
				l_var_pos := l_vars.item_for_iteration.to_integer
				l_vars.forth
				Result.force (l_var_name, l_var_pos)
			end
		end

	variable_type_table (a_data: STRING): HASH_TABLE [TYPE_A, INTEGER]
			-- Variable type table from `a_data'.
			-- Key is 0-based variable position, value is type of that variable.
			-- Format of `a_data' is something like: {LINKED_LIST [ANY]}@0;;;{ANY}@1;;;{NONE}@2;;;{BOOLEAN}@3;;;{BOOLEAN}@4;;;{INTEGER_32}@5.
		local
			l_cur_var: LIST [STRING_8]
			l_type_name: STRING_8
			l_any: CLASS_C
		do
			create Result.make (10)
			l_any := first_class_starts_with_name ("ANY")
			across string_slices (a_data, field_value_separator) as l_vars loop
				l_cur_var := l_vars.item.split ('@')
				l_type_name := l_cur_var.i_th (1)
				l_type_name := l_type_name.substring (2, l_type_name.count - 1)
				Result.force (type_a_from_string (l_type_name, l_any), l_cur_var.i_th (2).to_integer)
			end
		end

	transition_context (a_variable_types: like variable_type_table; a_variable_positions: like variable_position_table): EPA_CONTEXT
			-- Context from `a_variable_types' and `a_variable_positions'
		local
			l_vars: HASH_TABLE [TYPE_A, STRING]
			l_position: INTEGER
			l_type: TYPE_A
			l_name: STRING
		do
			create l_vars.make (a_variable_positions.count)
			l_vars.compare_objects

			across a_variable_types as l_types loop
				l_position := l_types.key
				l_type := l_types.item
				l_name := a_variable_positions.item (l_position)
				l_vars.force (l_type, l_name)
			end
			create Result.make (l_vars)
		end

	operand_variable_indexes (a_data: STRING): HASH_TABLE [STRING, INTEGER]
			-- Operand index table from `a_data'
			-- Key is 0-based operand position, value is name of that operand.
		local
			l_operands: LIST [STRING]
			l_opd_position: INTEGER
			l_opd_id: INTEGER
			l_var_name: STRING
			l_done: BOOLEAN
		do
			l_operands := a_data.split (',')
			create Result.make (l_operands.count // 2)
			from
				l_operands.start
			until
				l_operands.after
			loop
				l_opd_position := l_operands.item_for_iteration.to_integer
				l_operands.forth
				l_opd_id := l_operands.item_for_iteration.to_integer
				l_operands.forth
				l_var_name := variable_name_with_default_prefix (l_opd_id)
				Result.force (l_var_name, l_opd_position)
			end
		end

	setup_contracts
			-- Setup pre- and postconditions in `last_queryable'.
		do
			
		end

end

