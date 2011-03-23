-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLTableCellElement"
class
	JS_HTML_TABLE_CELL_ELEMENT

inherit
	JS_HTML_ELEMENT

feature -- Basic Operation

	col_span: INTEGER assign set_col_span
		external "C" alias "colSpan" end

	set_col_span (a_col_span: INTEGER)
		external "C" alias "colSpan=$a_col_span" end

	row_span: INTEGER assign set_row_span
		external "C" alias "rowSpan" end

	set_row_span (a_row_span: INTEGER)
		external "C" alias "rowSpan=$a_row_span" end

	headers: JS_DOM_SETTABLE_TOKEN_LIST
		external "C" alias "headers" end

	cell_index: INTEGER
		external "C" alias "cellIndex" end
end
