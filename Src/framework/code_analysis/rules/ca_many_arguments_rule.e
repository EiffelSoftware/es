note
	description: "Summary description for {CA_MANY_ARGUMENTS_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_MANY_ARGUMENTS_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

create
	make

feature {NONE} -- Initialization

	make (a_pref_manager: PREFERENCE_MANAGER)
			-- Initialization for `Current'.
		do
			is_enabled_by_default := True
			create {CA_WARNING} severity
			create violations.make
			initialize_options (a_pref_manager)
		end

	initialize_options (a_pref_manager: PREFERENCE_MANAGER)
		local
			l_factory: BASIC_PREFERENCE_FACTORY
		do
			create l_factory
			n_arguments_threshold := l_factory.new_integer_preference_value (a_pref_manager,
				preference_namespace + ca_names.arguments_threshold_option, 4)
			n_arguments_threshold.set_validation_agent (agent is_integer_string_within_bounds (?, 2, 20))
		end

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_feature_pre_action (agent process_feature)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.many_arguments_title
		end

	id: STRING_32 = "CA011T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result := ca_names.many_arguments_description
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		local
			l_infos: LINKED_LIST [ANY]
		do
			l_infos := a_violation.long_description_info

			a_formatter.add (ca_messages.many_arguments_violation_1)
			if attached {STRING_32} l_infos.first as l_feature_name then
				a_formatter.add_feature_name (l_feature_name, a_violation.affected_class)
			end
			a_formatter.add (ca_messages.many_arguments_violation_2)
			if attached {INTEGER} l_infos.at (2) as l_n then
				a_formatter.add_int (l_n)
			end
			a_formatter.add (ca_messages.many_arguments_violation_3)
			if attached {INTEGER} l_infos.at (3) as l_t then
				a_formatter.add_int (l_t)
			end
			a_formatter.add (".")
		end

feature {NONE} -- Options

	n_arguments_threshold : INTEGER_PREFERENCE
		-- The minimum number of arguments a feature body must have in order to
		-- trigger a rule violation.

feature -- Visitor

	process_feature (a_feature: FEATURE_AS)
		local
			n: INTEGER
			l_viol: CA_RULE_VIOLATION
		do
			if attached a_feature.body.arguments as l_args_1 then
				n := 0
				across l_args_1 as l_args_2 loop
					n := n + l_args_2.item.id_list.count
				end

				if n >= n_arguments_threshold.value then
					create l_viol.make_with_rule (Current)
					l_viol.set_location (a_feature.start_location)
					l_viol.long_description_info.extend (a_feature.feature_name.name_32)
					l_viol.long_description_info.extend (n)
					l_viol.long_description_info.extend (n_arguments_threshold.value)
					violations.extend (l_viol)
				end
			end
		end

end
