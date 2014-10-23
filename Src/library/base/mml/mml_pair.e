note
	description: "Pairs."
	author: "Nadia Polikarpova"
	theory: "pair.bpl"
	maps_to: "Pair"
	type_properties: "Pair#LeftType", "Pair#RightType"

class MML_PAIR [G, H]

inherit
	ANY
		redefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (x: G; y: H)
			-- Create a pair (`x', `y').
		do
		end

feature -- Access

	left: G
			-- Left component.
		do
		end

	right: H
			-- Right component.
		do
		end
		
feature -- Comparison

	is_equal (a_other: like Current): BOOLEAN
			-- Is `a_other' the same pair as `Current'?
		note
			maps_to: "Pair#Equal"
		do
		end		

end
