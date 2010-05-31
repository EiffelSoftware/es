note
	description: "Writer to write a semantic document"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_OBJECTS_WRITER
inherit
	SEM_DOCUMENT_WRITER
		redefine
			write,
			queryable
		end
create {SEM_DOCUMENT_WRITER}
	default_create

feature -- Basic operation

	write (a_objects: SEM_OBJECTS; a_folder: detachable STRING)
			-- Output `a_objects' into a file in `a_folder'
		local
			l_id: STRING
			l_file: PLAIN_TEXT_FILE
			l_file_name: FILE_NAME
			l_prop_list: STRING
			l_calls: LIST[STRING]
		do
			queryable := a_objects

			create buffer.make (4096)
			append_document_type (document_type)
			append_variables (queryable.variables, variables_field, true)
			append_variables (queryable.variables, variable_types_field, false)
			append_state (queryable.properties, to_field_prefix)
			append_serialized_data

			create l_id.make (64)

			from
				a_objects.objects.start
			until
				a_objects.objects.after
			loop
				if a_objects.objects.item_for_iteration /= void then
					l_id.append (a_objects.objects.item_for_iteration.generating_type)
				else
					l_id.append (once "NONE")
				end

				l_id.append_character ('.')

				a_objects.objects.forth
			end

			l_id.append (buffer.hash_code.out)
			append_field (id_field, default_boost, type_string, l_id)

			last_document := buffer

			if attached a_folder then
				create l_file_name.make_from_string (a_folder)
				l_file_name.set_file_name (l_id + ".obj")
				create l_file.make_create_read_write (l_file_name)
				l_file.put_string (buffer)
				l_file.close
			end
		end

feature -- Constants

	document_type: STRING = "objects"

feature {NONE} -- Impelementation

	combined_property_list: STRING
			-- Concatenated list of properties used to determine abstract types
		do
			from
				create Result.make_empty
				queryable.properties.start
			until
				queryable.properties.after
			loop
				Result.append(queryable.anonymous_expression_text (queryable.properties.item_for_iteration.expression)+"%N")
				queryable.properties.forth
			end
		end

	queryable: SEM_OBJECTS
			-- Objects to be output

feature {NONE} -- Output

	append_serialized_data
			-- Append serialized data to buffer
		local
			l_index: INTEGER
			l_serialization_buffer: STRING
		do
			if queryable.serialization /= void then
				create l_serialization_buffer.make_empty
				from
					l_index := queryable.serialization.lower
				until
					l_index > queryable.serialization.upper
				loop
					l_serialization_buffer.append (queryable.serialization[l_index].out)

					if l_index < queryable.serialization.upper then
						l_serialization_buffer.append_character (serialization_field_array_separator)
					end

					l_index := l_index+1
				end

				append_field (serialization_field, default_boost, type_string, l_serialization_buffer)
			end
		end
end
