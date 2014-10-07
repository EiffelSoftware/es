note
	description: "[
			RULE #87: Mergeable conditionals
	
			Successive conditional instructions with the same condition can be merged.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_MERGEABLE_CONDITIONALS_RULE

inherit
	CA_STANDARD_RULE
		rename
			make_with_defaults as make
		end

create
	make

feature -- Access

	title: STRING_32
		do
			Result := ca_names.mergeable_conditionals_title
		end

	id: STRING_32 = "CA087"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.mergeable_conditionals_description
		end

feature {NONE} -- Implementation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_if_pre_action (agent process_if)
		end

	process_if (a_if: attached IF_AS)
		do
			if
				attached last_if
				and then last_if.condition.text_32 (current_context.matchlist).is_equal (a_if.condition.text_32 (current_context.matchlist))
			then
				create_violation(last_if)
			end

			last_if := a_if
		end

	last_if: IF_AS

	create_violation (a_if: attached IF_AS)
		local
			l_violation: CA_RULE_VIOLATION
--			l_fix: CA_OBJECT_TEST_FAILING_FIX TODO Implement.
		do
			create l_violation.make_with_rule (Current)

			l_violation.set_location (a_if.start_location)

--			create l_fix.make
--			l_violation.fixes.extend (l_fix)

			violations.extend (l_violation)
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.mergeable_conditionals_violation_1)
		end

end

