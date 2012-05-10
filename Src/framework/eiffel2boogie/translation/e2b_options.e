note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_OPTIONS

feature -- Inlining

	is_inlining_enabled: BOOLEAN = True
			-- Is inlining enabled?

	inlining_depth: INTEGER
			-- Current inlining depth.

	max_recursive_inlining_depth: INTEGER = 13
			-- Maximum inlining depth for inlining recursive features.

	set_inlining_depth (a_value: INTEGER)
			-- Set `inlining_depth' to `a_value'.
		do
			inlining_depth := a_value
		end

	is_automatic_inlining_enabled: BOOLEAN = True
			-- Is automatic inlining of certain routines enabled?

	routines_to_inline: LINKED_LIST [INTEGER]
			-- Routines to inline.
		once
			create Result.make
		end

feature -- Loop unrolling

	loop_unrolling_depth: INTEGER = 13
			-- Loop unrolling depth.

	is_automatic_loop_unrolling_enabled: BOOLEAN = True
			-- Is automatic unrolling of certain loops enabled?

	is_sound_loop_unrolling_enabled: BOOLEAN = True
			-- Is loop unrolling being done in a sound way?

feature -- Precondition and postcondition predicates

	is_precondition_predicate_enabled: BOOLEAN = False
			-- Is generation of precondition predicates enabled?

	is_postcondition_predicate_enabled: BOOLEAN = True
			-- Is generation of postcondition predicates enabled?

feature -- Overflow checks

	is_checking_overflow: BOOLEAN = False
			-- Is checking of overflow enabled?

end
