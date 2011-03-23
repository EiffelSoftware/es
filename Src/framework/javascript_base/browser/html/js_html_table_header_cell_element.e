-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLTableHeaderCellElement"
class
	JS_HTML_TABLE_HEADER_CELL_ELEMENT

inherit
	JS_HTML_TABLE_CELL_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('th')" end

feature -- Basic Operation

	scope: STRING assign set_scope
		external "C" alias "scope" end

	set_scope (a_scope: STRING)
		external "C" alias "scope=$a_scope" end
end
