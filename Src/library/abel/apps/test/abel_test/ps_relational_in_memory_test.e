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

		do
			print (int_repo.memory_db.string_representation)
			assert ("", false)
		end




end
