-- This is a generated file, please do not edit directly
note
	copyright: "[
		This file has been generated from IDL Definitions available at
		http://www.w3.org/TR/DOM-Level-3-Core/Overview.html. Copyright ©2004 W3C®
		(MIT, ERCIM, Keio), All Rights Reserved. W3C liability, trademark, document
		use and software licensing rules apply.
	]"
	javascript: "NativeStub:Text"
class
	JS_TEXT

inherit
	JS_CHARACTER_DATA

feature -- Basic Operation

	split_text (a_offset: INTEGER): JS_TEXT
			-- Breaks this node into two nodes at the specified offset, keeping both in the
			-- tree as siblings. After being split, this node will contain all the content
			-- up to the offset point. A new node of the same type, which contains all the
			-- content at and after the offset point, is returned. If the original node had
			-- a parent node, the new node is inserted as the next sibling of the original
			-- node. When the offset is equal to the length of this node, the new node has
			-- no data.
		external "C" alias "splitText($a_offset)" end

feature -- Introduced in DOM Level 3:

	is_element_content_whitespace: BOOLEAN
			-- Returns whether this text node contains element content whitespace, often
			-- abusively called "ignorable whitespace". The text node is determined to
			-- contain whitespace in element content during the load of the document or if
			-- validation occurs while using Document.normalizeDocument().
		external "C" alias "isElementContentWhitespace" end

feature -- Introduced in DOM Level 3:

	whole_text: STRING
			-- Returns all text of Text nodes logically-adjacent text nodes to this node,
			-- concatenated in document order. For instance, in the example below wholeText
			-- on the Text node that contains "bar" returns "barfoo", while on the Text
			-- node that contains "foo" it returns "barfoo".
		external "C" alias "wholeText" end

feature -- Introduced in DOM Level 3:

	replace_whole_text (a_content: STRING): JS_TEXT
			-- Replaces the text of the current node and all logically-adjacent text nodes
			-- with the specified text. All logically-adjacent text nodes are removed
			-- including the current node unless it was the recipient of the replacement
			-- text. This method returns the node which received the replacement text.
		external "C" alias "replaceWholeText($a_content)" end
end
