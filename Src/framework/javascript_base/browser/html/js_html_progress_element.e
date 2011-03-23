-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLProgressElement"
class
	JS_HTML_PROGRESS_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('progress')" end

feature -- Basic Operation

	value: REAL assign set_value
		external "C" alias "value" end

	set_value (a_value: REAL)
		external "C" alias "value=$a_value" end

	max: REAL assign set_max
		external "C" alias "max" end

	set_max (a_max: REAL)
		external "C" alias "max=$a_max" end

	position: REAL
		external "C" alias "position" end

	form: JS_HTML_FORM_ELEMENT
		external "C" alias "form" end

	labels: JS_NODE_LIST
		external "C" alias "labels" end
end
