note
	description: "See `description' below."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_SEMICOLON_ARGUMENTS_RULE

inherit
	CA_STANDARD_RULE
		redefine
			id
		end

	SHARED_SERVER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
				-- set the default parameters (subject to be changed by user)
			is_enabled_by_default := True
			create {CA_WARNING} severity
			create violations.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_feature_pre_action (agent process_feature)
			a_checker.add_body_pre_action (agent process_body)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.semicolon_arguments_title
		end

	id: STRING_32 = "CA025T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result :=  ca_names.semicolon_arguments_description
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.semicolon_arguments_violation_1)
			if attached {STRING_32} a_violation.long_description_info.first as l_feat then
				a_formatter.add_feature_name (l_feat, a_violation.affected_class)
			end
			a_formatter.add (ca_messages.semicolon_arguments_violation_2)
		end

feature {NONE} -- Checking the rule

	current_feature_name: STRING_32
			-- Name of currently checked feature.

	process_feature (a_feature: FEATURE_AS)
			-- Sets current feature name.
		do
			current_feature_name := a_feature.feature_name.name_32
		end

	process_body (a_body: BODY_AS)
			-- Checks `a_body' for rule violations.
		local
			l_n_semis: INTEGER
			l_viol: CA_RULE_VIOLATION
		do
			if attached matchlist then
				if attached a_body.arguments as l_a then
					l_n_semis := l_a.text_32 (matchlist).occurrences (';')
					if l_n_semis < l_a.count - 1 then
							-- At least one argument must have no semicolon separator.
						create l_viol.make_with_rule (Current)
						l_viol.set_location (l_a.start_location)
						l_viol.long_description_info.extend (current_feature_name)
						violations.extend (l_viol)
					end
				end
			end
		end

end
