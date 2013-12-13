note
	description: "Summary description for {CA_INSPECT_INSTRUCTIONS_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_INSPECT_INSTRUCTIONS_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

create
	make

feature {NONE} -- Initialization

	make (a_pref_manager: PREFERENCE_MANAGER)
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
			max_instructions := l_factory.new_integer_preference_value (a_pref_manager,
				preference_namespace + ca_names.inspect_instructions_max_instructions_option,
				default_max)
			max_instructions.set_default_value (default_max.out)
			max_instructions.set_validation_agent (agent is_integer_string_within_bounds (?, 1, 1_000_000))
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_inspect_pre_action (agent process_inspect)
		end

feature {NONE} -- Rule Checking

	process_inspect (a_inspect: INSPECT_AS)
		local
			l_count, l_max: INTEGER
			l_viol: CA_RULE_VIOLATION
		do
			if attached a_inspect.case_list then
				across a_inspect.case_list as l_cases loop
					if attached l_cases.item.compound as l_comp then
						l_count := l_comp.count
						l_max := max_instructions.value
						if l_count > l_max then
							create l_viol.make_with_rule (Current)
							l_viol.set_location (l_cases.item.start_location)
							l_viol.long_description_info.extend (l_count)
							l_viol.long_description_info.extend (l_max)
							violations.extend (l_viol)
						end
					end
				end
			end
		end

feature {NONE} -- Options

	max_instructions: INTEGER_PREFERENCE

	default_max: INTEGER = 8

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.inspect_instructions_title
		end

	id: STRING_32 = "CA044T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result := ca_names.inspect_instructions_description
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.inspect_instructions_violation_1)
			if attached {INTEGER} a_violation.long_description_info.first as l_count then
				a_formatter.add_int (l_count)
			end
			a_formatter.add (ca_messages.inspect_instructions_violation_2)
			if attached {INTEGER} a_violation.long_description_info.at (2) as l_max then
				a_formatter.add_int (l_max)
			end
			a_formatter.add (".")
		end

end
