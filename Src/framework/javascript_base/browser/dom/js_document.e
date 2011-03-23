-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:Document"
class
	JS_DOCUMENT

inherit
	JS_NODE

feature -- Modified in DOM Level 3:

	doctype: JS_DOCUMENT_TYPE
			-- The Document Type Declaration (see DocumentType) associated with this
			-- document. For XML documents without a document type declaration this returns
			-- null. For HTML documents, a DocumentType object may be returned,
			-- independently of the presence or absence of document type declaration in the
			-- HTML document. This provides direct access to the DocumentType node, child
			-- node of this Document. This node can be set at document creation time and
			-- later changed through the use of child nodes manipulation methods, such as
			-- Node.insertBefore, or Node.replaceChild. Note, however, that while some
			-- implementations may instantiate different types of Document objects
			-- supporting additional features than the "Core", such as "HTML" [DOM Level 2
			-- HTML], based on the DocumentType specified at creation time, changing it
			-- afterwards is very unlikely to result in a change of the features supported.
		external "C" alias "doctype" end

	implementation: JS_DOM_IMPLEMENTATION
			-- The DOMImplementation object that handles this document. A DOM application
			-- may use objects from multiple implementations.
		external "C" alias "implementation" end

	document_element: JS_ELEMENT
			-- This is a convenience attribute that allows direct access to the child node
			-- that is the document element of the document.
		external "C" alias "documentElement" end

	create_element (a_tag_name: STRING): attached JS_ELEMENT
			-- Creates an element of the type specified. Note that the instance returned
			-- implements the Element interface, so attributes can be specified directly on
			-- the returned object. In addition, if there are known attributes with default
			-- values, Attr nodes representing them are automatically created and attached
			-- to the element. To create an element with a qualified name and namespace
			-- URI, use the createElementNS method.
		external "C" alias "createElement($a_tag_name)" end

	create_document_fragment: JS_DOCUMENT_FRAGMENT
			-- Creates an empty DocumentFragment object.
		external "C" alias "createDocumentFragment()" end

	create_text_node (a_data: STRING): attached JS_TEXT
			-- Creates a Text node given the specified string.
		external "C" alias "createTextNode($a_data)" end

	create_comment (a_data: STRING): JS_COMMENT
			-- Creates a Comment node given the specified string.
		external "C" alias "createComment($a_data)" end

	create_cdata_section (a_data: STRING): attached JS_CDATA_SECTION
			-- Creates a CDATASection node whose value is the specified string.
		external "C" alias "createCDATASection($a_data)" end

	create_processing_instruction (a_target: STRING; a_data: STRING): JS_PROCESSING_INSTRUCTION
			-- Creates a ProcessingInstruction node given the specified name and data
			-- strings.
		external "C" alias "createProcessingInstruction($a_target, $a_data)" end

	create_attribute (a_name: STRING): JS_ATTR
			-- Creates an Attr of the given name. Note that the Attr instance can then be
			-- set on an Element using the setAttributeNode method. To create an attribute
			-- with a qualified name and namespace URI, use the createAttributeNS method.
		external "C" alias "createAttribute($a_name)" end

	create_entity_reference (a_name: STRING): JS_ENTITY_REFERENCE
			-- Creates an EntityReference object. In addition, if the referenced entity is
			-- known, the child list of the EntityReference node is made the same as that
			-- of the corresponding Entity node. Note: If any descendant of the Entity node
			-- has an unbound namespace prefix, the corresponding descendant of the created
			-- EntityReference node is also unbound; (its namespaceURI is null). The DOM
			-- Level 2 and 3 do not support any mechanism to resolve namespace prefixes in
			-- this case.
		external "C" alias "createEntityReference($a_name)" end

	get_elements_by_tag_name (a_tagname: STRING): JS_NODE_LIST
			-- Returns a NodeList of all the Elements in document order with a given tag
			-- name and are contained in the document.
		external "C" alias "getElementsByTagName($a_tagname)" end

