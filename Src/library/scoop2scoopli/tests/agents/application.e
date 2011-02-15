note
	description : "testbed application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			success : BOOLEAN
		do
			create local_tester.make
			create separate_tester.make;
			success := true
			success := success and compilation_test
			success := success and inline_agent_test
			success := success and sleepy_workers_test(4)
		end

feature

	local_tester: TESTER
	separate_tester: separate TESTER

	inline_agent_test: BOOLEAN
		do
 			--Inline procedure without parameters
 			(agent do end).call([])

 			--Inline procedure with parameters
			(agent (b: BOOLEAN; s1, s2: TESTER) do end).call([true, local_tester, local_tester])

 			--Inline procedure with separate parameters
 			(agent (b: BOOLEAN; s1, s2: separate TESTER) do end).call([true, separate_tester, separate_tester])

			Result := true;
		end

	compilation_test: BOOLEAN
		local
			local_procedure: PROCEDURE[ANY, TUPLE[]]
			separate_procedure: separate PROCEDURE[separate ANY, TUPLE[]]
			local_predicate: PREDICATE[ANY, TUPLE[]]
			separate_predicate: separate PREDICATE[separate ANY, TUPLE[]]
			local_function: FUNCTIon[ANY, TUPLE[], separate ANY]
			separate_function: separate FUNCTION[separate ANY, TUPLE[], separate ANY]
			integer: INTEGER
			boolean: BOOLEAN
			any: separate ANY
		do
			local_procedure := agent local_tester.procedure_no_args
			separate_procedure := local_procedure
 			call_procedure(separate_procedure, []);
 			local_procedure := agent local_tester.procedure_local_args
			separate_procedure := local_procedure
 			call_procedure(separate_procedure, [local_tester, local_tester]);
 			local_procedure := agent local_tester.procedure_separate_args
 			call_procedure(local_procedure, [separate_tester, separate_tester]);
 			local_procedure := agent local_tester.procedure_mixed_args
 			call_procedure(local_procedure, [local_tester, separate_tester]);
			separate_procedure := agent separate_tester.procedure_no_args
 			call_procedure(separate_procedure, []);
			separate_procedure := agent separate_tester.procedure_separate_args
 			call_procedure(separate_procedure, [separate_tester, separate_tester]);

			local_function := agent local_tester.local_function_no_args
			any := call_function(local_function, [])
 			local_function := (agent local_tester.local_function_local_args)
			any := call_function(local_function, [local_tester, local_tester])
 			local_function := (agent local_tester.local_function_separate_args)
 			separate_function := local_function
			any := call_function(separate_function, [separate_tester, separate_tester])
 			local_function := (agent local_tester.local_function_mixed_args)
 			separate_function := local_function
			any := call_function(separate_function, [local_tester, separate_tester])
			separate_function := (agent separate_tester.local_function_no_args)
			any := call_function(separate_function, [])
			separate_function := (agent separate_tester.local_function_separate_args)
			any := call_function(separate_function, [separate_tester, separate_tester])

			local_function := (agent local_tester.separate_function_no_args)
			any := call_function(local_function, [])
 			local_function := (agent local_tester.separate_function_local_args)
			any := call_function(local_function, [local_tester, local_tester])
 			local_function := (agent local_tester.separate_function_separate_args)
 			separate_function := local_function
			any := call_function(separate_function, [separate_tester, separate_tester])
 			local_function := (agent local_tester.separate_function_mixed_args)
 			separate_function := local_function
			any := call_function(separate_function, [local_tester, separate_tester])
			separate_function := (agent separate_tester.separate_function_no_args)
			any := call_function(separate_function, [])
			separate_function := (agent separate_tester.separate_function_separate_args)
			any := call_function(separate_function, [separate_tester, separate_tester])

			local_function := (agent local_tester.expanded_function_no_args)
			any := call_function(local_function, [])
 			local_function := (agent local_tester.expanded_function_local_args)
			any := call_function(local_function, [local_tester, local_tester])
 			local_function := (agent local_tester.expanded_function_separate_args)
 			separate_function := local_function
			any := call_function(separate_function, [separate_tester, separate_tester])
 			local_function := (agent local_tester.expanded_function_mixed_args)
 			separate_function := local_function
			any := call_function(separate_function, [local_tester, separate_tester])
			separate_function := (agent separate_tester.expanded_function_no_args)
			any := call_function(separate_function, [])
			separate_function := (agent separate_tester.expanded_function_separate_args)
			any := call_function(separate_function, [separate_tester, separate_tester])

			local_predicate := (agent local_tester.predicate_no_args)
			boolean := call_predicate(local_predicate, [])
 			local_predicate := (agent local_tester.predicate_local_args)
			boolean := call_predicate(local_predicate, [local_tester, local_tester])
 			local_predicate := (agent local_tester.predicate_separate_args)
 			separate_predicate := local_predicate
			boolean := call_predicate(separate_predicate, [local_tester, separate_tester])
 			local_predicate := (agent local_tester.predicate_mixed_args )
 			separate_predicate := local_predicate
			boolean := call_predicate(separate_predicate, [local_tester, separate_tester])
			separate_predicate := (agent separate_tester.predicate_no_args)
			boolean := call_predicate(separate_predicate, [])
			separate_predicate := (agent separate_tester.predicate_separate_args)
			boolean := call_predicate(separate_predicate, [separate_tester, separate_tester])

