note
	description: "Objects representing a general query."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"


	fixme: "[
			This class should be splitted into two subclasses, one returning objects and the other returning (readonly) tuples, 
			where the user can set a projection.
			]"

deferred class
	PS_QUERY [G -> ANY]

--create
--	make


feature {NONE} -- Creation

	make
			-- Create an new query on objects of type `G'.
		do
			create {PS_EMPTY_CRITERION} criteria.default_create
			create {PS_RESULT_SET [G]} query_result.make
			query_result.set_query (Current)
			is_executed := False
		ensure
			not_executed: not is_executed
			query_result_initialized: query_result.query = Current
		end


feature -- Access

	criteria: PS_CRITERION
			-- Criteria for `Current' query.


	query_result: PS_RESULT_SET [G]
			-- Iteration cursor containing the result of the query.
		require
			already_executed: is_executed
		attribute
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

	is_criterion_fitting_generic_type (a_criterion:PS_CRITERION): BOOLEAN
			-- Can `a_criterion' handle objects of type `G'?
		local
			reflection:INTERNAL
		do
			create reflection
			Result:= a_criterion.can_handle_object ( reflection.new_instance_of (reflection.dynamic_type_from_string (class_name)))
		end


feature -- Basic operations

	set_criterion (a_criterion: PS_CRITERION)
			-- Set the criteria `a_criterion', against which the objects will be selected
		require
			set_before_execution: not is_executed
			only_predefined: True
			-- fixme: when splitting the class, the base class should contain
			-- this precondition. It then has to be weakened for the object based query
			criterion_can_handle_objects: is_criterion_fitting_generic_type (a_criterion)
		do
			criteria := a_criterion
		ensure
			criteria_set: criteria = a_criterion
		end


feature {PS_EIFFELSTORE_EXPORT} -- Internal

	set_executed_to_true (a_transaction: PS_TRANSACTION)
			-- Set `is_executed' to true and bind query to `a_transaction'
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



feature {NONE}

	transaction_impl: detachable PS_TRANSACTION


feature -- Projections
	note
		fixme: "Move this to a descendant"

	--projection: ARRAY [STRING]
			-- Data to be included for projection.


--	set_projection (a_projection: ARRAY [STRING])
			-- Set `a_projection' to the current query.
--		do
--			fixme ("This should be in the creation procedure of the tuple query")			
--			projection := a_projection
--		ensure
--			projected_data_set: projection = a_projection
--		end


end
