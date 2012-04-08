note
	description: "Summary description for {EPA_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_UTILITY

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

	SHARED_WORKBENCH

	SHARED_EIFFEL_PARSER

	SHARED_SERVER

	REFACTORING_HELPER

	SHARED_TEXT_ITEMS

	EPA_TYPE_UTILITY

	ETR_SHARED_ERROR_HANDLER
		rename
			error_handler as etr_error_handler
		end

	SHARED_NAMES_HEAP

	SHARED_TYPES

feature -- AST

	text_from_ast (a_ast: AST_EIFFEL): like text_from_ast_with_printer
			-- Text from `a_ast', printed via the default `ast_printer' that is configured with `ast_printer_output'.
		require
			a_ast_attached: a_ast /= Void
		do
			Result := text_from_ast_with_printer (a_ast, ast_printer)
		end

	text_from_ast_with_printer (a_ast: AST_EIFFEL; a_ast_printer: ETR_AST_STRUCTURE_PRINTER): STRING
			-- Text from `a_ast', printed via `a_ast_printer' that has to be configured with a {ETR_AST_STRING_OUTPUT}.
		require
			a_ast_attached: a_ast /= Void
			a_ast_printer_attached: a_ast_printer /= Void
			a_ast_printer_has_string_output_attached: attached {ETR_AST_STRING_OUTPUT} a_ast_printer.output
		do
			a_ast_printer.output.reset
			a_ast_printer.print_ast_to_output (a_ast)

			if attached {ETR_AST_STRING_OUTPUT} a_ast_printer.output as l_ast_printer_output then
				Result := l_ast_printer_output.string_representation
			end
		ensure
			result_attached: Result /= Void
		end

	ast_printer: ETR_AST_STRUCTURE_PRINTER
			-- Default AST printer
		once
			create Result.make_with_output (ast_printer_output)
		end

	ast_printer_output: ETR_AST_STRING_OUTPUT
			-- Output for `ast_printer'
		once
			create Result.make_with_indentation_string ("%T")
		end

	old_remover_output: ETR_AST_STRING_OUTPUT
			-- Output for `old_remover'
		once
			create Result.make_with_indentation_string ("%T")
		end

	ast_from_compound_text (a_text: STRING): EIFFEL_LIST [INSTRUCTION_AS]
			-- AST node from `a_text'
			-- `a_text' must be the textual representation of a compound AS.
			-- If `a_text' is empty (or just contains whitespaces, an empty `{EIFFEL_LIST [INSTRUCTION_AS]}' will be returned.
		local
			l_text: STRING
		do
			l_text := "feature dummy__feature do%N" + a_text + "%Nend"

			entity_feature_parser.reset_nodes
			entity_feature_parser.set_syntax_version (entity_feature_parser.provisional_syntax)
			entity_feature_parser.parse_from_utf8_string (l_text, Void)
			check entity_feature_parser.error_count = 0 end

			if attached {DO_AS} entity_feature_parser.feature_node.body.as_routine.routine_body as l_do then
				if attached l_do.compound then
					Result := l_do.compound
				else
					create {EIFFEL_LIST [INSTRUCTION_AS]} Result.make(0)
				end
			end

			check Result /= Void end
		end

	ast_from_statement_or_expression_text (a_text: STRING): AST_EIFFEL
			-- AST node for `a_text'.
			-- `a_text' can be from an instruction or an expression.
		require
			text_not_empty: a_text /= Void and then not a_text.is_empty
		local
			l_tried_as_instruction, l_tried_as_expression: BOOLEAN
		do
			if not l_tried_as_instruction then
				Result := ast_from_statement_text (a_text)
			elseif not l_tried_as_expression then
				Result := ast_from_expression_text (a_text)
			else
				Result := Void
			end
		rescue
			if not l_tried_as_instruction then
				l_tried_as_instruction := True
				retry
			elseif not l_tried_as_expression then
				l_tried_as_expression := True
				retry
			end
		end

	ast_from_statement_text (a_text: STRING): INSTRUCTION_AS
			-- AST node from `a_text'
			-- `a_text' must a statement AST and must be able to be parsed in to a single AST node.
		local
			l_text: STRING
		do
			l_text := "feature dummy__feature do " + a_text + "%Nend"

			entity_feature_parser.reset_nodes
			entity_feature_parser.set_syntax_version (entity_feature_parser.provisional_syntax)
			entity_feature_parser.parse_from_utf8_string (l_text, Void)

			if attached {ROUTINE_AS} entity_feature_parser.feature_node.body.as_routine as l_routine then
				if attached {DO_AS} l_routine.routine_body as l_do then
					if l_do.compound.count = 1 then
						Result := l_do.compound.first
					end
				end
			end
			check Result /= Void end
		end

	ast_from_expression_text (a_text: STRING): EXPR_AS
			-- AST node from expression `a_text'
			-- `a_text' must be as an expression.
		do
			if a_text.starts_with (ti_for_all_keyword) then
				Result := parsed_quantification (a_text)
			elseif a_text.starts_with (ti_there_exists_keyword) then
				Result := parsed_quantification (a_text)
			else
				expression_parser.set_syntax_version (expression_parser.provisional_syntax)
				expression_parser.parse_from_utf8_string (once "check " + a_text, Void)
				Result := expression_parser.expression_node
			end
		end

	parsed_quantification (a_string: STRING): detachable QUANTIFIED_AS
			-- Parsed quantification from `a_string'
			-- Note: This is a very simple implmenetation.
			-- We assume that the syntax of the quantification is correct.
		local
			l_is_existential: BOOLEAN
			l_ok: BOOLEAN
			l_string: STRING
			l_index: INTEGER
			l_variable: STRING
			l_vars: STRING
			l_expr: EXPR_AS
			l_vars_def: EIFFEL_LIST [TYPE_DEC_AS]
			l_parser: like entity_declaration_parser
			l_var_text: STRING
		do
			l_string := a_string.twin
			if l_string.starts_with (ti_there_exists_keyword + " ") then
				l_string.remove_head (ti_there_exists_keyword.count + 1)
				l_is_existential := True
				l_ok := True
			elseif l_string.starts_with (ti_for_all_keyword + " ") then
				l_string.remove_head (ti_for_all_keyword.count + 1)
				l_is_existential := False
				l_ok := True
			end
			if l_ok then
				l_index := l_string.substring_index (ti_quantification_sperator, 1)

					-- Parse quantified varaible.
					-- Note: We only support one variable for the moment.
				l_vars := l_string.substring (1, l_index - 1)
				create l_var_text.make (l_vars.count + 10)
				l_var_text.append (ti_local_keyword)
				l_var_text.append_character ('%N')
				l_var_text.append (l_vars)
				l_parser := entity_declaration_parser
				l_parser.set_syntax_version (l_parser.provisional_syntax)
				l_parser.parse_from_ascii_string (l_var_text, Void)
				l_vars_def := l_parser.entity_declaration_node

					-- Parse quantified predicate.
				l_expr := ast_from_expression_text (l_string.substring (l_index + ti_quantification_sperator.count, l_string.count))
				if l_is_existential then
					create {THERE_EXISTS_AS} Result.initialize (l_vars_def, l_expr)
				else
					create {FOR_ALL_AS} Result.initialize (l_vars_def, l_expr)
				end

			end
		end

	ast_without_old_expression (a_ast: EXPR_AS): EXPR_AS
			-- An AST node the same as `a_ast' expect that all "old"
			-- keywords are removed
		do
			old_remover.output.reset
			old_remover.print_ast_to_output (a_ast)
			Result := ast_from_expression_text (old_remover_output.string_representation)
		end

	old_remover: EPA_AST_OLD_EXPRESSION_REMOVER
			-- Old expression remover
		once
			create Result.make_with_output (old_remover_output)
		end

	ast_in_other_context (a_ast: AST_EIFFEL; a_source_context: ETR_CONTEXT; a_target_context: ETR_CONTEXT): detachable AST_EIFFEL
			-- New AST from `a_ast' (in `a_source_context'), but viewed from `a_target_context'.
			-- Void if context transformation failed.
		local
			l_transformable: ETR_TRANSFORMABLE
			l_retried: BOOLEAN
		do
			if not l_retried then
				etr_error_handler.reset_errors
				create l_transformable.make (a_ast, a_source_context, True)
				Result := l_transformable.as_in_other_context (a_target_context)
				if etr_error_handler.has_errors then
					Result := Void
				end
			end
		rescue
			l_retried := True
			Result := Void
			retry
		end

	ast_in_context_class (a_ast: AST_EIFFEL; a_written_class: CLASS_C; a_written_feature: detachable FEATURE_I; a_context_class: CLASS_C): AST_EIFFEL
           -- AST representing `a_ast', which comes from `a_written_feature' in `a_written_class'.
           -- The resulting AST is viewed from `a_context_class' and with all renaming resolved.
           -- `a_written_class' and `a_context_class' should be in the same inheritance hierarchy.
       local
           l_source_context: ETR_CONTEXT
           l_target_context: ETR_CONTEXT
           l_feat_context: ETR_FEATURE_CONTEXT
           l_class_context: ETR_CLASS_CONTEXT
           l_feat: FEATURE_I
           l_transformable: ETR_TRANSFORMABLE
       do
           if a_written_class /= Void then
                   -- Calculate source context.
