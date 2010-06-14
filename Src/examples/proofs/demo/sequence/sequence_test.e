indexing
	description: "Summary description for {SEQUENCE_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEQUENCE_TEST

create
	make

feature

	make (monotone: !MONOTONE_SEQUENCE; strict: !STRICT_SEQUENCE)
		local
			s: INTEGER_SEQUENCE
			i: INTEGER
		do
			s := monotone
			i := s.value
			s.forth
			check
				s.value >= i
			end

			s := strict
			i := s.value
			s.forth
			check
				s.value > i
			end
		ensure
			monotone.value = monotone.value
			strict.value = strict.value
		end

end
