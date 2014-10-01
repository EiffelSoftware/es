note
	description: "[
			RULE #45: Comparison of {REAL}.nan
	
			To check whether a REAL object is "NaN" (not a number) a comparison
			using the '=' symbol does not yield the intended result. Instead one
			must use the query {REAL}.is_nan.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_REAL_NAN_COMPARISON_RULE

inherit
	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_defaults
		end

feature -- Access

	title: STRING_32
		do
			Result := ca_names.real_nan_comparison_title
		end

	id: STRING_32 = "CA045"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.real_nan_comparison_description
		end

feature {NONE} -- Implementation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_bin_eq_pre_action (agent process_bin_eq)
		end

	process_bin_eq (a_bin: attached BIN_EQ_AS)
		do
			do_nothing
		end

	create_violation (a_ot: attached OBJECT_TEST_AS)
		local
			l_violation: CA_RULE_VIOLATION
--			l_fix: CA_OBJECT_TEST_FAILING_FIX TODO Implement.
		do
			create l_violation.make_with_rule (Current)

			l_violation.set_location (a_ot.start_location)

			if attached {ACCESS_ID_AS} a_ot.expression as l_expr then
				l_violation.long_description_info.extend (l_expr.access_name_32)
			end

--			create l_fix.make
--			l_violation.fixes.extend (l_fix)

			violations.extend (l_violation)
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.object_test_failing_violation_1)

			if attached {STRING_32} a_violation.long_description_info.first as l_feature_name then
				a_formatter.add (l_feature_name)
			end

			a_formatter.add (ca_messages.object_test_failing_violation_2)
		end

end
