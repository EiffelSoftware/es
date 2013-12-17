note
	description: "Summary description for {CA_COUNT_EQUALS_ZERO_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_COUNT_EQUALS_ZERO_RULE

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
			a_checker.add_bin_eq_pre_action (agent process_equality)
		end

feature {NONE} -- Rule checking

	current_feature_i: FEATURE_I

	process_feature (a_feature: FEATURE_AS)
		do
			current_feature_i := checking_class.feature_named_32 (a_feature.feature_name.name_32)
		end

	process_equality (a_bin_eq: BIN_EQ_AS)
		local
			l_viol: CA_RULE_VIOLATION
		do
			if (is_zero (a_bin_eq.right) and then is_finite_count (a_bin_eq.left))
				or else (is_zero (a_bin_eq.left) and then is_finite_count (a_bin_eq.right)) then
				create l_viol.make_with_rule (Current)
				l_viol.set_location (a_bin_eq.start_location)
				violations.extend (l_viol)
			end
		end

	is_zero (a_expr: EXPR_AS): BOOLEAN
		do
			if attached {INTEGER_AS} a_expr as l_int then
				Result := (l_int.has_integer (32) and then l_int.integer_32_value = 0)
			end
		end

	finite: CLASS_C
		once
			Result := Eiffel_universe.compiled_classes_with_name ("FINITE").first.compiled_class
		end

	is_finite_count (a_expr: EXPR_AS): BOOLEAN
		local
			l_type: TYPE_A
		do
			if attached {EXPR_CALL_AS} a_expr as l_ec and then attached {NESTED_AS} l_ec.call as l_nested_call then
				if attached {ACCESS_AS} l_nested_call.target as l_target then
					if attached {ACCESS_AS} l_nested_call.message as l_msg and then l_msg.access_name_8.is_equal ("count") then
						l_type := node_type (l_target, current_feature_i)
						Result := l_type.base_class.conform_to (finite)
					end
				end
			end
		end

feature -- Properties

	title: STRING_32
			-- Rule title.
		do
			Result := ca_names.count_equals_zero_title
		end

	description: STRING_32
			-- Rule description.
		do
			Result :=  ca_names.count_equals_zero_description
		end

	id: STRING_32 = "CA052T"
			-- "T" stands for 'under test'.

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
			-- Generates a formatted rule violation description for `a_formatter' based on `a_violation'.
		do
			a_formatter.add (ca_messages.count_equals_zero_violation)
			a_formatter.add_feature_name ("is_empty", finite)
			a_formatter.add ("'.")
		end

end
