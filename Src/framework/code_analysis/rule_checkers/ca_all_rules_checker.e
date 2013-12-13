note
	description: "Summary description for {CA_ALL_RULES_CHECKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CA_ALL_RULES_CHECKER

inherit

	AST_ITERATOR
		export {NONE}
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
			process_bin_eq_as,
			process_bin_ge_as,
			process_bin_gt_as,
			process_bin_le_as,
			process_bin_lt_as,
			process_body_as,
			process_case_as,
			process_create_as,
			process_creation_as,
			process_do_as,
			process_eiffel_list,
			process_elseif_as,
			process_feature_as,
			process_feature_clause_as,
			process_id_as,
			process_if_as,
			process_inspect_as,
			process_instr_call_as,
			process_loop_as,
			process_object_test_as,
			process_once_as,
			process_routine_as,
			process_un_not_as
			-- ...
		end

create
	make

feature {NONE} -- Initialization
	make
		do
			last_run_successful := False

			create_action_lists
		end

	create_action_lists
		do
			create access_id_pre_actions.make
			create access_id_post_actions.make
			create assign_pre_actions.make
			create assign_post_actions.make
			create bin_eq_pre_actions.make
			create bin_eq_post_actions.make
			create bin_ge_pre_actions.make
			create bin_ge_post_actions.make
			create bin_gt_pre_actions.make
			create bin_gt_post_actions.make
			create bin_le_pre_actions.make
			create bin_le_post_actions.make
			create bin_lt_pre_actions.make
			create bin_lt_post_actions.make
			create body_pre_actions.make
			create body_post_actions.make
			create case_pre_actions.make
			create case_post_actions.make
			create class_pre_actions.make
			create class_post_actions.make
			create create_pre_actions.make
			create create_post_actions.make
			create creation_pre_actions.make
			create creation_post_actions.make
			create do_pre_actions.make
			create do_post_actions.make
			create eiffel_list_pre_actions.make
			create eiffel_list_post_actions.make
			create elseif_pre_actions.make
			create elseif_post_actions.make
			create feature_pre_actions.make
			create feature_post_actions.make
			create feature_clause_pre_actions.make
			create feature_clause_post_actions.make
			create id_pre_actions.make
			create id_post_actions.make
			create if_pre_actions.make
			create if_post_actions.make
			create inspect_pre_actions.make
			create inspect_post_actions.make
			create instruction_call_pre_actions.make
			create instruction_call_post_actions.make
			create loop_pre_actions.make
			create loop_post_actions.make
			create object_test_pre_actions.make
			create object_test_post_actions.make
			create once_pre_actions.make
			create once_post_actions.make
			create routine_pre_actions.make
			create routine_post_actions.make
			create un_not_pre_actions.make
			create un_not_post_actions.make
		end

