-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLMeterElement"
class
	JS_HTML_METER_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('meter')" end

feature -- Basic Operation

	value: REAL assign set_value
		external "C" alias "value" end

	set_value (a_value: REAL)
		external "C" alias "value=$a_value" end

	min: REAL assign set_min
		external "C" alias "min" end

	set_min (a_min: REAL)
		external "C" alias "min=$a_min" end

	max: REAL assign set_max
		external "C" alias "max" end

	set_max (a_max: REAL)
		external "C" alias "max=$a_max" end

	low: REAL assign set_low
		external "C" alias "low" end

	set_low (a_low: REAL)
		external "C" alias "low=$a_low" end

	high: REAL assign set_high
		external "C" alias "high" end

	set_high (a_high: REAL)
		external "C" alias "high=$a_high" end

	optimum: REAL assign set_optimum
		external "C" alias "optimum" end

	set_optimum (a_optimum: REAL)
		external "C" alias "optimum=$a_optimum" end

	form: JS_HTML_FORM_ELEMENT
		external "C" alias "form" end

	labels: JS_NODE_LIST
		external "C" alias "labels" end
end
