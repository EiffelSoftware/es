-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLInputElement"
class
	JS_HTML_INPUT_ELEMENT

inherit
	JS_HTML_ELEMENT
	redefine checked, disabled end

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('input')" end

feature -- Basic Operation

	accept: STRING assign set_accept
		external "C" alias "accept" end

	set_accept (a_accept: STRING)
		external "C" alias "accept=$a_accept" end

	alt: STRING assign set_alt
		external "C" alias "alt" end

	set_alt (a_alt: STRING)
		external "C" alias "alt=$a_alt" end

	autocomplete: STRING assign set_autocomplete
		external "C" alias "autocomplete" end

	set_autocomplete (a_autocomplete: STRING)
		external "C" alias "autocomplete=$a_autocomplete" end

	autofocus: BOOLEAN assign set_autofocus
		external "C" alias "autofocus" end

	set_autofocus (a_autofocus: BOOLEAN)
		external "C" alias "autofocus=$a_autofocus" end

	default_checked: BOOLEAN assign set_default_checked
		external "C" alias "defaultChecked" end

	set_default_checked (a_default_checked: BOOLEAN)
		external "C" alias "defaultChecked=$a_default_checked" end

	checked: BOOLEAN assign set_checked
		external "C" alias "checked" end

	set_checked (a_checked: BOOLEAN)
		external "C" alias "checked=$a_checked" end

	disabled: BOOLEAN assign set_disabled
		external "C" alias "disabled" end

	set_disabled (a_disabled: BOOLEAN)
		external "C" alias "disabled=$a_disabled" end

	form: JS_HTML_FORM_ELEMENT
		external "C" alias "form" end

	files: ANY
		external "C" alias "files" end

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

	form_no_validate: BOOLEAN assign set_form_no_validate
		external "C" alias "formNoValidate" end

	set_form_no_validate (a_form_no_validate: BOOLEAN)
		external "C" alias "formNoValidate=$a_form_no_validate" end

	form_target: STRING assign set_form_target
		external "C" alias "formTarget" end

	set_form_target (a_form_target: STRING)
		external "C" alias "formTarget=$a_form_target" end

	height: STRING assign set_height
		external "C" alias "height" end

	set_height (a_height: STRING)
		external "C" alias "height=$a_height" end

	indeterminate: BOOLEAN assign set_indeterminate
		external "C" alias "indeterminate" end

	set_indeterminate (a_indeterminate: BOOLEAN)
		external "C" alias "indeterminate=$a_indeterminate" end

	list: JS_HTML_ELEMENT
		external "C" alias "list" end

	max: STRING assign set_max
		external "C" alias "max" end

	set_max (a_max: STRING)
		external "C" alias "max=$a_max" end

	max_length: INTEGER assign set_max_length
		external "C" alias "maxLength" end

	set_max_length (a_max_length: INTEGER)
		external "C" alias "maxLength=$a_max_length" end

	min: STRING assign set_min
		external "C" alias "min" end

	set_min (a_min: STRING)
		external "C" alias "min=$a_min" end

	multiple: BOOLEAN assign set_multiple
		external "C" alias "multiple" end

	set_multiple (a_multiple: BOOLEAN)
		external "C" alias "multiple=$a_multiple" end

	name: STRING assign set_name
		external "C" alias "name" end

	set_name (a_name: STRING)
		external "C" alias "name=$a_name" end

	pattern: STRING assign set_pattern
		external "C" alias "pattern" end

	set_pattern (a_pattern: STRING)
		external "C" alias "pattern=$a_pattern" end

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

	size: INTEGER assign set_size
		external "C" alias "size" end

	set_size (a_size: INTEGER)
		external "C" alias "size=$a_size" end

	src: STRING assign set_src
		external "C" alias "src" end

	set_src (a_src: STRING)
		external "C" alias "src=$a_src" end

	step: STRING assign set_step
		external "C" alias "step" end

	set_step (a_step: STRING)
		external "C" alias "step=$a_step" end

	type: STRING assign set_type
		external "C" alias "type" end

	set_type (a_type: STRING)
		external "C" alias "type=$a_type" end

	default_value: STRING assign set_default_value
		external "C" alias "defaultValue" end

	set_default_value (a_default_value: STRING)
		external "C" alias "defaultValue=$a_default_value" end

	value: STRING assign set_value
		external "C" alias "value" end

	set_value (a_value: STRING)
		external "C" alias "value=$a_value" end

	value_as_date: JS_DATE assign set_value_as_date
		external "C" alias "valueAsDate" end

	set_value_as_date (a_value_as_date: JS_DATE)
		external "C" alias "valueAsDate=$a_value_as_date" end

	value_as_number: REAL assign set_value_as_number
		external "C" alias "valueAsNumber" end

	set_value_as_number (a_value_as_number: REAL)
		external "C" alias "valueAsNumber=$a_value_as_number" end

	selected_option: JS_HTML_OPTION_ELEMENT
		external "C" alias "selectedOption" end

	width: STRING assign set_width
		external "C" alias "width" end

	set_width (a_width: STRING)
		external "C" alias "width=$a_width" end

	step_up (a_n: INTEGER)
		external "C" alias "stepUp($a_n)" end

	step_down (a_n: INTEGER)
		external "C" alias "stepDown($a_n)" end

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
