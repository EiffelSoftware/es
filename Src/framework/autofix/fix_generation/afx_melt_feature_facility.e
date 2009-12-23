note
	description: "Summary description for {AFX_MELT_FEATURE_FACILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_MELT_FEATURE_FACILITY

inherit
	SHARED_BYTE_CONTEXT

	SHARED_ARRAY_BYTE

	SHARED_TYPES

	SHARED_STATELESS_VISITOR
		export
			{NONE} all
		end

	SHARED_EIFFEL_PARSER
		export
			{NONE} all
		end

	EIFFEL_PARSER_WRAPPER

	REFACTORING_HELPER

feature -- Basic operations

	feature_byte_code_with_text (a_written_class: EIFFEL_CLASS_C; a_feature: FEATURE_I; a_text: STRING): TUPLE [byte_code: STRING; last_bpslot: INTEGER]
			-- String containing byte code for feature
		require
			a_written_class_attached: a_written_class /= Void
			a_feature_attached: a_feature /= Void
			a_written_class_valid: a_written_class.types.count = 1
		local
			l_feature_checker: like feature_checker
			l_context: like context
			l_byte_array: like byte_array
			l_result: detachable STRING
			l_ast_context: AST_CONTEXT
			l_body_id: INTEGER
			l_old_ast: detachable FEATURE_AS
			l_last_bpslot: INTEGER
		do
			fixme ("Coded copied from ETEST_EVALUATOR_BYTE_CODE_FACTORY, refactoring needed. 23.12.2009 Jasonw")
			if attached feature_as_with_text (a_text, a_written_class) as l_feature then
				l_body_id := a_feature.body_index
				l_old_ast := a_feature.body
				a_feature.tmp_ast_server.body_force (l_feature, l_body_id)

				l_ast_context := a_written_class.ast_context
				l_ast_context.initialize (a_written_class, a_written_class.actual_type, a_written_class.feature_table)
				l_ast_context.set_current_feature (a_feature)
				l_feature_checker := feature_checker
				l_feature_checker.init (l_ast_context)
				l_feature_checker.type_check_and_code (a_feature, True, False)
				if attached l_feature_checker.byte_code as l_byte_code then
					l_last_bpslot := l_feature_checker.break_point_slot_count
					l_context := context
					l_byte_array := byte_array
					l_context.init (a_written_class.types.first)
					l_context.set_byte_code (l_byte_code)
					l_context.set_current_feature (a_feature)
					l_context.set_workbench_mode
					l_byte_array.clear
					l_ast_context.init_byte_code (l_byte_code)
					l_byte_code.make_byte_code (l_byte_array)
					l_result := l_byte_array.melted_feature.string_representation
					l_context.clear_feature_data
					l_byte_array.clear
				else
					l_last_bpslot := 0
				end
				l_ast_context.clear_all

				if l_old_ast /= Void then
					a_feature.tmp_ast_server.body_force (l_old_ast, l_body_id)
				end
			end
			if l_result = Void then
				create l_result.make_empty
			end
			Result := [l_result, l_last_bpslot]
		ensure
			result_attached: Result /= Void
		end

feature {NONE} -- Basic operations

	feature_as_with_text (a_text: STRING; a_evaluator_class: EIFFEL_CLASS_C): detachable FEATURE_AS
			-- Create feature AST of {EQA_EVALUATOR}.execute_test for executing given test
			--
			-- `a_test': Test to be executed.
			-- `a_evaluator_class': Compiled representation of {EQA_EVALUATOR}
		local
			l_parser: like entity_feature_parser
		do
			fixme ("Coded copied from ETEST_EVALUATOR_BYTE_CODE_FACTORY, refactoring needed. 23.12.2009 Jasonw")
			l_parser := entity_feature_parser
			parse (l_parser, a_text, True, a_evaluator_class)

			if not has_error and attached {FEATURE_AS} ast_node as l_feature then
				Result := l_feature
			end
		end

end
