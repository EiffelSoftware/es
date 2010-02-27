note
	description: "Summary description for {AFX_SOLVER_EXPRESSION_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_SOLVER_EXPRESSION_GENERATOR

inherit
	SHARED_TYPES

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER

	REFACTORING_HELPER

	SHARED_WORKBENCH

	AFX_SOLVER_CONSTANTS

	SHARED_SERVER

	EPA_SHARED_EXPR_TYPE_CHECKER

	SHARED_NAMES_HEAP

	EPA_SHARED_EXPR_TYPE_CHECKER

	AST_ITERATOR
		redefine
			process_nested_as,
			process_void_as,
			process_bool_as,
			process_integer_as,
			process_result_as,
			process_current_as,
			process_access_feat_as
		end

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create last_statements.make
			create nested_prefix.make
			create last_string.make (256)
		end

feature -- Access

	last_statements: LINKED_LIST [STRING]
			-- The last generated SMT-LIB statement
			-- Every item is a SMT statement
			-- The order of items are the same as the processing order.

feature -- Basic operations

	initialize_for_generation
			-- Initialize current for the next SMTLIB generation.
		do
			last_statements.wipe_out
			last_string.wipe_out
		end

	generate_postcondition_as_invariant_axioms (a_class: CLASS_C)
			-- Generate SMTLIB axioms for some of the postconditions in `a_class'
			-- as if they are class invariants and store results in `last_statements'.
		local
			l_inv_gen: AFX_POSTCONDITION_AS_INVARIANT_GENERATOR
			l_inv: DS_HASH_SET [EPA_EXPRESSION]
			l_stmt: STRING
			l_paran_needed: BOOLEAN
			l_axiom: STRING
		do
			create l_inv_gen
			l_inv_gen.generate (a_class)
			l_inv := l_inv_gen.last_invariants
			from
				l_inv.start
			until
				l_inv.after
			loop
				create l_axiom.make (128)
				l_axiom.append (solver_axiom_header)
				l_stmt := solver_expression_as_string (l_inv.item_for_iteration.ast, a_class, l_inv.item_for_iteration.written_class, Void)
				l_paran_needed := l_stmt.item (1) /= '('
				if l_paran_needed then
					l_axiom.append_character ('(')
				end
				l_axiom.append (l_stmt)
				if l_paran_needed then
					l_axiom.append_character (')')
				end
				l_axiom.append (dummy_semicolon)
				last_statements.extend (l_axiom)
				l_inv.forth
			end
		end

	generate_invariant_axioms (a_class: CLASS_C)
			-- Generate SMTLIB axioms for invariants in `a_class' and store results in `last_statements'.
		local
			l_contract_extractor: AUT_CONTRACT_EXTRACTOR
			l_inv: LIST [EPA_EXPRESSION]
			l_axiom: STRING
			l_stmt: STRING
			l_paran_needed: BOOLEAN
			l_regexp: RX_PCRE_REGULAR_EXPRESSION
			l_ast_text: STRING
		do
			create l_contract_extractor
			l_inv := l_contract_extractor.invariant_of_class (a_class)

				-- Use regular expression to filter out assertions with object test.
			fixme ("Implement support for object test. 9.11.2009 Jasonw")
			create l_regexp.make
			l_regexp.compile ("attached.+as")
			from
				l_inv.start
			until
				l_inv.after
			loop
				create l_axiom.make (128)
				l_axiom.append (solver_axiom_header)
				l_ast_text := l_inv.item_for_iteration.ast.text (match_list_server.item (l_inv.item_for_iteration.written_class.class_id))
				l_regexp.match (l_ast_text)
				if not l_regexp.has_matched then
					l_stmt := solver_expression_as_string (l_inv.item_for_iteration.ast, a_class, l_inv.item_for_iteration.written_class, Void)
					l_paran_needed := l_stmt.item (1) /= '('
					if l_paran_needed then
						l_axiom.append_character ('(')
					end
					l_axiom.append (l_stmt)
					if l_paran_needed then
						l_axiom.append_character (')')
					end
					l_axiom.append (dummy_semicolon)
					last_statements.extend (l_axiom)
				end
				l_inv.forth
			end
		end

	generate_expression (a_expr: EXPR_AS; a_class: CLASS_C; a_written_class: CLASS_C; a_feature: detachable FEATURE_I)
			-- Generate statement from `a_expr' which appear in `a_class', and `a_feature'.
			-- `a_feature' can be Void, for example, if `a_expr' comes from class invariants.
			-- Store result in `last_statements'.
		do
			last_statements.extend (solver_expression_as_string (a_expr, a_class, a_written_class, a_feature))
		end

	generate_void_function
			-- Generate a dummy function for the expression "Void'.
			-- Store result in `last_statements'.
		deferred
		end

	generate_current_function (a_class: CLASS_C)
			-- Generate a dummy function for the expression "Void'.
			-- Store result in `last_statements'.
		deferred
		end

	generate_functions (a_class: CLASS_C)
			-- Generate functions for all queries in a_class'
			-- Store result in `last_statements', every item in `last_statements'
			-- represents a single query. Update `needed_theory' when necessary.
		local
			l_feats: FEATURE_TABLE
			l_cursor: CURSOR
			l_feature: FEATURE_I
		do
			l_feats := a_class.feature_table
			l_cursor := l_feats.cursor
			from
				l_feats.start
			until
				l_feats.after
			loop
				l_feature := l_feats.item_for_iteration
				if not l_feature.type.is_void then
					generate_function (l_feature, a_class)
				end
				l_feats.forth
			end
			l_feats.go_to (l_cursor)
		end

	generate_argument_function (a_feature: FEATURE_I; a_class: CLASS_C)
			-- Generate arguments of `a_feature' as functions,
			-- store result in `last_statement'.
		deferred
		end

	generate_local_function (a_feature: FEATURE_I; a_class: CLASS_C)
			-- Generate locals of `a_feature' as solver expresessions,
			-- store result in `last_statement'.
		deferred
		end

	generate_function (a_feature: FEATURE_I; a_class: CLASS_C)
			-- Generate the solver represention function for `a_feature' in `a_class'.
			-- Store result in `last_statement'. Update `needed_theory' when necessary.
		require
			a_feature_is_query: not a_feature.type.is_void
		deferred
		end

