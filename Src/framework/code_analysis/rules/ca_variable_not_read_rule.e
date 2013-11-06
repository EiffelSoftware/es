note
	description: "Summary description for {CA_VARIABLE_NOT_READ_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_VARIABLE_NOT_READ_RULE

inherit
	CA_CFG_RULE

create
	make

feature {NONE} -- Initialization

	make
		do
			is_enabled := True
			create {CA_WARNING} severity
			create violations.make
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
			Result := True
		end

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do

		end


end
