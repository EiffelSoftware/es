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
			from
				l_cursor := a_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_expr := l_cursor.item.expression
					-- We only care about expressions in form "expr1 ~ expr2" = True.
				if attached {BIN_TILDE_AS} l_expr.ast as l_tilda and then l_cursor.item.value.is_true_boolean then
					create l_left_expr.make_with_feature (l_expr.class_, l_expr.feature_, l_tilda.left, l_expr.written_class)
					create l_right_expr.make_with_feature (l_expr.class_, l_expr.feature_, l_tilda.right, l_expr.written_class)

					l_set := Void
						-- Iterate through all known equivalent classes, check if `l_left_expr' or `l_right_expr' is in the set.
					across l_equiv_sets as l_sets until l_set /= Void loop
						if l_sets.item.has (l_left_expr) or else l_sets.item.has (l_right_expr) then
							l_set := l_sets.item
						end
					end

					if l_set = Void then
						create l_set.make (10)
						l_set.set_equality_tester (expression_equality_tester)
					end

						-- Put `l_left_expr' and `l_right_expr' into the set equivalent class.
					if not l_set.has (l_left_expr) then
						l_set.force_last (l_left_expr)
					end
					if not l_set.has (l_right_expr) then
						l_set.force_last (l_right_expr)
					end
				end
				l_cursor.forth
			end

			create Result.make (50)
			Result.set_key_equality_tester (expression_equality_tester)
			next_object_equivalent_class_id := next_object_equivalent_class_id + 1
			across l_equiv_sets as l_sets loop
				from
					l_expr_cursor := l_sets.item.new_cursor
					l_expr_cursor.start
				until
					l_expr_cursor.after
				loop

					Result.force_last (next_object_equivalent_class_id, l_expr_cursor.item)
					l_expr_cursor.forth
				end
				next_object_equivalent_class_id := next_object_equivalent_class_id + 1
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
								-- We use the minimal value of INTEGER_32 to represent Void.
								-- This is a hack though.
							l_value_text := {INTEGER}.min_value.out
						else
							l_value_text := l_value.text
						end
						if not l_value_tbl.has (l_value.text) then
							l_value_tbl.put (next_reference_equivalent_class_id, l_value_text)
							next_reference_equivalent_class_id := next_reference_equivalent_class_id + 1
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
					l_value_text := a_reference_value_table.item (a_value.text)
					if a_object_equivalent_classes /= Void then
						a_object_equivalent_classes.search (a_expr)
						if a_object_equivalent_classes.found then
							l_equal_value_text := a_object_equivalent_classes.found_item
						else
							l_equal_value_text := a_reference_value_table.found_item
							next_object_equivalent_class_id := next_object_equivalent_class_id + 1
						end
					else
						l_equal_value_text := a_reference_value_table.found_item
						next_object_equivalent_class_id := next_object_equivalent_class_id + 1
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
				l_data.append_character (field_section_separator)
				if l_canonical_text ~ once "$" then
					l_data.append (a_queryable.variable_positions.item (a_expr).out)
					append_string_field (variable_field_name, l_data)
				else
					l_data.append (once "0")
					append_string_field (property_field_name, l_data)
				end
			end
		end

end
