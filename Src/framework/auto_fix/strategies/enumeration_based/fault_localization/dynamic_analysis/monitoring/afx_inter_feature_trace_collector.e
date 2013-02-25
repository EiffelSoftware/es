note
	description: "Summary description for {}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class AFX_INTER_FEATURE_TRACE_COLLECTOR

inherit

	AFX_TRACE_COLLECTOR
		redefine
			wrap_up,
			on_test_case_entry,
			on_breakpoint_hit_in_test_case
		end

create
	make

feature{NONE} -- Initialization

	make
			-- Initialization.
		do
			make_general
		end

feature -- Basic operation

	wrap_up
			-- <Precursor>
		local
		do
			Precursor

			generate_daikon_files (trace_repository.passing_traces, "passing")
			generate_daikon_files (trace_repository.failing_traces, "failing")
		end

	register_program_state_monitoring
			-- <Precursor>
		local
			l_feature_under_test: AFX_FEATURE_TO_MONITOR
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_contract_expressions: TUPLE [pre, post: EPA_HASH_SET [EPA_EXPRESSION]]
			l_expressions: LINKED_LIST [EPA_EXPRESSION]
			l_manager: EPA_EXPRESSION_EVALUATION_BREAKPOINT_MANAGER
		do
			l_feature_under_test := feature_to_monitor
			l_class := l_feature_under_test.context_class
			l_feature := l_feature_under_test.feature_
			l_contract_expressions := expressions_for_contracts (l_feature_under_test)
			create l_expressions.make
			l_contract_expressions.post.do_all (agent l_expressions.force)
			create state_skeleton.make_with_expressions (l_class, l_feature, l_expressions)

			create l_manager.make (l_class, l_feature)
			l_manager.set_breakpoint_with_expression_and_action (first_breakpoint_in_body,
																 l_contract_expressions.pre, agent on_breakpoint_hit_in_test_case (l_class, l_feature, ?, ?))
			l_manager.set_breakpoint_with_expression_and_action (last_breakpoint_in_body,
																 l_contract_expressions.post, agent on_breakpoint_hit_in_test_case (l_class, l_feature, ?, ?))
			monitored_breakpoint_managers.force_last (l_manager)
		end

	on_test_case_entry (a_breakpoint: BREAKPOINT; a_test_case_info: EPA_STATE)
			-- <Precursor>
		do
			Precursor (a_breakpoint, a_test_case_info)
			recursion_depth := 0
		end

	on_breakpoint_hit_in_test_case (a_class: CLASS_C; a_feature: FEATURE_I; a_breakpoint: BREAKPOINT; a_state: EPA_STATE)
			-- <Precursor>
		local
			l_index: INTEGER
		do
			l_index := a_breakpoint.breakable_line_number
			if (l_index = first_breakpoint_in_body and then recursion_depth = 0) or else (l_index /= first_breakpoint_in_body and then recursion_depth = 1) then
				Precursor (a_class, a_feature, a_breakpoint, a_state)
			end

			if l_index = first_breakpoint_in_body then
				recursion_depth := recursion_depth + 1
			else
				recursion_depth := recursion_depth - 1
			end
		end

