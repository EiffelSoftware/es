-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:DOMImplementationSource"
class
	JS_DOM_IMPLEMENTATION_SOURCE

feature -- Introduced in DOM Level 3:

	get_d_o_m_implementation (a_features: STRING): JS_DOM_IMPLEMENTATION
			-- A method to request the first DOM implementation that supports the specified
			-- features.
		external "C" alias "getDOMImplementation($a_features)" end

	get_d_o_m_implementation_list (a_features: STRING): JS_DOM_IMPLEMENTATION_LIST
			-- A method to request a list of DOM implementations that support the specified
			-- features and versions, as specified in DOM Features.
		external "C" alias "getDOMImplementationList($a_features)" end
end
