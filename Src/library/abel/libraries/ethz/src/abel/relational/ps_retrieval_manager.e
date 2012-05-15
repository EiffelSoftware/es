note
	description: "Responsible for correct retrieval of objects"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RETRIEVAL_MANAGER
inherit
	PS_EIFFELSTORE_EXPORT

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
					field_type_name := reflection.class_name_of_type (reflection.field_static_type_of_type (i, reflection.dynamic_type (new_object)))

					--print (field_name + ": " + field_type_name + " = " + field_val + "%N")

					if field_type_name.has_substring ("STRING") then
						reflection.set_reference_field (i, new_object, field_val)
					elseif field_type_name.has_substring ("INTEGER") then
						reflection.set_integer_32_field (i, new_object, field_val.to_integer_32)
					end

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





end