feature -- Instrumentation

	feature_to_monitor: AFX_FEATURE_TO_MONITOR
			-- Feature under test.
		local
			l_stack: EIFFEL_CALL_STACK
			l_stack_element, l_test_element: CALL_STACK_ELEMENT
			i: INTEGER
			l_test_element_depth: INTEGER
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			if feature_to_monitor_cache = Void then
				l_stack := debugger_manager.application_status.current_call_stack
				from i := 1
				until i > l_stack.count or else l_test_element /= Void
				loop
					l_stack_element := l_stack.i_th (i)
					if l_stack_element.routine_name ~ Test_case_surrounding_feature_name then
						l_test_element := l_stack.i_th (i - 1)
					end
					i := i + 1
				end
				check test_case_element_found: l_test_element /= Void end
				l_class := first_class_starts_with_name (l_test_element.class_name)
				l_feature := l_class.feature_named (l_test_element.routine_name)
				create feature_to_monitor_cache.make (l_feature, l_class)

				first_breakpoint_in_body := feature_to_monitor.first_breakpoint_in_body
				last_breakpoint_in_body := feature_to_monitor.last_breakpoint_in_body
			end

			Result := feature_to_monitor_cache
		end

	first_breakpoint_in_body: INTEGER
			-- First breakpoint of the body of `feature_to_monitor'.

	last_breakpoint_in_body: INTEGER
			-- Last breakpoint of the body of `feature_to_monitor'.

	recursion_depth: INTEGER
			-- Depth of recursive calls to `feature_under_test_from_call_stack'.
			-- 0 before entering the first call.

feature -- Expressions to monitor

	state_skeleton: EPA_STATE_SKELETON
			-- State skeleton based on `expressions_for_contracts'.

	expressions_for_contracts (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS): TUPLE [pre, post: EPA_HASH_SET [EPA_EXPRESSION]]
			-- Set of expressions that could appear in the pre-/postcondition of `a_feature'.
		local
			l_arguments: DS_HASH_TABLE [TYPE_A, STRING]
			l_operand_names: DS_LINKED_LIST[STRING]
			l_expression: EPA_AST_EXPRESSION
			l_expressions, l_precondition_expressions, l_postcondition_expressions: EPA_HASH_SET[EPA_EXPRESSION]
			l_constructor: AFX_BASIC_TYPE_EXPRESSION_CONSTRUCTOR
		do
			l_arguments := arguments_from_feature (a_feature.feature_, a_feature.context_class)
			create l_operand_names.make_from_linear (l_arguments.keys)
			l_operand_names.put_first ("Current")

			l_precondition_expressions := derived_expressions (a_feature, l_operand_names)

			if a_feature.feature_.has_return_value then
				l_operand_names.put_last ("Result")
			end
			l_postcondition_expressions := derived_expressions (a_feature, l_operand_names)

			Result := [l_precondition_expressions, l_postcondition_expressions]
		end

	derived_expressions (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS; a_expression_texts: DS_LIST [STRING]): EPA_HASH_SET[EPA_EXPRESSION]
			-- Set of derived expressions from `a_expression_texts', in the context of `a_feature'.
		local
			l_expression: EPA_AST_EXPRESSION
			l_expressions, l_precondition_expressions, l_postcondition_expressions: EPA_HASH_SET[EPA_EXPRESSION]
			l_constructor: AFX_BASIC_TYPE_EXPRESSION_CONSTRUCTOR
		do
			create l_expressions.make (a_expression_texts.count)
			from a_expression_texts.start
			until a_expression_texts.after
			loop
				create l_expression.make_with_text (a_feature.context_class, a_feature.feature_, a_expression_texts.item_for_iteration, a_feature.written_class)
				l_expressions.put (l_expression)

				a_expression_texts.forth
			end
			Basic_type_expression_constructor.construct_from (l_expressions)
			Result := Basic_type_expression_constructor.last_constructed_expressions
		end

feature -- Daikon output

	generate_daikon_files (a_traces: DS_HASH_TABLE [AFX_PROGRAM_EXECUTION_TRACE, EPA_TEST_CASE_INFO]; a_tag: STRING)
			-- Generate daikon files from `a_traces'.
			-- Tag the generated files with `a_tag'.
		local
			l_daikon_printer: AFX_PROGRAM_EXECUTION_TRACE_TO_DAIKON_PRINTER
			l_path: PATH
			l_text_file: PLAIN_TEXT_FILE
		do
			create l_daikon_printer.make
			l_daikon_printer.set_state_skeleton (state_skeleton)
			l_daikon_printer.print_trace_repository (a_traces)

			l_path := config.data_directory.extended (feature_to_monitor.out + "." + a_tag + ".decls")
			create l_text_file.make_with_path (l_path)
			l_text_file.create_read_write
			l_text_file.put_string (l_daikon_printer.last_declarations.out)
			l_text_file.close

			l_path := config.data_directory.extended (feature_to_monitor.out + "." + a_tag + ".dtrace")
			create l_text_file.make_with_path (l_path)
			l_text_file.create_read_write
			l_text_file.put_string (l_daikon_printer.last_trace.out)
			l_text_file.close
		end

feature -- Once

	Basic_type_expression_constructor: AFX_BASIC_TYPE_EXPRESSION_CONSTRUCTOR
			-- Shared object to construct basic type expressions.
		once
			create Result
		end

feature -- Cache

	feature_to_monitor_cache: AFX_FEATURE_TO_MONITOR
			-- Cache for `feature_to_monitor'.

end
