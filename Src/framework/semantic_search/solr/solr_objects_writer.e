note
	description: "Class to write objects into Solr documents"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLR_OBJECTS_WRITER

inherit
	SEM_OBJECTS_WRITER

	SOLR_QUERYABLE_WRITER [SEM_QUERYABLE]

create
	make_with_medium

feature{NONE} -- Initialization

	make_with_medium (a_medium: like medium)
			-- Initialize `medium' with `a_medium'.
		do
			set_medium (a_medium)
		end

feature -- Basic operations

	write (a_objects: like queryable)
			-- Write `a_objects' into `medium'.
		do
			queryable := a_objects
			queryable_dynamic_type_name_table := type_name_table (queryable.variable_dynamic_type_table)

			medium.put_string (once "<add><doc>%N")
			append_queryable_type
			append_uuid
			append_variables (queryable.variables, variables_field, True, False)
			append_variables (queryable.variables, variable_types_field, False, True)
			append_properties
			append_serialization
			append_content
			medium.put_string (once "</doc></add>%N")
		end

feature{NONE} -- Implementation

	queryable_dynamic_type_name_table: like type_name_table
			-- Dynamic type name table for variables in `queryable'

	static_type_form_generator: SEM_STATIC_TYPE_FORM_GENERATOR
			-- Static type form generator
		once
			create Result.make
		end

feature{NONE} -- Implementation

	append_properties
			-- Append properties from `queryable' into `medium'.
		local
			l_equations: like queryable.properties.new_cursor
			l_expr: EPA_EXPRESSION
			l_tran: like queryable
			l_var_dtype_tbl: like type_name_table
			l_var_stype_tbl: like type_name_table
			l_type: INTEGER
			l_anonymous: STRING
			a_prefix: STRING
			l_equation: EPA_EQUATION
			l_boost: DOUBLE
			l_value_text: STRING
			l_value: EPA_EXPRESSION_VALUE
			l_prefix: STRING
			l_dmeta: HASH_TABLE [STRING, STRING]
			l_smeta: HASH_TABLE [STRING, STRING]
			l_body: STRING
			l_field_name: STRING
			l_meta_value: STRING
		do
			l_tran := queryable
			l_var_dtype_tbl := queryable_dynamic_type_name_table
			l_boost := default_boost_value
			l_prefix := property_prefix
			create l_dmeta.make (400)
			l_dmeta.compare_objects
			create l_smeta.make (400)
			l_smeta.compare_objects
				-- Iterate through all interface contracts from `queryable'.
			from
				l_equations := queryable.properties.new_cursor
				l_equations.start
			until
				l_equations.after
			loop
				l_equation := l_equations.item
				l_expr := l_equation.expression
				l_value := l_equation.value
				l_value_text := l_value.text
				l_type := type_of_equation (l_equation)

					-- Only handle integer value and True boolean values.
				if l_value.is_integer or l_value.is_true_boolean then
						-- Output anonymous format.
					l_anonymous := queryable.anonymous_expression_text (l_expr)
					append_field_with_data (field_name_for_equation (l_anonymous, l_equation, anonymous_format_type, False, l_prefix), l_value_text, l_type, l_boost)

						-- Output dynamic type format.
					l_body := expression_with_replacements (l_expr, l_var_dtype_tbl, True)
					append_field_with_data (
						field_name_for_equation (l_body, l_equation, dynamic_format_type, False, l_prefix),
						l_value_text, l_type, l_boost)

					l_field_name := field_name_for_equation (l_body, l_equation, dynamic_format_type, True, l_prefix)
					l_meta_value := text_for_variable_indexes_and_value (l_anonymous, l_value_text)
					extend_string_into_list (l_dmeta, l_meta_value, l_field_name)

						-- Output static type form.
					static_type_form_generator.generate (queryable.context, l_expr, l_var_dtype_tbl)
					l_body := static_type_form_generator.output.string_representation
					append_field_with_data (
						field_name_for_equation (l_body, l_equation, static_format_type, False, l_prefix),
						l_value_text, l_type, l_boost)
					l_field_name := field_name_for_equation (l_body, l_equation, static_format_type, True, l_prefix)
					l_meta_value := text_for_variable_indexes_and_value (l_anonymous, l_value_text)
					extend_string_into_list (l_smeta, l_meta_value, l_field_name)
				end
				l_equations.forth
			end

			across <<l_dmeta, l_smeta>> as l_metas loop
				across l_metas.item as l_items loop
					append_field_with_data (l_items.key, escaped_field_string (l_items.item), ir_string_value_type, default_boost_value)
				end
			end
		end

	append_serialization
			-- Append serialization from `queryable' to `medium'.
		do
			append_string_field (serialization_field, queryable.serialization_as_string)
		end

	append_content
			-- Append content from `queryab'e to `medium'.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_types: HASH_TABLE [INTEGER, STRING]
			l_type_name: STRING
			l_content: STRING
		do
			create l_types.make (10)
			l_types.compare_objects
			from
				l_cursor := queryable.variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_type_name := output_type_name (l_cursor.item.type.name)
				l_types.force (l_types.item (l_type_name) + 1, l_type_name)
				l_cursor.forth
			end

			create l_content.make (256)
			across l_types as l_type_counts loop
				l_content.append (l_type_counts.key)
				l_content.append (once ": ")
				l_content.append (l_type_counts.item.out)
				l_content.append (once "; ")
			end
			append_string_field (content_field, l_content)
		end

end

