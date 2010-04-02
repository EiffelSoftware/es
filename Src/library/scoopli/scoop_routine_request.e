indexing
	description: "Objects that represent routine requests to be scheduled for execution"
	author: "Piotr Nienaltowski"
	date: "$Date$"
	revision: "$Revision$"
	build_number: "0.4.4000"

class
	SCOOP_ROUTINE_REQUEST

create
	make

feature {NONE} -- Initialization

	make (a_caller: SCOOP_SEPARATE_CLIENT; a_requested_processors: TUPLE [SCOOP_PROCESSOR]; a_routine: ROUTINE [SCOOP_SEPARATE_TYPE, TUPLE]; a_wait_condition: FUNCTION [SCOOP_SEPARATE_CLIENT, TUPLE, BOOLEAN]) is
			-- Creation procedure.
		require
			a_caller_not_void: a_caller /= void
			a_requested_processors_not_void: a_requested_processors /= void
			a_procedure_not_void: a_routine /= void
		do
			requested_by := a_caller
			requested_processors := a_requested_processors
			routine := a_routine
			wait_condition := a_wait_condition
			create ready_for_execution.make (False)
		ensure
			requested_by_set: requested_by = a_caller
			requested_processors_set: requested_processors = a_requested_processors
			routine_set: routine = a_routine
		end
		
feature -- Access

	requested_processors: TUPLE [SCOOP_PROCESSOR]
			-- Processors to be locked by routine.
	
	requested_by: SCOOP_SEPARATE_CLIENT
			-- Separate client requesting the execution of routine.

	finished: BOOLEAN
			-- Has routine terminated?

	active: BOOLEAN
			-- Is routine being currently executed?
	
	ready_for_execution: SCOOP_AUTO_RESET_EVENT_HANDLE
			-- Signal routine request is ready for execution.

	wait_condition_satisfied: BOOLEAN
			-- Is wait condition satisfied?
		do
			if wait_condition /= void then
				-- SCOOP PROFILE
				if attached {SCOOP_SEPARATE_TYPE} routine.target as scoop_profile_target and then scoop_profile_target.processor_.profile_collector /= Void then
					scoop_profile_target.processor_.profile_collector.collect_wait_condition (routine)
				end
				wait_condition.call ([])
				Result := wait_condition.last_result
			else
				Result := True
			end
		end
		
feature -- Element change

	signal_ready_for_execution is
			-- Signal that request is ready for execution.
		do
			ready_for_execution.set
		end

feature {NONE} -- Implementation

	wait_condition: FUNCTION [SCOOP_SEPARATE_CLIENT, TUPLE, BOOLEAN]
			-- Wait condition to be satisfied before calling routine.
	
	routine: ROUTINE [SCOOP_SEPARATE_TYPE, TUPLE]
			-- Routine to be executed (enclosing routine).

			
invariant
	
	requested_by_not_void: requested_by /= void
	requested_processors_not_void: requested_processors /= void
	routine_not_void: routine /= void
	ready_for_execution_not_void: ready_for_execution /= void

end -- class SCOOP_ROUTINE_REQUEST
