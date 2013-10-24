note
	description: "Summary description for {CA_UNUSED_ARGUMENT_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNUSED_ARGUMENT_RULE
inherit
	CA_RULE

create
	make

feature {NONE} -- Initialization
	make
		do
			-- set the default parameters (subject to be changed by user)
			is_enabled := True
			create {CA_WARNING} severity
		end

feature -- Properties

	title: STRING
		once
			Result := "Unused argument"
		end

	description: STRING
		once
			Result :=  "A feature should only have arguments which are actually %
			           %needed and used in the computation."
		end

	rule_checker: CA_RULE_CHECKER
		once
			create {CA_UNUSED_ARGUMENT_RULE_CHECKER} Result.make_with_rule (Current)
		end

	options: LINKED_LIST[CA_RULE_OPTION]
		once
			create Result.make
		end

end
