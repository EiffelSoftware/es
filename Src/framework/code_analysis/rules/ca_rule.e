note
	description: "Summary description for {CA_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_RULE

inherit
	CA_SHARED_NAMES

feature -- Basic properties, usually fix

	title: STRING
		deferred
		end

	description: STRING
		deferred
		end

	options: LINKED_LIST[CA_RULE_OPTION[ANY]]
		deferred
		end

	is_system_wide: BOOLEAN
			-- Only check the rule if a system wide analysis is performed.
		deferred
		end

feature {CA_RULE_VIOLATION} -- formatted rule checking output

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		require
			violation_belongs_to_rule: violations.has (a_violation)
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

feature -- Rule checking

	set_checking_class (a_class: CLASS_C)
		do
			checking_class := a_class
		end

	checking_class: detachable CLASS_C

feature -- Results

	violations: LINKED_LIST[CA_RULE_VIOLATION]

end
