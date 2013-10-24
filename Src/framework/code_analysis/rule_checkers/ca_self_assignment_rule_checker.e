note
	description: "Summary description for {CA_SELF_ASSIGNMENT_RULE_CHECKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_SELF_ASSIGNMENT_RULE_CHECKER

inherit
	CA_RULE_CHECKER
		redefine
			process_assignment
		end

create
	make_with_rule

feature {NONE} -- Checking the rule
	process_assignment (a_assign_as: ASSIGN_AS)
		local
			l_violation: CA_RULE_VIOLATION
		do
			-- TODO: check; it is probably wrong!
			if attached {EXPR_CALL_AS} a_assign_as.source as l_source then
				if attached {ACCESS_ID_AS} l_source.call as l_src_access_id then
					if attached {ACCESS_ID_AS} a_assign_as.target as l_tar
					and then l_tar.feature_name.is_equal (l_src_access_id.feature_name) then
						create l_violation.make_with_rule (checked_rule)
						l_violation.set_affected_class (current_class)
						l_violation.set_location (a_assign_as.start_location)
						l_violation.set_long_description ("Variable '" + l_src_access_id.feature_name.name_8 + "' is assigned to itself...")
						results.extend (l_violation)
					end
				end
			end
		end

end
