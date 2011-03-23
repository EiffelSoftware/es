-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLIFrameElement"
class
	JS_HTML_IFRAME_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('iframe')" end

feature -- Basic Operation

	src: STRING assign set_src
		external "C" alias "src" end

	set_src (a_src: STRING)
		external "C" alias "src=$a_src" end

	srcdoc: STRING assign set_srcdoc
		external "C" alias "srcdoc" end

	set_srcdoc (a_srcdoc: STRING)
		external "C" alias "srcdoc=$a_srcdoc" end

	name: STRING assign set_name
		external "C" alias "name" end

	set_name (a_name: STRING)
		external "C" alias "name=$a_name" end

	sandbox: JS_DOM_SETTABLE_TOKEN_LIST
		external "C" alias "sandbox" end

	seamless: BOOLEAN assign set_seamless
		external "C" alias "seamless" end

	set_seamless (a_seamless: BOOLEAN)
		external "C" alias "seamless=$a_seamless" end

	width: STRING assign set_width
		external "C" alias "width" end

	set_width (a_width: STRING)
		external "C" alias "width=$a_width" end

	height: STRING assign set_height
		external "C" alias "height" end

	set_height (a_height: STRING)
		external "C" alias "height=$a_height" end

	content_document: JS_DOCUMENT
		external "C" alias "contentDocument" end

	content_window: JS_WINDOW
		external "C" alias "contentWindow" end
end
