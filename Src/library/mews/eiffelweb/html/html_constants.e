indexing

	description:
		"Tags of subset of the HTML language. This class may be used as %
		%ancestor by classes needing its facilities"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	HTML_CONSTANTS

feature -- Constants

	Bold_start: STRING is "<b>"
			-- Bold face start tag.

	Bold_end: STRING is "</b>"
			-- Bold face end tag.

	Glossary_start: STRING is "<dl>"
			-- Glossary list start tag.

	Glossary_end: STRING is "</dl>"
			-- Glossary list end tag.

	Glossary_term: STRING is "<dt>"
			-- Glossary list term.

	Glossary_definition: STRING is "<dd>"
			-- Glossary list definition.

	H1_start: STRING is "<h1>"
			-- Header level 1 start tag.

	H1_end: STRING is "</h1>"
			-- Header level 1 end tag.

	H2_start: STRING is "<h2>"
			-- Header level 2 start tag.

	H2_end: STRING is "</h2>"
			-- Header level 2 end tag.

	H3_start: STRING is "<h3>"
			-- Header level 3 start tag.

	H3_end: STRING is "</h3>"
			-- Header level 3 end tag.

	H4_start: STRING is "<h4>"
			-- Header level 4 start tag.

	H4_end: STRING is "</h4>"
			-- Header level 4 end tag.

	H5_start: STRING is "<h5>"
			-- Header level 5 start tag.

	H5_end: STRING is "</Hh5>"
			-- Header level 5 end tag.

	H6_start: STRING is "<h6>"
			-- Header level 6 start tag.

	H6_end: STRING is "</h6>"
			-- Header level 6 end tag.

	Horizontal_rule: STRING is "<hr />"
			-- Horizontal rule tag.

	Italic_start: STRING is "<I>"
			-- Italic start tag.

	Italic_end: STRING is "</I>"
			-- Italic end tag.

	Line_break: STRING is "<br />"
			-- Line break tag.

	List_item_start: STRING is "<li>"
			-- List item start tag.

	List_item_end: STRING is "</li>"
			-- List item end tag.

	Ordered_list_start: STRING is "<ol>"
			-- Ordered list start tag.

	Ordered_list_end: STRING is "</ol>"
			-- Ordered list end tag.

	Paragraph_start: STRING is "<p>"
			-- Paragraph start tag.

	Paragraph_end: STRING is "</p>"
			-- Paragraph end tag.

	Preformatted_start: STRING is "<pre>"
			-- Preformatted text start tag.

	Preformatted_end: STRING is "</pre>"
			-- Preformatted text end tag.

	Unordered_list_start: STRING is "<ul>"
			-- Unordered list start tag.

	Unordered_list_end: STRING is "</ul>";
			-- Unordered list end tag.

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class HTML_CONSTANTS

