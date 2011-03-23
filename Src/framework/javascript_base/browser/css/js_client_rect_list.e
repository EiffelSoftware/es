-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/cssom-view/. Copyright © 2009 W3C® (MIT, ERCIM, Keio),
		All Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:ClientRectList"
class
	JS_CLIENT_RECT_LIST

feature -- Basic Operation

	length: INTEGER
		external "C" alias "length" end

	item alias "[]" (a_index: INTEGER): JS_CLIENT_RECT
		external "C" alias "item($a_index)" end
end
