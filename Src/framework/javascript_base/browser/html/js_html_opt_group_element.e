-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLOptGroupElement"
class
	JS_HTML_OPT_GROUP_ELEMENT

inherit
	JS_HTML_ELEMENT
	redefine label, disabled end

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('optgroup')" end

feature -- Basic Operation

	disabled: BOOLEAN assign set_disabled
		external "C" alias "disabled" end

	set_disabled (a_disabled: BOOLEAN)
		external "C" alias "disabled=$a_disabled" end

	label: STRING assign set_label
		external "C" alias "label" end

	set_label (a_label: STRING)
		external "C" alias "label=$a_label" end
end
