note
	description: "Summary description for {AFX_SMTLIB_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_SMTLIB_GENERATOR

inherit
	AFX_SOLVER_EXPRESSION_GENERATOR
		redefine
			process_binary_as,
			process_unary_as
		end

create
	make

feature -- Basic operations

	generate_void_function
			-- Generate a dummy function for the expression "Void'.
			-- Store result in `last_statements'.
		local
			l_stmt: STRING
		do
			create l_stmt.make (32)
			l_stmt.append (smtlib_function_header)
			l_stmt.append (once "((Void Int))")
			last_statements.extend (l_stmt)
		end

	generate_current_function (a_class: CLASS_C)
			-- Generate a dummy function for the expression "Void'.
			-- Store result in `last_statements'.
		local
			l_stmt: STRING
		do
			create l_stmt.make (32)
			l_stmt.append (smtlib_function_header)
			l_stmt.append (once "((")
			l_stmt.append (solver_prefix ("", a_class))
			l_stmt.append (once "Current Int))")
			last_statements.extend (l_stmt)
		end

	generate_argument_function (a_feature: FEATURE_I; a_class: CLASS_C)
			-- Generate arguments of `a_feature' as functions,
			-- store result in `last_statement'.
		local
			i: INTEGER
			c: INTEGER
			l_type: TYPE_A
			l_name: STRING
			l_stmt: STRING
		do
			from
				i := 1
				c := a_feature.argument_count
			until
				i > c
			loop
				l_name := a_feature.arguments.item_name (i)
				l_type := a_feature.arguments.i_th (i).instantiation_in (a_class.actual_type, a_class.class_id).actual_type
				create l_stmt.make (64)
				l_stmt.append (smtlib_function_header)
				l_stmt.append (once "((")
				l_stmt.append (l_name)
				l_stmt.append_character (' ')
				l_stmt.append (solver_type (l_type))
				l_stmt.append (once "))")
				last_statements.extend (l_stmt)
				i := i + 1
			end
		end

	generate_local_function (a_feature: FEATURE_I; a_class: CLASS_C)
			-- Generate locals of `a_feature' as solver expresessions,
			-- store result in `last_statement'.
		local
			l_locals: HASH_TABLE [LOCAL_INFO, INTEGER]
			l_stmt: STRING
			l_type: TYPE_A
		do
			l_locals := expression_type_checker.local_info (a_class, a_feature)
			from
				l_locals.start
			until
				l_locals.after
			loop
				create l_stmt.make (64)
				l_stmt.append (smtlib_function_header)
				l_stmt.append (once "((")
				l_stmt.append (names_heap.item (l_locals.key_for_iteration))
				l_stmt.append_character (' ')
				l_stmt.append (solver_type (l_locals.item_for_iteration.type.instantiation_in (context_class.actual_type, context_class.class_id).actual_type))
				l_stmt.append (once "))")
				last_statements.extend (l_stmt)
				l_locals.forth
			end
		end

	generate_function (a_feature: FEATURE_I; a_class: CLASS_C)
			-- Generate the SMTLIB function for `a_feature' in `a_class'.
			-- Store result in `last_statement'. Update `needed_theory' when necessary.
		local
			l_stmt: STRING
			l_type: TYPE_A
			i: INTEGER
			l_arg_count: INTEGER
		do
			set_context_class (a_class)
			set_context_feature (a_feature)

			create l_stmt.make (64)
			l_stmt.append (smtlib_function_header)
			l_stmt.append (once "((")
			l_stmt.append (solver_prefix ("", context_class))
			l_stmt.append (context_feature.feature_name.as_lower)
			l_stmt.append_character (' ')

				-- Process routine argument types.
			from
				i := 1
				l_arg_count := a_feature.argument_count
			until
				i > l_arg_count
			loop
				l_stmt.append (solver_type (a_feature.arguments.i_th (i).instantiation_in (context_class.actual_type, context_class.class_id).actual_type))
				l_stmt.append_character (' ')
				i := i + 1
			end

				-- Process result type.
			l_stmt.append (solver_type (a_feature.type.actual_type))
			l_stmt.append (once "))")
			last_statements.extend (l_stmt)
		end


feature{NONE} -- Implementation

	solver_type (a_type: TYPE_A): STRING
			-- type used in solver from `a_type'
		do
			if a_type.is_boolean then
				Result := once "bool"
			else
				Result := once "Int"
			end
		end

	dummy_paranthesis: STRING
			-- Dummy paranthesis
		do
			Result := once ""
		end

	dummy_semicolon: STRING
			-- Dummy semicolon
		do
			Result := once ""
		end

feature -- Process

	process_binary_as (l_as: BINARY_AS)
		local
			l_opt: STRING
			l_is_not_equal: BOOLEAN
		do
			output_buffer.append_character ('(')

			l_opt := l_as.operator_ast.name
			if l_opt.is_case_insensitive_equal (once "and then") then
				l_opt := once "and"
			elseif l_opt.is_case_insensitive_equal (once "or else") then
				l_opt := once "or"
			elseif l_opt.is_equal (once "/=") then
				l_is_not_equal := True
				output_buffer.append (once "(not (")
				l_opt := once "="
			elseif l_opt.is_equal (once "~") then
				l_opt := once "="
			end

			output_buffer.append (l_opt)

			output_buffer.append (once " (")
			l_as.left.process (Current)
			output_buffer.append (") (")
			l_as.right.process (Current)
			output_buffer.append ("))")

			if l_is_not_equal then
				output_buffer.append (once "))")
			end
		end

	process_unary_as (l_as: UNARY_AS)
		do
			output_buffer.append_character ('(')
			output_buffer.append (l_as.operator_ast.name)
			output_buffer.append (once " (")
			l_as.expr.process (Current)
			output_buffer.append (once "))")
		end

end
