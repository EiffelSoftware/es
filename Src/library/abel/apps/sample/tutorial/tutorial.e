note
	description: "The main TUTORIAL class."
	author: "Roman Schmocker, Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class TUTORIAL

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
		-- Set up a simple in-memory repository.
		local
			repository: PS_IN_MEMORY_REPOSITORY
		do
			create repository.make_empty
			create executor.make (repository)
			create factory
			create my_visitor
		end

feature -- Access

	executor: PS_CRUD_EXECUTOR
		-- The CRUD executor used throughout the tutorial.

	factory: PS_CRITERION_FACTORY
		-- A criterion factory.

	my_visitor: MY_PRIVATE_VISITOR
		-- A user-defined visitor to react to an error.

feature -- CRUD operations

	simple_query: LINKED_LIST [PERSON]
		-- Query all person objects from the active repository.
		local
			query:PS_OBJECT_QUERY [PERSON]
		do
			create Result.make
			create query.make
			executor.execute_query (query)

			across query as	query_result
			loop
				Result.extend (query_result.item)
			end
		end

	simple_insert_and_update (a_person: PERSON)
		-- Insert `a_person' into the current repository.
		require

		do
			executor.insert (a_person)
			a_person.celebrate_birthday
			executor.update (a_person)
		end

	delete_person (name: STRING)
		-- Delete the person called `name'.
		local
			query: PS_OBJECT_QUERY [PERSON]
		do
			-- First retrieve the person from the database.
			create query.make
			executor.execute_query (query)
			across query as query_result
			loop
				if query_result.item.last_name.is_equal (name) then

					-- Now delete the person.
					executor.delete (query_result.item)
				end
			end
		end


feature -- Failing write operations

	failing_update
		-- Try and fail to update a new person object.
		local
			a_person: PERSON
		do
			create a_person.make ("Albo", "Bitossi")
			executor.update (a_person)
				-- Results in a precondition violation.
		end

	failing_delete (name: STRING)
		-- Try and fail to delete a new person object.
		local
			a_person: PERSON
		do
			create a_person.make ("Albo", "Bitossi")
			executor.delete (a_person)
				-- Results in a precondition violation.
		end


feature -- Queries with criteria

	create_criteria_traditional : PS_CRITERION
		-- Create a new criterion using the traditional approach.
		do

			-- for predefined criteria.
			Result:=
				factory.new_predefined ("age", factory.less, 5)

			-- for agent criteria
			Result :=
				factory.new_agent (agent age_less_than (?, 5))
		end

	create_criteria_double_bracket : PS_CRITERION
		-- Create a new criteria using the double bracket syntax.
		do

			-- for predefined criteria
			Result:= factory[["age", factory.less, 5]]

			-- for agent criteria
			Result := factory[[agent age_less_than (?, 5)]]
		end

	search_albo_bitossi : PS_CRITERION
		-- Combining criteria.
		local
			first_name_criterion: PS_CRITERION
			last_name_criterion: PS_CRITERION
			age_criterion: PS_CRITERION
		do
			first_name_criterion:=
				factory[[ "first_name", factory.equals, "Albo" ]]

			last_name_criterion :=
				factory[[ "last_name", factory.equals, "Bitossi" ]]

			age_criterion :=
				factory[[ "age", factory.equals, 20 ]]

			Result := first_name_criterion and last_name_criterion and not age_criterion

			-- using double brackets for compactness.
			Result := factory[[ "first_name", "=", "Albo" ]]
				and factory[[ "last_name", "=", "Bitossi" ]]
				and not factory[[ "age", "=", 20 ]]
		end

feature -- Deletion queries

	delete_person_with_deletion_query (name: STRING)
		-- Delete `name' using a deletion query.
		local
			deletion_query: PS_OBJECT_QUERY [PERSON]
			criterion: PS_PREDEFINED_CRITERION
		do
			create deletion_query.make
			create criterion.make ("last_name", "=", name)
			deletion_query.set_criterion (criterion)
			executor.execute_deletion_query (deletion_query)
		end

feature -- Tuple queries

	print_all_last_names
		-- Print the last name of all PERSON objects.
		local
			query: PS_TUPLE_QUERY [PERSON]
			last_name_index: INTEGER
			single_result: TUPLE
		do
			create query.make
			-- Find out at which position in the tuple the last_name is returned.
			last_name_index := query.attribute_index ("last_name")

			from
				executor.execute_tuple_query (query)
			until
				query.result_cursor.after
			loop
				single_result := query.result_cursor.item
				print (single_result [last_name_index] )
			end
		end

	print_last_names_of_20_year_old
		-- Print the last name of all PERSON objects with age = 20.
		local
			query: PS_TUPLE_QUERY [PERSON]
		do
			create query.make

			-- Only return the last_name of persons.
			query.set_projection (<<"last_name">>)

			-- Only return persons with age = 20.
			query.set_criterion (factory [["age", "=", 20]])

			from
				executor.execute_tuple_query (query)
			until
				query.result_cursor.after
			loop
				-- As we only have the last_name in the tuple,
				-- its index has to be 1.
				print (query.result_cursor.item [1])
			end
		end

feature -- Transaction handling

	update_ages
		-- Increase everyone's age by one.
		local
			query: PS_OBJECT_QUERY [PERSON]
			transaction: PS_TRANSACTION
		do
			create query.make
			transaction := executor.new_transaction

			executor.execute_query_within_transaction (query, transaction)

			across query as query_result
			loop
				query_result.item.celebrate_birthday
				executor.update_within_transaction
					(query_result.item, transaction)
			end

			transaction.commit

			-- The commit may have failed.
			if transaction.has_error then
				if attached transaction.error.message as msg then
					print ("Commit has failed. Error: " + msg)
				end
			end
		end

feature -- Error handling

	do_something_with_error_handling
		-- Perform some operations. Deal with errors in case of a problem.
		do
			-- Some complicated operations.
		rescue
			my_visitor.visit (executor.last_error)
			if my_visitor.shall_retry then
				retry
			else
				-- The exception propagates upwards, and maybe
				-- another feature can handle it.
			end
		end

feature -- Utilities

	age_less_than (person: PERSON; age: INTEGER): BOOLEAN
		-- Age check on `person' used as an agent routine.
		require
			age_non_negative: age >= 0
		do
			Result:= person.age < age
		end
end
