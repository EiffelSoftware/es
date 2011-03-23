-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLLinkElement"
class
	JS_HTML_LINK_ELEMENT

inherit
	JS_HTML_ELEMENT
	redefine disabled end

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('link')" end

feature -- Basic Operation

	disabled: BOOLEAN assign set_disabled
		external "C" alias "disabled" end

	set_disabled (a_disabled: BOOLEAN)
		external "C" alias "disabled=$a_disabled" end

	href: STRING assign set_href
		external "C" alias "href" end

	set_href (a_href: STRING)
		external "C" alias "href=$a_href" end

	rel: STRING assign set_rel
		external "C" alias "rel" end

	set_rel (a_rel: STRING)
		external "C" alias "rel=$a_rel" end

	rel_list: JS_DOM_TOKEN_LIST
		external "C" alias "relList" end

	media: STRING assign set_media
		external "C" alias "media" end

	set_media (a_media: STRING)
		external "C" alias "media=$a_media" end

	hreflang: STRING assign set_hreflang
		external "C" alias "hreflang" end

	set_hreflang (a_hreflang: STRING)
		external "C" alias "hreflang=$a_hreflang" end

	type: STRING assign set_type
		external "C" alias "type" end

	set_type (a_type: STRING)
		external "C" alias "type=$a_type" end

	sizes: JS_DOM_SETTABLE_TOKEN_LIST
		external "C" alias "sizes" end
end
