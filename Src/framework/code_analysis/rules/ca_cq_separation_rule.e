note
	description: "Summary description for {CA_CQ_SEPARATION_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CQ_SEPARATION_RULE

inherit
	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make
		do
			is_enabled := True
			create {CA_WARNING} severity
			create violations.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do

		end

feature {NONE} -- AST Visits

	process_feature (a_feature: FEATURE_AS)
		do
			is_function := a_feature.is_function
		end

	is_function: BOOLEAN

	process_assign (a_assign: ASSIGN_AS)
		do
			-- Skip the checks if we are not within a function.
			if is_function then
				if attached {ACCESS_ID_AS} a_assign.target as l_access_id then
					if checking_class.feature_with_id (l_access_id.feature_name) /= Void then
						-- We have an assignment to an attribute.
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
						end
					end
				end
			end
		end

feature -- Properties

	title: STRING
		do
			Result := ca_names.cq_separation_title
		end

	description: STRING
		do
			Result :=  "---"
		end

	options: LINKED_LIST[CA_RULE_OPTION[ANY]]
		once
			create Result.make
		end


	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do

		end
end
