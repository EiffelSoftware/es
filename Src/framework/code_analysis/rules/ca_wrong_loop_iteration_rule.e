note
	description: "Summary description for {CA_WRONG_LOOP_ITERATION_RULE}."
	author: "Stefan Zurfluh"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_WRONG_LOOP_ITERATION_RULE

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
			create {CA_WARNING} severity
			create violations.make
		end

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_loop_pre_action (agent process_loop)
		end

feature {NONE} -- Checking Loop For Pattern

	process_loop (a_loop: LOOP_AS)
		do
			if extract_from (a_loop) then
				if is_valid_stop_condition (a_loop.stop) then
					if attached a_loop.compound as l_comp then
						check_xxcrement (l_comp.last)
					end
				end
			end
		end

	extract_from (a_loop: LOOP_AS): BOOLEAN
		do
			Result := False

			if attached a_loop.from_part as l_from and then l_from.count = 1 then
				if attached {ASSIGN_AS} l_from.first as l_assign then
					if attached {ACCESS_ID_AS} l_assign.target as l_target and then l_target.is_local then
						if attached {INTEGER_AS} l_assign.source as l_start and then l_start.has_integer (64) then
								-- We have a from part like "j := 3". Something of the form "x := X", where
								-- x is a local variable and X is an integer constant.
							iteration_variable := l_target.feature_name
							loop_start := l_start.integer_64_value
							Result := True
						end
					end
				end
			end
		end

	is_valid_stop_condition (a_stop: EXPR_AS): BOOLEAN
		local
			l_viol: CA_RULE_VIOLATION
		do
			Result := False

			if attached {COMPARISON_AS} a_stop as l_comp then
				if attached {EXPR_CALL_AS} l_comp.left as l_call and then attached {ACCESS_ID_AS} l_call.call as l_access then
					if l_access.feature_name.is_equal (iteration_variable) then
							-- The variable that is used for initialization is compared.
						if attached {INTEGER_AS} l_comp.right as l_int and then l_int.has_integer (64) then
							Result := True -- The loop structure still follows the pattern.
							loop_end := l_int.integer_64_value
							if attached {BIN_GE_AS} l_comp or attached {BIN_GT_AS} l_comp then
									-- '>' or '>=' comparison.
									-- Check for wrong comparison symbol.
								if loop_start > loop_end then
									create l_viol.make_with_rule (Current)
									l_viol.set_location (a_stop.start_location)
									l_viol.long_description_info.extend (ca_messages.wrong_loop_iteration_violation_1)
									violations.extend (l_viol)
								end
							elseif attached {BIN_LE_AS} l_comp or attached {BIN_LT_AS} l_comp then
									-- '<' or '<=' comparison.
									-- Check for wrong comparison symbol.
								if loop_start < loop_end then
									create l_viol.make_with_rule (Current)
									l_viol.set_location (a_stop.start_location)
									l_viol.long_description_info.extend (ca_messages.wrong_loop_iteration_violation_1)
									violations.extend (l_viol)
								end
							end
						end
					end
				end
			end
		end

	check_xxcrement (a_instruction: INSTRUCTION_AS)
		local
			l_viol: CA_RULE_VIOLATION
		do
			if attached {ASSIGN_AS} a_instruction as l_assign then
				if attached {ACCESS_ID_AS} l_assign.target as l_target and then l_target.feature_name.is_equal (iteration_variable) then
					if attached {BINARY_AS} l_assign.source as l_bin then
						if attached {EXPR_CALL_AS} l_bin.left as l_call and then attached {ACCESS_ID_AS} l_call.call as l_left then
							if l_left.feature_name.is_equal (iteration_variable) then
								if attached {INTEGER_AS} l_bin.right then
										-- We have an increment of the form "x := x +/- X", where x is our iteration variable
										-- and X is an integer constant.
									if (attached {BIN_PLUS_AS} l_bin and loop_start > loop_end)
										or (attached {BIN_MINUS_AS} l_bin and loop_start < loop_end) then
											-- Wrong iteration direction.
										create l_viol.make_with_rule (Current)
										l_viol.set_location (a_instruction.start_location)
										l_viol.long_description_info.extend (ca_messages.wrong_loop_iteration_violation_2)
										violations.extend (l_viol)
									end
								end
							end
						end
					end
				end
			end
		end

	loop_start, loop_end: INTEGER_64
	iteration_variable: ID_AS

feature -- Properties

	title: STRING_32
			-- Rule title.
		do
			Result := ca_names.wrong_loop_iteration_title
		end

	description: STRING_32
			-- Rule description.
		do
			Result :=  ca_names.wrong_loop_iteration_description
		end

	id: STRING_32 = "CA092T"
			-- "T" stands for 'under test'.

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
			-- Generates a formatted rule violation description for `a_formatter' based on `a_violation'.
		do
			if attached {STRING_32} a_violation.long_description_info.first as l_msg then
				a_formatter.add (l_msg)
			end
		end

end
