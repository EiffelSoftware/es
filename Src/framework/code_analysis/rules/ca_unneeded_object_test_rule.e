note
	description: "Summary description for {CA_UNNEEDED_OBJECT_TEST_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNNEEDED_OBJECT_TEST_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

create
	make

feature {NONE} -- Initialization

	make
		do
			is_enabled := True
			create {CA_SUGGESTION} severity
			create violations.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_object_test_pre_action (agent process_object_test)
		end

feature -- Properties

	title: STRING
		do
			Result := ca_names.unneeded_object_test_title
		end

	id: STRING = "CA006T"
			-- "T" stands for 'under test'.

	description: STRING
		do
			Result :=  ca_names.unneeded_object_test_description
		end

	options: LINKED_LIST[CA_RULE_OPTION[ANY]]
		once
			create Result.make
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)

		do

		end

feature {NONE} -- AST Visits

	process_object_test (a_ot: OBJECT_TEST_AS)
		local
			l_violation: CA_RULE_VIOLATION
		do
			if attached {EXPR_CALL_AS} a_ot.expression as l_call then
				if attached {ACCESS_ID_AS} l_call.call as l_access then
						-- TODO: Check type of call.
				end
					-- TODO: Else: Check type of nested call.
			end
		end

feature {NONE}

end
