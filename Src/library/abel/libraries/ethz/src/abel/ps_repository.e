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

end
