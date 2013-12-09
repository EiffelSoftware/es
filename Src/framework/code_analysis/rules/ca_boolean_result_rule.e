note
	description: "Summary description for {CA_BOOLEAN_RESULT_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_BOOLEAN_RESULT_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

create
	make

feature {NONE} -- Initialization

	make
		do
			is_enabled_by_default := True
			create {CA_WARNING} severity
			create violations.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_if_pre_action (agent process_if)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.boolean_result_title
		end

	id: STRING_32 = "CA041T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result := ca_names.boolean_result_description
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.boolean_result_violation)
		end

feature {NONE} -- Rule Checking

	process_if (a_if: IF_AS)
		local
			l_violation: CA_RULE_VIOLATION
		do
				-- If-else instructions without any 'elseif':
			if attached a_if.compound as l_if_branch
					and attached a_if.else_part as l_else_branch
					and not attached a_if.elsif_list then
				if l_if_branch.count = 1 and l_else_branch.count = 1 then
					if is_result_assign (l_if_branch.first) and is_result_assign (l_else_branch.first) then
						create l_violation.make_with_rule (Current)
						l_violation.set_location (a_if.start_location)
						violations.extend (l_violation)
					end
				end
			end
		end

	is_result_assign (a_instruction: INSTRUCTION_AS): BOOLEAN
		do
			if attached {ASSIGN_AS} a_instruction as l_assign then
				Result := (attached {RESULT_AS} l_assign.target) and (attached {BOOL_AS} l_assign.source)
			end
		end

end
