note
	description: "Summary description for {CA_UNUSED_ARGUMENT_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNUSED_ARGUMENT_RULE
inherit
	CA_RULE

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

feature -- Activation

	prepare_checking (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_feature_pre_action (agent process_feature)
			a_checker.add_body_pre_action (agent process_body)
			a_checker.add_body_post_action (agent post_process_body)
			a_checker.add_id_pre_action (agent process_id)
			violations.wipe_out
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

feature {NONE} -- Rule Checking

	process_feature (a_feature_as: FEATURE_AS)
		do
			feature_id := a_feature_as.feature_name
		end

	process_body (a_body_as: BODY_AS)
		do
			has_arguments := (a_body_as.arguments /= Void)
			if has_arguments then
				routine_body := a_body_as
				create arg_ids.make
				across a_body_as.arguments as l_args loop
					across l_args.item.id_list as l_ids loop arg_ids.extend (l_ids.item) end
				end
			end
		end

	post_process_body (a_body: BODY_AS)
		local
			l_violation: CA_RULE_VIOLATION
		do
			if has_arguments and then not arg_ids.is_empty then
				create l_violation.make_with_rule (Current)
--				l_violation.set_affected_class ()
				l_violation.set_location (routine_body.start_location)
				l_violation.set_long_description ("Routine '" + feature_id.name_8 + "' has unused arguments.")
				violations.extend (l_violation)
			end
		end

	process_id (a_id_as: ID_AS)
		local
			id, j: INTEGER
		do
			-- TODO: ignore IDs from argument declaration!
			if has_arguments then
				id := a_id_as.name_id
				-- Remove the ID from the argument list. Since it has appeared
				-- this argument does not violate the rule.
				if arg_ids.has (id) then
					j := arg_ids.index_of (id, 1)
					arg_ids.go_i_th (j)
					arg_ids.remove
				end
			end
		end

	has_arguments: BOOLEAN
	feature_id: ID_AS
	routine_body: BODY_AS
	arg_ids: LINKED_LIST[INTEGER]

end
