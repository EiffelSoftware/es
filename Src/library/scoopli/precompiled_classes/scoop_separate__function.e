note
	description: "Proxy class for {FUNCTION}."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_SEPARATE__FUNCTION[BASE_TYPE, OPEN_ARGS -> detachable TUPLE create default_create end, RESULT_TYPE]

inherit
	 SCOOP_SEPARATE__ANY
		redefine
			implementation_,
			is_equal
		end
		
create
	make

convert
	-- This conversion is a work around so that the compiler doesn't throw an
	-- error in a proxy class where a local agent is an argument
	-- It is also important for campatibility with base library classes.
	implementation_: {
			FUNCTION[BASE_TYPE, OPEN_ARGS, RESULT_TYPE]
	}

feature -- Initialization
	make (a_processor_: like processor_; impl: FUNCTION[BASE_TYPE, OPEN_ARGS, RESULT_TYPE])
		do
			processor_ := a_processor_
			implementation_ := impl
		end

feature -- Calls

	item (a_caller_: attached SCOOP_SEPARATE_TYPE; args: detachable OPEN_ARGS): RESULT_TYPE
			-- Result of calling function with `args' as operands.
		local
			a_function_to_evaluate: FUNCTION[ANY, TUPLE, RESULT_TYPE]
			scoop_passing_locks: BOOLEAN
			i: INTEGER
		do
			from
				i := 1
				scoop_passing_locks := false
			until
				args = void or i > args.count
			loop
				if attached {SCOOP_SEPARATE_TYPE} args[i] as scoop_object_ then
					if a_caller_.processor_.locked_processors_has (scoop_object_.processor_) then
						scoop_passing_locks := true
					end
				end
				i := i + 1
			end

			a_function_to_evaluate := agent implementation_.item(args)
			scoop_wait_call(a_caller_,scoop_passing_locks,a_function_to_evaluate)
			Result := a_function_to_evaluate.last_result
		end

	last_result (a_caller_: attached SCOOP_SEPARATE_TYPE): RESULT_TYPE
		local
			a_function_to_evaluate: FUNCTION[ANY, TUPLE, RESULT_TYPE]
		do
			a_function_to_evaluate := agent last_result_scoop_separate_function
			scoop_synchronous_execute (a_caller_,a_function_to_evaluate)
			Result :=a_function_to_evaluate.last_result
		end

	last_result_scoop_separate_function: RESULT_TYPE
			-- Wrapper for attribute `last_result'.
		do
			Result := implementation_.last_result
		end

	call (a_caller_: attached SCOOP_SEPARATE_TYPE; args: OPEN_ARGS)
		local
			a_function_to_evaluate: PROCEDURE[ANY, TUPLE]
			scoop_passing_locks: BOOLEAN
			i: INTEGER
		do
			from
				i := 1
				scoop_passing_locks := false
			until
				args = void or i > args.count
			loop
				if attached {SCOOP_SEPARATE_TYPE} args[i] as scoop_object_ then
					if a_caller_.processor_.locked_processors_has (scoop_object_.processor_) then
						scoop_passing_locks := true
					end
				end
				i := i + 1
			end

			a_function_to_evaluate := agent implementation_.call(args)
			scoop_wait_call(a_caller_,scoop_passing_locks,a_function_to_evaluate)
		end

feature -- Implementation

	is_equal (a_caller_: attached SCOOP_SEPARATE_TYPE; other: like Current):BOOLEAN 
		local
			a_function_to_evaluate: FUNCTION[ANY, TUPLE, BOOLEAN]
			scoop_passing_locks: BOOLEAN
		do
			if attached {SCOOP_SEPARATE_TYPE} other as scoop_object_ then
					if a_caller_.processor_.locked_processors_has (scoop_object_.processor_) then
							scoop_passing_locks := true
					end
			end
			a_function_to_evaluate := agent implementation_.is_equal(other.implementation_)
			scoop_wait_call(a_caller_,scoop_passing_locks,a_function_to_evaluate)
			Result := a_function_to_evaluate.last_result
		end

feature -- Separateness

	implementation_: FUNCTION[BASE_TYPE, OPEN_ARGS, RESULT_TYPE]
			-- reference to actual object
end
