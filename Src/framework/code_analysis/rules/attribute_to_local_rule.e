note
	description: "Summary description for {CA_COUNT_EQUALS_ZERO_RULE}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_ATTRIBUTE_TO_LOCAL_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			is_enabled_by_default := True
			create {CA_SUGGESTION} severity
			create violations.make
		end

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_class_pre_action (agent process_class)
		end

feature {NONE} -- Rule checking

	process_class (a_class: CLASS_AS)
		local
			l_feat: LIST [E_FEATURE]
			l_clients: ARRAYED_LIST [CLASS_C]
			l_has_clients: BOOLEAN
			l_callers: LIST [STRING_32]
		do
			l_feat := checking_class.written_in_features
			l_clients := checking_class.clients

			from
				l_feat.start
			until
				l_feat.after
			loop

					-- Only look at attributes.
				if l_feat.item.is_attribute then
					from
						l_has_clients := False
						l_clients.start
					until
						l_has_clients or l_clients.after
					loop
							-- Only look at external clients.
						if not l_clients.item.name.is_equal (checking_class.name) then
								-- `callers_32' retrieves not only callers but also assigners and creators.
							if l_feat.item.callers_32 (l_clients.item, 0) /= Void then
								l_has_clients := True
							end
						end

						l_clients.forth
					end

					if not l_has_clients then
						if attached l_feat.item.callers_32 (checking_class, 0) as l_c and then l_c.count = 1 then
							create_violation (l_feat.item, l_c.first)
						end
					end
				end

				l_feat.forth
			end
		end

	create_violation (a_attribute: E_FEATURE; a_used_in: STRING_32)
		local
			l_violation: CA_RULE_VIOLATION
		do
			create l_violation.make_with_rule (Current)
			l_violation.set_location (a_attribute.ast.start_location)
			l_violation.long_description_info.extend (a_attribute.name_32)
			l_violation.long_description_info.extend (a_used_in)
			violations.extend (l_violation)
		end

feature -- Properties

	title: STRING_32
			-- Rule title.
		do
			Result := ca_names.attribute_to_local_title
		end

	description: STRING_32
			-- Rule description.
		do
			Result :=  ca_names.attribute_to_local_description
		end

	id: STRING_32 = "CA054T"
			-- "T" stands for 'under test'.

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
			-- Generates a formatted rule violation description for `a_formatter' based on `a_violation'.
		local
			l_info: LINKED_LIST [ANY]
		do
			l_info := a_violation.long_description_info

			a_formatter.add (ca_messages.attribute_to_local_violation_1)
			if attached {STRING_32} l_info.first as l_attribute then
				a_formatter.add_feature_name (l_attribute, a_violation.affected_class)
			end
			a_formatter.add (ca_messages.attribute_to_local_violation_2)
			if attached {STRING_32} l_info.at (2) as l_used_in then
				a_formatter.add_feature_name (l_used_in, a_violation.affected_class)
			end
			a_formatter.add (ca_messages.attribute_to_local_violation_3)
		end

end
