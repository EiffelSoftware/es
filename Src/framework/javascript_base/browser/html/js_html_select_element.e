-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLSelectElement"
class
	JS_HTML_SELECT_ELEMENT

inherit
	JS_HTML_ELEMENT
	redefine disabled end

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('select')" end

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

	multiple: BOOLEAN assign set_multiple
		external "C" alias "multiple" end

	set_multiple (a_multiple: BOOLEAN)
		external "C" alias "multiple=$a_multiple" end

	name: STRING assign set_name
		external "C" alias "name" end

	set_name (a_name: STRING)
		external "C" alias "name=$a_name" end

	required: BOOLEAN assign set_required
		external "C" alias "required" end

	set_required (a_required: BOOLEAN)
		external "C" alias "required=$a_required" end

	size: INTEGER assign set_size
		external "C" alias "size" end

	set_size (a_size: INTEGER)
		external "C" alias "size=$a_size" end

	type: STRING
		external "C" alias "type" end

	options: JS_HTML_OPTIONS_COLLECTION
		external "C" alias "options" end

	length: INTEGER assign set_length
		external "C" alias "length" end

	set_length (a_length: INTEGER)
		external "C" alias "length=$a_length" end

	item alias "[]" (a_index: INTEGER): ANY
		external "C" alias "item($a_index)" end

	named_item (a_name: STRING): ANY
		external "C" alias "namedItem($a_name)" end

	add (a_element: JS_HTML_ELEMENT; a_before: JS_HTML_ELEMENT)
		external "C" alias "add($a_element, $a_before)" end

	add2 (a_element: JS_HTML_ELEMENT; a_before: INTEGER)
		external "C" alias "add($a_element, $a_before)" end

	remove (a_index: INTEGER)
		external "C" alias "remove($a_index)" end

	selected_options: JS_HTML_COLLECTION
		external "C" alias "selectedOptions" end

	selected_index: INTEGER assign set_selected_index
		external "C" alias "selectedIndex" end

	set_selected_index (a_selected_index: INTEGER)
		external "C" alias "selectedIndex=$a_selected_index" end

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
