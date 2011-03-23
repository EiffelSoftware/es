-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLBaseElement"
class
	JS_HTML_BASE_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('base')" end

feature -- Basic Operation

	href: STRING assign set_href
		external "C" alias "href" end

	set_href (a_href: STRING)
		external "C" alias "href=$a_href" end

	target: STRING assign set_target
		external "C" alias "target" end

	set_target (a_target: STRING)
		external "C" alias "target=$a_target" end
end
