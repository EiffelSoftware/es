indexing
	description: "Objects that handle creation of processors, locking, and scheduling separate calls.%
			 	 %One instance of SCOOP_SCHEDULER exists in every SCOOP system.%
			 	 %Revision 2.3.0 eliminates the need for additional data structures%
			 	 %for processor lookup - each separate object has direct reference%
			 	 %to its processor."
	author: "Piotr Nienaltowski"
	date: "$Date$"
	revision: "$Revision$"
	build_number: "0.4.4000"

class
	SCOOP_SCHEDULER

inherit
	SCOOP_THREAD

create
	make

feature {NONE} -- Initialization

	make is
			-- Creation procedure.
		do
			create routine_requests.make
			create processors.make
			create routine_requests_mutex
			create processors_mutex
			create routine_request_update.make (False)
			create all_processors_finished.make (False)
			default_create
		end

feature {SCOOP_SEPARATE_TYPE} -- Registration

	new_processor_: SCOOP_PROCESSOR is
			-- Create new processor and return reference to it.
		do
				create Result.make (Current)
				processors_mutex.lock
				processors.extend (Result)
				processors_mutex.unlock
		end

feature {SCOOP_SEPARATE_CLIENT} -- Basic operations


	execute_routine (a_caller_: SCOOP_SEPARATE_CLIENT; a_requested_processors: TUPLE [SCOOP_PROCESSOR]; a_routine: ROUTINE [SCOOP_SEPARATE_TYPE, TUPLE];
						a_wait_condition: FUNCTION [SCOOP_SEPARATE_CLIENT, TUPLE, BOOLEAN]
						a_separate_postcondition: ROUTINE [SCOOP_SEPARATE_CLIENT, TUPLE];
						a_non_separate_postcondition: ROUTINE [SCOOP_SEPARATE_CLIENT, TUPLE]) is
			-- Create routine request for `a_routine' and add it to list of routine requests.
			-- When request is ready for execution, i.e. all requested processors are locked and `a_wait_condition' holds, execute `a_routine'.
			-- Check `a_separate_postcondition' and `a_non_separate_postcondition'.
		require
			a_caller_non_void: a_caller_ /= void
			a_requested_processors_non_void: a_requested_processors /= void
			at_least_one_requested_processor: a_requested_processors.count > 0
			a_routine_non_void: a_routine /= void
		local
			request: SCOOP_ROUTINE_REQUEST
			i: INTEGER_32
			requested_processors: TUPLE [SCOOP_PROCESSOR]
			effectively_requested_processors: LINKED_LIST [SCOOP_PROCESSOR] -- Processors effectively requested.
			are_requested_processors_locked: BOOLEAN
			a_requested_processor: SCOOP_PROCESSOR
		do
			create effectively_requested_processors.make
			requested_processors := a_requested_processors.twin
			-- Check whether `a_caller_' knows its processor.
			if a_caller_.processor_ = void then
				find_and_set_processor_ (a_caller_)
			end
			-- Eliminate repeated requests for the same processor.
			-- Eliminate requests for processors that a_caller has already locked.
			are_requested_processors_locked := true
			from
				i := a_requested_processors.lower
			until
				i > a_requested_processors.upper
			loop
				a_requested_processor ?= a_requested_processors.item (i)
				if not (a_requested_processor = Void
						or else a_caller_.processor_.locked_processors_has (a_requested_processor) -- already locked
						or else effectively_requested_processors.has (a_requested_processor)) -- duplicate
				then
					effectively_requested_processors.extend (a_requested_processor)
					are_requested_processors_locked := false -- there's at least one processor to lock
				else
					requested_processors.put (Void, i) -- no need to lock this processor
				end
				i := i + 1
			end
			if are_requested_processors_locked then
				a_routine.call([])
				if a_separate_postcondition /= void then
					a_separate_postcondition.call ([])
				end
			 	if a_non_separate_postcondition /= void then
 				 	a_non_separate_postcondition.call ([])
			 	end
			else
				create request.make (a_caller_, requested_processors, a_routine, a_wait_condition)
				routine_requests_mutex.lock
				routine_requests.extend (request)
				if routine_requests.after then
					routine_requests.start -- necessary to make sure that scheduler thread take new request into account
				end
				routine_request_update.set
			    routine_requests_mutex.unlock
				request.ready_for_execution.wait_one -- wait until routine request is ready for execution (locks acquired and wait condition holds)
				a_caller_.processor_.locked_processors_push (requested_processors)
				a_routine.call([])
				if a_separate_postcondition /= void then
					a_separate_postcondition.call ([])
				end
			 	release_locks_asynchronously (a_caller_, requested_processors)
			 	if a_non_separate_postcondition /= void then
 				 	a_non_separate_postcondition.call ([])
			 	end
				a_caller_.processor_.locked_processors_pop
			end
		end

	execute_routine_without_postconditions (a_caller_: SCOOP_SEPARATE_CLIENT; a_requested_processors: TUPLE [SCOOP_PROCESSOR]; a_routine: ROUTINE [SCOOP_SEPARATE_TYPE, TUPLE]; a_wait_condition: FUNCTION [SCOOP_SEPARATE_CLIENT, TUPLE, BOOLEAN]) is
			-- Create routine request for `a_routine' and add it to list of routine requests.
			-- When request is ready for execution, i.e. all requested processors are locked and `a_wait_condition' holds, execute `a_routine'.
			-- Obsolete; use `execute_routine' instead.
		obsolete
			"Use `execute_routine' instead."
		require
			a_caller_non_void: a_caller_ /= void
			a_requested_processors_non_void: a_requested_processors /= void
			at_least_one_requested_processor: a_requested_processors.count > 0
			a_routine_non_void: a_routine /= void
		local
			request: SCOOP_ROUTINE_REQUEST
			i: INTEGER_32
			requested_processors: TUPLE [SCOOP_PROCESSOR]
			effectively_requested_processors: LINKED_LIST [SCOOP_PROCESSOR] -- Processors effectively requested.
			are_requested_processors_locked: BOOLEAN
			a_requested_processor: SCOOP_PROCESSOR
		do
			create effectively_requested_processors.make
			requested_processors := a_requested_processors.twin
			-- Check whether `a_caller_' knows its processor.
			if a_caller_.processor_ = void then
				find_and_set_processor_ (a_caller_)
			end
			-- Eliminate repeated requests for the same processor.
			-- Eliminate requests for processors that a_caller has already locked.
			are_requested_processors_locked := true
			from
				i := a_requested_processors.lower
			until
				i > a_requested_processors.upper
			loop
				a_requested_processor ?= a_requested_processors.item (i)
				if not (a_requested_processor = Void
						or else a_caller_.processor_.locked_processors_has (a_requested_processor) -- already locked
						or else effectively_requested_processors.has (a_requested_processor)) -- duplicate
				then
					effectively_requested_processors.extend (a_requested_processor)
					are_requested_processors_locked := false -- there's at least one processor to lock
				else
					requested_processors.put (Void, i) -- no need to lock this processor
				end
				i := i + 1
			end
			if are_requested_processors_locked then
				a_routine.call([])
			else
				create request.make (a_caller_, requested_processors, a_routine, a_wait_condition)
				routine_requests_mutex.lock
				routine_requests.extend (request)
				if routine_requests.after then
					routine_requests.start -- necessary to make sure that scheduler thread take new request into account
				end
				routine_request_update.set
			    routine_requests_mutex.unlock
				request.ready_for_execution.wait_one -- wait until routine request is ready for execution (locks acquired and wait condition holds)
				a_caller_.processor_.locked_processors_push (requested_processors)
				a_routine.call([])
				a_caller_.processor_.locked_processors_pop
			 	release_locks_asynchronously (a_caller_, requested_processors)
			end
		end



feature {NONE} -- Synchronization

	execute_thread is
			-- Main loop. Schedule routine requests for execution.
			-- Scheduling and locking policy are implemented here.
		local
			current_request: SCOOP_ROUTINE_REQUEST
			number_of_requests: INTEGER_32
			are_processors_active: BOOLEAN
		do
			from
				routine_requests.start
			until
				execution_stopped --and routine_requests.is_empty
			loop
				processors_mutex.lock
			from
				processors.start
			until
				processors.after
			loop
				processors.item.mutex.lock
				processors.item.signal_actions_not_empty
				processors.item.mutex.unlock
				processors.forth
			end
			processors_mutex.unlock
				routine_request_update.wait_one	-- Wait until state of some routine request has changed or new request has been added.
												-- This eliminates "busy wait".
				from
					routine_requests_mutex.lock
					routine_requests.start -- Always start from the "oldest" request to preserve FIFO policy.
				until
					routine_requests.off
				loop
					current_request := routine_requests.item
						-- Check if locks can be acquired and wait condition holds.
					if locks_acquired (current_request.requested_by, current_request.requested_processors) then
						if current_request.wait_condition_satisfied then
							current_request.signal_ready_for_execution -- Signal that request is ready for execution.
							routine_requests.remove -- `current_request' has been executed and needs to be removed from list.
