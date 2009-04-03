indexing
	description: "Summary description for {TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST

feature

	test
		local
			a1, a2: A
			b: B
			c: C
			p: PROCESSOR
		do
			create {B}a1.make (10)
			create p.make

			a1.process (p)
			a1.process (p)

			check
				p.sum = 20
			end


			--check sound: false end
		end

end
