indexing
	description: "Objects that control the replay of a run."
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

inherit
	PROGRAM_FLOW_SINK

	INTERNAL

create
	make

-- Assumptions: event_factory.last_event always contains theevent that is
--				currently being treated. As soon as the treatment is finished
--				the next event will be read.
--				Thus every method handling an event can assume that the event it
--				should treat is in event_factory.last_event.

-- Out-Of-Sync Problems:
--				When the observed code is being changed, it's possible that the
--				actual events dont't match the recorded ones. Symptoms for an
--				execution that is out of sync are:
--					-End of log is reached while still executing
--					-Called method doesn't match the one in the run log
--					-Arguments of the called method don't conform to the recorded ones.
--Questions: 	-is there a way to recover from that problem?
--				-What could be signalled to the players client?

feature -- Initialization


		setup_on_text_file (filename: STRING; a_caller: CALLER)
			-- Set the player up to the the replay of the text-log `filename'
		require
			filename_not_void: filename /= Void
			a_caller_not_void: a_caller /= Void
		local
			parser: TEXT_EVENT_PARSER
			input_file: KL_TEXT_INPUT_FILE
		do
			create resolver.make
			create event_input
			create input_file.make (filename)
			input_file.open_read
			create parser.make (input_file, event_input)

			caller := a_caller

			set_capture_replay_enabled (True)
			set_replay_phase (True)
		ensure
			capture_replay_enabled: is_capture_replay_enabled
			replay_phase_enabled: is_replay_phase
		end

feature -- Access

	event_input: EVENT_INPUT
		-- Input where the events are read from

	caller: CALLER
		-- Caller that executes the feature calls

	resolver: ENTITY_RESOLVER
		-- Resolver that resolves the entities to objects

	has_error: BOOLEAN
		-- Has an error occurred?

	error_message: STRING
		-- What error has occurred?
		-- Note: valid if `has_error' is True

feature -- Status setting

	set_event_input (a_factory: EVENT_INPUT) is
			-- Set `event_input'
		do
			event_input := a_factory
		end

	set_caller (a_caller: CALLER) is
			-- Set `caller'
		require
			a_caller_not_void: a_caller /= Void
		do
			caller := a_caller
		end

	set_resolver (a_resolver: ENTITY_RESOLVER)
			-- Set `resolver' to `a_resolver'
		require
			resolver_not_void: a_resolver /= Void
		do
			resolver := a_resolver
		end

