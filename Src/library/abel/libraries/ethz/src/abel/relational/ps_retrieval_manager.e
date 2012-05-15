note
	description: "Responsible for correct retrieval of objects"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RETRIEVAL_MANAGER
inherit
	PS_EIFFELSTORE_EXPORT

inherit{NONE}
	REFACTORING_HELPER

create make

feature {NONE}

	make (a_backend: PS_BACKEND_STRATEGY)
		-- Initialize `Current'
		do
			backend:= a_backend
			create query_to_cursor_map.make (100)
		end

	backend:PS_BACKEND_STRATEGY
		-- The storage backend

	query_to_cursor_map: HASH_TABLE[ITERATION_CURSOR[HASH_TABLE[STRING, STRING]], INTEGER]


	new_identifier: INTEGER
			-- Get a new identifier for a query
		do
--			fixme ( "TODO: make this fault free...")
			Result := identifier_number
			identifier_number := identifier_number + 1
		end
	identifier_number: INTEGER

feature

	setup_query (query:PS_OBJECT_QUERY[ANY]; transaction:PS_TRANSACTION)
		local
			results: ITERATION_CURSOR[HASH_TABLE[STRING, STRING]]
		do
			query.set_identifier (new_identifier)
			query.register_as_executed (transaction)

			results:=backend.retrieve (query.class_name, query.criteria, create{LINKED_LIST[STRING]}.make, transaction)
			query_to_cursor_map.extend (results, query.backend_identifier)

			retrieve_one (query, transaction)

		end


	next_entry (query:PS_OBJECT_QUERY[ANY])
		do
			attach (query_to_cursor_map[query.backend_identifier]).forth
			retrieve_one (query, query.transaction)
		end



	retrieve_one (query: PS_OBJECT_QUERY[ANY]; transaction:PS_TRANSACTION)
		-- Retrieve the results of `query'
		local
			results: ITERATION_CURSOR[HASH_TABLE[STRING, STRING]]
			current_object:HASH_TABLE[STRING, STRING]
			reflection:INTERNAL
			new_object:ANY
			i, no_fields:INTEGER
			found:BOOLEAN
			field_name, field_type_name, field_val: STRING
			type:INTEGER
		do
			create reflection
			results:= attach (query_to_cursor_map[query.backend_identifier])


			from
				found:= False
			until
				found or results.after
			loop



				new_object:= reflection.new_instance_of (reflection.dynamic_type_from_string (query.class_name))

				no_fields:= reflection.field_count (new_object)

				from i:=1
				until i> no_fields
				loop
					field_name := reflection.field_name (i, new_object)
					field_val := attach (results.item.at(field_name))
					--field_type_name := reflection.class_name_of_type (reflection.field_static_type_of_type (i, reflection.dynamic_type (new_object)))
					--type:= reflection.field_type (i, new_object)

					--print (field_name + ": " + field_type_name + " = " + field_val + "%N")

					check try_basic_attribute (new_object, field_val, i) end

					i := i + 1
				end

				if query.criteria.is_satisfied_by (new_object) then
					query.result_cursor.set_entry (new_object)
					found := true
				else
					results.forth
				end
			end

			if results.after then
				query.result_cursor.set_entry (Void)
			end

		end



	try_basic_attribute (obj:ANY; value:STRING; index:INTEGER):BOOLEAN
		-- See if field at `index' is of basic type, and set it if true
		local
			type:INTEGER
			reflection:INTERNAL
			type_name:STRING
		do
			create reflection
			type:= reflection.field_type (index, obj)

			if type /= reflection.reference_type and  type /= reflection.pointer_type then -- check if it is a basic type (except strings)
				set_expanded_attribute (obj, value, index)
				Result:= True
			else
				-- check if it's a string
				type_name := reflection.class_name_of_type (reflection.field_static_type_of_type (index, reflection.dynamic_type (obj)))

				if type_name.is_case_insensitive_equal ("STRING_32") then
					reflection.set_reference_field (index, obj, value.to_string_32)
					Result:= True
				elseif type_name.is_case_insensitive_equal ("STRING_8") then
					reflection.set_reference_field (index, obj, value.to_string_8)
					Result:= True
				else
					-- Not of a basic type - return false
					Result:= False
				end

			end

		end



	set_expanded_attribute (obj: ANY; value:STRING; index: INTEGER)
		-- Set the attribute `index' of type `type' of object obj to value `generic_value'
		local
			type:INTEGER
			reflection:INTERNAL
		do
			create reflection
			type:= reflection.field_type (index, obj)

			-- Integers
			if type = reflection.integer_8_type and value.is_integer_8 then
				reflection.set_integer_8_field (index, obj, value.to_integer_8)

			elseif type = reflection.integer_16_type and value.is_integer_16 then
				reflection.set_integer_16_field (index, obj, value.to_integer_16)

			elseif type = reflection.integer_32_type and value.is_integer_32 then
				reflection.set_integer_32_field (index, obj, value.to_integer_32)

			elseif type = reflection.integer_64_type and value.is_integer_64 then
				reflection.set_integer_64_field (index, obj, value.to_integer_64)

			-- Naturals
			elseif type = reflection.natural_8_type and value.is_natural_8 then
				reflection.set_natural_8_field (index, obj, value.to_natural_8)

			elseif type = reflection.natural_16_type and value.is_natural_16 then
				reflection.set_natural_16_field (index, obj, value.to_natural_16)

			elseif type = reflection.natural_32_type and value.is_natural_32 then
				reflection.set_natural_32_field (index, obj, value.to_natural_32)

			elseif type = reflection.natural_64_type and value.is_natural_64 then
				reflection.set_natural_64_field (index, obj, value.to_natural_64)

			-- Reals	
			elseif type = reflection.real_32_type and value.is_real then
				reflection.set_real_32_field (index, obj, value.to_real)

			elseif type = reflection.double_type and value.is_double then
				reflection.set_double_field (index, obj, value.to_double)

			-- Characters
			elseif type = reflection.character_8_type and value.is_natural_8 then
				reflection.set_character_8_field (index, obj, value.to_natural_8.to_character_8)

			elseif type = reflection.character_32_type and value.is_natural_32 then
				reflection.set_character_32_field (index, obj, value.to_natural_32.to_character_32)

			-- Boolean
			elseif type = reflection.boolean_type and value.is_boolean then
				reflection.set_boolean_field (index, obj, value.to_boolean)


			else
				fixme ("TODO: throw error")
			end
		end





end
