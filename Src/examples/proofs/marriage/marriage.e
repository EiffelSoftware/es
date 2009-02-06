indexing
	description: "Test class for marriage example."
	date: "$Date$"
	revision: "$Revision$"

class
	MARRIAGE

create
	make

feature {NONE} -- Initialization

	make
		local
			alice, bob, eve: PERSON
		do
			create alice.make
			create bob.make
			create eve.make

			check
				alice.spouse = Void
				bob.spouse = Void
				eve.spouse = Void
			end

			alice.marry (bob)

			check
				alice.spouse = bob
				bob.spouse = alice
				eve.spouse = Void
			end

			bob.divorce

			check
				false
				alice.spouse = Void
				bob.spouse = Void
				eve.spouse = Void
			end

			eve.marry (bob)

			check
				alice.spouse = Void
				bob.spouse = Void
				eve.spouse = Void
			end

		end

end
