-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/html5/. Copyright © 2010 W3C® (MIT, ERCIM, Keio), All
		Rights Reserved. W3C liability, trademark and document use rules apply.
	]"
	javascript: "NativeStub:HTMLOptionsCollection"
class
	JS_HTML_OPTIONS_COLLECTION

inherit
	JS_HTML_COLLECTION
	redefine length, named_item end

feature -- inherits item()

feature -- overrides inherited length

	length: INTEGER assign set_length
			-- Returns the number of elements in the collection. When set to a smaller
			-- number, truncates the number of option elements in the corresponding
			-- container. When set to a greater number, adds new blank option elements to
			-- that container.
		external "C" alias "length" end

	set_length (a_length: INTEGER)
			-- See length
		external "C" alias "length=$a_length" end

feature -- overrides inherited namedItem()

	named_item (a_name: STRING): ANY
			-- Returns the item with ID or name name from the collection. If there are
			-- multiple matching items, then a NodeList object containing all those
			-- elements is returned. Returns null if no element with that ID could be
			-- found.
		external "C" alias "namedItem($a_name)" end

	add (a_element: JS_HTML_ELEMENT; a_before: JS_HTML_ELEMENT)
			-- Inserts element before the node given by before. The before argument can be
			-- a number, in which case element is inserted before the item with that
			-- number, or an element from the collection, in which case element is inserted
			-- before that element. If before is omitted, null, or a number out of range,
			-- then element will be added at the end of the list. This method will throw a
			-- HIERARCHY_REQUEST_ERR exception if element is an ancestor of the element
			-- into which it is to be inserted. If element is not an option or optgroup
			-- element, then the method does nothing.
		external "C" alias "add($a_element, $a_before)" end

	add2 (a_element: JS_HTML_ELEMENT; a_before: INTEGER)
		external "C" alias "add($a_element, $a_before)" end

	remove (a_index: INTEGER)
		external "C" alias "remove($a_index)" end

	selected_index: INTEGER assign set_selected_index
			-- Returns the index of the first selected item, if any, or -1 if there is no
			-- selected item. Can be set, to change the selection.
		external "C" alias "selectedIndex" end

	set_selected_index (a_selected_index: INTEGER)
			-- See selected_index
		external "C" alias "selectedIndex=$a_selected_index" end
end
