-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html.
		Copyright © 2010 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C
		liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:DocumentEvent"
class
	JS_DOCUMENT_EVENT

feature -- Modified in DOM Level 3:

	create_event (a_event_interface: STRING): JS_EVENT
			-- Creates an event object of the type specified.
		external "C" alias "createEvent($a_event_interface)" end
end
