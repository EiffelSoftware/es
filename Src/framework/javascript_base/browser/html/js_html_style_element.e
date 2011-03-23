-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLStyleElement"
class
	JS_HTML_STYLE_ELEMENT

inherit
	JS_HTML_ELEMENT
	redefine disabled end

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('style')" end

feature -- Basic Operation

	disabled: BOOLEAN assign set_disabled
		external "C" alias "disabled" end

	set_disabled (a_disabled: BOOLEAN)
		external "C" alias "disabled=$a_disabled" end

	media: STRING assign set_media
		external "C" alias "media" end

	set_media (a_media: STRING)
		external "C" alias "media=$a_media" end

	type: STRING assign set_type
		external "C" alias "type" end

	set_type (a_type: STRING)
		external "C" alias "type=$a_type" end

	scoped: BOOLEAN assign set_scoped
		external "C" alias "scoped" end

	set_scoped (a_scoped: BOOLEAN)
		external "C" alias "scoped=$a_scoped" end
end