--               create l_class_context.make (a_written_class)
--               create l_feat_context.make (a_written_feature, l_class_context)
--               l_source_context := l_feat_context
               l_source_context := context_from_class_feature (a_written_class, a_written_feature)

                   -- Calculate target context.
               l_feat := a_context_class.feature_of_rout_id_set (a_written_feature.rout_id_set)
--               create l_class_context.make (a_context_class)
--               create l_feat_context.make (l_feat, l_class_context)
--               l_target_context := l_feat_context
               l_target_context := context_from_class_feature (a_context_class, l_feat)
           else
                   -- Calculate source context.
               create l_class_context.make (a_written_class)
               l_source_context := l_class_context

                   -- Calculate target context.
               create l_class_context.make (a_context_class)
               l_target_context := l_class_context
           end

           create l_transformable.make (a_ast, l_source_context, True)
           Result := l_transformable.as_in_other_context (l_target_context).to_ast
       end

	context_from_class_feature (a_class: CLASS_C; a_feature: detachable FEATURE_I): ETR_CONTEXT
			-- Context from `a_class' and possibly `a_feature'
		local
			l_class_ctxt: ETR_CLASS_CONTEXT
		do
			create l_class_ctxt.make (a_class)
			if a_feature = Void then
				Result := l_class_ctxt
			else
				create {ETR_FEATURE_CONTEXT} Result.make (a_feature, l_class_ctxt)
			end
		end

	arguments_from_feature (a_feature: FEATURE_I; a_context_class: CLASS_C): DS_HASH_TABLE [TYPE_A, STRING]
			-- Arguments from `a_feature'
			-- Key of result is argument name, value is type of that argument.
			-- The returned TYPE_As are not guaranteed to be explicit.
		do
			Result := operand_name_types_with_feature (a_feature, a_context_class)
			Result.remove (ti_current)
		end

	ast_without_surrounding_paranthesis (a_expr_as: EXPR_AS): EXPR_AS
			-- Expression AST from `a_expr_as' where all surrounding paranthesis
			-- are removed
		local
			l_ast: EXPR_AS
		do
			from
				l_ast := a_expr_as
			until
				Result /= Void
			loop
				if attached {PARAN_AS} l_ast as l_paran then
					l_ast := l_paran.expr
				else
					Result := l_ast
				end
			end
		end

