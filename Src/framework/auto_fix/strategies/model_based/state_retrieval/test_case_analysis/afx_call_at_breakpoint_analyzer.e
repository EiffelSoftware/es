note
	description: "Summary description for {AFX_CALL_AT_BREAKPOINT_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CALL_AT_BREAKPOINT_ANALYZER

inherit
	AST_ITERATOR
		redefine
			process_access_feat_as,
			process_precursor_as,
			process_current_as,
			process_result_as,
			process_eiffel_list,
			process_nested_as,
			process_nested_expr_as
		end

	EPA_UTILITY

feature -- Analysis setting

	caller_class: CLASS_C
			-- Caller class.

	caller_feature: FEATURE_I
			-- Caller feature.

	breakpoint_index: INTEGER
			-- Position inside `caller_feature' where the call is made.

	nested_breakpoint_index: INTEGER
			-- Position inside `caller_feature' where the call is made.
			-- NOTE: See comment for `current_nested_breakpoint_index'.

	callee_class: CLASS_C
			-- Callee class.
			-- Could be Void.

	callee_name: STRING
			-- Name of the callee feature.

feature -- Derived access

	callee_feature: FEATURE_I
			-- Feature with `feature_name'.
		require
			callee_class_attached: callee_class /= Void
		do
			Result := callee_class.feature_named_32 (callee_name)
		ensure
			result_attached: Result /= Void
		end

feature -- Analysis result

	last_callee_target: EPA_EXPRESSION
			-- Target expression of the callee.

	is_last_call_precursor: BOOLEAN
			-- Is last a precursor call?
			-- If true, `last_precursor' contains the precursor call string,
			-- and `last_argument_list' the list of arguments.

	last_precursor: STRING
			-- Last precursor call string: Precursor {XXX}

	last_argument_list: DS_ARRAYED_LIST [EPA_EXPRESSION]
			-- Arguments of the call.

feature -- Basic operation

	analyze_feature_call (a_caller_class: CLASS_C; a_caller_feature: FEATURE_I;
					a_breakpoint: INTEGER; a_nested_breakpoint: INTEGER;
					a_callee_class: CLASS_C; a_callee_feature_name: STRING)
			-- Analyze the call to `a_callee_class'.`a_callee_feature_name' at a breakpoint of `a_caller_class'.`a_caller_feature'.
			-- Put the result in `last_*'.
		require
			caller_attached: a_caller_class /= Void and then a_caller_feature /= Void
			breakpoint_valid: a_breakpoint > 0 and then a_nested_breakpoint >= 0
			callee_feature_name_not_empty: a_callee_feature_name /= Void and then not a_callee_feature_name.is_empty
		local
			l_breakpoint_info: DBG_BREAKABLE_POINT_INFO
			l_breakpoint_text: STRING
			l_ast: AST_EIFFEL
		do
			reset_analyzer (a_caller_class, a_caller_feature, a_breakpoint, a_nested_breakpoint, a_callee_class, a_callee_feature_name)

			l_breakpoint_info := breakpoint_info_at (caller_class, caller_feature, breakpoint_index)
			l_breakpoint_text := l_breakpoint_info.text
			l_ast := ast_from_statement_or_expression_text (l_breakpoint_text)
			l_ast := ast_in_context_class (l_ast, l_breakpoint_info.class_c,
					l_breakpoint_info.class_c.feature_of_rout_id_set (a_caller_feature.rout_id_set),
					caller_class)
			check ast_attached: l_ast /= Void end
			l_ast.process (Current)

		end

