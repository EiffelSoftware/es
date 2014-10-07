note
	description: "[
			RULE #7: Object test always failing
	
			An object test will always fail if the type that the variable is tested
			for does not conform to any type that conforms to the static type of the
			tested variable. The whole if block will therefore never be executed and
			it is redundant.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_OBJECT_TEST_FAILING_RULE

inherit
	CA_STANDARD_RULE
		rename
			make_with_defaults as make
		end

create
	make

feature -- Access

	title: STRING_32
		do
			Result := ca_names.object_test_failing_title
		end

	id: STRING_32 = "CA007"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.object_test_failing_description
		end

feature {NONE} -- Implementation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_if_pre_action (agent process_if)
			a_checker.add_feature_pre_action (agent process_feature)
		end

	process_feature (a_feature: attached FEATURE_AS)
			-- Sets the current feature.
		do
			current_feature := current_context.checking_class.feature_named_32 (a_feature.feature_names.first.visual_name_32)
		end

	process_if (a_if: attached IF_AS)
		local
			l_type_1, l_type_2: TYPE_A
		do
			if attached {OBJECT_TEST_AS} a_if.condition as l_ot then
				 l_type_1 := current_context.node_type (l_ot.expression, current_feature)
				 l_type_2 := current_context.node_type (l_ot.type, current_feature)

				 if not has_common_child (l_type_1, l_type_2) then
				 	create_violation (l_ot)
				 end
			end
		end

	has_common_child (a_t1, a_t2: attached TYPE_A): BOOLEAN
			-- Is there a class that conforms to both `a_t1' and `a_t2'?
		do
			across system.classes as l_class loop
--				if l_class.item.actual_type.conform_to (a_context_class: CLASS_C, other: TYPE_A) then
--					-- TODO Implement. Awaiting answers from Tschannen.
--				end
			end
		end

	current_feature: FEATURE_I

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
