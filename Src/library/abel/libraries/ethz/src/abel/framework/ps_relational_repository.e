note
	description: "A repository that holds values in memory, but takes objects apart and stores them in a relational-like fashion"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RELATIONAL_REPOSITORY

inherit
	PS_REPOSITORY


create make

feature {PS_EIFFELSTORE_EXPORT} -- Object query

	execute_query (query: PS_OBJECT_QUERY [ANY]; transaction: PS_TRANSACTION)
			-- Execute `query'.
		do
			id_manager.register_transaction (transaction)
			if attached {PS_OBJECT_QUERY[ANY]} query as obj_query then
				retriever.setup_query (obj_query, transaction)
			end
		rescue
			default_transactional_rescue (transaction)
		end

	next_entry (query: PS_OBJECT_QUERY [ANY])
			-- retrieves the next object. stores item directly into result_set
			-- in case of an error it is written into the transaction connected to the query
		do
			id_manager.register_transaction (query.transaction)
			if attached {PS_OBJECT_QUERY[ANY]} query as obj_query then
				retriever.next_entry (obj_query)
			end
		rescue
			default_transactional_rescue (query.transaction)
		end


	execute_tuple_query (tuple_query: PS_TUPLE_QUERY[ANY]; transaction: PS_TRANSACTION)
		-- Execute the tuple query `tuple_query' within the readonly transaction `transaction'
		do
			fixme ("TODO")
		end


	next_tuple_entry (tuple_query: PS_TUPLE_QUERY[ANY])
		-- Retrieves the next tuple and stores it in `query.result_cursor'
		do
			fixme ("TODO")
		end


feature {PS_EIFFELSTORE_EXPORT} -- Modification

	insert (object: ANY; transaction: PS_TRANSACTION)
			-- Insert `object' within `transaction' into `Current'
		do
			id_manager.register_transaction (transaction)
			disassembler.execute_disassembly (object, (create {PS_WRITE_OPERATION}).insert, transaction)
			executor.perform_operations (planner.generate_plan (disassembler.disassembled_object), transaction)
		rescue
			default_transactional_rescue (transaction)
		end

	update (object: ANY; transaction: PS_TRANSACTION)
			-- Update `object' within `transaction'
		do
			id_manager.register_transaction (transaction)
			disassembler.execute_disassembly (object, (create {PS_WRITE_OPERATION}).update, transaction)
			executor.perform_operations (planner.generate_plan (disassembler.disassembled_object), transaction)
		rescue
			default_transactional_rescue (transaction)
		end

	delete (object: ANY; transaction: PS_TRANSACTION)
			-- Delete `object' within `transaction' from `Current'
		do
			id_manager.register_transaction (transaction)
			disassembler.execute_disassembly (object, (create {PS_WRITE_OPERATION}).delete, transaction)
			executor.perform_operations (planner.generate_plan (disassembler.disassembled_object), transaction)
			fixme ("TODO: fix this for depth > 1")
			id_manager.delete_identification (object, transaction)
		rescue
			default_transactional_rescue (transaction)
		end


feature {PS_EIFFELSTORE_EXPORT} -- Transaction handling

	commit_transaction (transaction: PS_TRANSACTION)
		-- Explicitly commit the transaction
		do
			if id_manager.can_commit (transaction) then
				backend.commit (transaction) -- can fail and raise an exception
				id_manager.commit (transaction)
				transaction.declare_as_successful
			else
				rollback_transaction (transaction, False)
			end
		rescue
			default_transactional_rescue (transaction)
		end

	rollback_transaction (transaction: PS_TRANSACTION; manual_rollback: BOOLEAN)
		-- Rollback the transaction
		do
			backend.rollback (transaction)
			id_manager.rollback (transaction)
			transaction.declare_as_aborted
		end


feature {PS_EIFFELSTORE_EXPORT} -- Testing

	clean_db_for_testing
		-- Wipe out all data
		do
			-- Ugly, but it works for now...
			if attached{PS_GENERIC_LAYOUT_SQL_BACKEND} backend as sql_backend then
				sql_backend.wipe_out_all
			else
				create {PS_IN_MEMORY_DATABASE} backend.make
			end

			make (backend)
		end

feature {PS_EIFFELSTORE_EXPORT} -- Status Report


	can_handle (object:ANY): BOOLEAN
		-- Can `Current' handle the object `object'?
		do
			to_implement ("Disassemble object and then ask backend for each part")
			Result:=True
		end

feature{NONE} -- Initialization

	make (a_backend: PS_BACKEND_STRATEGY)
		-- Initialize `Current'
		local
			special_handler: PS_SPECIAL_COLLECTION_HANDLER
		do
			create transaction_isolation_level
			set_transaction_isolation_level (transaction_isolation_level.repeatable_read)
			create default_object_graph.make
			create id_manager.make
			create planner.make
			create disassembler.make (id_manager, default_object_graph)
		--	create memory_db.make
			backend:= a_backend
			create executor.make (backend)
			create retriever.make (backend, id_manager)

			create special_handler.make
			add_collection_handler (special_handler)
		end

feature -- Initialization

	add_collection_handler (handler: PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]])
		-- Add a handler for a specific type of collections
		do
			retriever.add_handler (handler)
			disassembler.add_handler (handler)
		end

feature {PS_EIFFELSTORE_EXPORT}

	disassembler:PS_OBJECT_DISASSEMBLER
	planner:PS_WRITE_PLANNER
	executor: PS_WRITE_EXECUTOR
--	memory_db: PS_IN_MEMORY_DATABASE
	backend: PS_BACKEND_STRATEGY
	retriever:PS_RETRIEVAL_MANAGER


end
