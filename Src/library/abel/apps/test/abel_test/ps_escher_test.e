note
	description: "A small unit test for ESCHER integration."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_ESCHER_TEST

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature

	test_normal_operation
			-- Test if no version mismatch gets handled correctly
		local
			query: PS_OBJECT_QUERY [ESCHER_TEST_CLASS]
		do
			escher_integration.set_simulation (False)
			create query.make
			executor.insert (test_data.escher_test)
			executor.execute_query (query)
		end

	test_version_mismatch
			-- Test the ESCHER version checking by simulating a version mismatch.
		local
			query: PS_OBJECT_QUERY [ESCHER_TEST_CLASS]
			retried: BOOLEAN
		do
			escher_integration.set_simulation (True)
			if not retried then
				create query.make
				executor.insert (test_data.escher_test)
				executor.execute_query (query)
			end
		rescue
			assert ("No version mismatch error was raised", executor.has_error and then attached {PS_VERSION_MISMATCH} executor.last_error)
			retried := True
			retry
		end

feature {NONE}

	executor: PS_CRUD_EXECUTOR

	test_data: PS_TEST_DATA

	escher_integration: PS_VERSION_HANDLER

	on_prepare
			-- Set up an in-memory database with an ESCHER integration layer
		local
			real_backend: PS_IN_MEMORY_DATABASE
			repo: PS_RELATIONAL_REPOSITORY
		do
			create real_backend.make
			create escher_integration.make (real_backend)
			create repo.make (escher_integration)
			create executor.make (repo)
			create test_data.make
		end

end
