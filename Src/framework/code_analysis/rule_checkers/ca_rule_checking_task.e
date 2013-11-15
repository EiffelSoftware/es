note
	description: "Summary description for {CA_VISIT_NODE_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_RULE_CHECKING_TASK

inherit
	ROTA_TIMED_TASK_I

create
	make

feature {NONE} -- Initialization

	make (a_rules_checker: CA_ALL_RULES_CHECKER; a_rules: LINKED_LIST [CA_RULE]; a_classes: LINKED_SET [CLASS_C]; a_completed_action: PROCEDURE [ANY, TUPLE []])
		do
			rules_checker := a_rules_checker
			rules := a_rules
			classes := a_classes
			completed_action := a_completed_action
			classes.start

			has_next_step := not classes.is_empty
		end

feature {NONE} -- Implementation

	rules_checker: CA_ALL_RULES_CHECKER

	rules: LINKED_LIST [CA_RULE]

	classes: LINKED_SET [CLASS_C]

	completed_action: PROCEDURE [ANY, TUPLE []]

	big_step: INTEGER

feature -- From ROTA

	sleep_time: NATURAL = 10

	has_next_step: BOOLEAN

	step
		do
			-- TODO: more elegant and performant solution?
			across rules as l_rules loop
				l_rules.item.set_checking_class (classes.item)
					-- If rule is non-standard then it will not be checked by l_rules_checker.
					-- We will have the rule check the current class here:
				if attached {CA_CFG_RULE} l_rules.item as l_cfg_rule then
					l_cfg_rule.check_class (classes.item)
				end
			end

			rules_checker.run_on_class (classes.item)

			classes.forth

			has_next_step := not classes.after

			if not has_next_step then
				completed_action.call ([])
			end
		end

	cancel
		do
			has_next_step := False
		end

	is_interface_usable: BOOLEAN = True

end
