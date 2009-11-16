indexing
	description: "Separate objects. Separate clients and proxies to separate suppliers are instances of SCOOP_SEPARATE_TYPE.%
				 %Revision 2.3 introduces direct reference to processor handler, thus eliminating the need%
				 %for additional data structures (hash tables) and lookup algorithms in SCOOP_SCHEDULER.%
				 %Revision 3.0 eliminates the need for non-standard default create."
	author: "Piotr Nienaltowski"
	date: "$Date$"
	revision: "$Revision$"
	build_number: "0.4.4000"

deferred class
	SCOOP_SEPARATE_TYPE

-- inherit 
--	SCOOP_CONCURRENCY
	
--		rename
--			default_create as concurrency_default_create
--		end

		
feature {SCOOP_SEPARATE_TYPE, SCOOP_PROCESSOR, SCOOP_SCHEDULER} -- Access

	processor_: SCOOP_PROCESSOR
			-- Processor handling this object.
			
	set_processor_ (a_processor_: SCOOP_PROCESSOR) is
			-- Set `processor_' to `a_processor_'.
		require
			a_processor_exists: a_processor_ /= void
		do
			processor_ := a_processor_
		ensure
			processor_set: processor_ = a_processor_
		end

feature {SCOOP_SEPARATE_TYPE, SCOOP_PROCESSOR, SCOOP_SCHEDULER} -- Comparison

	scoop_is_local (other: SCOOP_PROCESSOR): BOOLEAN is
		do
			Result := other /= void and then processor_.synchronous_processors_has (other)
		end

	scoop_local_to_each_other (one_separate_object, other_separate_object: SCOOP_SEPARATE_TYPE): BOOLEAN is
			-- 
		do
			if one_separate_object /= void and then other_separate_object /= void then
				if one_separate_object.processor_ = void then
					one_separate_object.set_processor_ (processor_)
				end
				if other_separate_object.processor_ = void then
					other_separate_object.set_processor_ (processor_)
				end
				Result := (one_separate_object.processor_ = other_separate_object.processor_)
			end
		end

feature {NONE} -- Implementation
	
	scoop_scheduler: SCOOP_SCHEDULER is
			-- Scheduler of separate calls.
		indexing
			once_status: global
		once
			create Result.make
		end
			
end -- class SCOOP_SEPARATE_TYPE
