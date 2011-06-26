-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:Node"
class
	JS_NODE

feature -- NodeType

	ELEMENT_NODE: INTEGER
			-- The node is an Element.
		external "C" alias "#1" end

	ATTRIBUTE_NODE: INTEGER
			-- The node is an Attr.
		external "C" alias "#2" end

	TEXT_NODE: INTEGER
			-- The node is a Text node.
		external "C" alias "#3" end

	CDATA_SECTION_NODE: INTEGER
			-- The node is a CDATASection.
		external "C" alias "#4" end

	ENTITY_REFERENCE_NODE: INTEGER
			-- The node is an EntityReference.
		external "C" alias "#5" end

	ENTITY_NODE: INTEGER
			-- The node is an Entity.
		external "C" alias "#6" end

	PROCESSING_INSTRUCTION_NODE: INTEGER
			-- The node is a ProcessingInstruction.
		external "C" alias "#7" end

	COMMENT_NODE: INTEGER
			-- The node is a Comment.
		external "C" alias "#8" end

	DOCUMENT_NODE: INTEGER
			-- The node is a Document.
		external "C" alias "#9" end

	DOCUMENT_TYPE_NODE: INTEGER
			-- The node is a DocumentType.
		external "C" alias "#10" end

	DOCUMENT_FRAGMENT_NODE: INTEGER
			-- The node is a DocumentFragment.
		external "C" alias "#11" end

	NOTATION_NODE: INTEGER
			-- The node is a Notation.
		external "C" alias "#12" end

	node_name: STRING
			-- The name of this node, depending on its type; see the table above.
		external "C" alias "nodeName" end

	node_value: STRING assign set_node_value
			-- The value of this node, depending on its type; see the table above. When it
			-- is defined to be null, setting it has no effect, including if the node is
			-- read-only.
		external "C" alias "nodeValue" end

	set_node_value (a_node_value: STRING)
			-- See node_value
		external "C" alias "nodeValue=$a_node_value" end

	node_type: INTEGER
			-- A code representing the type of the underlying object, as defined above.
		external "C" alias "nodeType" end

	parent_node: JS_NODE
			-- The parent of this node. All nodes, except Attr, Document, DocumentFragment,
			-- Entity, and Notation may have a parent. However, if a node has just been
			-- created and not yet added to the tree, or if it has been removed from the
			-- tree, this is null.
		external "C" alias "parentNode" end

	child_nodes: JS_NODE_LIST
			-- A NodeList that contains all children of this node. If there are no
			-- children, this is a NodeList containing no nodes.
		external "C" alias "childNodes" end

	first_child: JS_NODE
			-- The first child of this node. If there is no such node, this returns null.
		external "C" alias "firstChild" end

	last_child: JS_NODE
			-- The last child of this node. If there is no such node, this returns null.
		external "C" alias "lastChild" end

	previous_sibling: JS_NODE
			-- The node immediately preceding this node. If there is no such node, this
			-- returns null.
		external "C" alias "previousSibling" end

	next_sibling: JS_NODE
			-- The node immediately following this node. If there is no such node, this
			-- returns null.
		external "C" alias "nextSibling" end

	attributes: JS_NAMED_NODE_MAP
			-- A NamedNodeMap containing the attributes of this node (if it is an Element)
			-- or null otherwise.
		external "C" alias "attributes" end

feature -- Modified in DOM Level 2:

	owner_document: JS_DOCUMENT
			-- The Document object associated with this node. This is also the Document
			-- object used to create new nodes. When this node is a Document or a
			-- DocumentType which is not used with any Document yet, this is null.
		external "C" alias "ownerDocument" end

feature -- Modified in DOM Level 3:

	insert_before (a_new_child: JS_NODE; a_ref_child: JS_NODE): JS_NODE
			-- Inserts the node newChild before the existing child node refChild. If
			-- refChild is null, insert newChild at the end of the list of children. If
			-- newChild is a DocumentFragment object, all of its children are inserted, in
			-- the same order, before refChild. If the newChild is already in the tree, it
			-- is first removed.
		external "C" alias "insertBefore($a_new_child, $a_ref_child)" end

