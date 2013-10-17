note
	description: "Summary description for {CI_FIX_CONTRACTS_CMD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_FIX_CONTRACTS_CMD

create
	make

feature{NONE} -- Initialization

	make (a_config: CI_CONFIG)
			-- Initialization.
		do
			config := a_config
		end

feature -- Access

	config: CI_CONFIG
			-- Configuration.

feature -- Inferred contracts

	last_contracts: HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], BOOLEAN]
			-- Contracts inferred from all passing/failing test runs.
			-- Key is a boolean indicating precondition or postcondition,
			-- value is the set of assertions of that kind.	

	last_sequence_based_contracts: DS_HASH_SET [STRING]
			-- Set of sequence based contracts

feature -- Number of tests used for fixing

	number_passing_tests: INTEGER
	number_failing_tests: INTEGER

feature	-- Basic operation

	execute
			-- Fix contracts.
		local
			l_build_command: CI_BUILD_TEST_CASE_APP_CMD_EXT
		do
			check config.should_build_project end
			create l_build_command.make (config)
			l_build_command.execute

			number_passing_tests := l_build_command.number_passing_tests
			number_failing_tests := l_build_command.number_failing_tests

			infer_contracts
		end

	infer_contracts
			-- Infer contracts using passing tests, and failing ones respectively.
			-- Put inferred contracts in `last_**_contracts_from_passing/failing'.
		local
			l_last_contracts_from_passing: HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], BOOLEAN]
			l_last_contracts_from_failing: HASH_TABLE [DS_HASH_SET [EPA_EXPRESSION], BOOLEAN]
			l_last_sequence_based_contracts_from_passing: DS_HASH_SET [STRING]
			l_last_sequence_based_contracts_from_failing: DS_HASH_SET [STRING]

			l_infer_command: CI_INFER_CONTRACT_CMD_EXT
		do
			create l_infer_command.make (config)
			l_infer_command.execute

--			l_last_contracts_from_passing := l_infer_command.last_contracts
--			l_last_sequence_based_contracts_from_passing := l_infer_command.last_sequence_based_contracts

--			create l_infer_command.make (config)
--			l_infer_command.execute

--			l_last_contracts_from_failing := l_infer_command.last_contracts
--			l_last_sequence_based_contracts_from_failing := l_infer_command.last_sequence_based_contracts

--			last_contracts := l_last_contracts_from_passing
--			last_sequence_based_contracts := l_last_sequence_based_contracts_from_passing
		end

	surviving_contracts (a_contracts_from_passing, a_contracts_from_failing: like last_contracts): like last_contracts
			-- Contracts that were observed across passing runs
		do

		end

end
