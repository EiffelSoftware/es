note
	description: "Default event visitor, constructs profile abstraction from events.%
				 %To be used for COMPLETE sets of events (from start to end of application) only!"
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_DEFAULT_EVENT_VISITOR

inherit
	SCOOP_PROFILER_EVENT_VISITOR
		redefine
			visit_processor_start,
			visit_processor_end,
			visit_profiling_start,
			visit_profiling_end,
			visit_feature_external_call,
			visit_feature_call,
			visit_feature_wait,
			visit_feature_application,
			visit_feature_return,
			visit_feature_wait_condition
		end

create
	make_with_profile

feature -- Initialization

	make_with_profile (a_profile: like profile)
			-- Creation procedure.
		require
			profile_not_void: a_profile /= Void
		do
			profile := a_profile
			create calls.make (1)
			create stack.make (1)
			create external_call.make (1)
			create profiling.make (1)
		ensure
			calls_not_void: calls /= Void
			stack_not_void: stack /= Void
			external_call_not_void: external_call /= Void
			profile_set: profile = a_profile
			profiling_not_void: profiling /= Void
		end

feature -- Access

	profile: SCOOP_PROFILER_APPLICATION_PROFILE
			-- Reference to the application profile

feature -- Visitor

	visit_processor_start (a_event: SCOOP_PROFILER_PROCESSOR_START_EVENT)
			-- Visit processor start.
		do
			-- Set information
			find_processor (a_event.processor_id).set_start_time (a_event.time)

			-- Continue with events for this processor
			continue (a_event.processor_id)
		end

	visit_processor_end (a_event: SCOOP_PROFILER_PROCESSOR_END_EVENT)
			-- Visit processor end.
		do
			-- Set information
			find_processor (a_event.processor_id).set_stop_time (a_event.time)

			-- Continue with events for this processor
			continue (a_event.processor_id)
		end

	visit_profiling_start (a_event: SCOOP_PROFILER_PROFILING_START_EVENT)
			-- Visit profiling start.
		local
			p: SCOOP_PROFILER_PROCESSOR_PROFILE
			a: SCOOP_PROFILER_PROFILING_PROFILE
			s: LINKED_STACK [SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE]
		do
			-- Find processor
			p := find_processor (a_event.processor_id)

			-- Set information
			a := profile.new_profiling_profile
			a.set_processor (p)
			a.set_start_time (a_event.time)

			-- Save temporary
			if profiling.has (p.id) then
				profiling.remove (p.id)
			end
			profiling.extend (a, p.id)

			-- Continue with events for this processor
			continue (a_event.processor_id)
		end

	visit_profiling_end (a_event: SCOOP_PROFILER_PROFILING_END_EVENT)
			-- Visit profiling end.
		local
			p: SCOOP_PROFILER_PROCESSOR_PROFILE
			a: SCOOP_PROFILER_ACTION_PROFILE
			s: LINKED_STACK [SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE]
		do
			-- Find processor
			p := find_processor (a_event.processor_id)

			-- Find profiling
			a := profiling.item (p.id)

			debug ("SCOOP")
				if a = Void then
					io.put_string ("ERROR: profiling start not found%N")
				end
			end

			profiling.remove (p.id)

			-- Set information
			if attached {SCOOP_PROFILER_PROFILING_PROFILE} a then
				a.set_stop_time (a_event.time)
			else
				debug ("SCOOP")
					io.put_string ("ERROR: expected profiling, found feature call!%N")
				end
			end

			-- Add profiling to the caller
			s := stack.item (p.id)
			if p.stop_time = Void then
				if s.is_empty then
					if not p.calls.is_empty and then (attached {SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE} p.calls.last as t_call and a.start_time < p.calls.last.stop_time) then
						t_call.call_tree.extend (a)
					else
						p.calls.extend (a)
					end
				else
					if attached {SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE} s.item as t_call and then not t_call.call_tree.is_empty and then a.start_time < t_call.call_tree.last.stop_time then
						if attached {SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE} t_call.call_tree.last as t_internal then
							t_internal.call_tree.extend (a)
						else
							s.item.call_tree.extend (a)
						end
					else
						s.item.call_tree.extend (a)
					end
				end
			end

			-- Continue with events for this processor
			continue (a_event.processor_id)
		end

	visit_feature_external_call (a_event: SCOOP_PROFILER_FEATURE_EXTERNAL_CALL_EVENT)
			-- Visit external call.
		local
			p: SCOOP_PROFILER_PROCESSOR_PROFILE
			fc: SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE
		do
			-- Find elements
			p := find_processor (a_event.processor_id)
			if not stack.item (p.id).is_empty then
				fc := stack.item (p.id).item
			end

			debug ("SCOOP")
				if a_event.processor_id = a_event.called_id then
					io.put_string ("ERROR: invalid external call, caller = callee%N")
				end
			end

			if fc /= Void and then (fc.synchronous and fc.caller_processor.id = p.id and fc.processor.id /= p.id) then
				--| There is already a synchronous external call |--

				delay (p.id)
			elseif external_call.has (p.id) then
				--| We are already waiting for an external call  |--

				delay (p.id)
			else
				--| Ok, register external call                   |--

				external_call.extend (a_event, p.id)

				resume (a_event.called_id)
				continue (p.id)
				delay (p.id)
			end
		end

	visit_feature_call (a_event: SCOOP_PROFILER_FEATURE_CALL_EVENT)
			-- Visit feature call.
		local
			c: SCOOP_PROFILER_CLASS_PROFILE
			f: SCOOP_PROFILER_FEATURE_PROFILE
			fc: SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE
		do
			-- Find elements
			c := find_class (a_event)
			f := find_feature (a_event)

			-- Create feature call
			fc := profile.new_feature_call_application_profile
			fc.set_definition (f)
			fc.set_processor (find_processor (a_event.processor_id))
			fc.set_caller_processor (find_processor (a_event.caller_id))
			fc.set_call_time (a_event.time)
			fc.set_synchronous (a_event.synchronous)

			-- Add to calls
			calls.item (a_event.processor_id).extend (fc)

			-- Continue with events for this processor
			continue (a_event.processor_id)
		end

	visit_feature_wait (a_event: SCOOP_PROFILER_FEATURE_WAIT_EVENT)
			-- Visit feature wait.
		local
			p: SCOOP_PROFILER_PROCESSOR_PROFILE
			c: SCOOP_PROFILER_CLASS_PROFILE
			f: SCOOP_PROFILER_FEATURE_PROFILE
			fc: SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE
		do
			-- Find elements
			p := find_processor (a_event.processor_id)
			c := find_class (a_event)
			f := find_feature (a_event)
			-- Find call, but do not remove from the queue
			fc := find_call (a_event, False)

			if fc /= Void and then (p.id /= fc.caller_processor.id and not external_call.has (fc.caller_processor.id)) then
				--| This is an external call         |--
				--| but the caller is not ready      |--
				delay (p.id)
			else
				--| This is a local call or          |--
				--| external and the caller is ready |--

				-- Find call, removing it from the queue
				fc := find_call (a_event, True)
				if fc = Void then
					-- Create feature call
					fc := profile.new_feature_call_application_profile
					fc.set_definition (f)
					fc.set_processor (p)
					-- Set current as caller
					fc.set_caller_processor (p)
					fc.set_call_time (a_event.time)
					fc.set_synchronous (True)
				end

				-- Set information
				fc.set_sync_time (a_event.time)
				from
					a_event.requested_processor_ids.start
				until
					a_event.requested_processor_ids.after
				loop
					fc.requested_processors.extend (find_processor (a_event.requested_processor_ids.item))
					a_event.requested_processor_ids.forth
				end

				-- Add to stack
				stack.item (p.id).put (fc)

				-- Add to caller
				if fc.caller_processor.id /= p.id then
					if fc.synchronous then
						-- Synchronous call: push on top of caller stack
						stack.item (fc.caller_processor.id).put (fc)
					elseif not stack.item (fc.caller_processor.id).is_empty then
						-- Asynchronous call: add to call tree
						stack.item (fc.caller_processor.id).item.call_tree.extend (fc)
					elseif flag_root_feature then
						-- There is no caller (ok once for the root feature, else error)
						debug ("SCOOP")
							io.put_string ("WARN: caller stack empty... not adding!%N")
						end
					else
						flag_root_feature := True
					end
					external_call.remove (fc.caller_processor.id)
					resume (fc.caller_processor.id)
				end

				-- Continue with events for this processor
				continue (p.id)
			end
		end

	visit_feature_application (a_event: SCOOP_PROFILER_FEATURE_APPLICATION_EVENT)
			-- Visit feature application.
		local
			fc: SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE
		do
			-- Find elements
			fc := stack.item (a_event.processor_id).item

			debug ("SCOOP")
				if fc = Void then
					io.put_string ("ERROR: application of inexistent feature.%N")
				end
				if not (fc.feature_definition.name.is_equal (a_event.feature_name) and fc.feature_definition.class_definition.name.is_equal (a_event.class_name)) then
					io.put_string ("ERROR: application of wrong feature.%N")
				end
			end

			-- Set information
			fc.set_application_time (a_event.time)

			-- Continue with events for this processor
			continue (a_event.processor_id)
		end

	visit_feature_return (a_event: SCOOP_PROFILER_FEATURE_RETURN_EVENT)
			-- Visit feature return.
		local
			p: SCOOP_PROFILER_PROCESSOR_PROFILE
			f: SCOOP_PROFILER_FEATURE_PROFILE
			fc, fce: SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE
			s: LINKED_STACK [SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE]
		do
			-- Find elements
			p := find_processor (a_event.processor_id)
			s := stack.item (p.id)
			f := find_feature (a_event)
			fc := s.item

			if not (fc.feature_definition.name.is_equal (a_event.feature_name) and fc.feature_definition.class_definition.name.is_equal (a_event.class_name)) then
				--| We should wait for an internal feature |--

				delay (p.id)
			else
				--| It is possible to return               |--

				-- Remove from call stack
				s.remove

				-- Set time
				fc.set_return_time (a_event.time)

				-- Add to feature
				f.calls.extend (fc)

				-- Add to caller feature
				if s.is_empty then
					fc.processor.calls.extend (fc)
				else
					s.item.call_tree.extend (fc)
				end

				-- Add to caller processor
				if p.id /= fc.caller_processor.id and fc.synchronous then
					s := stack.item (fc.caller_processor.id)
					fce := s.item

					-- Remove from stack
					s.remove

					-- Add to caller
					if s.is_empty then
						debug ("SCOOP")
							io.put_string ("WARN: adding to external processor%N")
						end
						fc.caller_processor.calls.extend (fce)
					elseif s.item.caller_processor.id /= p.id then
						-- Only if this is not a callback
						s.item.call_tree.extend (fce)
					end

					resume (fc.caller_processor.id)
				end

				-- Continue with events for this processor
				continue (p.id)
			end
		end

	visit_feature_wait_condition (a_event: SCOOP_PROFILER_FEATURE_WAIT_CONDITION_EVENT)
			-- Visit wait condition try.
		local
			fc: SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE
		do
			-- Find elements
			fc := stack.item (a_event.processor_id).item

			debug ("SCOOP")
				if fc = Void then
					io.put_string ("ERROR: wait condition try of inexistent feature.%N")
				end
				if not (fc.feature_definition.name.is_equal (a_event.feature_name) and fc.feature_definition.class_definition.name.is_equal (a_event.class_name)) then
					io.put_string ("ERROR: wait condition try of wrong feature.%N")
				end
			end

			-- Add wait condition try
			fc.wait_conditions.extend (a_event.time)

			-- Continue with events for this processor
			continue (a_event.processor_id)
		end

