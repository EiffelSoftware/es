note
	description: "Class to generate sql files for objects"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_OBJECTS_WRITER

inherit
	SEM_OBJECTS_WRITER

	SEM_FIELD_BASED_QUERYABLE_WRITER [SEM_OBJECTS]
		redefine
			clear_for_write
		end

	EPA_SHARED_EQUALITY_TESTERS

	SQL_QUERYABLE_WRITER [SEM_OBJECTS]

create
	make_with_medium

feature -- Basic operations

	write (a_document: SEM_OBJECTS)
			-- Write `a_document' into `output'.
		do
			next_augxiliary_variable_id := max_vairable_id_from_queryable (a_document)
			queryable := a_document
			append_queryable_type (queryable)
			append_uuid
			append_content
			append_serialization
			append_properties (a_document)
		end

	clear_for_write
			-- Clear intermediate data for next `write'.
		do
			Precursor
			reference_value_table.wipe_out
			object_value_table.wipe_out

			next_reference_equivalent_class_id := 1
			next_object_equivalent_class_id := 1
			next_augxiliary_variable_id := 1
		end

feature{NONE} -- Implementation

	append_content
			-- Append content from `queryable'e to `medium'.
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

	append_serialization
			-- Append serialization from `queryable' to `medium'.
		do
			append_string_field (serialization_field, queryable.serialization_as_string)
			if pre_state_object_info /= Void then
				append_string_field (object_info_field, pre_state_object_info)
			end
		end

	append_properties (a_objects: SEM_OBJECTS)
			-- Append propertie from `queryable' into `medium'.
		local
			l_obj_equiv_sets: like object_equivalent_classes
		do
				-- Appending preconditions.
			setup_reference_value_table (queryable.properties)
			l_obj_equiv_sets := object_equivalent_classes (queryable.properties)
			append_properties_internal (queryable.properties, l_obj_equiv_sets, a_objects)
		end

	append_properties_internal (a_state: EPA_STATE; a_object_equivalent_classes: like object_equivalent_classes; a_objects: SEM_OBJECTS)
			-- Append `a_state' into `medium' as properties.
			-- `a_object_equivalent_classes' indicates which expressions in `a_state' are object-equivalent to each other.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_expr: EPA_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
		do
			from
				l_cursor := a_state.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_value := l_cursor.item.value
				l_expr := l_cursor.item.expression
				if not l_value.is_nonsensical then
					append_equation (a_objects, l_expr, l_value, object_property_prefix, False, a_object_equivalent_classes, reference_value_table)
				end
				l_cursor.forth
			end
		end

end
