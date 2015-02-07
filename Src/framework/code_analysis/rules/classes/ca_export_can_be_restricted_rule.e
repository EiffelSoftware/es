note
	description: "[
			RULE #75: Feature export can be restricted
	
			An exported feature that is used only in unqualified calls may be changed to secret.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_EXPORT_CAN_BE_RESTRICTED_RULE

inherit
	CA_STANDARD_RULE

create
	make

feature -- Initialization

	make
		do
			make_with_defaults
			checks_library_classes := False
		end

feature -- Access

	title: STRING_32
		do
			Result := ca_names.export_can_be_restricted_title
		end

	id: STRING_32 = "CA075"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.export_can_be_restricted_description
		end

feature {NONE} -- Implementation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_class_pre_action (agent class_check)
		end

	class_check (a_class: CLASS_AS)
			-- Checks `a_class' for features that are exported but never called in a qualified way.
		local
			l_clients: ARRAYED_LIST [CLASS_C]
			has_callers: BOOLEAN
		do
			l_clients := current_context.checking_class.clients

			across
				current_context.checking_class.written_in_features as l_feat
			loop
					-- Only check features that are exported
				if not l_feat.item.export_status.is_none then
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
						--create_violation (l_feat.item)
					end
				end
			end
		end

	create_violation (a_feature: attached FEATURE_AS)
		local
			l_violation: CA_RULE_VIOLATION
			l_fix: CA_EXPORT_CAN_BE_RESTRICTED_FIX
		do
			create l_violation.make_with_rule (Current)

			l_violation.set_location (a_feature.start_location)

			l_violation.fixes.extend (l_fix)

			violations.extend (l_violation)
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.local_used_for_result_violation_1)

			if attached {STRING_32} a_violation.long_description_info.first as l_feature_name then
				a_formatter.add (l_feature_name)
			end

			a_formatter.add (ca_messages.local_used_for_result_violation_2)
		end

end