feature -- Contract extractor

	contract_extractor: EPA_CONTRACT_EXTRACTOR
			-- Contract extractor
		once
			create Result
		end

feature -- Breakpoint related

	shared_debugger_manager: SHARED_DEBUGGER_MANAGER
			-- Shared debugger manager.
		once
			create Result
		end

	breakpoint_info_at (a_class: CLASS_C; a_feature: FEATURE_I; a_index: INTEGER): DBG_BREAKABLE_POINT_INFO
			-- Information about the `a_index'-th breakpoint in `a_class'.`a_feature'.
		local
			l_debugger_manager: DEBUGGER_MANAGER
			l_ast_server: DEBUGGER_AST_SERVER
			l_breakable_info: DBG_BREAKABLE_FEATURE_INFO
			l_points: ARRAYED_LIST [DBG_BREAKABLE_POINT_INFO]
			l_index, l_count: INTEGER
			l_found: BOOLEAN
			l_breakpoint: DBG_BREAKABLE_POINT_INFO
		do
			l_debugger_manager := shared_debugger_manager.debugger_manager
			l_ast_server := l_debugger_manager.debugger_ast_server
			l_breakable_info := l_ast_server.breakable_feature_info (a_feature.e_feature)
			l_points := l_breakable_info.points
			from
				l_index := l_points.lower
				l_count := l_points.upper
			until
				l_found or else l_index > l_count
			loop
				l_breakpoint := l_points[l_index]
				if l_breakpoint /= Void and then l_breakpoint.bp = a_index and then l_breakpoint.bp_nested = 0 then
					Result := l_breakpoint
					l_found := True
				end

				l_index := l_index + 1
			end
		ensure
			result_attached: Result /= Void
		end

	breakpoint_count (a_feature: FEATURE_I): INTEGER
			-- Count of breakpoints in `a_feature'.
		local
			l_breakable_info: DBG_BREAKABLE_FEATURE_INFO
		do
			l_breakable_info := shared_debugger_manager.debugger_manager.debugger_ast_server.breakable_feature_info (a_feature.e_feature)
			Result := l_breakable_info.breakable_count
		end

	is_feature_body_breakpoint_slot (a_feature: FEATURE_I; a_bp_slot: INTEGER): BOOLEAN
			-- Is `a_bp_slot' in the feature body of `a_feature'?
		require
			a_feature_not_void: a_feature /= Void
			a_bp_slot_valid: a_bp_slot >= 1
		local
			l_bp_interval: INTEGER_INTERVAL
		do
			l_bp_interval := feature_body_breakpoint_slots (a_feature)
			if l_bp_interval.has (a_bp_slot) then
				Result := True
			end
		end

	is_contract_breakpoint_slot (a_feature: FEATURE_I; a_bp_slot: INTEGER): BOOLEAN
			-- Is `a_bp_slot' part of the contracts of `a_feature'?
		require
			a_feature_not_void: a_feature /= Void
			a_bp_slot_valid: a_bp_slot >= 1
		do
			if not is_feature_body_breakpoint_slot (a_feature, a_bp_slot) and breakpoint_count (a_feature) < a_bp_slot then
				Result := True
			end
		end

	feature_body_breakpoint_count (a_feature: FEATURE_I): INTEGER
			-- Count of breakpoints of the feature body of `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
		local
			l_bp_interval: INTEGER_INTERVAL
		do
			l_bp_interval := feature_body_breakpoint_slots (a_feature)
			Result := l_bp_interval.upper - l_bp_interval.lower + 1
		end

	feature_body_breakpoint_slots (a_feature: FEATURE_I): INTEGER_INTERVAL
			-- First and last breakpoint slot of the feature body of `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
		local
			l_bp_finder: EPA_AST_BP_SLOTS_FINDER
			l_bp_initializer: ETR_BP_SLOT_INITIALIZER
		do
			create l_bp_initializer
			l_bp_initializer.init_with_context (a_feature.e_feature.ast, a_feature.written_class)
			create l_bp_finder
			l_bp_finder.set_feature (a_feature)
			l_bp_finder.set_ast (body_ast_from_feature (a_feature))
			l_bp_finder.find
			create Result.make (l_bp_finder.first_bp_slot, l_bp_finder.last_bp_slot)
		end

	assertion_at (a_class: CLASS_C; a_feature: FEATURE_I; a_breakpoint_index: INTEGER): TUPLE[STRING, EPA_EXPRESSION]
			-- Assertion, consisting of an optional tag and an expression, at `a_breakpoint' of `a_feature' from `a_class'.
		require
			is_assertion_at_breakpoint: True -- The arguments indicate an assertion.
		local
			l_breakpoint: DBG_BREAKABLE_POINT_INFO
			l_written_class: CLASS_C
			l_written_feature: FEATURE_I
			l_context_breakpoint_expression: EPA_AST_EXPRESSION
			l_written_ast: EXPR_AS
			l_breakpoint_text: STRING
			l_column_position: INTEGER
			l_tag: STRING
		do
			l_breakpoint := breakpoint_info_at (a_class, a_feature, a_breakpoint_index)
			l_breakpoint_text := l_breakpoint.text

				-- A naive way to get the tag.
			l_column_position := l_breakpoint_text.index_of (':', 1)
			if l_column_position > 1 then
				l_tag := l_breakpoint_text.substring (1, l_column_position - 1)
				l_breakpoint_text := l_breakpoint_text.substring (l_column_position + 1, l_breakpoint_text.count)
			else
				l_tag := ""
			end

				-- Rewrite the expression in the desired context.
			l_written_class := l_breakpoint.class_c
			l_written_feature := l_written_class.feature_of_rout_id_set (a_feature.rout_id_set)
			l_written_ast := ast_from_expression_text (l_breakpoint_text)
			check l_written_ast /= Void end
			check attached {EXPR_AS} ast_in_context_class (l_written_ast, l_written_class, l_written_feature, a_class) as lt_context_ast then
				create l_context_breakpoint_expression.make_with_text (a_class, a_feature, text_from_ast (lt_context_ast), l_written_class)

					-- FIXME: Make sure the assertion expression has the right type, even if type checking has failed.
				if l_context_breakpoint_expression.type = Void then
					l_context_breakpoint_expression.set_type (Boolean_type)
				end
			end

			Result := [l_tag, l_context_breakpoint_expression]
		end


