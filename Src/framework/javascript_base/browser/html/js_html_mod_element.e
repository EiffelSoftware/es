-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLModElement"
class
	JS_HTML_MOD_ELEMENT

inherit
	JS_HTML_ELEMENT

feature -- Basic Operation

	cite: STRING assign set_cite
		external "C" alias "cite" end

	set_cite (a_cite: STRING)
		external "C" alias "cite=$a_cite" end

	date_time: STRING assign set_date_time
		external "C" alias "dateTime" end

	set_date_time (a_date_time: STRING)
		external "C" alias "dateTime=$a_date_time" end
end
