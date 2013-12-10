note
	description: "Summary description for {CA_SIMPLIFIABLE_BOOLEAN_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_SIMPLIFIABLE_BOOLEAN_RULE

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
			a_checker.add_un_not_pre_action (agent process_un_not)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.simplifiable_boolean_title
		end

	id: STRING_32 = "CA057T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result := ca_names.simplifiable_boolean_description
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			
		end

feature {NONE} -- Rule Checking

	process_un_not (a_un_not: UN_NOT_AS)
		local
			l_viol: CA_RULE_VIOLATION
		do

		end

end
