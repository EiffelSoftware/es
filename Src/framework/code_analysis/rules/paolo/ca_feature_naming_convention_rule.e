note
	description: "[
					RULE #64: Feature naming convention violated
		
					Feature names should respect the Eiffel naming convention for features
					(all lowercase, no trailing or two consecutive underscores).
	]"
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_FEATURE_NAMING_CONVENTION_RULE

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

	process_feature (a_feature_as: attached FEATURE_AS)
		local
			l_name: STRING
			l_viol: CA_RULE_VIOLATION
		do
			l_name := a_feature_as.feature_name.name_8
			if not is_valid_feature_name (l_name) then
				create l_viol.make_with_rule (Current)
				l_viol.set_location (a_feature_as.start_location)
				l_viol.long_description_info.extend (l_name)
				violations.extend (l_viol)
			end
		end

	is_valid_feature_name (a_name: attached STRING): BOOLEAN
			-- Currently the casing restriction cannot be enforced, as identifiers received by this
			-- function are always upper- or lower-cased.
		do
			Result := not a_name.ends_with ("_") and not a_name.has_substring ("__") and (a_name.as_lower ~ a_name)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.feature_naming_convention_title
		end

	id: STRING_32 = "CA064"

	description: STRING_32
		do
			Result := ca_names.feature_naming_convention_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.feature_naming_convention_violation_1)
			check attached {STRING} a_violation.long_description_info.first as feature_name then
				a_formatter.add (feature_name)
			end
			a_formatter.add (ca_messages.feature_naming_convention_violation_2)
		end

end
