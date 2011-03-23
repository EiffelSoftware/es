-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:NameList"
class
	JS_NAME_LIST

feature -- Introduced in DOM Level 3:

	get_name (a_index: INTEGER): STRING
			-- Returns the indexth name item in the collection.
		external "C" alias "getName($a_index)" end

	get_namespace_uri (a_index: INTEGER): STRING
			-- Returns the indexth namespaceURI item in the collection.
		external "C" alias "getNamespaceURI($a_index)" end

	length: INTEGER
			-- The number of pairs (name and namespaceURI) in the list. The range of valid
			-- child node indices is 0 to length-1 inclusive.
		external "C" alias "length" end

	contains (a_str: STRING): BOOLEAN
			-- Test if a name is part of this NameList.
		external "C" alias "contains($a_str)" end

	contains_ns (a_namespace_uri: STRING; a_name: STRING): BOOLEAN
			-- Test if the pair namespaceURI/name is part of this NameList.
		external "C" alias "containsNS($a_namespace_uri, $a_name)" end
end
