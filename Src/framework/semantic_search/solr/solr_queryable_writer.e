note
	description: "Writer for SOLR documents"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SOLR_QUERYABLE_WRITER [G -> SEM_QUERYABLE]

inherit
	SOLR_UTILITY

feature -- Access

	queryable: G
			-- Queryable object
		deferred
		end


	uuid: detachable UUID
			-- UUID used for the queryable to write
			-- If Void, a new UUID will be generated

feature -- Setting

	set_uuid (a_uuid: like uuid)
			-- Set `uuid' with `a_uuid'.
		do
			uuid := a_uuid
		ensure
			uuid_set: uuid = a_uuid
		end

feature{NONE} -- Implementation

	append_field_with_data (a_name: STRING; a_value: STRING; a_type: STRING; a_boost: DOUBLE)
			-- Write field specified through `a_name', `a_value', `a_type' and `a_boost' into `output'.
		do
			append_field (create {SEM_DOCUMENT_FIELD}.make (a_name, a_value, a_type, a_boost))
		end

	append_field (a_field: SEM_DOCUMENT_FIELD)
			-- append `a_field' into `medium'.
		do
			if not written_fields.has (a_field) then
				medium.put_character (' ')
				medium.put_character (' ')
				medium.put_string (xml_element_for_field (a_field))
				medium.put_character ('%N')
				written_fields.force_last (a_field)
			end
		end

	append_string_field (a_name: STRING; a_value: STRING)
			-- Append a string field with `a_name' and `a_value' and default boost value.
		do
			append_field (create {SEM_DOCUMENT_FIELD}.make_with_string_type (a_name, a_value))
		end

	append_variables (a_variables: detachable EPA_HASH_SET[EPA_EXPRESSION]; a_field: STRING; a_print_position: BOOLEAN; a_print_ancestor: BOOLEAN)
			-- Append operands in `queryable' to `medium'.
			-- `a_print_position' indicates if position of variables are to be printed.
			-- `a_print_ancestor' indicates if ancestors of the types of `a_variables' are to be printed.
		local
			l_values: STRING
		do
			l_values := variable_info (a_variables, queryable, a_print_position, a_print_ancestor)
			if not l_values.is_empty then
				append_field_with_data (a_field, l_values, string_field_type, default_boost_value)
			end
		end

	append_queryable_type
			-- Append type of `queryable' into `medium'.
		do
			append_field (queryable_type_field (queryable))
		end

	append_uuid
			-- Append an UUID into `medium'.
		do
			if uuid = Void then
				append_string_field (uuid_field, uuid_generator.generate_uuid.out)
			else
				append_string_field (uuid_field, uuid.out)
			end
		end

feature{NONE} -- Implementation

	written_fields: DS_HASH_SET [SEM_DOCUMENT_FIELD]
			-- Fields that are already written
			-- Used to avoid writing duplicated fields
		deferred
		end

	medium: IO_MEDIUM
			-- Medium used to IO
		deferred
		end

	field_name_for_equation (a_name: STRING; a_equation: EPA_EQUATION; a_anonymous: BOOLEAN; a_prefix: STRING): STRING
			-- Field_name for `a_name' and `a_equation'
			-- `a_anonymous' indicates if the field is a field for anonymous property.
		do
			create Result.make (a_name.count + 32)

				-- Append type prefix.
			if a_anonymous then
				Result.append (once "s_")
			elseif a_equation.type.is_integer then
				Result.append (once "i_")
			elseif a_equation.type.is_boolean then
				Result.append (once "b_")
			end
			Result.append (a_prefix)
			if a_anonymous then
				Result.append_character ('0')
			end
			Result.append_character ('_')
			Result.append (escaped_field_string (a_name))
		end

	extend_string_into_list (a_table: HASH_TABLE [STRING, STRING]; a_string: STRING; a_key: STRING)
			-- Extend `a_string' into `a_table'.
		local
			l_list: STRING
		do
			a_table.search (a_key)
			if a_table.found then
				l_list := a_table.found_item
			else
				create l_list.make (1024)
				a_table.put (l_list, a_key)
			end
			l_list.append (a_string)
		end

end
