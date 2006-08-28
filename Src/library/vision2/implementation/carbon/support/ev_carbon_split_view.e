indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_CARBON_SPLIT_VIEW

inherit
	CARBONEVENTS_FUNCTIONS_EXTERNAL
		export
			 {NONE} all
		end
	CARBONEVENTSCORE_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		end

feature -- Constants

	class_id : STRING is "com.eiffel.vision2.carbon.splitview"

feature

	get_split_view_class : EV_CARBON_CF_STRING is
			-- Register the custom SplitView Class
		local
			event_array : EVENT_TYPE_SPEC_ARRAY
			err : INTEGER
		once
			create event_array.make_new_unshared( 2 )
			event_array.item ( 0 ).set_eventclass ( {HIOBJECT_ANON_ENUMS}.kEventClassHIObject )
			event_array.item ( 0 ).set_eventkind ( {HIOBJECT_ANON_ENUMS}.kEventHIObjectConstruct )

			event_array.item ( 1 ).set_eventclass ( {HIOBJECT_ANON_ENUMS}.kEventClassHIObject )
			event_array.item ( 1 ).set_eventkind ( {HIOBJECT_ANON_ENUMS}.kEventHIObjectDestruct )


			err := app_implementation.register_custom_control ( class_id, "com.apple.hiview", agent default_event_handler, event_array, default_pointer )

			create Result.make_unshared_with_eiffel_string ( class_id )
		end

		default_event_handler (a_inhandlercallref: POINTER; a_inevent: POINTER; a_inuserdata: POINTER): INTEGER is
				-- Handle construct and Destruct events
		local
			event_kind : INTEGER
		do
			event_kind := get_event_kind_external ( a_inevent )
			if event_kind = {HIOBJECT_ANON_ENUMS}.kEventHIObjectConstruct then
				Result := {EV_ANY_IMP}.noerr
			elseif event_kind = {HIOBJECT_ANON_ENUMS}.kEventHIObjectDestruct then
				Result := {EV_ANY_IMP}.noerr
			else
				Result := {CARBON_EVENTS_CORE_ANON_ENUMS}.eventnothandlederr
			end
		end

feature {NONE} -- Implementation

	app_implementation : EV_APPLICATION_IMP

invariant
	invariant_clause: True -- Your invariant here

end
