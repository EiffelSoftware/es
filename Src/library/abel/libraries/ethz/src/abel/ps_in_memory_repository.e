note
	description: "Repository that stores all items in memory."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_IN_MEMORY_REPOSITORY

inherit
	PS_REPOSITORY

create
	make

feature {PS_EIFFELSTORE_EXPORT}

	execute_query (query: PS_QUERY [ANY]; transaction: PS_TRANSACTION)
			-- Execute `query'.
		local
			id: INTEGER
			private_cursor: ITERATION_CURSOR [ANY]
		do
			id := new_identifier
			check attached private_database[query.class_name] as list then
				private_cursor := list.new_cursor
			end
			resultset_to_cursor_map [id] := private_cursor
			query.set_identifier (id)
--			query.query_result.set_repo (Current)
			from
			until
				private_cursor.after or else query.criteria.is_satisfied_by (private_cursor.item)
			loop
				private_cursor.forth
			end
			if private_cursor.after then
				query.result_cursor.set_entry (Void)
			else
				query.result_cursor.set_entry (private_cursor.item.deep_twin)
			end
			query.register_as_executed (transaction)
		end

	next_entry (query: PS_QUERY [ANY])
			-- retrieves the next object. stores item directly into query_result
		local
			private_cursor: ITERATION_CURSOR [ANY]
		do
			check attached resultset_to_cursor_map [query.backend_identifier] as cursor then
				private_cursor := cursor
			end
			private_cursor.forth
			from
			until
				private_cursor.after or else query.criteria.is_satisfied_by (private_cursor.item)
			loop
				private_cursor.forth
			end
			if private_cursor.after then
				query.result_cursor.set_entry (Void)
			else
				query.result_cursor.set_entry (private_cursor.item.deep_twin)
			end
		end


feature {PS_EIFFELSTORE_EXPORT}-- Modification

	insert (object: ANY; transaction: PS_TRANSACTION)
			-- Insert `object' within `transaction' into `Current'
		local
			object_class: STRING
			new_list: LINKED_LIST [ANY]
			private_copy: ANY
			reflection_library: INTERNAL
		do
			create reflection_library
			object_class := reflection_library.class_name (object)
			if not private_database.has (object_class) then
				create new_list.make
				private_database.extend (new_list, object_class)
			end
			private_copy := object.deep_twin
			check attached private_database.item (object_class) as list then
				list.extend (private_copy)
			end
			cache.cache (object, private_copy)
		end

	update (object: ANY; transaction: PS_TRANSACTION)
			-- Update `object' within `transaction'
		local
			object_class: STRING
			reflection_library: INTERNAL
			private_copy: ANY
		do
			create reflection_library
			object_class := reflection_library.class_name (object)
			check attached cache.get_identifier (object) as identifier and attached private_database[object_class] as list then
				private_copy := identifier
				list.search (private_copy)
				private_copy := object.deep_twin
				list.replace (private_copy)
				cache.update_repo_link (object, private_copy)

			end

		end

	delete (object: ANY; transaction: PS_TRANSACTION)
			-- Delete `object' within `transaction' from `Current'
		do
		end

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create private_database.make (database_size)
			identifier_number := 1
			create resultset_to_cursor_map.make (max_reads)
			create cache.make
			create transaction_isolation_level
			create default_object_graph.make_default
		end

feature {NONE} -- Implementation


	database_size: INTEGER = 50
			-- Defines the capacity of the database.

	max_reads: INTEGER = 50
			-- Defines how many queries can be active at the same time.

	private_database: HASH_TABLE [LIST [ANY], STRING]
			-- The in-memory database

	resultset_to_cursor_map: HASH_TABLE [ITERATION_CURSOR [ANY], INTEGER]
			-- Maps a {PS_QUERY}.backend_identifier to an iteration cursor over the in-memory database


	new_identifier: INTEGER
			-- Create a new backend identifier for the query
			-- TODO: make this fault free...
		do
			Result := identifier_number
			identifier_number := identifier_number + 1
		end
	identifier_number: INTEGER


	cache: PS_OBJECT_CACHE [ANY]
			-- A cache to remember inserted/queried objects


feature {PS_EIFFELSTORE_EXPORT} -- Testing

	clean_db_for_testing
		-- Wipe out all data
		do
			make
		end


end
