-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:DOMError"
class
	JS_DOM_ERROR

feature -- Introduced in DOM Level 3:

feature -- ErrorSeverity

	SEVERITY_WARNING: INTEGER
			-- The severity of the error described by the DOMError is warning. A
			-- SEVERITY_WARNING will not cause the processing to stop, unless
			-- DOMErrorHandler.handleError() returns false.
		external "C" alias "#1" end

	SEVERITY_ERROR: INTEGER
			-- The severity of the error described by the DOMError is error. A
			-- SEVERITY_ERROR may not cause the processing to stop if the error can be
			-- recovered, unless DOMErrorHandler.handleError() returns false.
		external "C" alias "#2" end

	SEVERITY_FATAL_ERROR: INTEGER
			-- The severity of the error described by the DOMError is fatal error. A
			-- SEVERITY_FATAL_ERROR will cause the normal processing to stop. The return
			-- value of DOMErrorHandler.handleError() is ignored unless the implementation
			-- chooses to continue, in which case the behavior becomes undefined.
		external "C" alias "#3" end

	severity: INTEGER
			-- The severity of the error, either SEVERITY_WARNING, SEVERITY_ERROR, or
			-- SEVERITY_FATAL_ERROR.
		external "C" alias "severity" end

	message: STRING
			-- An implementation specific string describing the error that occurred.
		external "C" alias "message" end

	type: STRING
			-- A DOMString indicating which related data is expected in relatedData. Users
			-- should refer to the specification of the error in order to find its
			-- DOMString type and relatedData definitions if any.
		external "C" alias "type" end

	related_exception: ANY
			-- The related platform dependent exception if any.
		external "C" alias "relatedException" end

	related_data: ANY
			-- The related DOMError.type dependent data if any.
		external "C" alias "relatedData" end

	location: JS_DOM_LOCATOR
			-- The location of the error.
		external "C" alias "location" end
end
