note
	description: "Summary description for {CA_CREATION_PROC_EXPORTED_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_CREATION_PROC_EXPORTED_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

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

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_create_pre_action (agent process_create)
			a_checker.add_feature_clause_pre_action (agent process_feature_clause)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.creation_proc_exported_title
		end

	id: STRING_32 = "CA013T"
		-- 'T' stands for 'under test'.

	description: STRING_32
		do
			Result := ca_names.creation_proc_exported_description
		end

	is_system_wide: BOOLEAN = True

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.creation_proc_exported_violation_1)
			if attached {STRING_32} a_violation.long_description_info.first as l_feature_name then
				a_formatter.add_feature_name (l_feature_name, a_violation.affected_class)
			end
			a_formatter.add (ca_messages.creation_proc_exported_violation_2)
		end

feature {NONE} -- AST Visitor

	process_create (a_create: CREATE_AS)
		do
			creation_procedures := a_create.feature_list
		end

	process_feature_clause (a_clause: FEATURE_CLAUSE_AS)
		local
			l_feature: FEATURE_AS
			l_exported: BOOLEAN
			l_viol: CA_RULE_VIOLATION
		do
			across creation_procedures as l_cp loop
				l_feature := a_clause.feature_with_name (l_cp.item.internal_name.name_id)
				if l_feature /= Void then
					if attached a_clause.clients as l_clients then
						across l_clients.clients as l_class_list loop
							if not l_class_list.item.name_32.is_equal ("NONE") then
									-- The feature is exported to something.
								l_exported := True
							end
						end
					else
							-- No clients are defined. It means that the feature is exported to {ANY}.
						l_exported := True
					end

					if l_exported then
						create l_viol.make_with_rule (Current)
						l_viol.set_location (a_clause.start_location)
						l_viol.long_description_info.extend (l_feature.feature_name.name_32)
						violations.extend (l_viol)
					end
				end
			end
		end

	creation_procedures: EIFFEL_LIST [FEATURE_NAME]

end
