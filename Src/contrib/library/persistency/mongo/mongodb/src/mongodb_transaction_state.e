note
	description: "[
			Object Representing Transaction States
			This enum describes the current transaction state of a session.
            
			Transaction States:
			MONGOC_TRANSACTION_NONE - There is no transaction in progress.
			MONGOC_TRANSACTION_STARTING - A transaction has been started, but no operation has been sent to the server.
			MONGOC_TRANSACTION_IN_PROGRESS - A transaction is in progress.
			MONGOC_TRANSACTION_COMMITTED - The transaction was committed.
			MONGOC_TRANSACTION_ABORTED - The transaction was aborted.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_transaction_state_t", "src=http://mongoc.org/libmongoc/current/mongoc_transaction_state_t.html", "protocol=uri"

class
	MONGODB_TRANSACTION_STATE

inherit
	MONGODB_ENUM

create
	make

feature {NONE} -- Initialization

	make
			-- Create an instance with default state set as MONGOC_TRANSACTION_NONE.
		do
			value := 0
		end

feature -- Change Element

	mark_transaction_none
		do
			value := 0
		end

	mark_transaction_starting
		do
			value := 1
		end

	mark_transaction_in_progress
		do
			value := 2
		end

	mark_transaction_committed
		do
			value := 3
		end

	mark_transaction_aborted
		do
			value := 4
		end

feature -- Status Report

	is_valid_value (a_value: INTEGER): BOOLEAN
		do
			Result := ((a_value = 0) or else
				(a_value = 1 ) or else
				(a_value = 2 ) or else
				(a_value = 3 ) or else
				(a_value = 4 ))
		end

	is_transaction_none: BOOLEAN
		do
			Result := value = 0
		end

	is_transaction_starting: BOOLEAN
		do
			Result := value = 1
		end

	is_transaction_in_progress: BOOLEAN
		do
			Result := value = 2
		end

	is_transaction_committed: BOOLEAN
		do
			Result := value = 3
		end

	is_transaction_aborted: BOOLEAN
		do
			Result := value = 4
		end

end

