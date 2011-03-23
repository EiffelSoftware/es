-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:DOMImplementationList"
class
	JS_DOM_IMPLEMENTATION_LIST

feature -- Introduced in DOM Level 3:

	item (a_index: INTEGER): JS_DOM_IMPLEMENTATION
			-- Returns the indexth item in the collection. If index is greater than or
			-- equal to the number of DOMImplementations in the list, this returns null.
		external "C" alias "item($a_index)" end

	length: INTEGER
			-- The number of DOMImplementations in the list. The range of valid child node
			-- indices is 0 to length-1 inclusive.
		external "C" alias "length" end
end
