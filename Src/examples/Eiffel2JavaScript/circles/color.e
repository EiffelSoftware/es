note
	description: "Summary description for {COLOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COLOR

create
	make

feature {NONE} -- Initialization

	make (a_html: attached STRING_32; a_r,a_g,a_b:INTEGER)
		do
			html := a_html
			r := a_r
			g := a_g
			b := a_b
		end

feature -- Access

	html: attached STRING_32
	r,g,b: INTEGER

end
