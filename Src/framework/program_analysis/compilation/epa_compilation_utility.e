note
	description: "Compilation related utilities"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_COMPILATION_UTILITY

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

	SHARED_EIFFEL_PARSER_WRAPPER

	REFACTORING_HELPER

	INTERNAL_COMPILER_STRING_EXPORTER

feature -- Access

	epa_feature_checker: EPA_FEATURE_CHECKER_GENERATOR
			-- Visitor to check code of a routine
		once
			create Result
		ensure
			feature_checker_not_void: Result /= Void
		end

feature -- Basic operations

	compile_project (a_eiffel_project: E_PROJECT; a_c_compilaiton: BOOLEAN)
			-- Compile `a_eiffel_project' when needed.
			-- `a_c_compilation' indicates if C compiler is to be launched.
		do
			a_eiffel_project.quick_melt (True, True, True)
			a_eiffel_project.freeze
			if a_c_compilaiton then
				a_eiffel_project.call_finish_freezing_and_wait (True)
			end
		end

	feature_byte_code_with_text (a_written_class: EIFFEL_CLASS_C; a_feature: FEATURE_I; a_text: STRING; a_ignore_export: BOOLEAN): TUPLE [byte_code: STRING; last_bpslot: INTEGER]
			-- String containing byte code for feature
			-- `byte_code' is the string representation for the byte-code.
			-- `last_bpslot' is the last break point slot of the feature.
			-- `a_ignore_export' indicates if feature call visibility is ignored.
		require
			a_written_class_attached: a_written_class /= Void
			a_feature_attached: a_feature /= Void
--			a_written_class_valid: a_written_class.types.count = 1
		local
			l_feature_checker: like epa_feature_checker
			l_context: like context
			l_byte_array: like byte_array
			l_result: detachable STRING
			l_ast_context: AST_CONTEXT
			l_body_id: INTEGER
			l_old_ast: detachable FEATURE_AS
			l_last_bpslot: INTEGER
			l_cursor: CURSOR
			l_type: detachable CLASS_TYPE
			l_tmp_server: TMP_AST_SERVER
			l_locals: HASH_TABLE [LOCAL_INFO, INTEGER]
		do
			fixme ("Code adapted from ETEST_EVALUATOR_BYTE_CODE_FACTORY, refactoring needed. 23.12.2009 Jasonw")
			if attached feature_as_with_text (a_text, a_written_class) as l_feature then
				l_tmp_server := a_feature.tmp_ast_server
				if l_tmp_server.has (a_written_class.class_id) or else l_tmp_server.system.ast_server.has (a_written_class.class_id) then
					l_tmp_server.load (a_written_class)
				end

				l_body_id := a_feature.body_index
				l_old_ast := a_feature.body
				a_feature.tmp_ast_server.body_force (a_written_class.class_id, l_feature, l_body_id)

				l_ast_context := a_written_class.ast_context
				l_ast_context.clear_feature_context
				l_ast_context.initialize (a_written_class, a_written_class.actual_type)
--				l_ast_context.initialize (a_written_class, a_written_class.actual_type, a_written_class.feature_table)
				l_ast_context.set_current_feature (a_feature)
				l_ast_context.set_written_class (a_written_class)
				l_ast_context.set_is_ignoring_export (a_ignore_export)
				l_feature_checker := epa_feature_checker
				l_feature_checker.error_handler.wipe_out
				l_feature_checker.init (l_ast_context)
				l_feature_checker.type_check_and_code (a_feature, True, False)

				if attached {ROUTINE_AS} a_feature.e_feature.ast.body.content as l_routine
						-- Fixme: Without the following condition, call to check_locals might fail in certain cases. Jan-7-2011, Max
					and then l_routine.locals /= Void
				then
					l_feature_checker.context.clear_local_context
					l_feature_checker.check_locals (l_routine)
					l_locals := l_feature_checker.context.locals.twin
				else
					create l_locals.make (0)
				end
				if l_feature_checker.error_handler.error_list.count = 0 and then attached l_feature_checker.byte_code as l_byte_code then
					l_last_bpslot := l_feature_checker.break_point_slot_count
					l_context := context
					l_byte_array := byte_array
					if a_written_class.types.count > 1 then
						fixme ("In case of a generic class, use the reference derivation, which won't be correct sometimes. 25.1.2010 Jasonw")
						l_cursor := a_written_class.types.cursor
						from
							a_written_class.types.start
						until
							a_written_class.types.after or l_type /= Void
						loop
							if a_written_class.types.item.is_reference then
								l_type := a_written_class.types.item
							end
							a_written_class.types.forth
						end
						if l_type = Void then
							l_type := a_written_class.types.first
						end
						a_written_class.types.go_to (l_cursor)
					else
						l_type := a_written_class.types.first
					end
					l_context.init (l_type)
					l_context.set_byte_code (l_byte_code)
					l_context.set_current_feature (a_feature)
					l_context.set_workbench_mode
					l_byte_array.clear
					l_ast_context.set_locals (l_locals)
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
					a_feature.tmp_ast_server.body_force (a_written_class.class_id, l_old_ast, l_body_id)
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
			l_parser.set_syntax_version (l_parser.Provisional_syntax)
			eiffel_parser_wrapper.parse (l_parser, a_text, True, a_evaluator_class)

			if not eiffel_parser_wrapper.has_error and attached {FEATURE_AS} eiffel_parser_wrapper.ast_node as l_feature then
				Result := l_feature
			end
		end


end