--							routine_requests.start -- Restart scanning request list from beginning.
						else
							release_locks (current_request.requested_by, current_request.requested_processors)
							routine_requests.forth -- Move to next routine request.
						end
					else
						routine_requests.forth -- Move to next routine request.
					end
					number_of_requests := routine_requests.count
					routine_requests_mutex.unlock
					routine_requests_mutex.lock
				end
				routine_requests_mutex.unlock
					-- Check for quiescense. If there are no outstanding requests and all processors are idle, terminate the application.
				if number_of_requests = 0 and processors.count > 1 then
					processors_mutex.lock
					from
						processors.start
						are_processors_active := false
					until
						processors.after or are_processors_active
					loop
						are_processors_active := are_processors_active or processors.item.locked
						processors.forth
					end
					processors_mutex.unlock
					if not are_processors_active then
						stop_execution
					end
				end
			end
			-- Terminate application. Destroy all processors.
			processors_mutex.lock
			from
				processors.start
			until
				processors.after
			loop
				processors.item.mutex.lock
				processors.item.signal_finished
				processors.item.mutex.unlock
				processors.forth
			end
			processors_mutex.unlock
		end



	locks_acquired (a_caller_: SCOOP_SEPARATE_CLIENT; a_requested_processors: TUPLE [SCOOP_PROCESSOR]): BOOLEAN is
			-- Check if locks on `a_requested_processors' can be acquired, if yes acquire them.
		require
			a_caller_non_void: a_caller_ /= void
			a_requested_processors_non_void: a_requested_processors /= void
			a_requested_processors.count > 0
		local
			i: INTEGER_32
			requested_processor: SCOOP_PROCESSOR
			requested_processors: LINKED_LIST [SCOOP_PROCESSOR] -- Processors already locked by current request.
		do
			Result := true
			create requested_processors.make
			-- Eliminate processors that are already locked by caller.
			-- Multiple occurences of processors are already eliminated.
			from
				i := a_requested_processors.lower
			until
				i > a_requested_processors.upper
			loop
				requested_processor ?= a_requested_processors.item (i)
				if requested_processor /= void --and then not requested_processors.has (requested_processor)
					and then not a_caller_.processor_.locked_processors_has (requested_processor)
				then
					requested_processors.extend (requested_processor)
				end
				i := i + 1
			end
			from
				requested_processors.start
			until
				requested_processors.after or else not Result
			loop
				if not single_lock_acquired (a_caller_, requested_processors.item) then
					from
						requested_processors.back
					until
						requested_processors.before
					loop
						release_single_lock (a_caller_, requested_processors.item)
						requested_processors.back
					end
					Result := false
				end
				requested_processors.forth
			end
		end


	single_lock_acquired (a_caller_: SCOOP_SEPARATE_CLIENT; a_requested_processor: SCOOP_PROCESSOR): BOOLEAN is
			-- Check if lock on `a_requested_processor' can be acquired, if yes acquire it.
		require
			a_caller_non_void: a_caller_ /= void
			a_requested_processor_non_void: a_requested_processor /= void
		local
			a_processor: SCOOP_PROCESSOR
		do
			a_processor := a_requested_processor
			a_processor.mutex.lock
			if not a_processor.locked then
				a_processor.lock (a_caller_)
				Result := True
			end
			a_processor.mutex.unlock
		end


	release_locks (a_caller_: SCOOP_SEPARATE_CLIENT; a_requested_processors: TUPLE [SCOOP_PROCESSOR]) is
			-- Release locks on `a_requested_processors'.
			-- Release is synchronous, i.e. routine terminates when all locks have been released.
		require
			a_requested_processors_non_void: a_requested_processors /= void
			at_least_one_requested_processor: a_requested_processors.count > 0
		local
			i: INTEGER_32
			requested_processor: SCOOP_PROCESSOR
		do
			from
				i := a_requested_processors.lower
			until
				i > a_requested_processors.upper
			loop
				requested_processor ?= a_requested_processors.item (i)
				if requested_processor /= void and then requested_processor.locked_by = a_caller_.processor_ then
					release_single_lock (a_caller_, requested_processor)
				end
				i := i + 1
			end
		end


	release_locks_asynchronously (a_caller_: SCOOP_SEPARATE_CLIENT; a_requested_processors: TUPLE [SCOOP_PROCESSOR]) is
			-- Release locks on `a_requested_processors'.
			-- Release is asynchronous, i.e. routine terminates after scheduling release of locks but without waiting for them to be released.
		require
			a_requested_processors_non_void: a_requested_processors /= void
			at_least_one_requested_processor: a_requested_processors.count > 0
		local
			i: INTEGER_32
			requested_processor: SCOOP_PROCESSOR
		do
			from
				i := a_requested_processors.lower
			until
				i > a_requested_processors.upper
			loop
				requested_processor ?= a_requested_processors.item (i)
				if requested_processor /= void and then requested_processor.locked_by = a_caller_.processor_ then
					release_single_lock_asynchronously (a_caller_, requested_processor)
				end
				i := i + 1
			end
		end


	release_single_lock (a_caller_: SCOOP_SEPARATE_CLIENT; a_requested_processor: SCOOP_PROCESSOR) is
			-- Release lock on `a_requested_processor'.
			-- Release is synchronous, i.e. routine terminates when lock has been released.
		require
			a_caller_non_void: a_caller_ /= void
			a_requested_processor_non_void: a_requested_processor /= void
			locked_by_caller: a_requested_processor.locked_by = a_caller_.processor_
		do
			a_requested_processor.release_lock
		end


	release_single_lock_asynchronously (a_caller_: SCOOP_SEPARATE_CLIENT; a_requested_processor: SCOOP_PROCESSOR) is
			-- Release lock on `a_requested_processor'.
			-- Release is asynchronous, i.e. routine terminates after scheduling release of lock but without waiting for it to be released.
		require
			a_caller_non_void: a_caller_ /= void
			a_requested_processor_non_void: a_requested_processor /= void
			locked_by_caller: a_requested_processor.locked_by = a_caller_.processor_
		do
			a_requested_processor.asynchronous_execute (a_caller_, agent a_requested_processor.release_lock_and_signal_change)
		end


