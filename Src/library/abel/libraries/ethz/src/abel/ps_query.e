note
	description: "Represents a general query on objects of type G to a repository."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"


deferred class
	PS_QUERY [G -> ANY]


feature -- Access

	criteria: PS_CRITERION
			-- Criteria for `Current' query.


	result_cursor: PS_RESULT_SET [ANY]
			-- Iteration cursor containing the result of the query.
		deferred
		end


	transaction: PS_TRANSACTION
			-- The transaction in which this query is embedded
		require
			already_executed: is_executed
		do
			check attached transaction_impl as transact then
				Result:=transact
			end
		end


feature -- Status

	is_executed: BOOLEAN
			-- Has query been executed?


	is_object_query:BOOLEAN
			-- Is `Current' an instance of PS_OBJECT_QUERY?
		deferred
		end

	is_tuple_query:BOOLEAN
			-- Is `Current' an instance of PS_TUPLE_QUERY?
		do
			Result:= not is_object_query
		end


feature -- Basic operations

	set_criterion (a_criterion: PS_CRITERION)
			-- Set the criteria `a_criterion', against which the objects will be selected
		require
			set_before_execution: not is_executed
			only_predefined: not a_criterion.has_agent_criterion
			criterion_can_handle_objects: is_criterion_fitting_generic_type (a_criterion)
		do
			criteria := a_criterion
		ensure
			criteria_set: criteria = a_criterion
		end


feature -- Miscellaneous

	is_criterion_fitting_generic_type (a_criterion:PS_CRITERION): BOOLEAN
			-- Can `a_criterion' handle objects of type `G'?
		local
			reflection:INTERNAL
		do
			create reflection
			Result:= a_criterion.can_handle_object ( reflection.new_instance_of (reflection.generic_dynamic_type (Current, 1)))
		end


feature {PS_EIFFELSTORE_EXPORT} -- Internal

	register_as_executed (a_transaction: PS_TRANSACTION)
			-- Set `is_executed' to true and bind query to `a_transaction'
		require
			not_yet_executed: not is_executed
		do
			is_executed := True
			transaction_impl := a_transaction
		ensure
			is_executed = True
			transaction_set: transaction = a_transaction
		end

	class_name: STRING
			-- The name of the class `G'.
		local
			reflection:INTERNAL
		once
			create reflection
			Result:= reflection.class_name_of_type (reflection.generic_dynamic_type (Current, 1))
		end

	backend_identifier: INTEGER
			-- Identifier for the backend to recognize an already executed query

	set_identifier (identifier: INTEGER)
			-- Set backend_identifier with `identifier'
		do
			backend_identifier := identifier
		ensure
			identifier_set: backend_identifier=identifier
		end



feature {NONE} -- Implementation

	transaction_impl: detachable PS_TRANSACTION


feature {NONE} -- Initialization

	make
		-- Initialize Current
		deferred
		ensure
			not_executed: not is_executed
			query_result_after: result_cursor.after
			query_result_initialized: result_cursor.query = Current
			default_criterion: attached{PS_EMPTY_CRITERION} criteria
		end


	initialize
		do
			create {PS_EMPTY_CRITERION} criteria
			reset
		end

	reset
		do
			transaction_impl:= Void
			create_result_cursor
			result_cursor.set_query (Current)
			is_executed:= False
			backend_identifier:= 0
		ensure
			not_executed: not is_executed
			not_bound_to_transaction: transaction_impl = Void
			unrecognizable_to_backend: backend_identifier = 0
			criteria_unchanged: criteria = old criteria
		end

	create_result_cursor
		deferred
		end

invariant
	query_result_correctly_initialized: result_cursor.query = Current
	transaction_set_if_executed: is_executed implies transaction_impl /= Void
	not_executed_implies_after: not is_executed implies result_cursor.after

end
