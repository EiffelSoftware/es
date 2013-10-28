note
	description: "Summary description for {CA_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_RULE

feature -- Activation

	prepare_checking (a_checker: CA_ALL_RULES_CHECKER)
		deferred
		end

feature -- Basic properties, usually fix

	title: STRING
		deferred
		end

	description: STRING
		deferred
		end

	options: LINKED_LIST[CA_RULE_OPTION]
		deferred
		end

	is_system_wide: BOOLEAN
			-- Only check the rule if a system wide analysis is performed.
		deferred
		end

feature -- Properties the user can change

	is_enabled: BOOLEAN

	enable
		do
			is_enabled := True
		ensure
			is_enabled
		end

	disable
		do
			is_enabled := False
		ensure
			not is_enabled
		end

	severity: CA_RULE_SEVERITY

	set_severity (a_severity: CA_RULE_SEVERITY)
		do
			severity := a_severity
		end

feature -- Results

	violations: LINKED_LIST[CA_RULE_VIOLATION]

invariant
	title_set: title.count > 3
end
