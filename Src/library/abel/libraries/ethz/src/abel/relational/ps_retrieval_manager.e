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
			create bookkeeping_manager.make (100)
		end

	backend:PS_BACKEND_STRATEGY
		-- The storage backend

	query_to_cursor_map: HASH_TABLE[ITERATION_CURSOR[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]], INTEGER]

	bookkeeping_manager: HASH_TABLE[HASH_TABLE[ANY, INTEGER], INTEGER]
		-- keeps track of already loaded object for each query

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
			results: ITERATION_CURSOR[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]]
			bookkeeping_table:HASH_TABLE[ANY, INTEGER]
		do
			query.set_identifier (new_identifier)
			query.register_as_executed (transaction)

			results:=backend.retrieve (query.class_name, query.criteria, create{LINKED_LIST[STRING]}.make, transaction)
			query_to_cursor_map.extend (results, query.backend_identifier)

			create bookkeeping_table.make (100)
			bookkeeping_manager.extend (bookkeeping_table, query.backend_identifier)

			retrieve_until_criteria_match (query, transaction, bookkeeping_table)

		end


	next_entry (query:PS_OBJECT_QUERY[ANY])
		local
			bookkeeping_table:HASH_TABLE[ANY, INTEGER]
		do
			attach (query_to_cursor_map[query.backend_identifier]).forth
			bookkeeping_table:= attach (bookkeeping_manager[query.backend_identifier])
			retrieve_until_criteria_match (query, query.transaction, bookkeeping_table)
		end



feature {NONE} -- Implementation


	retrieve_until_criteria_match (query:PS_OBJECT_QUERY[ANY]; transaction:PS_TRANSACTION; bookkeeping:HASH_TABLE[ANY, INTEGER])
		-- Retrieve objects until the criteria in `query.criteria' are satisfied
		local
			results: ITERATION_CURSOR[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]]
			current_object:PS_PAIR[INTEGER, HASH_TABLE[STRING, STRING]]
			new_object:ANY
			found:BOOLEAN
			reflection:INTERNAL
			new_type:INTEGER
		do
			create reflection
			results:= attach (query_to_cursor_map[query.backend_identifier])


			from
				found:= False
			until
				found or results.after
			loop

				current_object := attach (results.item)

				-- This has to be the detachable type, otherwise the is_deep_equal feature won't work any more
				new_type:= reflection.detachable_type (reflection.generic_dynamic_type (query, 1))
				--print (new_type.out + "%N")
				new_object:= build (new_type, current_object, transaction, bookkeeping)


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



	build (--query: PS_OBJECT_QUERY[ANY];
		dynamic_type:INTEGER
		 obj:PS_PAIR[INTEGER, HASH_TABLE[STRING, STRING]]; transaction:PS_TRANSACTION; bookkeeping:HASH_TABLE[ANY, INTEGER]):ANY
		-- Retrieve the results of `query'
		local
			reflection:INTERNAL
			i, no_fields:INTEGER
			field_name, field_val: STRING
			field_type_name:STRING
			field_type:INTEGER
			test:ANY

			cursor:ITERATION_CURSOR[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]]
		do
			if bookkeeping.has (obj.first) then
				Result:= attach (bookkeeping[obj.first])
			else


				create reflection
				Result:= reflection.new_instance_of (dynamic_type)

				bookkeeping.extend (Result, obj.first)

				no_fields:= reflection.field_count (Result)

				from i:=1
				until i> no_fields
				loop
					field_name := reflection.field_name (i, Result)
					if obj.second.has (field_name) then
						field_val := attach (obj.second[field_name])

						--field_type_name := reflection.class_name_of_type (reflection.field_static_type_of_type (i, reflection.dynamic_type (Result)))
						field_type:= reflection.detachable_type (reflection.field_static_type_of_type (i, reflection.dynamic_type (Result)))
						--print (field_type.out + "%N")
						--print (field_name + ": " + field_type_name + " = " + field_val + " type: " + field_type.out+ "%N")

						if not try_basic_attribute (Result, field_val, i) then
							--print (reflection.class_name_of_type (field_type))
							from
								cursor:= backend.retrieve (reflection.class_name_of_type (field_type), create{PS_EMPTY_CRITERION}, create{LINKED_LIST[STRING]}.make, transaction)
							until
								cursor.after
							loop
								if cursor.item.first = field_val.to_integer_32 then

									reflection.set_reference_field (i, Result, build (field_type, cursor.item, transaction, bookkeeping))
								end
								cursor.forth
							end

						end
					end
					i := i + 1
				variant
					no_fields+1 - i
				end
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
