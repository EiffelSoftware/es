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
			-- The object has been constructed.
		external "C" alias "#0" end

	OPENED: INTEGER
			-- The open() method has been successfully invoked. During this state request
			-- headers can be set using setRequestHeader() and the request can be made
			-- using the send() method.
		external "C" alias "#1" end

	HEADERS_RECEIVED: INTEGER
			-- All redirects (if any) have been followed and all HTTP headers of the final
			-- response have been received. Several response members of the object are now
			-- available.
		external "C" alias "#2" end

	LOADING: INTEGER
			-- The response entity body is being received.
		external "C" alias "#3" end

	DONE: INTEGER
			-- The data transfer has been completed or something went wrong during the
			-- transfer (e.g. infinite redirects).
		external "C" alias "#4" end

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
			-- Appends an header to the list of author request headers or if the header is
			-- already in the author request headers its value appended to. Throws an
			-- INVALID_STATE_ERR exception if the state is not OPENED or if the send() flag
			-- is true. Throws a SYNTAX_ERR exception if header is not a valid HTTP header
			-- field name or if value is not a valid HTTP header field value.
		external "C" alias "setRequestHeader($a_header, $a_value)" end

	send
			-- Initiates the request. The optional argument provides the request entity
			-- body. The argument is ignored if request method is GET or HEAD. Throws an
			-- INVALID_STATE_ERR exception if the state is not OPENED or if the send() flag
			-- is true.
		external "C" alias "send()" end

	send2 (a_data: JS_DOCUMENT)
			-- Initiates the request. The optional argument provides the request entity
			-- body. The argument is ignored if request method is GET or HEAD. Throws an
			-- INVALID_STATE_ERR exception if the state is not OPENED or if the send() flag
			-- is true.
		external "C" alias "send($a_data)" end

	send3 (a_data: STRING)
			-- Initiates the request. The optional argument provides the request entity
			-- body. The argument is ignored if request method is GET or HEAD. Throws an
			-- INVALID_STATE_ERR exception if the state is not OPENED or if the send() flag
			-- is true.
		external "C" alias "send($a_data)" end

	abort
			-- Cancels any network activity.
		external "C" alias "abort()" end

feature -- response

	status: INTEGER
			-- Returns the HTTP status code.
		external "C" alias "status" end

	status_text: STRING
			-- Returns the HTTP status text.
		external "C" alias "statusText" end

	get_response_header (a_header: STRING): STRING
			-- Returns the header field value from the response of which the field name
			-- matches header, unless the field name is Set-Cookie or Set-Cookie2.
		external "C" alias "getResponseHeader($a_header)" end

	get_all_response_headers: STRING
			-- Returns all headers from the response, with the exception of those whose
			-- field name is Set-Cookie or Set-Cookie2.
		external "C" alias "getAllResponseHeaders()" end

	response_text: STRING
			-- Returns the text response entity body.
		external "C" alias "responseText" end

	response_xml: JS_DOCUMENT
			-- Returns the document response entity body.
		external "C" alias "responseXML" end
end