feature -- Basic operations

	put_feature_exit (res: ANY): ANY is
			-- Notice that a feature exit event with result `res' occurred.
		local
			callee_observed: BOOLEAN
			callret: RETURN_EVENT
			non_basic_return_entity: NON_BASIC_ENTITY
		do
			if not has_error then
				callee_observed := observed_stack.item
				observed_stack.remove
				if callee_observed /= observed_stack.item then
					-- boundary cross
					if event_input.end_of_input then
						report_and_set_error ("Received Callret_event, but log is finished.")
					else
						set_error_status_for_callret (event_input.last_event, res, callee_observed)
						if not has_error then
							callret ?= event_input.last_event
							if callee_observed then
								--INCALLRET
								non_basic_return_entity ?= callret.return_value
								if non_basic_return_entity /= Void then
									if res /= Void then
										-- This return value must be registered.
										resolver.register_object (res, non_basic_return_entity)
									else
										report_and_set_error ("Received non-basic return value that is not observable")
									end
								end
								Result := res --don't change the return value.
							else
								--OUTCALLRET
								if callret.return_value /= Void then
									Result := resolver.resolve_entity (callret.return_value)
								end
							end
							consume_event
						end
					end
				else
					Result := res
				end
			end
		end

	put_feature_invocation (feature_name: STRING_8; target: ANY; arguments: TUPLE) is
			-- Notice that a feature invocation event (`target'.`feature_name'(`arguments')) occurred.
		local
			caller_is_observed: BOOLEAN
			call_event: CALL_EVENT
		do
			if not has_error then
				caller_is_observed := observed_stack.item
				observed_stack.put (target.is_observed)
				if target.is_observed /= caller_is_observed then
					--boundary cross
					if not event_input.end_of_input then
						set_error_status_for_call (event_input.last_event, feature_name, target, arguments)
						if not has_error then
							if target.is_observed then
								-- INCALL
								consume_event
							else
								call_event ?= event_input.last_event
								--OUTCALL
								resolver.register_object (target, call_event.target)
								index_arguments (call_event.arguments, arguments)
								consume_event
								if not has_error then
									simulate_unobserved_body
								end
							end
						end
					else
						report_and_set_error ("Received call event, but log is finished.")
					end
				end
			end
		end

	simulate_unobserved_body is
			-- Handle all consecuting incalls from the event_input.
		require
			event_input_not_void: event_input /= Void
			no_error: not has_error
			not_end_of_input: not event_input.end_of_input
		local
			incall_event: INCALL_EVENT
		do
			--Handle all following incall events...
			from
				incall_event ?= event_input.last_event
			until
				has_error or (incall_event = Void)
			loop
				handle_incall_event (incall_event)
				-- the next event will be read by the triggered methodbody_start and
				-- methodbody_end...
				if not event_input.end_of_input then
					incall_event ?= event_input.last_event
				else
					incall_event := Void
				end

			end
		end

	put_special_modification (target: SPECIAL[ANY]; size: INTEGER) is
			-- Record a special modification event.
		do
			print ("special modification!!! target: " + target.generating_type + "%N")
		end

	play is
			-- Replay the captured events from the event_input
		do
			enter
				-- Grab first event...
			consume_event
			if not has_error then
				simulate_unobserved_body
			end
			leave
		end

	accept(visitor: PROGRAM_FLOW_SINK_VISITOR) is
			-- Accept a visitor.
		do
			visitor.visit_player (Current)
		end

feature {NONE} -- Implementation

	report_and_set_error(message: STRING)
			-- Report that an out of sync error has occurred.
		require
			no_consecuting_errors: not has_error
			message_not_void: message /= Void
		do
			has_error := True
			print("replay error on event " + event_input.event_number.out + ": "+ message + "%N")
		ensure
			error_message_not_void: error_message /= Void
		end

	index_arguments (expected_arguments: DS_LIST[ENTITY]; actual_arguments: TUPLE) is
			-- Make sure that all arguments are indexed in the object
			-- lookup table.
		require
			no_error: not has_error
			expected_arguments_not_void: expected_arguments /= Void
			actual_arguments_not_void: actual_arguments /= Void
			actual_argument_count_matches_expected: expected_arguments.count = actual_arguments.count
		local
			i: INTEGER
			non_basic: NON_BASIC_ENTITY
			actual: ANY
		do
			--index all arguments
			from
				i := 1
			until
				i > expected_arguments.count or i > actual_arguments.count
			loop
				non_basic ?= expected_arguments @ i
				actual := actual_arguments @ i
				if non_basic /= Void and actual /= Void then
					resolver.register_object (actual, non_basic)
				end
				i := i + 1
			end
		ensure
			--all arguments are now found by the entity resolver, if looked up by these entities.
		end



	set_error_status_for_call (event: EVENT; feature_name: STRING; target: ANY; arguments: TUPLE) is
			-- Check if the recorded call event matches to the actual one and set `has_error' accordingly.
		require
			no_error: not has_error
			event_not_void: event /= Void
			feature_name_not_void: feature_name /= Void
			target_not_void: target /= Void
			arguments_not_void: arguments /= Void
		local
			incall: INCALL_EVENT
			call: CALL_EVENT
		do
			call ?= event
			incall ?= event
			if call /= Void then
				if target.is_observed implies (incall /= Void) then
					if feature_name.is_equal (call.feature_name) then
						set_error_status_for_arguments (call.arguments, arguments)
					else
						report_and_set_error ("Got call on feature '" + feature_name + "' but log has call to '" + call.feature_name + "' instead")
					end
				else
					report_and_set_error ("Got incall event, but current log entry is an outcall event")
				end
			else
				report_and_set_error ("Got call event, but current log entry is a different event")
			end
		ensure
			is_call_event: has_error or is_instance_of (event, call_type_id)
			is_incall_event_if_target_is_observed: has_error or (target.is_observed implies is_instance_of(event, incall_type_id))
			is_outcall_event_if_target_is_unobserved: has_error or ((not target.is_observed) implies is_instance_of(event, outcall_type_id))
		end

	set_error_status_for_arguments (expected_arguments: DS_LIST[ENTITY]; actual_arguments: TUPLE) is
			-- Check if the actual arguments match the expected ones and set `has_error' accordingly.
		require
			no_error: not has_error
			expected_arguments_not_void: expected_arguments /= Void
			arguments_not_void: actual_arguments /= Void
		local
			i: INTEGER
		do
			if expected_arguments.count = actual_arguments.count then
				--does type of arguments match?
				from
					i := 1
				until
					has_error or i > actual_arguments.count
				loop
					set_error_status_for_object (expected_arguments.item(i),actual_arguments[i])
					i := i + 1
				end
			end
		end

	set_error_status_for_object (expected_entity: ENTITY; object: ANY) is
			-- Check if expected_entity represents `object' and set `has_error' if this
			-- is not the case.
		require
			no_error: not has_error
			expected_entity_not_void: expected_entity /= Void
		local
			non_basic_entity: NON_BASIC_ENTITY
			expected_type: STRING
			actual_type: STRING
		do
			if object = Void then
				non_basic_entity ?= expected_entity
				if non_basic_entity = Void then
					report_and_set_error ("Expected basic entity '" + expected_entity.type +"' but got Void")
				else
					if non_basic_entity.id /= 0 then
						report_and_set_error ("Got Void object but expected non-Void object")
					end
				end
			else
				expected_type := expected_entity.type
				actual_type := object.generating_type
				if not expected_type.is_equal (actual_type) then
					report_and_set_error ("Mismatching argument Type. Expected '" +expected_type + "'but got '" + actual_type + "'")
				end
			end
		end

	set_error_status_for_callret (event: EVENT; return_value: ANY; is_incallret: BOOLEAN) is
			-- Check if `event' is a CALLRET - event and if it matches the actual callret event,
			-- set `has_error' if this is not the case.
		require
			event_not_void: event /= Void
		local
			return_event: RETURN_EVENT
			incallret_event: INCALLRET_EVENT
			outcallret_event: OUTCALLRET_EVENT
		do
			return_event ?= event
			if return_event /= Void then
				if is_incallret then
					-- Only return value of incallrets can be checked
					-- outcall retval not known yet.
					if return_event.return_value /= Void then
						set_error_status_for_object (return_event.return_value, return_value)
					else
						if return_value /= Void then
							report_and_set_error ("Expected no return value, but received one.")
						end
					end
					if not has_error then
						incallret_event ?= event
						if incallret_event = Void then
							report_and_set_error ("Expected incallret event")
						end
					end
				else
					outcallret_event ?= event
					if outcallret_event = Void then
						report_and_set_error ("Expected outcallret event")
					end
				end
			else
				report_and_set_error ("expected callret event")
			end
		end

	set_error_status_for_resolver (a_resolver: ENTITY_RESOLVER) is
			-- Sets and reports an error according to resolvers status.
		do
			if resolver.has_error then
				report_and_set_error ("error in entity resolver: " + a_resolver.error_message)
			end
		end


	consume_event is
			-- Go to the next event
		require
			no_error: not has_error
			not_end_of_input: not event_input.end_of_input
		do
			event_input.read_next_event
			if event_input.has_error then
				report_and_set_error ("Event Input - Error: " + event_input.error_message)
			end
		ensure
			event_read: not has_error implies old event_input.event_number > event_input.event_number
		end



	handle_incall_event (incall: INCALL_EVENT) is
			-- Execute the INCALL `incall'
		require
			incall_not_void: incall /= Void
		local
			target: ANY
			arguments: DS_LIST [ANY]
		do
			target := resolver.resolve_entity(incall.target)
			set_error_status_for_resolver(resolver)
			if not has_error then
				arguments := resolver.resolve_entities(incall.arguments)
				set_error_status_for_resolver(resolver)
				if not has_error then
					caller.call (target, incall.feature_name, arguments)
					if caller.has_error then
					report_and_set_error ("error in caller: " + caller.error_message)
					end
				end
			end
		end

feature {NONE}  -- Prototypes used for type comparison:

	call_type_id: INTEGER is
			-- Type_id of CALL_EVENT
		once
			Result := dynamic_type_from_string ("CALL_EVENT")
		end

	incall_type_id: INTEGER is
			-- Type_id of INCALL_EVENT
		once
			Result := dynamic_type_from_string ("INCALL_EVENT")
		end

	outcall_type_id: INTEGER is
			-- Type_id of OUTCALL_EVENT
		once
			Result := dynamic_type_from_string ("OUTCALL_EVENT")
		end

invariant
	invariant_clause: True -- Your invariant here

end
