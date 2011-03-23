-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLObjectElement"
class
	JS_HTML_OBJECT_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('object')" end

feature -- Basic Operation

	data: STRING assign set_data
		external "C" alias "data" end

	set_data (a_data: STRING)
		external "C" alias "data=$a_data" end

	type: STRING assign set_type
		external "C" alias "type" end

	set_type (a_type: STRING)
		external "C" alias "type=$a_type" end

	name: STRING assign set_name
		external "C" alias "name" end

	set_name (a_name: STRING)
		external "C" alias "name=$a_name" end

	use_map: STRING assign set_use_map
		external "C" alias "useMap" end

	set_use_map (a_use_map: STRING)
		external "C" alias "useMap=$a_use_map" end

	form: JS_HTML_FORM_ELEMENT
		external "C" alias "form" end

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

	will_validate: BOOLEAN
		external "C" alias "willValidate" end

	validity: JS_VALIDITY_STATE
		external "C" alias "validity" end

	validation_message: STRING
		external "C" alias "validationMessage" end

	check_validity: BOOLEAN
		external "C" alias "checkValidity()" end

	set_custom_validity (a_error: STRING)
		external "C" alias "setCustomValidity($a_error)" end
end
