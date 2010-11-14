note
	description: "Summary description for {SQL_QUERYABLE_WRITER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SQL_QUERYABLE_WRITER [G -> SEM_QUERYABLE]

inherit
	EPA_SHARED_EQUALITY_TESTERS

	EPA_TYPE_UTILITY

	SEM_FIELD_NAMES

	EPA_UTILITY

	SEM_FIELD_BASED_QUERYABLE_WRITER [G]
		undefine
			clear_for_write
		end

	ITP_SHARED_CONSTANTS

feature{NONE} -- Initialization

	make_with_medium (a_medium: like medium)
			-- Initialize `medium' with `a_medium'.
		do
			set_medium (a_medium)

			create reference_value_table.make (1024)
			reference_value_table.compare_objects

			create object_value_table.make (1024)
			object_value_table.compare_objects
		end

feature -- Setting

	set_medium (a_medium: like medium)
			-- Set `medium' with `a_medium'.
		deferred
		end


feature{NONE} -- Implementation

	string_representation_of_field (a_field: IR_FIELD): STRING
			-- String representation of `a_field'
		local
			l_value: STRING
		do
			create Result.make (256)
			Result.append (a_field.name)
			Result.append_character (':')
			Result.append_character (' ')

				-- All new line characters are encoded to make sure
				-- that a field takes only one line.
			l_value := a_field.value.text.twin
			l_value.replace_substring_all (once "%N", once "%%N")
			Result.append (l_value)
		end

feature{NONE} -- Implementation

	reference_value_table: HASH_TABLE [INTEGER, STRING]
			-- Value tables for reference equality
			-- Key of table is actual expression value,
			-- value of table is the equivelant class id

	object_value_table: HASH_TABLE [INTEGER, STRING]
			-- Value tables for object equality
			-- Key of table is actual expression value,
			-- value of table is the equivelant class id

	next_reference_equivalent_class_id: INTEGER
			-- ID for the next reference equivalent class

	next_object_equivalent_class_id: INTEGER
			-- ID for the next object equivalent class

	next_augxiliary_variable_id: INTEGER
			-- ID for the next auxiliary variable
			-- Auxiliary variables are used to represent integer argument as a variable.
			-- For example: we use an auxiliary variable v_20 to represent the integer
			-- argument 1 in the expression: l.i_th (1).

	object_equivalent_classes (a_state: EPA_STATE): DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
			-- Object equivalent classes from `a_state'
			-- Return a hash table, key is an expression in `a_state',
			-- value is the equivalent class id for that expression. Two expressions
			-- having the same equivalent class id means that they are object equal to each other.
		local
			l_equiv_sets: LINKED_LIST [DS_HASH_SET [EPA_EXPRESSION]]
			l_set: DS_HASH_SET [EPA_EXPRESSION]
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_expr: EPA_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
			l_left_expr: EPA_AST_EXPRESSION
			l_right_expr: EPA_AST_EXPRESSION
			l_expr_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_class_id: INTEGER
		do
			create l_equiv_sets.make
			create Result.make (50)
			Result.set_key_equality_tester (expression_equality_tester)

			from
				l_cursor := a_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_expr := l_cursor.item.expression
				if attached {EPA_REFERENCE_VALUE} l_cursor.item.value as l_ref_value then
					if l_ref_value.object_equivalent_class_id > 0 then
						Result.force_last (l_ref_value.object_equivalent_class_id, l_expr)
						if l_ref_value.object_equivalent_class_id > next_object_equivalent_class_id then
							next_object_equivalent_class_id := l_ref_value.object_equivalent_class_id + 1
						end
					end
				end
				l_cursor.forth
			end
		end

	setup_reference_value_table (a_state: EPA_STATE)
			-- Setup `reference_value_table' using `a_state'.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_value_tbl: like reference_value_table
			l_expr: EPA_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
			l_value_text: STRING
			l_ast: EXPR_AS
			l_class_id: INTEGER
		do
				-- Iterate through all expressions in `a_state', for an expression,
				-- if it is not connected through a "=", "/=" ,"~", "/~", we collect
				-- its value and assign its value to an equivalent class ID.
			l_value_tbl := reference_value_table
			from
				l_cursor := a_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_expr := l_cursor.item.expression
				l_ast := l_expr.ast
				if attached {BIN_EQ_AS} l_ast or else attached {BIN_NE_AS} l_ast or else attached {BIN_TILDE_AS} l_ast or else attached {BIN_NOT_TILDE_AS} l_ast then
				else
						-- `l_expr' is a basic expression.
					l_value := l_cursor.item.value
						-- We ignore nonsensical values. An expression has nonsensical value
						-- if its evaluation ended with an exception.
					if not l_value.is_nonsensical then
						if l_value.is_void then
								-- We use the max value of INTEGER_16 + 1 to represent Void.
								-- This is a hack though.							
							l_class_id := void_value_id
							l_value_text := l_class_id.out
						else
							l_value_text := l_value.text
							l_class_id := next_reference_equivalent_class_id
							next_reference_equivalent_class_id := next_reference_equivalent_class_id + 1
						end
						if not l_value_tbl.has (l_value_text) then
							l_value_tbl.put (l_class_id, l_value_text)

						end
					end
				end
				l_cursor.forth
			end
		end

	expression_info (a_expression: EPA_EXPRESSION): TUPLE [canonical_form: STRING; operands: LINKED_LIST [EPA_EXPRESSION]]
			-- Information of `a_expression'
			-- `canonical_form' is a text representation of `a_expression', with all operands replaced by "$", for example,
			-- "l1.has (l2)" becomes "$.has ($)". `operands' is the list of operands in `a_expression'. The operands are in the same order as the appear
			-- in `a_expression'.
		local
			l_old_value: BOOLEAN
			l_rewriter: like expression_rewriter
			l_replacements: HASH_TABLE [STRING, STRING]
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_canonical_form: STRING
			l_operands: LINKED_LIST [EPA_EXPRESSION]
			l_opd_text: STRING
			l_operand: EPA_EXPRESSION
		do
			create l_replacements.make (queryable.variables.count)
			l_replacements.compare_objects
			from
				l_cursor := queryable.variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_replacements.put (once "$", l_cursor.item.text)
				l_cursor.forth
			end

			l_rewriter := expression_rewriter
			l_old_value := l_rewriter.should_keep_encountered_names
			l_rewriter.set_should_keep_encountered_names (True)
			l_canonical_form := l_rewriter.expression_text (a_expression, l_replacements)
			create l_operands.make
			across l_rewriter.encountered_names as l_names loop
				l_operand := queryable.variable_by_name (l_names.item)
				l_operands.extend (l_operand)
			end
			l_rewriter.set_should_keep_encountered_names (l_old_value)
			Result := [l_canonical_form, l_operands]
		end

feature{NONE} -- Implementation

	append_equation (a_queryable: SEM_QUERYABLE; a_expr: EPA_EXPRESSION; a_value: EPA_EXPRESSION_VALUE; a_property_type: STRING; a_human_written: BOOLEAN; a_object_equivalent_classes: detachable DS_HASH_TABLE [INTEGER_32, EPA_EXPRESSION]; a_reference_value_table: HASH_TABLE [INTEGER, STRING])
				-- Append `a_expr' with `a_value' into `medium'
		local
			l_full_text: STRING
			l_canonical_text: STRING
			l_opd_number: INTEGER
			l_data: STRING
			l_expr_info: like expression_info
			l_operand_count: INTEGER
			l_operands: STRING
			l_operand_types: STRING
			i: INTEGER
			c: INTEGER
			l_value_text: INTEGER
			l_equal_value_text: INTEGER
			l_boost_value: DOUBLE
			l_should_process: BOOLEAN
			l_var_text: STRING
			l_prefix_length: INTEGER
			l_value_type: INTEGER
			l_int_arg: INTEGER
			l_aug_var: STRING
			l_aug_var_id: INTEGER
			l_matcher: like single_integer_argument_query_matcher
			l_new_expr_text: STRING
			l_aug_var_value: INTEGER
			l_new_canonical_text: STRING
		do
			l_prefix_length := default_variable_prefix.count
			if a_human_written then
				l_boost_value := 2.0
			else
				l_boost_value := default_boost_value
			end

			l_should_process := not a_value.is_nonsensical
			if attached {BIN_EQ_AS} a_expr.ast or else attached {BIN_NE_AS} a_expr.ast or else attached {BIN_TILDE_AS} a_expr.ast or else attached {BIN_NOT_TILDE_AS} a_expr.ast then
				if l_should_process then
					l_should_process := a_human_written
				end
			end
			if l_should_process then
				l_full_text := a_expr.text
				l_expr_info := expression_info (a_expr)
				l_canonical_text := l_expr_info.canonical_form
				l_operand_count := l_expr_info.operands.count
				if attached {EPA_INTEGER_VALUE} a_value as l_int then
					l_value_text := l_int.item
					l_equal_value_text := l_value_text
					l_value_type := 2
				elseif attached {EPA_BOOLEAN_VALUE} a_value as l_bool then
					if l_bool.item then
						l_value_text := 1
					else
						l_value_text := 0
					end
					l_equal_value_text := l_value_text
					l_value_type := 1
				else
					l_value_type := 0
					if a_value.is_void then
						l_value_text := a_reference_value_table.item (void_value_id.out)
					else
						l_value_text := a_reference_value_table.item (a_value.text)
					end
					if a_value.is_void then
						l_equal_value_text := void_value_id
					else
						if a_object_equivalent_classes /= Void then
							a_object_equivalent_classes.search (a_expr)
							if a_object_equivalent_classes.found then
								l_equal_value_text := a_object_equivalent_classes.found_item
							else
--								l_equal_value_text := a_reference_value_table.found_item
								l_equal_value_text := next_object_equivalent_class_id
								next_object_equivalent_class_id := next_object_equivalent_class_id + 1
							end
						else
--							l_equal_value_text := a_reference_value_table.found_item
							l_equal_value_text := next_object_equivalent_class_id
							next_object_equivalent_class_id := next_object_equivalent_class_id + 1
						end
					end
				end

					-- Collect operand information.
				create l_operands.make (128)
				create l_operand_types.make (128)
				c := l_expr_info.operands.count
				i := 1
				across l_expr_info.operands as l_operand_info loop
					l_var_text := l_operand_info.item.text.twin
					l_var_text.remove_head (l_prefix_length)
					l_operands.append (l_var_text)
					l_operand_types.append (output_type_name (l_operand_info.item.type.name))
					if i < c then
						l_operands.append_character (field_value_separator)
						l_operand_types.append_character (field_value_separator)
					end
					i := i + 1
				end

				create l_data.make (256)
				l_data.append (l_full_text)
				l_data.append_character (field_section_separator)
				l_data.append (l_canonical_text)
				l_data.append_character (field_section_separator)
				l_data.append (a_property_type)
				l_data.append_character (field_section_separator)
				l_data.append (c.out)
				l_data.append_character (field_section_separator)
				l_data.append (l_operands)
				l_data.append_character (field_section_separator)
				l_data.append (l_operand_types)
				l_data.append_character (field_section_separator)
				l_data.append (l_value_type.out)
				l_data.append_character (field_section_separator)
				l_data.append (l_value_text.out)
				l_data.append_character (field_section_separator)
				l_data.append (l_equal_value_text.out)
				l_data.append_character (field_section_separator)
				l_data.append (l_boost_value.out)
				l_data.append_character (field_section_separator)
				if l_canonical_text ~ once "$" then
					l_data.append (a_queryable.variable_positions.item (a_expr).out)
					append_string_field (variable_field_name, l_data)
				else
					l_data.append (once "0")
					append_string_field (property_field_name, l_data)
				end

					-- Check if `a_expr' is of form "a.query (i)" where i is an integer.
					-- If so, we introuce an auxiliary variable for that integer argument,
					-- and introduce a new property using that auxiliary variable.
				if l_canonical_text /~ once "$" then
					l_matcher := single_integer_argument_query_matcher
					l_matcher.match (a_expr.text)
					if l_matcher.has_matched then
							-- Calculate data about the augxiliary variable.
						l_aug_var := variable_name_prefix + next_augxiliary_variable_id.out
						l_aug_var_id := next_augxiliary_variable_id
						next_augxiliary_variable_id := next_augxiliary_variable_id + 1
						l_aug_var_value := l_matcher.captured_substring (1).to_integer
						l_new_expr_text := a_expr.text.substring (1, l_matcher.captured_start_position (1) - 1) + l_aug_var + a_expr.text.substring (l_matcher.captured_end_position (1) + 1, a_expr.text.count)

							-- Generate augxiliary variable.
						create l_data.make (128)
						l_data.append (l_aug_var)
						l_data.append_character (field_section_separator)
						l_data.append (once "$")
						l_data.append_character (field_section_separator)
						l_data.append (a_property_type)
						l_data.append_character (field_section_separator)
						l_data.append_integer (1)
						l_data.append_character (field_section_separator)
						l_data.append (l_aug_var_id.out)
						l_data.append_character (field_section_separator)
						l_data.append (once "INTEGER_32")
						l_data.append_character (field_section_separator)
						l_data.append_integer (2)
						l_data.append_character (field_section_separator)
						l_data.append (l_aug_var_value.out)
						l_data.append_character (field_section_separator)
						l_data.append (l_aug_var_value.out)
						l_data.append_character (field_section_separator)
						l_data.append_double (default_boost_value)
						l_data.append_character (field_section_separator)
						l_data.append_integer (-1)
						append_string_field (variable_field_name, l_data)

							-- Generate `a_expr' with the integer argument replaced with the auxiliary variable.
						l_matcher.match (l_canonical_text)
						l_new_canonical_text := l_canonical_text.substring (1, l_matcher.captured_start_position (1) - 1) + once "$" + l_canonical_text.substring (l_matcher.captured_end_position (1) + 1, l_canonical_text.count)

						create l_data.make (128)
						l_data.append (l_new_expr_text)
						l_data.append_character (field_section_separator)
						l_data.append (l_new_canonical_text)
						l_data.append_character (field_section_separator)
						l_data.append (a_property_type)
						l_data.append_character (field_section_separator)
						l_data.append_integer (c + 1)
						l_data.append_character (field_section_separator)
						l_data.append (l_operands + once ";" + l_aug_var_id.out)
						l_data.append_character (field_section_separator)
						l_data.append (l_operand_types + once ";INTEGER_32")
						l_data.append_character (field_section_separator)
						l_data.append (l_value_type.out)
						l_data.append_character (field_section_separator)
						l_data.append (l_value_text.out)
						l_data.append_character (field_section_separator)
						l_data.append (l_equal_value_text.out)
						l_data.append_character (field_section_separator)
						l_data.append (l_boost_value.out)
						l_data.append_character (field_section_separator)
						l_data.append_integer (-1)
						append_string_field (property_field_name, l_data)
					end
				end
			end
		end

	single_integer_argument_query_matcher: RX_PCRE_REGULAR_EXPRESSION
			-- Regular expresion matcher for integer argument queries.
		once
			create Result.make
			Result.set_caseless (True)
			Result.set_extended (True)
			Result.compile (".*\(([-0-9]+)\)")
		end

	max_vairable_id_from_queryable (a_queryable: SEM_QUERYABLE): INTEGER
			-- Maximal vairable id from `a_queryable'
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_var_name: STRING
			l_var_prefix: STRING
			l_var_prefix_count: INTEGER
			l_id: INTEGER
		do
			l_var_prefix := variable_name_prefix
			l_var_prefix_count := l_var_prefix.count
			Result := 1
			from
				l_cursor := a_queryable.variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_var_name := l_cursor.item.text.twin
				if l_var_name.starts_with (l_var_prefix) then
					l_var_name.remove_head (l_var_prefix_count)
					if l_var_name.is_integer then
						l_id := l_var_name.to_integer
						if l_id > Result then
							Result := l_id
						end
					end
				end
				l_cursor.forth
			end
		end

end