feature -- Modified in DOM Level 3:

	replace_child (a_new_child: JS_NODE; a_old_child: JS_NODE): JS_NODE
			-- Replaces the child node oldChild with newChild in the list of children, and
			-- returns the oldChild node. If newChild is a DocumentFragment object,
			-- oldChild is replaced by all of the DocumentFragment children, which are
			-- inserted in the same order. If the newChild is already in the tree, it is
			-- first removed.
		external "C" alias "replaceChild($a_new_child, $a_old_child)" end

feature -- Modified in DOM Level 3:

	remove_child (a_old_child: JS_NODE): JS_NODE
			-- Removes the child node indicated by oldChild from the list of children, and
			-- returns it.
		external "C" alias "removeChild($a_old_child)" end

feature -- Modified in DOM Level 3:

	append_child (a_new_child: JS_NODE): JS_NODE
			-- Adds the node newChild to the end of the list of children of this node. If
			-- the newChild is already in the tree, it is first removed.
		external "C" alias "appendChild($a_new_child)" end

	has_child_nodes: BOOLEAN
			-- Returns whether this node has any children.
		external "C" alias "hasChildNodes()" end

	clone_node (a_deep: BOOLEAN): JS_NODE
			-- Returns a duplicate of this node, i.e., serves as a generic copy constructor
			-- for nodes. The duplicate node has no parent (parentNode is null) and no user
			-- data. User data associated to the imported node is not carried over.
			-- However, if any UserDataHandlers has been specified along with the
			-- associated data these handlers will be called with the appropriate
			-- parameters before this method returns. Cloning an Element copies all
			-- attributes and their values, including those generated by the XML processor
			-- to represent defaulted attributes, but this method does not copy any
			-- children it contains unless it is a deep clone. This includes text contained
			-- in an the Element since the text is contained in a child Text node. Cloning
			-- an Attr directly, as opposed to be cloned as part of an Element cloning
			-- operation, returns a specified attribute (specified is true). Cloning an
			-- Attr always clones its children, since they represent its value, no matter
			-- whether this is a deep clone or not. Cloning an EntityReference
			-- automatically constructs its subtree if a corresponding Entity is available,
			-- no matter whether this is a deep clone or not. Cloning any other type of
			-- node simply returns a copy of this node. Note that cloning an immutable
			-- subtree results in a mutable copy, but the children of an EntityReference
			-- clone are readonly. In addition, clones of unspecified Attr nodes are
			-- specified. And, cloning Document, DocumentType, Entity, and Notation nodes
			-- is implementation dependent.
		external "C" alias "cloneNode($a_deep)" end

feature -- Modified in DOM Level 3:

	normalize
			-- Puts all Text nodes in the full depth of the sub-tree underneath this Node,
			-- including attribute nodes, into a "normal" form where only structure (e.g.,
			-- elements, comments, processing instructions, CDATA sections, and entity
			-- references) separates Text nodes, i.e., there are neither adjacent Text
			-- nodes nor empty Text nodes. This can be used to ensure that the DOM view of
			-- a document is the same as if it were saved and re-loaded, and is useful when
			-- operations (such as XPointer [XPointer] lookups) that depend on a particular
			-- document tree structure are to be used. If the parameter
			-- "normalize-characters" of the DOMConfiguration object attached to the
			-- Node.ownerDocument is true, this method will also fully normalize the
			-- characters of the Text nodes.
		external "C" alias "normalize()" end

feature -- Introduced in DOM Level 2:

	is_supported (a_feature: STRING; a_version: STRING): BOOLEAN
			-- Tests whether the DOM implementation implements a specific feature and that
			-- feature is supported by this node, as specified in DOM Features.
		external "C" alias "isSupported($a_feature, $a_version)" end

feature -- Introduced in DOM Level 2:

	namespace_uri: STRING
			-- The namespace URI of this node, or null if it is unspecified (see XML
			-- Namespaces). This is not a computed value that is the result of a namespace
			-- lookup based on an examination of the namespace declarations in scope. It is
			-- merely the namespace URI given at creation time. For nodes of any type other
			-- than ELEMENT_NODE and ATTRIBUTE_NODE and nodes created with a DOM Level 1
			-- method, such as Document.createElement(), this is always null.
		external "C" alias "namespaceURI" end

