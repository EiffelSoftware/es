note
	description: "Tests ABELs transaction capabilities"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_TRANSACTION_TESTS

inherit
	PS_TEST_PROVIDER
	THREAD_CONTROL undefine default_create end

create make

feature {PS_REPOSITORY_TESTS}

	test_no_lost_update
		local
			some_person: PERSON
			t1, t2: PS_TRANSACTION
			q1, q2: PS_OBJECT_QUERY[PERSON]
		do
			create some_person.make ("first_name", "last_name", 0)
			executor.insert (some_person)

			t1:= executor.new_transaction
			t2:= executor.new_transaction
			create q1.make
			create q2.make

			-- Simulate a race condition between two transactions that want to update some_person
			-- t1 reads some_person
			executor.execute_query_within_transaction (q1, t1)

			-- t2 reads, updates and commits
			executor.execute_query_within_transaction (q2, t2)
			q2.result_cursor.item.add_item
			executor.update_within_transaction (q2.result_cursor.item, t2)
			t2.commit

			-- t2 now updates, but it has to fail at commit time
			q1.result_cursor.item.add_item
			executor.update_within_transaction (q1.result_cursor.item, t1)
			t1.commit

			assert ("The transaction should be aborted", t1.has_error and then attached{PS_TRANSACTION_ERROR} t1.error)
			repository.clean_db_for_testing
		end


	test_no_dirty_reads
		-- Test if a dirty read can happen.
		-- Please note that this test will very likely deadlock in a lock-based transaction management system (except if there is some sort of timeout).
		local
			some_person: PERSON
			t1, t2: PS_TRANSACTION
			q1, q2, q3: PS_OBJECT_QUERY[PERSON]
		do
			create some_person.make ("first_name", "last_name", 0)
			executor.insert (some_person)

			t1:= executor.new_transaction
			t2:= executor.new_transaction
			create q1.make
			create q2.make

			-- Simulate a dirty read
			-- t1 reads and updates some_person
			executor.execute_query_within_transaction (q1, t1)
			q1.result_cursor.item.add_item
			executor.update_within_transaction (q1.result_cursor.item, t1)

			-- t2 reads, updates and commits
			executor.execute_query_within_transaction (q2, t2)
			q2.result_cursor.item.add_item
			executor.update_within_transaction (q2.result_cursor.item, t2)
			t2.commit

			-- t1 now does a rollback
			t1.rollback

			create q3.make
			executor.execute_query (q3)
			-- Now ensure that t2 has not read the dirty value
			assert ("The items_owned attribute is equal to two, which implies that t2 has read a dirty value", q3.result_cursor.item.items_owned < 2)
			repository.clean_db_for_testing

		end


	test_repeatable_read
		-- Test if a non-repeatable read can happen
		local
			some_person: PERSON
			t1, t2: PS_TRANSACTION
			q1, q2, q3: PS_OBJECT_QUERY[PERSON]
		do
			create some_person.make ("first_name", "last_name", 0)
			executor.insert (some_person)

			t1:= executor.new_transaction
			t2:= executor.new_transaction
			create q1.make
			create q2.make
			create q3.make

			-- Simulate a non-repeatable read
			-- t1 reads some_person
			executor.execute_query_within_transaction (q1, t1)

			-- t2 updates some_person and commits
			executor.execute_query_within_transaction (q2, t2)
			q2.result_cursor.item.add_item
			executor.update_within_transaction (q2.result_cursor.item, t2)
			t2.commit

			-- t1 reads again some_person
			executor.execute_query_within_transaction (q3, t1)

			-- Now ensure that t1 has read the same value twice
			assert ("T1 has suffered a non-repeadable read", q1.result_cursor.item.items_owned = q2.result_cursor.item.items_owned)
			repository.clean_db_for_testing

		end


	test_correct_insert_rollback
		-- Test if an object inserted within an aborted transaction gets removed correctly
		local
			some_person: PERSON
			t1: PS_TRANSACTION
			q1, q2: PS_OBJECT_QUERY[PERSON]
		do
			create some_person.make ("first_name", "last_name", 0)
			t1:= executor.new_transaction
			create q1.make
			create q2.make

			executor.insert_within_transaction (some_person, t1)
			executor.execute_query_within_transaction (q1, t1)
			assert ("Person not inserted", not q1.result_cursor.after)

			t1.rollback

			executor.execute_query (q2)
			assert ("Result not empty", q2.result_cursor.after)
			assert ("Person not properly removed", not executor.is_already_loaded (some_person) and not executor.is_already_loaded (q1.result_cursor.item))

			repository.clean_db_for_testing
		end


	test_correct_update_rollback
		-- Test if an object updated within an aborted transaction gets rolled back correctly
		local
			some_person: PERSON
			t1: PS_TRANSACTION
			q1, q2: PS_OBJECT_QUERY[PERSON]
		do
			create some_person.make ("first_name", "last_name", 0)
			executor.insert (some_person)
			t1:= executor.new_transaction
			create q1.make
			create q2.make

			executor.execute_query_within_transaction (q1, t1)
			q1.result_cursor.item.add_item
			executor.update_within_transaction (q1.result_cursor.item, t1)

			executor.execute_query_within_transaction (q2, t1)
			assert ("Not updated correctly", q2.result_cursor.item.is_deep_equal (q1.result_cursor.item))

			t1.rollback

			q2.reset
			executor.execute_query (q2)
			assert ("Update not rolled back", q2.result_cursor.item.is_deep_equal (some_person))
			repository.clean_db_for_testing
		end



	test_correct_delete_rollback
		-- Test if an object deleted within an aborted transaction gets inserted again
		local
			some_person: PERSON
			t1: PS_TRANSACTION
			q1, q2: PS_OBJECT_QUERY[PERSON]
		do
			create some_person.make ("first_name", "last_name", 0)
			executor.insert (some_person)
			t1:= executor.new_transaction
			create q1.make
			create q2.make

			executor.delete_within_transaction (some_person, t1)
			executor.execute_query_within_transaction (q1, t1)
			assert ("Not deleted correctly", q1.result_cursor.after)

			t1.rollback

			executor.execute_query (q2)
			assert ("Item not present in database", not q2.after)
			asert ("Object not known any more", executor.is_already_loaded (some_person))
			repository.clean_db_for_testing
		end


end