feature {CA_STANDARD_RULE}

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

	add_bin_eq_pre_action (a_action: PROCEDURE [ANY, TUPLE [BIN_EQ_AS]])
		do
			bin_eq_pre_actions.extend (a_action)
		end

	add_bin_eq_post_action (a_action: PROCEDURE [ANY, TUPLE [BIN_EQ_AS]])
		do
			bin_eq_post_actions.extend (a_action)
		end

	add_bin_ge_pre_action (a_action: PROCEDURE [ANY, TUPLE [BIN_GE_AS]])
		do
			bin_ge_pre_actions.extend (a_action)
		end

	add_bin_ge_post_action (a_action: PROCEDURE [ANY, TUPLE [BIN_GE_AS]])
		do
			bin_ge_post_actions.extend (a_action)
		end

	add_bin_gt_pre_action (a_action: PROCEDURE [ANY, TUPLE [BIN_GT_AS]])
		do
			bin_gt_pre_actions.extend (a_action)
		end

	add_bin_gt_post_action (a_action: PROCEDURE [ANY, TUPLE [BIN_GT_AS]])
		do
			bin_gt_post_actions.extend (a_action)
		end

	add_bin_le_pre_action (a_action: PROCEDURE [ANY, TUPLE [BIN_LE_AS]])
		do
			bin_le_pre_actions.extend (a_action)
		end

	add_bin_le_post_action (a_action: PROCEDURE [ANY, TUPLE [BIN_LE_AS]])
		do
			bin_le_post_actions.extend (a_action)
		end

	add_bin_lt_pre_action (a_action: PROCEDURE [ANY, TUPLE [BIN_LT_AS]])
		do
			bin_lt_pre_actions.extend (a_action)
		end

	add_bin_lt_post_action (a_action: PROCEDURE [ANY, TUPLE [BIN_LT_AS]])
		do
			bin_lt_post_actions.extend (a_action)
		end

	add_body_pre_action (a_action: PROCEDURE[ANY, TUPLE[BODY_AS]])
		do
			body_pre_actions.extend (a_action)
		end

	add_body_post_action (a_action: PROCEDURE[ANY, TUPLE[BODY_AS]])
		do
			body_post_actions.extend (a_action)
		end

	add_case_pre_action (a_action: PROCEDURE [ANY, TUPLE [CASE_AS]])
		do
			case_pre_actions.extend (a_action)
		end

	add_case_post_action (a_action: PROCEDURE [ANY, TUPLE [CASE_AS]])
		do
			case_post_actions.extend (a_action)
		end

	add_class_pre_action (a_action: PROCEDURE[ANY, TUPLE[CLASS_AS]])
		do
			class_pre_actions.extend (a_action)
		end

	add_class_post_action (a_action: PROCEDURE[ANY, TUPLE[CLASS_AS]])
		do
			class_post_actions.extend (a_action)
		end

	add_create_pre_action (a_action: PROCEDURE [ANY, TUPLE [CREATE_AS]])
		do
			create_pre_actions.extend (a_action)
		end

	add_create_post_action (a_action: PROCEDURE [ANY, TUPLE [CREATE_AS]])
		do
			create_post_actions.extend (a_action)
		end

	add_creation_pre_action (a_action: PROCEDURE [ANY, TUPLE [CREATION_AS]])
		do
			creation_pre_actions.extend (a_action)
		end

	add_creation_post_action (a_action: PROCEDURE [ANY, TUPLE [CREATION_AS]])
		do
			creation_post_actions.extend (a_action)
		end

	add_do_pre_action (a_action: PROCEDURE[ANY, TUPLE[DO_AS]])
		do
			do_pre_actions.extend (a_action)
		end

	add_do_post_action (a_action: PROCEDURE[ANY, TUPLE[DO_AS]])
		do
			do_post_actions.extend (a_action)
		end

	add_eiffel_list_pre_action (a_action: PROCEDURE [ANY, TUPLE [EIFFEL_LIST[AST_EIFFEL]]])
		do
			eiffel_list_pre_actions.extend (a_action)
		end

	add_eiffel_list_post_action (a_action: PROCEDURE [ANY, TUPLE [EIFFEL_LIST[AST_EIFFEL]]])
		do
			eiffel_list_post_actions.extend (a_action)
		end

	add_elseif_pre_action (a_action: PROCEDURE [ANY, TUPLE [ELSIF_AS]])
		do
			elseif_pre_actions.extend (a_action)
		end

	add_elseif_post_action (a_action: PROCEDURE [ANY, TUPLE [ELSIF_AS]])
		do
			elseif_post_actions.extend (a_action)
		end

	add_feature_pre_action (a_action: PROCEDURE [ANY, TUPLE [FEATURE_AS]])
		do
			feature_pre_actions.extend (a_action)
		end

	add_feature_post_action (a_action: PROCEDURE [ANY, TUPLE [FEATURE_AS]])
		do
			feature_post_actions.extend (a_action)
		end

	add_feature_clause_pre_action (a_action: PROCEDURE [ANY, TUPLE [FEATURE_CLAUSE_AS]])
		do
			feature_clause_pre_actions.extend (a_action)
		end

	add_feature_clause_post_action (a_action: PROCEDURE [ANY, TUPLE [FEATURE_CLAUSE_AS]])
		do
			feature_clause_post_actions.extend (a_action)
		end

	add_id_pre_action (a_action: PROCEDURE[ANY, TUPLE[ID_AS]])
		do
			id_pre_actions.extend (a_action)
		end

	add_id_post_action (a_action: PROCEDURE[ANY, TUPLE[ID_AS]])
		do
			id_post_actions.extend (a_action)
		end

	add_if_pre_action (a_action: PROCEDURE[ANY, TUPLE[IF_AS]])
		do
			if_pre_actions.extend (a_action)
		end

	add_if_post_action (a_action: PROCEDURE[ANY, TUPLE[IF_AS]])
		do
			if_post_actions.extend (a_action)
		end

	add_inspect_pre_action (a_action: PROCEDURE[ANY, TUPLE[INSPECT_AS]])
		do
			inspect_pre_actions.extend (a_action)
		end

	add_inspect_post_action (a_action: PROCEDURE[ANY, TUPLE[INSPECT_AS]])
		do
			inspect_post_actions.extend (a_action)
		end

	add_instruction_call_pre_action (a_action: PROCEDURE [ANY, TUPLE [INSTR_CALL_AS] ])
		do
			instruction_call_pre_actions.extend (a_action)
		end

	add_instruction_call_post_action (a_action: PROCEDURE [ANY, TUPLE [INSTR_CALL_AS] ])
		do
			instruction_call_post_actions.extend (a_action)
		end

	add_loop_pre_action (a_action: PROCEDURE [ANY, TUPLE [LOOP_AS]])
		do
			loop_pre_actions.extend (a_action)
		end

	add_loop_post_action (a_action: PROCEDURE [ANY, TUPLE [LOOP_AS]])
		do
			loop_post_actions.extend (a_action)
		end

	add_object_test_pre_action (a_action: PROCEDURE [ANY, TUPLE [OBJECT_TEST_AS]])
		do
			object_test_pre_actions.extend (a_action)
		end

	add_object_test_post_action (a_action: PROCEDURE [ANY, TUPLE [OBJECT_TEST_AS]])
		do
			object_test_post_actions.extend (a_action)
		end

	add_once_pre_action (a_action: PROCEDURE [ANY, TUPLE [ONCE_AS]])
		do
			once_pre_actions.extend (a_action)
		end

	add_once_post_action (a_action: PROCEDURE [ANY, TUPLE [ONCE_AS]])
		do
			once_post_actions.extend (a_action)
		end

	add_routine_pre_action (a_action: PROCEDURE [ANY, TUPLE [ROUTINE_AS]])
		do
			routine_pre_actions.extend (a_action)
		end

	add_routine_post_action (a_action: PROCEDURE [ANY, TUPLE [ROUTINE_AS]])
		do
			routine_post_actions.extend (a_action)
		end

	add_un_not_pre_action (a_action: PROCEDURE [ANY, TUPLE [UN_NOT_AS]])
		do
			un_not_pre_actions.extend (a_action)
		end

	add_un_not_post_action (a_action: PROCEDURE [ANY, TUPLE [UN_NOT_AS]])
		do
			un_not_post_actions.extend (a_action)
		end

