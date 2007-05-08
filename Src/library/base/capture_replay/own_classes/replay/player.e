indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

inherit
	CONTROLLER

create
	make

feature -- Initialization

	make is
		--
		do
			create observed_stack.make(100)
			observed_stack.put(False) --assume that we start in the unobserved space.
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
					Result := resolver.resolve_entity(outcallret.return_value)
					event_factory.create_next_event
				end
			else
				Result := res
			end

		end

	methodbody_start (feature_name: STRING_8; target: ANY; arguments: TUPLE) is
			-- Hook for capture/replay. Is to be placed before the methodbody is evaluated
			-- 'target' is the object whose feature was called
			-- 'arguments' are the arguments of the feature.
		local
			caller_is_observed: BOOLEAN
		do
			caller_is_observed := observed_stack.item

			if (not target.is_observed) and caller_is_observed then
				--OUTCALL
				consume_outcall

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
				event_factory.create_next_event
				incall_event ?= event_factory.last_event
			end
		end


	handle_incall_event (incall: INCALL_EVENT) is
			--
		require
			incall_not_void: incall /= Void
		do
			caller.call (resolver.resolve_entity(incall.target), incall.feature_name, resolver.resolve_entities(incall.arguments))
		end


	consume_outcall is
		do

		end


	consume_outcallret: ANY is
			--
		do

		end


	play is
			--
		do
			--grab first event...
			event_factory.create_next_event
			simulate_unobserved_body
		end


feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

	execute_incall is
			-- 	
		do
			--consume_incall event	
			--make call
			--consume incallret_event
		end

invariant
	invariant_clause: True -- Your invariant here

end
