note
	description: "Summary description for {CA_FEATURE_NEVER_CALLED_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_FEATURE_NEVER_CALLED_RULE

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
			end


feature -- Properties

	title: STRING
		once
			Result := "---"
		end

	description: STRING
		once
			Result :=  "---"
		end

	options: LINKED_LIST[CA_RULE_OPTION[ANY]]
		once
			create Result.make
		end


	is_system_wide: BOOLEAN
		once
			Result := False
		end

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do

		end

end
