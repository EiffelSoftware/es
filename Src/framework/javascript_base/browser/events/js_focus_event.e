-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html.
		Copyright © 2010 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C
		liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:FocusEvent"
class
	JS_FOCUS_EVENT

inherit
	JS_UI_EVENT

feature -- Basic Operation

	related_target: JS_EVENT_TARGET
			-- Used to identify a secondary EventTarget related to a Focus event, depending
			-- on the type of event. For security reasons with nested browsing contexts,
			-- when tabbing into or out of a nested context, the relevant EventTarget
			-- should be null.
		external "C" alias "relatedTarget" end

	init_focus_event (a_type_arg: STRING; a_can_bubble_arg: BOOLEAN; a_cancelable_arg: BOOLEAN; a_view_arg: ANY; a_detail_arg: INTEGER; a_related_target_arg: JS_EVENT_TARGET)
			-- Initializes attributes of a FocusEvent object. This method has the same
			-- behavior as UIEvent.initUIEvent().
		external "C" alias "initFocusEvent($a_type_arg, $a_can_bubble_arg, $a_cancelable_arg, $a_view_arg, $a_detail_arg, $a_related_target_arg)" end
end
