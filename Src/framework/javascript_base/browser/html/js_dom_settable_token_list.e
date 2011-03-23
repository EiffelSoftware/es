-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:DOMSettableTokenList"
class
	JS_DOM_SETTABLE_TOKEN_LIST

inherit
	JS_DOM_TOKEN_LIST

feature -- Basic Operation

	value: STRING assign set_value
			-- Returns the underlying string. Can be set, to change the underlying string.
		external "C" alias "value" end

	set_value (a_value: STRING)
			-- See value
		external "C" alias "value=$a_value" end
end
