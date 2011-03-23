-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLTableRowElement"
class
	JS_HTML_TABLE_ROW_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('tr')" end

feature -- Basic Operation

	row_index: INTEGER
		external "C" alias "rowIndex" end

	section_row_index: INTEGER
		external "C" alias "sectionRowIndex" end

	cells: JS_HTML_COLLECTION
		external "C" alias "cells" end

	insert_cell (a_index: INTEGER): JS_HTML_ELEMENT
		external "C" alias "insertCell($a_index)" end

	delete_cell (a_index: INTEGER)
		external "C" alias "deleteCell($a_index)" end
end
