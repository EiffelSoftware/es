note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_OPTIONS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize default options.
		do
			is_two_step_verification_enabled := False
			is_inlining_enabled := True
			is_automatic_inlining_enabled := False
			is_automatic_loop_unrolling_enabled := False
			is_sound_loop_unrolling_enabled := True
			is_precondition_predicate_enabled := False
			is_postcondition_predicate_enabled := False
			is_checking_overflow := False
			is_checking_frame := True
			is_using_ownership := True
			loop_unrolling_depth := 5
			max_recursive_inlining_depth := 4

			is_postcondition_mutation_enabled := False
			is_coupled_mutations_enabled := True
			is_aging_enabled := False
			is_uncoupled_mutations_enabled := False
		end

feature -- Inlining verification step

	is_two_step_verification_enabled: BOOLEAN
			-- Is a verification with inlining done in case of failed verifications?

	set_two_step_verification_enabled (a_value: BOOLEAN)
			-- Set `is_two_step_verification_enabled' to `a_value'.
		do
			is_two_step_verification_enabled := a_value
		end


feature --Postcondition mutation step

	is_postcondition_mutation_enabled: BOOLEAN
			-- Should postcondition mutation be executed?

	set_postcondition_mutation_enabled (a_value: BOOLEAN)
			-- Set `is_postcondition_mutation_enabled' to `a_value'.
		do
			is_postcondition_mutation_enabled := a_value
		end

	is_coupled_mutations_enabled : BOOLEAN
			-- Execute postcondition mutation with coupled mutations?
			-- This is usually the minimum, but can be turned off if uncoupled is used instead.

	set_coupled_mutations_enabled (a_value: BOOLEAN)
			-- Set `is_coupled_mutations_enabled' to `a_value'.
		do
			is_coupled_mutations_enabled := a_value
		end

	is_uncoupled_mutations_enabled: BOOLEAN
			-- Execute postcondition mutation with uncoupled mutations?

	set_uncoupled_mutations_enabled(a_value: BOOLEAN)
			-- Set `is_uncoupled_mutations_enabled' to `a_value'.
		do
			is_uncoupled_mutations_enabled := a_value
		end

	is_aging_enabled : BOOLEAN
			-- Execute postcondition mutation with variable aging?

	set_aging_enabled (a_value: BOOLEAN)
			-- Set `is_aging_enabled' to `a_value'.
		do
			is_aging_enabled := a_value
		end

feature -- Inlining options

	is_inlining_enabled: BOOLEAN
			-- Is inlining enabled?

	inlining_depth: INTEGER
			-- Current inlining depth.

	max_recursive_inlining_depth: INTEGER
			-- Maximum inlining depth for inlining recursive features.

	set_max_recursive_inlining_depth (a_value: INTEGER)
			-- Set `max_recursive_inlining_depth' to `a_value'.
		do
			max_recursive_inlining_depth := a_value
		end

	set_inlining_depth (a_value: INTEGER)
			-- Set `inlining_depth' to `a_value'.
		do
			inlining_depth := a_value
		end

	is_automatic_inlining_enabled: BOOLEAN
			-- Is automatic inlining of certain routines enabled?

	set_automatic_inlining_enabled (a_value: BOOLEAN)
			-- Set `is_automatic_inlining_enabled' to `a_value'.
		do
			is_automatic_inlining_enabled := a_value
		end

	routines_to_inline: LINKED_LIST [INTEGER]
			-- Routines to inline.
		once
			create Result.make
		end

feature -- Loop unrolling

	loop_unrolling_depth: INTEGER
			-- Loop unrolling depth.

	set_loop_unrolling_depth (a_value: INTEGER)
			-- Set `loop_unrolling_depth' to `a_value'.
		do
			loop_unrolling_depth := a_value
		end

	is_automatic_loop_unrolling_enabled: BOOLEAN
			-- Is automatic unrolling of certain loops enabled?

	set_automatic_loop_unrolling_enabled (a_value: BOOLEAN)
			-- Set `is_automatic_loop_unrolling_enabled' to `a_value'.
		do
			is_automatic_loop_unrolling_enabled := a_value
		end

	is_sound_loop_unrolling_enabled: BOOLEAN
			-- Is loop unrolling being done in a sound way?

	set_sound_loop_unrolling_enabled (a_value: BOOLEAN)
			-- Set `is_sound_loop_unrolling_enabled' to `a_value'.
		do
			is_sound_loop_unrolling_enabled := a_value
		end

feature -- Precondition and postcondition predicates

	is_precondition_predicate_enabled: BOOLEAN
			-- Is generation of precondition predicates enabled?

	set_precondition_predicate_enabled (a_value: BOOLEAN)
			-- Set `is_precondition_predicate_enabled' to `a_value'.
		do
			is_precondition_predicate_enabled := a_value
		end

	is_postcondition_predicate_enabled: BOOLEAN
			-- Is generation of postcondition predicates enabled?

	set_postcondition_predicate_enabled (a_value: BOOLEAN)
			-- Set `is_postcondition_predicate_enabled' to `a_value'.
		do
			is_postcondition_predicate_enabled := a_value
		end

feature -- Overflow checks

	is_checking_overflow: BOOLEAN
			-- Is checking of overflow enabled?

	set_checking_overflow (a_value: BOOLEAN)
			-- Set `is_checking_overflow' to `a_value'.
		do
			is_checking_overflow := a_value
		end

feature -- Framing

	is_checking_frame: BOOLEAN
			-- Is frame checked?

	set_checking_frame (a_value: BOOLEAN)
			-- Set `is_checking_frame' to `a_value'.
		do
			is_checking_frame := a_value
		end

	is_using_ownership: BOOLEAN
			-- Is ownership translation used?

	set_using_ownership (a_value: BOOLEAN)
			-- Set `is_using_ownership' to `a_value'.
		do
			is_using_ownership := a_value
		end

end
