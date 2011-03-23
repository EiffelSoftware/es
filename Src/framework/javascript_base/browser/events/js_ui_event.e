-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html.
		Copyright © 2010 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C
		liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:UIEvent"
class
	JS_UI_EVENT

inherit
	JS_EVENT

feature -- Basic Operation

	view: ANY
			-- The view attribute identifies the AbstractView from which the event was
			-- generated.
		external "C" alias "view" end

	detail: INTEGER
			-- Specifies some detail information about the Event, depending on the type of
			-- event.
		external "C" alias "detail" end

	init_u_i_event (a_type_arg: STRING; a_can_bubble_arg: BOOLEAN; a_cancelable_arg: BOOLEAN; a_view_arg: ANY; a_detail_arg: INTEGER)
			-- Initializes attributes of an UIEvent object. This method has the same
			-- behavior as Event.initEvent().
		external "C" alias "initUIEvent($a_type_arg, $a_can_bubble_arg, $a_cancelable_arg, $a_view_arg, $a_detail_arg)" end
end
