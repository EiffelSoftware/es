note
	description: "Summary description for {CA_UNNEEDED_OBJECT_TEST_RULE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNNEEDED_OBJECT_TEST_RULE

inherit
	CA_STANDARD_RULE
		redefine id end

create
	make

feature {NONE} -- Initialization

	make
		do
			is_enabled_by_default := True
			create {CA_SUGGESTION} severity
			create violations.make
		end

feature {NONE} -- Activation

	register_actions (a_checker: CA_ALL_RULES_CHECKER)
		do
			a_checker.add_feature_pre_action (agent process_feature)
			a_checker.add_object_test_pre_action (agent process_object_test)
		end

feature -- Properties

	title: STRING_32
		do
			Result := ca_names.unneeded_object_test_title
		end

	id: STRING_32 = "CA006T"
			-- "T" stands for 'under test'.

	description: STRING_32
		do
			Result :=  ca_names.unneeded_object_test_description
		end

	is_system_wide: BOOLEAN = False

	format_violation_description (a_violation: CA_RULE_VIOLATION; a_formatter: TEXT_FORMATTER)
		local
			l_info: LINKED_LIST [ANY]
		do
			l_info := a_violation.long_description_info

			a_formatter.add (ca_messages.unneeded_object_test_violation_1)
			if attached {STRING_32} l_info.first as l_var then
				a_formatter.add_local (l_var)
			end
			a_formatter.add (ca_messages.unneeded_object_test_violation_2)
			if attached {CLASS_C} l_info.at (2) as l_type then
				a_formatter.add_class (l_type.original_class)
			end
			a_formatter.add ("'.")
		end

feature {NONE} -- AST Visits

	current_feature_i: FEATURE_I

	process_feature (a_feature: FEATURE_AS)
		do
			current_feature_i := checking_class.feature_named_32 (a_feature.feature_name.name_32)
		end

	process_object_test (a_ot: OBJECT_TEST_AS)
		local
			l_violation: CA_RULE_VIOLATION
			l_static_variable_type: TYPE_A
			l_access: ACCESS_FEAT_AS
		do
			if attached {EXPR_CALL_AS} a_ot.expression as l_call then

				if attached {ACCESS_FEAT_AS} l_call.call as l_af then
					l_access := l_af
				elseif attached {NESTED_AS} l_call.call as l_nested then
					l_access := find_access_id (l_nested)
				end
				if l_access /= Void then
					if attached {CLASS_TYPE_AS} a_ot.type as l_type then
						l_static_variable_type := node_type (l_access, current_feature_i)
						if l_type.class_name.name_8.is_equal (l_static_variable_type.name) then
							create l_violation.make_with_rule (Current)
							l_violation.set_location (a_ot.start_location)
							l_violation.long_description_info.extend (l_access.access_name_32)
							l_violation.long_description_info.extend (l_static_variable_type.base_class)
							violations.extend (l_violation)
						end
					end
				end
			end
		end

feature {NONE} -- Helpers

	find_access_id (a_nested_call: NESTED_AS): ACCESS_FEAT_AS
		local
			l_nested: NESTED_AS
		do
				-- Follow the chain of nested calls.
			from
				l_nested := a_nested_call
			until
				not (attached {NESTED_AS} l_nested.message)
			loop
				if attached {NESTED_AS} l_nested.message as l_subnested then
					l_nested := l_subnested
				end
			end

			if attached {ACCESS_FEAT_AS} l_nested.message as l_access_id then
				Result := l_access_id
			else
				Result := Void
			end
		end

end
