note
	description: "Summary description for {TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TESTER

create
	make

feature
	make
		do
		end

feature
	procedure_no_args
		do

		end

	procedure_local_args (test1, test2 : TESTER)
		do

		end

	procedure_separate_args (test1, test2 : separate TESTER)
		do

		end

	procedure_mixed_args (test1 : TESTER; test2 : separate TESTER)
		do

		end

	local_function_no_args : TESTER
		do
			create Result.make
		end

	local_function_local_args (test1, test2 : detachable TESTER) : TESTER
		do
			create Result.make
		end

	local_function_separate_args (test1, test2 : separate TESTER) : TESTER
		do
			create Result.make
		end

	local_function_mixed_args (test1 : TESTER; test2 : separate TESTER) : TESTER
		do
			create Result.make
		end

	separate_function_no_args : separate TESTER
		do
			create Result.make
		end

	separate_function_local_args (test1, test2 : TESTER) : separate TESTER
		do
			create Result.make
		end

	separate_function_separate_args (test1, test2 : separate TESTER) : separate TESTER
		do
			create Result.make
		end

	separate_function_mixed_args (test1 : TESTER; test2 : separate TESTER) : separate TESTER
		do
			create Result.make
		end

	expanded_function_no_args : INTEGER
		do
		end

	expanded_function_local_args (test1, test2 : TESTER) : INTEGER
		do
		end

	expanded_function_separate_args (test1, test2 : separate TESTER) : INTEGER
		do
		end

	expanded_function_mixed_args (test1 : TESTER; test2 : separate TESTER) : INTEGER
		do
		end

	predicate_no_args : BOOLEAN
		do
		end

	predicate_local_args (test1, test2 : TESTER) : BOOLEAN
		do
		end

	predicate_separate_args (test1, test2 : separate TESTER) : BOOLEAN
		do
		end

	predicate_mixed_args (test1 : TESTER; test2 : separate TESTER) : BOOLEAN
		do
		end

	function_local_agent (test : FUNCTION[ANY, TUPLE, ANY]) : FUNCTION[ANY, TUPLE, ANY]
		do
			Result := test
		end

	function_separate_agent (test : separate FUNCTION[ANY, TUPLE, ANY]) : separate FUNCTION[ANY, TUPLE, ANY]
		do
			Result := test
		end


end
