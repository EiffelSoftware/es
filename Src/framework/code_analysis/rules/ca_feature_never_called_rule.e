note
	description: "Summary description for {CA_FEATURE_NEVER_CALLED_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_FEATURE_NEVER_CALLED_RULE

inherit
	CA_STANDARD_RULE
		redefine
			checks_library_classes, id
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			is_enabled_by_default := True
			create {CA_WARNING} severity
			create violations.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_class_pre_action (agent class_check)
		end

feature {NONE} -- Feature Visitor for Violation Check

	class_check (a_class: CLASS_AS)
		local
			l_feat: LIST [E_FEATURE]
			l_clients: ARRAYED_LIST [CLASS_C]
			has_callers: BOOLEAN
		do
			l_feat := checking_class.written_in_features
			l_clients := checking_class.clients

			from
				l_feat.start
			until
				l_feat.after
			loop
				from
					has_callers := False
					l_clients.start
				until
					has_callers or l_clients.after
				loop
					if l_feat.item.callers_32 (l_clients.item, 0) /= Void then
						has_callers := True
					end
					l_clients.forth
				end

				if not has_callers then
					create_violation (l_feat.item)
				end

				l_feat.forth
			end
		end

	create_violation (a_feature: E_FEATURE)
		local
			l_violation: CA_RULE_VIOLATION
			l_fix: CA_FEATURE_NEVER_CALLED_FIX
		do
			create l_violation.make_with_rule (Current)
			l_violation.set_location (a_feature.ast.start_location)
			l_violation.long_description_info.extend (a_feature.name_32)

			create l_fix.make_with_feature (checking_class, a_feature.ast)
			l_violation.fixes.extend (l_fix)

			violations.extend (l_violation)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.feature_never_called_title
		end

	id: STRING_32 = "CA003T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result :=  ca_names.feature_never_called_description
		end

	is_system_wide: BOOLEAN = True

	checks_library_classes: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.feature_never_called_violation_1)
			if attached {STRING_32} a_violation.long_description_info.first as l_feat_name then
				a_formatter.add_feature_name (l_feat_name, a_violation.affected_class)
			end
			a_formatter.add (ca_messages.feature_never_called_violation_2)
		end

end
