note
	description: "Proxy class for {PROCEDURE}."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_SEPARATE__PROCEDURE[BASE_TYPE, OPEN_ARGS -> detachable TUPLE create default_create end]

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
	-- It is also important for compatibility with base classes
	implementation_: {
			PROCEDURE[BASE_TYPE, OPEN_ARGS]
	}


feature -- Initialization
	make (a_processor_: like processor_; impl: PROCEDURE[BASE_TYPE, OPEN_ARGS])
		do
			processor_ := a_processor_
			implementation_ := impl
		end

feature -- Calls
	call (a_caller_: attached SCOOP_SEPARATE_TYPE; args: detachable OPEN_ARGS)
		local
			a_function_to_evaluate: PROCEDURE[ANY, TUPLE]
			scoop_passing_locks: BOOLEAN
			i: INTEGER
			int: INTERNAL
			l_type: INTEGER
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
			scoop_async_call(a_caller_,scoop_passing_locks,a_function_to_evaluate)
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

	implementation_: PROCEDURE[BASE_TYPE, OPEN_ARGS]
			-- reference to actual object
end

