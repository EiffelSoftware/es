note
	description: "Summary description for {CA_VERY_SHORT_IDENTIFIER_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_VERY_SHORT_IDENTIFIER_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
				-- set the default parameters (subject to be changed by user)
			is_enabled_by_default := True
			create {CA_WARNING} severity
			create violations.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			
		end

feature {NONE} -- Rule checking



feature -- Properties

	title: STRING_32
		do
			Result := ca_names.very_short_identifier_title
		end

	id: STRING_32 = "CA061T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result :=  ca_names.very_short_identifier_description
		end

	is_system_wide: BOOLEAN
		once
			Result := False
		end

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do

		end

end