feature{NONE} -- Implementation

	solver_type (a_type: TYPE_A): STRING
			-- type used in solver from `a_type'
		deferred
		end

	solver_prefix (a_prefix: STRING; a_class: CLASS_C): STRING
			-- Prefix for `a_class'
		do
			create Result.make (a_class.name.count + a_prefix.count + 10)
			Result.append (once "{{")
			Result.append (a_prefix)
			Result.append_character (':')
			Result.append (a_class.name_in_upper)
			Result.append (once "}}")
		end

	dummy_paranthesis: STRING
			-- Dummy paranthesis
		deferred
		end

	dummy_semicolon: STRING
			-- Dummy semicolon
		deferred
		end

feature{NONE} -- Implementation

	context_class: CLASS_C
			-- Context class
		do
			if nested_prefix.is_empty then
				Result := initial_context_class
			else
				Result := nested_prefix.item.associated_class
			end
		end

	initial_context_class: like context_class
			-- Initial context class

	context_feature: detachable FEATURE_I
			-- Context feature

	last_string: STRING
			-- Last string used to store temparary result

	last_prefix: STRING
			-- Last prefix

	last_type: TYPE_A
			-- Type of the last processed name

	last_context_type: TYPE_A
			-- Last context type used in nested expression analysis
		do
			if nested_prefix.is_empty then
				Result := context_class.actual_type
			else
				Result := nested_prefix.item
			end
		end

	nested_level: INTEGER
			-- Level of nestness of the expression currently being analyzed.
			-- 0 means no nestness. For an expression "item", although it is
			-- implicitly nested with "Current", syntactically, it is unnested,
			-- so its `nested_level' is 0.
		do
			Result := nested_prefix.count
		ensure then
			good_result: Result = nested_prefix.count
		end

	nested_prefix: LINKED_STACK [TYPE_A]
			-- Stack storing nested prefixes.

	last_nested_prefix: STRING
			-- Nested prefix on top of `nested_prefix'
			-- Empty string if not in a nested expression.

	current_written_class: detachable CLASS_C
			-- Written class for currently processed item
		do
			if nested_prefix.is_empty then
				Result := initial_written_class
			else
				Result := nested_prefix.item.associated_class
			end
		end

	initial_written_class: like current_written_class
			-- Initial written class

	output_buffer: STRING
			-- Output buffer

	final_name: STRING
			-- Final name derived from an access name

	solver_expression_as_string (a_expr: EXPR_AS; a_class: CLASS_C; a_written_class: CLASS_C; a_feature: detachable FEATURE_I): STRING
			-- Generate solver statement from `a_expr' which appear in `a_class', and `a_feature'.
			-- `a_feature' can be Void, for example, if `a_expr' comes from class invariants.
			-- Store result in `last_statements'.
		do
			fixme ("Cannot handle arguments in the target part of a nested expression, for example: a(b).c.d. 3.11.2009 Jasonw")
			set_context_class (a_class)
			set_context_feature (a_feature)

				-- Initialize data for visiting.
			create last_string.make (128)
			create last_prefix.make (32)
			create last_nested_prefix.make (64)
			last_type := none_type
			output_buffer := last_string
			set_current_written_class (a_written_class)

			a_expr.process (Current)
			Result := last_string.twin
		end

feature{NONE}	-- Implementation

	set_context_class (a_class: like context_class)
			-- Set `context_class' with `a_class'.
		do
			initial_context_class := a_class
		ensure
			initial_context_class_set: initial_context_class = a_class
		end

	set_context_feature (a_feature: like context_feature)
			-- Set `context_feature' with `a_feature'.
		do
			context_feature := a_feature
		ensure
			context_feature_set: context_feature = a_feature
		end

	set_current_written_class (a_class: like current_written_class)
			-- Set `current_written_class' with `a_class'.
		do
			initial_written_class := a_class
		ensure
			initial_written_class_set: initial_written_class = a_class
		end

	check_name (a_name: STRING)
			-- Check access name `a_name'
			-- Setup `final_name' and `last_type' according to `a_name'.
		local
			l_feat: detachable FEATURE_I
			l_found: BOOLEAN
			i: INTEGER
			l_locals: HASH_TABLE [LOCAL_INFO, INTEGER]
			l_done: BOOLEAN
		do
			if last_prefix.is_empty then
					-- Check if `a_name' is a feature name.
				check current_written_class /= Void end
				l_feat := final_feature (a_name, current_written_class, context_class)
				l_found := l_feat /= Void
				if l_found then
					final_name := l_feat.feature_name.as_lower
					last_type := l_feat.type.instantiated_in (context_class.actual_type)
				end

				check not l_found implies context_feature /= Void end
				if not l_found then
						-- `a_name' can be a local or an argument
					l_feat := final_feature (context_feature.feature_name, current_written_class, context_class)

						-- Can be an argument.
					i := final_argument_index (a_name, context_feature, current_written_class)
					if i > 0 then
						final_name := context_feature.arguments.item_name (i)
						last_type := context_feature.arguments.i_th (i).instantiation_in (context_class.actual_type, context_class.class_id).actual_type
					else
							-- Must be a local.
						check context_feature /= Void end
						l_locals := expression_type_checker.local_info (context_class, context_feature)
						final_name := a_name.twin
						from
							l_locals.start
						until
							l_locals.after or else l_done
						loop
							if final_name.is_case_insensitive_equal (names_heap.item (l_locals.key_for_iteration)) then
								last_type := l_locals.item_for_iteration.type.instantiation_in (context_class.actual_type, context_class.class_id).actual_type
								l_done := True
							end
							l_locals.forth
						end
					end
				end
			else
				final_name := a_name.twin
				last_type := last_type.associated_class.feature_named (final_name).type.instantiated_in (last_type)
			end
		end

feature{NONE} -- Process

	process_void_as (l_as: VOID_AS)
		do
			output_buffer.append (once "Void")
			last_type := void_type
		end

	process_bool_as (l_as: BOOL_AS)
		do
			output_buffer.append (l_as.value.out.as_lower)
			last_type := boolean_type
		end

	process_integer_as (l_as: INTEGER_AS)
		do
			output_buffer.append (l_as.integer_64_value.out)
			last_type := integer_type
		end

	process_result_as (l_as: RESULT_AS)
		do
			check context_feature /= Void end
			if nested_level = 0 then
				output_buffer.append (solver_prefix ("", context_class))
			end
			output_buffer.append (once "Result")
			last_type := context_feature.type
		end

	process_current_as (l_as: CURRENT_AS)
		do
			if nested_level = 0 then
				output_buffer.append (solver_prefix ("", context_class))
			end
			output_buffer.append (once "Current")
			last_type := context_class.actual_type
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_name: STRING
		do
			l_name := l_as.access_name.as_lower
			check_name (l_name)
			if nested_level = 0 then
					-- Needed for routine arguments.
				output_buffer.append (solver_prefix ("", context_class))
			end
			output_buffer.append (final_name)

			if l_as.internal_parameters /= Void then
				nested_prefix.remove
				check nested_level = 0 end
				output_buffer.append (once " (")
				safe_process (l_as.internal_parameters)
				output_buffer.append (once ")")
			elseif not is_in_nested then
				output_buffer.append (dummy_paranthesis)
			end
		end

	is_in_nested: BOOLEAN

	process_nested_as (l_as: NESTED_AS)
		local
			l_nested_prefix: STRING
			l_index: INTEGER
		do
			is_in_nested := True
			l_nested_prefix := last_nested_prefix
			output_buffer := last_nested_prefix
			l_as.target.process (Current)
			l_index := last_nested_prefix.substring_index (once "}}", 1)
			if l_index /= 0 then
				last_nested_prefix.remove_substring (1, l_index + 1)
			end
			check last_type /= Void end
			nested_prefix.extend (last_type)
			last_nested_prefix.append_character ('.')
			if nested_level = 1 then
				output_buffer := last_string
				output_buffer.append (solver_prefix (last_nested_prefix, nested_prefix.item.associated_class))
				last_nested_prefix.wipe_out
			end
			l_as.message.process (Current)
			if not nested_prefix.is_empty then
				nested_prefix.remove
			end
			if nested_level = 0 then
				output_buffer.append (dummy_paranthesis)
			end
			if nested_level = 0 then
				is_in_nested := False
			end
		end

end