feature -- Introduced in DOM Level 2:

	js_prefix: STRING assign set_js_prefix
			-- The namespace prefix of this node, or null if it is unspecified. When it is
			-- defined to be null, setting it has no effect, including if the node is
			-- read-only. Note that setting this attribute, when permitted, changes the
			-- nodeName attribute, which holds the qualified name, as well as the tagName
			-- and name attributes of the Element and Attr interfaces, when applicable.
			-- Setting the prefix to null makes it unspecified, setting it to an empty
			-- string is implementation dependent. Note also that changing the prefix of an
			-- attribute that is known to have a default value, does not make a new
			-- attribute with the default value and the original prefix appear, since the
			-- namespaceURI and localName do not change. For nodes of any type other than
			-- ELEMENT_NODE and ATTRIBUTE_NODE and nodes created with a DOM Level 1 method,
			-- such as createElement from the Document interface, this is always null.
		external "C" alias "prefix" end

	set_js_prefix (a_js_prefix: STRING)
			-- See js_prefix
		external "C" alias "prefix=$a_js_prefix" end

feature -- Introduced in DOM Level 2:

	local_name: STRING
			-- Returns the local part of the qualified name of this node. For nodes of any
			-- type other than ELEMENT_NODE and ATTRIBUTE_NODE and nodes created with a DOM
			-- Level 1 method, such as Document.createElement(), this is always null.
		external "C" alias "localName" end

feature -- Introduced in DOM Level 2:

	has_attributes: BOOLEAN
			-- Returns whether this node (if it is an element) has any attributes.
		external "C" alias "hasAttributes()" end

feature -- Introduced in DOM Level 3:

	base_uri: STRING
			-- The absolute base URI of this node or null if the implementation wasn't able
			-- to obtain an absolute URI. This value is computed as described in Base URIs.
			-- However, when the Document supports the feature "HTML" [DOM Level 2 HTML],
			-- the base URI is computed using first the value of the href attribute of the
			-- HTML BASE element if any, and the value of the documentURI attribute from
			-- the Document interface otherwise.
		external "C" alias "baseURI" end

feature -- DocumentPosition

	DOCUMENT_POSITION_DISCONNECTED: INTEGER
			-- The two nodes are disconnected. Order between disconnected nodes is always
			-- implementation-specific.
		external "C" alias "#0x01" end

	DOCUMENT_POSITION_PRECEDING: INTEGER
			-- The second node precedes the reference node.
		external "C" alias "#0x02" end

	DOCUMENT_POSITION_FOLLOWING: INTEGER
			-- The node follows the reference node.
		external "C" alias "#0x04" end

	DOCUMENT_POSITION_CONTAINS: INTEGER
			-- The node contains the reference node. A node which contains is always
			-- preceding, too.
		external "C" alias "#0x08" end

	DOCUMENT_POSITION_CONTAINED_BY: INTEGER
			-- The node is contained by the reference node. A node which is contained is
			-- always following, too.
		external "C" alias "#0x10" end

	DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC: INTEGER
			-- The determination of preceding versus following is implementation-specific.
		external "C" alias "#0x20" end

feature -- Introduced in DOM Level 3:

	compare_document_position (a_other: JS_NODE): INTEGER
			-- Compares the reference node, i.e. the node on which this method is being
			-- called, with a node, i.e. the one passed as a parameter, with regard to
			-- their position in the document and according to the document order.
		external "C" alias "compareDocumentPosition($a_other)" end

feature -- Introduced in DOM Level 3:

	text_content: STRING assign set_text_content
			-- This attribute returns the text content of this node and its descendants.
			-- When it is defined to be null, setting it has no effect. On setting, any
			-- possible children this node may have are removed and, if it the new string
			-- is not empty or null, replaced by a single Text node containing the string
			-- this attribute is set to.
		external "C" alias "textContent" end

	set_text_content (a_text_content: STRING)
			-- See text_content
		external "C" alias "textContent=$a_text_content" end

