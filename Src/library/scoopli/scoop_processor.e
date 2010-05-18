indexing
	description: "Objects that implement SCOOP processors."
	author: "Piotr Nienaltowski"
	date: "$Date$"
	revision: "$Revision$"
	build_number: "0.4.4000"

class
	SCOOP_PROCESSOR

inherit
	SCOOP_THREAD

	MEMORY
	undefine default_create end

create
	make

feature {NONE} -- Initialization

	make (a_scheduler: SCOOP_SCHEDULER)
			-- Creation procedure.
		do
			create locked_processors.make
			create locked_processors_mutex
			locked_processors.push ([Current])
			create synchronous_processors.make
			create synchronous_processors_mutex
			synchronous_processors.push (Current)
			create mutex
			create actions.make
			create actions_mutex
			create actions_empty.make (False)
			create actions_not_empty.make (False)
			create postcondition_counter_mutex
			scheduler := a_scheduler
			default_create
			-- SCOOP PROFILE
			if scheduler.profile_information.is_profiling_enabled then
				create profile_collector.make_with_processor (Current)
				profile_collector.set_information (scheduler.profile_information)
			end
		end

feature {SCOOP_SCHEDULER, SCOOP_SEPARATE_PROXY, SCOOP_PROFILER_COLLECTOR, SCOOP_ROUTINE_REQUEST} -- Profile collection

	profile_collector: SCOOP_PROFILER_COLLECTOR

feature -- Access

	signal_finished
			-- Signal that processor has finished.
		do
			finished := true
			signal_actions_not_empty -- to make sure any actions added afterwards are executed
		ensure
			finished: finished = True
		end


feature {SCOOP_PROCESSOR, SCOOP_SCHEDULER, SCOOP_SEPARATE_TYPE} -- Synchronization

	mutex: MUTEX
		-- Provides mutually exclusive access to processor.

	actions: LINKED_LIST [SCOOP_ACTION]
		-- List of actions to be executed by processor.

	actions_mutex: MUTEX
		-- Provides mutually exclusive access to list of actions.

	actions_not_empty: SCOOP_AUTO_RESET_EVENT_HANDLE
		-- There are actions to execute.

	signal_actions_not_empty
		-- Signal that there are actions to execute.
		do
			actions_not_empty.set
		end

	actions_empty: SCOOP_AUTO_RESET_EVENT_HANDLE
		-- There are no actions to execute.

	signal_actions_empty
		-- Signal that there are no actions to execute.
		do
			actions_empty.set
		end

	locked_by: SCOOP_PROCESSOR
		-- Processor that holds lock on current processor.

	locked: BOOLEAN
			-- Is processor locked?
		do
			Result := locked_by /= void
		end

	lock (a_lock_holder: SCOOP_SEPARATE_CLIENT)
			-- Lock processor.
		require
			not_locked: not locked
			actions.is_empty
		do
			if {SCOOP_LIBRARY_CONSTANTS}.Enable_profiler and profile_collector /= Void then
				profile_collector.collect_lock (locked_by, Current)
			end
			locked_by := a_lock_holder.processor_
		ensure
			lock_holder_set: locked_by = a_lock_holder.processor_
		end

	release_lock
			-- Unlock processor.
		require
			locked: locked
		do
			mutex.lock
			if {SCOOP_LIBRARY_CONSTANTS}.Enable_profiler and profile_collector /= Void then
				profile_collector.collect_unlock (locked_by, Current)
			end
			locked_by := void
			mutex.unlock
		ensure
			not_locked: not locked
		end

	release_lock_and_signal_change
			-- Unlock processor and signal it.
		require
			locked: locked
		local
			aux_counter: INTEGER_32
		do
			postcondition_counter_mutex.lock
			aux_counter := postcondition_counter
			postcondition_counter_mutex.unlock
			if aux_counter > 0 then	-- There are pending postconditions.
				add_action (Void, agent release_lock_and_signal_change)
				actions_mutex.lock
				if actions.count = 1 then
					signal_actions_empty
				end
				actions_mutex.unlock
			else					-- There are no pending postconditions.
