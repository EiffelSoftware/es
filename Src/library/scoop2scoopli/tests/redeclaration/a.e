note
	description: "Summary description for {B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	A

feature -- Access

	f (a: D): separate D is

	     do
	     	-- do nothing
	     end
	g(a: separate D; b:D ;c: separate D): separate D is
		do
			--do nothing
		end

	d_attr: separate D is
		do
		end

	x_attr: separate D



end
