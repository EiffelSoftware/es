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
		redefine
			set_processor_
		end

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

	scoop_wait_by_necessity_execute (a_caller_: SCOOP_SEPARATE_TYPE; a_pass_locks : BOOLEAN;
									a_function_to_evaluate : ROUTINE [ANY, TUPLE])
		local
			scoop_locked_processors_stack_size: INTEGER
			scoop_synchronous_processors_stack_size: INTEGER
		do
			if a_pass_locks then
				scoop_locked_processors_stack_size := processor_.locked_processors_count
				scoop_synchronous_processors_stack_size := processor_.synchronous_processors_count
				processor_.locked_processors_push_whole_stack(a_caller_.processor_.locked_processors)
				processor_.synchronous_processors_push_whole_stack(a_caller_.processor_.synchronous_processors)
				scoop_synchronous_execute (a_caller_,a_function_to_evaluate)
				processor_.synchronous_processors_trim (scoop_synchronous_processors_stack_size)
				processor_.locked_processors_trim (scoop_locked_processors_stack_size)
			else
				scoop_synchronous_execute (a_caller_,a_function_to_evaluate)
			end

			if {SCOOP_LIBRARY_CONSTANTS}.Enable_profiler and processor_.profile_collector /= Void then
				processor_.profile_collector.collect_join (processor_, a_caller_.processor_)
			end
		end

feature {SCOOP_SEPARATE_TYPE} -- Postcondition handling

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

feature {SCOOP_SEPARATE_TYPE} -- Implementation association

	implementation_: ANY

	set_implementation_ (an_implementation_: like implementation_)
			-- Set `implementation_' to `an_implementation_'.
		do
			implementation_ := an_implementation_
		end

feature {SCOOP_SEPARATE_TYPE} -- Processor association

	set_processor_ (a_processor_: SCOOP_PROCESSOR)
			-- Set `processor_' to `a_processor_' and create 'implementation_'.
		do
			processor_ := a_processor_
			create implementation_
			if attached {SCOOP_SEPARATE_CLIENT} implementation_ as client then
				client.set_processor_ (a_processor_)
			end
		ensure then
			implementation_set: attached {SCOOP_SEPARATE_CLIENT} implementation_ as client and then client.processor_ = a_processor_
		end

end -- class SCOOP_SEPARATE_PROXY
