-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLTextAreaElement"
class
	JS_HTML_TEXT_AREA_ELEMENT

inherit
	JS_HTML_ELEMENT
	redefine disabled end

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('textarea')" end

feature -- Basic Operation

	autofocus: BOOLEAN assign set_autofocus
		external "C" alias "autofocus" end

	set_autofocus (a_autofocus: BOOLEAN)
		external "C" alias "autofocus=$a_autofocus" end

	cols: INTEGER assign set_cols
		external "C" alias "cols" end

	set_cols (a_cols: INTEGER)
		external "C" alias "cols=$a_cols" end

	disabled: BOOLEAN assign set_disabled
		external "C" alias "disabled" end

	set_disabled (a_disabled: BOOLEAN)
		external "C" alias "disabled=$a_disabled" end

	form: JS_HTML_FORM_ELEMENT
		external "C" alias "form" end

	max_length: INTEGER assign set_max_length
		external "C" alias "maxLength" end

	set_max_length (a_max_length: INTEGER)
		external "C" alias "maxLength=$a_max_length" end

	name: STRING assign set_name
		external "C" alias "name" end

	set_name (a_name: STRING)
		external "C" alias "name=$a_name" end

	placeholder: STRING assign set_placeholder
		external "C" alias "placeholder" end

	set_placeholder (a_placeholder: STRING)
		external "C" alias "placeholder=$a_placeholder" end

	read_only: BOOLEAN assign set_read_only
		external "C" alias "readOnly" end

	set_read_only (a_read_only: BOOLEAN)
		external "C" alias "readOnly=$a_read_only" end

	required: BOOLEAN assign set_required
		external "C" alias "required" end

	set_required (a_required: BOOLEAN)
		external "C" alias "required=$a_required" end

	rows: INTEGER assign set_rows
		external "C" alias "rows" end

	set_rows (a_rows: INTEGER)
		external "C" alias "rows=$a_rows" end

	wrap: STRING assign set_wrap
		external "C" alias "wrap" end

	set_wrap (a_wrap: STRING)
		external "C" alias "wrap=$a_wrap" end

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

	text_length: INTEGER
		external "C" alias "textLength" end

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

	js_select
		external "C" alias "select()" end

	selection_start: INTEGER assign set_selection_start
		external "C" alias "selectionStart" end

	set_selection_start (a_selection_start: INTEGER)
		external "C" alias "selectionStart=$a_selection_start" end

	selection_end: INTEGER assign set_selection_end
		external "C" alias "selectionEnd" end

	set_selection_end (a_selection_end: INTEGER)
		external "C" alias "selectionEnd=$a_selection_end" end

	set_selection_range (a_start: INTEGER; a_js_end: INTEGER)
		external "C" alias "setSelectionRange($a_start, $a_js_end)" end
end
