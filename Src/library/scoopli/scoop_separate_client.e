indexing
	description: "Objects that declare and use separate entities."
	author: "Piotr Nienaltowski"
	date: "$Date$"
	revision: "$Revision$"
	build_number: "0.4.4000"

deferred class
	SCOOP_SEPARATE_CLIENT

inherit
	SCOOP_SEPARATE_TYPE

--	THREAD_CONTROL
--		rename
--			join as scoop_join, join_all as scoop_join_all, yield as scoop_yield
--		end

--	EXCEPTIONS
--		rename
--			class_name as exceptions_class_name
--		end
feature {SCOOP_SEPARATE_CLIENT} -- Implementation

	separate_execute_routine (a_requested_processors: TUPLE [SCOOP_PROCESSOR]; a_routine: ROUTINE [SCOOP_SEPARATE_TYPE, TUPLE];
								a_wait_condition: FUNCTION [SCOOP_SEPARATE_CLIENT, TUPLE, BOOLEAN];
								a_separate_postcondition: ROUTINE [SCOOP_SEPARATE_CLIENT, TUPLE];
								a_non_separate_postcondition: ROUTINE [SCOOP_SEPARATE_CLIENT, TUPLE]) is
			-- Wait until exclusive locks on `a_requested_processors' are acquired and `a_wait_condition' holds, then execute `a_routine' and
			-- check `a_separate_postcondition' and `a_non_separate_postcondition'.
		require
			a_requested_processors_non_void: a_requested_processors /= void
			at_least_one_requested_processor: a_requested_processors.count > 0
			a_routine_non_void: a_routine /= void
		do
			scoop_scheduler.execute_routine (Current, a_requested_processors, a_routine, a_wait_condition, a_separate_postcondition, a_non_separate_postcondition)
		end

	separate_execute_routine_without_postconditions (a_requested_processors: TUPLE [SCOOP_PROCESSOR]; a_routine: ROUTINE [SCOOP_SEPARATE_TYPE, TUPLE]; a_wait_condition: FUNCTION [SCOOP_SEPARATE_CLIENT, TUPLE, BOOLEAN]) is
			-- Wait until exclusive locks on `a_requested_processors' are acquired and `a_wait_condition' holds, then execute `a_routine'.
		obsolete
			"Use `separate_execute_routine' instead."
		require
			a_requested_processors_non_void: a_requested_processors /= void
			at_least_one_requested_processor: a_requested_processors.count > 0
			a_routine_non_void: a_routine /= void
		do
			scoop_scheduler.execute_routine_without_postconditions (Current, a_requested_processors, a_routine, a_wait_condition)
		end

	unseparated_postconditions_left (an_unseparated_postconditions: LIST [ROUTINE [ANY, TUPLE]]): BOOLEAN is
			-- Evaluate unseparated postconditions.
		require
			an_unseparated_postconditions /= Void
		do
			from
				an_unseparated_postconditions.start
			until
				an_unseparated_postconditions.after
			loop
				an_unseparated_postconditions.item.call ([])
				an_unseparated_postconditions.forth
			end
		end

	evaluated_as_separate_postcondition (an_involved_suppliers: TUPLE []; a_routine: ROUTINE [ANY, TUPLE]): BOOLEAN is
			-- Evaluate separate postcondition asynchronously.
		require
			an_involved_supplierrs_not_empty: an_involved_suppliers /= void --and then an_involved_suppliers.count > 0
			a_routine_non_void: a_routine /= void
		local
			i: INTEGER_32
			supplier: SCOOP_SEPARATE_PROXY
		do
			if an_involved_suppliers.count > 0 then -- If there are no ivolved suppliers, then clause is evaluated synchronously
													-- i.e. 5 > 0 is treated like that.
				Result := True
			end
			from
				i := 1
			until
				i > an_involved_suppliers.count
			loop
				supplier ?= an_involved_suppliers.item (i)
				if scoop_is_local (supplier.processor_) then
					Result := False
					i := an_involved_suppliers.count + 1
				else
					i := i + 1
				end
			end
			if Result then
				supplier ?= an_involved_suppliers.item (1)
				supplier.evaluate_separate_postcondition (Current, a_routine)
			end
		end

	added_to_unseparated_postconditions (a_list: LIST [ROUTINE [ANY, TUPLE]]; a_routine: ROUTINE [ANY, TUPLE]): BOOLEAN is
			-- Extend `a_list' with `a_routine'.
		require
			a_list /= void
			a_routine /= void
		do
			a_list.extend (a_routine)
			Result := True
		end


	invariant_disabled: BOOLEAN
			-- Is invariant checking temporarily disabled?
			-- Solves invariant violation problem in creation procedures.


feature {NONE} -- Termination

	stop_execution_ is
			-- Stop execution of SCOOP system. Obsolete.
		do
			scoop_scheduler.stop_execution
		end



end -- class SCOOP_SEPARATE_CLIENT
