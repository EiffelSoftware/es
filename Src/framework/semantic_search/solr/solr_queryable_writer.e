note
	description: "Writer for SOLR documents"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SOLR_QUERYABLE_WRITER [G -> SEM_QUERYABLE]

inherit
	SOLR_UTILITY

	SEM_FIELD_BASED_QUERYABLE_WRITER [G]

feature -- Access

	queryable: G
			-- Queryable object
		deferred
		end

	xx: TWO_WAY_TREE [INTEGER]

feature{NONE} -- Implementation

	append_variables (a_variables: detachable EPA_HASH_SET[EPA_EXPRESSION]; a_field: STRING; a_print_position: BOOLEAN; a_print_ancestor: BOOLEAN; a_static_type: BOOLEAN)
			-- Append operands in `queryable' to `medium'.
			-- `a_print_position' indicates if position of variables are to be printed.
			-- `a_print_ancestor' indicates if ancestors of the types of `a_variables' are to be printed.
			-- `a_static_type' indicates if static type of `a_variables' are used.
		local
			l_values: STRING
		do
			l_values := variable_info (a_variables, queryable, a_print_position, a_print_ancestor, a_static_type)
			if not l_values.is_empty then
				append_field_with_data (a_field, l_values, ir_string_value_type, default_boost_value)
			end
		end

feature{NONE} -- Implementation

	written_fields: DS_HASH_SET [IR_FIELD]
			-- Fields that are already written
			-- Used to avoid writing duplicated fields
		deferred
		end

	medium: IO_MEDIUM
			-- Medium used to IO
		deferred
		end

	format_type_prefix (a_type: INTEGER): STRING
			-- Prefix for `a_type'
		do
			if a_type = dynamic_type_form then
				Result := dynamic_type_form_prefix
			elseif a_type = static_type_form then
				Result := static_type_form_prefix
			elseif a_type = anonymous_type_form then
				Result := anonymous_type_form_prefix
			end
		end

	field_name_for_equation (a_name: STRING; a_equation: EPA_EQUATION; a_format_type: INTEGER; a_meta: BOOLEAN; a_3rdprefix: STRING): STRING
			-- Field_name for `a_name' and `a_equation'
			-- `a_anonymous' indicates if the field is a field for anonymous property.
		do
			create Result.make (a_name.count + 32)

				-- Append type prefix.
			if a_meta then
				Result.append (string_prefix)
			else
				if a_equation.type.is_integer then
					Result.append (integer_prefix)
				else
					Result.append (boolean_prefix)
				end
			end

			Result.append (format_type_prefix (a_format_type))

			Result.append (a_3rdprefix)
			Result.append (encoded_field_string (a_name))
		end

	extend_string_into_list (a_table: HASH_TABLE [DS_HASH_SET [STRING], STRING]; a_string: STRING; a_key: STRING)
			-- Extend `a_string' into `a_table'.
		local
			l_set: DS_HASH_SET [STRING]
		do
			a_table.search (a_key)
			if a_table.found then
				l_set := a_table.found_item
			else
				create l_set.make (10)
				l_set.set_equality_tester (string_equality_tester)
				a_table.put (l_set, a_key)
			end
			l_set.force_last (a_string)
		end

feature{NONE} -- Implementation

	variable_indexes_from_anonymous_text (a_text: STRING): LINKED_LIST [INTEGER]
			-- Variable indexes from `a_text', `a_text' is in anonymous form
		local
			i: INTEGER
			c: INTEGER
			l_in_var: BOOLEAN
			l_index: STRING
			l_char: CHARACTER
		do
			create Result.make
			create l_index.make (6)
			from
				i := 1
				c := a_text.count
			until
				i > c
			loop
				l_char := a_text.item (i)
				if l_char = '{' then
					l_in_var := True
				elseif l_char = '}' then
					Result.extend (l_index.to_integer)
					l_index.wipe_out
					l_in_var := False
				elseif l_in_var then
					l_index.extend (l_char)
				end
				i := i + 1
			end
		end

	text_for_variable_indexes_and_value (a_anonymous_text: STRING; a_value_text: STRING): STRING
			-- String containing variable indexes in `a_anonymous_text' and `a_value_text'
		do
			create Result.make (a_anonymous_text.count + 20)
			across variable_indexes_from_anonymous_text (a_anonymous_text) as l_indexes loop
				Result.append (l_indexes.item.out)
				Result.append_character (',')
			end
			Result.append (a_value_text)
			Result.append_character (';')
		end

	string_representation_of_field (a_field: IR_FIELD): STRING
			-- String representation of `a_field'
		do
			Result := xml_element_for_field (a_field)
		end


end
