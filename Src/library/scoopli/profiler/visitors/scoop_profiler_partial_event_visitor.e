note
	description: "Events visitor for partial time spans.%
				 %This IS to be used for partial profilings,%
				 %when either application start or application stop is not in range."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_PARTIAL_EVENT_VISITOR

inherit
	SCOOP_PROFILER_DEFAULT_EVENT_VISITOR
		redefine
			make_with_profile,
			visit_profiling_start,
			visit_profiling_end,
			visit_feature_external_call,
			visit_feature_wait,
			visit_feature_application,
			visit_feature_return,
			visit_feature_wait_condition,
			cleanup
		end

create
	make_with_profile

feature {NONE} -- Creation

	make_with_profile (a_profile: like profile)
			-- Creation procedure.
		do
			Precursor (a_profile)
			create started.make
		ensure then
			started_not_void: started /= Void
		end

feature {SCOOP_PROFILER_LOADER} -- Basic operation

	cleanup
			-- Cleanup.
		local
			l_item: SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE
			s: LINKED_STACK [SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE]
		do
			from
				stack.start
			until
				stack.is_empty
			loop
				if not stack.item_for_iteration.is_empty then
					l_item := stack.item_for_iteration.item
					l_item.set_incomplete
					if l_item.processor.id = stack.key_for_iteration then
						s := stack.item_for_iteration
						s.remove

						-- Set information
						if l_item.application_time = Void then
							l_item.set_application_time (loader.max)
						end
						l_item.set_return_time (loader.max)

						-- Add to feature
						--| FIXME: Should we add/remove this?
						-- Effects: average wait condition tries < 1 (but > 0); ...
						l_item.feature_definition.calls.extend (l_item)

						-- Add to caller
						if s.is_empty then
							l_item.processor.calls.extend (l_item)
							stack.remove (stack.key_for_iteration)
						else
							s.item.call_tree.extend (l_item)
						end

						-- Add to caller processor
						if l_item.processor.id /= l_item.caller_processor.id and l_item.synchronous then
							s := stack.item (l_item.caller_processor.id)
							l_item := s.item

							-- Remove from stack
							s.remove

							-- Add to caller
							if s.is_empty then
								debug ("SCOOP")
									io.put_string ("WARN: adding to external processor%N")
								end
								l_item.caller_processor.calls.extend (l_item)
								stack.remove (l_item.caller_processor.id)
							elseif s.item.caller_processor.id /= l_item.processor.id then
								-- Only if this is not a callback
								s.item.call_tree.extend (l_item)
							end
						end

						stack.start
					else
						stack.forth
						if stack.after then
							stack.start
						end
					end
				else
					stack.remove (stack.key_for_iteration)
					stack.start
				end
			end
		end

feature {SCOOP_PROFILER_EVENT} -- Visiting

	visit_profiling_start (a_event: SCOOP_PROFILER_PROFILING_START_EVENT)
			-- Visit profiling start.
		do
			if not started.has (a_event.processor_id) then
				started.extend (a_event.processor_id)
			end
			Precursor (a_event)
		end

	visit_profiling_end (a_event: SCOOP_PROFILER_PROFILING_END_EVENT)
			-- Visit profiling end.
		do
			if not started.has (a_event.processor_id) then
				continue (a_event.processor_id)
			else
				Precursor (a_event)
			end
		end

	visit_feature_external_call (a_event: SCOOP_PROFILER_FEATURE_EXTERNAL_CALL_EVENT)
			-- Visit external call.
		do
			if not started.has (a_event.processor_id) then
				started.extend (a_event.processor_id)
			end
			Precursor (a_event)
		end

	visit_feature_wait (a_event: SCOOP_PROFILER_FEATURE_WAIT_EVENT)
			-- Visit feature wait.
		do
			if not started.has (a_event.processor_id) then
				started.extend (a_event.processor_id)
			end
			Precursor (a_event)
		end

	visit_feature_application (a_event: SCOOP_PROFILER_FEATURE_APPLICATION_EVENT)
			-- Visit feature application.
		do
			if not started.has (a_event.processor_id) or not on_top (a_event) then
				continue (a_event.processor_id)
			else
				Precursor (a_event)
			end
		end

	visit_feature_return (a_event: SCOOP_PROFILER_FEATURE_RETURN_EVENT)
			-- Visit feature return.
		do
			if not started.has (a_event.processor_id) then
				continue (a_event.processor_id)
			elseif not on_stack (a_event) then
				--| FIXME Throw away the rest?
				continue (a_event.processor_id)
			else
				Precursor (a_event)
			end
		end

	visit_feature_wait_condition (a_event: SCOOP_PROFILER_FEATURE_WAIT_CONDITION_EVENT)
			-- Visit wait condition try.
		do
			if not started.has (a_event.processor_id) then
				continue (a_event.processor_id)
			elseif on_top (a_event) then
				Precursor (a_event)
			else
				continue (a_event.processor_id)
			end
		end

feature {NONE} -- Status report

	on_top (a_event: SCOOP_PROFILER_FEATURE_EVENT): BOOLEAN
			-- Is feature from `a_event` on top of stack?
		local
			s: LINKED_STACK [SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE]
		do
			if stack.has (a_event.processor_id) then
				s := stack.item (a_event.processor_id)
				if not s.is_empty then
					if
						s.item.feature_definition.name.is_equal (a_event.feature_name) and
						s.item.feature_definition.class_definition.name.is_equal (a_event.class_name)
					then
						Result := True
					end
				end
			end
		end

	on_stack (a_event: SCOOP_PROFILER_FEATURE_EVENT): BOOLEAN
			-- Is feature from `a_event` on stack?
		local
			s: LINKED_STACK [SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE]
			list: LIST [SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE]
		do
			if stack.has (a_event.processor_id) then
				s := stack.item (a_event.processor_id)
				if not s.is_empty then
					from
						list := s.linear_representation
						list.start
					until
						list.after or Result
					loop
						if
							list.item.feature_definition.name.is_equal (a_event.feature_name) and
							list.item.feature_definition.class_definition.name.is_equal (a_event.class_name)
						then
							Result := True
						end
						list.forth
					end
				end
			end
		end

feature {NONE} -- Implementation

	started: LINKED_SET [INTEGER]
			-- Started flags for each processor

invariant
	started_not_void: started /= Void

end