--				mutex.lock
--				locked_by := void
--				mutex.unlock
				release_lock
				scheduler.routine_request_update.set
			end
		ensure
			-- not_locked: not locked
			-- this postcondition may not hold due to multithreading
		end

	finished: BOOLEAN

	auto_finished: BOOLEAN
		-- Should processor be destroyed?
		local
			references: SPECIAL [ANY]
			sep_type: SCOOP_SEPARATE_TYPE
			i: INTEGER_32
		do
			references := referers (Current)
			Result := true
			from
				i := 0
			until
				i = references.count or not Result
			loop
				sep_type ?= references.item (i)
				if sep_type /= Void and then sep_type.processor_ = Current then
					Result := false
				end
				i := i + 1
			end

		end

	locked_processors: SCOOP_TUPLE_PROCESSOR_STACK
		-- Processors that are locked (directly or indirectly) by current processor.
		-- Current processor is always in stack.

	locked_processors_mutex: MUTEX
		-- Provides mutually exclusive access to stack of locked processors.

	locked_processors_has (a_processor: SCOOP_PROCESSOR): BOOLEAN
			-- Does `a_processor' appear in `locked_processors'?
		require
			a_processor_not_void: a_processor /= void
		do
			locked_processors_mutex.lock
			Result := locked_processors.has (a_processor)
			locked_processors_mutex.unlock
		end

	locked_processors_push (a_processors: TUPLE [SCOOP_PROCESSOR])
			-- Push `a_processors' on top of `locked_processors' stack.
		require
			a_processors_not_void: a_processors /= void
		do
			locked_processors_mutex.lock
			locked_processors.push (a_processors)
			locked_processors_mutex.unlock
		end

	locked_processors_pop
			-- Pop the top of `locked_processors' stack.
		require
--			at_least_two_elements: locked_processors_count > 1
		do
			locked_processors_mutex.lock
			locked_processors.pop
			locked_processors_mutex.unlock
		ensure
--			not locked_processors.is_empty
		end

	locked_processors_push_whole_stack (a_stack: SCOOP_TUPLE_PROCESSOR_STACK)
			-- Push `a_stack' on top of `locked_processors'.
		do
			locked_processors_mutex.lock
			locked_processors.push_whole_stack (a_stack)
			locked_processors_mutex.unlock
		end


	locked_processors_trim (n: INTEGER_32)
			-- Trim `locked_processors' to size `n'. At least one element should be left.
		require
--			n_small_enough: n < locked_processors_count
			n_large_enough: n > 0
		do
			locked_processors_mutex.lock
			locked_processors.trim (n)
			locked_processors_mutex.unlock
		end

	locked_processors_count: INTEGER_32
			-- Size of `locked_processors' stack.
		do
			locked_processors_mutex.lock
			Result := locked_processors.count
			locked_processors_mutex.unlock
		end



	synchronous_processors: SCOOP_PROCESSOR_STACK
		-- Processors that should be called synchronously by current processor.
		-- Current processor is always in stack.

	synchronous_processors_mutex: MUTEX
		-- Provides mutually exclusive access to stack of synchronous processors.

	synchronous_processors_has (a_processor: SCOOP_PROCESSOR): BOOLEAN
			-- Does `a_processor' appear in `synchronous_processors'?
		require
			a_processor_not_void: a_processor /= void
		do
			synchronous_processors_mutex.lock
			Result := synchronous_processors.has (a_processor)
			synchronous_processors_mutex.unlock
		end

	synchronous_processors_push (a_processor: SCOOP_PROCESSOR)
			-- Push `a_processor' on top of `synchronous_processors' stack.
		require
			a_processor_not_void: a_processor /= void
		do
			synchronous_processors_mutex.lock
			synchronous_processors.push (a_processor)
			synchronous_processors_mutex.unlock
		end

	synchronous_processors_pop
			-- Pop the top of `synchronous_processors' stack.
		require
--			at_least_two_elements: synchronous_processors_count > 1
		do
			synchronous_processors_mutex.lock
			synchronous_processors.pop
			synchronous_processors_mutex.unlock
		ensure
--			not synchronous_processors.is_empty
		end

	synchronous_processors_push_whole_stack (a_stack: SCOOP_PROCESSOR_STACK)
			-- Push `a_stack' on top of `synchronous_processors'.
		do
			synchronous_processors_mutex.lock
			synchronous_processors.push_whole_stack (a_stack)
			synchronous_processors_mutex.unlock
		end

	synchronous_processors_trim (n: INTEGER_32)
			-- Trim `synchronous_processors' to size `n'. At least one element should be left.
		require
