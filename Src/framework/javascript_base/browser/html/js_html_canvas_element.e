-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLCanvasElement"
class
	JS_HTML_CANVAS_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('canvas')" end

feature -- Basic Operation

	width: INTEGER assign set_width
		external "C" alias "width" end

	set_width (a_width: INTEGER)
		external "C" alias "width=$a_width" end

	height: INTEGER assign set_height
		external "C" alias "height" end

	set_height (a_height: INTEGER)
		external "C" alias "height=$a_height" end
end
