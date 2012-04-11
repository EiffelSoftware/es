note
	description: "Summary description for {PS_TESTS_GENERAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_TESTS_GENERAL

inherit
	EQA_TEST_SET
	undefine
		on_prepare
	end


feature {NONE}

	factory: PS_CRITERION_FACTORY

	repository: PS_REPOSITORY
		-- The repository to operate on. Assumed to be initialized in the on_prepare function of a descendant

	test_data: PS_TEST_DATA


	initialize_tests_general
	-- Initialize some more general parts of the test sets
		do
			create factory
			create test_data.make
		end

end
