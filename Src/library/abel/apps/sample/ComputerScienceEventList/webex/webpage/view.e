indexing
	description: "Objects that presents typical Views as the responses to Web Client, as example, html template based view, csv file view, pdf view...should be inherited from this class"
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "$Date$"
	revision: "$0.6$"

class
	VIEW
inherit
	HTML_PAGE
--export
--	{VIEW} replace_marker
--end

create
make

feature -- set content

	set_content(a_content: STRING) is
			-- replace  content of the current HTML page with 'a_content' string
		do
			make image.make_from_string (a_content)
		end

invariant
	invariant_clause: True -- Your invariant here

end
