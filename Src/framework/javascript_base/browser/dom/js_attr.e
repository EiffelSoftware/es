-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:Attr"
class
	JS_ATTR

inherit
	JS_NODE

feature -- Basic Operation

	name: STRING
			-- Returns the name of this attribute. If Node.localName is different from
			-- null, this attribute is a qualified name.
		external "C" alias "name" end

	specified: BOOLEAN
			-- True if this attribute was explicitly given a value in the instance
			-- document, false otherwise. If the application changed the value of this
			-- attribute node (even if it ends up having the same value as the default
			-- value) then it is set to true. The implementation may handle attributes with
			-- default values from other schemas similarly but applications should use
			-- Document.normalizeDocument() to guarantee this information is up-to-date.
		external "C" alias "specified" end

	value: STRING assign set_value
			-- On retrieval, the value of the attribute is returned as a string. Character
			-- and general entity references are replaced with their values. See also the
			-- method getAttribute on the Element interface. On setting, this creates a
			-- Text node with the unparsed contents of the string, i.e. any characters that
			-- an XML processor would recognize as markup are instead treated as literal
			-- text. See also the method Element.setAttribute(). Some specialized
			-- implementations, such as some [SVG 1.1] implementations, may do
			-- normalization automatically, even after mutation; in such case, the value on
			-- retrieval may differ from the value on setting.
		external "C" alias "value" end

	set_value (a_value: STRING)
			-- See value
		external "C" alias "value=$a_value" end

feature -- Introduced in DOM Level 2:

	owner_element: JS_ELEMENT
			-- The Element node this attribute is attached to or null if this attribute is
			-- not in use.
		external "C" alias "ownerElement" end

feature -- Introduced in DOM Level 3:

	schema_type_info: JS_TYPE_INFO
			-- The type information associated with this attribute. While the type
			-- information contained in this attribute is guarantee to be correct after
			-- loading the document or invoking Document.normalizeDocument(),
			-- schemaTypeInfo may not be reliable if the node was moved.
		external "C" alias "schemaTypeInfo" end

feature -- Introduced in DOM Level 3:

	is_id: BOOLEAN
			-- Returns whether this attribute is known to be of type ID (i.e. to contain an
			-- identifier for its owner element) or not. When it is and its value is
			-- unique, the ownerElement of this attribute can be retrieved using the method
			-- Document.getElementById.
		external "C" alias "isId" end
end
