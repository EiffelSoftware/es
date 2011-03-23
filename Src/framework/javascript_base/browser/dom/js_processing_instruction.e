-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:ProcessingInstruction"
class
	JS_PROCESSING_INSTRUCTION

inherit
	JS_NODE

feature -- Basic Operation

	target: STRING
			-- The target of this processing instruction. XML defines this as being the
			-- first token following the markup that begins the processing instruction.
		external "C" alias "target" end

	data: STRING assign set_data
			-- The content of this processing instruction. This is from the first non white
			-- space character after the target to the character immediately preceding the
			-- ?>.
		external "C" alias "data" end

	set_data (a_data: STRING)
			-- See data
		external "C" alias "data=$a_data" end
end
