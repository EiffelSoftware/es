-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html.
		Copyright © 2010 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C
		liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:CustomEvent"
class
	JS_CUSTOM_EVENT

inherit
	JS_EVENT

feature -- Basic Operation

	detail: ANY
			-- Specifies some detail information about the Event.
		external "C" alias "detail" end

	init_custom_event (a_type_arg: STRING; a_can_bubble_arg: BOOLEAN; a_cancelable_arg: BOOLEAN; a_detail_arg: ANY)
			-- Initializes attributes of a CustomEvent object. This method has the same
			-- behavior as Event.initEvent().
		external "C" alias "initCustomEvent($a_type_arg, $a_can_bubble_arg, $a_cancelable_arg, $a_detail_arg)" end
end
