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


--	test_crud_flat_in_memory
--		do
--			test_flat_class_store
--			test_flat_class_all_crud
--		end

--	test_crud_structures_in_memory
--		do
--			test_data_structures_store
--			test_update_on_reference
--		end




	test_initial_insert
		local
			ref_executor: PS_CRUD_EXECUTOR[REFERENCE_CLASS_1]
		do
			repository.clean_db_for_testing
--			flat_executor.insert (test_data.flat_class)
			create ref_executor.make_with_repository (repository)
			ref_executor.insert (test_data.reference_1)
--			structures_executor.insert (test_data.data_structures_1)

			print (int_repo.memory_db.string_representation)
			assert ("", true)

		end




end
