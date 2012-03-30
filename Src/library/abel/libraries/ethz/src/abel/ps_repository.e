note
	description: "[
		Common ancestor for all repository strategies.
		Descendants implement support for different kinds of databases.
		The repository object receives QUERYs from a CRUD_EXECUTOR object and returns ANY objects.
	]"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_REPOSITORY

inherit
	PS_EIFFELSTORE_EXPORT

feature -- Default values

	default_object_graph: PS_OBJECT_GRAPH_DEPTH
		-- Default object graph depth

	transaction_isolation_level:ANY
		-- Transaction isolation level



feature {PS_EIFFELSTORE_EXPORT} -- Object query

	execute_query (query: PS_QUERY [ANY]; transaction: PS_TRANSACTION)
			-- Execute `query'.
		require
			not_executed: not query.is_executed
			transaction_repository_correct: transaction.repository = Current
		deferred
		ensure
			executed: query.is_executed
			transaction_set: query.transaction = transaction
		end

	next_entry (query: PS_QUERY [ANY])
			-- retrieves the next object. stores item directly into result_set
			-- in case of an error it is written into the transaction connected to the query
		require
			not_after: not query.result_cursor.after
			already_executed: query.is_executed
			query_executed_by_me: query.transaction.repository = Current
		deferred
		end


feature {PS_EIFFELSTORE_EXPORT} -- Modification

	insert (object: ANY; transaction: PS_TRANSACTION)
			-- Insert `object' within `transaction' into `Current'
		require
			transaction_repository_correct: transaction.repository = Current
		deferred
		end

	update (object: ANY; transaction: PS_TRANSACTION)
			-- Update `object' within `transaction'
		require
			transaction_repository_correct: transaction.repository = Current
		deferred
		end

	delete (object: ANY; transaction: PS_TRANSACTION)
			-- Delete `object' within `transaction' from `Current'
		require
			transaction_repository_correct: transaction.repository = Current
		deferred
		end

	delete_query (query: PS_QUERY [ANY]; transaction: PS_TRANSACTION)
			-- Delete all objects that match the criteria in `query' from `Current' repository within transaction `transaction'
		require
			not_executed: not query.is_executed
			transaction_repository_correct: transaction.repository = Current
		do
			from
				execute_query (query, transaction)
			until
				query.result_cursor.after
			loop
				delete (query.result_cursor.item, transaction)
			end
		end

feature {PS_EIFFELSTORE_EXPORT} -- Transaction handling

	commit_transaction (transaction: PS_TRANSACTION)
		-- Explicitly commit the transaction
		require
			transaction_alive: transaction.is_active
			no_error: not transaction.has_error
			repository_correct: transaction.repository = Current
			not_readonly: not transaction.is_readonly
		do

		end

	rollback_transaction (transaction: PS_TRANSACTION)
		-- Rollback the transaction
		require
			transaction_alive: transaction.is_active
			repository_correct: transaction.repository = Current
			not_readonly: not transaction.is_readonly
		do

		end

end
