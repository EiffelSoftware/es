note
	description: "Summary description for {CA_UNUSED_ARGUMENT_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNUSED_ARGUMENT_RULE
inherit
	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization
	make
		do
			-- set the default parameters (subject to be changed by user)
			is_enabled := True
			create {CA_WARNING} severity
			create violations.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_feature_pre_action (agent process_feature)
			a_checker.add_body_pre_action (agent process_body)
			a_checker.add_body_post_action (agent post_process_body)
			a_checker.add_access_id_pre_action (agent process_access_id)
		end

feature -- Properties

	title: STRING
		once
			Result := "Unused argument"
		end

	description: STRING
		once
			Result :=  "A feature should only have arguments which are actually %
			           %needed and used in the computation."
		end

	options: LINKED_LIST[CA_RULE_OPTION]
		once
			create Result.make
		end


	is_system_wide: BOOLEAN
		once
			Result := False
		end

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			a_formatter.add_string ("Routine '")
			if attached {FEATURE_AS} a_violation.long_description_info.first as l_feature then
				a_formatter.add_feature_name (l_feature.feature_name.name_32, a_violation.affected_class)
			else
				a_formatter.add_char ('?')
			end
			a_formatter.add_string ("' has unused arguments.")
		end

feature {NONE} -- Rule Checking

	process_feature (a_feature_as: FEATURE_AS)
		do
			current_feature := a_feature_as
		end

	process_body (a_body_as: BODY_AS)
		local
			j: INTEGER
		do
			has_arguments := (a_body_as.arguments /= Void)
			if has_arguments then
				routine_body := a_body_as
				create arg_names.make (0)
				create args_used.make (0)
				n_arguments := 0
				across a_body_as.arguments as l_args loop
					from
						j := 1
					until
						j > l_args.item.id_list.count
					loop
						arg_names.extend (l_args.item.item_name (j))
						args_used.extend (False)
						n_arguments := n_arguments + 1
						j := j + 1
					end
				end
			end
		end

	post_process_body (a_body: BODY_AS)
		local
			l_violation: CA_RULE_VIOLATION
		do
			if has_arguments and then args_used.has (False) then
				create l_violation.make_with_rule (Current)
				l_violation.set_affected_class (checking_class)
				l_violation.set_location (routine_body.start_location)
				l_violation.long_description_info.extend (current_feature)
				violations.extend (l_violation)
			end
		end

	process_access_id (a_aid: ACCESS_ID_AS)
		local
			id, j: INTEGER
		do
			from
				j := 1
			until
				j > n_arguments
			loop
				if args_used.at (j) = False then
					if arg_names.has (a_aid.feature_name.name_8) then
						args_used.put_i_th (True, j)
					end
				end
				j := j + 1
			end
		end

	has_arguments: BOOLEAN
	current_feature: FEATURE_AS
	routine_body: BODY_AS
	n_arguments: INTEGER
	arg_names: ARRAYED_LIST[STRING]
	args_used: ARRAYED_LIST[BOOLEAN]

end
