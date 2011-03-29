-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:Element"
class
	JS_ELEMENT

inherit
	JS_NODE

feature -- Added by http://www.w3.org/TR/cssom-view

	get_client_rects: attached JS_CLIENT_RECT_LIST
			-- The getClientRects() and getBoundingClientRect methods provide information
			-- about the position of the border box edges of an element relative to the
			-- viewport. The objects these methods return must be static. That is, changes
			-- to the underlying document are not reflected in the objects.
		external "C" alias "getClientRects()" end

	get_bounding_client_rect: attached JS_CLIENT_RECT
			-- The getClientRects() and getBoundingClientRect methods provide information
			-- about the position of the border box edges of an element relative to the
			-- viewport. The objects these methods return must be static. That is, changes
			-- to the underlying document are not reflected in the objects.
		external "C" alias "getBoundingClientRect()" end

	scroll_top: INTEGER assign set_scroll_top
		external "C" alias "scrollTop" end

	set_scroll_top (a_scroll_top: INTEGER)
		external "C" alias "scrollTop=$a_scroll_top" end

	scroll_left: INTEGER assign set_scroll_left
		external "C" alias "scrollLeft" end

	set_scroll_left (a_scroll_left: INTEGER)
		external "C" alias "scrollLeft=$a_scroll_left" end

	scroll_width: INTEGER
		external "C" alias "scrollWidth" end

	scroll_height: INTEGER
		external "C" alias "scrollHeight" end

	client_top: INTEGER
		external "C" alias "clientTop" end

	client_left: INTEGER
		external "C" alias "clientLeft" end

	client_width: INTEGER
		external "C" alias "clientWidth" end

	client_height: INTEGER
		external "C" alias "clientHeight" end

feature -- Normal

	tag_name: STRING
			-- The name of the element. If Node.localName is different from null, this
			-- attribute is a qualified name.
		external "C" alias "tagName" end

	get_attribute (a_name: STRING): STRING
			-- Retrieves an attribute value by name.
		external "C" alias "getAttribute($a_name)" end

	set_attribute (a_name: STRING; a_value: STRING)
			-- Adds a new attribute. If an attribute with that name is already present in
			-- the element, its value is changed to be that of the value parameter. This
			-- value is a simple string; it is not parsed as it is being set. So any markup
			-- (such as syntax to be recognized as an entity reference) is treated as
			-- literal text, and needs to be appropriately escaped by the implementation
			-- when it is written out. In order to assign an attribute value that contains
			-- entity references, the user must create an Attr node plus any Text and
			-- EntityReference nodes, build the appropriate subtree, and use
			-- setAttributeNode to assign it as the value of an attribute. To set an
			-- attribute with a qualified name and namespace URI, use the setAttributeNS
			-- method.
		external "C" alias "setAttribute($a_name, $a_value)" end

	remove_attribute (a_name: STRING)
			-- Removes an attribute by name. If a default value for the removed attribute
			-- is defined in the DTD, a new attribute immediately appears with the default
			-- value as well as the corresponding namespace URI, local name, and prefix
			-- when applicable. The implementation may handle default values from other
			-- schemas similarly but applications should use Document.normalizeDocument()
			-- to guarantee this information is up-to-date. If no attribute with this name
			-- is found, this method has no effect. To remove an attribute by local name
			-- and namespace URI, use the removeAttributeNS method.
		external "C" alias "removeAttribute($a_name)" end

	get_attribute_node (a_name: STRING): JS_ATTR
			-- Retrieves an attribute node by name. To retrieve an attribute node by
			-- qualified name and namespace URI, use the getAttributeNodeNS method.
		external "C" alias "getAttributeNode($a_name)" end

	set_attribute_node (a_new_attr: JS_ATTR): JS_ATTR
			-- Adds a new attribute node. If an attribute with that name (nodeName) is
			-- already present in the element, it is replaced by the new one. Replacing an
			-- attribute node by itself has no effect. To add a new attribute node with a
			-- qualified name and namespace URI, use the setAttributeNodeNS method.
		external "C" alias "setAttributeNode($a_new_attr)" end

	remove_attribute_node (a_old_attr: JS_ATTR): JS_ATTR
			-- Removes the specified attribute node. If a default value for the removed
			-- Attr node is defined in the DTD, a new node immediately appears with the
			-- default value as well as the corresponding namespace URI, local name, and
			-- prefix when applicable. The implementation may handle default values from
			-- other schemas similarly but applications should use
			-- Document.normalizeDocument() to guarantee this information is up-to-date.
		external "C" alias "removeAttributeNode($a_old_attr)" end

	get_elements_by_tag_name (a_name: STRING): JS_NODE_LIST
			-- Returns a NodeList of all descendant Elements with a given tag name, in
			-- document order.
		external "C" alias "getElementsByTagName($a_name)" end

feature -- Introduced in DOM Level 2:

	get_attribute_ns (a_namespace_uri: STRING; a_local_name: STRING): STRING
			-- Retrieves an attribute value by local name and namespace URI.
		external "C" alias "getAttributeNS($a_namespace_uri, $a_local_name)" end

