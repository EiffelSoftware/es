note
	description: "Summary description for {CA_CQ_SEPARATION_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CQ_SEPARATION_RULE

inherit
	CA_STANDARD_RULE
		redefine
			id
		end

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
			a_checker.add_feature_pre_action (agent pre_process_feature)
			a_checker.add_feature_post_action (agent post_process_feature)

			a_checker.add_assign_pre_action (agent process_assign)
			a_checker.add_creation_pre_action (agent process_creation)
			a_checker.add_instruction_call_pre_action (agent process_instruction_call)
		end

feature {NONE} -- AST Visits

	pre_process_feature (a_feature: FEATURE_AS)
		do
			is_function := a_feature.is_function
			rule_violated := False
		end

	post_process_feature (a_feature: FEATURE_AS)
		local
			l_violation: CA_RULE_VIOLATION
		do
			if rule_violated then
				create l_violation.make_with_rule (Current)
				l_violation.set_location (a_feature.start_location)
				l_violation.long_description_info.extend (a_feature.feature_name.name_32)
				violations.extend (l_violation)
			end
		end

	is_function, rule_violated: BOOLEAN

	process_assign (a_assign: ASSIGN_AS)
		do
			-- Skip the checks if we are not within a function.
			if is_function then
				if attached {ACCESS_ID_AS} a_assign.target as l_access_id then
					if checking_class.feature_with_id (l_access_id.feature_name) /= Void then
						-- We have an assignment to an attribute.
						rule_violated := True
					end
				end
			end
		end

	process_creation (a_creation: CREATION_AS)
		do
			-- Skip the checks if we are not within a function.
			if is_function then
				if attached {ACCESS_ID_AS} a_creation.target as l_access_id then
					if checking_class.feature_with_id (l_access_id.feature_name) /= Void then
						-- We have a creation of an attribute.
						rule_violated := True
					end
				end
			end
		end

	process_instruction_call (a_call: INSTR_CALL_AS)
		do
			-- Skip the checks if we are not within a function.
			if is_function then
				if attached {ACCESS_ID_AS} a_call.call as l_access_id then
					if attached checking_class.feature_with_id (l_access_id.feature_name) as l_feat then
						if l_feat.is_procedure then
							-- There is a procedure call within this function.
							rule_violated := True
						end
					end
				end
			end
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.cq_separation_title
		end

	id: STRING_32 = "CA004T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result :=  "---"
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.cq_separation_violation_1)
			if attached {STRING_32} a_violation.long_description_info.first as l_feature_name then
				a_formatter.add_feature_name (l_feature_name, a_violation.affected_class)
			end
			a_formatter.add (ca_messages.cq_separation_violation_2)
		end
end
