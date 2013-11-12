note
	description: "Summary description for {CA_EMPTY_IF_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_EMPTY_IF_RULE
inherit
	CA_STANDARD_RULE
create
	make

feature {NONE} -- Initialization

	make
		do
			is_enabled := True
			create {CA_WARNING} severity
			create violations.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_if_pre_action (agent process_if)
		end

feature -- Properties

	title: STRING
		do
			Result := ca_names.empty_if_title
		end

	description: STRING
		do
			Result := ca_names.empty_if_description
		end

	is_system_wide: BOOLEAN = False

	options: LINKED_LIST[CA_RULE_OPTION[ANY]]
		once
			create Result.make
		end

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			-- TODO
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