feature -- Introduced in DOM Level 2:

	import_node (a_imported_node: JS_NODE; a_deep: BOOLEAN): JS_NODE
			-- Imports a node from another document to this document, without altering or
			-- removing the source node from the original document; this method creates a
			-- new copy of the source node. The returned node has no parent; (parentNode is
			-- null). For all nodes, importing a node creates a node object owned by the
			-- importing document, with attribute values identical to the source node's
			-- nodeName and nodeType, plus the attributes related to namespaces (prefix,
			-- localName, and namespaceURI). As in the cloneNode operation, the source node
			-- is not altered. User data associated to the imported node is not carried
			-- over. However, if any UserDataHandlers has been specified along with the
			-- associated data these handlers will be called with the appropriate
			-- parameters before this method returns. Additional information is copied as
			-- appropriate to the nodeType, attempting to mirror the behavior expected if a
			-- fragment of XML or HTML source was copied from one document to another,
			-- recognizing that the two documents may have different DTDs in the XML case.
		external "C" alias "importNode($a_imported_node, $a_deep)" end

feature -- Introduced in DOM Level 2:

	create_element_ns (a_namespace_uri: STRING; a_qualified_name: STRING): JS_ELEMENT
			-- Creates an element of the given qualified name and namespace URI. Per [XML
			-- Namespaces], applications must use the value null as the namespaceURI
			-- parameter for methods if they wish to have no namespace.
		external "C" alias "createElementNS($a_namespace_uri, $a_qualified_name)" end

feature -- Introduced in DOM Level 2:

	create_attribute_ns (a_namespace_uri: STRING; a_qualified_name: STRING): JS_ATTR
			-- Creates an attribute of the given qualified name and namespace URI. Per [XML
			-- Namespaces], applications must use the value null as the namespaceURI
			-- parameter for methods if they wish to have no namespace.
		external "C" alias "createAttributeNS($a_namespace_uri, $a_qualified_name)" end

feature -- Introduced in DOM Level 2:

	get_elements_by_tag_name_ns (a_namespace_uri: STRING; a_local_name: STRING): JS_NODE_LIST
			-- Returns a NodeList of all the Elements with a given local name and namespace
			-- URI in document order.
		external "C" alias "getElementsByTagNameNS($a_namespace_uri, $a_local_name)" end

feature -- Introduced in DOM Level 2:

	get_element_by_id (a_element_id: STRING): JS_ELEMENT
			-- Returns the Element that has an ID attribute with the given value. If no
			-- such element exists, this returns null. If more than one element has an ID
			-- attribute with that value, what is returned is undefined. The DOM
			-- implementation is expected to use the attribute Attr.isId to determine if an
			-- attribute is of type ID. Note: Attributes with the name "ID" or "id" are not
			-- of type ID unless so defined.
		external "C" alias "getElementById($a_element_id)" end

feature -- Introduced in DOM Level 3:

	input_encoding: STRING
			-- An attribute specifying the encoding used for this document at the time of
			-- the parsing. This is null when it is not known, such as when the Document
			-- was created in memory.
		external "C" alias "inputEncoding" end

feature -- Introduced in DOM Level 3:

	xml_encoding: STRING
			-- An attribute specifying, as part of the XML declaration, the encoding of
			-- this document. This is null when unspecified or when it is not known, such
			-- as when the Document was created in memory.
		external "C" alias "xmlEncoding" end

feature -- Introduced in DOM Level 3:

	xml_standalone: BOOLEAN assign set_xml_standalone
			-- An attribute specifying, as part of the XML declaration, whether this
			-- document is standalone. This is false when unspecified.
		external "C" alias "xmlStandalone" end

	set_xml_standalone (a_xml_standalone: BOOLEAN)
			-- See xml_standalone
		external "C" alias "xmlStandalone=$a_xml_standalone" end

feature -- Introduced in DOM Level 3:

	xml_version: STRING assign set_xml_version
			-- An attribute specifying, as part of the XML declaration, the version number
			-- of this document. If there is no declaration and if this document supports
			-- the "XML" feature, the value is "1.0". If this document does not support the
			-- "XML" feature, the value is always null. Changing this attribute will affect
			-- methods that check for invalid characters in XML names. Application should
			-- invoke Document.normalizeDocument() in order to check for invalid characters
			-- in the Nodes that are already part of this Document.
		external "C" alias "xmlVersion" end

	set_xml_version (a_xml_version: STRING)
			-- See xml_version
		external "C" alias "xmlVersion=$a_xml_version" end

