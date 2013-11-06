note
	description: "Summary description for {CA_RULE_VIOLATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_RULE_VIOLATION

inherit
	COMPARABLE

create
	make_with_rule

feature {NONE} -- Initialization
	make_with_rule (a_rule: CA_STANDARD_RULE)
		do
			rule := a_rule
			-- This is just the default. The rule may set the affected class otherwise
			-- if needed.
			affected_class := a_rule.checking_class
			synchronized_with_source := True
			create {LINKED_LIST[ANY]} long_description_info.make
		end

feature
	rule: CA_STANDARD_RULE

	long_description_info: LINKED_LIST[ANY]

	format_violation_description (a_formatter: TEXT_FORMATTER)
		do
			-- Just delegate to rule. The rule knows about its violations.
			rule.format_violation_description (Current, a_formatter)
		end

	affected_class: detachable CLASS_C

	synchronized_with_source: BOOLEAN
			-- 'True' if the rule violation corresponds to the current state of the
			-- source code; 'False' if the violation might be outdated or is outdated.

	location: detachable LOCATION_AS
			-- location of rule violation, if available

	fixes: LINKED_LIST[CA_FIX]
			-- fix "strategies"
			-- Empty if there is no fix available for this rule violation

feature -- Inherited from {COMPARABLE}

	is_less alias "<" (a_other: like Current): BOOLEAN
		do
			if attached location as l_location then
				if attached a_other.location as l_other_location then
					if l_location.line = l_other_location.line then
						Result := (l_location.column < l_other_location.column)
					else
						Result := (l_location.line < l_other_location.line)
					end
				else
					Result := False
				end
			else
				Result := False
			end
		end

feature {CA_STANDARD_RULE}

	set_affected_class (a_class: CLASS_C)
			-- Sets the class that this violations refers to to 'a_class'. This is only
			-- needed when 'a_class' differs from '{CA_RULE}.checking_class' of the rule at
			-- the time this violation is created. (See 'make_with_rule'.)
		do
			affected_class := a_class
		end

	set_location (a_location: LOCATION_AS)
		do
			location := a_location
		end

end
