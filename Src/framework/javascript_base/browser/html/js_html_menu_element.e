-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLMenuElement"
class
	JS_HTML_MENU_ELEMENT

inherit
	JS_HTML_ELEMENT
	redefine label end

feature -- Basic Operation

	type: STRING assign set_type
			-- The type attribute is an enumerated attribute indicating the kind of menu
			-- being declared. The attribute has three states. The context keyword maps to
			-- the context menu state, in which the element is declaring a context menu.
			-- The toolbar keyword maps to the toolbar state, in which the element is
			-- declaring a toolbar. The attribute may also be omitted. The missing value
			-- default is the list state, which indicates that the element is merely a list
			-- of commands that is neither declaring a context menu nor defining a toolbar.
		external "C" alias "type" end

	set_type (a_type: STRING)
			-- See type
		external "C" alias "type=$a_type" end

	label: STRING assign set_label
			-- The label attribute gives the label of the menu. It is used by user agents
			-- to display nested menus in the UI. For example, a context menu containing
			-- another menu would use the nested menu's label attribute for the submenu's
			-- menu label.
		external "C" alias "label" end

	set_label (a_label: STRING)
			-- See label
		external "C" alias "label=$a_label" end
end
