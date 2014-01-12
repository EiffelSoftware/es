note
	description: "See `description' below."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_SELF_COMPARISON_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization.
		do
				-- set the default parameters (subject to be changed by user)
			is_enabled_by_default := True
			create {CA_WARNING} severity
			create violations.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_bin_eq_pre_action (agent process_bin_eq)
			a_checker.add_bin_ge_pre_action (agent process_bin_ge)
			a_checker.add_bin_gt_pre_action (agent process_bin_gt)
			a_checker.add_bin_le_pre_action (agent process_bin_le)
			a_checker.add_bin_lt_pre_action (agent process_bin_lt)
			a_checker.add_loop_pre_action (agent pre_process_loop)
			a_checker.add_loop_post_action (agent post_process_loop)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.self_comparison_title
		end

	id: STRING_32 = "CA071T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result :=  ca_names.self_comparison_description
		end

	is_system_wide: BOOLEAN
		once
			Result := False
		end

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		local
			l_info: LINKED_LIST [ANY]
		do
			l_info := a_violation.long_description_info
			a_formatter.add ("'")
			if l_info.count >= 1 and then attached {STRING_32} l_info.first as l_name then
				a_formatter.add_local (l_name)
			end
			a_formatter.add (ca_messages.self_comparison_violation_1)

			l_info.compare_objects
			if l_info.has ("loop_stop") then
					-- Dangerous loop stop condition.
				a_formatter.add (ca_messages.self_comparison_violation_2)
			end
		end

feature {NONE} -- Checking the rule

	in_loop: BOOLEAN
			-- Are we within a loop?

	pre_process_loop (a_loop: LOOP_AS)
			-- Checking a loop `a_loop' for self-comparisons needs more work. If the until expression
			-- is a self-comparison that does not compare for equality then the loop will
			-- not terminate, which is more severe consequence compared to other self-comparisons.
		local
			l_viol: CA_RULE_VIOLATION
		do
			if attached {BINARY_AS} a_loop.stop as l_bin and then is_self (l_bin) then
				create l_viol.make_with_rule (Current)
				l_viol.set_location (a_loop.stop.start_location)
				l_viol.long_description_info.extend (self_name)
				if not attached {BIN_EQ_AS} l_bin then
						-- It is only a dangerous loop stop condition if we do not have
						-- an equality comparison.
					l_viol.long_description_info.extend ("loop_stop")
				end
				violations.extend (l_viol)
				in_loop := True
			end
		end

	post_process_loop (a_loop: LOOP_AS)
			-- Reset the within-loop flag.
		do in_loop := False end

	process_bin_eq (a_bin_eq: BIN_EQ_AS)
		do
			process_comparison (a_bin_eq)
		end

	process_bin_ge (a_bin_ge: BIN_GE_AS)
		do
			process_comparison (a_bin_ge)
		end

	process_bin_gt (a_bin_gt: BIN_GT_AS)
		do
			process_comparison (a_bin_gt)
		end

	process_bin_le (a_bin_le: BIN_LE_AS)
		do
			process_comparison (a_bin_le)
		end

	process_bin_lt (a_bin_lt: BIN_LT_AS)
		do
			process_comparison (a_bin_lt)
		end

	process_comparison (a_comparison: BINARY_AS)
			-- Checks `a_comparison' for rule violations.
		local
			l_viol: CA_RULE_VIOLATION
		do
			if (not in_loop) and then is_self (a_comparison) then
				create l_viol.make_with_rule (Current)
				l_viol.set_location (a_comparison.start_location)
				l_viol.long_description_info.extend (self_name)
				violations.extend (l_viol)
			end
		end

	is_self (a_bin: BINARY_AS): BOOLEAN
			-- Is `a_bin' a self-comparison?
		do
			if attached {EXPR_CALL_AS} a_bin.left as l_e1 and then attached {ACCESS_ID_AS} l_e1.call as l_l then
				if attached {EXPR_CALL_AS} a_bin.right as l_e2 and then attached {ACCESS_ID_AS} l_e2.call as l_r then
					Result := l_l.feature_name.is_equal (l_r.feature_name)
					self_name := l_l.access_name_32
				end
			end
		end

	self_name: detachable STRING_32
			-- Name of the self-compared variable.

end
