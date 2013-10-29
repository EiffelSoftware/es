note
	description: "Summary description for {CA_SELF_ASSIGNMENT_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_SELF_ASSIGNMENT_RULE

inherit
	CA_STANDARD_RULE
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

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_assign_pre_action (agent pre_assign)
		end

feature -- Properties

	title: STRING
		do
			Result := ca_names.self_assignment_title
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

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			a_formatter.add_string ("Variable '")
			if attached {STRING_32} a_violation.long_description_info.first as l_name then
				a_formatter.add_string (l_name)
			else
				a_formatter.add_char ('?')
			end
			a_formatter.add_string ("' is assigned to itself. Assigning a variable to %
			                        %itself is a meaningless statement due to a typing%
			                        % error. Most probably, one of the two variable %
			                        %names was misspelled.")
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
						l_violation.set_affected_class (checking_class)
						l_violation.set_location (a_assign_as.start_location)
						l_violation.long_description_info.extend (l_src_access_id.feature_name.name_32)
						violations.extend (l_violation)
					end
				end
			end
		end

end
