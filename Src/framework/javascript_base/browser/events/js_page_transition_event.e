-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html.
		Copyright © 2010 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C
		liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:PageTransitionEvent"
class
	JS_PAGE_TRANSITION_EVENT

inherit
	JS_EVENT

feature -- Basic Operation

	persisted: BOOLEAN
			-- Returns false if the page is newly being loaded (and the load event will
			-- fire). Otherwise, returns true.
		external "C" alias "persisted" end

	init_page_transition_event (a_type_arg: STRING; a_can_bubble_arg: BOOLEAN; a_cancelable_arg: BOOLEAN; a_persisted_arg: BOOLEAN)
		external "C" alias "initPageTransitionEvent($a_type_arg, $a_can_bubble_arg, $a_cancelable_arg, $a_persisted_arg)" end
end
