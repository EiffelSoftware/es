-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLFormElement"
class
	JS_HTML_FORM_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('form')" end

feature -- Basic Operation

	accept_charset: STRING assign set_accept_charset
		external "C" alias "acceptCharset" end

	set_accept_charset (a_accept_charset: STRING)
		external "C" alias "acceptCharset=$a_accept_charset" end

	action: STRING assign set_action
		external "C" alias "action" end

	set_action (a_action: STRING)
		external "C" alias "action=$a_action" end

	autocomplete: STRING assign set_autocomplete
		external "C" alias "autocomplete" end

	set_autocomplete (a_autocomplete: STRING)
		external "C" alias "autocomplete=$a_autocomplete" end

	enctype: STRING assign set_enctype
		external "C" alias "enctype" end

	set_enctype (a_enctype: STRING)
		external "C" alias "enctype=$a_enctype" end

	encoding: STRING assign set_encoding
		external "C" alias "encoding" end

	set_encoding (a_encoding: STRING)
		external "C" alias "encoding=$a_encoding" end

	method: STRING assign set_method
		external "C" alias "method" end

	set_method (a_method: STRING)
		external "C" alias "method=$a_method" end

	name: STRING assign set_name
		external "C" alias "name" end

	set_name (a_name: STRING)
		external "C" alias "name=$a_name" end

	no_validate: BOOLEAN assign set_no_validate
		external "C" alias "noValidate" end

	set_no_validate (a_no_validate: BOOLEAN)
		external "C" alias "noValidate=$a_no_validate" end

	target: STRING assign set_target
		external "C" alias "target" end

	set_target (a_target: STRING)
		external "C" alias "target=$a_target" end

	elements: JS_HTML_FORM_CONTROLS_COLLECTION
		external "C" alias "elements" end

	length: INTEGER
		external "C" alias "length" end

	item alias "[]" (a_index: INTEGER): ANY
		external "C" alias "item($a_index)" end

	named_item (a_name: STRING): ANY
		external "C" alias "namedItem($a_name)" end

	submit
		external "C" alias "submit()" end

	reset
		external "C" alias "reset()" end

	check_validity: BOOLEAN
		external "C" alias "checkValidity()" end

	dispatch_form_input
		external "C" alias "dispatchFormInput()" end

	dispatch_form_change
		external "C" alias "dispatchFormChange()" end
end
