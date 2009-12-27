note
	description: "Summary description for {AFX_RANDOM_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_RANDOM_VALUE

inherit
	AFX_EXPRESSION_VALUE
		redefine
			is_random
		end

feature -- Status report

	is_random: BOOLEAN
			-- Does current represent a random value?
		do
			Result := True
		end

feature{NONE} -- Implementation

	random: RANDOM
			-- Random number generator
		once
			create Result.set_seed ((create {TIME}.make_now).milli_second)
		end

feature -- Status report

	is_within_probability (a_random: RANDOM; a_probability: DOUBLE): BOOLEAN is
			-- Is the next random fall into the probality of [0, a_probality]?
		require
			a_probability_in_range: a_probability >= 0.0 and a_probability <= 1.0
		do
			a_random.forth
			Result := ((a_random.item_for_iteration \\ 100).to_double / 100.0) <= a_probability
		end

end
