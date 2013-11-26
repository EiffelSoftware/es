note
	description: "Summary description for {CA_UNNEEDED_OBJECT_TEST_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNNEEDED_OT_LOCAL_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

create
	make

feature {NONE} -- Initialization

	make
		do
			is_enabled_by_default := True
			create {CA_SUGGESTION} severity
			create violations.make
			default_severity_score := 70
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_object_test_pre_action (agent process_object_test)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.unneeded_ot_local_title
		end

	id: STRING_32 = "CA005T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result :=  ca_names.unneeded_ot_local_description
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)

		do
			a_formatter.add ("'")
			if attached {STRING_32} a_violation.long_description_info.first as l_name then
				a_formatter.add_local (l_name)
			end
			a_formatter.add (ca_messages.unneeded_ot_local_violation_1)
			if attached {STRING_32} a_violation.long_description_info.at (2) as l_name then
				a_formatter.add_local (l_name)
			end
			a_formatter.add ("'.")
		end

feature {NONE} -- AST Visits

	process_object_test (a_ot: OBJECT_TEST_AS)
		local
			l_violation: CA_RULE_VIOLATION
		do
				-- The expression to be tested must be a simple call.
			if attached {EXPR_CALL_AS} a_ot.expression as l_call then
				if attached {ACCESS_ID_AS} l_call.call as l_access then
						-- Testing if an object test local is used.
					if attached a_ot.name as l_ot_local then
							-- There must be no dynamic type check.
						if a_ot.type = Void then
								-- Now we have to check whether the tested expression is a local,
								-- an argument, or an object test local.
							if l_access.is_local or l_access.is_argument or l_access.is_object_test_local then
								create l_violation.make_with_rule (Current)
								l_violation.set_location (a_ot.start_location)
								l_violation.long_description_info.extend (l_access.access_name_32)
								l_violation.long_description_info.extend (l_ot_local.name_32)
								violations.extend (l_violation)
							end
						end
					end
				end
			end
		end

end
