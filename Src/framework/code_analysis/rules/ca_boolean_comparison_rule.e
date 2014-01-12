note
	description: "See `description'."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_BOOLEAN_COMPARISON_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization.
		do
			is_enabled_by_default := True
			create {CA_WARNING} severity
			create violations.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_bin_eq_pre_action (agent process_bin_eq)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.boolean_comparison_title
		end

	id: STRING_32 = "CA042T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result := ca_names.boolean_comparison_description
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.boolean_comparison_violation)
		end

feature {NONE} -- Rule Checking

	process_bin_eq (a_bin_eq: BIN_EQ_AS)
			-- Checks if `a_bin_eq' compares a boolean constant.
		local
			l_viol: CA_RULE_VIOLATION
		do
			if attached {BOOL_AS} a_bin_eq.left or attached {BOOL_AS} a_bin_eq.right then
				create l_viol.make_with_rule (Current)
				l_viol.set_location (a_bin_eq.start_location)
				violations.extend (l_viol)
			end
		end

end