feature -- Introduced in DOM Level 3:

	is_same_node (a_other: JS_NODE): BOOLEAN
			-- Returns whether this node is the same node as the given one. This method
			-- provides a way to determine whether two Node references returned by the
			-- implementation reference the same object. When two Node references are
			-- references to the same object, even if through a proxy, the references may
			-- be used completely interchangeably, such that all attributes have the same
			-- values and calling the same DOM method on either reference always has
			-- exactly the same effect.
		external "C" alias "isSameNode($a_other)" end

feature -- Introduced in DOM Level 3:

	lookup_prefix (a_namespace_uri: STRING): STRING
			-- Look up the prefix associated to the given namespace URI, starting from this
			-- node. The default namespace declarations are ignored by this method. See
			-- Namespace Prefix Lookup for details on the algorithm used by this method.
		external "C" alias "lookupPrefix($a_namespace_uri)" end

feature -- Introduced in DOM Level 3:

	is_default_namespace (a_namespace_uri: STRING): BOOLEAN
			-- This method checks if the specified namespaceURI is the default namespace or
			-- not.
		external "C" alias "isDefaultNamespace($a_namespace_uri)" end

feature -- Introduced in DOM Level 3:

	lookup_namespace_uri (a_js_prefix: STRING): STRING
			-- Look up the namespace URI associated to the given prefix, starting from this
			-- node. See Namespace URI Lookup for details on the algorithm used by this
			-- method.
		external "C" alias "lookupNamespaceURI($a_js_prefix)" end

feature -- Introduced in DOM Level 3:

	is_equal_node (a_arg: JS_NODE): BOOLEAN
			-- Tests whether two nodes are equal. This method tests for equality of nodes,
			-- not sameness (i.e., whether the two nodes are references to the same object)
			-- which can be tested with Node.isSameNode(). All nodes that are the same will
			-- also be equal, though the reverse may not be true.
		external "C" alias "isEqualNode($a_arg)" end

feature -- Introduced in DOM Level 3:

	get_feature (a_feature: STRING; a_version: STRING): ANY
			-- This method returns a specialized object which implements the specialized
			-- APIs of the specified feature and version, as specified in DOM Features. The
			-- specialized object may also be obtained by using binding-specific casting
			-- methods but is not necessarily expected to, as discussed in Mixed DOM
			-- Implementations. This method also allow the implementation to provide
			-- specialized objects which do not support the Node interface.
		external "C" alias "getFeature($a_feature, $a_version)" end

feature -- Introduced in DOM Level 3:

	set_user_data (a_key: STRING; a_data: ANY; a_handler: JS_USER_DATA_HANDLER): ANY
			-- Associate an object to a key on this node. The object can later be retrieved
			-- from this node by calling getUserData with the same key.
		external "C" alias "setUserData($a_key, $a_data, $a_handler)" end

feature -- Introduced in DOM Level 3:

	get_user_data (a_key: STRING): ANY
			-- Retrieves the object associated to a key on a this node. The object must
			-- first have been set to this node by calling setUserData with the same key.
		external "C" alias "getUserData($a_key)" end

feature -- Modified in DOM Level 3:

	add_event_listener (a_type: STRING; a_listener: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN]; a_use_capture: BOOLEAN)
			-- Registers an event listener, depending on the useCapture parameter, on the
			-- capture phase of the DOM event flow or its target and bubbling phases.
		external "C" alias "addEventListener($a_type, $a_listener, $a_use_capture)" end

	remove_event_listener (a_type: STRING; a_listener: FUNCTION [ANY, attached TUPLE [attached JS_EVENT], BOOLEAN]; a_use_capture: BOOLEAN)
			-- Removes an event listener. Calling removeEventListener with arguments which
			-- do not identify any currently registered EventListener on the EventTarget
			-- has no effect.
		external "C" alias "removeEventListener($a_type, $a_listener, $a_use_capture)" end

	dispatch_event (a_evt: JS_EVENT): BOOLEAN
			-- Dispatches an event into the implementation's event model. The event target
			-- of the event must be the EventTarget object on which dispatchEvent is
			-- called.
		external "C" alias "dispatchEvent($a_evt)" end
end
