note
	description: "A repository that holds values in memory, but takes objects apart and stores them in a relational-like fashion"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RELATIONA_IN_MEMORY_REPOSITORY

inherit
	PS_REPOSITORY

create make

feature {PS_EIFFELSTORE_EXPORT} -- Object query

	execute_query (query: PS_QUERY [ANY]; transaction: PS_TRANSACTION)
			-- Execute `query'.
		do
			if attached {PS_OBJECT_QUERY[ANY]} query as obj_query then
				retriever.setup_query (obj_query, transaction)
			end
		end

	next_entry (query: PS_QUERY [ANY])
			-- retrieves the next object. stores item directly into result_set
			-- in case of an error it is written into the transaction connected to the query
		do
			if attached {PS_OBJECT_QUERY[ANY]} query as obj_query then
				retriever.next_entry (obj_query)
			end
		end


feature {PS_EIFFELSTORE_EXPORT} -- Modification

	insert (object: ANY; transaction: PS_TRANSACTION)
			-- Insert `object' within `transaction' into `Current'
		do
			disassembler.execute_disassembly (object, (create {PS_WRITE_OPERATION}).insert)
			executor.perform_operations (planner.generate_plan (disassembler.disassembled_object), transaction)
		end

	update (object: ANY; transaction: PS_TRANSACTION)
			-- Update `object' within `transaction'
		do
			disassembler.execute_disassembly (object, (create {PS_WRITE_OPERATION}).update)
			executor.perform_operations (planner.generate_plan (disassembler.disassembled_object), transaction)
			--check false end
		end

	delete (object: ANY; transaction: PS_TRANSACTION)
			-- Delete `object' within `transaction' from `Current'
		do
			disassembler.execute_disassembly (object, (create {PS_WRITE_OPERATION}).delete)
			executor.perform_operations (planner.generate_plan (disassembler.disassembled_object), transaction)

		end

feature {PS_EIFFELSTORE_EXPORT} -- Testing

	clean_db_for_testing
		-- Wipe out all data
		do
			make
		end

feature{NONE} -- Initialization

	make
		-- Initialize `Current'
		do
			create transaction_isolation_level
			create default_object_graph.make_default
			create id_manager.make
			create disassembler.make (id_manager, default_object_graph)
			create planner.make
			create memory_db.make
			create executor.make (memory_db)
			create retriever.make (memory_db)

			create special_handler.make
			memory_db.add_handler (special_handler)
			retriever.add_handler (special_handler)
			disassembler.add_handler (special_handler)
		end

feature {PS_EIFFELSTORE_EXPORT}

	disassembler:PS_OBJECT_DISASSEMBLER
	planner:PS_WRITE_PLANNER
	executor: PS_WRITE_EXECUTOR
	memory_db: PS_IN_MEMORY_DATABASE
	retriever:PS_RETRIEVAL_MANAGER

	special_handler: PS_SPECIAL_COLLECTION_HANDLER

end
