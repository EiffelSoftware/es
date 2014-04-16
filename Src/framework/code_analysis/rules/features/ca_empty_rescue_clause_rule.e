note
	description: "[
					RULE #59: Empty rescue clause
		
					An empty rescue clause should be avoided and leads to undesirable program behaviour.
	]"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_EMPTY_RESCUE_CLAUSE_RULE

inherit

	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			make_with_defaults
		end

feature {NONE} -- Activation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_feature_pre_action (agent process_feature)
		end

feature {NONE} -- Rule checking

	process_feature (a_feature_as: FEATURE_AS)
		local
			l_rescue_keyword: KEYWORD_AS
			l_viol: CA_RULE_VIOLATION
		do
			if attached {ROUTINE_AS} a_feature_as.body.content as routine_as then
					-- routine_as.has_rescue is not very helpful, as it only tells us
					-- if the routine has a *non empty* rescue clause.
				l_rescue_keyword := routine_as.rescue_keyword (current_context.matchlist)
				if attached l_rescue_keyword and (routine_as.rescue_clause = Void or else routine_as.rescue_clause.is_empty) then
					create l_viol.make_with_rule (Current)
					l_viol.set_location (l_rescue_keyword.start_location)
					l_viol.long_description_info.extend (a_feature_as.feature_name.name_8)
					violations.extend (l_viol)
				end
			end
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.empty_rescue_clause_title
		end

	id: STRING_32 = "CA059"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.empty_rescue_clause_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.empty_rescue_clause_violation_1)
			check attached {STRING} a_violation.long_description_info.first as feature_name then
				a_formatter.add_feature_name (feature_name, a_violation.affected_class)
			end
			a_formatter.add (ca_messages.empty_rescue_clause_violation_2)
		end

end
