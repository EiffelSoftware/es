note
	description: "Summary description for {B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	B

inherit
	A
	rename
		foo as bla
	end


feature

	foo
		do
			b.foo
			a.foo
		end

	a2: A

	b: B

end
