indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VIEW_HTML

inherit
	VIEW
		redefine
			make,
			out
		end
	INLINE_ELEMENT

create
	make

feature -- Access
	make is
			--
		do
			Precursor
			-- set defaults
			link := ""
			set_charset_iso_8859_1
			set_doctype_xhtml_10_strict
		end

	out: STRING is
			-- Usable copy of the output.
		do
			Result := "some output"
		end

	put_link_css(s:STRING) is
			-- add a link to an external css file
		do
			link := link + "%N	<link rel=%"stylesheet%" type=%"text/css%" media=%"all%" href=%"" + s + "%" />"
		end

	set_doctype_xhtml_10_strict is
			--
		do
			doctype := "<!DOCTYPE html PUBLIC %"-//W3C//DTD XHTML 1.0 Strict//EN%"" +
        		"%N	%"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd%">"
		end

	set_charset(c:STRING) is
			--
		do
			charset := "%N	<meta http-equiv=%"content-type%" content=%"text/html; charset=" + c + "%" />"
		end

	set_charset_iso_8859_1 is
			--
		do
			set_charset("iso-8859-1")
		end

	set_charset_utf_8 is
			--
		do
			set_charset("utf-8")
		end

feature {NONE} -- Implementation
	link : STRING
	charset : STRING
	doctype : STRING


invariant
	invariant_clause: True -- Your invariant here

end
