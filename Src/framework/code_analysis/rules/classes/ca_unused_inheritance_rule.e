note
	description: "[
			RULE #77: Unused inheritance
	
			A class has an inheritance link that is used neither for implementation
			nor for polymorphy. This inheritance link should be removed.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNUSED_INHERITANCE_RULE

inherit
	CA_STANDARD_RULE

create
	make_with_defaults

feature -- Access

	title: STRING_32
		do
			Result := ca_names.unused_inheritance_title
		end

	id: STRING_32 = "CA077"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.unused_inheritance_description
		end

feature {NONE} -- Implementation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
		end

	create_violation (a_feature: attached FEATURE_AS)
		local
			l_violation: CA_RULE_VIOLATION
			l_fix: CA_UNUSED_INHERITANCE_FIX
		do
			create l_violation.make_with_rule (Current)

			l_violation.set_location (a_feature.start_location)

			l_violation.fixes.extend (l_fix)

			violations.extend (l_violation)
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.local_used_for_result_violation_1)

			if attached {STRING_32} a_violation.long_description_info.first as l_feature_name then
				a_formatter.add (l_feature_name)
			end

			a_formatter.add (ca_messages.local_used_for_result_violation_2)
		end

end
