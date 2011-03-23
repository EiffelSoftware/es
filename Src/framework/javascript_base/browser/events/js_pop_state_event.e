-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html.
		Copyright © 2010 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C
		liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:PopStateEvent"
class
	JS_POP_STATE_EVENT

inherit
	JS_EVENT

feature -- Basic Operation

	state: ANY
			-- Returns a copy of the information that was provided to pushState() or
			-- replaceState().
		external "C" alias "state" end

	init_pop_state_event (a_type_arg: STRING; a_can_bubble_arg: BOOLEAN; a_cancelable_arg: BOOLEAN; a_state_arg: ANY)
		external "C" alias "initPopStateEvent($a_type_arg, $a_can_bubble_arg, $a_cancelable_arg, $a_state_arg)" end
end
