note
	description: "Summary description for {PS_MANUAL_TEST_IN_MEMORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_MANUAL_TEST_IN_MEMORY

inherit
	PS_CRITERIA_TESTS
	PS_CRUD_TESTS


feature {NONE}
	on_prepare
		do
			create {PS_IN_MEMORY_REPOSITORY} repository.make
			initialize_tests_general
			initialize_criteria_tests
			initialize_crud_tests
		end


feature

	test_criteria_in_memory
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

	test_crud_structures_in_memory
	do
		test_data_structures_store
		test_update_on_reference
	end

end
