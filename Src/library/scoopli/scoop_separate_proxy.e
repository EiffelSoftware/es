indexing
	description: "Objects that implement proxies to separate suppliers."
	author: "Piotr Nienaltowski"
	date: "$Date$"
	revision: "$Revision$"
	build_number: "0.4.4000"

deferred class
	SCOOP_SEPARATE_PROXY

inherit
	SCOOP_SEPARATE_TYPE

feature {NONE} -- Basic operations

	scoop_asynchronous_execute (a_caller_: SCOOP_SEPARATE_TYPE; a_routine: ROUTINE [ANY, TUPLE]) is
			-- Ask handling processor to execute `a_routine'.
		require
			a_caller_non_void: a_caller_ /= void
			a_caller_processor_non_void: a_caller_.processor_ /= void
			a_routine_non_void: a_routine /= void
		do
			if processor_ = void then set_processor_ (a_caller_.processor_) end
			if a_caller_.processor_.synchronous_processors_has (processor_) then
				a_routine.call ([])  -- Execute `a_routine' synchronously.
			else
				processor_.asynchronous_execute (a_caller_, a_routine)
			end
		end

	scoop_synchronous_execute (a_caller_: SCOOP_SEPARATE_TYPE; a_routine: ROUTINE [ANY, TUPLE]) is
			-- Ask handling processor to execute `a_routine' and wait until it has been executed.
		require
			a_caller_non_void: a_caller_ /= void
			a_caller_processor_non_void: a_caller_.processor_ /= void
			a_routine_non_void: a_routine /= void
		do
			if processor_ = void then set_processor_ (a_caller_.processor_) end
			if a_caller_.processor_.synchronous_processors_has (processor_) then
				a_routine.call ([])
			else
				processor_.synchronous_execute (a_caller_, a_routine)
			end
		end

feature -- Postcondition handling

	evaluate_separate_postcondition (a_caller_: SCOOP_SEPARATE_TYPE; a_routine: ROUTINE [ANY, TUPLE]) is
			-- Evaluate separate postcondition asynchronously.
		require
			a_caller_non_void: a_caller_ /= void
--			a_caller_processor_non_void: a_caller_.processor_ /= void
			a_routine_non_void: a_routine /= void
		do
			if processor_ = void then set_processor_ (a_caller_.processor_) end
			if a_caller_.processor_ = processor_ then
				a_routine.call ([])  -- Execute `a_routine' synchronously.
			else
				processor_.asynchronous_execute (a_caller_, a_routine)
			end
		end

	increased_postcondition_counter (i: INTEGER_32): BOOLEAN is
			-- Increase postcondition counter by i.
		require
			i > 0
		do
			processor_.increase_postcondition_counter (i)
			Result := True
		end

	decreased_postcondition_counter (i: INTEGER_32): BOOLEAN is
			-- Decrease postcondition counter by i.
		require
			i > 0
		do
			processor_.decrease_postcondition_counter (i)
			Result := True
		end

end -- class SCOOP_SEPARATE_PROXY
