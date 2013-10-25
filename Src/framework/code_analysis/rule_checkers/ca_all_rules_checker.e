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
--			create rule_checkers.make
			last_run_successful := False
--			create last_result.make (100) -- TODO: check initial capacity

			create_action_lists
		end

	create_action_lists
		do
			create access_id_pre_actions.make
			create access_id_post_actions.make
			create assign_pre_actions.make
			create assign_post_actions.make
			create body_pre_actions.make
			create body_post_actions.make
			create class_pre_actions.make
			create class_post_actions.make
			create feature_pre_actions.make
			create feature_post_actions.make
			create id_pre_actions.make
			create id_post_actions.make
		end

feature -- Options For Execution

--	add_rule_checker (a_rule_checker: CA_RULE_CHECKER)
--		do
--			rule_checkers.extend (a_rule_checker)
--		end

--	remove_all_rule_checkers
--		do
--			rule_checkers.wipe_out
--		ensure
--			rule_checkers.is_empty
--		end

feature {CA_RULE}

	add_access_id_pre_action (a_action: PROCEDURE[ANY, TUPLE[ACCESS_ID_AS]])
		do
			access_id_pre_actions.extend (a_action)
		end

	add_access_id_post_action (a_action: PROCEDURE[ANY, TUPLE[ACCESS_ID_AS]])
		do
			access_id_post_actions.extend (a_action)
		end

	add_assign_pre_action (a_action: PROCEDURE[ANY, TUPLE[ASSIGN_AS]])
		do
			assign_pre_actions.extend (a_action)
		end

	add_assign_post_action (a_action: PROCEDURE[ANY, TUPLE[ASSIGN_AS]])
		do
			assign_post_actions.extend (a_action)
		end

	add_body_pre_action (a_action: PROCEDURE[ANY, TUPLE[BODY_AS]])
		do
			body_pre_actions.extend (a_action)
		end

	add_body_post_action (a_action: PROCEDURE[ANY, TUPLE[BODY_AS]])
		do
			body_post_actions.extend (a_action)
		end

	add_class_pre_action (a_action: PROCEDURE[ANY, TUPLE[CLASS_AS]])
		do
			class_pre_actions.extend (a_action)
		end

	add_class_post_action (a_action: PROCEDURE[ANY, TUPLE[CLASS_AS]])
		do
			class_post_actions.extend (a_action)
		end

	add_feature_pre_action (a_action: PROCEDURE[ANY, TUPLE[FEATURE_AS]])
		do
			feature_pre_actions.extend (a_action)
		end

	add_feature_post_action (a_action: PROCEDURE[ANY, TUPLE[FEATURE_AS]])
		do
			feature_post_actions.extend (a_action)
		end

	add_id_pre_action (a_action: PROCEDURE[ANY, TUPLE[ID_AS]])
		do
			id_pre_actions.extend (a_action)
		end

	add_id_post_action (a_action: PROCEDURE[ANY, TUPLE[ID_AS]])
		do
			id_post_actions.extend (a_action)
		end

feature {NONE} -- Agent lists

	access_id_pre_actions, access_id_post_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[ACCESS_ID_AS]]]

	assign_pre_actions, assign_post_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[ASSIGN_AS]]]

	body_pre_actions, body_post_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[BODY_AS]]]

	class_pre_actions, class_post_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[CLASS_AS]]]

	feature_pre_actions, feature_post_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[FEATURE_AS]]]

	id_pre_actions, id_post_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[ID_AS]]]

feature -- Execution Commands

	run_on_class (a_class_to_check: CLASS_C)
			-- Check all rules that have been added
		local
			l_ast: CLASS_AS
		do
--			across rule_checkers as l_checkers loop
--				l_checkers.item.clear_results
--				l_checkers.item.process_class (a_class_to_check)
--			end
			l_ast := a_class_to_check.ast
			across class_pre_actions as l_a loop l_a.item.call ([l_ast]) end
			process_class_as (l_ast)
			across class_post_actions as l_a loop l_a.item.call ([l_ast]) end
--			across rule_checkers as l_checkers loop
--				across l_checkers.item.results as l_rule_results loop
--					last_result.extend (l_rule_results.item)
--				end
--			end
			last_run_successful := True
		end

feature {NONE} -- Processing

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
--			across rule_checkers as l_checkers loop
--				l_checkers.item.process_access_id (l_as)
--			end
			across access_id_pre_actions as l_a loop l_a.item.call ([l_as]) end

			Precursor (l_as)

			across access_id_post_actions as l_a loop l_a.item.call ([l_as]) end
		end

	process_assign_as (l_as: ASSIGN_AS)
		do
--			across rule_checkers as l_checkers loop
--				l_checkers.item.process_assignment (l_as)
--			end
			across assign_pre_actions as l_a loop l_a.item.call ([l_as]) end

			Precursor (l_as)

			across assign_post_actions as l_a loop l_a.item.call ([l_as]) end
		end

	process_body_as (l_as: BODY_AS)
		do
--			across rule_checkers as l_checkers loop
--				l_checkers.item.process_body (l_as)
--			end
			across body_pre_actions as l_a loop l_a.item.call ([l_as]) end

			Precursor (l_as)

			across body_post_actions as l_a loop l_a.item.call ([l_as]) end
--			across rule_checkers as l_checkers loop
--				l_checkers.item.process_body_end
--			end
		end

	process_feature_as (l_as: FEATURE_AS)
		do
--			across rule_checkers as l_checkers loop
--				l_checkers.item.process_feature (l_as)
--			end
			across feature_pre_actions as l_a loop l_a.item.call ([l_as]) end

			Precursor (l_as)

			across feature_post_actions as l_a loop l_a.item.call ([l_as]) end
		end

	process_id_as (l_as: ID_AS)
		do
--			across rule_checkers as l_checkers loop
--				l_checkers.item.process_id (l_as)
--			end
			across id_pre_actions as l_a loop l_a.item.call ([l_as]) end

			Precursor (l_as)

			across id_post_actions as l_a loop l_a.item.call ([l_as]) end
		end

feature -- Results

	last_run_successful: BOOLEAN

--	last_result: HASH_TABLE[LINKED_LIST[CA_RULE_VIOLATION], CLASS_C]

feature -- Rule Checkers

--	rule_checkers: LINKED_LIST[CA_RULE_CHECKER]

--invariant
--	rule_checkers_list_exists: rule_checkers /= Void
end
