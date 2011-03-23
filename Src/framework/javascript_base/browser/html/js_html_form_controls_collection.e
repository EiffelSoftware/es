-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLFormControlsCollection"
class
	JS_HTML_FORM_CONTROLS_COLLECTION

inherit
	JS_HTML_COLLECTION
	redefine named_item end

feature -- inherits length and item()

feature -- overrides inherited namedItem()

	named_item (a_name: STRING): ANY
		external "C" alias "namedItem($a_name)" end
end
