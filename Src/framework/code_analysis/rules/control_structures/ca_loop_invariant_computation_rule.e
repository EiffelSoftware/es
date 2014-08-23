note
	description: "[
			RULE #21: Loop invariant computation within loop
	
			A loop invariant computation that lies within a loop should be moved outside the loop.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_LOOP_INVARIANT_COMPUTATION_RULE

inherit
	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization.
		do
			make_with_defaults
			create {CA_SUGGESTION} severity
		end

feature {NONE} -- Activation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_routine_pre_action (agent process_routine)
			a_checker.add_loop_pre_action (agent process_loop)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.loop_invariant_comp_within_loop_title
		end

	id: STRING_32 = "CA021"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.loop_invariant_comp_within_loop_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.loop_invariant_comp_within_loop_violation_1)
			if attached {STRING_32} a_violation.long_description_info.first as l_instruction then
				a_formatter.add (l_instruction)
			end
			a_formatter.add (ca_messages.loop_invariant_comp_within_loop_violation_2)
		end

	locals: LOCAL_DEC_LIST_AS

feature {NONE} -- Rule Checking

	process_routine (a_routine: ROUTINE_AS)
			-- Collect all local variables.
		do
			--create locals.make (a_routine.locals, k_as: [like local_keyword] KEYWORD_AS)
		end

	process_loop (a_loop: LOOP_AS)
			-- Checks if `a_loop' has an empty compound.
		local
			l_violation: CA_RULE_VIOLATION
			l_fix: CA_EMPTY_LOOP_FIX
		do
			if not attached a_loop.compound then
				create l_violation.make_with_rule (Current)
				l_violation.set_location (a_loop.start_location)

				create l_fix.make_with_loop (current_context.checking_class, a_loop)
				l_violation.fixes.extend (l_fix)

				violations.extend (l_violation)
			end
		end

end