feature -- Class/feature related

	arguments_of_feature (a_feature: FEATURE_I): DS_HASH_TABLE [INTEGER, STRING]
			-- Table of formal argument names in `a_feature'
			-- Key is the argument name, value is its index in the feature signature.
			-- The equality tester of the result is case insensitive equality tester.
		local
			i: INTEGER
			l_count: INTEGER
		do
			l_count := a_feature.argument_count
			create Result.make (l_count)
			Result.set_key_equality_tester (string_equality_tester)

			if l_count > 0 then
				from
					i := 1
				until
					i > l_count
				loop
					Result.put (i, a_feature.arguments.item_name (i))
					i := i + 1
				end
			end
		end

	operand_count_of_feature (a_feature: FEATURE_I): INTEGER
			-- Number of operands (target, argument, result) of `a_feature'
		do
			Result := a_feature.argument_count + 1
			if not a_feature.type.is_void then
				Result := Result + 1
			end
		end

	operands_of_feature (a_feature: FEATURE_I): DS_HASH_TABLE [INTEGER, STRING]
			-- Operands and their positions of `a_feature', including target and possible
			-- returned Result. Operand positions are 0-based, with 0 indicates the target.
			-- Key is an operand name, value is the position of that operand.
			-- The result is inversed `operands_with_feature'.
		local
			l_operand_count: INTEGER
			l_arg_cursor: like arguments_of_feature.new_cursor
		do
			l_operand_count := 1 + a_feature.argument_count
			if not a_feature.type.is_void then
				l_operand_count := l_operand_count + 1
			end
			create Result.make (l_operand_count)
			Result.set_key_equality_tester (string_equality_tester)

			Result.force_last (0, ti_current)
			from
				l_arg_cursor := arguments_of_feature (a_feature).new_cursor
				l_arg_cursor.start
			until
				l_arg_cursor.after
			loop
				Result.force_last (l_arg_cursor.item, l_arg_cursor.key)
				l_arg_cursor.forth
			end

			if a_feature.has_return_value then
				Result.force_last (l_operand_count - 1, ti_result)
			end
		end

	operands_with_feature (a_feature: FEATURE_I): DS_HASH_TABLE [STRING, INTEGER]
			-- Operands and their positions of `a_feature', including target and possible
			-- returned Result. Operand positions are 0-based, with 0 indicates the target.
			-- Key is an operand position, value is the operand name.
			-- The result is inversed `operands_of_feature'.
		local
			l_operands: like operands_of_feature
			l_cursor: like operands_of_feature.new_cursor
		do
			l_operands := operands_of_feature (a_feature)
			create Result.make (l_operands.count)
			from
				l_cursor := l_operands.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.force_last (l_cursor.key, l_cursor.item)
				l_cursor.forth
			end
		end

	operand_expressions_with_feature (a_class: CLASS_C; a_feature: FEATURE_I): HASH_TABLE [EPA_EXPRESSION, INTEGER]
			-- Operands and their positions of `a_feature', including target and possible
			-- returned Result. Operand positions are 0-based, with 0 indicates the target.
			-- Key is an operand position, value is the operand name.
			-- The result is inversed `operands_of_feature'.
		local
			l_operands: like operands_of_feature
			l_cursor: like operands_of_feature.new_cursor
			l_expr: EPA_AST_EXPRESSION
		do
			l_operands := operands_of_feature (a_feature)
			create Result.make (l_operands.count)
			from
				l_cursor := l_operands.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				create l_expr.make_with_text (a_class, a_feature, l_cursor.key, a_feature.written_class)
				Result.force (l_expr, l_cursor.item)
				l_cursor.forth
			end
		end

	operand_types_with_feature (a_feature: FEATURE_I; a_context_class: CLASS_C): DS_HASH_TABLE [TYPE_A, INTEGER]
			-- Types of operands of `a_feature' in the context of `a_context_class'.
			-- Result is a table, key is the 0-based operand index, 0 indicates the target,
			-- followed by arguments and result, if any. Value is the type of that operand.
			-- Note: Types in the result is not resolved.
		local
			l_operand_count: INTEGER
			l_args: FEAT_ARG
			l_cursor: CURSOR
			i: INTEGER
		do
			l_operand_count := 1 + a_feature.argument_count
			if a_feature.has_return_value then
				l_operand_count := l_operand_count + 1
			end
			create Result.make (l_operand_count)
			Result.force_last (a_context_class.actual_type, 0)
			if a_feature.has_return_value then
				Result.force_last (a_feature.type, l_operand_count - 1)
			end

			if a_feature.argument_count > 0 then
				l_args := a_feature.arguments
				l_cursor := l_args.cursor
				from
					i := 1
					l_args.start
				until
					l_args.after
				loop
					Result.force_last (l_args.item_for_iteration, i)
					i := i + 1
					l_args.forth
				end
				l_args.go_to (l_cursor)
			end
		end

	resolved_operand_types_with_feature (a_feature: FEATURE_I; a_viewed_class: CLASS_C; a_context_type: TYPE_A): like operand_types_with_feature
			-- Types of operands of `a_feature' in the context of `a_context_class'.
			-- Result is a table, key is the 0-based operand index, 0 indicates the target,
			-- followed by arguments and result, if any. Value is the type of that operand.
			-- Note: Types in the result is solved in `a_context_class'.	
		local
			l_type: TYPE_A
		do
			Result := operand_types_with_feature (a_feature, a_viewed_class)
			from
				Result.start
			until
				Result.after
			loop
				l_type := Result.item_for_iteration.actual_type
				l_type := actual_type_from_formal_type (l_type, a_context_type.associated_class)
				l_type := l_type.actual_type.instantiation_in (a_context_type, a_context_type.associated_class.class_id)
				Result.replace (l_type, Result.key_for_iteration)
				Result.forth
			end
		end

	operand_name_index_with_feature (a_feature: FEATURE_I; a_context_class: CLASS_C): HASH_TABLE [STRING, INTEGER]
			-- Table from 0-based operand (including result, if any) index to the corresponding operand names.
			-- Key is operand index, value is the name of that operand. "Current" for target, "Result" for result.
		local
			l_operand_count: INTEGER
			l_args: FEAT_ARG
		do
			l_operand_count := 1 + a_feature.argument_count
			if a_feature.has_return_value then
				l_operand_count := l_operand_count + 1
			end
			create Result.make (l_operand_count)
			Result.put (ti_current, 0)
			if a_feature.has_return_value then
				Result.put (ti_result, l_operand_count - 1)
			end

			if a_feature.argument_count > 0 then
				l_args := a_feature.arguments
				across 1 |..| a_feature.argument_count as l_arg_indexes loop
					Result.put (l_args.item_name (l_arg_indexes.item), l_arg_indexes.item)
				end
			end
		end

	operand_name_types_with_feature (a_feature: FEATURE_I; a_context_class: CLASS_C): DS_HASH_TABLE [TYPE_A, STRING]
			-- Types of operands of `a_feature' in the context of `a_context_class'.
			-- Result is a table, key is operand name, such as "Current", "Result", and arguments.
			-- Value is the type of that operand.
			-- Note: Types in the result is not resolved.
		require
			a_feature_not_void: a_feature /= Void
			a_context_class_not_void: a_context_class /= Void
		local
			l_operand_count: INTEGER
			l_args: FEAT_ARG
			l_cursor: CURSOR
			i: INTEGER
		do
			l_operand_count := 1 + a_feature.argument_count
			if a_feature.has_return_value then
				l_operand_count := l_operand_count + 1
			end
			create Result.make (l_operand_count)
			Result.set_key_equality_tester (string_equality_tester)
			Result.force_last (a_context_class.actual_type, ti_current)
			if a_feature.has_return_value then
				Result.force_last (a_feature.type, ti_result)
			end

			if a_feature.argument_count > 0 then
				l_args := a_feature.arguments
				l_cursor := l_args.cursor
				from
					i := 1
					l_args.start
				until
					l_args.after
				loop
					Result.force_last (l_args.item_for_iteration, l_args.item_name (i))
					i := i + 1
					l_args.forth
				end
				l_args.go_to (l_cursor)
			end
		end

	local_names_of_feature (a_feature: FEATURE_I): DS_HASH_SET [STRING]
			-- Set of local variable names in `a_feature'
			-- The equality tester of the result is case insensitive equality tester.
		do
			create Result.make (10)
			Result.set_equality_tester (case_insensitive_string_equality_tester)

			if attached {ROUTINE_AS} a_feature.body.body.as_routine as l_routine then
				if l_routine.locals /= Void then
					l_routine.locals.do_all (
						agent (a_type_dec: TYPE_DEC_AS; a_result: DS_HASH_SET [STRING])
							local
								i: INTEGER
								c: INTEGER
							do
								from
									c := a_type_dec.id_list.count
									i := 1
								until
									i > c
								loop
									a_result.force_last (a_type_dec.item_name (i))
									i := i + 1
								end
							end (?, Result))
				end
			end
		end

	first_class_starts_with_name (a_class_name: STRING): detachable CLASS_C
			-- First class found in current system with name `a_class_name'
			-- Void if no such class was found.
		local
			l_classes: LIST [CLASS_I]
			l_class_c: CLASS_C
		do
			l_classes := universe.classes_with_name (a_class_name.as_upper)
			if not l_classes.is_empty then
				Result := l_classes.first.compiled_representation
			end
		end

	feature_from_class (a_class_name: STRING; a_feature_name: STRING): detachable FEATURE_I
			-- Feature named `a_feature_name' from class named `a_class_name'
			-- Void if no such feature exists.
		local
			l_class: detachable CLASS_C
		do
			l_class := first_class_starts_with_name (a_class_name)
			if l_class /= Void then
				Result := l_class.feature_named (a_feature_name)
			end
		end

	feature_header_comment (a_feature: FEATURE_I): STRING
			-- Header comment of `a_feature'
		local
			l_comments: EIFFEL_COMMENTS
			l_text: STRING_32
			l_nls: INTEGER
		do
			fixme ("Code copied from EB_FEATURE_FOR_COMPLETION.tooltip_text")
			create Result.make_empty
			if a_feature.feature_id /= 0 then
				l_comments := comment_extractor.feature_comments (a_feature.e_feature)
				if attached l_comments then
					from l_comments.start until l_comments.after loop
						if attached l_comments.item as l_comment_line then
							l_text := l_comment_line.content
							l_text.left_adjust
							l_text.right_adjust

							if not l_text.is_empty then
								Result.append_string_general (l_text)
								Result.append_character (' ')
								l_nls := 0
							else
								if l_nls >= 2 and then not l_comments.islast then
									Result.append ("%N%N")
								end
							end
							l_nls := l_nls + 1
						end
						l_comments.forth
					end
				end
			end
		end

	comment_extractor: EPA_COMMENT_EXTRACTOR
			-- Comment extractor
		once
			create Result
		end

	operand_index_set (a_feature: FEATURE_I; a_include_target: BOOLEAN; a_include_result: BOOLEAN): INTEGER_INTERVAL
			-- Operand index interval for `a_feature'
			-- `a_include_target' indicates if the target operand 0 is included in the result interval.
			-- `a_include_result' indicates if the result (if any) operand is included in the result internal.
		local
			l_lower: INTEGER
			l_upper: INTEGER
		do
			if a_include_target then
				l_lower := 0
			else
				l_lower := 1
			end
			l_upper := a_feature.argument_count
			if a_include_result and then a_feature.has_return_value then
				l_upper := l_upper + 1
			end
			create Result.make (l_lower, l_upper)
		end

	root_class_of_system: detachable CLASS_C
			-- Root class of Current system, if any
			-- If current system is compiled using "all-class" option, there
			-- is no root class, current query will return Void.
		do
			Result := workbench.system.root_type.associated_class
		end

	root_feature_of_system: detachable FEATURE_I
			-- Root feature of Current system, if any
			-- If current system is compiled using "all-class" option, there
			-- is no root class, hence, there is no root feature.
		do
			if attached {CLASS_C} root_class_of_system as l_root_class then
				Result := l_root_class.feature_named (workbench.system.root_creation_name)
			end
		end

