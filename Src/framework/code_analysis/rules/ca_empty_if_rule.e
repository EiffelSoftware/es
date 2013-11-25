note
	description: "Summary description for {CA_EMPTY_IF_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_EMPTY_IF_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

create
	make

feature {NONE} -- Initialization

	make
		do
			is_enabled_by_default := True
			create {CA_WARNING} severity
			create violations.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_if_pre_action (agent process_if)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.empty_if_title
		end

	id: STRING_32 = "CA017T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result := ca_names.empty_if_description
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.empty_if_violation_1)
		end

feature {NONE} -- Rule Checking

	process_if (a_if: IF_AS)
		local
			l_violation: CA_RULE_VIOLATION
		do
			if not attached a_if.compound then
				create l_violation.make_with_rule (Current)
				l_violation.set_location (a_if.start_location)
				violations.extend (l_violation)
			end
		end

end
