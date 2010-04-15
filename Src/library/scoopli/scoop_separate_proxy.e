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

	scoop_asynchronous_execute (a_caller_: SCOOP_SEPARATE_TYPE; a_routine: ROUTINE [ANY, TUPLE])
			-- Ask handling processor to execute `a_routine'.
		require
			a_caller_non_void: a_caller_ /= void
			a_caller_processor_non_void: a_caller_.processor_ /= void
			a_routine_non_void: a_routine /= void
		local
			scoop_collector: SCOOP_PROFILER_COLLECTOR
		do
			if processor_ = void then set_processor_ (a_caller_.processor_) end

			-- SCOOP PROFILE
			-- Added by trosim
			if {SCOOP_LIBRARY_CONSTANTS}.Enable_profiler and processor_.profile_collector /= Void then
				scoop_collector := processor_.profile_collector
				-- Collect call (always)
				scoop_collector.collect_feature_call (a_routine, a_caller_.processor_, a_caller_.processor_.synchronous_processors_has (processor_))
			end

			if a_caller_.processor_.synchronous_processors_has (processor_) then
				-- SCOOP PROFILE
				-- Added by trosim
				if {SCOOP_LIBRARY_CONSTANTS}.Enable_profiler and scoop_collector /= Void and then not scoop_collector.has_separate_arguments (a_routine) then
					-- This doesn't go through the scheduler, collect wait/application/return here
					scoop_collector.collect_feature_wait (a_routine, create {LINKED_LIST [SCOOP_PROCESSOR]}.make)
					scoop_collector.collect_feature_application (a_routine)
					a_routine.call ([])  -- Execute `a_routine' synchronously.
					scoop_collector.collect_feature_return (a_routine)
				else
					a_routine.call ([])  -- Execute `a_routine' synchronously.
				end
			else
				processor_.asynchronous_execute (a_caller_, a_routine)
			end
		end

	scoop_synchronous_execute (a_caller_: SCOOP_SEPARATE_TYPE; a_routine: ROUTINE [ANY, TUPLE])
			-- Ask handling processor to execute `a_routine' and wait until it has been executed.
		require
			a_caller_non_void: a_caller_ /= void
			a_caller_processor_non_void: a_caller_.processor_ /= void
			a_routine_non_void: a_routine /= void
		local
			scoop_collector: SCOOP_PROFILER_COLLECTOR
		do
			if processor_ = void then set_processor_ (a_caller_.processor_) end

			-- SCOOP PROFILE
			-- Added by trosim
			if {SCOOP_LIBRARY_CONSTANTS}.Enable_profiler and processor_.profile_collector /= Void then
				scoop_collector := processor_.profile_collector
				-- Collect call (always)
				scoop_collector.collect_feature_call (a_routine, a_caller_.processor_, True)
			end

			if a_caller_.processor_.synchronous_processors_has (processor_) then
				-- SCOOP PROFILE
				-- Added by trosim
				if {SCOOP_LIBRARY_CONSTANTS}.Enable_profiler and scoop_collector /= Void and then not scoop_collector.has_separate_arguments (a_routine) then
					-- This doesn't go through the scheduler, collect wait/application/return here
					scoop_collector.collect_feature_wait (a_routine, create {LINKED_LIST [SCOOP_PROCESSOR]}.make)
					scoop_collector.collect_feature_application (a_routine)
					a_routine.call ([])
					scoop_collector.collect_feature_return (a_routine)
				else
					a_routine.call ([])
				end
			else
				processor_.synchronous_execute (a_caller_, a_routine)
			end
		end

feature -- Postcondition handling

	evaluate_separate_postcondition (a_caller_: SCOOP_SEPARATE_TYPE; a_routine: ROUTINE [ANY, TUPLE])
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

	increased_postcondition_counter (i: INTEGER_32): BOOLEAN
			-- Increase postcondition counter by i.
		require
			i > 0
		do
			processor_.increase_postcondition_counter (i)
			Result := True
		end

	decreased_postcondition_counter (i: INTEGER_32): BOOLEAN
			-- Decrease postcondition counter by i.
		require
			i > 0
		do
			processor_.decrease_postcondition_counter (i)
			Result := True
		end

end -- class SCOOP_SEPARATE_PROXY
