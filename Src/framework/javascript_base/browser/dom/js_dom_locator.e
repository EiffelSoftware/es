-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:DOMLocator"
class
	JS_DOM_LOCATOR

feature -- Introduced in DOM Level 3:

	line_number: INTEGER
			-- The line number this locator is pointing to, or -1 if there is no column
			-- number available.
		external "C" alias "lineNumber" end

	column_number: INTEGER
			-- The column number this locator is pointing to, or -1 if there is no column
			-- number available.
		external "C" alias "columnNumber" end

	byte_offset: INTEGER
			-- The byte offset into the input source this locator is pointing to or -1 if
			-- there is no byte offset available.
		external "C" alias "byteOffset" end

	utf16_offset: INTEGER
			-- The UTF-16, as defined in [Unicode] and Amendment 1 of [ISO/IEC 10646],
			-- offset into the input source this locator is pointing to or -1 if there is
			-- no UTF-16 offset available.
		external "C" alias "utf16Offset" end

	related_node: JS_NODE
			-- The node this locator is pointing to, or null if no node is available.
		external "C" alias "relatedNode" end

	uri: STRING
			-- The URI this locator is pointing to, or null if no URI is available.
		external "C" alias "uri" end
end
