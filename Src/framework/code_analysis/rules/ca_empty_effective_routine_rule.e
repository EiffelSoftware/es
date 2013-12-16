note
	description: "Summary description for {CA_EMPTY_EFFECTIVE_ROUTINE_RULE}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_EMPTY_EFFECTIVE_ROUTINE_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			is_enabled_by_default := True
			create {CA_SUGGESTION} severity
			create violations.make
		end

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_feature_pre_action (agent process_feature)
			a_checker.add_do_pre_action (agent process_do)
		end

feature {NONE} -- Rule checking

	process_feature (a_feature: FEATURE_AS)
		do
			current_feature := a_feature
		end

	current_feature: FEATURE_AS

	process_do (a_do: DO_AS)
		local
			l_viol: CA_RULE_VIOLATION
		do
				-- Make sure the feature is not a function. For a function, keeping the default
				-- value for the Result is some sort of implementation, too.
			if (checking_class.is_deferred and not current_feature.is_function) and then a_do.compound = Void then
				create l_viol.make_with_rule (Current)
				l_viol.set_location (current_feature.start_location)
				l_viol.long_description_info.extend (current_feature.feature_name.name_32)
				violations.extend (l_viol)
			end
		end

feature -- Properties

	title: STRING_32
			-- Rule title.
		do
			Result := ca_names.empty_effective_routine_title
		end

	description: STRING_32
			-- Rule description.
		do
			Result :=  ca_names.empty_effective_routine_description
		end

	id: STRING_32 = "CA053T"
			-- "T" stands for 'under test'.

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
			-- Generates a formatted rule violation description for `a_formatter' based on `a_violation'.
		do
			a_formatter.add (ca_messages.empty_effective_routine_violation_1)
			if attached {STRING_32} a_violation.long_description_info.first as l_feature then
				a_formatter.add_feature_name (l_feature, a_violation.affected_class)
			end
			a_formatter.add (ca_messages.empty_effective_routine_violation_2)
		end

end
