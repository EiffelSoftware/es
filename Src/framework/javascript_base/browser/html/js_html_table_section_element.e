-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLTableSectionElement"
class
	JS_HTML_TABLE_SECTION_ELEMENT

inherit
	JS_HTML_ELEMENT

feature -- Basic Operation

	rows: JS_HTML_COLLECTION
		external "C" alias "rows" end

	insert_row (a_index: INTEGER): JS_HTML_ELEMENT
		external "C" alias "insertRow($a_index)" end

	delete_row (a_index: INTEGER)
		external "C" alias "deleteRow($a_index)" end
end
