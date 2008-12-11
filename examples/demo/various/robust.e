indexing
	description: "Summary description for {ROBUST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
--	verify: False

class
	ROBUST [G]

inherit

	LINKED_LIST [INTEGER]

feature

	abc: G

	def (a: G): G
		do

		ensure
			Result /= a
		end

	not_implemented
		local
			a: INTEGER
		do
			inspect a
			when 1 then

			else

			end
			if True then

			end
		end

end
