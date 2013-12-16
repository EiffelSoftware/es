note
	description: "Summary description for {CA_IF_ELSE_NOT_EQUAL_RULE}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_IF_ELSE_NOT_EQUAL_RULE

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
		local
			l_viol: CA_RULE_VIOLATION
		do
				-- Only look at if-else instructions. (Whether there exists an 'elseif' is
				-- not relevant to this rule.)
			if attached a_if.else_part then
				if attached {BIN_NE_AS} a_if.condition as l_c and then (not attached {VOID_AS} l_c.right) then
						-- The if condition is of the form 'a /= b' or 'a /~ b'. Comparing to Void, however, is ignored
						-- for the sake of intuition: "if c /= Void then" is preferrable (note: the 'attached' syntax
						-- will not be discussed here and is not part of this rule).
					create l_viol.make_with_rule (Current)
					l_viol.set_location (l_c.start_location)
					violations.extend (l_viol)
				end
			end
		end

feature -- Properties

	title: STRING_32
			-- Rule title.
		do
			Result := ca_names.if_else_not_equal_title
		end

	description: STRING_32
			-- Rule description.
		do
			Result :=  ca_names.if_else_not_equal_description
		end

	id: STRING_32 = "CA046T"
			-- "T" stands for 'under test'.

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
			-- Generates a formatted rule violation description for `a_formatter' based on `a_violation'.
		do
			a_formatter.add (ca_messages.if_else_not_equal_violation)
		end

end