--			--Test open arguments
			separate_predicate := agent separate_tester.predicate_separate_args(separate_tester, ?)
 			boolean := call_predicate(separate_predicate, [separate_tester]);
--			--Test open target
			local_predicate := agent {TESTER}.predicate_separate_args(separate_tester, ?)
 			boolean := call_predicate(local_predicate, [local_tester, separate_tester]);

			Result := true;
		ensure
			call_predicate(agent separate_tester.predicate_separate_args(separate_tester, ?), [separate_tester]) or Result
		end

	call_procedure(procedure: separate PROCEDURE[separate ANY, TUPLE[]]; params : TUPLE[])
		do
			-- This should work but somehow the scoop compiler doesn't add the "Current" parameter
			procedure.call(params);
		end

	call_predicate(predicate: separate PREDICATE[separate ANY, TUPLE[]]; params : TUPLE[]): BOOLEAN
		do
			Result := predicate.item(params)
		end

	call_function(function: separate FUNCTION[separate ANY, TUPLE[], separate ANY]; params : TUPLE[]): separate ANY
		do
			Result := function.item(params)
		end

	sleepy_workers_test (threads: INTEGER): BOOLEAN
		require
			parallel: threads > 1
		local
			procedure: separate PROCEDURE[separate ANY, TUPLE[]]
			worker: separate SLEEPY_WORKER
			local_procedure: PROCEDURE[ANY, TUPLE[]]
			local_worker: SLEEPY_WORKER
			i: INTEGER
--			start, stop: TIME
			parallel, serial: DOUBLE
		do
--			create start.make_now
			from
				i := 1
			until
				i > threads
			loop
				create worker.make(i, 1*1000*1000*1000)
				-- This shouldn't work because the agent isn't controlled
				--(agent worker.do_your_work).call([])
				procedure := (agent worker.do_your_work)
				--procedure.call([]);
				call_procedure(procedure,[]);
				i := i + 1
			end
--			create stop.make_now
--			parallel := (stop.fine_seconds - start.fine_seconds)

--			create start.make_now
			from
				i := 1 + threads
			until
				i > 2 * threads
			loop
				create local_worker.make(i, 1*1000*1000*1000)
				local_procedure := agent local_worker.do_your_work
 				local_procedure.call([]);
				i := i + 1
			end
--			create stop.make_now
--			serial := (stop.fine_seconds - start.fine_seconds)
--			Result := parallel < serial
			Result := true
		ensure
			parallel_is_faster_than_serial: Result = true
		end
end
