-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:DocumentType"
class
	JS_DOCUMENT_TYPE

inherit
	JS_NODE

feature -- Basic Operation

	name: STRING
			-- The name of DTD; i.e., the name immediately following the DOCTYPE keyword.
		external "C" alias "name" end

	entities: JS_NAMED_NODE_MAP
			-- A NamedNodeMap containing the general entities, both external and internal,
			-- declared in the DTD. Parameter entities are not contained. Duplicates are
			-- discarded.
		external "C" alias "entities" end

	notations: JS_NAMED_NODE_MAP
			-- A NamedNodeMap containing the notations declared in the DTD. Duplicates are
			-- discarded. Every node in this map also implements the Notation interface.
			-- The DOM Level 2 does not support editing notations, therefore notations
			-- cannot be altered in any way.
		external "C" alias "notations" end

feature -- Introduced in DOM Level 2:

	public_id: STRING
			-- The public identifier of the external subset.
		external "C" alias "publicId" end

feature -- Introduced in DOM Level 2:

	system_id: STRING
			-- The system identifier of the external subset. This may be an absolute URI or
			-- not.
		external "C" alias "systemId" end

feature -- Introduced in DOM Level 2:

	internal_subset: STRING
			-- The internal subset as a string, or null if there is none. This is does not
			-- contain the delimiting square brackets.
		external "C" alias "internalSubset" end
end
