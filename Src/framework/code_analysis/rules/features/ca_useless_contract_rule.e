note
	description: "[
			RULE #9: Useless contract with void-safety
	
			If a certain variable is declared as attached, either explicitly or by
			the project setting "Are types attached by default?" then a contract
			declaring this variable not to be void is useless. This rule only applies
			if the project setting for Void safety is set to "Complete" (?).
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_USELESS_CONTRACT_RULE

inherit
	CA_STANDARD_RULE

	AST_ITERATOR
		redefine
			process_bin_ne_as
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_defaults
			project_setting_void_safety := "Complete" -- TODO: Find the actual setting and load it here or later.
			create void_checked_arguments.make
		end

feature -- Access

	title: STRING_32
		do
			Result := ca_names.useless_contract_title
		end

	id: STRING_32 = "CA009"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.useless_contract_description
		end

feature {NONE} -- Implementation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_feature_pre_action (agent pre_process_feature)
			a_checker.add_feature_post_action (agent post_process_feature)
		end

	post_process_feature (a_feature: attached FEATURE_AS)
		do
			-- Clean up for the next feature.
			void_checked_arguments.wipe_out
		end

	pre_process_feature (a_feature: attached FEATURE_AS)
		do
			if project_setting_void_safety.is_equal ("Complete") then
				if
					attached {ROUTINE_AS} a_feature.body.content as l_routine
					and then attached {REQUIRE_AS} l_routine.precondition as l_precondition
				then
					checking_tagged := True
					l_precondition.process (Current)
					checking_tagged := False
				end

				if attached a_feature.body.arguments as l_args then
					across l_args as l_arg loop
						if l_arg.item.type.has_attached_mark then
							across l_arg.item.id_list as l_id loop
								if void_checked_arguments.has (l_id.item) then
									create_violation(a_feature)
								end
							end
						end
					end
				end
			end
		end

	process_bin_ne_as (l_bin: BIN_NE_AS)
		do
			if checking_tagged then
				if
					attached {VOID_AS} l_bin.right
					and then attached {EXPR_CALL_AS} l_bin.left as l_expr_call
					and then attached {ACCESS_ASSERT_AS} l_expr_call.call as l_access_assert
					and then attached {ID_AS} l_access_assert.feature_name as l_id
				then
					void_checked_arguments.extend(l_id.index)
				end
			end

			Precursor (l_bin)
		end

	create_violation (a_feature: attached FEATURE_AS)
		local
			l_violation: CA_RULE_VIOLATION
			--l_fix: CA_USELESS_CONTRACT_FIX TODO Implement.
		do
			create l_violation.make_with_rule (Current)
			if attached {ROUTINE_AS} a_feature.body.content as l_rout then
				l_violation.set_location (l_rout.precondition.start_location)
			else
				l_violation.set_location (a_feature.start_location)
			end

			l_violation.long_description_info.extend (a_feature.feature_names.first)

--			create l_fix.make
--			l_violation.fixes.extend (l_fix)

			violations.extend (l_violation)
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			a_formatter.add (ca_messages.useless_contract_violation_1)

			if attached {STRING_32} a_violation.long_description_info.first as l_feature_name then
				a_formatter.add (l_feature_name)
			end

			a_formatter.add (ca_messages.useless_contract_violation_2)
		end

	checking_tagged: BOOLEAN
		-- Are we checking tagged_as right now?

	void_checked_arguments: LINKED_LIST[INTEGER]

	project_setting_void_safety: STRING -- TODO: Find the actual setting.

end
