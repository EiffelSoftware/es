note
	description: "Class to perform all kinds of CRUD operations, either in an implicit or explicit transaction."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_CRUD_EXECUTOR [G -> ANY]
	-- Executes any CRUD operation (in a very crude and violent way:)

inherit
	PS_EIFFELSTORE_EXPORT

inherit {NONE}
 	REFACTORING_HELPER

create
	make_with_repository

feature --Access

	repository: PS_REPOSITORY
			-- The data repository on which 'Current' operates

	activation_strategy: PS_OBJECT_GRAPH_DEPTH
			-- The activation strategies for the different storage operations. Default is to take whatever is defined in repository.

feature -- Data retrieval

	execute_query (a_query: PS_QUERY [G])
			-- Run `a_query' against the repository.
		require
			query_not_executed: not a_query.is_executed
		local
			transaction: PS_TRANSACTION
		do
			create transaction.make (repository)
			execute_query_within_transaction (a_query, transaction)
		ensure
			query_executed: a_query.is_executed
		end


	--retrieve_all
			-- Retrieve all objects that are instances of class G.
		--do
			-- Same effect can be achieved by running an empty query against the CRUD_EXECUTOR
		--end

	--load_attribute (object: G; object_attribute: STRING)
			-- Load an object attribute which has not been previously loaded because of reference depth
		--do
			-- Function might be deleted, because it doesn't make much sense to load single attributes without projections.
		--end

	load_to_depth (object: G; depth: INTEGER)
			-- Load  `object' (assumed to be partially loaded) further to object graph depth `depth'.
		do
		end

feature -- Data manipulation

	insert (an_object: G)
			-- Insert `an_object' into the repository.
		require
			object_not_previously_loaded: not is_already_loaded (an_object)
		local
			transaction: PS_TRANSACTION
		do
			create transaction.make (repository)
			insert_within_transaction (an_object, transaction)
			transaction.commit
		end

	update (an_object: G)
			-- Write back changes of `an_object' into the repository.
		require
			object_previously_loaded: is_already_loaded (an_object)
		local
			transaction: PS_TRANSACTION
		do
			create transaction.make (repository)
			update_within_transaction (an_object, transaction)
			transaction.commit
		end

	delete (an_object: G)
			-- Delete `an_object' from the repository
		require
			object_previously_loaded: is_already_loaded (an_object)
		local
			transaction: PS_TRANSACTION
		do
			create transaction.make (repository)
			delete_within_transaction (an_object, transaction)
			transaction.commit
		end

	execute_deletion_query (a_query: PS_QUERY [G])
			-- Delete all objects that match the criteria defined in `a_query'
		require
			query_not_executed: not a_query.is_executed
		local
			transaction: PS_TRANSACTION
		do
			create transaction.make (repository)
			execute_deletion_query_within_transaction (a_query, transaction)
			transaction.commit
		end

feature -- Status

	is_already_loaded (an_object: G): BOOLEAN
			-- Has `an_object' been previously loaded from (or inserted to) the database?
		do
			fixme ("TODO")
			Result := false
		end

feature -- Transaction-based data retrieval and querying

	execute_query_within_transaction (a_query: PS_QUERY [G]; a_transaction: PS_TRANSACTION)
			-- Execute `a_query' within the transaction `a_transaction'.
		require
			query_not_executed: not a_query.is_executed
			same_repository: a_transaction.repository = Current.repository
		do
			repository.execute_query (a_query, a_transaction)
		ensure
			query_executed: a_query.is_executed
			transaction_set: a_query.transaction = a_transaction
		end

	insert_within_transaction (an_object: G; a_transaction: PS_TRANSACTION)
			-- Insert `an_object' within the transaction `a_transaction' into the repository.
		require
			same_repository: a_transaction.repository = Current.repository
			object_new_to_system: not is_already_loaded (an_object)
		do
			repository.insert (an_object, a_transaction)
		ensure
			-- object_known: is_already_loaded (an_object) -- Disabled because is_already_loaded not implemented yet
		end

	update_within_transaction (an_object: G; a_transaction: PS_TRANSACTION)
			-- Write back changes of `an_object' into the repository, within the transaction `a_transaction'.
		require
			same_repository: a_transaction.repository = Current.repository
			object_known: is_already_loaded (an_object)
		do
			repository.update (an_object, a_transaction)
		end

	delete_within_transaction (an_object: G; a_transaction: PS_TRANSACTION)
				-- Delete `an_object' within the transaction `a_transaction' from the repository.
		require
			same_repository: a_transaction.repository = Current.repository
			object_known: is_already_loaded (an_object)
		do
			repository.delete (an_object, a_transaction)
		end

	execute_deletion_query_within_transaction (a_query: PS_QUERY [G]; a_transaction: PS_TRANSACTION)
				-- Delete, within the transaction `a_transaction', all objects that match the criteria defined in `a_query'
		require
			query_not_executed: not a_query.is_executed
			same_repository: a_transaction.repository = Current.repository
		do
			repository.delete_query (a_query, a_transaction)
		end

	new_transaction: PS_TRANSACTION
			-- Create a new transaction to be used for this CRUD_EXECUTOR
		do
			create Result.make (repository)
		end

feature --Error handling

	has_error: BOOLEAN
		-- Did the last operation produce an error?

	last_error: detachable ANY
		-- Description of last error message
		require
			error_present: has_error
		do
			fixme ("TODO: How to represent errors? Strings or classes? What type of errors can occur?")
		end


feature {NONE} -- Initialization

	make_with_repository (a_repository: PS_REPOSITORY)
			-- Initialization for `Current'.
		do
			repository := a_repository
			create activation_strategy.make_rely_on_repository
		end

end
