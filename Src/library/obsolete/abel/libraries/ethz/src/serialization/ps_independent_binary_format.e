note
	description: "Objects that represent specific, platform independent binary formats"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_INDEPENDENT_BINARY_FORMAT

inherit
	PS_FORMAT redefine default_create end

feature {NONE} -- Initialization

	default_create
		do
			precursor
			create representation.make_empty (0)
		end

feature -- Access

	optimized_for_retrieval: BOOLEAN

	representation: SPECIAL [INTEGER_8]
			-- Last object representation computed.

feature -- Status setting

	set_optimized_for_retrieval (is_optimized_for_retrieval: BOOLEAN)
		do
			optimized_for_retrieval := is_optimized_for_retrieval
		ensure
			optimized_for_retrieval_set: optimized_for_retrieval = is_optimized_for_retrieval
		end

feature -- Basic operations

	compute_representation (an_obj: ANY)
			-- Compute `an_obj' representation in independent binary format. Update `representation'.
		do
		end

end
