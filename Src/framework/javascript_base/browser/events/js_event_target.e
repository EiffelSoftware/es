-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://dev.w3.org/2006/webapi/DOM-Level-3-Events/html/DOM3-Events.html.
		Copyright © 2010 W3C® (MIT, ERCIM, Keio), All Rights Reserved. W3C
		liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:EventTarget"
class
	JS_EVENT_TARGET

feature -- Basic Operation

	add_event_listener (a_type: STRING; a_listener: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN]; a_use_capture: BOOLEAN)
			-- Registers an event listener, depending on the useCapture parameter, on the
			-- capture phase of the DOM event flow or its target and bubbling phases.
		external "C" alias "addEventListener($a_type, $a_listener, $a_use_capture)" end

	remove_event_listener (a_type: STRING; a_listener: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN]; a_use_capture: BOOLEAN)
			-- Removes an event listener. Calling removeEventListener with arguments which
			-- do not identify any currently registered EventListener on the EventTarget
			-- has no effect.
		external "C" alias "removeEventListener($a_type, $a_listener, $a_use_capture)" end

feature -- Modified in DOM Level 3:

	dispatch_event (a_evt: JS_EVENT): BOOLEAN
			-- Dispatches an event into the implementation's event model. The event target
			-- of the event shall be the EventTarget object on which dispatchEvent is
			-- called.
		external "C" alias "dispatchEvent($a_evt)" end
end