feature -- Introduced in DOM Level 3:

	strict_error_checking: BOOLEAN assign set_strict_error_checking
			-- An attribute specifying whether error checking is enforced or not. When set
			-- to false, the implementation is free to not test every possible error case
			-- normally defined on DOM operations, and not raise any DOMException on DOM
			-- operations or report errors while using Document.normalizeDocument(). In
			-- case of error, the behavior is undefined. This attribute is true by default.
		external "C" alias "strictErrorChecking" end

	set_strict_error_checking (a_strict_error_checking: BOOLEAN)
			-- See strict_error_checking
		external "C" alias "strictErrorChecking=$a_strict_error_checking" end

feature -- Introduced in DOM Level 3:

	document_uri: STRING assign set_document_uri
			-- The location of the document or null if undefined or if the Document was
			-- created using DOMImplementation.createDocument. No lexical checking is
			-- performed when setting this attribute; this could result in a null value
			-- returned when using Node.baseURI.
		external "C" alias "documentURI" end

	set_document_uri (a_document_uri: STRING)
			-- See document_uri
		external "C" alias "documentURI=$a_document_uri" end

feature -- Introduced in DOM Level 3:

	adopt_node (a_source: JS_NODE): JS_NODE
			-- Attempts to adopt a node from another document to this document. If
			-- supported, it changes the ownerDocument of the source node, its children, as
			-- well as the attached attribute nodes if there are any. If the source node
			-- has a parent it is first removed from the child list of its parent. This
			-- effectively allows moving a subtree from one document to another (unlike
			-- importNode() which create a copy of the source node instead of moving it).
			-- When it fails, applications should use Document.importNode() instead. Note
			-- that if the adopted node is already part of this document (i.e. the source
			-- and target document are the same), this method still has the effect of
			-- removing the source node from the child list of its parent, if any.
		external "C" alias "adoptNode($a_source)" end

feature -- Introduced in DOM Level 3:

	dom_config: JS_DOM_CONFIGURATION
			-- The configuration used when Document.normalizeDocument() is invoked.
		external "C" alias "domConfig" end

feature -- Introduced in DOM Level 3:

	normalize_document
			-- This method acts as if the document was going through a save and load cycle,
			-- putting the document in a "normal" form. As a consequence, this method
			-- updates the replacement tree of EntityReference nodes and normalizes Text
			-- nodes, as defined in the method Node.normalize(). Otherwise, the actual
			-- result depends on the features being set on the Document.domConfig object
			-- and governing what operations actually take place. Noticeably this method
			-- could also make the document namespace well-formed according to the
			-- algorithm described in Namespace Normalization, check the character
			-- normalization, remove the CDATASection nodes, etc. See DOMConfiguration for
			-- details.
		external "C" alias "normalizeDocument()" end

feature -- Introduced in DOM Level 3:

	rename_node (a_n: JS_NODE; a_namespace_uri: STRING; a_qualified_name: STRING): JS_NODE
			-- Rename an existing node of type ELEMENT_NODE or ATTRIBUTE_NODE. When
			-- possible this simply changes the name of the given node, otherwise this
			-- creates a new node with the specified name and replaces the existing node
			-- with the new node as described below. If simply changing the name of the
			-- given node is not possible, the following operations are performed: a new
			-- node is created, any registered event listener is registered on the new
			-- node, any user data attached to the old node is removed from that node, the
			-- old node is removed from its parent if it has one, the children are moved to
			-- the new node, if the renamed node is an Element its attributes are moved to
			-- the new node, the new node is inserted at the position the old node used to
			-- have in its parent's child nodes list if it has one, the user data that was
			-- attached to the old node is attached to the new node. When the node being
			-- renamed is an Element only the specified attributes are moved, default
			-- attributes originated from the DTD are updated according to the new element
			-- name. In addition, the implementation may update default attributes from
			-- other schemas. Applications should use Document.normalizeDocument() to
			-- guarantee these attributes are up-to-date.
		external "C" alias "renameNode($a_n, $a_namespace_uri, $a_qualified_name)" end
end