--			n_small_enough: n < synchronous_processors_count
			n_large_enough: n > 0
		do
			synchronous_processors_mutex.lock
			synchronous_processors.trim (n)
			synchronous_processors_mutex.unlock
		end

	synchronous_processors_count: INTEGER_32
			-- Size of `synchronous_processors' stack.
		do
			synchronous_processors_mutex.lock
			Result := synchronous_processors.count
			synchronous_processors_mutex.unlock
		end



feature {SCOOP_PROCESSOR, SCOOP_SCHEDULER, SCOOP_SEPARATE_TYPE} -- Postcondition handling

	postcondition_counter: INTEGER_32
		-- Number of pending separate postconditions.

	postcondition_counter_mutex: MUTEX
		-- Provides mutually exclusive access to postcondition counter.

	all_postconditions_evaluated: SCOOP_AUTO_RESET_EVENT_HANDLE
		-- There are no more pending postconditions.

	increase_postcondition_counter (i: INTEGER_32)
			-- Increase postcondition counter by i.
		require
			i > 0
		do
			postcondition_counter_mutex.lock
			postcondition_counter := postcondition_counter + i
--			all_postconditions_evaluated.reset
			postcondition_counter_mutex.unlock
		end

	decrease_postcondition_counter (i: INTEGER_32)
			-- Decrease postcondition counter by i.
		require
			i > 0
		do
			postcondition_counter_mutex.lock
			postcondition_counter := postcondition_counter - i
--			if postcondition_counter = 0 then
--				all_postconditions_evaluated.set
--			end
			postcondition_counter_mutex.unlock
		end

feature {SCOOP_SCHEDULER, SCOOP_SEPARATE_PROXY} -- Basic operations

	asynchronous_execute (a_requesting_object: SCOOP_SEPARATE_TYPE; a_routine: ROUTINE [ANY, TUPLE])
			-- Add `a_routine' to list of actions.
		do
			add_action (a_requesting_object, a_routine)
		end

	synchronous_execute (a_requesting_object: SCOOP_SEPARATE_TYPE; a_routine: ROUTINE [ANY, TUPLE])
			-- Add `a_routine' to list of actions and wait until it is executed.
		do
			add_action (a_requesting_object, a_routine)
			actions_empty.wait_one
		end

	add_action (a_requesting_object: SCOOP_SEPARATE_TYPE; an_action: ROUTINE [ANY, TUPLE])
			-- Add `an_action' to list of actions.
		require
--			requesting_processor_has_lock: a_requesting_object.processor_.locked_processors_has (Current)
			action_not_void: an_action /= void
		local
			action: SCOOP_ACTION
		do
			create action.make (an_action)
			actions_mutex.lock
			actions.extend (action)
			actions_empty.reset
			signal_actions_not_empty
			actions_mutex.unlock
		ensure
			-- actions.count = old actions.count + 1
			-- this postcondition may not hold due to multithreading
		end

feature {NONE} -- Implementation

	scheduler: SCOOP_SCHEDULER

	execute_thread
			-- Main execution loop.
			-- Execute actions (if any) from action list.
		local
			current_action: SCOOP_ACTION -- action currently scheduled for execution
		do
			from
				actions_not_empty.wait_one -- sleep until there are some actions to be executed
			until
				finished or auto_finished -- loop until `finished' has been signalled
			loop
				from
					actions_mutex.lock
				until
					actions.is_empty
				loop
					actions.start -- go to first action
					current_action := actions.item
					check current_action /= void end
					actions.remove -- remove `current_action' from list of actions
					actions_mutex.unlock -- allow clients to add actions in the meantime

					-- SCOOP PROFILE
					if {SCOOP_LIBRARY_CONSTANTS}.Enable_profiler and (profile_collector /= Void and attached {SCOOP_SEPARATE_TYPE} current_action.target) and then not profile_collector.has_separate_arguments (current_action.action) then
						profile_collector.collect_feature_wait (current_action.action, create {LINKED_LIST [SCOOP_PROCESSOR]}.make)
						profile_collector.collect_feature_application (current_action.action)
						current_action.action.apply -- execute action
						profile_collector.collect_feature_return (current_action.action)
					else
						current_action.action.apply -- execute action
					end

					actions_mutex.lock
				end
				signal_actions_empty
				actions_mutex.unlock
				actions_not_empty.wait_one -- sleep until there are some actions to be executed
			end
			scheduler.remove_processor (Current)
		end

invariant
	mutex_not_void: mutex /= void
	actions_mutex_not_void: actions_mutex /= void
	locked_processors_mutex_not_void: locked_processors_mutex /= void
	synchronous_processors_mutex_not_void: synchronous_processors_mutex /= void

	actions_not_void: actions /= void
	actions_empty_not_void: actions_empty /= void
	actions_not_empty_not_void: actions_not_empty /= void
	scheduler_not_void: scheduler /= void

	locked_processors_not_void: locked_processors /= void
--	locked_processors_not_empty: not locked_processors.is_empty
--	locked_processors_has_current: locked_processors.has (Current)
	synchronous_processors_not_void: synchronous_processors /= void
--	synchronous_processors_not_empty: not synchronous_processors.is_empty
--	synchronous_processors_has_current: synchronous_processors.has (Current)

	postcondition_counter_not_negative: postcondition_counter >= 0
	postcondition_counter_mutex_not_void: postcondition_counter_mutex /= void


end -- class PROCESSOR_HANDLER
