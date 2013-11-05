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
			end


feature -- Properties

	title: STRING
		once
			Result := "---"
		end

	description: STRING
		once
			Result :=  "---"
		end

	options: LINKED_LIST[CA_RULE_OPTION]
		once
			create Result.make
		end


	is_system_wide: BOOLEAN
		once
			Result := False
		end

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		do

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
				l_violation.set_affected_class (checking_class)
				check attached current_feature end
				l_violation.set_location (current_feature.start_location)
				l_violation.long_description_info.extend (current_feature)
				l_violation.long_description_info.extend (l_npath)
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
