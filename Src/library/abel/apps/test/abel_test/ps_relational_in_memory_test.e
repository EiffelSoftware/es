note
	description: "Tests ABEL with an in-memory 'database' backend."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RELATIONAL_IN_MEMORY_TEST
inherit
--	PS_REPOSITORY_TESTS

feature{NONE}

	make_repository: PS_RELATIONA_IN_MEMORY_REPOSITORY
		do
			create Result.make (create {PS_IN_MEMORY_DATABASE}.make)
		end

feature

	test_criteria_in_memory
		do
			criteria_tests.test_criteria_agents
			criteria_tests.test_criteria_predefined
			criteria_tests.test_criteria_agents_and_predefined
		end


	test_crud_flat_in_memory
		do
			crud_tests.test_flat_class_store
			crud_tests.test_flat_class_all_crud
		end

	test_references_in_memory
		do
			crud_tests.test_insert_void_reference
			crud_tests.test_insert_one_reference
			crud_tests.test_insert_reference_cycle
		end

--	test_crud_structures_in_memory
--		do
--			test_data_structures_store
--			test_update_on_reference
--		end

end