feature -- Status report

	is_argument_mentioned (a_expression: EPA_EXPRESSION; a_feature: FEATURE_I; a_class: CLASS_C): BOOLEAN
			-- Is any argument of `a_feature' mentioned in `a_expression'?
		local
			l_replacements: HASH_TABLE [STRING, STRING]
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, STRING]
		do
			if a_feature.argument_count > 0 then
				create l_replacements.make (a_feature.argument_count)
				l_replacements.compare_objects

				from
					l_cursor := arguments_of_feature (a_feature).new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					l_replacements.force (once "@@", l_cursor.key)
					l_cursor.forth
				end
				Result := expression_rewriter.expression_text (a_expression, l_replacements).has_substring (once "@@")
			end
		end

	is_feature_of_same_signature (a_feature: FEATURE_I; b_feature: FEATURE_I): BOOLEAN
			-- Do `a_feature' and `b_feature' have the same signature (arguments and return type)?
		do
				-- Check return type equality.
			Result := a_feature.has_return_value = b_feature.has_return_value
			if Result then
				if a_feature.has_return_value then
					Result :=
						a_feature.type.same_type (b_feature.type) and then
						a_feature.type.is_equivalent (b_feature.type)
				end
			end
				-- Check argument type equality.
			if Result then
				Result := a_feature.argument_count = b_feature.argument_count
			end

			if Result and then a_feature.argument_count > 0 then
				Result :=
					across 1 |..| a_feature.argument_count as l_indexes all
						a_feature.arguments.i_th (l_indexes.item).same_type (b_feature.arguments.i_th (l_indexes.item)) and then
						a_feature.arguments.i_th (l_indexes.item).is_equivalent (b_feature.arguments.i_th (l_indexes.item))
					end
			end
		end