feature {NONE} -- Element search

	find_processor (a_id: INTEGER): SCOOP_PROFILER_PROCESSOR_PROFILE
			-- What's the processor with id `a_id`?
		require
			id_positive: a_id > 0
		local
			l_call: LINKED_LIST [SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE]
			l_stack: LINKED_STACK [SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE]
		do
			if profile.processors.has (a_id) then
				Result := profile.processors.item (a_id)
			elseif a_id /= 0 then
				-- Create processor
				Result := profile.new_processor_profile
				Result.set_id (a_id)
				Result.set_application (profile)
				profile.processors.extend (Result, Result.id)

				-- Create call list and stack
				create l_call.make
				calls.extend (l_call, Result.id)
				create l_stack.make
				stack.extend (l_stack, Result.id)
			end
		ensure
			result_valid: Result /= Void and then Result.id = a_id
		end

	find_class (a_event: SCOOP_PROFILER_FEATURE_EVENT): SCOOP_PROFILER_CLASS_PROFILE
			-- What's the class for feature event `a_event`?
		require
			event_not_void: a_event /= Void
		do
			if not profile.classes.has (a_event.class_name) then
				-- Create class
				Result := profile.new_class_profile
				Result.set_name (a_event.class_name)
				Result.set_application (profile)
				profile.classes.extend (Result, Result.name)
			else
				Result := profile.classes.item (a_event.class_name)
			end
		ensure
			result_valid: Result /= Void and then (Result.name /= Void and then Result.name.is_equal (a_event.class_name))
		end

	find_feature (a_event: SCOOP_PROFILER_FEATURE_EVENT): SCOOP_PROFILER_FEATURE_PROFILE
			-- What's the feature for `a_event`?
		require
			event_not_void: a_event /= Void
		local
			c: SCOOP_PROFILER_CLASS_PROFILE
		do
			c := find_class (a_event)

			if not c.features.has (a_event.feature_name) then
				-- Create feature
				Result := profile.new_feature_profile
				Result.set_name (a_event.feature_name)
				Result.set_class_definition (c)
				c.features.extend (Result, Result.name)
			else
				Result := c.features.item (a_event.feature_name)
			end
		ensure
			result_valid: Result /= Void and then (Result.name /= Void and then Result.name.is_equal (a_event.feature_name))
		end

	find_call (a_event: SCOOP_PROFILER_FEATURE_WAIT_EVENT; a_remove: BOOLEAN): detachable SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE
			-- Which is the call for `a_event`?
		require
			event_not_void: a_event /= Void
		local
			q: LINKED_LIST [SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE]
		do
			-- Find call
			from
				q := calls.item (a_event.processor_id)
				q.start
			until
				q.after or Result /= Void
			loop
				if q.item.feature_definition.name.is_equal (a_event.feature_name) then
					Result := q.item
					if a_remove then
						q.prune (Result)
					end
				end
				if not q.after then
					q.forth
				end
			end
		ensure
			result_valid_feature: Result /= Void implies Result.feature_definition.name.is_equal (a_event.feature_name)
			result_valid_class: Result /= Void implies Result.feature_definition.class_definition.name.is_equal (a_event.class_name)
		end

