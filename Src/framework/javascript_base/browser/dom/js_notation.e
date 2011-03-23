-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:Notation"
class
	JS_NOTATION

inherit
	JS_NODE

feature -- Basic Operation

	public_id: STRING
			-- The public identifier of this notation. If the public identifier was not
			-- specified, this is null.
		external "C" alias "publicId" end

	system_id: STRING
			-- The system identifier of this notation. If the system identifier was not
			-- specified, this is null. This may be an absolute URI or not.
		external "C" alias "systemId" end
end
