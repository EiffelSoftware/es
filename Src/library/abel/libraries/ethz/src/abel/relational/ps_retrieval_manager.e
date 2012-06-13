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
			create collection_handlers.make
			create metadata_manager.make_new
		end

	backend:PS_BACKEND_STRATEGY
		-- The storage backend

	metadata_manager: PS_METADATA_MANAGER

--	query_to_cursor_map: HASH_TABLE[ITERATION_CURSOR[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]], INTEGER]
	query_to_cursor_map: HASH_TABLE[ITERATION_CURSOR[PS_RETRIEVED_OBJECT], INTEGER]

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

	collection_handlers: LINKED_LIST[PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]]]

	add_handler (a_handler: PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]])
		do
			collection_handlers.extend (a_handler)
		end

	setup_query (query:PS_OBJECT_QUERY[ANY]; transaction:PS_TRANSACTION)
		local
			results: ITERATION_CURSOR[PS_RETRIEVED_OBJECT]
			bookkeeping_table:HASH_TABLE[ANY, INTEGER]
			reflection: INTERNAL
			type: PS_TYPE_METADATA
		do
			create reflection
			query.set_identifier (new_identifier)
			query.register_as_executed (transaction)
			type:= metadata_manager.create_metadata_from_type (reflection.type_of_type (reflection.generic_dynamic_type (query, 1)))
			results:=backend.retrieve (type, query.criteria, create{LINKED_LIST[STRING]}.make, transaction)

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
--			results: ITERATION_CURSOR[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]]
			results: ITERATION_CURSOR[PS_RETRIEVED_OBJECT]
			current_object:PS_RETRIEVED_OBJECT
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

				current_object := results.item

				-- This has to be the detachable type, otherwise the is_deep_equal feature won't work any more
				new_type:= reflection.detachable_type (reflection.generic_dynamic_type (query, 1))