feature --  Visitor routine (Ref: AST_DEBUGGER_BREAKABLE_STRATEGY)

	process_nested_as (l_as: NESTED_AS)
			-- <Precursor>
			-- Refer to {NESTED_BL}.generate for calculating breakpoint nested indexes.
		do
			l_as.target.process (Current)
			enter_nested
			current_nested_expression_stack.put (text_from_ast(l_as.target))
			current_nested_breakpoint_index := current_nested_breakpoint_index + 1
			l_as.message.process (Current)
			exit_nested
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
			-- <Precursor>
			-- Refer to {NESTED_BL}.generate for calculating breakpoint nested indexes.
		do
			l_as.target.process (Current)
			enter_nested
			current_nested_expression_stack.put (text_from_ast(l_as.target))
			current_nested_breakpoint_index := current_nested_breakpoint_index + 1
			-- process_feature_call (current_nested, l_as.message)
			l_as.message.process (Current)
			exit_nested
		end

	process_precursor_as (l_as: PRECURSOR_AS)
			-- <Precursor>
		local
			l_precursor_table: LINKED_LIST [TUPLE [feat: FEATURE_I; parent_type: CL_TYPE_A]]
		do
			if not is_result_set then
				l_precursor_table := precursor_table (l_as, caller_class, caller_feature.rout_id_set)
				check unique_precursor: l_precursor_table.count = 1 end
				l_precursor_table.start
				if is_feature_call_conforming (current_nested_breakpoint_index, l_precursor_table.item.parent_type.associated_class, caller_feature.feature_name) then
					is_last_call_precursor := True
					last_precursor := "Precursor"
					if l_as.parent_base_class /= Void then
						last_precursor := last_precursor + "{" + l_as.parent_base_class.class_name.name + "}"
					end
					save_feature_call_arguments (l_as.parameters)
				end
			end
			precursor (l_as)
		end

	process_current_as (l_as: CURRENT_AS)
			-- <Precursor>
		do
			precursor (l_as)
		end

	process_result_as (l_as: RESULT_AS)
			-- <Precursor>
		do
			precursor (l_as)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
			-- <Precursor>
		local
			l_text: STRING
			l_access_name: STRING
			l_expr: EPA_AST_EXPRESSION
		do
			l_access_name := l_as.access_name_8
			l_text := text_from_ast (l_as)
			if is_within_nested then
				process_feature_call (current_nested, l_as)
				current_nested_expression_stack.put (l_text)
			elseif not local_variables.has (l_access_name) then
				process_feature_call ("Current", l_as)
			end

			precursor(l_as)
		end

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
			-- <Precursor>
		local
			l_cursor: INTEGER
		do
			if attached {EIFFEL_LIST [EXPR_AS]} l_as as lt_list then
				from
					l_cursor := l_as.index
					l_as.start
				until
					l_as.after
				loop
					if attached l_as.item as l_item then
						enter_sub_expression
						l_item.process (Current)
						exit_sub_expression
					else
						check False end
					end
					l_as.forth
				end
				l_as.go_i_th (l_cursor)
			else
				precursor (l_as)
			end
		end

feature{NONE} -- Access

	current_nested_breakpoint_index: INTEGER
			-- Nested breakpoint index at the current processing position.
			--
			-- NOTE: evaluation order of expressions has to be considered to compute the
			--		 nested breakpoint index correctly.
			--		 This is not the case in the current implementation,
			--		 therefore, we only use the name of the callee to locate the call.

	is_result_set: BOOLEAN
			-- Is result already set?
		do
			Result := last_callee_target /= Void or else last_precursor /= Void
		end