feature -- String manipulation

	string_slices (a_string: STRING; a_separater: STRING): LIST [STRING]
			-- Split `a_string' on `a_separater', return slices.
		local
			l_index1, l_index2: INTEGER
			l_part: STRING
			l_done: BOOLEAN
			l_spe_count: INTEGER
		do
			create {LINKED_LIST [STRING]} Result.make
			from
				l_spe_count := a_separater.count
			until
				l_done
			loop
				l_index2 := a_string.substring_index (a_separater, l_index1 + 1)
				if l_index2 = 0 then
					l_index2 := a_string.count + 1
					l_done := True
				end
				l_part := a_string.substring (l_index1 + 1, l_index2 - 1)
				Result.extend (l_part)
				l_index1 := l_index2 + l_spe_count - 1
			end
		end

feature -- Equation

	equation_with_value (a_expr: EPA_EXPRESSION; a_value: EPA_EXPRESSION_VALUE): EPA_EQUATION
			-- Equation with current as expression and `a_value' as value.
		do
			create Result.make (a_expr, a_value)
		end

	equation_with_random_value (a_expr: EPA_EXPRESSION): EPA_EQUATION
			-- Equation with current as expression, with a randomly
			-- assigned value.
		local
			l_value: EPA_EXPRESSION_VALUE
		do
			if a_expr.type.is_boolean then
				create {EPA_RANDOM_BOOLEAN_VALUE} l_value.make
			elseif a_expr.type.is_integer then
				create {EPA_RANDOM_INTEGER_VALUE} l_value.make
			else
				check not_supported_yet: False end
				to_implement ("Implement random value for other types.")
			end

			Result := equation_with_value (a_expr, l_value)
		ensure
			value_is_random: Result.value.is_random
		end

feature -- Equation transformation

	equation_in_normal_form (a_equation: EPA_EQUATION): EPA_EQUATION
			-- Equation in normal form of `a_equation'.
			-- Transformation only happens if `a_equation'.`expression' is in form of "prefix.ABQ",
			-- otherwise, return `a_equation' itself.
		local
			l_analyzer: EPA_ABQ_STRUCTURE_ANALYZER
			l_expr: EPA_AST_EXPRESSION
			l_text: STRING
			l_ori_expr: EPA_EXPRESSION
			l_value: EPA_BOOLEAN_VALUE
		do
			l_ori_expr := a_equation.expression
			if l_ori_expr.is_predicate then
				create l_analyzer
				l_analyzer.analyze (l_ori_expr)
				if l_analyzer.is_matched then
					create l_text.make (l_ori_expr.text.count)
					if attached l_analyzer.prefix_expression as l_prefix then
						l_text.append (l_prefix.text)
						l_text.append_character ('.')
					end
					l_text.append (l_analyzer.argumentless_boolean_query.text)
					create l_expr.make_with_text (l_ori_expr.class_, l_ori_expr.feature_, l_text, l_ori_expr.written_class)
					if attached {EPA_BOOLEAN_VALUE} a_equation.value as l_temp_value then
						if l_temp_value.is_deterministic and then l_analyzer.negation_count \\ 2 = 1 then
							create l_value.make (not l_temp_value.item)
						else
							l_value := l_temp_value
						end
					else
						check should_not_happen: False end
					end
					create Result.make (l_expr, l_value)
				else
					Result := a_equation
				end
			else
				Result := a_equation
			end
		end

feature -- Expressions/Types

	variable_to_type_replacements (a_variables: EPA_HASH_SET [EPA_EXPRESSION]; a_context_type: detachable TYPE_A): HASH_TABLE [STRING, STRING]
			-- Table to lookup the type of variables in `a_variables'
			-- Key is variable name, value is the type of that variable.
		do
			create Result.make (a_variables.count)
			Result.compare_objects
			a_variables.do_all (
				agent (a_expr: EPA_EXPRESSION; a_tbl: HASH_TABLE [STRING, STRING]; a_ctxt_type: detachable TYPE_A)
					local
						l_type: STRING
					do
						l_type := cleaned_type_name (a_expr.resolved_type (a_ctxt_type).name)
						l_type.prepend_character ('{')
						l_type.append_character ('}')
						a_tbl.put (l_type, a_expr.text.as_lower)
					end (?, Result, a_context_type))
		end

