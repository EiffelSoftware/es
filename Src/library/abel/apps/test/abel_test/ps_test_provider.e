note
	description: "[
		The ancestor for provider classes of backend-neutral tests.
		Each test defined in a descendants of this class should provide the following:
			- The test does not take any arguments
			- The test shall leave an empty database after execution
			- The test can assume an empty database before execution
		Additionaly, the provider class should be instantiated using the make feature defined here.
		]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_TEST_PROVIDER

inherit
	PS_EIFFELSTORE_EXPORT
	undefine default_create end

--inherit {NONE}
	EQA_TEST_SET
		export {NONE} all end
--	rename default_create as eqa_test_set_default_create end



feature {PS_TEST_PROVIDER}

	repository: PS_REPOSITORY

	executor: PS_CRUD_EXECUTOR

	test_data: PS_TEST_DATA


	make (a_repository: PS_REPOSITORY)
		do
			default_create
			repository:= a_repository
			create executor.make_with_repository (repository)
			create test_data.make
		end



end
