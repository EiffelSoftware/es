note
	description: "[
			RULE #1: Self-assignment
			
			Assigning a variable to itself is a meaningless instruction
			due to a typing error. Most probably, one of the two
			variable names was misspelled. One example among many
			others: the programmer wanted to assign a local variable
			to a class attribute and used one of the variable names twice.
		]"
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_SELF_ASSIGNMENT_RULE

inherit
	CA_STANDARD_RULE
		redefine
			id
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization.
		do
			-- set the default parameters (subject to be changed by user)
			is_enabled_by_default := True
			create {CA_WARNING} severity
			create violations.make
			default_severity_score := 50
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_assign_pre_action (agent pre_assign)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.self_assignment_title
		end

	id: STRING_32 = "CA001"
			-- <Precursor>

	description: STRING_32
		do
			Result :=  ca_names.self_assignment_description
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.self_assignment_violation_1)
			if attached {STRING_32} a_violation.long_description_info.first as l_name then
				a_formatter.add_local (l_name)
			end
			a_formatter.add (ca_messages.self_assignment_violation_2)
		end

feature {NONE} -- Checking the rule

	pre_assign (a_assign_as: ASSIGN_AS)
			-- Checks `a_assign_as' for rule violations.
		local
			l_violation: CA_RULE_VIOLATION
		do
			if attached {EXPR_CALL_AS} a_assign_as.source as l_source then
				if attached {ACCESS_ID_AS} l_source.call as l_src_access_id then
					if attached {ACCESS_ID_AS} a_assign_as.target as l_tar
					and then l_tar.feature_name.is_equal (l_src_access_id.feature_name) then
						create l_violation.make_with_rule (Current)
						l_violation.set_location (a_assign_as.start_location)
						l_violation.long_description_info.extend (l_src_access_id.feature_name.name_32)
						violations.extend (l_violation)
					end
				end
			end
		end

end
