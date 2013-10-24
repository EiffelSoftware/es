note
	description: "Summary description for {CA_SELF_ASSIGNMENT_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_SELF_ASSIGNMENT_RULE

inherit
	CA_RULE
		redefine
			title
		end

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
			Result := "Self-assignment"
		end

	description: STRING
		once
			Result :=  "Assigning a variable to itself is a meaningless statement%
			               % due to a typing error. Most probably, one of the two%
			               % variable names was misspelled. One example among many%
			               % others: the programmer wanted to assign a local variable%
			               % to a class attribute and used one of the variable names twice."
		end

	rule_checker: CA_RULE_CHECKER
		once
			create {CA_SELF_ASSIGNMENT_RULE_CHECKER} Result.make_with_rule (Current)
		end

	options: LINKED_LIST[CA_RULE_OPTION]
		once
			create Result.make
		end

end
