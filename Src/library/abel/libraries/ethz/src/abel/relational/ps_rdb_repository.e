note
	description: "Main repository for a relational database backend. Responsible for assembling and disassembling objects into strings."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RDB_REPOSITORY

inherit
	PS_REPOSITORY

inherit {NONE}
	REFACTORING_HELPER

create
	make

feature {PS_EIFFELSTORE_EXPORT} -- Object query

	execute_query (query: PS_QUERY [ANY]; transaction: PS_TRANSACTION)
			-- Execute `query'.
		do
				-- Initialize query for calls to next_entry
			query.register_as_executed (transaction)
			--query.query_result.set_repo (current)
			retrieve_one_object (query)
		end

	next_entry (query: PS_QUERY [ANY])
			-- retrieves the next object. stores item directly into result_set
			-- in case of an error it is written into the transaction connected to the query
		do
			retrieve_one_object (query)
		end


feature {PS_EIFFELSTORE_EXPORT} -- Modification

	insert (object: ANY; transaction: PS_TRANSACTION)
			-- Insert `object' within `transaction' into `Current'
		local
			obj_metadata: PS_METADATA
			attributes: HASH_TABLE [STRING, STRING]
			i: INTEGER
			reflection: INTERNAL
			field_name: STRING
			primary_key: INTEGER
		do
			create reflection
			create attributes.make (reflection.field_count (object))
			obj_metadata := metadata.get_metadata (object)
			from
				i := 1
			until
				i > reflection.field_count (object)
			loop
				field_name := reflection.field_name (i, object)
				check attached reflection.field (i, object) as attr then
					attributes.put (attr.out, field_name)
				end
				i := i + 1
			end
			primary_key := strategy.insert (attributes, obj_metadata, transaction)
		end

	update (object: ANY; transaction: PS_TRANSACTION)
			-- Update `object' within `transaction'
		do
		end

	delete (object: ANY; transaction: PS_TRANSACTION)
			-- Delete `object' within `transaction' from `Current'
		do
		end

feature {NONE} -- Initialization

	make (a_strategy: PS_MAPPING_STRATEGY; user, password, db_name, host: STRING; port: INTEGER)
			-- Initialize strategy with `a_strategy'.
		do
			fixme ("Add an initialization procedure with PS_GENERIC_LAYOUT_STRATEGY as default")
			strategy := a_strategy
			create database.make
			database.set_username (user)
			database.set_password (password)
			database.set_database (db_name)
			database.set_host (host)
			database.set_port (port)
			database.connect
				--print (database.last_error_message)
			strategy.set_database (database)
			create metadata.make (database)
		ensure
			strategy_set: strategy = a_strategy
		end

feature -- Testing

	clean_db_for_testing
			-- Delete all entries from the table. This only works for PS_GENERIC_LAYOUT_STRATEGY.
		do
			database.execute_query ("DROP TABLE ps_value")
			print (database.last_error_message)
		end

feature {PS_EIFFELSTORE_EXPORT} -- Status

	metadata: PS_METADATA_MANAGER

	database: MYSQLI_CLIENT

	strategy: PS_MAPPING_STRATEGY

feature {NONE} -- Implementation

	retrieve_one_object (query: PS_QUERY [ANY])
			-- Retrieve a single object from the database and store result into `query'
		local
			reflection: INTERNAL
			obj: ANY
			obj_metadata: PS_METADATA
			values: detachable HASH_TABLE [STRING, STRING]
			i: INTEGER
			field_name: STRING
			found: BOOLEAN
		do
			create reflection
				-- See at generic argument. Retrieve PS_METADATA from the metadata manager.
			obj := reflection.new_instance_of (reflection.dynamic_type_from_string (reflection.class_name_of_type (reflection.generic_dynamic_type (query, 1))))
			obj_metadata := metadata.get_metadata (obj)
			from
			until
				found
			loop
					-- call strategy.retrieve_an_object
				values := strategy.retrieve_an_object (query, obj_metadata, query.transaction)
				if values = Void then
					query.result_cursor.set_entry (void)
					found := true
				else
						-- Create an empty object and put it into the cache (and maybe fill in strings and numeric values)
					from
						i := 1
					until
						i > reflection.field_count (obj)
					loop
						field_name := reflection.field_name (i, obj)
							--print (field_name)
						check attached values[field_name] as val then

							if obj_metadata.get_attribute_type (field_name).is_basic_type then
								if obj_metadata.get_attribute_type (field_name).name.has_substring ("STRING") then
									reflection.set_reference_field (i, obj, val)
								elseif obj_metadata.get_attribute_type (field_name).name.has_substring ("INTEGER") then
									reflection.set_integer_32_field (i, obj, val.to_integer_32)
								end -- todo: extend this list for all basic types
							end
						end
						i := i + 1
					end
						-- for each foreign key in the retrieved string set, call a recursive function to
						-- load all referenced items (will return objects...). Needs to first check the cache.
						-- Fill in all referenced objects.
						-- If the criteria have agents: perform a check if the newly created object matches. If no, start over...
					if query.criteria.is_satisfied_by (obj) then
						query.result_cursor.set_entry (obj)
						found := true
					end
				end
				-- Return object.
			end
		end

end
