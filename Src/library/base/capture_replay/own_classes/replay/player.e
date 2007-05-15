indexing
	description: "Objects that control the replay of a run."
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

inherit
	CONTROLLER

create
	make

-- Assumptions: event_factory.last_event always contains the event that is
--				currently being treated. As soon as the treatment is finished
--				the next event will be read.
--				Thus every method handling an event can assume that the event it
--				should treat is in event_factory.last_event.


feature -- Initialization


		setup_on_text_file (filename: STRING; a_caller: CALLER)
			--
		local
--			resolver: ENTITY_RESOLVER
--			event_factory: EVENT_FACTORY
			parser: TEXT_EVENT_PARSER
			input_file: KL_TEXT_INPUT_FILE
		do
			create resolver.make
			create event_factory
			create input_file.make (filename)
			input_file.open_read
			create parser.make (input_file, event_factory)

			caller := a_caller

			set_capture_replay_enabled(True)
			is_replay_phase := True
		end

feature -- Access

	event_factory: EVENT_FACTORY

	caller: CALLER

	resolver: ENTITY_RESOLVER

feature -- Measurement

feature -- Status report

feature -- Status setting

	set_event_factory(a_factory: EVENT_FACTORY) is
			--
		do
			event_factory := a_factory
		end

	set_caller(a_caller: EXAMPLE_CALLER) is
			--
		require
			a_caller_not_void: a_caller /= Void
		do
			caller := a_caller
		end

	set_resolver(a_resolver: ENTITY_RESOLVER)
			-- Set `resolver' to `a_resolver'
		require
			resolver_not_void: a_resolver /= Void
		do
			resolver := a_resolver
		end

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

	methodbody_end (res: ANY): ANY is
			--Hook for capture/replay. Is to be placed at the end of a MethodBody
			--'res' is the Result of the Method that should be instrumented.
		local
			callee_observed: BOOLEAN
			outcallret: OUTCALLRET_EVENT
		do
			callee_observed := observed_stack.item
			observed_stack.remove

			if callee_observed /= observed_stack.item then
				if callee_observed then
					--INCALLRET
					-- ignore event:
					event_factory.create_next_event
					Result := res
				else
					--OUTCALLRET
					outcallret ?= event_factory.last_event
					check
						right_event_read: outcallret /= Void
					end
					if outcallret.return_value /= Void then
						Result := resolver.resolve_entity(outcallret.return_value)
					end
					event_factory.create_next_event
				end
			else
				Result := res
			end
		end

	methodbody_start (feature_name: STRING_8; target: OBSERVABLE; arguments: TUPLE) is
			-- Hook for capture/replay. Is to be placed before the methodbody is evaluated
			-- 'target' is the object whose feature was called
			-- 'arguments' are the arguments of the feature.
		local
			caller_is_observed: BOOLEAN
			call_event: CALL_EVENT
		do
			caller_is_observed := observed_stack.item
			call_event ?= event_factory.last_event
			if call_event /= Void then
				if target.is_observed /= caller_is_observed then
					--boundary cross
					check_call(event_factory.last_event,feature_name,target,arguments)
					if target.is_observed then
						--INCALL

					else
						--OUTCALL
						resolver.register_object (target, call_event.target)
						index_arguments(call_event.arguments, arguments)
					end
					-- Consume event
					event_factory.create_next_event
				end
			else
				report_out_of_sync_error("call_event", event_factory.last_event)
			end
			observed_stack.put (target.is_observed)
		end

	simulate_unobserved_body
			-- Handle all following incalls...
		local
			incall_event: INCALL_EVENT
		do
			from
				incall_event ?= event_factory.last_event
			until
				incall_event = Void
			loop
				handle_incall_event(incall_event)
	--			event_factory.create_next_event
				incall_event ?= event_factory.last_event
			end
		end


	play is
			--
		do
			enter
			--grab first event...
			event_factory.create_next_event
			simulate_unobserved_body
			leave
		end


feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	report_out_of_sync_error(expected_event_type: STRING; received_event: EVENT)
			-- Report that an out of sync error has occurred.
		do

		end

	report_argument_count_error(actual_number: INTEGER)
			--
		do

		end

	index_arguments(expected_arguments: LIST[ENTITY]; actual_arguments: TUPLE) is
			-- Make sure that all arguments are indexed in the object
			-- lookup table.
		local
			i: INTEGER
			non_basic: NON_BASIC_ENTITY
			observable: OBSERVABLE
		do
			--is there a mismatch regarding count of arguments?
			if expected_arguments.count /= actual_arguments.count then
				report_argument_count_error(actual_arguments.count)
			end

			--index all arguments
			from
				i := 1
			until
				i > expected_arguments.count or i > actual_arguments.count
			loop
				non_basic ?= expected_arguments @ i
				observable ?= actual_arguments @ i
				--TODO: raise error, if both arguments aren't both of the same kind (basic/non-basic)
				if non_basic /= Void and observable /= Void then
					resolver.register_object(observable, non_basic)
				end
				i := i + 1
			end
		end

	check_call(event: EVENT; feature_name: STRING; target: ANY; arguments: TUPLE)
			-- checks if the call event matches to what we actually have...
		local
			incall: INCALL_EVENT
			call: CALL_EVENT
		do
			call ?= event
			incall ?= event
			check
				event_is_call: call /= Void
				right_call_type: target.is_observed implies incall /= Void
				feature_name_correct: feature_name = call.feature_name
				-- we could check, if the arguments conform, but probably this is too
				-- expensive
			end
		end

	handle_incall_event (incall: INCALL_EVENT) is
			-- execute `incall'
		require
			incall_not_void: incall /= Void
		do
			caller.call (resolver.resolve_entity(incall.target), incall.feature_name, resolver.resolve_entities(incall.arguments))
		end

invariant
	invariant_clause: True -- Your invariant here

end
