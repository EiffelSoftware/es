-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLQuoteElement"
class
	JS_HTML_QUOTE_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('blockquote')" end

feature -- Basic Operation

	cite: STRING assign set_cite
		external "C" alias "cite" end

	set_cite (a_cite: STRING)
		external "C" alias "cite=$a_cite" end
end
