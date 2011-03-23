-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:DOMConfiguration"
class
	JS_DOM_CONFIGURATION

feature -- Introduced in DOM Level 3:

	set_parameter (a_name: STRING; a_value: ANY)
			-- Set the value of a parameter.
		external "C" alias "setParameter($a_name, $a_value)" end

	get_parameter (a_name: STRING): ANY
			-- Return the value of a parameter if known.
		external "C" alias "getParameter($a_name)" end

	can_set_parameter (a_name: STRING; a_value: ANY): BOOLEAN
			-- Check if setting a parameter to a specific value is supported.
		external "C" alias "canSetParameter($a_name, $a_value)" end

	parameter_names: JS_DOM_STRING_LIST
			-- The list of the parameters supported by this DOMConfiguration object and for
			-- which at least one value can be set by the application. Note that this list
			-- can also contain parameter names defined outside this specification.
		external "C" alias "parameterNames" end
end
