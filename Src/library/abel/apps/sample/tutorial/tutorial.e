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

feature 	-- Tutorial exploration features

	explore
			-- Tutorial code.
		local
			p1, p2, p3: PERSON
		do
			print ("-o- ABEL Tutorial -o-")
			io.new_line
			print ("Insert 3 new persons in the database")
			io.new_line
			create p1.make ("Albo", "Bitossi")
			p1.celebrate_birthday
			executor.insert (p1)
			create p2.make ("Berno", "Citrini")
			p2.celebrate_birthday
			p2.celebrate_birthday
			p2.celebrate_birthday
			executor.insert (p2)
			create p3.make ("Dumbo", "Ermini")
			executor.insert (p3)
			print ("Query the database and print result")
			print_result (simple_query)
			print ("Update an existing person in the database and print result")
			p2.celebrate_birthday
			executor.update (p2)
			print_result (simple_query)
			print ("Delete Dumbo Ermini from the database and print result")
			executor.delete (p3)
			print_result (simple_query)
			-- Uncomment the following 2 lines to have a failing update of an object not known to ABEL
			--print ("A failing update...")
			--failing_update
			-- Uncomment the following 2 lines to have a failing update of an object not known to ABEL
			--print ("A failing delete...")			
			--failing_delete
			print ("Combined criterion example: search for an Albo Bitossi who is not 20")
			print_result (query_with_composite_criterion)
			print ("Delete Albo Bitossi using a deletion query")
			--delete_person_with_deletion_query ("Bitossi")
			--print_result (simple_query)
			print ("Print last names of all person objects")
			print_all_last_names

		end

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
			explore
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
		-- Query all persons from repository.
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

	query_with_composite_criterion: LINKED_LIST [PERSON]
		-- Query using a composite criterion.
		local
			query: PS_OBJECT_QUERY [PERSON]
		do
			create Result.make
			create query.make
			query.set_criterion (composite_search_criterion)
			executor.execute_query (query)

			across query as	query_result
			loop
				Result.extend (query_result.item)
			end
		end

feature -- Failing write operations

	failing_update
		-- Try and fail to update a new person object.
		local
			a_person: PERSON
		do
			create a_person.make ("Bob", "Barath")
			executor.update (a_person)
				-- Results in a precondition violation.
		end

	failing_delete
		-- Try and fail to delete a new person object.
		local
			a_person: PERSON
		do
			create a_person.make ("Cersei", "Lannis")
			executor.delete (a_person)
				-- Results in a precondition violation.
		end

feature -- Queries with criteria

	composite_search_criterion : PS_CRITERION
		-- Combining criteria.
		local
			first_name_criterion: PS_CRITERION
			last_name_criterion: PS_CRITERION
			age_criterion: PS_CRITERION
		do
			first_name_criterion :=
				factory[[ "first_name", factory.equals, "Albo" ]]

			last_name_criterion :=
				factory[[ "last_name", factory.equals, "Bitossi" ]]

			age_criterion :=
				factory[[ agent age_more_than (?, 20)]]

			Result := first_name_criterion and last_name_criterion and not age_criterion

			-- using double brackets for compactness (comment this Result to get the previous one).
			Result := factory[[ "first_name", "=", "Albo" ]]
				and factory[[ "last_name", "=", "Bitossi" ]]
				and not factory[[ agent age_more_than (?, 20) ]]
		end

feature -- Deletion queries

	delete_person_with_deletion_query (last_name: STRING)
		-- Delete person with `last_name' using a deletion query.
		local
			deletion_query: PS_OBJECT_QUERY [PERSON]
			criterion: PS_PREDEFINED_CRITERION
		do
			create deletion_query.make
			create criterion.make ("last_name", "=", last_name)
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

	age_more_than (person: PERSON; age: INTEGER): BOOLEAN
		-- Age check on `person' used as an agent routine.
		require
			age_non_negative: age >= 0
		do
			Result:= person.age > age
		end

	print_result (lis: LINKED_LIST [PERSON])
		-- Utility to print a query result.
		do
			across lis as local_list
			loop
				io.new_line
				print (local_list.item.first_name + " ")
				print (local_list.item.last_name + ", age: ")
				print (local_list.item.age)
			end
			io.new_line
		end
end
