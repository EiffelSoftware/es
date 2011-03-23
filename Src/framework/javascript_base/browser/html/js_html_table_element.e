-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLTableElement"
class
	JS_HTML_TABLE_ELEMENT

inherit
	JS_HTML_ELEMENT

create
	make

feature {NONE} -- Initialization

	make
		external "C" alias "#document.createElement('table')" end

feature -- Basic Operation

	caption: JS_HTML_TABLE_CAPTION_ELEMENT assign set_caption
		external "C" alias "caption" end

	set_caption (a_caption: JS_HTML_TABLE_CAPTION_ELEMENT)
		external "C" alias "caption=$a_caption" end

	create_caption: JS_HTML_ELEMENT
		external "C" alias "createCaption()" end

	delete_caption
		external "C" alias "deleteCaption()" end

	t_head: JS_HTML_TABLE_SECTION_ELEMENT assign set_t_head
		external "C" alias "tHead" end

	set_t_head (a_t_head: JS_HTML_TABLE_SECTION_ELEMENT)
		external "C" alias "tHead=$a_t_head" end

	create_t_head: JS_HTML_ELEMENT
		external "C" alias "createTHead()" end

	delete_t_head
		external "C" alias "deleteTHead()" end

	t_foot: JS_HTML_TABLE_SECTION_ELEMENT assign set_t_foot
		external "C" alias "tFoot" end

	set_t_foot (a_t_foot: JS_HTML_TABLE_SECTION_ELEMENT)
		external "C" alias "tFoot=$a_t_foot" end

	create_t_foot: JS_HTML_ELEMENT
		external "C" alias "createTFoot()" end

	delete_t_foot
		external "C" alias "deleteTFoot()" end

	t_bodies: JS_HTML_COLLECTION
		external "C" alias "tBodies" end

	create_t_body: JS_HTML_ELEMENT
		external "C" alias "createTBody()" end

	rows: JS_HTML_COLLECTION
		external "C" alias "rows" end

	insert_row (a_index: INTEGER): JS_HTML_ELEMENT
		external "C" alias "insertRow($a_index)" end

	delete_row (a_index: INTEGER)
		external "C" alias "deleteRow($a_index)" end

	summary: STRING assign set_summary
		external "C" alias "summary" end

	set_summary (a_summary: STRING)
		external "C" alias "summary=$a_summary" end
end
