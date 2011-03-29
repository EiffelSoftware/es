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
			-- The length attribute must return the total number of ClientRect objects
			-- associated with the object.
		external "C" alias "length" end

	item alias "[]" (a_index: INTEGER): JS_CLIENT_RECT
			-- The item(index) method, when invoked, must raise an INDEX_SIZE_ERR exception
			-- when index is negative or greater than the number of ClientRect objects
			-- associated with the object. Otherwise, the ClientRect object at index must
			-- be returned.
		external "C" alias "item($a_index)" end
end
