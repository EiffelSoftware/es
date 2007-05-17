indexing
	description: "Objects that control the replay of a run."
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

inherit
	CONTROLLER

	INTERNAL

create
	make

-- Assumptions: event_factory.last_event always contains the event that is
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

--TODO: 		--find way to say more about the current position of event_input (like line)
--					in case of an error.

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
			create event_reader
			create input_file.make (filename)
			input_file.open_read
			create parser.make (input_file, event_reader)

			caller := a_caller

			set_capture_replay_enabled(True)
			set_replay_phase(True)
		end

feature -- Access

	event_reader: EVENT_INPUT

	caller: CALLER

	resolver: ENTITY_RESOLVER

	has_error: BOOLEAN

	error_message: STRING

feature -- Measurement

feature -- Status report

feature -- Status setting

	set_event_factory(a_factory: EVENT_INPUT) is
			--
		do
			event_reader := a_factory
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
			-- Hook for capture/replay. Is to be placed at the end of a MethodBody
			-- 'res' is the Result of the Method that should be instrumented.
		local
			callee_observed: BOOLEAN
			callret: RETURN_EVENT
			observable_returnvalue: OBSERVABLE
			non_basic_return_entity: NON_BASIC_ENTITY
		do
			callee_observed := observed_stack.item
			observed_stack.remove

			if callee_observed /= observed_stack.item then
				-- boundary cross
				if event_reader.end_of_input then
					report_and_set_error ("Received Callret_event, but log is finished.")
				else
					set_error_status_for_callret (event_reader.last_event, res, callee_observed)
					if not has_error then
						callret ?= event_reader.last_event
						if callee_observed then
							--INCALLRET
							observable_returnvalue ?= res
							non_basic_return_entity ?= callret.return_value
							if non_basic_return_entity /= Void then
								if observable_returnvalue /= Void then
									-- This return value must be registered.
									resolver.register_object (observable_returnvalue, non_basic_return_entity)
								else
									report_and_set_error ("Received non-basic return value that is not observable")
								end
							end
							Result := res --don't change the return value.
						else
							--OUTCALLRET

							if callret.return_value /= Void then
								Result := resolver.resolve_entity(callret.return_value)
							end
						end
						event_reader.read_next_event
					end
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
			if target.is_observed /= caller_is_observed then
				--boundary cross
				if not event_reader.end_of_input then
					set_error_status_for_call (event_reader.last_event, feature_name, target, arguments)
					if not has_error then
						if target.is_observed then
							-- INCALL
							-- XXX nothing to do here (?)
						else
							call_event ?= event_reader.last_event
							--OUTCALL
							resolver.register_object (target, call_event.target)
							index_arguments(call_event.arguments, arguments)
						end
						-- Consume event
						event_reader.read_next_event
					end
				else
					report_and_set_error ("Received call event, but log is finished.")
				end
			end
			observed_stack.put (target.is_observed)
		end

	simulate_unobserved_body
			-- Handle all following incalls...
		require
			event_reader_not_void: event_reader /= Void
		local
			incall_event: INCALL_EVENT
		do
			--Handle all following incall events...
			from
				incall_event ?= event_reader.last_event
			until
				event_reader.end_of_input or (not event_reader.last_event.conforms_to(incall_event))
			loop
				incall_event ?= event_reader.last_event
				handle_incall_event(incall_event)
				-- the next event will be read by the triggered methodbody_start and
				-- methodbody_end...
			end
		end


	play is
			--
		do
			enter
			--grab first event...
			event_reader.read_next_event
			simulate_unobserved_body
			leave
		end


feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	report_and_set_error(message: STRING)
			-- Report that an out of sync error has occurred.
		require
			no_consecuting_errors: not has_error
		do
			has_error := True
			print("replay error: " + message)
			exceptions.raise ("replay error: " + message)
		end

	index_arguments (expected_arguments: LIST[ENTITY]; actual_arguments: TUPLE) is
			-- Make sure that all arguments are indexed in the object
			-- lookup table.
		require
			expected_arguments_not_void: expected_arguments /= Void
			actual_arguments_not_void: actual_arguments /= Void
			actual_argument_count_matches_expected: expected_arguments.count = actual_arguments.count
		local
			i: INTEGER
			non_basic: NON_BASIC_ENTITY
			observable: OBSERVABLE
		do
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



	set_error_status_for_call (event: EVENT; feature_name: STRING; target: ANY; arguments: TUPLE) is
			-- Check if the call event matches to what we actually have.
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
					if feature_name.is_equal(call.feature_name) then
						set_error_status_for_arguments (call, arguments)
					else
						report_and_set_error ("Expected call on feature '" + feature_name + "' but got" + call.feature_name)
					end
				else
					report_and_set_error("Expected incall event")
				end
			else
				report_and_set_error ("Expected call event")
			end

--			feature_name_correct: feature_name = call.feature_name
--			-- we could check, if the arguments conform, but probably this is too
--			-- expensive
--			end
		ensure
			is_call_event: has_error or is_instance_of (event, call_type_id)
--			feature_name matches.
			is_incall_event_if_target_is_observed: has_error or (target.is_observed implies is_instance_of(event, incall_type_id))
			is_outcall_event_if_target_is_unobserved: has_error or ((not target.is_observed) implies is_instance_of(event, outcall_type_id))
		end

	set_error_status_for_arguments(call: CALL_EVENT; arguments: TUPLE) is
			--
		require
			no_error: not has_error
			call_not_void: call /= Void
			arguments_not_void: arguments /= Void
		local
			i: INTEGER
		do
			if call.arguments.count = arguments.count then
				--does type of arguments match?
				from
					i := 1
				until
					has_error or i > arguments.count
				loop
					set_error_status_for_object(call.arguments[i],arguments[i])
					i := i + 1
				end
			end
		end

	set_error_status_for_object (expected_entity: ENTITY; object: ANY) is
			--
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
						report_and_set_error ("Got Void argument but expected non-Void argument")
					end
				end
			else
				expected_type := expected_entity.type
				actual_type := object.generating_type
				if not expected_type.is_equal (actual_type) then
					report_and_set_error("Mismatching argument Type. Expected '" +expected_type + "'but got '" + actual_type + "'")
				end
			end
		end

	set_error_status_for_callret(event: EVENT; return_value: ANY; is_incallret: BOOLEAN) is
			--
		require
			event_not_void: event /= Void
		local
			return_event: RETURN_EVENT
			incallret_event: INCALLRET_EVENT
			outcallret_event: OUTCALLRET_EVENT
		do
			return_event ?= event
			if return_event /= Void then
				if return_event.return_value /= Void then
					set_error_status_for_object (return_event.return_value, return_value)
				else
					if return_value /= Void then
						report_and_set_error ("Expected no return value, but received one.")
					end
				end
				if not has_error then
					if is_incallret then
						incallret_event ?= event
						if incallret_event = Void then
							report_and_set_error ("Expected incallret event")
						end
					else
						outcallret_event ?= event
						if outcallret_event = Void then
							report_and_set_error ("Expected outcallret event")
						end
					end
				end
			else
				report_and_set_error ("expected callret event")
			end

		end


	handle_incall_event (incall: INCALL_EVENT) is
			-- execute `incall'
		require
			incall_not_void: incall /= Void
		do
			caller.call (resolver.resolve_entity(incall.target), incall.feature_name, resolver.resolve_entities(incall.arguments))
		end

	--prototypes used for type comparison:
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
			Result := dynamic_type_from_string("OUTCALL_EVENT")
		end

	exceptions : EXCEPTIONS is
			-- Standard instance of EXCEPTIONS
		once
			create Result
		end




invariant
	invariant_clause: True -- Your invariant here

end
