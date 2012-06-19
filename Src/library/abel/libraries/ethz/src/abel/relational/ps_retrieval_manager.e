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

	make (a_backend: PS_BACKEND_STRATEGY; an_id_manager: PS_OBJECT_IDENTIFICATION_MANAGER)
		-- Initialize `Current'
		do
			backend:= a_backend
			id_manager:= an_id_manager
			create query_to_cursor_map.make (100)
			create bookkeeping_manager.make (100)
			create collection_handlers.make
			create metadata_manager.make_new

		end

	backend:PS_BACKEND_STRATEGY
		-- The storage backend

	metadata_manager: PS_METADATA_MANAGER

	id_manager: PS_OBJECT_IDENTIFICATION_MANAGER
--	query_to_cursor_map: HASH_TABLE[ITERATION_CURSOR[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]], INTEGER]

--	query_to_cursor_map: HASH_TABLE[ITERATION_CURSOR[PS_RETRIEVED_OBJECT], INTEGER]
	query_to_cursor_map: HASH_TABLE[ITERATION_CURSOR[ANY], INTEGER]

	bookkeeping_manager: HASH_TABLE[HASH_TABLE[ANY, INTEGER], INTEGER]
		-- keeps track of already loaded object for each query

	new_identifier: INTEGER
			-- Get a new identifier for a query
		do
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

	has_handler (type: PS_TYPE_METADATA):BOOLEAN
		do
			Result:= across collection_handlers as handler some handler.item.can_handle_type (type.type)  end
		end

	get_handler (type: PS_TYPE_METADATA): PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]]
		require
			has_handler (type)
		local
			res: detachable PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]]
		do
			across collection_handlers as handler loop
				if handler.item.can_handle_type(type.type) then
					res:= handler.item
				end
			end
			Result:= attach (res)
		end

	setup_query (query:PS_OBJECT_QUERY[ANY]; transaction:PS_TRANSACTION)
		local
			results: ITERATION_CURSOR[ANY]
			bookkeeping_table:HASH_TABLE[ANY, INTEGER]
			reflection: INTERNAL
			type: PS_TYPE_METADATA
		do
			create reflection
			query.set_identifier (new_identifier)
			query.register_as_executed (transaction)
			type:= metadata_manager.create_metadata_from_type (query.generic_type)

			if has_handler (type) then
				results:= backend.retrieve_all_collections (type, transaction)
			else
				results:=backend.retrieve (type, query.criteria, create{LINKED_LIST[STRING]}.make, transaction)
			end

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
--			results: ITERATION_CURSOR[PS_RETRIEVED_OBJECT]
			current_object:PS_RETRIEVED_OBJECT
			new_object:ANY
			found:BOOLEAN
			reflection:INTERNAL
			new_type:INTEGER
			type: PS_TYPE_METADATA
		do
			create reflection

			type:= metadata_manager.create_metadata_from_type (query.generic_type)

			if attached {ITERATION_CURSOR[PS_RETRIEVED_OBJECT]} query_to_cursor_map[query.backend_identifier] as results then
				from
					found:= False
				until
					found or results.after
				loop

					current_object := results.item
					new_object:= build_new (type, current_object, transaction, bookkeeping)

					if query.criteria.is_satisfied_by (new_object) then
						query.result_cursor.set_entry (new_object)
						found := True
					else
						results.forth
					end
				end
				if results.after then
					query.result_cursor.set_entry (Void)
				end

			else
				check attached {ITERATION_CURSOR[PS_RETRIEVED_OBJECT_COLLECTION]} query_to_cursor_map[query.backend_identifier] as direct_collection then

					if direct_collection.after then
						query.result_cursor.set_entry (Void)
					else
						new_object:= build_object_collection (type, direct_collection.item, get_handler (type), transaction, bookkeeping)
--						direct_collection.forth
						query.result_cursor.set_entry (new_object)
					end
				end

			end
		end


	build_new(type:PS_TYPE_METADATA; obj:PS_RETRIEVED_OBJECT; transaction:PS_TRANSACTION; bookkeeping:HASH_TABLE[ANY, INTEGER]): ANY
		require
			obj.class_metadata.name.is_equal (type.class_of_type.name)
		local
			reflection:INTERNAL
			field_value: ANY
			field_type:PS_TYPE_METADATA
			keys: LINKED_LIST [INTEGER]
			referenced_obj: LIST[PS_RETRIEVED_OBJECT]
			collection_result: PS_RETRIEVED_OBJECT_COLLECTION
		do
			if bookkeeping.has (obj.primary_key+ obj.class_metadata.name.hash_code) then
				Result:= attach (bookkeeping[obj.primary_key+ obj.class_metadata.name.hash_code])
			else
				create reflection
				Result:= reflection.new_instance_of  (type.type.type_id)
				bookkeeping.extend (Result, obj.primary_key + obj.class_metadata.name.hash_code)
				id_manager.identify (Result, transaction)
				backend.key_mapper.add_entry (id_manager.get_identifier_wrapper (Result, transaction), obj.primary_key, transaction)

				across obj.attributes as attr_cursor loop
					-- Set all the attributes
					if not try_basic_attribute (Result, obj.attribute_value (attr_cursor.item).first, type.index_of (attr_cursor.item)) then

						field_type:= type.attribute_type (attr_cursor.item)

						print (field_type.type.out + has_handler (field_type).out + "%N")
						if has_handler (field_type) then -- Collection
							fixme ("relational collections")
							collection_result:= backend.retrieve_objectoriented_collection (field_type, obj.attribute_value (attr_cursor.item).first.to_integer, transaction)
							--across collection_result.collection_items as item loop print (item.item.first)  end
							reflection.set_reference_field (type.index_of (attr_cursor.item), Result, build_object_collection (field_type, collection_result, get_handler (field_type), transaction, bookkeeping))
						else
							-- Referenced object
							if not obj.attribute_value (attr_cursor.item).first.is_empty then
								referenced_obj:= backend.retrieve_from_single_key (field_type, obj.attribute_value (attr_cursor.item).first.to_integer, transaction)
								if not referenced_obj.is_empty then
									field_value:= build_new (field_type, referenced_obj.first, transaction, bookkeeping)
									reflection.set_reference_field (type.index_of (attr_cursor.item), Result, field_value)
								end
							end
						end
					end
				end
			end
		ensure
			type_correct: Result.generating_type.type_id = type.type.type_id
		end

	build_relational_collection (type: PS_TYPE_METADATA; collection: PS_RETRIEVED_RELATIONAL_COLLECTION; handler: PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]]; transaction: PS_TRANSACTION; bookkeeping: HASH_TABLE[ANY, INTEGER]): ANY
		do
			Result:= handler.build_relational_collection (type, build_collection_items (type, collection, transaction, bookkeeping))
			id_manager.identify (Result, transaction)
		end

	build_object_collection (type: PS_TYPE_METADATA; collection: PS_RETRIEVED_OBJECT_COLLECTION; handler: PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]]; transaction: PS_TRANSACTION; bookkeeping: HASH_TABLE[ANY, INTEGER]): ANY
		do
			Result:= handler.build_collection (type, build_collection_items (type, collection, transaction, bookkeeping), collection)
			id_manager.identify (Result, transaction)
		end


	build_collection_items (type: PS_TYPE_METADATA; collection: PS_RETRIEVED_COLLECTION; transaction: PS_TRANSACTION; bookkeeping: HASH_TABLE[ANY, INTEGER]): LINKED_LIST[detachable ANY]

		local
			collection_items: LINKED_LIST[detachable ANY]
			retrieved_item: LIST[PS_RETRIEVED_OBJECT]
		do
			-- Build every object of the list and store it in collection_items
			create Result.make

			print (type.type.out + "%N" + type.generic_type (1).type.out + "%N")

			if type.generic_type (1).is_basic_type then
				across collection.collection_items as items loop
					fixme("TODO: all other basic types")
					Result.extend (items.item.first.to_integer)

				end

			else

				across collection.collection_items as items loop
					-- If the collection was empty at `item', add a Void value
					if items.item.first.to_integer = 0 then
						Result.extend (Void)
					else
					-- Get and build the object
						retrieved_item:= backend.retrieve_from_single_key (type.generic_type (1), items.item.first.to_integer, transaction)
						if not retrieved_item.is_empty then
							Result.extend (build_new (type.generic_type (1), retrieved_item.first, transaction, bookkeeping))
						else
							Result.extend (Void)
						end
					end
				end
			end
		end


--	try_collection (obj:ANY;type:PS_TYPE_METADATA; attr_name:STRING; value: PS_PAIR[STRING, STRING]; transaction:PS_TRANSACTION; bookkeeping: HASH_TABLE[ANY, INTEGER]):BOOLEAN
--		local
--			reflection:INTERNAL
--			field_type:PS_TYPE_METADATA
--			collection_result: PS_RETRIEVED_OBJECT_COLLECTION
--		do
--			create reflection
--			field_type:= type.attribute_type (attr_name)
--
--			Result:= has_handler (field_type)

--			if Result then -- collection
--				fixme ("relational collections")
--				collection_result:= backend.retrieve_objectoriented_collection (field_type, value.first.to_integer, transaction)
--				reflection.set_reference_field (type.index_of (attr_name), obj, build_object_collection (field_type, collection_result, get_handler (field_type), transaction, bookkeeping))
--			end
--		end

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
