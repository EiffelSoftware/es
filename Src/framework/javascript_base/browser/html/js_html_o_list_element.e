-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLOListElement"
class
	JS_HTML_O_LIST_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('ol')" end

feature -- Basic Operation

	reversed: BOOLEAN assign set_reversed
		external "C" alias "reversed" end

	set_reversed (a_reversed: BOOLEAN)
		external "C" alias "reversed=$a_reversed" end

	start: INTEGER assign set_start
		external "C" alias "start" end

	set_start (a_start: INTEGER)
		external "C" alias "start=$a_start" end

	type: STRING assign set_type
		external "C" alias "type" end

	set_type (a_type: STRING)
		external "C" alias "type=$a_type" end
end
