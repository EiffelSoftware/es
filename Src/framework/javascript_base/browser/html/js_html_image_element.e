-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLImageElement"
class
	JS_HTML_IMAGE_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('img')" end

feature -- Basic Operation

	alt: STRING assign set_alt
		external "C" alias "alt" end

	set_alt (a_alt: STRING)
		external "C" alias "alt=$a_alt" end

	src: STRING assign set_src
		external "C" alias "src" end

	set_src (a_src: STRING)
		external "C" alias "src=$a_src" end

	use_map: STRING assign set_use_map
		external "C" alias "useMap" end

	set_use_map (a_use_map: STRING)
		external "C" alias "useMap=$a_use_map" end

	is_map: BOOLEAN assign set_is_map
		external "C" alias "isMap" end

	set_is_map (a_is_map: BOOLEAN)
		external "C" alias "isMap=$a_is_map" end

	width: INTEGER assign set_width
		external "C" alias "width" end

	set_width (a_width: INTEGER)
		external "C" alias "width=$a_width" end

	height: INTEGER assign set_height
		external "C" alias "height" end

	set_height (a_height: INTEGER)
		external "C" alias "height=$a_height" end

	natural_width: INTEGER
		external "C" alias "naturalWidth" end

	natural_height: INTEGER
		external "C" alias "naturalHeight" end

	complete: BOOLEAN
		external "C" alias "complete" end
end
