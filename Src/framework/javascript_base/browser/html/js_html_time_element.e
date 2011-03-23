-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLTimeElement"
class
	JS_HTML_TIME_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('time')" end

feature -- Basic Operation

	date_time: STRING assign set_date_time
		external "C" alias "dateTime" end

	set_date_time (a_date_time: STRING)
		external "C" alias "dateTime=$a_date_time" end

	pub_date: BOOLEAN assign set_pub_date
		external "C" alias "pubDate" end

	set_pub_date (a_pub_date: BOOLEAN)
		external "C" alias "pubDate=$a_pub_date" end

	value_as_date: JS_DATE
		external "C" alias "valueAsDate" end
end
