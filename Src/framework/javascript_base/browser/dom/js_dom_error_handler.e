-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:DOMErrorHandler"
class
	JS_DOM_ERROR_HANDLER

feature -- Introduced in DOM Level 3:

	handle_error (a_error: JS_DOM_ERROR): BOOLEAN
			-- This method is called on the error handler when an error occurs. If an
			-- exception is thrown from this method, it is considered to be equivalent of
			-- returning true.
		external "C" alias "handleError($a_error)" end
end
