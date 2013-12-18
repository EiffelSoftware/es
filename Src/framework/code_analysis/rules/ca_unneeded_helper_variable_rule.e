note
	description: "Summary description for {CA_UNNEEDED_HELPER_VARIABLE_RULE}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNNEEDED_HELPER_VARIABLE_RULE

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
			create {CA_SUGGESTION} severity
			create violations.make
			initialize_preferences (a_pref_manager)
		end

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_feature_pre_action (agent pre_process_feature)
			a_checker.add_feature_post_action (agent post_process_feature)
			a_checker.add_assign_pre_action (agent process_assign)
			a_checker.add_access_id_pre_action (agent process_access_id)

			a_checker.add_assigner_call_pre_action (agent pre_process_assigner_call)
			a_checker.add_bang_creation_pre_action (agent pre_process_bang_creation)
			a_checker.add_create_creation_pre_action (agent pre_process_create_creation)
			a_checker.add_instruction_call_pre_action (agent pre_process_instr_call)
		end

	initialize_preferences (a_pref_manager: PREFERENCE_MANAGER)
		local
			l_factory: BASIC_PREFERENCE_FACTORY
		do
			create l_factory
			max_line_length := l_factory.new_integer_preference_value (a_pref_manager,
				preference_namespace + ca_names.max_line_length_option,
				default_max_line_length)
			max_line_length.set_default_value (default_max_line_length.out)
			max_line_length.set_validation_agent (agent is_integer_string_within_bounds (?, 30, 1000))
		end

feature {NONE} -- Rule checking

	pre_process_feature (a_feature: FEATURE_AS)
		do
			create assignments.make (0)
			create assigned_expression_length.make (0)
			create usages.make (0)
			create usage_line_length.make (0)
			create usage_location.make (0)
		end

	assignments: HASH_TABLE [INTEGER, ID_AS]
			-- Set of variable IDs of local variables that are assigned a value only
			-- once in the feature.

	assigned_expression_length: HASH_TABLE [INTEGER, ID_AS]
			-- For each assignee the # of characters of the right-hand-side is stored.
			-- It suffices to store the last assignment since variables that are
			-- assigned more than once are not considered anyway.

	usages: HASH_TABLE [INTEGER, ID_AS]
			-- How many times is the local variable with a certain ID used in the feature?
			-- Note that the assignment itself also counts.

	current_line_length: INTEGER
			-- # of character of the currently visited instruction.

	usage_line_length: HASH_TABLE [INTEGER, ID_AS]
			-- For each usage the # of characters of this line is stored.
			-- It suffices to store the last usage since variables that are
			-- used more than once are not considered anyway.

	usage_location: HASH_TABLE [LOCATION_AS, ID_AS]
			-- Location where variable with a certain ID has been used last.

	pre_process_assigner_call (a_assigner_call: ASSIGNER_CALL_AS)
		do
			current_line_length := a_assigner_call.end_position - a_assigner_call.start_position + 1
		end

	pre_process_bang_creation (a_bang_creation: BANG_CREATION_AS)
		do
			current_line_length := a_bang_creation.end_position - a_bang_creation.start_position + 1
		end

	pre_process_create_creation (a_create_creation: CREATE_CREATION_AS)
		do
			current_line_length := a_create_creation.end_position - a_create_creation.start_position + 1
		end

	pre_process_instr_call (a_instr_call: INSTR_CALL_AS)
		do
			current_line_length := a_instr_call.end_position - a_instr_call.start_position + 1
		end

	post_process_feature (a_feature: FEATURE_AS)
		local
			l_id: ID_AS
			l_n_usages, l_max: INTEGER
			l_viol: CA_RULE_VIOLATION
		do
			across assignments as l_a loop
				if l_a.item = 1 then
					l_id := l_a.key
					l_n_usages := usages [l_id]

					if l_n_usages = 2 then
							-- 2, since the assignment is included in the count.
						l_max := max_line_length.value
							-- Check if the possible new line is not too long:
						if usage_line_length [l_id] - l_id.name_8.count + assigned_expression_length [l_id] <= l_max then
							create l_viol.make_with_rule (Current)
							l_viol.long_description_info.extend (l_id.name_32)
							l_viol.set_location (usage_location [l_id])
							violations.extend (l_viol)
						end
					end
				end
			end
		end

	process_assign (a_assign: ASSIGN_AS)
		local
			l_id: ID_AS
			l_old_count: INTEGER
		do
				-- In the right-hand-side of this assignment a critical variable might
				-- be used. Thus here, too, we are storing the line length.
			current_line_length := a_assign.end_position - a_assign.start_position + 1

			if attached {ACCESS_FEAT_AS} a_assign.target as l_assignee and then l_assignee.is_local then
					-- Only look at locals.
				l_id := l_assignee.feature_name

				if not assignments.has (l_id) then
					assignments.put (1, l_id)
					assigned_expression_length.force (a_assign.source.end_position - a_assign.source.start_position + 1, l_id)
				else
					l_old_count := assignments [l_id]
					assignments.force (l_old_count + 1, l_id)
				end
			end
		end

	process_access_id (a_access_id: ACCESS_ID_AS)
		local
			l_id: ID_AS
			l_old_count: INTEGER
		do
			if a_access_id.is_local then
					-- Only look at locals.
				l_id := a_access_id.feature_name

				if not usages.has (l_id) then
					usages.put (1, l_id)
				else
					l_old_count := usages [l_id]
					usages.force (l_old_count + 1, l_id)
				end

					-- Store length of line where usage appears.
				usage_line_length.force (current_line_length, l_id)
					-- And store location for the use by a possible rule violation.
				usage_location.force (a_access_id.start_location, l_id)
			end
		end

feature {NONE} -- Preferences

	default_max_line_length: INTEGER = 80

	max_line_length: INTEGER_PREFERENCE

feature -- Properties

	title: STRING_32
			-- Rule title.
		do
			Result := ca_names.unneeded_helper_variable_title
		end

	description: STRING_32
			-- Rule description.
		do
			Result :=  ca_names.unneeded_helper_variable_description
		end

	id: STRING_32 = "CA085T"
			-- "T" stands for 'under test'.

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
			-- Generates a formatted rule violation description for `a_formatter' based on `a_violation'.
		do
			a_formatter.add (ca_messages.unneeded_helper_variable_violation_1)
			if attached {STRING_32} a_violation.long_description_info.first as l_name then
				a_formatter.add_local (l_name)
			end
			a_formatter.add (ca_messages.unneeded_helper_variable_violation_2)
		end

end