feature -- Introduced in DOM Level 2:

	set_attribute_ns (a_namespace_uri: STRING; a_qualified_name: STRING; a_value: STRING)
			-- Adds a new attribute. If an attribute with the same local name and namespace
			-- URI is already present on the element, its prefix is changed to be the
			-- prefix part of the qualifiedName, and its value is changed to be the value
			-- parameter. This value is a simple string; it is not parsed as it is being
			-- set. So any markup (such as syntax to be recognized as an entity reference)
			-- is treated as literal text, and needs to be appropriately escaped by the
			-- implementation when it is written out. In order to assign an attribute value
			-- that contains entity references, the user must create an Attr node plus any
			-- Text and EntityReference nodes, build the appropriate subtree, and use
			-- setAttributeNodeNS or setAttributeNode to assign it as the value of an
			-- attribute.
		external "C" alias "setAttributeNS($a_namespace_uri, $a_qualified_name, $a_value)" end

feature -- Introduced in DOM Level 2:

	remove_attribute_ns (a_namespace_uri: STRING; a_local_name: STRING)
			-- Removes an attribute by local name and namespace URI. If a default value for
			-- the removed attribute is defined in the DTD, a new attribute immediately
			-- appears with the default value as well as the corresponding namespace URI,
			-- local name, and prefix when applicable. The implementation may handle
			-- default values from other schemas similarly but applications should use
			-- Document.normalizeDocument() to guarantee this information is up-to-date. If
			-- no attribute with this local name and namespace URI is found, this method
			-- has no effect.
		external "C" alias "removeAttributeNS($a_namespace_uri, $a_local_name)" end

feature -- Introduced in DOM Level 2:

	get_attribute_node_ns (a_namespace_uri: STRING; a_local_name: STRING): JS_ATTR
			-- Retrieves an Attr node by local name and namespace URI.
		external "C" alias "getAttributeNodeNS($a_namespace_uri, $a_local_name)" end

feature -- Introduced in DOM Level 2:

	set_attribute_node_ns (a_new_attr: JS_ATTR): JS_ATTR
			-- Adds a new attribute. If an attribute with that local name and that
			-- namespace URI is already present in the element, it is replaced by the new
			-- one. Replacing an attribute node by itself has no effect.
		external "C" alias "setAttributeNodeNS($a_new_attr)" end

feature -- Introduced in DOM Level 2:

	get_elements_by_tag_name_ns (a_namespace_uri: STRING; a_local_name: STRING): JS_NODE_LIST
			-- Returns a NodeList of all the descendant Elements with a given local name
			-- and namespace URI in document order.
		external "C" alias "getElementsByTagNameNS($a_namespace_uri, $a_local_name)" end

feature -- Introduced in DOM Level 2:

	has_attribute (a_name: STRING): BOOLEAN
			-- Returns true when an attribute with a given name is specified on this
			-- element or has a default value, false otherwise.
		external "C" alias "hasAttribute($a_name)" end

feature -- Introduced in DOM Level 2:

	has_attribute_ns (a_namespace_uri: STRING; a_local_name: STRING): BOOLEAN
			-- Returns true when an attribute with a given local name and namespace URI is
			-- specified on this element or has a default value, false otherwise.
		external "C" alias "hasAttributeNS($a_namespace_uri, $a_local_name)" end

feature -- Introduced in DOM Level 3:

	schema_type_info: JS_TYPE_INFO
			-- The type information associated with this element.
		external "C" alias "schemaTypeInfo" end

feature -- Introduced in DOM Level 3:

	set_id_attribute (a_name: STRING; a_is_id: BOOLEAN)
			-- If the parameter isId is true, this method declares the specified attribute
			-- to be a user-determined ID attribute. This affects the value of Attr.isId
			-- and the behavior of Document.getElementById, but does not change any schema
			-- that may be in use, in particular this does not affect the
			-- Attr.schemaTypeInfo of the specified Attr node. Use the value false for the
			-- parameter isId to undeclare an attribute for being a user-determined ID
			-- attribute.  To specify an attribute by local name and namespace URI, use the
			-- setIdAttributeNS method.
		external "C" alias "setIdAttribute($a_name, $a_is_id)" end

feature -- Introduced in DOM Level 3:

	set_id_attribute_ns (a_namespace_uri: STRING; a_local_name: STRING; a_is_id: BOOLEAN)
			-- If the parameter isId is true, this method declares the specified attribute
			-- to be a user-determined ID attribute. This affects the value of Attr.isId
			-- and the behavior of Document.getElementById, but does not change any schema
			-- that may be in use, in particular this does not affect the
			-- Attr.schemaTypeInfo of the specified Attr node. Use the value false for the
			-- parameter isId to undeclare an attribute for being a user-determined ID
			-- attribute.
		external "C" alias "setIdAttributeNS($a_namespace_uri, $a_local_name, $a_is_id)" end

feature -- Introduced in DOM Level 3:

	set_id_attribute_node (a_id_attr: JS_ATTR; a_is_id: BOOLEAN)
			-- If the parameter isId is true, this method declares the specified attribute
			-- to be a user-determined ID attribute. This affects the value of Attr.isId
			-- and the behavior of Document.getElementById, but does not change any schema
			-- that may be in use, in particular this does not affect the
			-- Attr.schemaTypeInfo of the specified Attr node. Use the value false for the
			-- parameter isId to undeclare an attribute for being a user-determined ID
			-- attribute.
		external "C" alias "setIdAttributeNode($a_id_attr, $a_is_id)" end
end
