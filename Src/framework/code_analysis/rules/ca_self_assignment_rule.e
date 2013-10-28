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
			create violations.make
		end

feature -- Activation

	prepare_checking (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_assign_pre_action (agent pre_assign)
			violations.wipe_out
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

	options: LINKED_LIST[CA_RULE_OPTION]
		once
			create Result.make
		end

	is_system_wide: BOOLEAN
		once
			Result := False
		end

feature {NONE} -- Checking the rule
	pre_assign (a_assign_as: ASSIGN_AS)
		local
			l_violation: CA_RULE_VIOLATION
		do
			if attached {EXPR_CALL_AS} a_assign_as.source as l_source then
				if attached {ACCESS_ID_AS} l_source.call as l_src_access_id then
					if attached {ACCESS_ID_AS} a_assign_as.target as l_tar
					and then l_tar.feature_name.is_equal (l_src_access_id.feature_name) then
						create l_violation.make_with_rule (Current)
--						l_violation.set_affected_class (current_class)
						l_violation.set_location (a_assign_as.start_location)
						l_violation.set_long_description ("Variable '" + l_src_access_id.feature_name.name_8 + "' is assigned to itself...")
						violations.extend (l_violation)
					end
				end
			end
		end

end
