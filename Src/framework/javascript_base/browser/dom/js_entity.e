-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:Entity"
class
	JS_ENTITY

inherit
	JS_NODE

feature -- Basic Operation

	public_id: STRING
			-- The public identifier associated with the entity if specified, and null
			-- otherwise.
		external "C" alias "publicId" end

	system_id: STRING
			-- The system identifier associated with the entity if specified, and null
			-- otherwise. This may be an absolute URI or not.
		external "C" alias "systemId" end

	notation_name: STRING
			-- For unparsed entities, the name of the notation for the entity. For parsed
			-- entities, this is null.
		external "C" alias "notationName" end

feature -- Introduced in DOM Level 3:

	input_encoding: STRING
			-- An attribute specifying the encoding used for this entity at the time of
			-- parsing, when it is an external parsed entity. This is null if it an entity
			-- from the internal subset or if it is not known.
		external "C" alias "inputEncoding" end

feature -- Introduced in DOM Level 3:

	xml_encoding: STRING
			-- An attribute specifying, as part of the text declaration, the encoding of
			-- this entity, when it is an external parsed entity. This is null otherwise.
		external "C" alias "xmlEncoding" end

feature -- Introduced in DOM Level 3:

	xml_version: STRING
			-- An attribute specifying, as part of the text declaration, the version number
			-- of this entity, when it is an external parsed entity. This is null
			-- otherwise.
		external "C" alias "xmlVersion" end
end
