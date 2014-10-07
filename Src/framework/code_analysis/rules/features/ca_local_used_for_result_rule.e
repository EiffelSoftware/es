note
	description: "[
			RULE #50: Local variable only used for Result
	
			In a function, a local variable that is never read and that is not assigned
			to any variable but the Result can be omitted. Instead the Result can be directly used.
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_LOCAL_USED_FOR_RESULT_RULE

inherit
	CA_STANDARD_RULE

	AST_ITERATOR
		redefine
			process_assign_as
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_defaults
			create all_locals.make (10)
		end

feature -- Access

	title: STRING_32
		do
			Result := ca_names.local_used_for_result_title
		end

	id: STRING_32 = "CA050"
			-- <Precursor>

	description: STRING_32
		do
			Result := ca_names.local_used_for_result_description
		end

feature {NONE} -- Implementation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_feature_pre_action (agent process_feature)
		end

	process_feature (a_feature: attached FEATURE_AS)
		do
			if
				attached a_feature.body.type
				and then attached a_feature.body.as_routine as l_routine
				and then attached l_routine.locals as l_locals
			then
				-- Get all locals.
				across l_locals as l_local_dec loop
					across l_local_dec.item.id_list as l_id loop
						all_locals.extend (l_local_dec.item.item_name (l_local_dec.item.id_list.index_of (l_id.item, 1)))
					end
				end

				checking_assigns := True
				process_routine_as (l_routine)
				checking_assigns := False
			end
		end

	all_locals: ARRAYED_LIST [STRING]

	process_assign_as (a_assign: attached ASSIGN_AS)
		do
			if
				checking_assigns
				and then attached {EXPR_CALL_AS} a_assign.source as l_expr_call
				and then attached {ACCESS_ID_AS} l_expr_call.call as l_access
				and then all_locals.has (l_access.access_name_8)
			then
				if attached {RESULT_AS} a_assign.target then
					-- TODO What happens if 2 locals are assigned to Result. Might be dangerous to fix this then.
				end
			end

			Precursor (a_assign)
		end

	checking_assigns: BOOLEAN
		-- Is the rule currently checking assign statements?

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
			a_formatter.add (ca_messages.local_used_for_result_violation_1)

			if attached {STRING_32} a_violation.long_description_info.first as l_feature_name then
				a_formatter.add (l_feature_name)
			end

			a_formatter.add (ca_messages.local_used_for_result_violation_2)
		end

end
