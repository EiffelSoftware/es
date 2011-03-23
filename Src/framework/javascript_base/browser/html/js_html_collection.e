-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLCollection"
class
	JS_HTML_COLLECTION

feature -- Basic Operation

	length: INTEGER
			-- Returns the number of elements in the collection.
		external "C" alias "length" end

	item alias "[]" (a_index: INTEGER): JS_ELEMENT
			-- Returns the item with index index from the collection. The items are sorted
			-- in tree order. Returns null if index is out of range.
		external "C" alias "item($a_index)" end

feature -- only returns Element

	named_item (a_name: STRING): ANY
			-- Returns the first item with ID or name name from the collection. Returns
			-- null if no element with that ID or name could be found.
		external "C" alias "namedItem($a_name)" end
end
