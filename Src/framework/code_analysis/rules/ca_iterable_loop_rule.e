note
	description: "Summary description for {CA_ITERABLE_LOOP_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_ITERABLE_LOOP_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

	SHARED_EIFFEL_PROJECT

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
			a_checker.add_feature_pre_action (agent process_feature)
			a_checker.add_loop_pre_action (agent process_loop)
		end

feature {NONE} -- Rule checking

	iterable: CLASS_C
		once
			Result := Eiffel_universe.compiled_classes_with_name ("ITERABLE").first.compiled_class
		end

	current_feature_i: FEATURE_I

	process_feature (a_feature: FEATURE_AS)
		do
			current_feature_i := checking_class.feature_named_32 (a_feature.feature_name.name_32)
		end

	process_loop (a_loop: LOOP_AS)
		local
			l_viol: CA_RULE_VIOLATION
		do

			if matching_until_part (a_loop.stop) and then matching_from_part (a_loop.from_part) then
				if matching_last_instruction (a_loop.compound) then
					create l_viol.make_with_rule (Current)
					l_viol.set_location (a_loop.start_location)
					l_viol.long_description_info.extend (expected_var)
					violations.extend (l_viol)
				end
			end
		end

	matching_until_part (a_stop_condition: EXPR_AS): BOOLEAN
			-- Checks if `a_stop_condition' is of the form 'list.after', where list is
			-- a variable of a type that conforms to {ITERABLE}.
		local
			l_type: TYPE_A
		do
			Result := False

			if attached a_stop_condition as l_stop and then attached {EXPR_CALL_AS} l_stop as l_call then
				if attached {NESTED_AS} l_call.call as l_nested_call then
					if attached {ACCESS_AS} l_nested_call.target as l_target then
						if attached {ACCESS_AS} l_nested_call.message as l_msg and then l_msg.access_name_8.is_equal ("after") then
							l_type := node_type (l_target, current_feature_i)
							if l_type.base_class.conform_to (iterable) then
								Result := True
								expected_var := l_target.access_name_32
							end
						end
					end
				end
			end
		ensure
			expected_variable_set: Result implies attached expected_var
		end

	expected_var: detachable STRING_32

	matching_from_part (a_from: detachable EIFFEL_LIST [INSTRUCTION_AS]): BOOLEAN
		require
			expected_variable_set: attached expected_var
			-- Checks if `a_from' contains an instruction of the form `expected_var'.start.
		do
			Result := False

			if attached a_from then
				across a_from as l_instr loop
					if attached {INSTR_CALL_AS} l_instr.item as l_call then
						if attached {NESTED_AS} l_call.call as l_nested_call then
							if attached {ACCESS_AS} l_nested_call.target as l_target and then l_target.access_name_32.is_equal (expected_var) then
								if attached {ACCESS_AS} l_nested_call.message as l_msg and then l_msg.access_name_8.is_equal ("start") then
										-- We do not have to check the type of `l_target' since we know it is the expected variable
										-- that has already been checked for conformance to {ITERABLE}.
									Result := True
								end
							end
						end
					end
				end
			end
		end

	matching_last_instruction (a_loop_body: detachable EIFFEL_LIST [INSTRUCTION_AS]): BOOLEAN
		do
			Result := False

			if attached a_loop_body and then attached {INSTR_CALL_AS} a_loop_body.last as l_call then
				if attached {NESTED_AS} l_call.call as l_nested_call then
					if attached {ACCESS_AS} l_nested_call.target as l_target and then l_target.access_name_32.is_equal (expected_var) then
						if attached {ACCESS_AS} l_nested_call.message as l_msg and then l_msg.access_name_8.is_equal ("forth") then
								-- We do not have to check the type of `l_target' since we know it is the expected variable
								-- that has already been checked for conformance to {ITERABLE}.
							Result := True
						end
					end
				end
			end
		end

feature -- Properties

	title: STRING_32
			-- Rule title.
		do
			Result := ca_names.iterable_loop_title
		end

	description: STRING_32
			-- Rule description.
		do
			Result :=  ca_names.iterable_loop_description
		end

	id: STRING_32 = "CA024T"
			-- "T" stands for 'under test'.

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
			-- Generates a formatted rule violation description for `a_formatter' based on `a_violation'.
		do
			a_formatter.add (ca_messages.iterable_loop_violation_1)
			if attached {STRING_32} a_violation.long_description_info.first as l_name then
				a_formatter.add_local (l_name)
			end
			a_formatter.add (ca_messages.iterable_loop_violation_2)
		end

end
