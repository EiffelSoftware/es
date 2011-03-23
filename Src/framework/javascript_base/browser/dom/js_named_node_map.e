-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:NamedNodeMap"
class
	JS_NAMED_NODE_MAP

feature -- Basic Operation

	get_named_item (a_name: STRING): JS_NODE
			-- Retrieves a node specified by name.
		external "C" alias "getNamedItem($a_name)" end

	set_named_item (a_arg: JS_NODE): JS_NODE
			-- Adds a node using its nodeName attribute. If a node with that name is
			-- already present in this map, it is replaced by the new one. Replacing a node
			-- by itself has no effect. As the nodeName attribute is used to derive the
			-- name which the node must be stored under, multiple nodes of certain types
			-- (those that have a "special" string value) cannot be stored as the names
			-- would clash. This is seen as preferable to allowing nodes to be aliased.
		external "C" alias "setNamedItem($a_arg)" end

	remove_named_item (a_name: STRING): JS_NODE
			-- Removes a node specified by name. When this map contains the attributes
			-- attached to an element, if the removed attribute is known to have a default
			-- value, an attribute immediately appears containing the default value as well
			-- as the corresponding namespace URI, local name, and prefix when applicable.
		external "C" alias "removeNamedItem($a_name)" end

	item (a_index: INTEGER): JS_NODE
			-- Returns the indexth item in the map. If index is greater than or equal to
			-- the number of nodes in this map, this returns null.
		external "C" alias "item($a_index)" end

	length: INTEGER
			-- The number of nodes in this map. The range of valid child node indices is 0
			-- to length-1 inclusive.
		external "C" alias "length" end

feature -- Introduced in DOM Level 2:

	get_named_item_ns (a_namespace_uri: STRING; a_local_name: STRING): JS_NODE
			-- Retrieves a node specified by local name and namespace URI.
		external "C" alias "getNamedItemNS($a_namespace_uri, $a_local_name)" end

feature -- Introduced in DOM Level 2:

	set_named_item_ns (a_arg: JS_NODE): JS_NODE
			-- Adds a node using its namespaceURI and localName. If a node with that
			-- namespace URI and that local name is already present in this map, it is
			-- replaced by the new one. Replacing a node by itself has no effect.
		external "C" alias "setNamedItemNS($a_arg)" end

feature -- Introduced in DOM Level 2:

	remove_named_item_ns (a_namespace_uri: STRING; a_local_name: STRING): JS_NODE
			-- Removes a node specified by local name and namespace URI. A removed
			-- attribute may be known to have a default value when this map contains the
			-- attributes attached to an element, as returned by the attributes attribute
			-- of the Node interface. If so, an attribute immediately appears containing
			-- the default value as well as the corresponding namespace URI, local name,
			-- and prefix when applicable.
		external "C" alias "removeNamedItemNS($a_namespace_uri, $a_local_name)" end
end
