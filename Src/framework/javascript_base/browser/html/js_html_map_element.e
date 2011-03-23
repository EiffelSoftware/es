-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLMapElement"
class
	JS_HTML_MAP_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('map')" end

feature -- Basic Operation

	name: STRING assign set_name
		external "C" alias "name" end

	set_name (a_name: STRING)
		external "C" alias "name=$a_name" end

	areas: JS_HTML_COLLECTION
		external "C" alias "areas" end

	images: JS_HTML_COLLECTION
		external "C" alias "images" end
end