feature -- Expressions

	expression_rewriter: EPA_TRANSITION_EXPRESSION_REWRITER
			-- Expression rewriter to rewrite `variables' in anonymous format.
		once
			create Result.make
		end

	expression_text_with_replacement (a_expression: EPA_EXPRESSION; a_replacements: HASH_TABLE [STRING, STRING]): STRING
			-- Text of `a_expression' with all accesses to variables replaced by anonymoue names
			-- `a_replacements' defines the replacements. Key is the original variable name in `a_expressions',
			-- value is the new text for that variable in the resulting string.
			-- For example, "has (v)" will be: "{0}.has ({1})", given those variable positions.			
		do
			Result := expression_rewriter.expression_text (a_expression, a_replacements)
		end

feature -- Context

	variable_position_mapping_from_context (a_context: EPA_CONTEXT): HASH_TABLE [STRING, INTEGER]
			-- A straitforward assignment of positions of variable in `a_context'
			-- The variable position starts from 1.
			-- Key is position, value is the variable at that position.
		local
			i: INTEGER
		do
				-- Setup variable positions.			
			create Result.make (10)
			i := 1
			across a_context.variables as l_variables loop
				Result.force (l_variables.key, i)
				i := i + 1
			end
		end

	body_ast_from_feature (a_feature: FEATURE_I): detachable INTERNAL_AS
			-- Body AST from `a_feature', if any
		do
			if attached {BODY_AS} a_feature.body.body as l_body then
				if attached {ROUTINE_AS} l_body.content as l_routine then
					if attached {DO_AS} l_routine.routine_body as l_do then
						Result := l_do
					elseif attached {ONCE_AS} l_routine.routine_body as l_once then
						Result := l_once
					end
				end
			end
		end

	body_compound_ast_from_feature (a_feature: FEATURE_I): detachable EIFFEL_LIST [INSTRUCTION_AS]
			-- Body compound AST from `a_feature', if any
		do
			if attached {DO_AS} body_ast_from_feature (a_feature) as l_body then
				if attached {EIFFEL_LIST [INSTRUCTION_AS]} l_body.compound as l_compound then
					Result := l_compound
				end
			elseif attached {ONCE_AS} body_ast_from_feature (a_feature) as l_once then
				if attached {EIFFEL_LIST [INSTRUCTION_AS]} l_once.compound as l_compound then
					Result := l_compound
				end
			end
		end

	expression_value_from_string (a_value_text: STRING): detachable EPA_EXPRESSION_VALUE
			-- Expression value from `a_value_text'
			-- Result can be Void if `a_value_text' does not contain correct information.
		local
			l_ref_value: EPA_REFERENCE_VALUE
		do
			if a_value_text /= Void then
				if a_value_text ~ {ITP_SHARED_CONSTANTS}.void_value then
					create {EPA_VOID_VALUE} Result.make
				elseif a_value_text ~ {ITP_SHARED_CONSTANTS}.invariant_violation_value or a_value_text ~ {ITP_SHARED_CONSTANTS}.nonsensical_value then
						-- An exception happened during the expression evaluation,
						-- we don't have any value for this expression.
				else
					if a_value_text.is_boolean then
						create {EPA_BOOLEAN_VALUE} Result.make (a_value_text.to_boolean)
					elseif a_value_text.is_integer then
						create {EPA_INTEGER_VALUE} Result.make (a_value_text.to_integer)
					else
							-- Reference type.
							-- Note that we does not have information about the object
							-- equivalence, so we do not call set_object_equivalent_class_id.
							-- This means that we cannot handle object equality checking later
							-- in an external expression evaluation.
						create l_ref_value.make (a_value_text, system.any_type)
						Result := l_ref_value
					end
				end
			end
		end

feature -- Typing

	is_type_conformant_in_application_context (a_type1: TYPE_A; a_type2: TYPE_A): BOOLEAN
			-- Is `a_type1' conformant to `a_type2' in the context of `root_class_of_system'
		do
			Result := is_type_conformant (a_type1, a_type2, root_class_of_system.actual_type)
		end


feature -- Class Descendants

	candidate_class_list: HASH_TABLE [CLASS_C, INTEGER]
			-- Table of ancestor classes (see `find_classes').
			-- Key is `class_id' of a descendant class, value is CLASS_C object of that class

	candidate_class_table: HASH_TABLE [HASH_TABLE [CLASS_C, INTEGER], INTEGER]
			-- Table of descendant classes (see `find_classes').
			-- Key is `class_id' of a descendant class, value is a list of its descendants.

	processed_classes: SEARCH_TABLE [INTEGER];
			-- Flag structure to indicate whether or not a class has been processed.
			-- Item of this set is `class_id' of a compiled class.
			-- Ssee `find_classes'.

	find_classes_setup (a_wipe: BOOLEAN)
			-- Reset `find_classes' data structures.
			-- Used inside `find_classes'
		do
			if candidate_class_list = Void then
				create candidate_class_list.make (100)
			end

			if candidate_class_table = Void then
				create candidate_class_table.make (100)
			end

			if processed_classes = Void then
				create processed_classes.make (100)
			end

			if a_wipe then
				candidate_class_list.wipe_out
				candidate_class_table.wipe_out
				candidate_class_list.wipe_out
			end
		ensure then
			candidate_class_list_attached: candidate_class_list /= Void
			candidate_class_list_is_empty: a_wipe implies candidate_class_list.is_empty
			candidate_class_table_attached: candidate_class_table /= Void
			candidate_class_table_is_empty: a_wipe implies candidate_class_table.is_empty
			processed_classes_attached: processed_classes /= Void
			processed_classes_is_empty: a_wipe implies processed_classes.is_empty
		end

	find_class_descendants (a_class_c: CLASS_C; a_including_self: BOOLEAN; a_recursive: BOOLEAN)
			-- Find all descendants of `a_class_c' and put them in `candidate_class_list' and `candidate_class_table'.
			-- If `a_including_self' is True, `a_class_c' will be in resultset.)
			-- If `a_recursive' is True, find recursively.
			-- Extracted from `{QL_CLASS_DESCENDANT_RELATION_CRI}.find_classes'
		local
			l_descendants: ARRAYED_LIST [CLASS_C]
			l_descendant_class: CLASS_C
			l_list: HASH_TABLE [CLASS_C, INTEGER]
			l_class_id: INTEGER
			l_class_id2: INTEGER
			l_candidate_class_list: like candidate_class_list
			l_candidate_class_table: like candidate_class_table
			l_processed_classes: like processed_classes
		do
			find_classes_setup (false)

			if a_including_self then
				create l_descendants.make (1)
				l_descendants.extend (a_class_c)
			else
				l_descendants := a_class_c.direct_descendants
			end
			if not l_descendants.is_empty then
				l_processed_classes := processed_classes
				l_candidate_class_list := candidate_class_list
				l_candidate_class_table := candidate_class_table
				l_class_id2 := a_class_c.class_id
				from
					l_descendants.start
				until
					l_descendants.after
				loop
					l_descendant_class := l_descendants.item
					l_class_id := l_descendant_class.class_id
					l_candidate_class_list.put (l_descendant_class, l_class_id)
					l_list := l_candidate_class_table.item (l_class_id2)
					if l_list = Void then
						create {HASH_TABLE [CLASS_C, INTEGER]}l_list.make (2)
						l_candidate_class_table.put (l_list, l_class_id2)
					end
					if not a_including_self and then not l_list.has (l_class_id) then
						l_list.put (l_descendant_class, l_class_id)
					end
					if not l_processed_classes.has (l_class_id) then
						l_processed_classes.force (l_class_id)
						if a_recursive then
							find_class_descendants (l_descendant_class, False, a_recursive)
						end
					end
					l_descendants.forth
				end
			end
		end

end
