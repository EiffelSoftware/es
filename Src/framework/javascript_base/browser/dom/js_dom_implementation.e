-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:DOMImplementation"
class
	JS_DOM_IMPLEMENTATION

feature -- Basic Operation

	has_feature (a_feature: STRING; a_version: STRING): BOOLEAN
			-- Test if the DOM implementation implements a specific feature and version, as
			-- specified in DOM Features.
		external "C" alias "hasFeature($a_feature, $a_version)" end

feature -- Introduced in DOM Level 2:

	create_document_type (a_qualified_name: STRING; a_public_id: STRING; a_system_id: STRING): JS_DOCUMENT_TYPE
			-- Creates an empty DocumentType node. Entity declarations and notations are
			-- not made available. Entity reference expansions and default attribute
			-- additions do not occur..
		external "C" alias "createDocumentType($a_qualified_name, $a_public_id, $a_system_id)" end

feature -- Introduced in DOM Level 2:

	create_document (a_namespace_uri: STRING; a_qualified_name: STRING; a_doctype: JS_DOCUMENT_TYPE): JS_DOCUMENT
			-- Creates a DOM Document object of the specified type with its document
			-- element. Note that based on the DocumentType given to create the document,
			-- the implementation may instantiate specialized Document objects that support
			-- additional features than the "Core", such as "HTML" [DOM Level 2 HTML]. On
			-- the other hand, setting the DocumentType after the document was created
			-- makes this very unlikely to happen. Alternatively, specialized Document
			-- creation methods, such as createHTMLDocument [DOM Level 2 HTML], can be used
			-- to obtain specific types of Document objects.
		external "C" alias "createDocument($a_namespace_uri, $a_qualified_name, $a_doctype)" end

feature -- Introduced in DOM Level 3:

	get_feature (a_feature: STRING; a_version: STRING): ANY
			-- This method returns a specialized object which implements the specialized
			-- APIs of the specified feature and version, as specified in DOM Features. The
			-- specialized object may also be obtained by using binding-specific casting
			-- methods but is not necessarily expected to, as discussed in Mixed DOM
			-- Implementations. This method also allow the implementation to provide
			-- specialized objects which do not support the DOMImplementation interface.
		external "C" alias "getFeature($a_feature, $a_version)" end
end
