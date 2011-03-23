-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:XMLHttpRequest"
class
	JS_XML_HTTP_REQUEST

feature -- event handler attributes

	onreadystatechange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN] assign set_onreadystatechange
		external "C" alias "onreadystatechange" end

	set_onreadystatechange (a_onreadystatechange: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN])
		external "C" alias "onreadystatechange=$a_onreadystatechange" end

feature -- states

	UNSENT: INTEGER
		external "C" alias "0" end

	OPENED: INTEGER
		external "C" alias "1" end

	HEADERS_RECEIVED: INTEGER
		external "C" alias "2" end

	LOADING: INTEGER
		external "C" alias "3" end

	DONE: INTEGER
		external "C" alias "4" end

	ready_state: INTEGER
		external "C" alias "readyState" end

feature -- request

	open (a_method: STRING; a_url: STRING)
		external "C" alias "open($a_method, $a_url)" end

	open2 (a_method: STRING; a_url: STRING; a_async: BOOLEAN)
		external "C" alias "open($a_method, $a_url, $a_async)" end

	open3 (a_method: STRING; a_url: STRING; a_async: BOOLEAN; a_user: STRING)
		external "C" alias "open($a_method, $a_url, $a_async, $a_user)" end

	open4 (a_method: STRING; a_url: STRING; a_async: BOOLEAN; a_user: STRING; a_password: STRING)
		external "C" alias "open($a_method, $a_url, $a_async, $a_user, $a_password)" end

	set_request_header (a_header: STRING; a_value: STRING)
		external "C" alias "setRequestHeader($a_header, $a_value)" end

	send
		external "C" alias "send()" end

	send2 (a_data: JS_DOCUMENT)
		external "C" alias "send($a_data)" end

	send3 (a_data: STRING)
		external "C" alias "send($a_data)" end

	abort
		external "C" alias "abort()" end

feature -- response

	status: INTEGER
		external "C" alias "status" end

	status_text: STRING
		external "C" alias "statusText" end

	get_response_header (a_header: STRING): STRING
		external "C" alias "getResponseHeader($a_header)" end

	get_all_response_headers: STRING
		external "C" alias "getAllResponseHeaders()" end

	response_text: STRING
		external "C" alias "responseText" end

	response_xml: JS_DOCUMENT
		external "C" alias "responseXML" end
end
