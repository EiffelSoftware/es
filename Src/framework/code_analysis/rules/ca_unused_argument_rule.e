note
	description: "See `description' below."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNUSED_ARGUMENT_RULE
inherit
	CA_STANDARD_RULE
		redefine
			id
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization.
		do
				-- Set the default parameters (subject to be changed by user).
			is_enabled_by_default := True
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

	title: STRING_32
		do
			Result := ca_names.unused_argument_title
		end

	id: STRING_32 = "CA002T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result :=  ca_names.unused_argument_description
		end

	is_system_wide: BOOLEAN
		once
			Result := False
		end

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		local
			j: INTEGER
		do
			a_formatter.add (ca_messages.unused_argument_violation_1)
			from
				j := 2
			until
				j > a_violation.long_description_info.count
			loop
				if j > 2 then a_formatter.add (", ") end
				a_formatter.add ("'")
				if attached {STRING_32} a_violation.long_description_info.at (j) as l_arg then
					a_formatter.add_local (l_arg)
				end
				a_formatter.add ("'")
				j := j + 1
			end
			a_formatter.add (ca_messages.unused_argument_violation_2)
			if attached {FEATURE_AS} a_violation.long_description_info.first as l_feature then
				a_formatter.add_feature_name (l_feature.feature_name.name_32, a_violation.affected_class)
			end
			a_formatter.add (ca_messages.unused_argument_violation_3)
		end

feature {NONE} -- Rule Checking

	process_feature (a_feature_as: FEATURE_AS)
			-- Sets the current feature.
		do
			current_feature := a_feature_as
		end

	process_body (a_body_as: BODY_AS)
			-- Retrieves the arguments from `a_body_as'.
		local
			j: INTEGER
		do
			has_arguments := (a_body_as.arguments /= Void)
			create args_used.make (0)
			n_arguments := 0
			if attached a_body_as.as_routine as l_rout then
				if has_arguments and (not l_rout.is_external) then
					routine_body := a_body_as
					create arg_names.make (0)
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
		end

	post_process_body (a_body: BODY_AS)
			-- Adds a violation if the feature contains unused arguments.
		local
			l_violation: CA_RULE_VIOLATION
			j: INTEGER
		do
			if a_body.content /= Void
			and then not current_feature.is_deferred
			and then has_arguments
			and then args_used.has (False) then
				create l_violation.make_with_rule (Current)
				l_violation.set_location (routine_body.start_location)
				l_violation.long_description_info.extend (current_feature)
				from
					j := 1
				until
					j > n_arguments
				loop
					if not args_used.at (j) then
						l_violation.long_description_info.extend (arg_names.at (j))
					end
					j := j + 1
				end
				violations.extend (l_violation)
			end
		end

	process_access_id (a_aid: ACCESS_ID_AS)
			-- Mark an argument as used if it corresponds to `a_aid'.
		local
			j: INTEGER
		do
			from
				j := 1
			until
				j > n_arguments
			loop
				if not args_used.at (j) then
					if arg_names.at (j).is_equal (a_aid.feature_name.name_32) then
						args_used.put_i_th (True, j)
					end
				end
				j := j + 1
			end
		end

	has_arguments: BOOLEAN
			-- Does current feature have arguments?

	current_feature: FEATURE_AS
			-- Currently checked feature.

	routine_body: BODY_AS
			-- Current routine body.

	n_arguments: INTEGER
			-- # arguments for current routine.

	arg_names: ARRAYED_LIST [STRING_32]
			-- Argument names of current routine.

	args_used: ARRAYED_LIST [BOOLEAN]
			-- Which argument has been used?

end