feature {NONE} -- Implementation

	routine_requests: LINKED_LIST [SCOOP_ROUTINE_REQUEST]
		-- List of routine requests.

	routine_requests_mutex: MUTEX
		-- Ensures exclusive access to `routine_requests'.

	processors: LINKED_LIST [SCOOP_PROCESSOR]
		-- List of processors.

	processors_mutex: MUTEX
		-- Ensures exclusive access to `processors'.

	execution_stopped: BOOLEAN
		-- Is application terminating?

	root_object: SCOOP_SEPARATE_CLIENT
		-- Root object.

	scoop_starter: SCOOP_STARTER_IMP
		-- Object that initializes SCOOP application.

	find_and_set_processor_ (a_caller_: SCOOP_SEPARATE_CLIENT) is
			-- Find processor that handles `a_caller_' and set `a_caller.processor_'.
		require
			a_caller_processor_void: a_caller_.processor_ = void
		local
			a_caller_thread_id: POINTER
		do
			a_caller_thread_id := get_current_id
			from
				processors_mutex.lock
				processors.start
			until
				a_caller_.processor_ /= void --or else processors.after
			loop
				if a_caller_thread_id = processors.item.thread_id then
					a_caller_.set_processor_ (processors.item)
				end
				processors.forth
			end
			processors_mutex.unlock
		end


