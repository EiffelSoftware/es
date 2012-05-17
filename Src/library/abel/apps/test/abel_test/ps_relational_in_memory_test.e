note
	description: "Tests the relational stack with an in-memory 'database'."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RELATIONAL_IN_MEMORY_TEST
inherit
	PS_CRUD_TESTS
	PS_CRITERIA_TESTS


feature{NONE}

	on_prepare
		do
			create int_repo.make
			repository := int_repo
			initialize_tests_general
			initialize_criteria_tests
			initialize_crud_tests
		end


	int_repo: PS_RELATIONA_IN_MEMORY_REPOSITORY

feature

	test_criteria_in_relational_memory
	do
		test_criteria_agents
		test_criteria_predefined
		test_criteria_agents_and_predefined
	end


	test_crud_flat_in_memory
		do
			test_flat_class_store
			test_flat_class_all_crud
		end

--	test_crud_structures_in_memory
--		do
--			test_data_structures_store
--			test_update_on_reference
--		end




	test_initial_insert
		local
			ref_executor: PS_CRUD_EXECUTOR[REFERENCE_CLASS_1]
			query:PS_OBJECT_QUERY[REFERENCE_CLASS_1]
			orig, one, two, three:REFERENCE_CLASS_1
			eq: BOOLEAN
		do
			repository.clean_db_for_testing
--			flat_executor.insert (test_data.flat_class)
			create ref_executor.make_with_repository (repository)
			ref_executor.insert (test_data.reference_1)
--			structures_executor.insert (test_data.data_structures_1)

			--print (int_repo.memory_db.string_representation)
			create query.make
			ref_executor.execute_query (query)


			assert ("The result is empty", not query.result_cursor.after)

--			print (test_data.reference_1.references.out)
--			print (query.result_cursor.item.references.out)

			-- here we have the problem that the result is not sorted...
			one:= query.result_cursor.item
--			query.result_cursor.forth
			two:= query.result_cursor.item
--			query.result_cursor.forth
			three:= query.result_cursor.item



			orig:= test_data.reference_1


--			print (one.out + two.out + three.out + orig.out + orig.references[1].out + orig.references[1].references[1].out)

--			print (three.tagged_out +two.tagged_out +one.tagged_out +"%N")

--			print ( three.tagged_out+ attach (three.refer).tagged_out + attach (attach (three.refer).refer).tagged_out + "%N")


--			print ( orig.tagged_out+ attach (orig.refer).tagged_out + attach (attach (orig.refer).refer).tagged_out)
--			print (three.references.tagged_out + orig.references.tagged_out)
--			print (three.references[1].tagged_out + orig.references[1].tagged_out)
--			print (one.tagged_out + orig.references[1].references[1].tagged_out)

			print (one.tagged_out + orig.tagged_out)

			eq:= orig.is_deep_equal (one) or orig.is_deep_equal (two) or orig.is_deep_equal (three)
			print (eq.out + deep_equal (orig, one).out)

--			print ( three.tagged_out+ attach (three.refer).tagged_out + attach (attach (three.refer).refer).tagged_out + "%N")
--			print ( orig.tagged_out+ attach (orig.refer).tagged_out + attach (attach (orig.refer).refer).tagged_out)


			assert ("The results are not the same", eq)



		end


	test_very_simple
		local
			ref1, ref2:REFERENCE_CLASS_1
			query:PS_OBJECT_QUERY[REFERENCE_CLASS_1]
			ref_executor: PS_CRUD_EXECUTOR[REFERENCE_CLASS_1]
		do
			create ref_executor.make_with_repository (repository)
			create ref1.make (1)
			create ref2.make (1)
			create query.make
			repository.clean_db_for_testing

			ref_executor.insert (ref1)
			ref_executor.execute_query (query)

			print (ref1.tagged_out + ref2.tagged_out + query.result_cursor.item.tagged_out)
	--		print (ref1.deep_twin.tagged_out + ref1.deep_twin.is_deep_equal (ref1).out)
			print (ref1.is_deep_equal (ref2))
			assert ("equality", ref1.is_deep_equal (query.result_cursor.item))


		end




end
