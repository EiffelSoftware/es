-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html.
		Copyright © 2010 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C
		liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HashChangeEvent"
class
	JS_HASH_CHANGE_EVENT

inherit
	JS_EVENT

feature -- Basic Operation

	old_url: STRING
			-- Returns the URL of the session history entry that was previously current.
		external "C" alias "oldURL" end

	new_url: STRING
			-- Returns the URL of the session history entry that is now current.
		external "C" alias "newURL" end

	init_hash_change_event (a_type_arg: STRING; a_can_bubble_arg: BOOLEAN; a_cancelable_arg: BOOLEAN; a_old_url_arg: STRING; a_new_url_arg: STRING)
		external "C" alias "initHashChangeEvent($a_type_arg, $a_can_bubble_arg, $a_cancelable_arg, $a_old_url_arg, $a_new_url_arg)" end
end
