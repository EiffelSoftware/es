-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLSourceElement"
class
	JS_HTML_SOURCE_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('source')" end

feature -- Basic Operation

	src: STRING assign set_src
		external "C" alias "src" end

	set_src (a_src: STRING)
		external "C" alias "src=$a_src" end

	type: STRING assign set_type
		external "C" alias "type" end

	set_type (a_type: STRING)
		external "C" alias "type=$a_type" end

	media: STRING assign set_media
		external "C" alias "media" end

	set_media (a_media: STRING)
		external "C" alias "media=$a_media" end
end