feature {NONE} -- Implementation

	delay (a_processor: INTEGER)
			-- Delay events for processor with id `a_processor`.
		do
			loader.delay (a_processor)
		end

	resume (a_processor: INTEGER)
			-- Resume events for processor with id `a_processor`.
		do
			loader.resume (a_processor)
		end

	continue (a_processor: INTEGER)
			-- Continue with events for processor with id `a_processor`.
		do
			loader.continue (a_processor)
		end

feature {NONE} -- Implementation

	stack: HASH_TABLE [LINKED_STACK [SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE], INTEGER]
			-- Call stack for each processor

	calls: HASH_TABLE [LINKED_LIST [SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE], INTEGER]
			-- Calls for each processor

	external_call: HASH_TABLE [SCOOP_PROFILER_FEATURE_EXTERNAL_CALL_EVENT, INTEGER]
			-- External call waiting flags for each processor

	profiling: HASH_TABLE [SCOOP_PROFILER_PROFILING_PROFILE, INTEGER]
			-- Actual profiling action for each processor

	flag_root_feature: BOOLEAN
			-- Has root feature already been profiled?

invariant
	calls_not_void: calls /= Void
	stack_not_void: stack /= Void
	profile_not_void: profile /= Void
	external_call_not_void: external_call /= Void
	profiling_not_void: profiling /= Void

end
