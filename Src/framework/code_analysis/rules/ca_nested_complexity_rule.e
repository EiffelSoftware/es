note
	description: "Summary description for {CA_NESTED_COMPLEXITY_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_NESTED_COMPLEXITY_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

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
			a_checker.add_feature_pre_action (agent pre_process_feature)
			a_checker.add_feature_post_action (agent post_process_feature)
			a_checker.add_if_pre_action (agent pre_process_if)
			a_checker.add_if_post_action (agent post_process_if)
			a_checker.add_loop_pre_action (agent pre_process_loop)
			a_checker.add_loop_post_action (agent post_process_loop)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.nested_complexity_title
		end

	id: STRING_32 = "CA010T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result :=  ca_names.nested_complexity_description
		end

	options: LINKED_LIST [CA_RULE_OPTION [INTEGER]]
		local
			l_threshold: CA_RULE_OPTION [INTEGER]
		once
			create l_threshold.make_with_caption (ca_names.nested_complexity_threshold_option)
			l_threshold.set_valid_choice_agent (agent is_threshold_within_bounds)
			l_threshold.set_choice (5) -- default option

			create Result.make
			Result.extend (l_threshold)
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		local
			l_info: LINKED_LIST[ANY]
		do
			l_info := a_violation.long_description_info
			a_formatter.add (ca_messages.nested_complexity_violation_1)
			if attached {STRING_32} l_info.first as l_feature_name then
				a_formatter.add_feature_name (l_feature_name, a_violation.affected_class)
			end
			a_formatter.add (ca_messages.nested_complexity_violation_2)
			if attached {INTEGER} l_info.at (2) as l_max then
				a_formatter.add_int (l_max)
			end
			a_formatter.add (ca_messages.nested_complexity_violation_3)
			if attached {INTEGER} l_info.at (3) as l_option then
				a_formatter.add_int (l_option)
			end
			a_formatter.add (".")
		end

feature {NONE} -- Options

	is_threshold_within_bounds (a_threshold: INTEGER): BOOLEAN
		do
			Result := a_threshold >= 2 and a_threshold <= 100
		end

feature {NONE} -- AST Visits

	current_feature: detachable FEATURE_AS

	current_depth, maximum_depth: INTEGER

	current_violation_exists: BOOLEAN

	pre_process_feature (a_feature: FEATURE_AS)
		do
			current_feature := a_feature
			current_depth := 0
			maximum_depth := 0
			current_violation_exists := False
		end

	post_process_feature (a_feature: FEATURE_AS)
		local
			l_violation: CA_RULE_VIOLATION
		do
			if current_violation_exists then
				create l_violation.make_with_rule (Current)
				l_violation.set_location (current_feature.start_location)
				l_violation.long_description_info.extend (current_feature.feature_name.name_32)
				l_violation.long_description_info.extend (maximum_depth)
				l_violation.long_description_info.extend (options.first.choice)
				violations.extend (l_violation)
			end
		end

	pre_process_if (a_if: IF_AS)
		do
			current_depth := current_depth + 1
			evaluate_depth
		end

	post_process_if (a_if: IF_AS)
		do
			current_depth := current_depth - 1
		end

	pre_process_loop (a_loop: LOOP_AS)
		do
			current_depth := current_depth + 1
			evaluate_depth
		end

	post_process_loop (a_loop: LOOP_AS)
		do
			current_depth := current_depth - 1
		end

	evaluate_depth
		do
			if current_depth > maximum_depth then
				maximum_depth := current_depth
			end

			if not current_violation_exists then
				if current_depth >= options.first.choice then
					current_violation_exists := True
				end
			end
		end

end
