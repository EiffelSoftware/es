note
	description: "See `description' below."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_SHORT_CIRCUIT_IF_RULE

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
			a_checker.add_if_pre_action (agent process_if)
		end

feature {NONE} -- Rule checking

	process_if (a_if: IF_AS)
			-- Checks `a_if' for rule violations.
		local
			l_viol: CA_RULE_VIOLATION
		do
			if attached a_if.compound as l_c and then l_c.count = 1 then
				if attached {IF_AS} l_c.first as l_inner_if then
					if
						(not attached a_if.else_part) and (not attached a_if.elsif_list)
						and (not attached l_inner_if.else_part) and (not attached l_inner_if.elsif_list)
					then
							-- The Compound of the (outer) if only contains an (inner) if instruction,
							-- which is exactly what will trigger this rule.
						create l_viol.make_with_rule (Current)
						l_viol.set_location (a_if.start_location)
						violations.extend (l_viol)
					end
				end
			end
		end

feature -- Properties

	title: STRING_32
			-- Rule title.
		do
			Result := ca_names.short_circuit_if_title
		end

	description: STRING_32
			-- Rule description.
		do
			Result :=  ca_names.short_circuit_if_description
		end

	id: STRING_32 = "CA028T"
			-- "T" stands for 'under test'.

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
			-- Generates a formatted rule violation description for `a_formatter' based on `a_violation'.
		do
			a_formatter.add (ca_messages.short_circuit_if_violation)
		end

end
