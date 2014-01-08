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

			if classes.is_empty then
				completed_action.call ([])
			else
				create type_recorder.make
			end
		end

feature {NONE} -- Implementation

	rules_checker: CA_ALL_RULES_CHECKER

	type_recorder: CA_AST_TYPE_RECORDER

	rules: LINKED_LIST [CA_RULE]

	classes: LINKED_SET [CLASS_C]

	completed_action: PROCEDURE [ANY, TUPLE []]

	big_step: INTEGER

feature -- From ROTA

	sleep_time: NATURAL = 10

	has_next_step: BOOLEAN

	step
		do
				-- Gather type information
			type_recorder.clear
			type_recorder.analyze_class (classes.item)

				-- TODO: more elegant and performant solution?
			across rules as l_rules loop
				if l_rules.item.is_enabled.value then
					l_rules.item.set_node_types (type_recorder.node_types)
					l_rules.item.set_checking_class (classes.item)
						-- If rule is non-standard then it will not be checked by l_rules_checker.
						-- We will have the rule check the current class here:
					if attached {CA_CFG_BACKWARD_RULE} l_rules.item as l_cfg_rule then
						l_cfg_rule.check_class (classes.item)
					end
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
