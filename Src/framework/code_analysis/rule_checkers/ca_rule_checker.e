note
	description: "Summary description for {CA_RULE_CHECKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CA_RULE_CHECKER

feature {NONE} -- Initialization

	make_with_rule(a_checked_rule: CA_RULE)
		do
			checked_rule := a_checked_rule
			create results.make
		end

feature {CA_ALL_RULES_CHECKER} -- Iteration On AST Nodes

-- Although the following features might be considered to be
-- declared deferred, it would force many effective subclasses
-- to make many features effective having an empty body. Thus
-- it is much more convenient like this. Semantically it should be okay too,
-- for processing nodes by doing nothing is allowed.

	process_access_id (a_access_id_as: ACCESS_ID_AS)
		do
		end

	process_assignment (a_assign_as: ASSIGN_AS)
		do
		end

	process_feature (a_feature_as: FEATURE_AS)
		do
		end

	process_body (a_body_as: BODY_AS)
		do
		end

	process_body_end
		do
		end

	process_class (a_class_as: CLASS_AS)
		do
			current_class := a_class_as
		end

	process_id (a_id_as: ID_AS)
		do
		end

feature {CA_ALL_RULES_CHECKER} -- Info

	checked_rule: CA_RULE

	clear_results
		do
			results.wipe_out
		ensure
			results_empty: results.is_empty
		end

	results: LINKED_LIST[CA_RULE_VIOLATION]

	current_class: detachable CLASS_AS

end
