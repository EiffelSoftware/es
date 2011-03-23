-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLButtonElement"
class
	JS_HTML_BUTTON_ELEMENT

inherit
	JS_HTML_ELEMENT
	redefine disabled end

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('button')" end

feature -- Basic Operation

	autofocus: BOOLEAN assign set_autofocus
		external "C" alias "autofocus" end

	set_autofocus (a_autofocus: BOOLEAN)
		external "C" alias "autofocus=$a_autofocus" end

	disabled: BOOLEAN assign set_disabled
		external "C" alias "disabled" end

	set_disabled (a_disabled: BOOLEAN)
		external "C" alias "disabled=$a_disabled" end

	form: JS_HTML_FORM_ELEMENT
		external "C" alias "form" end

	form_action: STRING assign set_form_action
		external "C" alias "formAction" end

	set_form_action (a_form_action: STRING)
		external "C" alias "formAction=$a_form_action" end

	form_enctype: STRING assign set_form_enctype
		external "C" alias "formEnctype" end

	set_form_enctype (a_form_enctype: STRING)
		external "C" alias "formEnctype=$a_form_enctype" end

	form_method: STRING assign set_form_method
		external "C" alias "formMethod" end

	set_form_method (a_form_method: STRING)
		external "C" alias "formMethod=$a_form_method" end

	form_no_validate: STRING assign set_form_no_validate
		external "C" alias "formNoValidate" end

	set_form_no_validate (a_form_no_validate: STRING)
		external "C" alias "formNoValidate=$a_form_no_validate" end

	form_target: STRING assign set_form_target
		external "C" alias "formTarget" end

	set_form_target (a_form_target: STRING)
		external "C" alias "formTarget=$a_form_target" end

	name: STRING assign set_name
		external "C" alias "name" end

	set_name (a_name: STRING)
		external "C" alias "name=$a_name" end

	type: STRING assign set_type
		external "C" alias "type" end

	set_type (a_type: STRING)
		external "C" alias "type=$a_type" end

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
