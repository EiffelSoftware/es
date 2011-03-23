-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLCommandElement"
class
	JS_HTML_COMMAND_ELEMENT

inherit
	JS_HTML_ELEMENT
	redefine label, checked, icon, disabled end

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('command')" end

feature -- Basic Operation

	type: STRING assign set_type
		external "C" alias "type" end

	set_type (a_type: STRING)
		external "C" alias "type=$a_type" end

	label: STRING assign set_label
		external "C" alias "label" end

	set_label (a_label: STRING)
		external "C" alias "label=$a_label" end

	icon: STRING assign set_icon
		external "C" alias "icon" end

	set_icon (a_icon: STRING)
		external "C" alias "icon=$a_icon" end

	disabled: BOOLEAN assign set_disabled
		external "C" alias "disabled" end

	set_disabled (a_disabled: BOOLEAN)
		external "C" alias "disabled=$a_disabled" end

	checked: BOOLEAN assign set_checked
		external "C" alias "checked" end

	set_checked (a_checked: BOOLEAN)
		external "C" alias "checked=$a_checked" end

	radiogroup: STRING assign set_radiogroup
		external "C" alias "radiogroup" end

	set_radiogroup (a_radiogroup: STRING)
		external "C" alias "radiogroup=$a_radiogroup" end
end
