-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLEmbedElement"
class
	JS_HTML_EMBED_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('embed')" end

feature -- Basic Operation

	src: STRING assign set_src
		external "C" alias "src" end

	set_src (a_src: STRING)
		external "C" alias "src=$a_src" end

	type: STRING assign set_type
		external "C" alias "type" end

	set_type (a_type: STRING)
		external "C" alias "type=$a_type" end

	width: STRING assign set_width
		external "C" alias "width" end

	set_width (a_width: STRING)
		external "C" alias "width=$a_width" end

	height: STRING assign set_height
		external "C" alias "height" end

	set_height (a_height: STRING)
		external "C" alias "height=$a_height" end
end