feature {NONE} -- Agent lists

	access_id_pre_actions, access_id_post_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[ACCESS_ID_AS]]]

	assign_pre_actions, assign_post_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[ASSIGN_AS]]]

	bin_eq_pre_actions, bin_eq_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [BIN_EQ_AS]]]

	bin_ge_pre_actions, bin_ge_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [BIN_GE_AS]]]

	bin_gt_pre_actions, bin_gt_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [BIN_GT_AS]]]

	bin_le_pre_actions, bin_le_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [BIN_LE_AS]]]

	bin_lt_pre_actions, bin_lt_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [BIN_LT_AS]]]

	body_pre_actions, body_post_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[BODY_AS]]]

	case_pre_actions, case_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [CASE_AS]]]

	class_pre_actions, class_post_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[CLASS_AS]]]

	create_pre_actions, create_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [CREATE_AS]]]

	creation_pre_actions, creation_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [CREATION_AS]]]

	do_pre_actions, do_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [DO_AS]]]

	eiffel_list_pre_actions, eiffel_list_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [EIFFEL_LIST [AST_EIFFEL]]]]

	elseif_pre_actions, elseif_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [ELSIF_AS]]]

	feature_pre_actions, feature_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [FEATURE_AS]]]

	feature_clause_pre_actions, feature_clause_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [FEATURE_CLAUSE_AS]]]

	id_pre_actions, id_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [ID_AS]]]

	if_pre_actions, if_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [IF_AS]]]

	inspect_pre_actions, inspect_post_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[INSPECT_AS]]]

	instruction_call_pre_actions, instruction_call_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [INSTR_CALL_AS] ] ]

	loop_pre_actions, loop_post_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[LOOP_AS]]]

	object_test_pre_actions, object_test_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [OBJECT_TEST_AS]]]

	once_pre_actions, once_post_actions: LINKED_LIST[PROCEDURE[ANY, TUPLE[ONCE_AS]]]

	routine_pre_actions, routine_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [ROUTINE_AS]]]

	un_not_pre_actions, un_not_post_actions: LINKED_LIST [PROCEDURE [ANY, TUPLE [UN_NOT_AS]]]

