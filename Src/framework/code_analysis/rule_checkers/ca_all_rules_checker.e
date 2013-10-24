note
	description: "Summary description for {CA_ALL_RULES_CHECKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_ALL_RULES_CHECKER

inherit
	AST_ITERATOR
		export
			{NONE}
				process_none_id_as,
				process_typed_char_as,
				process_agent_routine_creation_as,
				process_inline_agent_creation_as,
				process_create_creation_as,
				process_bang_creation_as,
				process_create_creation_expr_as,
				process_bang_creation_expr_as,
				process_keyword_as,
				process_symbol_as,
				process_break_as,
				process_leaf_stub_as,
				process_symbol_stub_as,
				process_keyword_stub_as,
				process_there_exists_as,
				process_for_all_as
		redefine
			process_access_id_as,
			process_assign_as,
			process_body_as,
			process_feature_as,
			process_id_as
			-- ...
		end

create
	make

feature {NONE} -- Initialization
	make
		do
			create rule_checkers.make
			last_run_successful := False
			create last_result.make
		end

feature -- Options For Execution

	add_rule_checker (a_rule_checker: CA_RULE_CHECKER)
		do
			rule_checkers.extend (a_rule_checker)
		end

	remove_all_rule_checkers
		do
			rule_checkers.wipe_out
		ensure
			rule_checkers.is_empty
		end

	clear_results
		do
			last_result.wipe_out
		end

feature -- Execution Commands

	run_on_class (a_class_to_check: CLASS_AS)
			-- Check all rules that have been added
		require
			rule_checkers_added: not rule_checkers.is_empty
		do
			across rule_checkers as l_checkers loop
				l_checkers.item.clear_results
				l_checkers.item.process_class (a_class_to_check)
			end

			process_class_as (a_class_to_check)

			across rule_checkers as l_checkers loop
				across l_checkers.item.results as l_rule_results loop
					last_result.extend (l_rule_results.item)
				end
			end
			last_run_successful := True
		ensure
			last_run_successful implies last_result /= Void
		end

feature {NONE} -- Processing

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			across rule_checkers as l_checkers loop
				l_checkers.item.process_access_id (l_as)
			end

			Precursor (l_as)
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
			across rule_checkers as l_checkers loop
				l_checkers.item.process_assignment (l_as)
			end

			Precursor (l_as)
		end

	process_body_as (l_as: BODY_AS)
		do
			across rule_checkers as l_checkers loop
				l_checkers.item.process_body (l_as)
			end

			Precursor (l_as)

			across rule_checkers as l_checkers loop
				l_checkers.item.process_body_end
			end
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			across rule_checkers as l_checkers loop
				l_checkers.item.process_feature (l_as)
			end

			Precursor (l_as)
		end

	process_id_as (l_as: ID_AS)
		do
			across rule_checkers as l_checkers loop
				l_checkers.item.process_id (l_as)
			end

			Precursor (l_as)
		end

feature -- Results

	last_run_successful: BOOLEAN

	last_result: detachable LINKED_LIST[CA_RULE_VIOLATION]

feature -- Rule Checkers

	rule_checkers: LINKED_LIST[CA_RULE_CHECKER]

invariant
	rule_checkers_list_exists: rule_checkers /= Void
end
