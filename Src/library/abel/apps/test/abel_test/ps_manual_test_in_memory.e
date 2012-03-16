note
	description: "Summary description for {PS_MANUAL_TEST_IN_MEMORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_MANUAL_TEST_IN_MEMORY

inherit
	PS_REPOSITORY_TESTS



feature {NONE}
	on_prepare
		local
			rep:PS_IN_MEMORY_REPOSITORY
		do
			create rep.make
			initialize (rep)
		end


feature

	test_criteria_in_memory
	do
		test_criteria_agents
		test_criteria_predefined
		test_criteria_agents_and_predefined
	end

end