feature{NONE} -- Implementation

	reset_analyzer (a_class: CLASS_C; a_feature: FEATURE_I;
					a_breakpoint: INTEGER; a_nested_breakpoint: INTEGER;
					a_callee_class: CLASS_C; a_feature_name: STRING)
			-- Reset analyzer state.
		do
				-- Analysis setting.
			caller_class := a_class
			caller_feature := a_feature
			breakpoint_index := a_breakpoint
			nested_breakpoint_index := a_nested_breakpoint
			callee_class := a_callee_class
			callee_name := a_feature_name.twin

				-- Result.
			last_callee_target := Void
			is_last_call_precursor := False
			last_precursor := Void
			create last_argument_list.make (3)

				-- Internal state.			
			current_nested_breakpoint_index := 0
			expression_stack_cache := Void
			nested_level_stack_cache := Void
			local_variables_cache := Void
		end

	process_feature_call (a_target: STRING; a_message: CALL_AS)
			-- Process a call `a_target' and `a_message' at the current process position.
			-- If it's a match to the callee, save the call to `last_*'.
		require
			target_not_empty: a_target /= Void and then not a_target.is_empty
			message_attached: a_message /= Void
		local
			l_expr: EPA_AST_EXPRESSION
			l_class: CLASS_C
			l_feature_name: STRING
			l_parameters: EIFFEL_LIST [EXPR_AS]
		do
			if not is_result_set then -- and then current_nested_breakpoint_index = nested_breakpoint_index then
				if attached {ACCESS_FEAT_AS} a_message as lt_access then
					l_feature_name := lt_access.access_name_8
					l_parameters := lt_access.parameters
				elseif attached {NESTED_AS} a_message as lt_nested then
					l_feature_name := lt_nested.target.access_name_8
					l_parameters := lt_nested.target.parameters
				end

				create l_expr.make_with_text (caller_class, caller_feature, a_target, caller_feature.written_class)
				l_class := l_expr.type.associated_class
				if is_feature_call_conforming (current_nested_breakpoint_index, l_class, l_feature_name) then
					is_last_call_precursor := False
					if callee_class = Void then
						callee_class := l_class
					end
					last_callee_target := l_expr
					save_feature_call_arguments (l_parameters)
				end
			end
		end

	is_feature_call_conforming (a_nested_breakpoint_index: INTEGER; a_target_class: CLASS_C; a_feature_name: STRING): BOOLEAN
			-- Is the call `a_target_class'.`a_feature_name',
			-- at `a_nested_breakpoint_index', conforming to the callee under search?
		require
			class_attached: a_target_class /= Void
			feature_name_not_empty: a_feature_name /= Void and then not a_feature_name.is_empty
		do
			Result := -- (nested_breakpoint_index = 0 or else a_nested_breakpoint_index = nested_breakpoint_index)
					-- and then
					(callee_class = Void or else callee_class.conform_to (a_target_class))
					and then a_feature_name ~ callee_name
		end

	save_feature_call_arguments (a_arguments: EIFFEL_LIST [EXPR_AS])
			-- Save `a_arguments' as the arguments for the last feature call.
		local
			l_expr: EPA_AST_EXPRESSION
		do
			if a_arguments /= Void then
				from a_arguments.start
				until a_arguments.after
				loop
					create l_expr.make_with_text (caller_class, caller_feature, text_from_ast (a_arguments.item_for_iteration), caller_feature.written_class)
					last_argument_list.force_last (l_expr)
					a_arguments.forth
				end
			end
		end

	local_variables: DS_HASH_SET [STRING]
			-- Local variables in `caller_feature'.
		local
			l_arguments: DS_HASH_TABLE [TYPE_A, STRING]
			l_debugger_manager: DEBUGGER_MANAGER
			l_breakable_info: DBG_BREAKABLE_FEATURE_INFO
			l_object_test_locals: ARRAYED_LIST [TUPLE [id: ID_AS; li: LOCAL_INFO]]
		do
			if local_variables_cache = Void then
				create local_variables_cache.make_equal (10)

					-- Local variables.
				local_variables_cache.append (local_names_of_feature (caller_feature))

					-- Object test.
				l_debugger_manager := shared_debugger_manager.debugger_manager
				l_object_test_locals := l_debugger_manager.debugger_ast_server.object_test_locals (caller_feature.e_feature, breakpoint_index, nested_breakpoint_index)
				from l_object_test_locals.start
				until l_object_test_locals.after
				loop
					local_variables_cache.force (l_object_test_locals.item_for_iteration.id.name_32)
					l_object_test_locals.forth
				end

					-- Arguments.
				l_arguments := arguments_from_feature (caller_feature, caller_class)
				from l_arguments.start
				until l_arguments.after
				loop
					local_variables_cache.force (l_arguments.key_for_iteration)
					l_arguments.forth
				end
			end
			Result := local_variables_cache
		end

	current_nested: STRING
			-- A sub-expression from nested recognized so far.
		local
			l_list: ARRAYED_LIST[STRING]
			l_aggregate: STRING
			l_expr: EPA_AST_EXPRESSION
		do
			create l_aggregate.make_empty
			l_list := current_nested_expression_stack.linear_representation
			from
				l_list.finish
			until
				l_list.before
			loop
				l_aggregate.append (l_list.item_for_iteration)
				l_aggregate.append (".")
				l_list.back
			end

			if not l_aggregate.is_empty and then l_aggregate /~ "." then
				l_aggregate.remove_tail (1)
				Result := l_aggregate
			end
		end

feature{NONE} -- Data structures for processing nested

	is_within_nested: BOOLEAN
			-- Is process currently within a nested?
		require
			stack_not_empty: not nested_level_stack.is_empty
		do
			Result := current_nested_level > 0
		end

	current_nested_level: INTEGER
			-- Nested level within the expression currently under process.
		require
			stack_not_empty: not nested_level_stack.is_empty
		do
			Result := nested_level_stack.item
		end

	nested_level_stack: LINKED_STACK [INTEGER]
			-- Stack for storing nested levels within expressions.
		do
			if nested_level_stack_cache = Void then
				create nested_level_stack_cache.make
				nested_level_stack_cache.put (0)
			end

			Result := nested_level_stack_cache
		end

	current_nested_expression_stack: LINKED_STACK [STRING]
			-- Nested expression stack for processing current expression.
		require
			expression_stack_not_empty: not expression_stack.is_empty
		do
			Result := expression_stack.item
		end

	expression_stack: LINKED_STACK [LINKED_STACK [STRING]]
			-- Stack to keep track of nested expressions from different expressions.
		do
			if expression_stack_cache = Void then
				create expression_stack_cache.make
				expression_stack_cache.put (create {LINKED_STACK [STRING]}.make)
			end

			Result := expression_stack_cache
		end

feature{NONE} -- Operations for processing nested

	enter_nested
			-- Process enters another level of nested.
		require
			stack_not_empty: not nested_level_stack.is_empty
		local
			l_current_level: INTEGER
		do
			l_current_level := nested_level_stack.item
			l_current_level := l_current_level + 1

			nested_level_stack.remove
			nested_level_stack.put (l_current_level)
		ensure
			nested_level_stack_same_count: nested_level_stack.count = old nested_level_stack.count
		end

	exit_nested
			-- Process exits a level of nested.
		require
			stack_not_empty: not nested_level_stack.is_empty
		local
			l_current_level: INTEGER
		do
			l_current_level := nested_level_stack.item
			l_current_level := l_current_level - 1

			nested_level_stack.remove
			nested_level_stack.put (l_current_level)

			if l_current_level = 0 then
				-- Clear `current_nested_expression_stack'
				current_nested_expression_stack.wipe_out
			end
		ensure
			nested_level_stack_same_count: nested_level_stack.count = old nested_level_stack.count
		end

	enter_sub_expression
			-- Enter a sub-expression.
			-- A sub-expression is a standalone expression used as part of the current expression.
			-- For example, an actual argument expression, or a field of a TUPLE.
		local
			l_nested_stack: LINKED_STACK [STRING]
		do
			expression_stack.put (create {LINKED_STACK [STRING]}.make)
			nested_level_stack.put (0)
		end

	exit_sub_expression
			-- Exit a sub-expression.
		require
			expression_stack_not_empty: not expression_stack.is_empty
			nested_level_stack_not_empty: not nested_level_stack.is_empty
			not_within_nested: not is_within_nested
		do
			expression_stack.remove
			nested_level_stack.remove
		end