feature {SCOOP_PROCESSOR} -- Update

	routine_request_update: SCOOP_AUTO_RESET_EVENT_HANDLE
		-- Indication that `routine_requests' list has been updated.
		-- If set, wake up thread servicing `routine_requests'.

	remove_processor (a_processor: SCOOP_PROCESSOR) is
		-- Remove `a_processor' from list of processors.
		require
			a_processor_not_void: a_processor /= void
		do
			processors_mutex.lock
			processors.start
			processors.prune (a_processor)
			if processors.is_empty then
				all_processors_finished.set
			end
			processors_mutex.unlock
		end


feature {SCOOP_STARTER_IMP} -- Termination

	all_processors_finished: SCOOP_AUTO_RESET_EVENT_HANDLE
		-- Indication that all processors have terminated.

feature {SCOOP_SEPARATE_CLIENT} -- Termination

	stop_execution is	--Highly unelegant. Obsolete.
			-- Signal it is time to stop the application.
		do
			execution_stopped := True
			routine_request_update.set
		ensure
			stop_execution_signalled: execution_stopped = True
		end

invariant
	routine_requests_not_void: routine_requests /= void
	processors_not_void: processors /= void
	routine_requests_mutex_not_void: routine_requests_mutex /= void
	processors_mutex_not_void: processors_mutex /= void
	routine_request_update_not_void: routine_request_update /= void

end -- class SCOOP_SEPARATE_HANDLER
