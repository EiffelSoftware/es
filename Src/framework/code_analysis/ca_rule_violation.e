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
	make_with_rule (a_rule: CA_RULE)
		do
			rule := a_rule
			long_description := ""
		end

feature
	rule: CA_RULE

	long_description: STRING

	affected_class: detachable CLASS_C

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

feature {CA_RULE}

	set_long_description (a_descr: STRING)
			-- The long description should contain information that is specific
			-- to the concrete violation. Regarding this concrete violation, it is the
			-- only text that the user is able to see; it may therefore also embody
			-- general information on the rule.
		do
			long_description := a_descr
		end

	set_affected_class (a_class: CLASS_C)
		do
			affected_class := a_class
		end

	set_location (a_location: LOCATION_AS)
		do
			location := a_location
		end

end