feature{NONE}

	precursor_table (l_as: PRECURSOR_AS; a_current_class: CLASS_C; a_rout_id_set: ROUT_ID_SET): LINKED_LIST [TUPLE [feat: FEATURE_I; parent_type: CL_TYPE_A]]
			-- Copied from {AST_FEATURE_CHECKER_GENERATOR}.
			-- Table of parent types which have an effective
			-- precursor of current feature. Indexed by
			-- routine ids.
		require
			l_as_not_void: l_as /= Void
		local
			rout_id: INTEGER
			parents: FIXED_LIST [CL_TYPE_A]
			a_parent: CLASS_C
			a_feature: FEATURE_I
			p_name: STRING
			spec_p_name: STRING
			p_list: HASH_TABLE [CL_TYPE_A, STRING]
			i, rc: INTEGER
			couple: TUPLE [written_in, body_index: INTEGER]
			check_written_in: LINKED_LIST [TUPLE [written_in, body_index: INTEGER]]
			r_class_i: CLASS_I
		do
			rc := a_rout_id_set.count

			if l_as.parent_base_class /= Void then
				-- Take class renaming into account
				r_class_i := Universe.class_named (l_as.parent_base_class.class_name.name, a_current_class.group)

				if r_class_i /= Void then
					spec_p_name := r_class_i.name
				else
					-- A class of name `l_as.parent_base_class' does not exist
					-- in the universe. Use an empty name to trigger
					-- an error message later.
					spec_p_name := ""
				end
			end

			from
				parents := a_current_class.parents
				create Result.make
				create check_written_in.make
				check_written_in.compare_objects
				create p_list.make (parents.count)
				parents.start
			until
				parents.after
			loop
				a_parent := parents.item.associated_class
				p_name := a_parent.name

					-- Don't check the same parent twice.
					-- If construct is qualified, check
					-- specified parent only.
				if
					not (p_list.has_key (p_name) and then
					p_list.found_item.is_equivalent (parents.item)) and then
					(spec_p_name = Void or else spec_p_name.is_equal (p_name))
				then
						-- Check if parent has an effective precursor
					from
						i := 1
					until
						i > rc
					loop
						rout_id   := a_rout_id_set.item (i)
						a_feature := a_parent.feature_of_rout_id (rout_id)

						if a_feature /= Void and then not a_feature.is_deferred  then
								-- Ok, add parent.
							couple := [a_feature.written_in, a_feature.body_index]

								-- Before entering the new info in `Result' we
								-- need to make sure that we do not have the same
								-- item, because if we were adding it, it will
								-- cause a VDPR3 error when it is not needed.
							if not check_written_in.has (couple) then
								Result.extend ([a_feature, parents.item])
								check_written_in.extend (couple)
							end

						end
						i := i + 1
					end
						-- Register parent
					p_list.put (parents.item, p_name)
				end
				parents.forth
			end
		end

feature{NONE} -- Cache

	expression_stack_cache: like expression_stack
			-- Cache for `expression_stack'.

	nested_level_stack_cache: like nested_level_stack
			-- Cache for `nested_level_stack'.

	local_variables_cache: like local_variables
			-- Cache for `local_variables'.


end