feature {CA_RULE_CHECKING_TASK} -- Execution Commands

	run_on_class (a_class_to_check: CLASS_C)
			-- Check all rules that have been added.
		local
			l_ast: CLASS_AS
		do
			last_run_successful := False
			l_ast := a_class_to_check.ast
			across class_pre_actions as l_a loop l_a.item.call ([l_ast]) end
			process_class_as (l_ast)
			across class_post_actions as l_a loop l_a.item.call ([l_ast]) end
			last_run_successful := True
		end

feature {NONE} -- Processing

	process_access_id_as (a_id: ACCESS_ID_AS)
		do
			across access_id_pre_actions as l_a loop l_a.item.call ([a_id]) end
			Precursor (a_id)
			across access_id_post_actions as l_a loop l_a.item.call ([a_id]) end
		end

	process_assign_as (a_assign: ASSIGN_AS)
		do
			across assign_pre_actions as l_a loop l_a.item.call ([a_assign]) end
			Precursor (a_assign)
			across assign_post_actions as l_a loop l_a.item.call ([a_assign]) end
		end

	process_bin_eq_as (a_bin_eq: BIN_EQ_AS)
		do
			across bin_eq_pre_actions as l_a loop l_a.item.call ([a_bin_eq]) end
			Precursor (a_bin_eq)
			across bin_eq_post_actions as l_a loop l_a.item.call ([a_bin_eq]) end
		end

	process_bin_ge_as (a_bin_ge: BIN_GE_AS)
		do
			across bin_ge_pre_actions as l_a loop l_a.item.call ([a_bin_ge]) end
			Precursor (a_bin_ge)
			across bin_ge_pre_actions as l_a loop l_a.item.call ([a_bin_ge]) end
		end

	process_bin_gt_as (a_bin_gt: BIN_GT_AS)
		do
			across bin_gt_pre_actions as l_a loop l_a.item.call ([a_bin_gt]) end
			Precursor (a_bin_gt)
			across bin_gt_pre_actions as l_a loop l_a.item.call ([a_bin_gt]) end
		end

	process_bin_le_as (a_bin_le: BIN_LE_AS)
		do
			across bin_le_pre_actions as l_a loop l_a.item.call ([a_bin_le]) end
			Precursor (a_bin_le)
			across bin_le_pre_actions as l_a loop l_a.item.call ([a_bin_le]) end
		end

	process_bin_lt_as (a_bin_lt: BIN_LT_AS)
		do
			across bin_lt_pre_actions as l_a loop l_a.item.call ([a_bin_lt]) end
			Precursor (a_bin_lt)
			across bin_lt_pre_actions as l_a loop l_a.item.call ([a_bin_lt]) end
		end

	process_body_as (a_body: BODY_AS)
		do
			across body_pre_actions as l_a loop l_a.item.call ([a_body]) end
			Precursor (a_body)
			across body_post_actions as l_a loop l_a.item.call ([a_body]) end
		end

	process_case_as (a_case: CASE_AS)
		do
			across case_pre_actions as l_a loop l_a.item.call ([a_case]) end
			Precursor (a_case)
			across case_post_actions as l_a loop l_a.item.call ([a_case]) end
		end

	process_create_as (a_create: CREATE_AS)
		do
			across create_pre_actions as l_a loop l_a.item.call ([a_create]) end
			Precursor (a_create)
			across create_post_actions as l_a loop l_a.item.call ([a_create]) end
		end

	process_creation_as (a_creation: CREATION_AS)
		do
			across creation_pre_actions as l_a loop l_a.item.call ([a_creation]) end
			Precursor (a_creation)
			across creation_post_actions as l_a loop l_a.item.call ([a_creation]) end
		end

	process_do_as (a_do: DO_AS)
		do
			across do_pre_actions as l_a loop l_a.item.call ([a_do]) end
			Precursor (a_do)
			across do_post_actions as l_a loop l_a.item.call ([a_do]) end
		end

	process_eiffel_list (a_list: EIFFEL_LIST [AST_EIFFEL])
		do
			across eiffel_list_pre_actions as l_a loop l_a.item.call ([a_list]) end
			Precursor (a_list)
			across eiffel_list_post_actions as l_a loop l_a.item.call ([a_list]) end
		end

	process_elseif_as (a_elseif: ELSIF_AS)
		do
			across elseif_pre_actions as l_a loop l_a.item.call ([a_elseif]) end
			Precursor (a_elseif)
			across elseif_post_actions as l_a loop l_a.item.call ([a_elseif]) end
		end

	process_feature_as (a_feature: FEATURE_AS)
		do
			across feature_pre_actions as l_a loop l_a.item.call ([a_feature]) end
			Precursor (a_feature)
			across feature_post_actions as l_a loop l_a.item.call ([a_feature]) end
		end

	process_feature_clause_as (a_clause: FEATURE_CLAUSE_AS)
		do
			across feature_clause_pre_actions as l_a loop l_a.item.call ([a_clause]) end
			Precursor (a_clause)
			across feature_clause_post_actions as l_a loop l_a.item.call ([a_clause]) end
		end

	process_id_as (a_id: ID_AS)
		do
			across id_pre_actions as l_a loop l_a.item.call ([a_id]) end
			Precursor (a_id)
			across id_post_actions as l_a loop l_a.item.call ([a_id]) end
		end

	process_if_as (a_if: IF_AS)
		do
			across if_pre_actions as l_a loop l_a.item.call ([a_if]) end
			Precursor (a_if)
			across if_post_actions as l_a loop l_a.item.call ([a_if]) end
		end

	process_inspect_as (a_inspect: INSPECT_AS)
		do
			across inspect_pre_actions as l_a loop l_a.item.call ([a_inspect]) end
			Precursor (a_inspect)
			across inspect_post_actions as l_a loop l_a.item.call ([a_inspect]) end
		end

	process_instr_call_as (a_call: INSTR_CALL_AS)
		do
			across instruction_call_pre_actions as l_a loop l_a.item.call ([a_call]) end
			Precursor (a_call)
			across instruction_call_post_actions as l_a loop l_a.item.call ([a_call]) end
		end

	process_loop_as (a_loop: LOOP_AS)
		do
			across loop_pre_actions as l_a loop l_a.item.call ([a_loop]) end
			Precursor (a_loop)
			across loop_post_actions as l_a loop l_a.item.call ([a_loop]) end
		end

	process_object_test_as (a_ot: OBJECT_TEST_AS)
		do
			across object_test_pre_actions as l_a loop l_a.item.call ([a_ot]) end
			Precursor (a_ot)
			across object_test_post_actions as l_a loop l_a.item.call ([a_ot]) end
		end

	process_once_as (a_once: ONCE_AS)
		do
			across once_pre_actions as l_a loop l_a.item.call ([a_once]) end
			Precursor (a_once)
			across once_post_actions as l_a loop l_a.item.call ([a_once]) end
		end

	process_routine_as (a_routine: ROUTINE_AS)
		do
			across routine_pre_actions as l_a loop l_a.item.call ([a_routine]) end
			Precursor (a_routine)
			across routine_post_actions as l_a loop l_a.item.call ([a_routine]) end
		end

	process_un_not_as (a_un_not: UN_NOT_AS)
		do
			across un_not_pre_actions as l_a loop l_a.item.call ([a_un_not]) end
			Precursor (a_un_not)
			across un_not_post_actions as l_a loop l_a.item.call ([a_un_not]) end
		end

feature -- Results

	last_run_successful: BOOLEAN

feature {NONE} -- Implementation

	frozen rota: detachable ROTA_S
			-- Access to rota service
		local
			l_service_consumer: SERVICE_CONSUMER [ROTA_S]
		do
			create l_service_consumer
			if l_service_consumer.is_service_available and then l_service_consumer.service.is_interface_usable then
				Result := l_service_consumer.service
			end
		end
end