--				print (new_type.out + " " + reflection.detachable_type (query.generating_type.generic_parameter_type (1).type_id).out + "%N")
--				check new_type = query.generating_type.generic_parameter_type (1).type_id end

				--new_object:= build (new_type, current_object, transaction, bookkeeping)
				new_object:= build_new (metadata_manager.create_metadata_from_type (reflection.type_of_type (new_type)), current_object, transaction, bookkeeping)


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

	big_multiline_comment:STRING = "[

	build (--query: PS_OBJECT_QUERY[ANY];
		dynamic_type:INTEGER
		 obj:PS_RETRIEVED_OBJECT;
--		 obj:PS_PAIR[INTEGER, HASH_TABLE[STRING, STRING]];

		  transaction:PS_TRANSACTION; bookkeeping:HASH_TABLE[ANY, INTEGER]):ANY
		-- Retrieve the results of `query'
		local
			reflection:INTERNAL
			i, no_fields:INTEGER
			field_name, field_val: STRING
			field_type_name:STRING
			field_type:INTEGER
			test:ANY
			new_obj:ANY

--			cursor:ITERATION_CURSOR[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]]
			cursor:ITERATION_CURSOR[PS_RETRIEVED_OBJECT]


			collection_handler: detachable PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]]
			collection_result: PS_PAIR [LIST[STRING], HASH_TABLE[STRING, STRING] ]
			collection_as_list: LINKED_LIST[detachable ANY]
			collection_item: detachable ANY
		do
			if bookkeeping.has (obj.primary_key+ obj.class_metadata.name.hash_code) then
				Result:= attach (bookkeeping[obj.primary_key+ obj.class_metadata.name.hash_code])
			else


				create reflection
				Result:= reflection.new_instance_of  (dynamic_type)

				bookkeeping.extend (Result, obj.primary_key + obj.class_metadata.name.hash_code)
				no_fields:= reflection.field_count (Result)

				from i:=1
				until i> no_fields
				loop
					field_name := reflection.field_name (i, Result)
					if obj.to_old_format.second.has (field_name) then
						field_val := attach (obj.to_old_format.second[field_name])

						--field_type_name := reflection.class_name_of_type (reflection.field_static_type_of_type (i, reflection.dynamic_type (Result)))
						field_type:= reflection.detachable_type (
							reflection.field_static_type_of_type (i, reflection.dynamic_type (Result))
							)
						--print (field_type.out + "%N")
						--print (field_name + ": " + field_type_name + " = " + field_val + " type: " + field_type.out+ "%N")

						if not try_basic_attribute (Result, field_val, i) then
							--print (reflection.class_name_of_type (field_type))

							-- either a reference type or a collection
							across collection_handlers as coll_cursor loop
								if coll_cursor.item.can_handle_type (reflection.type_of_type (field_type)) then
									collection_handler:= coll_cursor.item
								end
							end

							if attached collection_handler then -- collection
								fixme ("relational collections")
								--collection_result:= backend.retrieve_collection (field_val.to_integer, dynamic_type, field_type, field_name)
								collection_result:= backend.retrieve_objectoriented_collection (metadata_manager.create_metadata_from_type (reflection.type_of_type (field_type)), field_val.to_integer, transaction)
								create collection_as_list.make
								across collection_result.first as foreignkey_cursor loop

									if foreignkey_cursor.item.to_integer = 0 then
										collection_as_list.extend (Void)
									else
										-- retrieve single object
										from
											cursor:= backend.retrieve (metadata_manager.create_metadata_from_type (reflection.type_of_type (reflection.generic_dynamic_type_of_type (field_type, 1))), create{PS_EMPTY_CRITERION}, create{LINKED_LIST[STRING]}.make, transaction)
										until
											cursor.after
										loop
											if cursor.item.to_old_format.first = foreignkey_cursor.item.to_integer then
												collection_as_list.extend (build (reflection.generic_dynamic_type_of_type (field_type, 1), cursor.item, transaction, bookkeeping))
											end
											cursor.forth
										end
									end
								end
								reflection.set_reference_field (i, Result, collection_handler.build_collection (field_type, collection_as_list, collection_result.second))

							else -- reference type

								from
									cursor:= backend.retrieve (metadata_manager.create_metadata_from_type (reflection.type_of_type (field_type)), create{PS_EMPTY_CRITERION}, create{LINKED_LIST[STRING]}.make, transaction)
								until
									cursor.after
								loop
									print ("XXXXXXXXXXXX" + cursor.item.class_metadata.name + reflection.class_name_of_type (field_type) + "%N")
									if cursor.item.primary_key = field_val.to_integer_32 and then cursor.item.class_metadata.name.is_equal (reflection.class_name_of_type (field_type)) then
										print (reflection.type_of_type (field_type).out)
										print (reflection.type_of_type (reflection.field_static_type_of_type (i, dynamic_type)).out)
										--check false end
										new_obj:= build (field_type, cursor.item, transaction, bookkeeping)
										print (new_obj.generating_type.out)
										reflection.set_reference_field (i, Result, new_obj)
									end
									cursor.forth
								end
							end
						end
					end
					i := i + 1
				variant
					no_fields+1 - i
				end
			end
		ensure
			type_correct: Result.generating_type.type_id = dynamic_type
		end

	]"


	build_new(type:PS_TYPE_METADATA; obj:PS_RETRIEVED_OBJECT; transaction:PS_TRANSACTION; bookkeeping:HASH_TABLE[ANY, INTEGER]): ANY
		require
			obj.class_metadata.name.is_equal (type.class_of_type.name)
		local
			reflection:INTERNAL
			field_value: ANY
			field_type:PS_TYPE_METADATA
			keys: LINKED_LIST [INTEGER]
			referenced_obj: LIST[PS_RETRIEVED_OBJECT]
		do
			if bookkeeping.has (obj.primary_key+ obj.class_metadata.name.hash_code) then
				Result:= attach (bookkeeping[obj.primary_key+ obj.class_metadata.name.hash_code])
			else
				create reflection
				Result:= reflection.new_instance_of  (type.type.type_id)
				bookkeeping.extend (Result, obj.primary_key + obj.class_metadata.name.hash_code)

				across obj.attributes as attr_cursor loop
--					print (attr_cursor.item)
					if not try_basic_attribute (Result, obj.attribute_value (attr_cursor.item).first, type.index_of (attr_cursor.item)) then

						field_type:= type.attribute_type (attr_cursor.item)

						if not obj.attribute_value (attr_cursor.item).first.is_empty then
							create keys.make
							keys.extend (obj.attribute_value (attr_cursor.item).first.to_integer)
							referenced_obj:= backend.retrieve_from_keys (field_type, keys, transaction)
							if not referenced_obj.is_empty then
								field_value:= build_new (field_type, referenced_obj.first, transaction, bookkeeping)
								reflection.set_reference_field (type.index_of (attr_cursor.item), Result, field_value)
							end
						end
					end
				end
			end
		ensure
			type_correct: Result.generating_type.type_id = type.type.type_id
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
