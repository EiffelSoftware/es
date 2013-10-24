note
	description: "Summary description for {CA_RULE_VIOLATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_RULE_VIOLATION

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

	affected_class: detachable CLASS_AS

	location: detachable LOCATION_AS
			-- location of rule violation, if available

	fixes: LINKED_LIST[CA_FIX]
			-- fix "strategies"
			-- Empty if there is no fix available for this rule violation

feature {CA_RULE_CHECKER}

	set_long_description (a_descr: STRING)
			-- The long description should contain information that is specific
			-- to the concrete violation. Regarding this concrete violation, it is the
			-- only text that the user is able to see; it may therefore also embody
			-- general information on the rule.
		do
			long_description := a_descr
		end

	set_affected_class (a_class: CLASS_AS)
		do
			affected_class := a_class
		end

	set_location (a_location: LOCATION_AS)
		do
			location := a_location
		end

end
