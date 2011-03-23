-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLOutputElement"
class
	JS_HTML_OUTPUT_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('output')" end

feature -- Basic Operation

	html_for: JS_DOM_SETTABLE_TOKEN_LIST
		external "C" alias "htmlFor" end

	form: JS_HTML_FORM_ELEMENT
		external "C" alias "form" end

	name: STRING assign set_name
		external "C" alias "name" end

	set_name (a_name: STRING)
		external "C" alias "name=$a_name" end

	type: STRING
		external "C" alias "type" end

	default_value: STRING assign set_default_value
		external "C" alias "defaultValue" end

	set_default_value (a_default_value: STRING)
		external "C" alias "defaultValue=$a_default_value" end

	value: STRING assign set_value
		external "C" alias "value" end

	set_value (a_value: STRING)
		external "C" alias "value=$a_value" end

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

	labels: JS_NODE_LIST
		external "C" alias "labels" end
end
