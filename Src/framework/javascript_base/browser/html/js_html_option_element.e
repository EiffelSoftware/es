-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLOptionElement"
class
	JS_HTML_OPTION_ELEMENT

inherit
	JS_HTML_ELEMENT
	redefine label, disabled end

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('option')" end

feature -- Basic Operation

	disabled: BOOLEAN assign set_disabled
		external "C" alias "disabled" end

	set_disabled (a_disabled: BOOLEAN)
		external "C" alias "disabled=$a_disabled" end

	form: JS_HTML_FORM_ELEMENT
		external "C" alias "form" end

	label: STRING assign set_label
		external "C" alias "label" end

	set_label (a_label: STRING)
		external "C" alias "label=$a_label" end

	default_selected: BOOLEAN assign set_default_selected
		external "C" alias "defaultSelected" end

	set_default_selected (a_default_selected: BOOLEAN)
		external "C" alias "defaultSelected=$a_default_selected" end

	selected: BOOLEAN assign set_selected
		external "C" alias "selected" end

	set_selected (a_selected: BOOLEAN)
		external "C" alias "selected=$a_selected" end

	value: STRING assign set_value
		external "C" alias "value" end

	set_value (a_value: STRING)
		external "C" alias "value=$a_value" end

	text: STRING assign set_text
		external "C" alias "text" end

	set_text (a_text: STRING)
		external "C" alias "text=$a_text" end

	index: INTEGER
		external "C" alias "index" end
end
