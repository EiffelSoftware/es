note
	description: "Summary description for {CA_NPATH_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_NPATH_RULE

inherit
	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make
		do
			is_enabled := True
			create {CA_WARNING} severity
			create violations.make
			create {LINKED_STACK[INTEGER]} npath_stack.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_feature_pre_action (agent process_feature)
			a_checker.add_do_pre_action (agent pre_process_do)
			a_checker.add_do_post_action (agent post_process_do)
			a_checker.add_once_pre_action (agent pre_process_once)
			a_checker.add_once_post_action (agent post_process_once)
			a_checker.add_if_pre_action (agent pre_process_if)
			a_checker.add_if_post_action (agent post_process_if)
			a_checker.add_loop_pre_action (agent pre_process_loop)
			a_checker.add_loop_post_action (agent post_process_loop)
			a_checker.add_inspect_pre_action (agent pre_process_inspect)
			a_checker.add_inspect_post_action (agent post_process_inspect)
		end


feature -- Properties

	title: STRING
		do
			Result := ca_names.npath_title
		end

	description: STRING
		do
			Result :=  ca_names.npath_description
		end

	options: LINKED_LIST[CA_RULE_OPTION[ANY]]
		local
			l_threshold: CA_RULE_OPTION[INTEGER]
		once
			create l_threshold.make_with_caption (ca_names.npath_threshold_option)
			l_threshold.set_valid_choice_agent (agent is_threshold_within_bounds)

			create Result.make
			Result.extend (l_threshold)
		end


	is_system_wide: BOOLEAN
		once
			Result := False
		end

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		local
			l_info: LINKED_LIST[ANY]
		do
			l_info := a_violation.long_description_info
			a_formatter.add_string (ca_messages.npath_violation_1)
			if attached {FEATURE_AS} l_info.first as l_feat then
				a_formatter.add_feature_name (l_feat.feature_name.name_32, a_violation.affected_class)
			end
			a_formatter.add_string (ca_messages.npath_violation_2)
			if attached {INTEGER} l_info.at (2) as l_npath then
				a_formatter.add_int (l_npath)
			end
			a_formatter.add_string (ca_messages.npath_violation_3)
			if attached {INTEGER} l_info.at (3) as l_max then
				a_formatter.add_int (l_max)
			end
			a_formatter.add_char ('.')
		end

feature {NONE} -- Options

	is_threshold_within_bounds (a_threshold: INTEGER): BOOLEAN
		do
			Result := a_threshold >= 10 and a_threshold <= 10000
		end

feature {NONE} -- Rule Checking

	npath_stack: STACK[INTEGER]

	process_feature (a_feature_as: FEATURE_AS)
		do
			current_feature := a_feature_as
		end

	pre_process_do (a_do: DO_AS)
		do
			prepare_routine
		end
	post_process_do (a_do: DO_AS)
		do
			evaluate_routine
		end
	pre_process_once (a_once: ONCE_AS)
		do
			prepare_routine
		end
	post_process_once (a_once: ONCE_AS)
		do
			evaluate_routine
		end

	prepare_routine
		do
			npath_stack.wipe_out
			npath_stack.put (1)
		end

	evaluate_routine
		local
			l_violation: CA_RULE_VIOLATION
			l_npath: INTEGER
		do
			check npath_stack.count = 1 end
			l_npath := npath_stack.item
			-- TODO: replace 200 by option
			if l_npath > 200 then
				create l_violation.make_with_rule (Current)
				check attached current_feature end
				l_violation.set_location (current_feature.start_location)
				l_violation.long_description_info.extend (current_feature)
				l_violation.long_description_info.extend (l_npath)
				l_violation.long_description_info.extend (200) -- TODO: replace by option
			end
		end

	pre_process_if (a_if: IF_AS)
		do
			npath_stack.put (1)
		end

	post_process_if (a_if: IF_AS)
		local
			inner_npath, outer_npath: INTEGER
		do
			inner_npath := npath_stack.item + 1
			npath_stack.remove
			outer_npath := npath_stack.item
			npath_stack.replace (inner_npath * outer_npath)
		end

	pre_process_loop (a_loop: LOOP_AS)
		do
			npath_stack.put (1)
		end

	post_process_loop (a_loop: LOOP_AS)
		local
			inner_npath, outer_npath: INTEGER
		do
			inner_npath := npath_stack.item + 1
			npath_stack.remove
			outer_npath := npath_stack.item
			npath_stack.replace (inner_npath * outer_npath)
		end

	pre_process_inspect (a_inspect: INSPECT_AS)
		do
			npath_stack.put (1)
		end

	post_process_inspect (a_inspect: INSPECT_AS)
		local
			inner_npath, outer_npath: INTEGER
		do
			inner_npath := npath_stack.item + 1
			npath_stack.remove
			outer_npath := npath_stack.item
			npath_stack.replace (inner_npath * outer_npath)
		end

	process_and_then (a_and_then: BIN_AND_THEN_AS)
		do

		end

	process_or_else (a_or_else: BIN_OR_ELSE_AS)
		do

		end

	current_feature: detachable FEATURE_AS

end
