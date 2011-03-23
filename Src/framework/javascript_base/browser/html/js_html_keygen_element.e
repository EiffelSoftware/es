-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLKeygenElement"
class
	JS_HTML_KEYGEN_ELEMENT

inherit
	JS_HTML_ELEMENT
	redefine disabled end

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('keygen')" end

feature -- Basic Operation

	autofocus: BOOLEAN assign set_autofocus
		external "C" alias "autofocus" end

	set_autofocus (a_autofocus: BOOLEAN)
		external "C" alias "autofocus=$a_autofocus" end

	challenge: STRING assign set_challenge
		external "C" alias "challenge" end

	set_challenge (a_challenge: STRING)
		external "C" alias "challenge=$a_challenge" end

	disabled: BOOLEAN assign set_disabled
		external "C" alias "disabled" end

	set_disabled (a_disabled: BOOLEAN)
		external "C" alias "disabled=$a_disabled" end

	form: JS_HTML_FORM_ELEMENT
		external "C" alias "form" end

	keytype: STRING assign set_keytype
		external "C" alias "keytype" end

	set_keytype (a_keytype: STRING)
		external "C" alias "keytype=$a_keytype" end

	name: STRING assign set_name
		external "C" alias "name" end

	set_name (a_name: STRING)
		external "C" alias "name=$a_name" end

	type: STRING
		external "C" alias "type" end

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
