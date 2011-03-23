-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLLIElement"
class
	JS_HTML_LI_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('li')" end

feature -- Basic Operation

	value: INTEGER assign set_value
		external "C" alias "value" end

	set_value (a_value: INTEGER)
		external "C" alias "value=$a_value" end
end
